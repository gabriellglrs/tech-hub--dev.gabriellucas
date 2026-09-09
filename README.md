<div align="center">

# 🐧 Minhas Config Linux Terminal

### Zsh + Oh My Zsh + Powerlevel10k pronto pra dev e cyberseg

**zsh • p10k • fzf • zoxide • eza • bat • ripgrep + toolkit cyberseg completo**

</div>

---

## 👀 Preview

> Dica: tire um print com `fastfetch` + `ll` e salve como `docs/preview.png`

Prompt atual: segmento OS + `~` (esquerda) + `✔ at HH:MM:SS` (direita) — estilo `lean` powerline.

---

## 📂 O que vem no repo?

```
minhas_config_linux_terminal/
├── install.sh        # instalador automático com backup
├── .gitignore
├── zsh/
│   ├── .zshrc        # <-- seu ~/.zshrc exportado do Ubuntu
│   └── .p10k.zsh     # <-- seu ~/.p10k.zsh (p10k configure)
└── docs/
    ├── 01-reconhecimento.md     # nmap, masscan, whois, dig
    ├── 02-webapp-testing.md     # gobuster, ffuf, nikto, sqlmap
    ├── 03-brute-force.md        # hydra, john, hashcat
    ├── 04-sniffing-rede.md      # wireshark, tcpdump, netcat, socat
    ├── 05-proxy-anonimato.md    # proxychains4, tor
    ├── 06-post-exploracao.md    # impacket
    ├── 07-go-tools.md           # subfinder, nuclei, httpx
    ├── 08-wordlists.md          # seclists
    └── 09-dev-tools.md          # fzf, fd, bat, eza, zoxide, ripgrep
```

| Arquivo | Vai para |
|:---|:---|
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.p10k.zsh` | `~/.p10k.zsh` |

---

## ✅ Pré-requisitos

- Ubuntu 22.04/24.04
- Fonte Nerd Font (JetBrainsMono NF) selecionada no terminal
- `git`

## 🚀 Instalação em 30 segundos (máquina nova)

```bash
git clone https://github.com/gabriellglrs/minhas_config_linux_terminal.git
cd minhas_config_linux_terminal
chmod +x install.sh

