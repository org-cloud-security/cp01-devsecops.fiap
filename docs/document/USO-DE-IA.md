# Declaração de uso de inteligência artificial

Anexo exigido pelas regras de conduta acadêmica do Check Point 01.

## Ferramenta utilizada

Claude (Anthropic), modelo Opus, acessado pela interface Claude Code, em sessões conduzidas por Luiz Brito entre 25 e 28 de setembro de 2026.

## O que foi gerado com auxílio de IA

| Artefato | Natureza do auxílio |
| --- | --- |
| `LAB.md` | Redação do roteiro a partir dos comandos definidos pelo grupo |
| `docs/document/README.md` | Redação do documento de pesquisa a partir das medições do grupo |
| `docs/achados/README.md` | Redação da análise dos achados |
| `lab/docker-compose.yml`, `lab/zap.yaml` | Escrita dos arquivos de configuração |
| `lab/app/index.js`, `lab/iac/main.tf` | Escrita das amostras vulneráveis do laboratório |
| `.github/workflows/lab.yml` | Escrita do workflow |
| `docs/arch.gif` | Geração do diagrama de arquitetura |
| Mensagens de commit | Redação |

## O que não foi gerado com auxílio de IA

As decisões técnicas do trabalho foram tomadas pelo grupo: a escolha das duas ferramentas do laboratório, a escolha das vulnerabilidades a demonstrar, a decisão de usar o Automation Framework do ZAP em vez dos scripts empacotados, e a recusa de soluções que o grupo considerou inadequadas, como fixar permissão `777` no workflow e reclassificar manualmente regras do ZAP para forçar o gate.

## Como as informações foram validadas

Esta seção atende à exigência de que afirmação técnica sem evidência não conta.

**Execução das ferramentas.** Todos os números do documento vêm de execuções feitas pelo grupo, não de documentação. Os relatórios estão versionados em `lab/reports/`. Isso inclui os tempos de execução, as contagens de regras e achados, e os códigos de saída.

**Verificação de afirmações contra a documentação oficial.** As flags, os formatos de saída e os códigos de saída descritos no documento foram conferidos nas páginas oficiais de cada ferramenta, citadas nas referências.

**Correções aplicadas após verificação.** Três afirmações incorretas foram identificadas e corrigidas antes da entrega:

1. Um achado do ZAP (`43 Source Code Disclosure`) havia sido descrito na análise dos achados, mas não reproduzia no plano de automação adotado, pois vinha do `zap-full-scan.py` usado em uma versão anterior do laboratório. Foi substituído por um alerta efetivamente presente na execução atual.
2. O repositório do OWASP Dependency-Check havia sido identificado como `jeremylong/DependencyCheck`. A verificação pela API do GitHub mostrou tratar-se de um fork criado em 2025, com 55 estrelas. O repositório oficial é `dependency-check/DependencyCheck`, de 2012.
3. A integração com o DefectDojo foi verificada lendo o código dos parsers no repositório do projeto, o que revelou que os parsers de ZAP e Dependency-Check consomem XML, e não JSON.

**Verificação das fontes.** As 26 referências do documento tiveram seus endereços testados por requisição HTTP, e todas retornaram código 200. Uma fonte originalmente prevista foi descartada por retornar 404.

**Limitações registradas em vez de omitidas.** Quando uma ferramenta não produziu o resultado esperado, o documento registra a limitação em vez de apresentar um resultado favorável. É o caso da ausência de severidade no Checkov open source, do falso negativo da política `CKV_AZURE_10` com notação CIDR, e da variação de alertas passivos do ZAP entre execuções idênticas.
