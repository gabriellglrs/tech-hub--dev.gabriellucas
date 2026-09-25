## Automação — Rodar as varreduras de uma vez

**O que este script faz:** após a Fase 1 (Alimentação), executa em lote as varreduras passivas/ativas básicas das Fases 2 e 6, salvando na estrutura correta. A exploração manual (Burp) continua feita por você.

> ⚠️ **Rode somente com autorização** e respeitando `06-opsec.md` (rate limit se tem WAF).

```bash
#!/usr/bin/env bash
# web-scan.sh — varreduras automatizadas do MANUAL-WEB
# Uso: ./web-scan.sh <alvo>   (ex: ./web-scan.sh evilcorp.com)

set -euo pipefail
ALVO="${1:?Uso: $0 <dominio>}"
URL="https://$ALVO"

mkdir -p 09-descoberta 10-injecao 13-validacao

echo "[*] Alvo: $URL"

# --- Fase 2: descoberta -------------------------------------------------
echo "[1/7] ffuf diretórios..."
ffuf -u "$URL/FUZZ" -w /usr/share/seclists/Discovery/Web-Content/common.txt \
  -mc 200,301,302,403 -t 5 -p 0.5 -o 09-descoberta/ffuf-dirs.json -of json \
  2>/dev/null || true

echo "[2/7] whatweb..."
whatweb "$URL" -v > 09-descoberta/whatweb.txt 2>/dev/null || true

echo "[3/7] headers..."
curl -I -s "$URL" > 09-descoberta/headers.txt || true

echo "[4/7] subdomínios vivos (httpx)..."
[ -f ../01-reconhecimento/recon/targets/$ALVO/02-enum/vivos-filtrados.txt ] && \
  httpx -l ~/recon/targets/$ALVO/02-enum/vivos-filtrados.txt -silent \
    -status-code -title > 09-descoberta/subdomains-http.txt || true

# --- Fase 6: nuclei -----------------------------------------------------
echo "[5/7] nuclei básico..."
nuclei -u "$URL" -severity critical,high \
  -o 13-validacao/nuclei-criticos.txt 2>/dev/null || true

echo "[6/7] nuclei tags web..."
nuclei -u "$URL" -tags sqli,xss,ssrf \
  -o 13-validacao/nuclei-web.txt 2>/dev/null || true

echo "[7/7] resumo..."
echo "Críticas/altas: $(grep -c '\[critical\]\|\[high\]' 13-validacao/nuclei-criticos.txt 2>/dev/null || echo 0)"
ls -la 09-descoberta/ 13-validacao/

echo "[+] Varredura concluída. Agora faça a exploração MANUAL no Burp (Fases 3-5)."
```

**Como usar:**
```bash
chmod +x web-scan.sh
./web-scan.sh evilcorp.com
```

**O que ele NÃO faz (e você precisa fazer à mão):**
- Crawl e scope no Burp (Passo 2.1)
- Testes de injeção, XSS, auth, JWT (Fases 3-4)
- SSRF/XXE/upload/lógica de negócio (Fase 5)
- Validação de evidências e relatório (Fases 6-7)

**Se der errado:** verifique [18 — Troubleshooting](18-troubleshooting.md); sem WAF remova `-p 0.5` do ffuf para acelerar.
