# Prompt para geração dos slides

Prompt para uso no Claude Design. O roteiro com a divisão de tempo está em `ROTEIRO.md`.

---

Crie uma apresentação de 25 slides sobre ferramentas open source de segurança em pipeline DevSecOps. É um trabalho acadêmico de graduação em Cloud Computing, apresentado por 4 pessoas em 30 minutos.

## Direção visual

Fundo branco. Azul como única cor de destaque, em três tons: um azul escuro para títulos, um azul médio para elementos de apoio e um azul claro para preenchimentos e áreas. Cinza para texto secundário. Nada de gradiente, sombra, brilho ou ícone decorativo.

Tipografia Poppins em toda a apresentação. Escala de tamanhos em múltiplos de 8: 56 para título de capa, 40 para título de slide, 24 para texto de apoio, 16 para legenda e rodapé. Peso 600 para títulos, 400 para corpo.

Grade de 8 pontos para todo espaçamento e alinhamento. Margem generosa, pelo menos 64 de respiro nas bordas. Alinhamento à esquerda, exceto na capa.

## Ícones das ferramentas

Cada ferramenta deve aparecer com o seu logo oficial, não com ícone genérico de segurança. O logo entra no slide de abertura da ferramenta, no quadro comparativo e no diagrama do pipeline.

| Ferramenta | Logo | Onde obter o SVG |
| --- | --- | --- |
| Semgrep | marca própria, em verde | https://semgrep.dev |
| OWASP Dependency-Check | logo da OWASP | https://owasp.org |
| Checkov | marca da Bridgecrew, em laranja | https://www.checkov.io |
| OWASP ZAP | logo do ZAP, o alvo com a flecha | https://www.zaproxy.org |

Se o logo colorido brigar com a paleta azul do slide, use a versão monocromática da marca em cinza escuro. Nunca recrie o logo à mão nem substitua por ícone genérico de cadeado, escudo ou lupa.

Os logos devem ter o mesmo tamanho óptico entre si e ficar alinhados à mesma linha de base quando aparecerem lado a lado.

## Regras de conteúdo

Máximo 5 linhas de texto por slide. Cada slide comunica **uma** ideia. Quando houver dado numérico, ele é o elemento visual dominante do slide, em tamanho grande, com a explicação em legenda pequena abaixo.

Prefira diagrama, tabela enxuta ou número grande a lista de tópicos. Evite bullet point sempre que houver alternativa visual.

## O que não fazer

Nada de emoji, seta decorativa, gradiente, ícone genérico de cadeado ou escudo, foto de banco de imagens, fundo com textura, caixa com sombra. Nada de frase de efeito genérica do tipo "segurança é responsabilidade de todos". Nada de travessão no texto.

O resultado deve parecer feito por alguém com formação em design editorial, não por um gerador automático.

## Estrutura dos 25 slides

**1. Capa.** Título "Ferramentas open source de SAST, SCA, IaC Security e DAST no pipeline". Subtítulo "Check Point 01". Quatro nomes com RM: Anderson Huang 565920, Bruno Henrique 566277, Guylherme Miguel 562374, Luiz Brito 562192. Disciplina Cloud Security: Automation e DevSecOps, FIAP, 2026.

**2. Agenda.** Cinco blocos com tempo: abertura 3 min, as quatro ferramentas 10 min, laboratório ao vivo 12 min, comparativo e conclusão 3 min, perguntas 2 min.

**3. As quatro frentes.** Tabela de quatro colunas comparando SAST, SCA, IaC Security e DAST em três linhas: o que analisa, estágio do pipeline, se exige a aplicação em execução. Destaque visual no único "Sim" da última linha, que é o do DAST.

**4. Posicionamento no pipeline.** Linha horizontal com os estágios Code, Build, Test e Deploy. Abaixo, barras indicando onde cada categoria atua. IaC aparece em dois pontos, Code e Deploy.

