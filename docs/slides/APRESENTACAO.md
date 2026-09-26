# Roteiro de fala, slide a slide

Baseado em `Checkpoint01-DevSecOps.pptx`, 25 slides, 30 minutos. A coluna de tempo é o relógio corrido desde o início.

## Abertura, Guylherme, 0:00 a 3:00

| Slide | Tempo | O que falar |
| --- | --- | --- |
| 1. Capa | 0:00 | Apresentar o grupo e o tema. Uma frase: quatro categorias de teste automatizado, duas aplicadas ao vivo hoje. |
| 2. Agenda | 0:30 | Avisar que o laboratório é o bloco maior e que a turma vai executar junto, então já podem abrir o terminal. |
| 3. As quatro frentes | 1:00 | O ponto central: SAST olha o código que escrevemos, SCA o que importamos. Apontar a última linha: só o DAST exige a aplicação no ar. |
| 4. Posicionamento no pipeline | 2:00 | Mostrar que IaC aparece duas vezes, em Code e Deploy, porque o mesmo manifesto pode virar recurso inseguro se uma variável mudar. Passar para Semgrep. |

## Semgrep, Guylherme, 3:00 a 5:30

| Slide | Tempo | O que falar |
| --- | --- | --- |
| 5. O que é | 3:00 | SAST por correspondência de padrões sobre a árvore sintática, não sobre texto. |
| 6. Como funciona | 3:50 | Mostrar regra e código lado a lado. A regra se parece com o código que procura, por isso escrever regra própria é barato. |
| 7. Resultado | 4:40 | Os três números medidos por nós: 84 segundos, 223 regras, 2 achados. Frase de gancho: achou o XSS na linha 9 sem subir a aplicação, e isso volta no slide 22. Passar para Bruno. |

## Dependency-Check, Bruno, 5:30 a 8:00

| Slide | Tempo | O que falar |
| --- | --- | --- |
| 8. O que é | 5:30 | SCA compara as dependências declaradas contra a base pública da NVD. Projeto da OWASP, de 2012. |
| 9. Como funciona | 6:20 | Explicar o fluxo e enfatizar: a base precisa estar baixada antes. |
| 10. Limitação | 7:10 | 398.697 registros. Dizer o número medido: 34 minutos na primeira execução, 9 segundos com cache. Passar para Luiz. |

Se perguntarem: a ferramenta exige chave de API da NVD, gratuita mas com cadastro prévio. É a única das quatro que precisa de credencial.

## Checkov, Luiz, 8:00 a 10:30

| Slide | Tempo | O que falar |
| --- | --- | --- |
| 11. O que é | 8:00 | IaC Security avaliando políticas sobre um grafo de recursos. |
| 12. Como funciona | 8:50 | Mostrar o Terraform com SSH aberto e o veredito CKV_AZURE_10. Esse é o arquivo do laboratório. |
| 13. A limitação | 9:40 | O achado mais forte da nossa análise: `*` reprova, `0.0.0.0/0` aprova, mesma exposição. Falso negativo que só apareceu porque testamos as duas formas. Passar para Anderson. |

Se perguntarem: o Checkov não classifica severidade na versão gratuita, isso exige chave da Prisma Cloud. Por isso o gate por criticidade fica no ZAP.

## ZAP, Anderson, 10:30 a 13:00

| Slide | Tempo | O que falar |
| --- | --- | --- |
| 14. O que é | 10:30 | DAST black-box, ataca a aplicação em execução. Projeto de 2010. |
| 15. Como funciona | 11:20 | As três etapas. O ponto que importa: só o scan ativo acha XSS, porque detectar XSS exige injetar payload. |
| 16. Gate por severidade | 12:10 | Contraste medido: script empacotado sai com 2 mesmo com 3 alertas altos; plano de automação com `errorLevel: High` sai com 1. Só a segunda forma quebra o build. Passar para o laboratório. |

## Laboratório, Luiz e Anderson, 13:00 a 25:00

| Slide | Tempo | Quem | O que fazer |
| --- | --- | --- | --- |
| 17. Como funciona | 13:00 | Luiz | Pedir que a turma clone e entre em `lab/`. Esperar todos confirmarem antes de seguir. |
| 18. Fases 1 e 2 | 14:00 | Luiz | Rodar o Checkov ao vivo, mostrar reprovado e código 1. Trocar a linha no `iac/main.tf`. Rodar de novo, aprovado e código 0. |
| 19. Fases 3 e 4 | 19:00 | Anderson | Subir a aplicação, mostrar o XSS no navegador, rodar o ZAP, alerta alto e código 1. Trocar a linha no `app/index.js`, rebuild, rodar de novo, plano bem-sucedido e código 0. |
| 20. Perguntas de verificação | 24:00 | Anderson | Ler as duas perguntas e pedir que anotem a resposta do próprio terminal. Passar para Bruno. |

Tempos reais por execução: Checkov 20 segundos, ZAP 57 segundos. Enquanto o ZAP roda, Anderson comenta o log em vez de esperar em silêncio.

Se algo travar, abrir `docs/plano-b/lab.mp4` e narrar por cima. Não tentar depurar ao vivo.

## Conclusão, Bruno, 25:00 a 28:00

| Slide | Tempo | O que falar |
| --- | --- | --- |
| 21. Quadro comparativo | 25:00 | Percorrer a tabela. Apontar a única coluna em que o Checkov diz Não: severidade. |
| 22. A convergência | 25:45 | O resultado principal do trabalho. Semgrep e ZAP acharam o mesmo CWE-79 por caminhos independentes. As categorias não competem, são camadas com custos diferentes. |
| 23. Limitações | 26:30 | Os quatro achados nossos, não de documentação. Falar rápido, um por item. |
| 24. Recomendação | 27:15 | Fechar com a regra que decorre das medições: o gate por criticidade precisa ficar em ferramenta que atribui severidade real. |

## Perguntas, todos, 28:00 a 30:00

| Slide | Tempo | O que falar |
| --- | --- | --- |
| 25. Encerramento | 28:00 | Deixar o link do repositório na tela. Cada pergunta vai para o dono da ferramenta. |

## Divisão final do tempo

| Quem | Blocos | Total |
| --- | --- | --- |
| Luiz | Checkov 2,5 + laboratório 6 | 8,5 min |
| Anderson | ZAP 2,5 + laboratório 6 | 8,5 min |
| Guylherme | abertura 3 + Semgrep 2,5 | 5,5 min |
| Bruno | Dependency-Check 2,5 + conclusão 3 | 5,5 min |

## Perguntas prováveis e quem responde

| Pergunta | Quem |
| --- | --- |
| Por que não usaram o `zap-baseline`? | Anderson: baseline é só passivo, e XSS exige injeção de payload. |
| Por que o Checkov não quebra o build por severidade alta? | Luiz: a versão gratuita não classifica severidade, exige chave da Prisma Cloud. |
| O Dependency-Check achou alguma vulnerabilidade? | Bruno: não, e isso é correto. Duas dependências recentes, sem CVE. O valor do SCA cresce com o tamanho da árvore de dependências. |
| Qual a taxa de falso positivo de vocês? | Quem for da ferramenta. Está documentada por ferramenta em `docs/achados/`. |
| Dá para rodar tudo isso em pre-commit? | Guylherme: Semgrep e Checkov sim; Dependency-Check é lento demais e o ZAP exige a aplicação no ar. |
