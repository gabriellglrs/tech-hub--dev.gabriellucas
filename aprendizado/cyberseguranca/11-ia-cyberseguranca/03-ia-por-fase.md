# IA para Cada Fase do Pentest

> Como usar IA em cada etapa de um penetration test.

---

## Fase 1: Reconhecimento + IA

### Nuclei + AI

```bash
# Scan com triagem automática
nuclei -u http://target.com -severity critical,high -silent

# Com templates específicos de IA
nuclei -u http://target.com -tags ai,ml
```

### Shodan AI

```bash
# Buscar dispositivos com IA
shodan search "has_screenshot:true port:554 country:BR"
```

### Ollama para Análise de Resultados

```bash
# Alimentar resultado do subfinder
ollama run llama3.1:8b <<EOF
Analise estes subdomínios e classifique por risco:
$(cat subdomains.txt)
EOF
```

---

## Fase 2: Scanning + IA

### CAI Automated Scan

```bash
# Scan completo automatizado
cai scan http://target.com

# OUTPUT ESPERADO:
# [CAI] Starting scan...
# [Recon] Found 15 endpoints
# [Web] Testing 8 attack vectors...
# [Network] Scanning ports...
# [Results] 3 HIGH, 5 MEDIUM, 2 LOW
```

### Nuclei + AI Triage

```bash
# Scan com priorização automática
nuclei -u http://target.com -t http/ -severity critical,high -json | \
  ollama run llama3.1:8b "Priorize these vulnerabilities by exploitability"
```

---

## Fase 3: Exploração + IA

### CAI Exploit Generation

```bash
# Gerar exploit para SQLi
cai exploit sqli --target http://target.com/login

# Gerar exploit para XSS
cai exploit xss --target http://target.com/search?q=test
```

### Ollama para Payload Generation

```bash
ollama run codellama:13b <<EOF
Gere um payload Python para:
1. SQL Injection no campo 'user' de /login
2. Usar requests e bs4
3. Incluir bypass de WAF com encoding
EOF
```

---

## Fase 4: Pós-Exploração + IA

### AI-Assisted Enumeration

```bash
# Analisar output do enum4linux
ollama run llama3.1:8b <<EOF
Analise este output do enum4linux e identifique:
1. Usuários válidos
2. Shares acessíveis
3. Vulnerabilidades

$(cat enum4linux.txt)
EOF
```

### AI para Privesc

```bash
# Analisar output do LinPEAS
ollama run llama3.1:8b <<EOF
Com base neste output do LinPEAS, sugira vetores de escalação de privilégio:

$(cat linpeas.txt)
EOF
```

---

## Fase 5: Relatório + IA

### AI Report Generation

```bash
# Gerar relatório a partir de findings
ollama run llama3.1:8b <<EOF
Gere um relatório profissional de pentest com estes findings:
- SQL Injection no /login (HIGH)
- XSS no /search (MEDIUM)
- Missing security headers (LOW)

Inclua: resumo executivo, metodologia, achados, recomendações, timeline.
EOF
```

### CAI Report

```bash
# Gerar relatório automaticamente
cai report --format pdf --output relatorio.pdf
cai report --format html --output relatorio.html
```

---

## Resumo: IA por Fase

| Fase | Ferramenta IA | Uso |
|:-----|:-------------|:----|
| Recon | Ollama, Shodan AI | Análise de subdomínios, classificação de risco |
| Scanning | CAI, Nuclei+AI | Scan automatizado, priorização de vulns |
| Exploitation | CAI, Ollama | Geração de payloads, bypass de WAF |
| Post-Exploitation | Ollama | Análise de enum, sugestão de privesc |
| Report | Ollama, CAI | Geração de relatório, resumo executivo |
