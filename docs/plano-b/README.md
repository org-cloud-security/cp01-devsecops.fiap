# Plano B

Gravação da execução completa do laboratório, para o caso de o ambiente falhar durante a apresentação.

O arquivo `lab.cast` é uma gravação de terminal em formato asciicast, com 3 minutos e 10 segundos. Cobre as cinco fases do `LAB.md`: Checkov reprovando e passando, ZAP reprovando e passando, e a mudança de `Content-Type` que elimina o XSS.

## Como reproduzir

```bash
asciinema play docs/plano-b/lab.cast
```

Se o `asciinema` não estiver instalado:

```bash
pip install --user asciinema
```

## Marcos da gravação

| Tempo aproximado | Momento |
| --- | --- |
| 0:00 | Checkov reprova `CKV_AZURE_10`, exit code 1 |
| 0:25 | Terraform corrigido, `Passed checks: 4`, exit code 0 |
| 0:45 | `curl` mostra o payload refletido com `Content-Type: text/html` |
| 1:00 | ZAP encerra com `risk of at least: High`, exit code 1 |
| 2:10 | Aplicação corrigida, resposta passa a `text/plain` |
| 2:30 | ZAP encerra com `Automation plan succeeded!`, exit code 0 |
