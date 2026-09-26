# ZAP (Zed Attack Proxy)

Categoria: **DAST** (Dynamic Application Security Testing)

Alvo usado nos testes: OWASP Juice Shop `v20.2.0` (`app/juice-shop`), rodando local via Docker. Relatórios em `reports/zap/`.

## a. Identificação

| Item | Valor |
|---|---|
| Nome | ZAP (Zed Attack Proxy), antes conhecido como "OWASP ZAP" |
| Criador | Simon Bennetts, que anunciou a versão 1.0.0 em 06/09/2010 [1] |
| Origem | fork da versão 3.2.13 do Paros Proxy, da Chinotec Technologies [1] |
| Linguagem | Java [5] |
| Licença | Apache 2.0 [3][5] |
| Mantenedor | ZAP Core Team. O projeto saiu da OWASP em setembro de 2023 e entrou no Software Security Project [2][4]. Desde 24/09/2024 é "ZAP by Checkmarx": a Checkmarx emprega 3 membros do Core Team, e o projeto segue open source, sob Apache 2.0 e controlado pelo Core Team [3] |

**Atividade do projeto** (repositório `zaproxy/zaproxy`, consultado via GitHub API em 26/09/2026) [5]:

- 378 commits nos últimos 12 meses
- 239 contribuidores
- 15.832 stars e 2.649 forks
- última release estável: 2.17.0 (15/12/2025), com releases semanais (a mais recente, `w2026-09-23`)

O repositório no GitHub foi criado em 2015 por migração, e o projeto em si é de 2010.

## b. Fundamento técnico

O ZAP é um scanner **black-box**: testa a aplicação em execução pelo lado de fora, sem acesso ao código-fonte. Ele trabalha como um proxy, que fica entre o cliente e a aplicação e registra as requisições e respostas.

Etapas principais:

1. **Spider**: navega pela aplicação para descobrir URLs. Além do spider tradicional, há um spider moderno para aplicações com muito JavaScript (Ajax Spider ou Client Spider) [6]
2. **Regras passivas**: analisam as respostas sem modificar nenhuma requisição. Não fazem ataques [6]
3. **Regras ativas**: reenviam as requisições trocando os parâmetros por payloads de ataque e analisam as respostas. Fazem ataques reais e podem demorar bastante [7]

**O que detecta**: falhas visíveis no comportamento da aplicação em execução, como SQL injection, XSS, headers de segurança ausentes, CORS permissivo e vazamento de informação em respostas.

**O que não detecta**:

- a linha de código com o defeito, porque não vê o código (isso é papel do SAST)
- rotas que o spider não descobre. No nosso baseline, nenhum dos 18 URLs com alerta era da API `/rest/`, que o Juice Shop chama pelo JavaScript
- páginas atrás de login, se a autenticação não for configurada no scan
- falhas de lógica de negócio
- dependências vulneráveis que não se manifestam nas respostas (isso é papel do SCA)

## c. Instalação e uso

**Instalação.** Usamos as imagens Docker oficiais, disponíveis no Docker Hub e no GHCR [8]:

| Imagem | Uso |
|---|---|
| `zaproxy/zap-stable` | atualizada a cada release completa, é a que usamos (`2.17.0`) |
| `zaproxy/zap-weekly` | atualizada toda semana |
| `zaproxy/zap-nightly` | atualizada diariamente |
| `zaproxy/zap-bare` | imagem mínima, voltada a CI |

**Modos de scan usados**:

| Modo | Comando | O que faz |
|---|---|---|
| Baseline | `zap-baseline.py -t <url>` | spider por 1 min (padrão) e regras passivas, sem ataques [6] |
| Full scan | `zap-full-scan.py -t <url>` | spider sem limite de tempo e scan ativo completo [7] |
| Quick scan | `zap.sh -cmd -quickurl <url> -quickout <arquivo>` | ataca a URL informada e grava o relatório [9] |

**Flags do baseline mais relevantes** [6]: `-t` (alvo), `-m` (minutos de spider), `-r` / `-w` / `-x` / `-J` (relatório em HTML, Markdown, XML e JSON), `-c` (arquivo de regras), `-g` (gera arquivo de regras padrão), `-I` (não retorna falha em WARN), `-j` (usa o spider moderno), `-z` (opções extras do ZAP).

No `-quickout`, o formato depende da extensão: `.html`, `.json`, `.md` ou `.xml` [9].

**Exit codes** (baseline e full scan) [6][7]: `0` sucesso, `1` pelo menos um FAIL, `2` pelo menos um WARN e nenhum FAIL, `3` outra falha.

**Supressão de falso positivo.** O arquivo de regras (`-c`) define, por ID de regra, se o alerta vira `WARN`, `IGNORE` ou `FAIL`. Também dá para ignorar uma regra só em certos URLs, com `<id> OUTOFSCOPE <regex>` [6]. Exemplo (não testado) para o falso positivo que encontramos, descrito na seção de achados:

```
10096	OUTOFSCOPE	http://app:3000/styles.css
```

**Comandos que usamos** (os relatórios estão em `reports/zap/`):

