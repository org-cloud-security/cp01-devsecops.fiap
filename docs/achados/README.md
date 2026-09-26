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

A mesma do achado 1. Uma única linha alterada elimina os dois alertas de risco High, o que foi verificado na execução após a correção.

## 3. Missing Anti-clickjacking Header

**Ferramenta:** OWASP ZAP, regra 10020
**Risco:** Medium (confiança Medium)
**CWE:** [CWE-1021](https://cwe.mitre.org/data/definitions/1021.html), Improper Restriction of Rendered UI Layers or Frames
**Veredito:** falso positivo neste contexto

### Justificativa

O ZAP aponta a ausência dos cabeçalhos `X-Frame-Options` e `Content-Security-Policy: frame-ancestors`, que impedem a página de ser carregada dentro de um iframe de terceiros. A verificação em si está correta: os cabeçalhos realmente não existem, o que se confirma com

```bash
curl -si http://localhost:3000/ | grep -i "x-frame\|content-security"
```

O comando não retorna nada.

O que torna o alerta um falso positivo é o critério de impacto. Clickjacking depende de induzir a vítima a clicar em um elemento sobreposto para executar uma ação com efeito colateral. A aplicação do laboratório tem duas rotas, ambas GET, nenhuma com formulário, botão, sessão ou qualquer ação com estado. Não existe ação que um atacante pudesse induzir por sobreposição.

A regra é puramente passiva: verifica a presença do cabeçalho sem avaliar se a página tem algo a proteger. O alerta é tecnicamente verdadeiro e praticamente irrelevante, que é a assinatura de um falso positivo por falta de contexto.

Em uma aplicação real com autenticação e formulários, o mesmo alerta seria verdadeiro positivo. É o contexto que muda o veredito, não a evidência.

Observação sobre reprodutibilidade: em execuções consecutivas do mesmo plano, sem qualquer alteração no código, este alerta apareceu em algumas e não em outras. O spider percorre a aplicação a cada execução e nem sempre alcança as mesmas URLs, de modo que alertas passivos podem variar entre scans. Os dois alertas de XSS, levantados pelo active scan, se mantiveram estáveis em todas as execuções.

### Correção

Nenhuma correção é necessária nesta aplicação. Em um cenário real, a proteção viria do `helmet`, que define `X-Frame-Options: SAMEORIGIN` por padrão:

```js
const helmet = require("helmet");
app.use(helmet());
```

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
| 3 | OWASP ZAP | 10020 | falso positivo neste contexto | CWE-1021 |
| 4 | Checkov | CKV_AZURE_10 | verdadeiro positivo | CWE-284 |

Quatro alertas de três regras distintas se resolvem com duas linhas de código alteradas.
