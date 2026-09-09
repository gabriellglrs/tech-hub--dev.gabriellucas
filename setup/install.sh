#!/usr/bin/env bash
# Instala e restaura o setup Zsh + Powerlevel10k (Ubuntu/WSL2)
# Uso:
#   git clone https://github.com/gabriellglrs/tech-hub--dev.gabriellucas.git
#   cd tech-hub--dev.gabriellucas
#   ./install.sh            # base dev (zsh, plugins, ferramentas dev)
#   ./install.sh --sec      # base + cyberseg
#   ./install.sh --copy-only # só copia .zshrc/.p10k sem apt
#   ./install.sh --wsl      # otimizações específicas para WSL2
set -euo pipefail
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
COPY_ONLY=false
WITH_SEC=false
WITH_WSL=false
for arg in "$@"; do
  [[ "$arg" == "--copy-only" ]] && COPY_ONLY=true
  [[ "$arg" == "--sec" ]] && WITH_SEC=true
  [[ "$arg" == "--wsl" ]] && WITH_WSL=true
done

step(){ echo -e "\n==> $1"; }
success(){ echo -e "  \033[32m✓\033[0m $1"; }
warn(){ echo -e "  \033[33m!\033[0m $1"; }
error(){ echo -e "  \033[31m✗\033[0m $1"; }

# Verificar se é WSL2
is_wsl() {
  grep -qi microsoft /proc/version 2>/dev/null
}

if [[ ! -f "$REPO_ROOT/zsh/.zshrc" ]]; then
  error "zsh/.zshrc não encontrado no repo. Exporte primeiro do seu Ubuntu:"
  echo "  cp ~/.zshrc \"$REPO_ROOT/zsh/.zshrc\""
  echo "  cp ~/.p10k.zsh \"$REPO_ROOT/zsh/.p10k.zsh\" 2>/dev/null || true"
  exit 1
fi

if ! $COPY_ONLY; then
  step "Instalando pacotes base via apt..."
  sudo apt update
  sudo apt install -y zsh git curl wget fzf fd-find ripgrep bat eza zoxide \
    python3-pip unzip fontconfig autojump git-delta tldr tree htop unzip 2>/dev/null || \
  sudo apt install -y zsh git curl wget fzf fd-find ripgrep bat eza zoxide \
    python3-pip unzip fontconfig autojump

  # fd/bat no Ubuntu chamam fdfind/batcat -> cria symlink local
  mkdir -p ~/.local/bin
  command -v fdfind >/dev/null && ln -sf "$(command -v fdfind)" ~/.local/bin/fd 2>/dev/null || true
  command -v batcat >/dev/null && ln -sf "$(command -v batcat)" ~/.local/bin/bat 2>/dev/null || true
  success "Pacotes base instalados"

  step "Glow (renderizador de markdown no terminal)..."
  if ! command -v glow >/dev/null 2>&1 && [[ ! -f ~/.local/bin/glow ]]; then
    GLOW_VERSION="2.0.0"
    curl -sL "https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_Linux_x86_64.tar.gz" | tar xz -C /tmp/
    mv "/tmp/glow_${GLOW_VERSION}_Linux_x86_64/glow" ~/.local/bin/glow
    rm -rf "/tmp/glow_${GLOW_VERSION}_Linux_x86_64"
    success "Glow instalado"
  else
    success "Glow já existe"
  fi

  step "Oh My Zsh..."
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    success "Oh My Zsh instalado"
  else
    success "Oh My Zsh já existe"
  fi

  step "Powerlevel10k + plugins..."
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  [[ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]] && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k" && \
    success "Powerlevel10k instalado" || success "Powerlevel10k já existe"

  [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && \
    success "zsh-autosuggestions instalado" || success "zsh-autosuggestions já existe"

  [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" && \
    success "zsh-syntax-highlighting instalado" || success "zsh-syntax-highlighting já existe"

  [[ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]] && \
    git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions" && \
    success "zsh-completions instalado" || success "zsh-completions já existe"

  step "Nerd Font (JetBrainsMono)..."
  if ! fc-list | grep -qi "JetBrainsMono.*Nerd"; then
    mkdir -p ~/.local/share/fonts
    cd /tmp && curl -fLo JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" 2>/dev/null
    unzip -o JetBrainsMono.zip -d ~/.local/share/fonts >/dev/null 2>&1
    fc-cache -fv ~/.local/share/fonts >/dev/null 2>&1
    success "Nerd Font instalada - selecione 'JetBrainsMono Nerd Font' no terminal"
  else
    success "Nerd Font já instalada"
  fi

  if $WITH_WSL; then
    step "Otimizações WSL2..."
    # Habilitar integração com Windows
    if ! grep -q "alias pbcopy" ~/.zshrc 2>/dev/null; then
      cat >> ~/.zshrc << 'EOF'

# ── WSL2 Integrations ────────────────────────────────────────
alias pbcopy='clip.exe'
alias pbpaste='powershell.exe -command "Get-Clipboard"'
EOF
    fi
    success "WSL2 integrations configuradas"
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
    success "Ferramentas cyberseg (apt) instaladas"

    step "Ferramentas cyberseg via pip..."
    sudo pip3 install --break-system-packages wafw00f theHarvester 2>/dev/null || \
    sudo pip3 install wafw00f theHarvester 2>/dev/null || true
    success "Ferramentas cyberseg (pip) instaladas"

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
    success "Ferramentas cyberseg (git) instaladas"

    echo ""
    echo "Extras via Go (subfinder/nuclei/httpx) instale sob demanda:"
    echo "  sudo apt install -y golang-go"
    echo "  go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest"
    echo "  go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest"
    echo "  go install github.com/projectdiscovery/httpx/cmd/httpx@latest"
  else
    echo ""
    warn "Dica cyberseg: rode ./install.sh --sec para instalar ferramentas de segurança"
    warn "Dica WSL: rode ./install.sh --wsl para integração com Windows"
  fi
fi

backup_copy(){
  src="$1"; dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -f "$dst" ]]; then
    bak="$dst.backup-$(date +%Y%m%d-%H%M%S).bak"
    cp "$dst" "$bak"
    success "Backup criado: $bak"
  fi
  cp "$src" "$dst"
  success "Copiado: $src -> $dst"
}

step "Copiando .zshrc e .p10k.zsh (com backup)..."
backup_copy "$REPO_ROOT/zsh/.zshrc" "$HOME/.zshrc"
if [[ -f "$REPO_ROOT/zsh/.p10k.zsh" ]]; then
  backup_copy "$REPO_ROOT/zsh/.p10k.zsh" "$HOME/.p10k.zsh"
fi

# troca shell padrão pra zsh se preciso
if [[ "${SHELL:-}" != *"zsh" ]]; then
  step "Trocando shell padrão para zsh..."
  chsh -s "$(command -v zsh)" || warn "Rode manualmente: chsh -s \$(which zsh)"
fi

step "Instalação concluída!"
echo ""
success "Pronto! Reabra o terminal ou rode: exec zsh"
echo ""
echo "Comandos úteis:"
echo "  comandos        - guia de Linux do básico ao avançado"
echo "  cyberseg        - guia de comandos de cybersegurança"
echo "  p10k configure  - reconfigurar o prompt"
echo "  ll              - listagem detalhada"
echo "  gs              - git status"
echo "  tldrf           - buscar exemplos de comandos"
echo "  extract arquivo - extrair qualquer formato"
echo "  bak arquivo     - backup rápido"
echo "  mkcd pasta      - criar e entrar na pasta"