```bash
docker network create zap-lab
docker run -d --name app --network zap-lab -p 127.0.0.1:3000:3000 bkimminich/juice-shop:v20.2.0

# baseline
docker run --rm --network zap-lab -v "$PWD/reports/zap":/zap/wrk:rw zaproxy/zap-stable:2.17.0 \
  zap-baseline.py -t http://app:3000 -r baseline.html -J baseline.json

# ativo direcionado ao endpoint de busca
docker run --rm --memory 3g --network zap-lab -v "$PWD/reports/zap":/zap/wrk:rw zaproxy/zap-stable:2.17.0 \
  zap.sh -cmd -quickurl "http://app:3000/rest/products/search?q=apple" -quickout /zap/wrk/active.json \
  -config scanner.maxScanDurationInMins=4
```

## d. Integração

**CI/CD.** O projeto mantém GitHub Actions oficiais, todas ativas em 2026 [10][11]:

- `zaproxy/action-baseline`, `zaproxy/action-full-scan` e `zaproxy/action-api-scan`: rodam os scans empacotados. No `action-baseline`, o input `fail_action` tem padrão `false`, ou seja, **a action não quebra o workflow por padrão** mesmo com alertas. Também por padrão (`allow_issue_writing: true`), ela abre uma issue no repositório com os achados [10]
- `zaproxy/action-af`: roda um plano do Automation Framework [11]. O job `exitStatus` do plano define o exit code a partir do risco dos alertas (`errorLevel`, `warnLevel`), por exemplo, sair com `1` quando houver alerta High [12]

**SARIF.** O ZAP gera SARIF pelo template de relatório `sarif-json` [13], formato que pode ser enviado ao GitHub Code Scanning.

**DefectDojo.** O parser "ZAP Scan" do DefectDojo lê o relatório em **XML** (usa `ElementTree`) [14]. Os nossos relatórios estão em HTML e JSON, então para importar seria preciso gerar também com `-x`.

**IDE e pre-commit.** Não encontramos plugin oficial de IDE na documentação. Pre-commit não se aplica: o ZAP precisa da aplicação em execução, e o código ainda nem foi commitado nessa etapa.

## e. Avaliação crítica

**Tempos medidos** (Mac arm64, Docker 28, alvo local):

| Etapa | Tempo |
|---|---|
| Pull das imagens (518 MB + 3,6 GB) | cerca de 1 min |
| Juice Shop pronto para responder | 7 s |
| Baseline (2 execuções) | 52 s e 53 s |
| Quick scan ativo no endpoint de busca (3 execuções cronometradas) | 41 s, 42 s e 49 s |
| Full scan no app inteiro | interrompido após 7 min, sem resultado |

**Resultados**:

- Baseline: 8 regras com alerta, 0 FAIL, maior risco **Medium**. Nunca chega a High, porque não ataca
- Quick scan ativo: 5 alertas, maior risco **High** (SQL Injection)

**Taxa de falso positivo observada.** Dos 4 alertas do scan ativo com risco Low ou maior, 1 é falso positivo (Timestamp Disclosure): **25%**. O quinto alerta (Modern Web Application) é informativo, não uma vulnerabilidade.

**Limitações encontradas na prática**:

- **Full scan travou.** Apontado para o Juice Shop inteiro, ficou 7 minutos usando 6,2 GB de memória e 224% de CPU, enquanto o app estava parado (0,3% de CPU), ou seja, sem receber requisições. Precisou ser interrompido. Para uma SPA como o Juice Shop, foi mais eficaz apontar o scan ativo direto para um endpoint conhecido
- **Spider não alcança a API.** O baseline não gerou alerta em nenhuma rota `/rest/`. O SQL injection só apareceu quando informamos a URL da busca manualmente
- **Confiança subestimada.** O ZAP marcou o SQL Injection com confiança "Low", mas confirmamos manualmente que é verdadeiro. A confiança não deve ser usada sozinha para descartar alerta
- **O quick scan termina com exit 0 mesmo achando High.** Sozinho, ele não serve de gate. No pipeline, o gate precisa vir do job `exitStatus` do Automation Framework ou de `fail_action`
- **CWE genérico.** O alerta Cross-Domain Misconfiguration vem com CWE-264, uma categoria ampla. Para CORS com `Access-Control-Allow-Origin: *`, o CWE-942 (Permissive Cross-domain Policy with Untrusted Domains) é mais específico
- **Imagem pesada.** A imagem `zap-stable` tem 3,6 GB, o que exige baixar antes da aula

**Cenário ideal.** Aplicações web em ambiente de teste, no estágio Test do pipeline: o baseline como verificação rápida e não agressiva em todo PR, e o scan ativo direcionado aos endpoints críticos quando o objetivo é quebrar o build em High.

**Por que escolher.** É open source, ativo, com imagens Docker e actions oficiais prontas para CI, e encontra falhas que as ferramentas estáticas não veem, porque testa o comportamento real da aplicação.

## Análise dos 3 achados

