# 🔍 17. Nuclei — Scanner de Vulnerabilidades Baseado em Templates

> Nuclei é o scanner mais rápido e extensível que existe. 9000+ templates para detectar tudo — de CVEs a configurações erradas.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 40min | ⭐⭐ Intermediário | `nuclei, curl` |

</div>

---

## 🎓 Por que isso importa?

Nuclei é um scanner **baseado em templates** desenvolvido pela ProjectDiscovery. Ele envia requests HTTP e verifica se o response corresponde a um padrão de vulnerabilidade. Com 9000+ templates da comunidade, ele detecta CVEs, misconfigurations, exposed panels, default credentials e mais.

**Analogia:** Imagine um detector de metais que sabe identificar 9000 tipos de metal diferentes. Você aponta ele e ele te diz o que encontrou — em segundos.

**Vantagens sobre Nikto:**
- 10x mais rápido
- Templates atualizados pela comunidade
- Customizável (criar seus próprios templates)
- Baixo falso-positivo rate

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP basics | Sim | Módulo 00 |
| CLI básico | Sim | Módulo 00 |

---

## 🎯 Quando usar Nuclei

- **Discovery rápido** de vulnerabilidades em targets
- **Pentest** — primeira passada para identificar alvos fáceis
- **Bug bounty** — escanear múltiplos targets rapidamente
- **Auditoria** — verificar configurações inseguras
- **CVE check** — testar se servidor é vulnerável a CVEs específicas

---

## 🛠️ Instalação

```bash
# Instalar via Go
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# Ou via apt (Kali)
sudo apt update && sudo apt install nuclei

# Ou via GitHub releases
wget https://github.com/projectdiscovery/nuclei/releases/latest/download/nuclei_linux_amd64.zip
unzip nuclei_linux_amd64.zip
sudo mv nuclei /usr/local/bin/

# Verificar versão
nuclei -version

# Atualizar templates (SEMPRE fazer antes de usar)
nuclei -update-templates
```

---

## 📋 Flags Principais

| Flag | Descrição | Exemplo |
|------|-----------|---------|
| `-u` | URL alvo | `-u http://target.com` |
| `-l` | Lista de URLs | `-l urls.txt` |
| `-t` | Template(s) para usar | `-t cves/` |
| `-severity` | Filtrar por severidade | `-severity critical,high` |
| `-tags` | Filtrar por tags | `-tags sqli,xss` |
| `-o` | Salvar output | `-o results.txt` |
| `-json` | Output em JSON | `-json` |
| `-silent` | Só output final | `-silent` |
| `-rate-limit` | Requests por segundo | `-rate-limit 100` |
| `-c` | Concorrência | `-c 25` |
| `-timeout` | Timeout por request | `-timeout 10` |
| `-retries` | Tentativas | `-retries 3` |
| `-proxy` | Usar proxy | `-proxy http://127.0.0.1:8080` |
| `-headers` | Headers customizados | `-headers "Authorization: Bearer token"` |
| `-rl` | Rate limit | `-rl 150` |
| `-bs` | Bulk size (batch) | `-bs 50` |
| `-stats` | Mostrar estatísticas | `-stats` |
| `-v` | Verbose | `-v` |
| `-nc` | No color | `-nc` |

---

## 📝 Exemplos Práticos

### Exemplo 1: Scan Básico

```bash
# Scan completo de um target
nuclei -u http://target.com

# Output esperado:
# [tech-detect:nginx] [http] [info] http://target.com
# [cve-2021-44228] [http] [critical] http://target.com/api
# [exposed-panel:grafana] [http] [high] http://target.com:3000
```

### Exemplo 2: Filtrar por Severidade

```bash
# Apenas vulnerabilidades críticas e altas
nuclei -u http://target.com -severity critical,high

# Output:
# [critical] [cve-2021-44228] http://target.com/api
# [high] [exposed-panel:grafana] http://target.com:3000
```

### Exemplo 3: Scan de Múltiplos Targets

```bash
# Criar lista de URLs
cat > targets.txt << 'EOF'
http://target1.com
http://target2.com
https://target3.com
EOF

# Scan todos
nuclei -l targets.txt -severity critical,high -o results.txt
```

### Exemplo 4: Scan de CVEs Específicas

```bash
# Scan apenas CVEs de uma tecnologia
nuclei -u http://target.com -t cves/2021/

# CVE específica
nuclei -u http://target.com -t cves/2021/CVE-2021-44228

# Scan de Apache Struts
nuclei -u http://target.com -t cves/ -tags struts
```

### Exemplo 5: Scan via Proxy (Burp)

```bash
# Enviar todo tráfego do Nuclei via Burp Suite
nuclei -u http://target.com -proxy http://127.0.0.1:8080

# Ver requests no Burp → HTTP History
```

### Exemplo 6: Templates Customizados