./install.sh            # só base dev (zsh, plugins, ferramentas dev)
./install.sh --sec      # base + cyberseg (todas as ferramentas abaixo)
exec zsh
```

> **Extras já inclusos:** `autojump` (navegação rápida), `delta` (git diff bonito), `tldr` (exemplos de comandos)

> Só copiar sem instalar nada:
> ```bash
> ./install.sh --copy-only
> ```

## 💾 Exportar sua config atual (no Ubuntu onde já está pronto)

Rode **no Ubuntu com o terminal configurado**:

```bash
cd ~/minhas_config_linux_terminal  # ou onde você clonou
cp ~/.zshrc ./zsh/.zshrc
cp ~/.p10k.zsh ./zsh/.p10k.zsh 2>/dev/null || echo "sem .p10k.zsh (rode p10k configure)"
# opcional: lista de pacotes pra documentar
dpkg --get-selections | grep -E "zsh|fzf|ripgrep|bat|eza|zoxide" > docs/packages.txt
git add zsh/.zshrc zsh/.p10k.zsh
git commit -m "feat: exporta zsh + p10k do Ubuntu"
git push
```

Depois pra editar e salvar de volta:
```bash
cp ~/.zshrc ./zsh/.zshrc
git add . && git commit -m "feat: atualiza zshrc" && git push
```

---

## 📚 Guias das Ferramentas

### 🛡️ Cybersegurança (`--sec`)

| Guia | Ferramentas | Descrição |
|:---|:---|:---|
| [📡 Reconhecimento](docs/01-reconhecimento.md) | nmap, masscan, whois, dig, ping, theharvester, dnsrecon | Mapear o alvo |
| [🌐 Web App Testing](docs/02-webapp-testing.md) | gobuster, ffuf, nikto, sqlmap, whatweb, wafw00f, wpscan | Testar aplicações web |
| [🔑 Brute Force](docs/03-brute-force.md) | hydra, john, hashcat, hashid | Quebrar senhas e hashes |
| [🕵️ Sniffing e Rede](docs/04-sniffing-rede.md) | wireshark, tcpdump, netcat, socat | Analisar tráfego |
| [🔒 Proxy e Anonimato](docs/05-proxy-anonimato.md) | proxychains4, tor, responder, bettercap, mitmproxy | Trafegar anônimo e MITM |
| [🔧 Pós-Exploração](docs/06-post-exploracao.md) | impacket, enum4linux-ng | Movimentação lateral |
| [🚀 Go Tools](docs/07-go-tools.md) | subfinder, nuclei, httpx | Pipeline de recon |
| [📦 Wordlists](docs/08-wordlists.md) | seclists, crunch, cewl | Listas para brute force |

### 🛠️ Ferramentas Dev (base)

| Guia | Ferramentas | Descrição |
|:---|:---|:---|
| [🛠️ Dev Tools](docs/09-dev-tools.md) | fzf, fd, bat, eza, zoxide, ripgrep | Produtividade no terminal |

---

## 🛡️ Resumo das Ferramentas Cyberseg

### 📡 Reconhecimento
| Ferramenta | Para quê |
|:---|:---|
| **nmap** | Scanner de portas e serviços |
| **masscan** | Scanner ultrarrápido de portas |
| **whois** | Info de domínio e IP |
| **dig** | Consulta e enumeração DNS |
| **dnsrecon** | Enumeração DNS profunda |
| **theharvester** | Coletar emails e subdomínios |
| **ping** | Teste de conectividade |

### 🌐 Web App Testing
| Ferramenta | Para quê |
|:---|:---|
| **gobuster** | Brute force de diretórios/subdomínios |
| **ffuf** | Fuzzing web avançado |
| **nikto** | Scanner de vulnerabilidades web |
| **sqlmap** | Detecção e exploração de SQL Injection |
| **whatweb** | Fingerprinting de tecnologias |
| **wafw00f** | Detecção de WAF |
| **wpscan** | Scanner para WordPress |

### 🔑 Brute Force
| Ferramenta | Para quê |
|:---|:---|
| **hydra** | Brute force de login (SSH, FTP, HTTP, etc) |
| **john** | Cracking de hashes |
| **hashcat** | Cracking de hashes com GPU |
| **hashid** | Identificar tipo de hash |

### 🕵️ Sniffing
| Ferramenta | Para quê |
|:---|:---|
| **wireshark** | Análise gráfica de pacotes |
| **tcpdump** | Sniff de pacotes via terminal |
| **netcat** | Conexões, reverse shells, transferências |
| **socat** | Netcat com SSL, proxy, port forwarding |

### 🔒 Proxy e MITM
| Ferramenta | Para quê |
|:---|:---|
| **proxychains4** | Forçar apps a usar proxy |
| **tor** | Rede anônima |
| **responder** | Poisoning LLMNR/NBT-NS (captura hashes) |
| **bettercap** | MITM, ARP spoofing, DNS spoofing |
| **mitmproxy** | Proxy interativo para análise HTTPS |

### 🔧 Pós-Exploração
| Ferramenta | Para quê |
|:---|:---|
| **impacket** | Protocolos Windows/SMB, credenciais |
| **enum4linux-ng** | Enumeração SMB/Windows completa |

### 🚀 Go Tools
| Ferramenta | Para quê |
|:---|:---|
| **subfinder** | Enumeração de subdomínios |
| **nuclei** | Scanner de vulnerabilidades com templates |
| **httpx** | Verificar URLs ativas |

### 📦 Wordlists
| Ferramenta | Para quê |
|:---|:---|
| **seclists** | Coleção completa de wordlists |
| **crunch** | Gerar wordlists por padrão |
| **cewl** | Gerar wordlist a partir de sites |

---

## 🛠️ Problemas comuns

| Sintoma | Solução |
|:---|:---|
| Ícones quebrados `�` | instale Nerd Font + selecione no terminal |
| `fd/bat não encontrado` | no Ubuntu é `fdfind/batcat` — o install.sh já cria link em `~/.local/bin` |
| Shell ainda é bash | `chsh -s $(which zsh)` + logout/login |
| Prompt quebrou após copiar | `p10k configure` e depois re-exporte com `cp ~/.p10k.zsh ./zsh/.p10k.zsh` |
| Nmap sem permissão | `sudo nmap` ou `sudo setcap cap_net_raw,cap_net_admin+eip $(which nmap)` |
| Hydra lento | reduza `-t` (threads), ex: `-t 4` |
| SQLMap bloqueado | use `--delay=1` ou `--random-agent` |
| Wireshark sem permissão | `sudo usermod -aG wireshark $USER` + logout/login |
| Proxychains não funciona | edite `/etc/proxychains4.conf` e configure o proxy correto |
| Go tools não instaladas | veja [Go Tools](docs/07-go-tools.md) |

---

## 🔄 Manutenção

```bash
# atualizar plugins/tema
git -C ~/.oh-my-zsh/custom/themes/powerlevel10k pull
git -C ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions pull
git -C ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting pull

# atualizar ferramentas cyberseg
sudo apt update && sudo apt upgrade -y

# atualizar nuclei templates
nuclei -update-templates

# atualizar wordlists seclists
sudo apt install -y seclists --reinstall

# reconfigurar p10k
p10k configure
```

---

## ⚠️ Aviso Legal

Todas as ferramentas e técnicas documentadas aqui são para uso em **ambientes autorizados e legais**. Sempre obtenha permissão antes de testar em qualquer sistema. O autor não se responsabiliza pelo uso indevido.
