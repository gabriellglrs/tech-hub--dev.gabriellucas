## Script de Pré-requisitos — Testar Tudo Antes de Começar

> **Execute este script ANTES de começar qualquer fase.** Ele testa se TUDO está instalado e funcionando. Se algo falhar, você sabe o que consertar antes de perder tempo.

```bash
#!/bin/bash
# Script de Pré-requisitos — Reconhecimento
# Salve como: check-recon.sh
# Execute como: chmod +x check-recon.sh && ./check-recon.sh

echo "============================================"
echo "  VERIFICAÇÃO DE PRÉ-REQUISITOS - RECON"
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

echo "1. VERIFICANDO FERRAMENTAS BÁSICAS"
echo "-----------------------------------"

for cmd in nmap curl dig whois jq; do
    if command -v $cmd &> /dev/null; then
        ok "$cmd instalado ($(which $cmd))"
    else
        erro "$cmd NÃO encontrado — instale com: sudo apt install $cmd"
    fi
done

echo ""
echo "2. VERIFICANDO FERRAMENTAS GO"
echo "------------------------------"

if command -v go &> /dev/null; then
    ok "Go instalado ($(go version))"
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
else
    erro "Go NÃO encontrado — instale com: sudo apt install golang"
fi

for cmd in subfinder httpx nuclei katana dnsx gau waybackurls; do
    if command -v $cmd &> /dev/null || [ -f "$HOME/go/bin/$cmd" ]; then
        ok "$cmd instalado"
    else
        aviso "$cmd não encontrado — tente: go install github.com/projectdiscovery/$cmd/cmd/$cmd@latest"
    fi
done

echo ""
echo "3. VERIFICANDO FERRAMENTAS KALI"
echo "--------------------------------"

for cmd in gobuster ffuf nikto wpscan wafw00f ncat theHarvester proxychains4 masscan; do
    if command -v $cmd &> /dev/null; then
        ok "$cmd instalado"
    else
        aviso "$cmd não encontrado — tente: sudo apt install $cmd"
    fi
done

echo ""
echo "4. VERIFICANDO WORDLISTS"
echo "------------------------"

if [ -f "/usr/share/wordlists/dirb/common.txt" ]; then
    ok "common.txt existe"
else
    erro "common.txt NÃO encontrado — instale com: sudo apt install seclists"
fi

if [ -d "/usr/share/seclists" ]; then
    ok "SecLists instalado"
else
    erro "SecLists NÃO encontrado — instale com: sudo apt install seclists"
fi

echo ""
echo "5. VERIFICANDO REDE"
echo "-------------------"

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
        aviso "NordVPN instalado mas NÃO conectado — reconecte antes de escanear"
    fi
fi

if command -v tor &> /dev/null; then
    if systemctl is-active --quiet tor; then
        ok "Tor rodando"
    else
        aviso "Tor instalado mas NÃO rodando — inicie com: sudo systemctl start tor"
    fi
fi

echo ""
echo "6. VERIFICANDO GO PATH"
echo "----------------------"

if [ -d "$HOME/go/bin" ]; then
    COUNT=$(ls $HOME/go/bin 2>/dev/null | wc -l)
    ok "$COUNT ferramentas Go encontradas em $HOME/go/bin"
else
    aviso "Diretório $HOME/go/bin não existe — crie com: mkdir -p ~/go/bin"
fi

echo ""
echo "============================================"
if [ $ERROS -eq 0 ]; then
    echo -e "${VERDE}TUDO CERTO! Pode começar o reconhecimento.${RESET}"
else
    echo -e "${VERMELHO}Foram encontrados $ERROS ERROS. Corrija antes de começar.${RESET}"
fi
echo "============================================"
```

**Como usar:**
```bash
# Salvar o script
nano check-recon.sh
# (cole o script acima)

# Tornar executável
chmod +x check-recon.sh

# Rodar
./check-recon.sh
```

**Se tudo der verde → pode começar. Se tiver vermelho → conserte antes.**

---
