## Script de Automação — Rodar Tudo de Uma Vez

> **Este script roda TODAS as 7 fases automaticamente.** Útil para quando você já entendeu o manual e quer agilidade. Salve como `recon.sh`, execute como `./recon.sh evilcorp.com`, e volte em 2-3 horas para ver os resultados.

```bash
#!/bin/bash
# Script de Automação — Reconhecimento Completo
# Uso: ./recon.sh <dominio>
# Exemplo: ./recon.sh evilcorp.com

# === CONFIGURAÇÃO ===
DOMINIO=$1
BASE_DIR="$HOME/recon/targets/$DOMINIO"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG="$BASE_DIR/logs/recon_$TIMESTAMP.log"

# Cores
VERDE="\033[0;32m"
VERMELHO="\033[0;31m"
AMARELO="\033[1;33m"
RESET="\033[0m"

log() { echo -e "[$(date +%H:%M:%S)] ${VERDE}[+]${RESET} $1" | tee -a "$LOG"; }
erro() { echo -e "[$(date +%H:%M:%S)] ${VERMELHO}[!]${RESET} $1" | tee -a "$LOG"; }
aviso() { echo -e "[$(date +%H:%M:%S)] ${AMARELO}[!]${RESET} $1" | tee -a "$LOG"; }

# === VERIFICAÇÕES ===
if [ -z "$DOMINIO" ]; then
    echo "Uso: $0 <dominio>"
    echo "Exemplo: $0 evilcorp.com"
    exit 1
fi

if ! command -v nmap &> /dev/null; then
    erro "Nmap não encontrado. Instale com: sudo apt install nmap"
    exit 1
fi

# === CRIAR ESTRUTURA ===
log "Criando estrutura de pastas para $DOMINIO..."
mkdir -p "$BASE_DIR"/{01-intel,02-enum,03-fingerprint,04-discovery,05-vulns,06-validacao,07-relatorio,logs}

log "Estrutura criada em: $BASE_DIR"
echo ""

# === FASE 1: INTELIGÊNCIA PASSIVA ===
log "========== FASE 1: INTELIGÊNCIA PASSIVA =========="

log "1.1 — WHOIS..."
whois "$DOMINIO" > "$BASE_DIR/01-intel/whois.txt" 2>/dev/null

log "1.2 — DNS Records..."
dig "$DOMINIO" ANY > "$BASE_DIR/01-intel/dns-records.txt" 2>/dev/null
dig +short "$DOMINIO" > "$BASE_DIR/01-intel/ip-direto.txt" 2>/dev/null

log "1.3 — ASN/BGP Mapping..."
# Descobrir ASN pela organização (extrair do WHOIS)
ORG=$(grep -i "Organization\|OrgName\|registrant" "$BASE_DIR/01-intel/whois.txt" 2>/dev/null | head -1 | sed 's/.*: //')
if [ -n "$ORG" ]; then
    curl -s "https://api.bgpview.io/search?query_term=$ORG" | jq -r '.data.asns[].asn' 2>/dev/null > "$BASE_DIR/01-intel/asns.txt"
    # Para cada ASN, obter prefixos CIDR
    while read asn; do
        curl -s "https://api.bgpview.io/asn/AS${asn}/prefixes" | jq -r '.data.ipv4_prefixes[].prefix' 2>/dev/null
    done < "$BASE_DIR/01-intel/asns.txt" > "$BASE_DIR/01-intel/cidrs.txt"
fi

log "1.4 — Subfinder..."
subfinder -d "$DOMINIO" -silent > "$BASE_DIR/01-intel/subfinder.txt" 2>/dev/null

log "1.5 — Amass passivo..."
amass enum -passive -d "$DOMINIO" -o "$BASE_DIR/01-intel/amass.txt" 2>/dev/null

log "1.6 — crt.sh..."
curl -s "https://crt.sh/?q=$DOMINIO&output=json" | jq -r '.[].name_value' 2>/dev/null | sort -u > "$BASE_DIR/01-intel/crtsh.txt"

log "1.7 — theHarvester..."
theHarvester -d "$DOMINIO" -b google,bing,crtsh -f "$BASE_DIR/01-intel/theharvester.html" 2>/dev/null

log "1.8 — GitHub/GitLab OSINT..."
# Buscar repositórios públicos da organização
curl -s "https://api.github.com/search/repositories?q=$DOMINIO+in:name&sort=stars&order=desc" | jq -r '.items[].full_name' 2>/dev/null > "$BASE_DIR/01-intel/github-repos.txt"
# Buscar possíveis secrets no código (apenas indicadores, não exploração)
if [ -s "$BASE_DIR/01-intel/github-repos.txt" ]; then
    head -5 "$BASE_DIR/01-intel/github-repos.txt" | while read repo; do
        curl -s "https://api.github.com/repos/$repo/contents/" | jq -r '.[].name' 2>/dev/null
    done > "$BASE_DIR/01-intel/github-files.txt"
fi

log "1.9 — Combinar subdomínios..."
cat "$BASE_DIR/01-intel/subfinder.txt" "$BASE_DIR/01-intel/amass.txt" "$BASE_DIR/01-intel/crtsh.txt" 2>/dev/null | grep -i "$DOMINIO" | sort -u > "$BASE_DIR/01-intel/subdominios-todos.txt"

SUB_COUNT=$(wc -l < "$BASE_DIR/01-intel/subdominios-todos.txt" 2>/dev/null || echo "0")
log "Subdomínios encontrados: $SUB_COUNT"

log "1.10 — Wayback URLs..."
echo "$DOMINIO" | waybackurls > "$BASE_DIR/01-intel/wayback.txt" 2>/dev/null

log "1.11 — gau URLs..."
echo "$DOMINIO" | gau > "$BASE_DIR/01-intel/gau.txt" 2>/dev/null

log "1.12 — Combinar URLs..."
cat "$BASE_DIR/01-intel/wayback.txt" "$BASE_DIR/01-intel/gau.txt" 2>/dev/null | sort -u > "$BASE_DIR/01-intel/todas-urls.txt"

URL_COUNT=$(wc -l < "$BASE_DIR/01-intel/todas-urls.txt" 2>/dev/null || echo "0")
log "URLs históricas encontradas: $URL_COUNT"

log "Fase 1 concluída."
echo ""

# === FASE 2: ENUMERAÇÃO ATIVA ===
log "========== FASE 2: ENUMERAÇÃO ATIVA =========="

log "2.1 — Resolver DNS..."
cat "$BASE_DIR/01-intel/subdominios-todos.txt" | dnsx -silent -a > "$BASE_DIR/02-enum/resolvidos.txt" 2>/dev/null

log "2.2 — Validar HTTP vivos..."
cat "$BASE_DIR/02-enum/resolvidos.txt" | httpx -silent -status-code -title > "$BASE_DIR/02-enum/vivos.txt" 2>/dev/null

log "2.3 — Filtrar vivos (200/301/302)..."
cat "$BASE_DIR/02-enum/vivos.txt" | grep -E "\[200\]|\[301\]|\[302\]" > "$BASE_DIR/02-enum/vivos-filtrados.txt" 2>/dev/null

log "2.4 — Extrair IPs..."
cat "$BASE_DIR/02-enum/vivos.txt" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort -u > "$BASE_DIR/02-enum/ips.txt" 2>/dev/null

log "2.5 — Nmap ports (top 1000)..."
nmap -sT -Pn -p 21,22,25,53,80,110,143,443,993,995,3306,3389,5432,8080,8443,8888,9090 -T3 --max-rate 100 -iL "$BASE_DIR/02-enum/ips.txt" -oN "$BASE_DIR/02-enum/nmap-ports.txt" 2>/dev/null

log "2.6 — Nmap service detection..."
PORTAS=$(grep "open" "$BASE_DIR/02-enum/nmap-ports.txt" | awk '{print $1}' | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')
if [ ! -z "$PORTAS" ]; then
    nmap -sV -sC -p "$PORTAS" -T3 --max-rate 100 -iL "$BASE_DIR/02-enum/ips.txt" -oN "$BASE_DIR/02-enum/nmap-services.txt" 2>/dev/null
fi

log "2.7 — Banner grabbing..."
for port in 21 22 25 80 443; do
    echo "=== Port $port ===" >> "$BASE_DIR/02-enum/banners.txt"
    echo "" | ncat -w 3 "$DOMINIO" $port 2>&1 >> "$BASE_DIR/02-enum/banners.txt" 2>/dev/null
done

log "2.8 — Headers HTTP..."
curl -sI "http://$DOMINIO" > "$BASE_DIR/02-enum/headers.txt" 2>/dev/null

log "Fase 2 concluída."
echo ""

# === FASE 3: FINGERPRINTING ===
log "========== FASE 3: FINGERPRINTING =========="

log "3.1 — WhatWeb principal..."
whatweb -a 3 "$DOMINIO" > "$BASE_DIR/03-fingerprint/whatweb-principal.txt" 2>/dev/null

log "3.2 — WhatWeb todos os subs..."
cat "$BASE_DIR/02-enum/vivos-filtrados.txt" | awk '{print $1}' | whatweb -a 3 -i - > "$BASE_DIR/03-fingerprint/whatweb-todos.txt" 2>/dev/null

log "3.3 — httpx tech detect..."
cat "$BASE_DIR/02-enum/vivos-filtrados.txt" | awk '{print $1}' | httpx -tech-detect -title -status-code -web-server -silent > "$BASE_DIR/03-fingerprint/httpx-tech.txt" 2>/dev/null

log "3.4 — Wafw00f..."
wafw00f "$DOMINIO" > "$BASE_DIR/03-fingerprint/waf-principal.txt" 2>/dev/null

log "Fase 3 concluída."
echo ""

# === FASE 4: DISCOVERY DE CONTEÚDO ===
log "========== FASE 4: DISCOVERY DE CONTEÚDO =========="

log "4.1 — Gobuster dirs..."
gobuster dir -u "http://$DOMINIO" -w /usr/share/wordlists/dirb/common.txt -t 20 -b 404,403 --delay 0.2s -o "$BASE_DIR/04-discovery/gobuster-basico.txt" 2>/dev/null

log "4.2 — ffuf extensões..."
ffuf -u "http://$DOMINIO/FUZZ" -w /usr/share/wordlists/dirb/common.txt -e .php,.bak,.txt,.zip,.sql,.env,.old -fc 404,403 -p 0.5 -o "$BASE_DIR/04-discovery/ffuf-extensoes.json" -of json 2>/dev/null

log "4.3 — URLs com parâmetros..."
cat "$BASE_DIR/01-intel/todas-urls.txt" | grep "=" | sort -u > "$BASE_DIR/04-discovery/urls-com-parametros.txt" 2>/dev/null

PARAM_COUNT=$(wc -l < "$BASE_DIR/04-discovery/urls-com-parametros.txt" 2>/dev/null || echo "0")
log "URLs com parâmetros: $PARAM_COUNT"

log "Fase 4 concluída."
echo ""

# === FASE 5: SCAN DE VULNERABILIDADES ===
log "========== FASE 5: SCAN DE VULNERABILIDADES =========="

log "5.1 — Nikto..."
nikto -h "http://$DOMINIO" -o "$BASE_DIR/05-vulns/nikto.html" -Format htm 2>/dev/null

log "5.2 — Nuclei..."
nuclei -u "http://$DOMINIO" -severity medium,high,critical -o "$BASE_DIR/05-vulns/nuclei.txt" 2>/dev/null

log "5.3 — Nmap vuln..."
nmap --script vuln -p "$PORTAS" -T3 -iL "$BASE_DIR/02-enum/ips.txt" -oN "$BASE_DIR/05-vulns/nmap-vuln.txt" 2>/dev/null

log "Fase 5 concluída."
echo ""

# === FASE 6: VALIDAÇÃO ===
log "========== FASE 6: VALIDAÇÃO =========="

log "6.1 — Criando checklist de validação..."
cat > "$BASE_DIR/06-validacao/validacao.md" << VALFIM
# Validação de Achados - $(date)
## Verifique manualmente cada achado abaixo:
- [ ] Abrir cada URL encontrada no navegador
- [ ] Confirmar que cada vulnerabilidade é REAL (não falso positivo)
- [ ] Testar cada achado com curl/ncat
- [ ] Organizar por severidade
VALFIM

log "Fase 6 concluída — VALIDE MANUALMENTE os achados."
echo ""

# === FASE 7: RELATÓRIO ===
log "========== FASE 7: RELATÓRIO =========="

log "7.1 — Criando relatório..."
cat > "$BASE_DIR/07-relatorio/relatorio-recon.md" << RELFIM
# Relatório de Reconhecimento

| Campo | Valor |
|-------|-------|
| **Alvo** | $DOMINIO |
| **Data** | $(date +%d/%m/%Y) |
| **Autor** | $(whoami) |
| **Classificação** | CONFIDENCIAL |

---

## 1. Resumo Executivo
[ESCREVA AQUI]

## 2. Escopo
- **Alcance:** $DOMINIO
- **Exclusões:** [ESCREVA AQUI]

## 3. Metodologia
| Fase | Resultados |
|------|------------|
| 1 - Inteligência Passiva | $SUB_COUNT subdomínios, $URL_COUNT URLs |
| 2 - Enumeração Ativa | $(wc -l < "$BASE_DIR/02-enum/vivos-filtrados.txt" 2>/dev/null) vivos |
| 3 - Fingerprinting | Ver 03-fingerprint/ |
| 4 - Discovery | $(wc -l < "$BASE_DIR/04-discovery/urls-com-parametros.txt" 2>/dev/null) URLs com params |
| 5 - Vulns | Ver 05-vulns/ |

## 4. Descobertas
[ESCREVA AQUI os achados de cada fase]

## 5. Recomendações
[ESCREVA AQUI]

## 6. Ferramentas Utilizadas
Subfinder, Amass, crt.sh, theHarvester, httpx, Nmap, ncat, WhatWeb, wafw00f, Gobuster, ffuf, Nikto, Nuclei

## 7. Anexos
- 01-intel/ — Inteligência passiva
- 02-enum/ — Enumeração ativa
- 03-fingerprint/ — Fingerprinting
- 04-discovery/ — Discovery de conteúdo
- 05-vulns/ — Vulnerabilidades
RELFIM

log "Relatório criado: $BASE_DIR/07-relatorio/relatorio-recon.md"
echo ""

# === RESUMO FINAL ===
log "============================================"
log "  RECONHECIMENTO CONCLUÍDO!"
log "============================================"
log ""
log "Estrutura: $BASE_DIR"
log ""
log "PRÓXIMOS PASSOS:"
log "1. VALIDE os achados na Fase 6 (abre cada URL, confirma cada vuln)"
log "2. PREENCHA o relatório na Fase 7"
log "3. Organize por severidade"
log "4. Avance para o Módulo 02 - Web & Aplicações"
log ""
log "Total de arquivos:"
find "$BASE_DIR" -type f | wc -l
log ""
log "Logs: $LOG"
```

**Como usar:**
```bash
# Salvar
nano recon.sh

# Tornar executável
chmod +x recon.sh

# Rodar (com VPN ligada!)
nordvpn connect
./recon.sh evilcorp.com

# Voltar em 2-3 horas e verificar os resultados
ls -la ~/recon/targets/evilcorp/
```
