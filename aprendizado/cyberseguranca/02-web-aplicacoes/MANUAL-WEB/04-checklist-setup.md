## Script de Pré-requisitos — Testar Tudo Antes de Começar

> **Execute este script ANTES de começar qualquer fase.** Ele testa se TUDO está instalado e se os dados do Módulo 01 existem. Se algo falhar, você sabe o que consertar antes de perder tempo.

```bash
#!/bin/bash
# Script de Pré-requisitos — Testes Web
# Salve como: check-web.sh
# Execute como: chmod +x check-web.sh && ./check-web.sh

echo "============================================"
echo "  VERIFICAÇÃO DE PRÉ-REQUISITOS - TESTE WEB"
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

echo "1. VERIFICANDO SISTEMA"
echo "----------------------"

if lsb_release -a 2>/dev/null | grep -qi kali; then
    ok "Kali Linux instalado"
else
    aviso "Não é Kali — muitas ferramentas exigem instalação manual"
fi

if java -version 2>&1 | head -1 | grep -qE "17|21"; then
    ok "Java 17+ instalado (necessário para Burp)"
else
    erro "Java 17+ NÃO encontrado — sudo apt install openjdk-17-jdk"
fi

echo ""
echo "2. VERIFICANDO BURP E FERRAMENTAS WEB"
echo "-------------------------------------"

for cmd in burpsuite sqlmap gobuster whatweb curl nikto; do
    if command -v $cmd &> /dev/null; then
        ok "$cmd instalado"
    else
        erro "$cmd NÃO encontrado — sudo apt install $cmd"
    fi
done

for cmd in ffuf httpx nuclei; do
    if command -v $cmd &> /dev/null; then
        ok "$cmd instalado"
    else
        erro "$cmd NÃO encontrado — go install (veja 03-setup-ferramentas.md)"
    fi
done

echo ""
echo "3. VERIFICANDO WORDLISTS"
echo "------------------------"

if [ -f "/usr/share/seclists/Discovery/Web-Content/common.txt" ]; then
    ok "common.txt existe"
else
    erro "common.txt NÃO encontrado — sudo apt install seclists"
fi

if [ -f "/usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt" ]; then
    ok "burp-parameter-names.txt existe"
else
    erro "burp-parameter-names.txt NÃO encontrado — sudo apt install seclists"
fi

if ls ~/.cache/nuclei-templates/http >/dev/null 2>&1 || [ -d "$HOME/nuclei-templates" ]; then
    ok "Templates do Nuclei baixados"
else
    aviso "Templates ausentes — rode: nuclei -update-templates"
fi

echo ""
echo "4. VERIFICANDO DADOS DO MÓDULO 01 (obrigatório)"
echo "------------------------------------------------"

ALVO_DIR="$HOME/recon/targets"

if [ ! -d "$ALVO_DIR" ]; then
    erro "$ALVO_DIR não existe — complete o Módulo 01 primeiro"
else
    ALVO=$(ls -d "$ALVO_DIR"/*/ 2>/dev/null | head -1)
    if [ -z "$ALVO" ]; then
        erro "Nenhum alvo em $ALVO_DIR — rode o recon do Módulo 01 primeiro"
    else
        ok "Alvo encontrado: $(basename $ALVO)"

        for f in "02-enum/vivos-filtrados.txt" "04-discovery/urls-com-parametros.txt" "04-discovery/gobuster-basico.txt"; do
            if [ -f "$ALVO$f" ]; then
                ok "Dado do Módulo 01: $f"
            else
                aviso "Ausente: $ALVO$f — a Fase 1 vai avisar se for crítico"
            fi
        done

        if [ -f "$ALVO/04-discovery/js-secrets.txt" ] && [ -s "$ALVO/04-discovery/js-secrets.txt" ]; then
            aviso "js-secrets.txt tem conteúdo — documente como achado CRÍTICO (Fase 1)"
        fi
    fi
fi

echo ""
echo "5. VERIFICANDO REDE E AUTORIZAÇÃO"
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
        aviso "NordVPN instalado mas NÃO conectado — reconecte antes de testar"
    fi
fi

if [ -f "$ALVO/escopo-web.md" ]; then
    ok "escopo-web.md existe (Fase 1)"
else
    aviso "escopo-web.md ainda não criado — a Fase 1 cria"
fi

echo ""
echo "============================================"
if [ $ERROS -eq 0 ]; then
    echo -e "${VERDE}TUDO CERTO! Pode começar o teste web.${RESET}"
else
    echo -e "${VERMELHO}Foram encontrados $ERROS ERROS. Corrija antes de começar.${RESET}"
fi
echo "============================================"
```

**Como usar:**
```bash
# Salvar o script
nano check-web.sh
# (cole o script acima)

# Tornar executável
chmod +x check-web.sh

# Rodar
./check-web.sh
```

**Se tudo der verde → pode começar. Se tiver vermelho → conserte antes.**

**Se passou no verde → Avance para [05 - Guia de Wordlists](05-wordlists.md)**

---
