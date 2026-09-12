# Manual de Teste Web — Checklist Operacional

## Objetivo
Guia passo a passo para executar um teste de segurança web completo em um alvo, usando Burp Suite Community e ferramentas complementares no Kali Linux. Cada fase é uma sequência de ações copiar-e-colar com outputs esperados.

## Pré-requisitos
- Kali Linux atualizado
- Burp Suite Community Edition instalado
- Proxy browser configurado (FoxyProxy ou configuração manual)
- Acesso à URL do alvo (scope definido)
- pluma ou nano para edição de arquivos

## Estrutura do Manual

| Fase | Arquivo | Descrição |
|------|---------|-----------|
| Setup | `00-checklist-setup.md` | Verificar ambiente, Burp, proxy, escopo |
| 1 | `01-setup-burp-proxy.md` | Configurar Burp Suite e proxy intercept |
| 2 | `02-recon-api.md` | Mapeamento da superfície de ataque via API |
| 3 | `03-injecao.md` | SQLi, NoSQLi, SSTI, command injection |
| 4 | `04-cliente.md` | XSS, CSRF, clickjacking, DOM |
| 5 | `05-auth.md` | Autenticação, sessão, JWT, OAuth |
| 6 | `06-ssrf.md` | Server-Side Request Forgery |
| 7 | `07-xxe.md` | XML External Entity |
| 8 | `08-file-upload.md` | Upload de webshells e bypass |
| 9 | `09-business.md` | Lógica de negócio, race conditions |
| 10 | `10-nuclei.md` | Scan automatizado com templates |
| Pós-teste | `11-validacao.md` | Confirmar exploits, reproduzir |
| Pós-teste | `12-relatorio.md` | Documentar findings |

## Anexos

| Anexo | Arquivo | Descrição |
|-------|---------|-----------|
| A | `A-troubleshooting.md` | Solução de problemas comuns |
| B | `B-referencia-rapida.md` | Cheat sheet de payloads e comandos |
| C | `C-quando-parar.md` | Critérios de parada e escopo |

## Como Usar Este Manual

1. Execute as fases em ordem (1→10)
2. Cada fase é independente — se uma não aplicar ao alvo, pule
3. Salve os outputs em `relatorio/` para referência
4. Ao final, use `11-validacao.md` para confirmar cada finding
5. Gere o relatório com `12-relatorio.md`

## Convenções

- **🎯 Alvo**: URL base do alvo (ex: `https://target.com`)
- **📡 Proxy**: Burp Suite Proxy intercept (porta 8080)
- **🔒 Escopo**: Definido no Burp Target → Scope
- **📝 Output**: Sempre salve no diretório `relatorio/`
