# Fase 10: Scan Automatizado com Nuclei

**Tempo estimado:** 30-45 minutos
**Objetivo:** Executar scan automatizado de vulnerabilidades usando templates Nuclei para complementar o teste manual. O Nuclei tem 9000+ templates que detectam CVEs, misconfigurations e vulnerabilidades conhecidas.
**Por quê:** Enquanto os testes manuais (Fases 3-7) encontram vulnerabilidades lógicas específicas da aplicação, o Nuclei encontra vulnerabilidades conhecidas (CVEs, configs erradas) que você pode ter perdido.

---

### Passo 10.1 — Verificar Instalação e Atualização

**O que você vai fazer:** Confirmar que o Nuclei está instalado e com os templates atualizados.

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

---

### Passo 10.2 — Scan Básico

**O que você vai fazer:** Rodar todos os templates do Nuclei contra o alvo.

```bash
nuclei -u https://target.com -o relatorio/nuclei-basic.txt
```

**Explicação das flags:**
| Flag | Função |
|------|--------|
| `-u https://target.com` | URL alvo |
| `-o relatorio/nuclei-basic.txt` | Salvar resultados em arquivo |

**✅ Output esperado:**
```
[technologies:nginx] [http] [info] https://target.com
[vulnerabilities:cve-2021-44228] [http] [critical] https://target.com
[misconfiguration:missing-header] [http] [medium] https://target.com
[exposures:config-file] [http] [high] https://target.com
```

**O que procurar:**
- **[critical]** → vulnerabilidades críticas → prioridade máxima
- **[high]** → vulnerabilidades altas → corrigir em breve
- **[medium]** → vulnerabilidades médias → planejar correção
- **[info]** → informações → usar para entendimento da aplicação

---

### Passo 10.3 — Scan com Severity Específica

**O que você vai fazer:** Filtrar apenas vulnerabilidades de severidade crítica e alta.

```bash
nuclei -u https://target.com -severity critical,high -o relatorio/nuclei-criticos.txt
```

**✅ Output esperado:**
```
[vulnerabilities:cve-2021-44228] [http] [critical] https://target.com
[exposures:config-file] [http] [high] https://target.com
[misconfiguration:directory-listing] [http] [high] https://target.com
```

---

### Passo 10.4 — Scan com Tags Específicas

**O que você vai fazer:** Rodar apenas templates de tipos específicos (SQLi, XSS, SSRF, etc).

```bash
nuclei -u https://target.com -tags sqli,xss,ssrf -o relatorio/nuclei-web.txt
```

**Tags úteis para web:**
```
sqli, xss, ssrf, rce, lfi, rfi, upload, auth, misconfiguration, exposure
```

---

### Passo 10.5 — Scan com Lista de URLs

**O que você vai fazer:** Escanear múltiplas URLs de uma vez.

```bash
# Criar arquivo de URLs
echo "https://target.com" > relatorio/urls.txt
echo "https://api.target.com" >> relatorio/urls.txt
echo "https://admin.target.com" >> relatorio/urls.txt

# Scan de múltiplas URLs
nuclei -l relatorio/urls.txt -o relatorio/nuclei-multi.txt
```

---

### Passo 10.6 — Scan com Rate Limiting

**O que você vai fazer:** Evitar bloqueio por rate limiting durante o scan.

```bash
nuclei -u https://target.com -rate-limit 10 -timeout 10 -o relatorio/nuclei-limited.txt
```

**Explicação das flags:**
| Flag | Função |
|------|--------|
| `-rate-limit 10` | Máximo 10 requests por segundo |
| `-timeout 10` | Timeout de 10 segundos por request |

---

### Passo 10.7 — Scan com Templates Específicos

```bash
# Scan apenas SQL injection
nuclei -u https://target.com -t http/vulnerabilities/sql-injection/ -o relatorio/nuclei-sqli.txt

# Scan apenas XSS
nuclei -u https://target.com -t http/vulnerabilities/xss/ -o relatorio/nuclei-xss.txt

# Scan apenas misconfigurations
nuclei -u https://target.com -t http/misconfiguration/ -o relatorio/nuclei-misconfig.txt
```

---

### Passo 10.8 — Analisar Resultados

```bash
# Contar vulnerabilidades por severity
echo "=== Resumo ==="
echo "Críticas: $(grep -c '\[critical\]' relatorio/nuclei-basic.txt)"
echo "Altas: $(grep -c '\[high\]' relatorio/nuclei-basic.txt)"
echo "Médias: $(grep -c '\[medium\]' relatorio/nuclei-basic.txt)"
echo "Baixas: $(grep -c '\[low\]' relatorio/nuclei-basic.txt)"

# Filtrar por tipo
echo "=== SQL Injection ==="
grep "sql-injection" relatorio/nuclei-basic.txt

echo "=== XSS ==="
grep "xss" relatorio/nuclei-basic.txt

echo "=== Misconfigurations ==="
grep "misconfiguration" relatorio/nuclei-basic.txt
```

### Passo 10.9 — Exportar para JSON

```bash
nuclei -u https://target.com -json -o relatorio/nuclei-results.json
python3 -m json.tool relatorio/nuclei-results.json > relatorio/nuclei-formatted.json
```

---

## Checklist de Nuclei

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Nuclei instalado e atualizado | — | [ ] |
| 2 | Templates atualizados | — | [ ] |
| 3 | Scan básico executado | `relatorio/nuclei-basic.txt` | [ ] |
| 4 | Scan com severity crítica/alta | `relatorio/nuclei-criticos.txt` | [ ] |
| 5 | Scan com tags específicas | `relatorio/nuclei-web.txt` | [ ] |
| 6 | Scan com múltiplas URLs | `relatorio/nuclei-multi.txt` | [ ] |
| 7 | Resultados analisados | — | [ ] |
| 8 | Exportado para JSON | `relatorio/nuclei-results.json` | [ ] |

### ✅ Sinal de sucesso:
- Pelo menos **5 vulnerabilidades encontradas** (varia por alvo)
- **Vulnerabilidades críticas/alta documentadas**
- Resultados cruzados com testes manuais das fases anteriores

### ❌ Se falhou:
- Nuclei retornou 0 resultados → o alvo pode ser muito seguro ou o scan não rodou
- Muitos falsos positivos → use `-severity critical,high` para filtrar
- O mínimo para avançar: ter executado pelo menos o scan básico

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 10 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `nuclei-basic.txt` | Fase 11 (Validação) | Confirmar vulnerabilidades encontradas |
| `nuclei-criticos.txt` | Fase 12 (Relatório) | Documentar vulnerabilidades críticas |
| `nuclei-results.json` | Fase 12 (Relatório) | Dados estruturados para o relatório |

**Se completou tudo → Avance para Fase 11** (`11-validacao.md`)

---

## Mini-Checkpoint: Execute um Scan Nuclei

1. Execute `nuclei -u https://target.com -severity critical,high -o relatorio/nuclei-checkpoint.txt`
2. Verifique se encontrou pelo menos 1 vulnerabilidade
3. Se encontrou → avance. Se não → tente com `-tags sqli,xss` para tipos específicos

---