| # | Achado | Risco ZAP | CWE | Veredito |
|---|---|---|---|---|
| 1 | SQL Injection | High | CWE-89 | Verdadeiro positivo |
| 2 | Content Security Policy (CSP) Header Not Set | Medium | CWE-693 | Verdadeiro positivo |
| 3 | Timestamp Disclosure - Unix | Low | CWE-497 | Falso positivo |

### 1. SQL Injection (verdadeiro positivo)

- **Onde:** `GET /rest/products/search?q=`, parâmetro `q`
- **Evidência:** com `?q=apple` a resposta é `200`. Com o payload do ZAP, `?q=apple'`, o app devolve `SQLITE_ERROR: near "'%'": syntax error`. A aspa quebrou a sintaxe da query, então o valor enviado vai direto para dentro do SQL. O erro ainda expõe o banco usado (SQLite)
- **Causa no código:** `app/juice-shop/routes/search.ts:23` monta a query por interpolação de string:
  ```ts
  models.sequelize.query(`SELECT * FROM Products WHERE ((name LIKE '%${criteria}%' OR description LIKE '%${criteria}%') AND deletedAt IS NULL) ORDER BY name`)
  ```
- **Correção proposta:** usar query parametrizada, como recomenda o próprio alerta [15]. O Juice Shop usa Sequelize `^6.37.3`, que oferece bind parameters: o valor é enviado ao banco fora do texto da query, então nunca é interpretado como SQL [17]:
  ```ts
  models.sequelize.query(
    'SELECT * FROM Products WHERE ((name LIKE $criteria OR description LIKE $criteria) AND deletedAt IS NULL) ORDER BY name',
    { bind: { criteria: `%${criteria}%` } }
  )
  ```
  A alternativa `replacements` do Sequelize também evita a injeção, mas por escape do valor dentro da query, e não por separação [17]. Além disso, o app não deveria devolver a mensagem de erro do banco para o cliente.

### 2. CSP Header Not Set (verdadeiro positivo)

- **Onde:** 5 URLs, incluindo a página inicial `/`
- **Evidência:** a resposta de `/` não traz o header `Content-Security-Policy` (conferido com `curl -I`)
- **Por que importa:** sem CSP, o navegador não tem uma política que limite de onde scripts podem ser carregados, o que facilita a exploração de XSS
- **Correção proposta:** enviar o header `Content-Security-Policy` com uma política restritiva, por exemplo `default-src 'self'`, ajustada aos recursos que a aplicação realmente carrega

### 3. Timestamp Disclosure - Unix (falso positivo)

- **Onde:** `/styles.css`
- **Evidência:** os "timestamps" apontados (`1528301887`, `1578947368`, `1602209945`) são casas decimais de cores em variáveis CSS, por exemplo `--theme-warn-darker: rgb(159.1528301887, ...)`. A regra procura números grandes que possam ser convertidos em data [16], e esses valores só coincidem com o formato
- **Correção proposta:** nenhuma no app. Suprimir no arquivo de regras do ZAP para esse URL, com `10096 OUTOFSCOPE http://app:3000/styles.css`, que mantém a regra ativa no resto da aplicação

## Referências

1. ZAP. *ZAP is Ten Years Old*. https://www.zaproxy.org/blog/2020-09-06-zap-is-ten-years-old/
2. ZAP. *ZAP Ownership*. https://www.zaproxy.org/docs/zap-ownership/
3. ZAP. *ZAP Has Joined Forces With Checkmarx*. https://www.zaproxy.org/blog/2024-09-24-zap-has-joined-forces-with-checkmarx/
4. ZAP. *ZAP is Joining the Software Security Project*. https://www.zaproxy.org/blog/2023-08-01-zap-is-joining-the-software-security-project/
5. GitHub. *zaproxy/zaproxy*. https://github.com/zaproxy/zaproxy
6. ZAP. *ZAP Baseline Scan*. https://www.zaproxy.org/docs/docker/baseline-scan/
7. ZAP. *ZAP Full Scan*. https://www.zaproxy.org/docs/docker/full-scan/
8. ZAP. *Docker User Guide*. https://www.zaproxy.org/docs/docker/about/
9. ZAP. *Quick Start: Command Line*. https://www.zaproxy.org/docs/desktop/addons/quick-start/cmdline/
10. GitHub. *zaproxy/action-baseline*. https://github.com/zaproxy/action-baseline
11. GitHub. *zaproxy/action-af*. https://github.com/zaproxy/action-af
12. ZAP. *Automation Framework: exitStatus Job*. https://www.zaproxy.org/docs/desktop/addons/automation-framework/job-exitstatus/
13. ZAP. *Report Generation: Templates*. https://www.zaproxy.org/docs/desktop/addons/report-generation/templates/
14. DefectDojo. *ZAP parser* (`dojo/tools/zap/parser.py`). https://github.com/DefectDojo/django-DefectDojo/blob/master/dojo/tools/zap/parser.py
15. ZAP. *SQL Injection (alerta 40018)*. https://www.zaproxy.org/docs/alerts/40018/
16. ZAP. *Timestamp Disclosure (alerta 10096)*. https://www.zaproxy.org/docs/alerts/10096/
17. Sequelize. *Raw Queries* (v6). https://sequelize.org/docs/v6/core-concepts/raw-queries/
