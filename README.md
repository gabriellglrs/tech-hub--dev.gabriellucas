<div align="center">

# 🐧 Minhas Config Linux Terminal

### Configuração profissional + Trilha completa de Cybersegurança

**Zsh • Powerlevel10k • Ferramentas Dev • Toolkit Cyberseg • Docker • Redes • BD**

</div>

---

## 🎯 O que é este repo?

Este é meu **repositório pessoal** com tudo que preciso para trabalhar com tecnologia:

| Área | O que tem | Status |
|:-----|:----------|:------:|
| 🖥️ **Terminal** | Configuração Zsh, Powerlevel10k, plugins | ✅ Pronto |
| 🛡️ **Cybersegurança** | Trilha completa (11 módulos, 40+ arquivos) | ✅ Pronto |
| 🐳 **Docker** | Containers, Dockerfile, Compose | 🚧 Planejado |
| 🌐 **Redes** | Fundamentos, troubleshooting, comandos | 🚧 Planejado |
| 💾 **Banco de Dados** | SQL, NoSQL, administração | 🚧 Planejado |
| 💻 **Programação** | Python, Bash, automação | 🚧 Planejado |

---

## 📂 Estrutura do Repo

```
minhas_config_linux_terminal/
│
├── install.sh                  # Instalador automático
├── zsh/
│   ├── .zshrc                  # Config do Zsh
│   └── .p10k.zsh               # Config do Powerlevel10k
│
├── cyberseguranca/             # 🛡️ Trilha de Cybersegurança
│   ├── README.md               # Índice da trilha
│   ├── GLOSSARIO.md            # 150+ termos explicados
│   ├── INSTALACAO.md           # Guia de instalação de ferramentas
│   ├── CHEATSHEET-*.md         # 3 cheatsheets rápidas
│   │
│   ├── 00-pre-requisitos/      # 📚 Para iniciantes totais
│   │   ├── 01-redes/           # IP, DNS, portas, TCP/IP
│   │   ├── 02-sistemas/        # Linux, HTTP, VMs
│   │   ├── 03-seguranca/       # CIA, malware, Python, Windows
│   │   └── 04-ferramentas/     # Comandos de rede, editores
│   │
│   ├── 01-reconhecimento/      # Nmap, DNS enum, OSINT
│   ├── 02-web-aplicacoes/      # Web, API, DB, SQL Injection, XSS
│   ├── 03-exploracao/          # Hydra, John, Hashcat
│   ├── 04-pos-exploracao/      # LinPEAS, escalação, pivoting
│   ├── 05-reversing/           # Ghidra, GDB, buffer overflow
│   ├── 06-analise-rede/        # tcpdump, Wireshark, MITM
│   ├── 07-defesa/              # Firewalls, IDS/IPS, SIEM
│   ├── 08-resposta/            # Forense, malware, Volatility
│   ├── 09-ambientes/           # Docker, K8s, Cloud, Wireless
│   └── 10-governanca/          # GRC, Criptografia, LGPD
│
├── docker/                     # 🐳 Docker (planejado)
├── redes/                      # 🌐 Redes (planejado)
├── banco-de-dados/             # 💾 BD (planejado)
└── programacao/                # 💻 Prog (planejado)
```

---

## 🖥️ Terminal Config

### O que vem instalado

| Categoria | Ferramentas |
|:----------|:------------|
| **Shell** | Zsh + Oh My Zsh + Powerlevel10k |
| **Navegação** | fzf, zoxide, autojump |
| **Visualização** | eza (ls), bat (cat), delta (git diff) |
| **Busca** | ripgrep (rg), fd |
| **Documentação** | tldr |
| **Git** | delta, alias otimizados |

### Instalação

```bash
git clone https://github.com/gabriellglrs/minhas_config_linux_terminal.git
cd minhas_config_linux_terminal
chmod +x install.sh

./install.sh            # Só base dev
./install.sh --sec      # Base + cyberseg (todas as ferramentas)
./install.sh --copy-only  # Só copiar configs (sem instalar)
exec zsh
```

