## Script de Pré-requisitos — Testar Tudo Antes de Começar

> **Execute este script ANTES de começar qualquer fase.** Ele testa se TUDO está instalado e se os dados dos Módulos 01 e 02 existem. Se algo falhar, você sabe o que consertar antes de perder tempo.

```bash
#!/bin/bash
# Script de Pré-requisitos — Exploração
# Salve como: check-exploit.sh
# Execute como: chmod +x check-exploit.sh && ./check-exploit.sh

echo "============================================"
echo "  VERIFICAÇÃO DE PRÉ-REQUISITOS - EXPLORAÇÃO"
echo "============================================"
echo ""

ERROS=0

# Cores
VERDE="\033[0;32m"
VERMELHO="\033[0;31m"
AMARELO="\033[1;33m"
RESET="\033[0m"

ok() { echo -e "  ${VERDE}[OK]${RESET} $1"; }
erro() { echo -e "  ${VERMELHO}[ERRO]${RESET} $1"; ERROS=$((ERROS+1)); }
aviso() { echo -e "  ${AMARELO}[!]${RESET} $1"; }

echo "1. VERIFICANDO FERRAMENTAS DE EXPLORAÇÃO"
echo "-----------------------------------------"

for cmd in hydra john hashcat hashid medusa ncrack; do
    if command -v $cmd &> /dev/null; then
        ok "$cmd instalado ($(which $cmd))"
    else
        erro "$cmd NÃO encontrado — instale com: sudo apt install $cmd"
    fi
done

echo ""
echo "2. VERIFICANDO METASPLOIT E SEARCHSPLOIT"
echo "----------------------------------------"

if command -v msfconsole &> /dev/null; then
    ok "msfconsole instalado"
else
    erro "msfconsole NÃO encontrado — instale com: sudo apt install metasploit-framework"
fi

if command -v searchsploit &> /dev/null; then
    ok "searchsploit instalado"
else
    erro "searchsploit NÃO encontrado — instale com: sudo apt install exploitdb"
fi

echo ""
echo "3. VERIFICANDO FERRAMENTAS APOIO"
echo "--------------------------------"

for cmd in cewl crunch curl ncat unshadow; do
    if command -v $cmd &> /dev/null; then
        ok "$cmd instalado"
    else
        aviso "$cmd não encontrado — tente: sudo apt install $cmd"
    fi
done

echo ""
echo "4. VERIFICANDO WORDLISTS"
echo "------------------------"

if [ -f "/usr/share/seclists/Passwords/Top1000.txt" ]; then
    ok "Top1000.txt existe"
else
    erro "Top1000.txt NÃO encontrado — instale com: sudo apt install seclists"
fi

if [ -f "/usr/share/seclists/Usernames/top-usernames-shortlist.txt" ]; then
    ok "top-usernames-shortlist.txt existe"
else
    erro "usernames não encontrados — instale com: sudo apt install seclists"
fi

if [ -f "/usr/share/wordlists/rockyou.txt" ]; then
    ok "rockyou.txt existe (descompactado)"
else
    aviso "rockyou.txt não encontrado — descompacte: sudo gzip -d /usr/share/wordlists/rockyou.txt.gz"
fi

echo ""
echo "5. VERIFICANDO DADOS DOS MÓDULOS 01 E 02 (obrigatório)"
echo "-------------------------------------------------------"

ALVO_DIR="$HOME/recon/targets"

if [ ! -d "$ALVO_DIR" ]; then
    erro "$ALVO_DIR não existe — complete o Módulo 01 primeiro"
else
    # Pega a primeira pasta de alvo existente
    ALVO=$(ls -d "$ALVO_DIR"/*/ 2>/dev/null | head -1)
    if [ -z "$ALVO" ]; then
        erro "Nenhum alvo em $ALVO_DIR — rode o recon do Módulo 01 primeiro"
    else
        ok "Alvo encontrado: $(basename $ALVO)"

        for f in "02-enum/nmap-services.txt" "05-vulns/nmap-vuln.txt" "06-validacao/resumo-severidade.md"; do
            if [ -f "$ALVO$f" ]; then
                ok "Dado do Módulo 01: $f"
            else
                erro "FALTANDO: $ALVO$f — complete a fase correspondente do Módulo 01"
            fi
        done
    fi
fi

echo ""
echo "6. VERIFICANDO REDE E AUTORIZAÇÃO"
echo "---------------------------------"

if curl -s --max-time 5 https://ifconfig.me > /dev/null 2>&1; then
    IP=$(curl -s https://ifconfig.me)
    ok "Internet funcionando (IP: $IP)"
else
    erro "Sem conexão com a internet"
fi

if command -v nordvpn &> /dev/null; then
    if nordvpn status | grep -q "Connected"; then
        ok "NordVPN conectado"
    else
        aviso "NordVPN instalado mas NÃO conectado — reconecte antes de atacar"
    fi
fi

echo ""
echo "============================================"
if [ $ERROS -eq 0 ]; then
    echo -e "${VERDE}TUDO CERTO! Pode começar a exploração.${RESET}"
else
    echo -e "${VERMELHO}Foram encontrados $ERROS ERROS. Corrija antes de começar.${RESET}"
fi
echo "============================================"
```

**Como usar:**
```bash
# Salvar o script
nano check-exploit.sh
# (cole o script acima)

# Tornar executável
chmod +x check-exploit.sh

# Rodar
./check-exploit.sh
```

**Se tudo der verde → pode começar. Se tiver vermelho → conserte antes.**

**Se passou no verde → Avance para [05 - Guia de Wordlists](05-wordlists.md)**

---
