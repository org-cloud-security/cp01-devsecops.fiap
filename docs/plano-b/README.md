# Plano B

Gravação da execução completa do laboratório, para o caso de o ambiente falhar durante a apresentação.

O arquivo `lab.mp4` cobre as cinco fases do `LAB.md`: Checkov reprovando e passando, ZAP reprovando e passando, e a mudança de `Content-Type` que elimina o XSS.

## Marcos da gravação

| Tempo aproximado | Momento |
| --- | --- |
| 0:00 | Checkov reprova `CKV_AZURE_10`, exit code 1 |
| 0:17 | Terraform corrigido, `Passed checks: 4`, exit code 0 |
| 0:30 | `curl` mostra o payload refletido com `Content-Type: text/html` |
| 0:40 | ZAP encerra com `risk of at least: High`, exit code 1 |
| 1:25 | Aplicação corrigida, resposta passa a `text/plain` |
| 1:40 | ZAP encerra com `Automation plan succeeded!`, exit code 0 |
