## FASE 6 — Validação e Scan Automatizado (Nuclei)

**Tempo estimado:** 60-90 minutos
**Objetivo:** Rodar o Nuclei para pegar CVEs/configs que você pode ter perdido e ENTÃO confirmar CADA vulnerabilidade encontrada nas fases anteriores — reproduzindo o exploit e documentando evidências.
**Por quê:** Falsos positivos destroem a credibilidade do teste. **NADA vai para o relatório sem ser validado.**

> **📡 Nuclei no recon (Módulo 01):** se `05-vulns/nuclei.txt` já existe, revise os achados antes de rodar de novo — com critical/high já conhecidos, use tags (`-tags sqli,xss,ssrf`) em vez de rodar 9000+ templates do zero. Use o resultado anterior como baseline.

---

## 6A: Scan Automatizado com Nuclei

### Passo 6A.1 — Instalação e Atualização

```bash
nuclei -version
nuclei -update-templates
```

**✅ Output esperado:**
```
Current nuclei version: v3.x.x
[INF] nuclei-templates v3.x.x (latest)
[INF] Successfully updated nuclei-templates
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `nuclei: command not found` | Não instalado | `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest` |
| Templates não atualizam | Internet bloqueando | `nuclei -update-templates -update-directory ~/nuclei-templates` |

### Passo 6A.2 — Scan Básico

```bash
nuclei -u https://evilcorp.com -o 13-validacao/nuclei-basic.txt
```

**✅ Output esperado:**
```
[technologies:nginx] [http] [info] https://evilcorp.com
[vulnerabilities:cve-2021-44228] [http] [critical] https://evilcorp.com
[misconfiguration:missing-header] [http] [medium] https://evilcorp.com
[exposures:config-file] [http] [high] https://evilcorp.com
```

**O que procurar:** `[critical]` → prioridade máxima · `[high]` → corrigir em breve · `[medium]` → planejar · `[info]` → contexto da aplicação.

### Passo 6A.3 — Scan com Severity Específica

```bash
nuclei -u https://evilcorp.com -severity critical,high -o 13-validacao/nuclei-criticos.txt
```

### Passo 6A.4 — Scan com Tags (foco web)

```bash
nuclei -u https://evilcorp.com -tags sqli,xss,ssrf -o 13-validacao/nuclei-web.txt
```
Tags úteis: `sqli, xss, ssrf, rce, lfi, rfi, upload, auth, misconfiguration, exposure`

### Passo 6A.5 — Scan com Lista de URLs (subdomínios vivos)

```bash
# Lista de subdomínios vivos do recon (Módulo 01)
nuclei -l ~/recon/targets/<alvo>/02-enum/vivos-filtrados.txt -o 13-validacao/nuclei-multi.txt

# Alternativa manual
printf "https://evilcorp.com\nhttps://api.evilcorp.com\nhttps://admin.evilcorp.com\n" > 13-validacao/urls.txt
nuclei -l 13-validacao/urls.txt -o 13-validacao/nuclei-multi.txt
```

### Passo 6A.6 — Scan com Rate Limiting (WAF-safe)

```bash
nuclei -u https://evilcorp.com -rate-limit 10 -timeout 10 -o 13-validacao/nuclei-limited.txt
```
`-rate-limit 10` = máx 10 requests/s · `-timeout 10` = 10s por request.

### Passo 6A.7 — Templates Específicos

```bash
nuclei -u https://evilcorp.com -t http/vulnerabilities/sql-injection/ -o 13-validacao/nuclei-sqli.txt
nuclei -u https://evilcorp.com -t http/vulnerabilities/xss/ -o 13-validacao/nuclei-xss.txt
nuclei -u https://evilcorp.com -t http/misconfiguration/ -o 13-validacao/nuclei-misconfig.txt
```

### Passo 6A.8 — Analisar Resultados

```bash
echo "=== Resumo ==="
echo "Críticas: $(grep -c '\[critical\]' 13-validacao/nuclei-basic.txt)"
echo "Altas:    $(grep -c '\[high\]' 13-validacao/nuclei-basic.txt)"
echo "Médias:   $(grep -c '\[medium\]' 13-validacao/nuclei-basic.txt)"

grep "sql-injection\|xss\|misconfiguration" 13-validacao/nuclei-basic.txt

# Exportar JSON estruturado
nuclei -u https://evilcorp.com -json -o 13-validacao/nuclei-results.json
python3 -m json.tool 13-validacao/nuclei-results.json > 13-validacao/nuclei-formatted.json
```

**❌ Se falhou:** 0 resultados → alvo muito seguro ou scan não rodou; muitos falsos positivos → `-severity critical,high`.

---

## 6B: Validação de Vulnerabilidades

### Passo 6B.1 — Revisar Todos os Findings

```bash
echo "=== Findings das fases anteriores ==="
for f in 10-injecao/sqli-test.txt 10-injecao/ssti.txt 10-injecao/cmdi.txt \
         11-cliente-auth/xss-reflected.txt 11-cliente-auth/csrf.txt \
         11-cliente-auth/user-enumeration.txt 11-cliente-auth/auth-bypass.txt \
         12-especializados/ssrf-test.txt 12-especializados/xxe-test.txt \
         12-especializados/upload-test.txt 12-especializados/race-transfer.txt \
         12-especializados/idor.txt 13-validacao/nuclei-criticos.txt; do
  echo "--- $f"
  cat "$f" 2>/dev/null || echo "  Nenhum"
