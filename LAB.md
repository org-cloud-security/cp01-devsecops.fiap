# Laboratório: Checkov (IaC) e OWASP ZAP (DAST)

Duas ferramentas, duas categorias. Em cada uma: rode o scan, veja o gate quebrar, corrija uma linha, rode de novo.

## Pré-requisitos

- Docker e Docker Compose
- `git clone` deste repositório feito **antes** da aula
- Imagens baixadas antes da aula:

```bash
docker pull bridgecrew/checkov:3.3.20
docker pull zaproxy/zap-stable:2.17.0
```

Todos os comandos rodam a partir de `lab/`:

```bash
cd lab
```

## Fase 1: Checkov encontra SSH aberto

```bash
docker compose run --rm checkov
```

Esperado: `Failed checks: 1`, check `CKV_AZURE_10`. **Exit code 1**, o gate quebrou.

Confira o exit code:

```bash
echo $?
```

## Fase 2: Corrigir o Terraform

Em `iac/main.tf`, comente a linha marcada como `VULNERAVEL` e descomente a de `CORRECAO`:

```hcl
    # source_address_prefix = "*"
    source_address_prefix = "10.0.0.0/24"
```

Rode de novo:

```bash
docker compose run --rm checkov
```

Esperado: `Passed checks: 4, Failed checks: 0`. **Exit code 0**.

## Fase 3: ZAP encontra XSS refletido

Suba a aplicação e rode o scan (leva de 2 a 4 minutos):

```bash
docker compose up -d app
docker compose run --rm zap
```

Esperado: `An alert has been raised with a risk of at least: High`. **Exit code 1**.

Veja a vulnerabilidade no navegador:

```
http://localhost:3000/hello?name=<script>alert(1)</script>
```

O relatório completo fica em `reports/zap.html`.

## Fase 4: Corrigir a aplicação

Em `app/index.js`, comente a linha `VULNERAVEL` e descomente a de `CORRECAO`:

```js
  // res.send("Hello, " + req.query.name);
  res.type("text").send("Hello, " + req.query.name);
```

Reconstrua e rode de novo:

```bash
docker compose up -d --build app
docker compose run --rm zap
```

Esperado: `Automation plan succeeded!`. **Exit code 0**.

## Fase 5: Encerrar

```bash
docker compose down
```

## Perguntas de verificação

Responda com o que apareceu na sua máquina:

1. Qual o ID do check que o Checkov reprovou, e quantos checks passaram depois da correção?
2. Quantos alertas de risco High o ZAP levantou antes da correção, e qual o CWE do XSS refletido?
