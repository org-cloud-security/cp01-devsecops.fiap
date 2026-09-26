# Tarefas — Grupo 1

## Divisão

| Membro | Ferramenta | Pastas | Extras |
| --- | --- | --- | --- |
| Luiz (TL) | Checkov | `iac/`, `.github/workflows/`, `docker-compose.yml`, `LAB.md` | `.tf` e Dockerfile inseguros, pipeline com gate |
| Guylherme | OWASP ZAP | `app/` | App vulnerável, análise dos 3 achados |
| Bruno (relator) | Dependency-Check | `docs/document/`, `USO-DE-IA.md` | Seção f, ABNT, fontes |
| Anderson | Semgrep | `docs/slides/` | Slides, vídeo do plano B, 2 perguntas de verificação |

Cada membro também é dono de:

- `docs/research/<ferramenta>.md`: roteiro a–e da sua ferramenta
- `reports/<ferramenta>/`: relatório versionado da sua ferramenta

Todos: apresentar a sua parte, revisar PRs, testar o lab em máquina alheia e executar os labs dos grupos 2 e 3.

## Branches

- `study/luiz`, `study/anderson`, `study/bruno`, `study/guylherme`: estudo pessoal das 4 ferramentas, criadas a partir da `main`. Nunca abrem PR para a `main`. Para atualizar: `git rebase main`.
- `feat/*`, `docs/*`, `ci/*`: entregas. Cada PR só toca as pastas do dono, então não há conflito.

## Ordem

1. Guylherme (`app/`) e Luiz (`iac/`) entregam primeiro: o restante depende disso.
2. Em paralelo, todos estudam na `study/*` e escrevem os itens a–d da sua ferramenta.
3. Com `app/` e `iac/` na `main`, cada um roda sua ferramenta, versiona o relatório e escreve o item e.
4. Por fim: documento, slides e teste do lab em máquina alheia.