done
```

Crie a lista consolidada em `13-validacao/findings-todos.txt`.

### Passo 6B.2 — Confirmar por Tipo (checklist de reprodução)

**SQL Injection** — `GET /api/users?id=1' OR '1'='1--`
- [ ] Retorna dados extras
- [ ] UNION SELECT extrai dados específicos
- [ ] SQLMap confirma: `sqlmap -u "URL" --batch`

**XSS** — `GET /search?q=<script>alert('XSS')</script>`
- [ ] Alert aparece no Firefox
- [ ] Persiste no DOM (DevTools)
- [ ] Roubo de cookie: `<script>alert(document.cookie)</script>`

**SSRF** — `GET /api/fetch?url=http://127.0.0.1`
- [ ] Resposta do servidor interno retornada
- [ ] Cloud metadata acessível (se aplicável)
- [ ] Port scanning funciona (22, 80, 443)

**Command Injection** — `GET /api/ping?host=127.0.0.1;id`
- [ ] Output do `id` retornado (uid, gid)
- [ ] `cat /etc/passwd` funciona → RCE reproduzível

**File Upload** — webshell em `shell.php`
- [ ] Upload aceito
- [ ] Acessível: `https://evilcorp.com/uploads/shell.php?cmd=id`
- [ ] Comandos executam

**Race Condition:**
```bash
for i in {1..5}; do
  curl -s -X POST https://evilcorp.com/api/transfer \
    -H "Content-Type: application/json" \
    -d '{"to":"account2","amount":1000}' &
done
wait
```
- [ ] Múltiplos processados com sucesso
- [ ] Efeito colateral observado (saldo negativo, cupom reuso)
- [ ] Reproduzível 3 vezes

**Se NÃO reproduziu → falso positivo → remover.**

### Passo 6B.3 — Documentar Evidências

Para cada confirmada, registre em `13-validacao/evidencias.md`:

```markdown
## Vulnerabilidade: SQL Injection

**Endpoint:** GET /api/users?id=
**Payload:** 1' OR '1'='1--
**Evidência:**
- Response contém 50 registros (1 esperado)
- UNION SELECT confirmou acesso à tabela users
- SQLMap: MySQL 5.7, database targetdb
**Severidade:** Alta
**Status:** Confirmado
**Data:** 2026-09-25
**Reproduzível:** Sim (testado 3 vezes)
```

### Passo 6B.4 — Calcular Impacto (CVSS)

Use o calculator: https://www.first.org/cvss/calculator/

| Vulnerabilidade | Impacto | Severidade | CVSS |
|-----------------|---------|------------|------|
| SQL Injection | Exposição de dados, RCE | Alta | 8.6 |
| XSS Reflected | Roubo de sessão, phishing | Média | 6.1 |
| SSRF | Rede interna, cloud | Alta | 8.5 |
| Command Injection | RCE completo | Crítica | 9.8 |
| File Upload | RCE via webshell | Crítica | 9.8 |
| Race Condition | Bypass de regras | Média | 5.3 |

### Passo 6B.5 — Verificar Falsos Positivos

Critérios de falso positivo:
- Output é comportamento esperado (não vulnerabilidade)
- Não é reproduzível
- Impacto mínimo ou nulo
- WAF/defesa bloqueia o exploit na prática

**Falso positivo → remover de `findings-todos.txt` e documentar o motivo.**

---

### Checklist da Fase 6

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Nuclei instalado e templates atualizados | — | [ ] |
| 2 | Scan básico executado | `13-validacao/nuclei-basic.txt` | [ ] |
| 3 | Scan severity crítica/alta | `13-validacao/nuclei-criticos.txt` | [ ] |
| 4 | Scan tags web | `13-validacao/nuclei-web.txt` | [ ] |
| 5 | Scan múltiplas URLs | `13-validacao/nuclei-multi.txt` | [ ] |
| 6 | Resultados em JSON | `13-validacao/nuclei-results.json` | [ ] |
| 7 | Findings consolidados | `13-validacao/findings-todos.txt` | [ ] |
| 8 | Todos re-testados e confirmados | — | [ ] |
| 9 | Evidências documentadas | `13-validacao/evidencias.md` | [ ] |
| 10 | CVSS calculado | — | [ ] |
| 11 | Falsos positivos removidos | — | [ ] |

### ✅ Sinal de sucesso:
- Scan Nuclei completo e analisado (≥ 1 finding ou alvo confirmado seguro)
- **TODAS as vulnerabilidades confirmadas e reproduzíveis**
- Evidências com steps to reproduce + CVSS calculado
- Falsos positivos removidos

### ❌ Se alguma não reproduziu:
- **NÃO inclua no relatório** — documente "Não reproduzível em data de reteste"
- Pode ter sido corrigida entre teste e validação

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 6 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `evidencias.md` | Fase 7 (Relatório) | Base para detalhamento de cada vuln |
| `findings-todos.txt` | Fase 7 | Lista consolidada para o relatório |
| `nuclei-criticos.txt` / `nuclei-results.json` | Fase 7 | Vulnerabilidades conhecidas documentadas |

**Se completou tudo → Avance para [Fase 7 — Relatório](13-fase7-relatorio.md)**

---

## Mini-Checkpoint

1. `nuclei -u https://evilcorp.com -severity critical,high -o 13-validacao/nuclei-checkpoint.txt`
2. Se encontrou ≥ 1 → valide reproduzindo manualmente no Burp
3. Se não encontrou → tente `-tags sqli,xss` e valide os achados manuais das fases 3-5