---

## 🛡️ Trilha de Cybersegurança

Trilha completa **do zero ao profissional**, seguindo a ordem real de ataque e defesa (OSCP, CEH, NIST).

### Visão geral

```
FASE 0: PRÉ-REQUISITOS (para quem não sabe nada)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   00. Pré-Requisitos (13 arquivos, ~7-8h)
       Redes → Linux → VMs → Segurança → Python → Windows

FASE 1: FUNDAMENTOS
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   01. Reconhecimento      → Descobrir o alvo
   02. Web & Aplicações    → Entender aplicações web
   03. Exploração          → Quebrar e entrar

FASE 2: INTERMEDIÁRIO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   04. Pós-Exploração      → Escalar e persistir
   05. Engenharia Reversa  → Entender binários
   06. Análise de Rede     → Capturar tráfego

FASE 3: DEFESA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   07. Defesa & Hardening  → Proteger sistemas
   08. Resposta a Incidentes → Investigar ataques

FASE 4: ESPECIALIZAÇÃO
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   09. Ambientes Especiais → Cloud, Docker, Mobile
   10. Governança          → GRC, Criptografia, LGPD
```

### Módulos detalhados

| # | Módulo | Arquivos | Tempo | O que você vai aprender |
|:--|:-------|:--------:|:-----:|:------------------------|
| 0 | [Pré-Requisitos](cyberseguranca/00-pre-requisitos/) | 13 | 7-8h | Redes, Linux, VMs, Python, Windows |
| 1 | [Reconhecimento](cyberseguranca/01-reconhecimento/) | 2 + Labs | 3-4h | Nmap, DNS enum, OSINT, subdomínios |
| 2 | [Web & Aplicações](cyberseguranca/02-web-aplicacoes/) | 8 + Labs | 8-10h | Web, API, DB, SQL Injection, XSS |
| 3 | [Exploração](cyberseguranca/03-exploracao/) | 2 + Labs | 4-5h | Hydra, John, Hashcat, brute force |
| 4 | [Pós-Exploração](cyberseguranca/04-pos-exploracao/) | 2 + Labs | 5-6h | LinPEAS, escalação, pivoting |
| 5 | [Engenharia Reversa](cyberseguranca/05-reversing/) | 2 + Labs | 6-8h | Ghidra, GDB, buffer overflow |
| 6 | [Análise de Rede](cyberseguranca/06-analise-rede/) | 2 + Labs | 4-5h | tcpdump, Wireshark, MITM |
| 7 | [Defesa & Hardening](cyberseguranca/07-defesa/) | 2 + Labs | 5-6h | Firewalls, IDS/IPS, SIEM |
| 8 | [Resposta a Incidentes](cyberseguranca/08-resposta/) | 2 + Labs | 5-7h | Forense, malware, Volatility |
| 9 | [Ambientes Especiais](cyberseguranca/09-ambientes/) | 3 + Labs | 6-8h | Docker, K8s, Cloud, Wireless |
| 10 | [Governança](cyberseguranca/10-governanca/) | 2 + Labs | 4-5h | GRC, ISO 27001, LGPD |

**Total: 11 módulos • 40+ arquivos • 78+ exercícios • ~60-70 horas**

### Plataformas de prática

