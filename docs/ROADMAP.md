# Roadmap — Grupo 1

Ferramentas: Semgrep (SAST) · OWASP Dependency-Check (SCA) · Checkov (IaC) · OWASP ZAP (DAST)

## 1. Setup

- [x] Eleger líder técnico e relator
- [x] Escolher as 2 ferramentas do lab (categorias diferentes)
- [ ] Escolher o alvo vulnerável e conferir se gera achados
- [ ] Criar o repositório com README
- [ ] Criar o esqueleto do `docker-compose.yml`

## 2. Execução das 4 ferramentas

- [ ] Rodar Semgrep e versionar o relatório
- [ ] Rodar Dependency-Check e versionar o relatório
- [ ] Rodar Checkov e versionar o relatório
- [ ] Rodar ZAP e versionar o relatório
- [ ] Registrar o tempo de execução e os falsos positivos de cada uma

## 3. Laboratório

- [ ] `LAB.md`: pré-requisitos, passos numerados, comandos copiáveis, resultado esperado
- [ ] Ambiente reproduzível via Docker
- [ ] Pipeline (GitHub Actions) quebrando em HIGH/CRITICAL, com build vermelho e verde
- [ ] Análise de 3 achados: verdadeiro/falso positivo, justificativa, CWE, correção
- [ ] 2 perguntas de verificação para a turma
- [ ] Plano B: vídeo de 5 a 8 min
- [ ] Testar em máquina alheia, em até 12 min
- [ ] Publicar o repositório 24h antes

## 4. Documento

- [ ] Roteiro a–e para cada ferramenta: identificação, fundamento, instalação, integração, avaliação crítica
- [ ] Seção f: SAST vs SCA, pipeline, shift-left, SBOM, quadro comparativo
- [ ] 15 a 25 páginas, ABNT, fonte 11/12, espaçamento 1,5
- [ ] Mínimo de 10 fontes, 4 delas primárias
- [ ] `USO-DE-IA.md`

## 5. Apresentação

- [ ] 20 a 30 slides (`.pptx` + `.pdf`)
- [ ] Abertura (3 min) · ferramentas (10 min) · lab (12 min) · comparativo (3 min) · perguntas (2 min)
- [ ] Ensaio cronometrado, com todos apresentando

## 6. Pós-apresentação

- [ ] Executar os labs dos grupos 2 e 3 e entregar o comprovante
