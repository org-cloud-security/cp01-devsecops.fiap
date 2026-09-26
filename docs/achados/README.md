# Análise dos achados

Três achados levantados pelas ferramentas do laboratório, com veredito, justificativa, CWE e correção. As evidências vêm de `lab/reports/`.

## 1. XSS refletido na rota /hello

**Ferramenta:** OWASP ZAP, regra 40012
**Risco:** High (confiança Medium)
**CWE:** [CWE-79](https://cwe.mitre.org/data/definitions/79.html), Improper Neutralization of Input During Web Page Generation
**Veredito:** verdadeiro positivo

### Justificativa

O active scan injetou `<scrIpt>alert(1);</scRipt>` no parâmetro `name` e o recebeu de volta intacto no corpo da resposta, com `Content-Type: text/html`. O campo `evidence` do relatório mostra exatamente a string refletida.

A causa está em `lab/app/index.js`: a entrada do usuário é concatenada direto na resposta, sem escape e sem definir o tipo de conteúdo.

```js
res.send("Hello, " + req.query.name);
```

Como o Express infere `text/html` quando recebe uma string, o navegador interpreta a resposta como HTML e executa o script.

Confirmação manual:

```bash
curl -si "http://localhost:3000/hello?name=<script>alert(1)</script>"
```

A resposta traz a tag intacta e o cabeçalho `Content-Type: text/html`.

### Correção

Forçar o tipo de conteúdo para texto puro, o que impede o navegador de acionar o parser HTML:

```js
res.type("text").send("Hello, " + req.query.name);
```

Após a correção o ZAP encerra com `Automation plan succeeded!` e exit code 0.

## 2. XSS baseado em DOM na rota /hello

**Ferramenta:** OWASP ZAP, regra 40026
**Risco:** High (confiança High)
**CWE:** [CWE-79](https://cwe.mitre.org/data/definitions/79.html)
**Veredito:** verdadeiro positivo, mas é o mesmo defeito do achado 1

### Justificativa

O ZAP abriu a página em um navegador headless e detectou a execução efetiva do payload `<script>alert(5397)</script>`. Por isso a confiança é High, superior à do achado 1: em vez de apenas observar o reflexo na resposta, a ferramenta observou o script rodando.

São duas regras distintas apontando para a mesma linha de código. Contam como dois alertas no relatório, mas não são dois defeitos.

### Correção

A mesma do achado 1. Uma única linha alterada elimina os dois alertas, o que foi verificado na execução após a correção.

## 3. Source Code Disclosure na rota /hello

**Ferramenta:** OWASP ZAP, regra 43
**Risco:** High (confiança Medium)
**CWE:** [CWE-541](https://cwe.mitre.org/data/definitions/541.html), Inclusion of Sensitive Information in an Include File
**Veredito:** falso positivo

### Justificativa

O ZAP alega que a rota expõe código-fonte. A aplicação inteira tem quinze linhas e uma única rota, que devolve a string `Hello, ` concatenada ao parâmetro recebido. Não há leitura de arquivo, include, template engine nem qualquer caminho pelo qual código-fonte pudesse chegar à resposta.

O campo `evidence` do alerta veio vazio, ou seja, a ferramenta não apontou qual trecho de código teria vazado. O `attack` registrado foi a string `hello`, o próprio nome da rota.

A heurística da regra procura padrões que lembrem código na resposta. Como a aplicação devolve a entrada do usuário sem tratamento, o payload refletido foi interpretado como código-fonte vazado.

O alerta desaparece junto com a correção do XSS, o que confirma o diagnóstico: o gatilho era o reflexo da entrada, não exposição real de código.

### Correção

Nenhuma correção é necessária na aplicação. O tratamento adequado seria suprimir a regra 43 para esta rota via arquivo de configuração do ZAP, após documentar a análise.

## 4. SSH liberado para a internet

**Ferramenta:** Checkov, política CKV_AZURE_10
**Risco:** o Checkov open source não atribui severidade; a classificação por severidade exige chave da plataforma Prisma Cloud
**CWE:** [CWE-284](https://cwe.mitre.org/data/definitions/284.html), Improper Access Control
**Veredito:** verdadeiro positivo

### Justificativa

O Network Security Group em `lab/iac/main.tf` libera a porta 22 com `source_address_prefix = "*"`, que no Azure representa qualquer origem. Qualquer host da internet alcançaria o SSH da máquina.

Vale registrar um comportamento observado na prática: a regra não dispara quando o valor é `0.0.0.0/0`. A política reconhece como internet apenas os valores `*` e `Internet`, de modo que uma configuração igualmente insegura escrita em notação CIDR passaria despercebida. É uma limitação real da política, relevante para quem confia apenas no resultado da ferramenta.

### Correção

Restringir a origem a uma faixa conhecida:

```hcl
source_address_prefix = "10.0.0.0/24"
```

Após a correção o Checkov reporta `Passed checks: 4, Failed checks: 0` e exit code 0.

## Resumo

| # | Ferramenta | Regra | Veredito | CWE |
| --- | --- | --- | --- | --- |
| 1 | OWASP ZAP | 40012 | verdadeiro positivo | CWE-79 |
| 2 | OWASP ZAP | 40026 | verdadeiro positivo, mesmo defeito do 1 | CWE-79 |
| 3 | OWASP ZAP | 43 | falso positivo | CWE-541 |
| 4 | Checkov | CKV_AZURE_10 | verdadeiro positivo | CWE-284 |

Quatro alertas de três regras distintas se resolvem com duas linhas de código alteradas.
