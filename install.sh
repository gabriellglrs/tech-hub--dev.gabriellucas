#!/usr/bin/env bash
# Instala e restaura o setup Zsh + Powerlevel10k (Ubuntu)
# Uso:
#   git clone https://github.com/gabriellglrs/minhas_config_linux_terminal.git
#   cd minhas_config_linux_terminal
#   ./install.sh --sec        # base + ferramentas cyberseg (apt)
#   ./install.sh --copy-only   # só copia .zshrc/.p10k sem apt
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
COPY_ONLY=false
WITH_SEC=false
for arg in "$@"; do
  [[ "$arg" == "--copy-only" ]] && COPY_ONLY=true
  [[ "$arg" == "--sec" ]] && WITH_SEC=true
done

step(){ echo -e "\n==> $1"; }

if [[ ! -f "$REPO_ROOT/zsh/.zshrc" ]]; then
  echo "AVISO: zsh/.zshrc não encontrado no repo. Exporte primeiro do seu Ubuntu:"
  echo "  cp ~/.zshrc \"$REPO_ROOT/zsh/.zshrc\""
  echo "  cp ~/.p10k.zsh \"$REPO_ROOT/zsh/.p10k.zsh\" 2>/dev/null || true"
  exit 1
fi

if ! $COPY_ONLY; then
  step "Instalando pacotes base via apt..."
  sudo apt update
  sudo apt install -y zsh git curl wget fzf fd-find ripgrep bat eza zoxide python3-pip unzip fontconfig autojump git-delta tldr 2>/dev/null || \
  sudo apt install -y zsh git curl wget fzf fd-find ripgrep bat eza zoxide python3-pip unzip fontconfig
  # fd/bat no Ubuntu chamam fdfind/batcat -> cria alias local
  mkdir -p ~/.local/bin
  command -v fdfind >/dev/null && ln -sf "$(command -v fdfind)" ~/.local/bin/fd 2>/dev/null || true
  command -v batcat >/dev/null && ln -sf "$(command -v batcat)" ~/.local/bin/bat 2>/dev/null || true

  step "Oh My Zsh (se não existir)..."
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  else
    echo " - oh-my-zsh já instalado"
  fi

  step "Powerlevel10k + plugins..."
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" || echo " - p10k já existe"
  [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] && git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || echo " - autosuggestions já existe"
  [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] && git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || echo " - syntax-highlighting já existe"
  [[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]] && git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions" || echo " - completions já existe"

  step "Nerd Font (JetBrainsMono)..."
  if ! fc-list | grep -qi "JetBrainsMono.*Nerd"; then
    mkdir -p ~/.local/share/fonts
    cd /tmp && curl -fLo JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -o JetBrainsMono.zip -d ~/.local/share/fonts >/dev/null
    fc-cache -fv ~/.local/share/fonts
    echo " -> selecione a fonte 'JetBrainsMono Nerd Font' no seu terminal"
  else
    echo " - Nerd Font já instalada"
  fi

  if $WITH_SEC; then
    step "Ferramentas cyberseg via apt..."
    sudo apt update
    sudo apt install -y nmap masscan sqlmap nikto hydra john hashcat \
      wireshark tcpdump netcat-openbsd socat whois dnsutils iputils-ping \
      proxychains4 gobuster ffuf python3-impacket seclists \
      whatweb dnsrecon mitmproxy bettercap enum4linux \
      hashid crunch cewl 2>/dev/null || \
    sudo apt install -y nmap sqlmap nikto hydra john hashcat \
      tcpdump netcat-openbsd socat whois dnsutils proxychains4 \
      whatweb dnsrecon mitmproxy hashid

    step "Ferramentas cyberseg via pip..."
    sudo pip3 install --break-system-packages wafw00f theHarvester 2>/dev/null || \
    sudo pip3 install wafw00f theHarvester 2>/dev/null || true

    step "Ferramentas cyberseg via Git..."
    # enum4linux-ng
    if ! command -v enum4linux-ng >/dev/null 2>&1; then
      if [[ ! -d "/opt/enum4linux-ng" ]]; then
        sudo git clone --depth=1 https://github.com/cddmp/enum4linux-ng.git /opt/enum4linux-ng 2>/dev/null || true
        if [[ -d "/opt/enum4linux-ng" ]]; then
          cd /opt/enum4linux-ng && sudo pip3 install -r requirements.txt 2>/dev/null || true
          sudo ln -sf /opt/enum4linux-ng/enum4linux-ng.py /usr/local/bin/enum4linux-ng 2>/dev/null || true
          cd - >/dev/null
        fi
      fi
    fi

    # Responder
    if ! command -v responder >/dev/null 2>&1; then
      if [[ ! -d "/opt/Responder" ]]; then
        sudo git clone --depth=1 https://github.com/lgandx/Responder.git /opt/Responder 2>/dev/null || true
        if [[ -d "/opt/Responder" ]]; then
          sudo ln -sf /opt/Responder/Responder.py /usr/local/bin/responder 2>/dev/null || true
        fi
      fi
    fi

    # wpscan
    if ! command -v wpscan >/dev/null 2>&1; then
      sudo apt install -y wpscan 2>/dev/null || \
      sudo gem install wpscan 2>/dev/null || true
    fi

    echo ""
    echo " -> extras via Go (subfinder/nuclei/httpx) instale sob demanda:"
    echo "    sudo apt install -y golang-go"
    echo "    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    echo "    go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
    echo "    go install github.com/projectdiscovery/httpx/cmd/httpx@latest"
  else
    echo ""
    echo "Dica cyberseg: rode ./install.sh --sec para instalar nmap/sqlmap/nikto/hydra/john/hashcat/wireshark/tcpdump/nc/socat/gobuster/ffuf/whatweb/wafw00f/responder/bettercap/mitmproxy/enum4linux (+ seclists/impacket/hashid/crunch/cewl se disponível)."
    echo "Extras: autojump (j pasta), delta (git diff bonito), tldr (exemplos rápidos)."
  fi
fi

backup_copy(){
  src="$1"; dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -f "$dst" ]]; then
    bak="$dst.backup-$(date +%Y%m%d-%H%M).bak"
    cp "$dst" "$bak"
    echo "   backup: $bak"
  fi
  cp "$src" "$dst"
  echo "   copiado: $src -> $dst"
}

step "Copiando .zshrc e .p10k.zsh (com backup)..."
backup_copy "$REPO_ROOT/zsh/.zshrc" "$HOME/.zshrc"
if [[ -f "$REPO_ROOT/zsh/.p10k.zsh" ]]; then
  backup_copy "$REPO_ROOT/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
fi

# troca shell padrão pra zsh se preciso
if [[ "${SHELL:-}" != *"zsh" ]]; then
  step "Trocando shell padrão para zsh..."
  chsh -s "$(command -v zsh)" || echo "rode manualmente: chsh -s \$(which zsh)"
fi

step "Pronto! Reabra o terminal ou rode: exec zsh"
echo "Teste: p10k configure (para reconfigurar), ll, gs, ff"
