# Roteiro da apresentação

30 minutos, 4 apresentadores, 25 slides. Desconto de 2 pontos por minuto excedido.

## O que a apresentação precisa ter

Exigências do enunciado, todas mapeadas nos slides abaixo.

| Exigência | Onde |
| --- | --- |
| Capa | slide 1 |
| Agenda | slide 2 |
| Fundamentação | slides 3 e 4 |
| Demo | slides 17 a 20 |
| Quadro comparativo | slide 21 |
| Limitações | slide 23 |
| 20 a 30 slides | 25 slides |
| Máximo 30 minutos | 30 min exatos |
| Entrega em `.pptx` **e** `.pdf` | D-1 |

Rubrica da apresentação, 20 pontos: clareza e domínio 8, slides 4, tempo 4, participação equilibrada 4.

## Divisão do tempo

| Bloco | Tempo | Quem | Slides |
| --- | --- | --- | --- |
| Abertura e posicionamento no pipeline | 3 min | Guylherme | 1 a 4 |
| As 4 ferramentas | 10 min | cada um a sua | 5 a 16 |
| Laboratório guiado | 12 min | Luiz e Anderson | 17 a 20 |
| Comparativo, limitações e conclusão | 3 min | Bruno | 21 a 24 |
| Perguntas | 2 min | todos | 25 |

### Participação por pessoa

A rubrica avalia participação equilibrada. Esta é a distribuição resultante:

| Quem | Blocos | Total |
| --- | --- | --- |
| Luiz | Checkov 2,5 + lab fases 1 e 2, 6 | 8,5 min |
| Anderson | ZAP 2,5 + lab fases 3 e 4, 6 | 8,5 min |
| Guylherme | abertura 3 + Semgrep 2,5 | 5,5 min |
| Bruno | Dependency-Check 2,5 + conclusão 3 | 5,5 min |

Luiz e Anderson ficam com mais tempo porque conduzem o laboratório das ferramentas que são suas. A abertura foi atribuída a Guylherme justamente para compensar, já que ele não conduz laboratório.

## Mapa de slides

### Abertura, Guylherme, 3 min

| # | Conteúdo |
| --- | --- |
| 1 | Capa: título, integrantes com RM, disciplina |
| 2 | Agenda |
| 3 | As quatro frentes: o que cada uma analisa, estágio, se exige app no ar |
| 4 | Diagrama do laboratório (`docs/arch.gif`) |

Mensagem do bloco: as quatro categorias não competem, cobrem artefatos diferentes. SAST olha o código que escrevemos, SCA o que importamos.

### As 4 ferramentas, 2,5 min cada

Cada apresentador cobre: o que é, como funciona, o que detecta, o que **não** detecta.

| # | Ferramenta | Quem | Ponto que não pode faltar |
| --- | --- | --- | --- |
| 5 a 7 | Semgrep (SAST) | Guylherme | Achou o XSS por AST, na linha 9, em 84 s, sem subir a aplicação |
| 8 a 10 | Dependency-Check (SCA) | Bruno | Depende da base da NVD, que exige chave e download demorado |
| 11 a 13 | Checkov (IaC) | Luiz | Não classifica severidade na versão gratuita |
| 14 a 16 | OWASP ZAP (DAST) | Anderson | Único que exige a aplicação no ar, e o único com gate por severidade |

### Laboratório guiado, 12 min

| # | Conteúdo | Quem |
| --- | --- | --- |
| 17 | Pré-requisitos e comando de clone, turma acompanha | Luiz |
| 18 | Fases 1 e 2: Checkov reprova, corrige uma linha, Checkov passa | Luiz |
| 19 | Fases 3 e 4: ZAP acha XSS High, corrige uma linha, ZAP passa | Anderson |
| 20 | Perguntas de verificação | Anderson |

Tempo real medido: Checkov 20 s, ZAP 57 s por execução. Duas execuções de cada, mais a edição dos arquivos, cabem em 12 min com folga.

Se algo falhar: `docs/plano-b/lab.mp4`.

### Comparativo e conclusão, Bruno, 3 min

| # | Conteúdo |
| --- | --- |
| 21 | Quadro comparativo das 4 ferramentas |
| 22 | Semgrep e ZAP acharam o mesmo CWE-79 por caminhos independentes |
| 23 | Limitações que encontramos na prática |
| 24 | Recomendação de toolchain por estágio do pipeline |

### Perguntas, 2 min

| # | Conteúdo |
| --- | --- |
| 25 | Contato e link do repositório |

## Os quatro achados que sustentam a apresentação

Todos medidos pelo grupo, nenhum vem de documentação.

1. Semgrep e ZAP encontraram o mesmo CWE-79 por caminhos independentes, um lendo código parado, o outro atacando a aplicação no ar.
2. O Checkov aprova `0.0.0.0/0` e reprova `*` para a mesma exposição de SSH. Falso negativo real.
3. O código de saída dos scripts empacotados do ZAP não reflete severidade: 3 alertas High e ainda assim exit 2. Resolvido com o job `exitStatus` do Automation Framework, que também baixou o tempo de 142 s para 57 s.
4. Alertas passivos do ZAP não são determinísticos entre execuções idênticas. Gate sobre alerta passivo é instável.

## Perguntas de verificação para a turma

1. Qual o identificador do check que o Checkov reprovou, e quantos checks passaram depois da correção?
2. Quantos alertas de risco High o ZAP levantou antes da correção, e qual o CWE do XSS refletido?

## Cronograma e descontos

| Marco | Entrega |
| --- | --- |
| D-10 | Sumário aprovado e escolha das 2 ferramentas do lab |
| D-2 | Repositório publicado com o LAB.md acessível à turma |
| D-1 | PDF do documento, `.pptx` e link do repositório |
| D-0 | Apresentação, 30 minutos |

Descontos: 2 pontos por minuto excedido, 5 pontos por dia de atraso na entrega, 10 pontos se o repositório não sair com 24 horas de antecedência.

## Checklist antes de apresentar

- [ ] Ensaio cronometrado, em máquina que não seja a de quem montou o lab
- [ ] Repositório publicado 24h antes, com o LAB.md acessível
- [ ] Imagens Docker baixadas em todas as máquinas dos apresentadores
- [ ] `.pptx` e `.pdf` entregues
- [ ] Cada integrante sabe responder sobre qualquer parte do trabalho, não só a sua