```bash
# Criar template YAML
cat > my-template.yaml << 'EOF'
id: custom-sqli-test
info:
  name: Custom SQLi Test
  author: gabriel
  severity: high
  description: Testa SQLi básico

http:
  - method: GET
    path:
      - "{{BaseURL}}/api/users?id=1'"
    
    matchers-condition: or
    matchers:
      - type: word
        words:
          - "SQL syntax"
          - "mysql_fetch"
          - "ORA-01756"
      
      - type: status
        status:
          - 500
EOF

# Usar template customizado
nuclei -u http://target.com -t my-template.yaml
```

### Exemplo 7: Output JSON para Análise

```bash
# Output em JSON
nuclei -u http://target.com -json -o results.json

# Analisar com jq
cat results.json | jq '.[] | select(.info.severity == "critical")'

# Contar por severidade
cat results.json | jq '[.[] | .info.severity] | group_by(.) | map({(.[0]): length}) | add'
```

---

## 📋 Templates do Nuclei

### Estrutura de um Template

```yaml
id: template-id           # ID único
info:
  name: Nome do template
  author: Autor
  severity: critical/high/medium/low/info
  description: Descrição
  tags: tag1,tag2
  reference:
    - https://example.com
  classification:
    cvss-metrics: CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H
    cvss-score: 9.8
    cwe-id: CWE-89

http:
  - method: GET
    path:
      - "{{BaseURL}}/vulneravel"
    
    matchers:
      - type: word
        words:
          - "padrão encontrado"
      
      - type: status
        status:
          - 200
```

### Categorias de Templates

```
cves/           → CVEs conhecidas
vulnerabilities/ → Vulnerabilidades gerais
exposed-panels/  → Painéis expostos (admin, Grafana, etc.)
default-logins/  → Credenciais padrão
misconfigurations/ → Configurações erradas
technologies/    → Detecção de tecnologias
dns/             → DNS
ssl/             → SSL/TLS
```

---

## 🔄 Fluxo de Uso

```
┌─────────────────────────────────────────────────────────┐
│  1. ATUALIZAR TEMPLATES                                  │
│     nuclei -update-templates                             │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  2. SCAN INICIAL (todas as severidades)                  │
│     nuclei -u http://target.com -o initial-scan.json     │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  3. FILTRAR CRÍTICOS                                     │
│     nuclei -u http://target.com -severity critical,high  │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  4. VALIDAR MANUALMENTE                                  │
│     - Testar cada finding no Burp Repeater               │
│     - Confirmar falso-positivos                          │
│     - Escalar vulnerabilidades                           │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  5. EXPLORAR                                              │
│     - CVEs → buscar exploit no Exploit-DB                │
│     - Exposed panels → tentar credenciais padrão        │
│     - Misconfigurations → explorar config errada         │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ Erros Comuns

| Erro | Solução |
|------|---------|
| "Templates desatualizados" | `nuclei -update-templates` antes de usar |
| "Muitos falsos-positivos" | Filtrar por severity, validar manualmente |
| "Scan muito lento` | Usar `-rate-limit`, `-c`, `-timeout` |
| "Bloqueado por WAF` | Usar `-proxy` com Burp, reduzir rate |
| "Templates não encontrados" | Verificar path: `ls ~/nuclei-templates/` |

---

## 📋 Cheat Sheet Rápido

### Scan Rápido

```bash
# Scan básico
nuclei -u http://target.com

# Só críticos
nuclei -u http://target.com -severity critical

# CVEs apenas
nuclei -u http://target.com -t cves/

# Exposed panels
nuclei -u http://target.com -t exposed-panels/

# Default logins
nuclei -u http://target.com -t default-logins/

# Via proxy
nuclei -u http://target.com -proxy http://127.0.0.1:8080

# Output JSON
nuclei -u http://target.com -json -o results.json

# Múltiplos targets
nuclei -l targets.txt -severity critical,high -o results.txt

# Template customizado
nuclei -u http://target.com -t my-template.yaml
```

### Atalhos de Templates

```
-templates cves/          → todas as CVEs
-templates exposed-panels → painéis expostos
-templates default-logins → credenciais padrão
-templates misconfigurations → config erradas
-templates technologies   → detecção de tech
-templates ssl           → problemas SSL
-templates dns           → enumeração DNS
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | TryHackMe | [Nuclei](https://tryhackme.com/room/nuclei) | Scan básico | 30min |
| 2 | PortSwigger | [All Labs (usar Nuclei para scan)](https://portswigger.net/web-security/all-labs) | Scan antes de manual | Variável |

---

## 📚 Referências

- [Nuclei Documentation](https://nuclei.projectdiscovery.io/)
- [Nuclei Templates](https://github.com/projectdiscovery/nuclei-templates)
- [ProjectDiscovery Blog](https://blog.projectdiscovery.io/)
- [HackTricks — Nuclei](https://book.hacktricks.xyz/network-pentesting/pentesting-network/scan-ports)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Instalar e atualizar Nuclei
- [ ] Executar scan básico em um target
- [ ] Filtrar por severidade e tags
- [ ] Usar templates de CVEs e exposed panels
- [ ] Criar templates customizados
- [ ] Analisar output em JSON
- [ ] Usar Nuclei via proxy (Burp Suite)
- [ ] Integrar Nuclei no workflow de pentest