| Plataforma | O que é | Link |
|:-----------|:--------|:----:|
| **TryHackMe** | Salas guiadas para iniciantes | [tryhackme.com](https://tryhackme.com) |
| **HackTheBox** | Máquinas para pentest | [hackthebox.com](https://hackthebox.com) |
| **PortSwigger** | Labs de web security | [portswigger.net](https://portswigger.net/web-security) |
| **OverTheWire** | Desafios de Linux | [overthewire.org](https://overthewire.org) |
| **PicoCTF** | CTF para iniciantes | [picoctf.org](https://picoctf.org) |

### Extras

| Arquivo | Descrição |
|:--------|:----------|
| [GLOSSARIO.md](cyberseguranca/GLOSSARIO.md) | 150+ termos de segurança explicados |
| [INSTALACAO.md](cyberseguranca/INSTALACAO.md) | Guia completo de instalação de ferramentas |
| [CHEATSHEET-recon-web.md](cyberseguranca/CHEATSHEET-recon-web.md) | Recon e web rapidinho |
| [CHEATSHEET-exploracao.md](cyberseguranca/CHEATSHEET-exploracao.md) | Exploração e pós-exp |
| [CHEATSHEET-defesa-forense.md](cyberseguranca/CHEATSHEET-defesa-forense.md) | Defesa e forense |

---

## 🐳 Docker (planejado)

| Tópico | Descrição |
|:-------|:----------|
| 01 - Básico | O que é container, Docker Engine, comandos essenciais |
| 02 - Dockerfile | Criar imagens, multi-stage builds, boas práticas |
| 03 - Compose | Multi-container, redes, volumes |
| 04 - Segurança | Scanning de imagens, rootless, secrets |

---

## 🌐 Redes (planejado)

| Tópico | Descrição |
|:-------|:----------|
| 01 - Fundamentos | TCP/IP, OSI, roteamento, switches |
| 02 - Comandos | ip, ss, ping, traceroute, nslookup |
| 03 - Troubleshooting | Diagnosticar e resolver problemas |
| 04 - Segurança | Firewalls, VPN, segmentação |

---

## 💾 Banco de Dados (planejado)

| Tópico | Descrição |
|:-------|:----------|
| 01 - SQL básico | CREATE, SELECT, JOIN, índices |
| 02 - Administração | Usuários, permissões, backup |
| 03 - NoSQL | MongoDB, Redis, quando usar |
| 04 - Segurança | SQL Injection, hardening |

---

## 💻 Programação (planejado)

| Tópico | Descrição |
|:-------|:----------|
| 01 - Python básico | Variáveis, funções, bibliotecas |
| 02 - Python para Sec | Scripts de automação, scanning |
| 03 - Bash scripting | Automação no terminal |
| 04 - APIs | Consumir e criar APIs REST |

---

## 🛠️ Problemas comuns

| Sintoma | Solução |
|:--------|:--------|
| Ícones quebrados | Instale Nerd Font + selecione no terminal |
| `fd/bat não encontrado` | No Ubuntu é `fdfind/batcat` — o install.sh cria symlink |
| Shell ainda é bash | `chsh -s $(which zsh)` + logout/login |
| Prompt quebrou | `p10k configure` |
| Nmap sem permissão | `sudo nmap` ou `sudo setcap cap_net_raw,cap_net_admin+eip $(which nmap)` |
| Hydra lento | Reduza `-t 4` (threads) |
| SQLMap bloqueado | Use `--delay=1` ou `--random-agent` |
| Wireshark sem permissão | `sudo usermod -aG wireshark $USER` + logout |

---

## 🔄 Manutenção

```bash
# Atualizar plugins/tema
git -C ~/.oh-my-zsh/custom/themes/powerlevel10k pull
git -C ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions pull
git -C ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting pull

# Atualizar ferramentas
sudo apt update && sudo apt upgrade -y

# Atualizar nuclei templates
nuclei -update-templates

# Reconfigurar p10k
p10k configure
```

---

## ⚠️ Aviso Legal

Todas as ferramentas e técnicas documentadas aqui são para uso em **ambientes autorizados e legais**. Sempre obtenha permissão antes de testar em qualquer sistema.

---

<div align="center">

**Comece agora →** [Módulo 0: Pré-Requisitos](cyberseguranca/00-pre-requisitos/) (se é iniciante) ou [Módulo 1: Reconhecimento](cyberseguranca/01-reconhecimento/) (se já tem base)

</div>