**5. Semgrep: o que é.** SAST. Análise estática por correspondência de padrões sobre a árvore sintática. Licença LGPL-2.1, escrito em OCaml.

**6. Semgrep: como funciona.** Mostrar lado a lado um trecho de regra YAML e o código que ela encontra. A ideia central: a regra se parece com o código que procura.

**7. Semgrep: resultado.** Números grandes: 84 segundos, 223 regras, 2 achados. Legenda: encontrou XSS na linha 9 sem subir a aplicação.

**8. Dependency-Check: o que é.** SCA. Compara as dependências declaradas contra a base pública de vulnerabilidades da NVD. Licença Apache-2.0, escrito em Java, projeto de 2012.

**9. Dependency-Check: como funciona.** Diagrama simples: package-lock.json, seta para a base NVD, seta para o relatório. Enfatizar que a base precisa ser baixada antes.

**10. Dependency-Check: limitação.** Número grande: 398.697 registros. Legenda: a base da NVD exige chave de API e download demorado, o que torna a ferramenta dependente de rede e cache.

**11. Checkov: o que é.** IaC Security. Avalia políticas sobre um grafo de recursos de infraestrutura. Licença Apache-2.0, escrito em Python.

**12. Checkov: como funciona.** Trecho de Terraform com a regra de NSG liberando SSH, e ao lado o veredito CKV_AZURE_10 reprovado.

**13. Checkov: a limitação que encontramos.** Slide de contraste. Duas colunas: à esquerda `source_address_prefix = "*"` com o resultado reprovado, à direita `= "0.0.0.0/0"` com o resultado aprovado. Legenda: mesma exposição, vereditos opostos. É um falso negativo.

**14. ZAP: o que é.** DAST. Scanner black-box que ataca a aplicação em execução. Licença Apache-2.0, projeto de 2010.

**15. ZAP: como funciona.** Três etapas em sequência: spider descobre as URLs, scan passivo observa as respostas, scan ativo injeta payloads. Destacar que apenas o scan ativo encontra XSS.

**16. ZAP: o gate por severidade.** Contraste entre duas execuções. Script empacotado: 3 alertas de risco alto, código de saída 2. Plano de automação com errorLevel High: código de saída 1. Legenda: só a segunda forma quebra o build por criticidade.

**17. Laboratório: como funciona.** Comando de clone e as cinco fases em uma linha do tempo. Aviso de que a turma executa junto.

**18. Fase 1 e 2, Checkov.** Antes e depois: reprovado com código 1, aprovado com código 0 após alterar uma linha.

**19. Fase 3 e 4, ZAP.** Antes e depois: alerta de risco alto com código 1, plano bem-sucedido com código 0 após alterar uma linha.

**20. Perguntas de verificação.** As duas perguntas que a turma responde ao final.

**21. Quadro comparativo.** Tabela das quatro ferramentas por categoria, licença, se exige aplicação no ar, se tem severidade nativa, se gera SARIF e tempo medido.

**22. A convergência.** O slide mais importante. Semgrep e ZAP encontraram o mesmo CWE-79 por caminhos independentes: um lendo código parado, o outro atacando a aplicação no ar. Mostrar os dois caminhos convergindo no mesmo ponto.

**23. Limitações que encontramos.** Quatro itens curtos: Checkov não classifica severidade na versão gratuita; a política CKV_AZURE_10 não reconhece notação CIDR; o código de saída dos scripts do ZAP ignora severidade; alertas passivos do ZAP variam entre execuções idênticas.

**24. Recomendação de toolchain.** Cada ferramenta posicionada no estágio do pipeline onde deve rodar, com a observação de que o gate por criticidade precisa ficar em ferramenta que atribui severidade real.

**25. Encerramento.** Link do repositório e espaço para perguntas.

---

## Depois de gerar

Para entregar em `.pptx` e abrir no Google Slides:

1. Exportar a apresentação como `.pptx`
2. Subir no Google Drive, que converte automaticamente para Slides editável
3. Exportar também em `.pdf`, exigido pelo enunciado
