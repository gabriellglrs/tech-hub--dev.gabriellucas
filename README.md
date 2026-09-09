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
| 🐳 **Docker & Kubernetes** | Containers, Dockerfile, Compose, K8s, Helm | ✅ Estrutura |
| 🌐 **Redes** | TCP/IP avançado, firewalls, VPNs | ✅ Estrutura |
| 💾 **Banco de Dados** | SQL, NoSQL, administração | ✅ Estrutura |
| 💻 **Programação** | Python, Bash, automação, APIs | ✅ Estrutura |
| ☁️ **Cloud** | AWS, Azure, GCP, segurança cloud | ✅ Estrutura |
| 🐧 **Linux Admin** | Servidores, systemd, hardening | ✅ Estrutura |
| 🪟 **Windows Admin** | AD, GPO, PowerShell avançado | ✅ Estrutura |
| 🔄 **Git Avançado** | Branching, hooks, workflows | ✅ Estrutura |
| 🚀 **CI/CD** | GitHub Actions, Jenkins, DevSecOps | ✅ Estrutura |
| 📊 **Monitoramento** | Prometheus, Grafana, ELK Stack | ✅ Estrutura |
| 🔧 **Infra como Código** | Terraform, Ansible, compliance | ✅ Estrutura |
| 🌐 **Web Dev** | HTML, CSS, JS, APIs, OWASP | ✅ Estrutura |
| 🔐 **Criptografia** | PKI, TLS, GPG, pós-quântica | ✅ Estrutura |
| 🦠 **Malware Analysis** | Engenharia reversa, YARA, sandboxes | ✅ Estrutura |
| 🕵️ **Threat Intelligence** | OSINT, MITRE ATT&CK, threat hunting | ✅ Estrutura |
| 📱 **Mobile Security** | Android, iOS, APK analysis, Frida | ✅ Estrutura |
| 🌐 **IoT Security** | Firmware, ICS/SCADA, hardware hacking | ✅ Estrutura |
| 💾 **Backup & Recovery** | rsync, borg, DR plan, RTO/RPO | ✅ Estrutura |

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
├── cyberseguranca/             # 🛡️ Trilha de Cybersegurança (✅)
├── cloud/                      # ☁️ AWS, Azure, GCP
├── linux-admin/                # 🐧 Administração Linux
├── windows-admin/              # 🪟 Active Directory, GPO
├── git-avancado/               # 🔄 Branches, hooks, workflows
├── cicd/                       # 🚀 GitHub Actions, Jenkins
├── monitoramento/              # 📊 Prometheus, Grafana, ELK
├── infra-codigo/               # 🔧 Terraform, Ansible
├── web-dev/                    # 🌐 HTML, CSS, JS, APIs
├── criptografia-avancada/      # 🔐 PKI, TLS, GPG
├── malware-analysis/           # 🦠 YARA, Ghidra, sandboxes
├── threat-intelligence/        # 🕵️ OSINT, MITRE, hunting
├── mobile-security/            # 📱 Android, iOS, Frida
├── iot-security/               # 🌐 Firmware, ICS, UART
├── backup-recovery/            # 💾 rsync, borg, DR plan
├── docker-k8s/                 # 🐳 Docker + Kubernetes
├── redes/                      # 🌐 TCP/IP, firewalls, VPN
├── banco-de-dados/             # 💾 SQL, NoSQL, admin
└── programacao/                # 💻 Python, Bash, APIs
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

## 📚 Todas as Áreas

### ☁️ Cloud
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Cloud](cloud/README.md) | AWS, Azure, GCP, segurança cloud, Pacu, Prowler |

### 🐧 Administração Linux
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Linux Admin](linux-admin/README.md) | Servidores, systemd, users, hardening, logs |

### 🪟 Administração Windows
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Windows Admin](windows-admin/README.md) | Active Directory, GPO, PowerShell avançado, Sysmon |

### 🔄 Git Avançado
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Git Avançado](git-avancado/README.md) | Branching, GitFlow, rebase, hooks, bisect |

### 🚀 CI/CD
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [CI/CD](cicd/README.md) | GitHub Actions, Jenkins, DevSecOps, container scanning |

### 📊 Monitoramento
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Monitoramento](monitoramento/README.md) | Prometheus, Grafana, ELK Stack, alertas |

### 🔧 Infraestrutura como Código
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [IaC](infra-codigo/README.md) | Terraform, Ansible, compliance como código |

### 🌐 Web Development
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Web Dev](web-dev/README.md) | HTML, CSS, JavaScript, APIs, OWASP Top 10 |

### 🔐 Criptografia Avançada
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Criptografia](criptografia-avancada/README.md) | PKI, TLS/SSL, GPG, criptografia de disco, pós-quântica |

### 🦠 Análise de Malware
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Malware](malware-analysis/README.md) | Engenharia reversa, YARA, sandboxes, Ghidra |

### 🕵️ Threat Intelligence
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Threat Intel](threat-intelligence/README.md) | OSINT avançado, MITRE ATT&CK, threat hunting |

### 📱 Mobile Security
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Mobile](mobile-security/README.md) | Android, iOS, APK analysis, Frida, ssl pinning |

### 🌐 IoT Security
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [IoT](iot-security/README.md) | Firmware, ICS/SCADA, hardware hacking, RTL-SDR |

### 💾 Backup & Recovery
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Backup](backup-recovery/README.md) | rsync, borgbackup, DR plan, RTO/RPO |

### 🐳 Docker e Kubernetes
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Docker & K8s](docker-k8s/README.md) | Containers, Dockerfile, Compose, Kubernetes, Helm |

### 🌐 Redes
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Redes](redes/README.md) | TCP/IP avançado, firewalls, VPNs, troubleshooting |

### 💾 Banco de Dados
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Banco de Dados](banco-de-dados/README.md) | SQL, NoSQL, administração, SQL Injection |

### 💻 Programação
| Arquivo | O que você vai aprender |
|:--------|:------------------------|
| [Programação](programacao/README.md) | Python, Bash, automação, APIs REST |

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
