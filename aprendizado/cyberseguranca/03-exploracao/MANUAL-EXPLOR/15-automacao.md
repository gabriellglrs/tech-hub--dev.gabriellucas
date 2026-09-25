## Script de Automação — Rodar Tudo de Uma Vez

> **Este script automatiza as Fases 1 e 2 (e prepara as 3 e 4).** As Fases 5-7 (exploração, validação, relatório) exigem decisão humana — não são automatizadas de propósito. Salve como `exploit.sh`, execute como `./exploit.sh evilcorp`, e revise os resultados.

```bash
#!/bin/bash
# Script de Automação — Exploração (Fases 1-2 + preparo das 3-4)
# Uso: ./exploit.sh <alvo>
# Exemplo: ./exploit.sh evilcorp

# === CONFIGURAÇÃO ===
ALVO=$1
BASE_DIR="$HOME/recon/targets/$ALVO"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG="$BASE_DIR/logs/exploit_$TIMESTAMP.log"

# Cores
VERDE="\033[0;32m"
VERMELHO="\033[0;31m"
AMARELO="\033[1;33m"
RESET="\033[0m"

log() { echo -e "[$(date +%H:%M:%S)] ${VERDE}[+]${RESET} $1" | tee -a "$LOG"; }
erro() { echo -e "[$(date +%H:%M:%S)] ${VERMELHO}[!]${RESET} $1" | tee -a "$LOG"; }
aviso() { echo -e "[$(date +%H:%M:%S)] ${AMARELO}[!]${RESET} $1" | tee -a "$LOG"; }

# === VERIFICAÇÕES ===
if [ -z "$ALVO" ]; then
    echo "Uso: $0 <alvo>"
    echo "Exemplo: $0 evilcorp"
    exit 1
fi

if [ ! -d "$BASE_DIR" ]; then
    erro "Alvo não encontrado: $BASE_DIR"
    erro "Complete o Módulo 01 (reconhecimento) primeiro."
    exit 1
fi

for cmd in hydra john searchsploit cewl; do
    if ! command -v $cmd &> /dev/null; then
        erro "$cmd não encontrado — instale antes: sudo apt install $cmd"
        exit 1
    fi
done

cd "$BASE_DIR" || exit 1

# === CRIAR ESTRUTURA ===
log "Criando estrutura de exploração para $ALVO..."
mkdir -p {15-alimentacao,16-vetores,17-bruteforce,18-cracking,19-exploracao,20-validacao,21-relatorio,logs}
log "Estrutura criada em: $BASE_DIR"
echo ""

# === FASE 1: ALIMENTAÇÃO ===
log "========== FASE 1: ALIMENTAÇÃO (Módulos 01+02) =========="

log "1.1 — Verificando dados do Módulo 01..."
MISSING=0
for f in "02-enum/nmap-services.txt" "05-vulns/nmap-vuln.txt" "06-validacao/resumo-severidade.md"; do
    if [ -f "$f" ]; then
        log "  OK: $f"
    else
        erro "  FALTANDO: $f"
        MISSING=$((MISSING+1))
    fi
done
if [ $MISSING -gt 0 ]; then
    erro "Fase 1 incompleta — rode as fases do Módulo 01 correspondentes."
    exit 1
fi

log "1.2 — Extraindo serviços..."
grep "open" 02-enum/nmap-services.txt 2>/dev/null | grep -v "Nmap scan" | awk '{print $1": "$3" "$4}' > 15-alimentacao/alvos-servicos.txt

log "1.3 — Extraindo CVEs..."
grep -iE "CVE-|VULNERABLE" 05-vulns/nmap-vuln.txt 2>/dev/null | sort -u > 15-alimentacao/alvos-cve.txt
cp 06-validacao/resumo-severidade.md 15-alimentacao/severidade-recon.md 2>/dev/null

log "1.4 — Extraindo logins web (Módulo 02)..."
grep -iE "login|signin|admin|wp-login|auth|panel|dashboard" 04-discovery/gobuster-basico.txt 2>/dev/null \
  | awk '{print $2}' | sort -u > 15-alimentacao/alvos-login-web.txt

log "1.5 — Gerando usernames candidatos..."
grep -oE "^[a-zA-Z0-9._-]+@" 01-intel/theharvester.txt 2>/dev/null | sed 's/@.*//' | sort -u > 15-alimentacao/usernames-candidatos.txt
cat /usr/share/seclists/Usernames/top-usernames-shortlist.txt 15-alimentacao/usernames-candidatos.txt 2>/dev/null | sort -u > 15-alimentacao/usernames-todos.txt

log "1.6 — Consolidando hashes e credenciais..."
grep -rhoE "[a-f0-9]{32}|[a-f0-9]{40}|[a-f0-9]{64}" 01-intel/ 04-discovery/ 2>/dev/null | sort -u > 15-alimentacao/hashes-suspeitos.txt
grep -rhoiE "(password|passwd|pwd|secret|token|api_key)[\"' ]*[:=][\"' ]*[^\s\"']+" 04-discovery/ 2>/dev/null | sort -u > 15-alimentacao/credenciais-texto.txt
cp 04-discovery/js-secrets.txt 15-alimentacao/segredos-js.txt 2>/dev/null

log "1.7 — Gerando wordlist do alvo (CeWL)..."
cewl "http://$ALVO" -d 2 -m 5 -w 15-alimentacao/cewl-alvo.txt 2>/dev/null
cat /usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt 15-alimentacao/cewl-alvo.txt 2>/dev/null | sort -u > 15-alimentacao/wordlist-bruteforce.txt

SVC_COUNT=$(wc -l < 15-alimentacao/alvos-servicos.txt 2>/dev/null || echo "0")
USR_COUNT=$(wc -l < 15-alimentacao/usernames-todos.txt 2>/dev/null || echo "0")
HASH_COUNT=$(wc -l < 15-alimentacao/hashes-suspeitos.txt 2>/dev/null || echo "0")
log "Serviços: $SVC_COUNT | Usuários: $USR_COUNT | Hashes: $HASH_COUNT"
log "Fase 1 concluída."
echo ""

# === FASE 2: PRIORIZAÇÃO DE VETORES ===
log "========== FASE 2: PRIORIZAÇÃO DE VETORES =========="

log "2.1 — Searchsploit por CVE..."
grep -oE "CVE-[0-9]{4}-[0-9]+" 15-alimentacao/alvos-cve.txt 2>/dev/null | sort -u | while read cve; do
    echo "=== $cve ===" >> 16-vetores/searchsploit-cves.txt
    searchsploit --cve "$cve" >> 16-vetores/searchsploit-cves.txt 2>/dev/null
done

log "2.2 — Searchsploit por serviço..."
> 16-vetores/searchsploit-servicos.txt
grep -oiE "OpenSSH [0-9.]+|vsftpd [0-9.]+|Apache [0-9.]+|Samba [0-9.]+" 02-enum/nmap-services.txt 2>/dev/null \
  | sort -u | while read svc; do
    echo "=== $svc ===" >> 16-vetores/searchsploit-servicos.txt
    searchsploit $svc >> 16-vetores/searchsploit-servicos.txt 2>/dev/null
done

log "2.3 — Criando matriz de vetores..."
cat > 16-vetores/matriz-vetores.md << MATRIZ
# Matriz de Vetores — $ALVO (gerada automaticamente em $(date))

## Prioridade 1 — CVEs com exploit (PREENCHER manualmente a partir de searchsploit-cves.txt)
| Vetor | CVE/Exploit | Ferramenta | Fase | Status |
|-------|-------------|-----------|:----:|:------:|
(revise 16-vetores/searchsploit-cves.txt e preencha)

## Prioridade 2 — Brute force de serviço
$(grep "ssh\|ftp\|smb" 15-alimentacao/alvos-servicos.txt 2>/dev/null | sed 's/^/| /;s/$/ | Hydra | 3 | [ ] |/')

## Prioridade 3 — Brute force HTTP
$(sed 's/^/| /;s/$/ | Hydra http-post-form | 3 | [ ] |/' 15-alimentacao/alvos-login-web.txt 2>/dev/null)

## Prioridade 4 — Cracking
$(wc -l < 15-alimentacao/hashes-suspeitos.txt 2>/dev/null || echo "0") hash(s) pendente(s) → Fase 4

## Vetores descartados
| Vetor | Motivo |
|-------|--------|
| (preencher) | (preencher) |
MATRIZ

log "2.4 — Criando escopo (EDITE antes de atacar!)"
cat > 16-vetores/escopo.md << ESCOPO
# Escopo Autorizado — $ALVO

## IN (autorizado)
- [ ] Brute force em hosts do lab
- [ ] Exploração de CVEs em hosts do lab

## OUT (PROIBIDO)
- [ ] Produção de terceiros
- [ ] Contas reais de usuários
- [ ] DoS

⚠️  EDITE ESTE ARQUIVO ANTES DE RODAR QUALQUER HYDRA/METASPLOIT
ESCOPO

log "Fase 2 concluída."
echo ""

# === PREPARO DAS FASES 3 E 4 (não executa ataques!) ===
log "========== PREPARO DAS FASES 3 E 4 =========="

log "3.x — Listas prontas (o ATAQUE é manual, com escopo revisado):"
log "  Hydra SSH:  hydra -L 15-alimentacao/usernames-todos.txt -P 15-alimentacao/wordlist-bruteforce.txt -t 4 -f ssh://<IP>"
log "  Hydra HTTP: veja 09-fase3-bruteforce.md Passo 3.4 (precisa dos campos do form)"
log "  Cracking:   john --wordlist=... --rules 15-alimentacao/hashes-suspeitos.txt"
echo ""

# === RESUMO FINAL ===
log "============================================"
log "  ALIMENTAÇÃO E PRIORIZAÇÃO CONCLUÍDAS!"
log "============================================"
log ""
log "Estrutura: $BASE_DIR"
log ""
log "PRÓXIMOS PASSOS (MANUAIS):"
log "1. REVISE 16-vetores/escopo.md — confirme o que pode atacar"
log "2. PREENCHA 16-vetores/matriz-vetores.md com base nos searchsploit"
log "3. FASE 3 (manual): rode o Hydra conforme 09-fase3-bruteforce.md"
log "4. FASE 4 (manual): crackeie hashes conforme 10-fase4-cracking.md"
log "5. FASE 5 (manual): Metasploit conforme 11-fase5-exploracao.md"
log "6. FASES 6-7: valide e relate"
log ""
log "Total de arquivos:"
find "$BASE_DIR" -type f | wc -l
log ""
log "Logs: $LOG"
```

**Como usar:**
```bash
# Salvar
nano exploit.sh

# Tornar executável
chmod +x exploit.sh

# Rodar (com VPN ligada!)
nordvpn connect
./exploit.sh evilcorp

# Depois, revise manualmente:
cat 16-vetores/matriz-vetores.md
cat 16-vetores/escopo.md    # EDITE antes de qualquer ataque!
```

> ⚠️ **Por que o script para antes do ataque?** Hydra e Metasploit têm consequências reais (lockout, sessões abertas, impacto). Automação cega nessa etapa = contas travadas e escopo violado. As fases de decisão continuam manuais por design.

---
