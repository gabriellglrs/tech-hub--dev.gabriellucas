# 📋 Manual Completo de Reconhecimento — Checklist Operacional

> **Este é o arquivo mais importante deste módulo.** É nele que você vai consultar enquanto executa cada passo do reconhecimento. Cada fase é explicada com o que fazer, por quê, como, o output esperado, e o que fazer se der errado.

<div align="center">

**Objetivo final:** Mapear TODA a superfície de ataque de um alvo.

**Regra de ouro:** Nunca pule um passo. Cada fase alimenta a próxima.

**Tempo estimado completo:** 4 a 8 horas (dependendo do escopo)

</div>

---

## Índice

1. [Conhecimentos Mínimos — O que saber antes de começar](#conhecimentos-mínimos)
2. [Antes de Começar — Conceitos e Preparação](#antes-de-começar)
3. [Ferramentas Necessárias](#ferramentas-necessárias)
4. [Setup de Rede — VPN, Tor e ProxyChains](#setup-de-rede)
5. [Script de Pré-requisitos — Testar Tudo Antes de Começar](#script-de-pré-requisitos)
6. [Guia de Wordlists — Qual Usar para Cada Cenário](#guia-de-wordlists)
7. [OPSEC — Não Deixar Rastros](#opsec)
8. [Fase 1 — Inteligência Passiva](#fase-1)
9. [Fase 2 — Enumeração Ativa](#fase-2)
10. [Fase 3 — Fingerprinting](#fase-3)
11. [Fase 4 — Discovery de Conteúdo](#fase-4)
12. [Fase 5 — Scan de Vulnerabilidades](#fase-5)
13. [Fase 6 — Análise e Validação](#fase-6)
14. [Fase 7 — Relatório](#fase-7)
15. [Script de Automação — Rodar Tudo de Uma Vez](#script-de-automação)
16. [Alvos para Praticar — Onde Treinar](#alvos-para-praticar)
17. [Guia de Validação Manual — Como Confirmar um Achado](#guia-de-validação-manual)
18. [Apêndice A — Troubleshooting](#apendice-a)
19. [Apêndice B — Referência Rápida](#apendice-b)
20. [Apêndice C — O que fazer se NADA funcionar](#apendice-c)

---

## Conhecimentos Mínimos — O que você precisa saber ANTES de começar

> **Este manual NÃO é para quem nunca usou um computador.** Antes de seguir, verifique se você tem os conhecimentos mínimos listados abaixo. Se não tiver, estude primeiro os links indicados — senão vai travar no primeiro passo.

### 1. Linux / Terminal (OBRIGATÓRIO)

Você PRECISA saber usar o terminal do Linux. Este manual inteiro é comandos de terminal.

| Habilidade | O que é | Como testar se sabe | Onde estudar se não sabe |
|------------|---------|---------------------|--------------------------|
| Abrir terminal | Abrir o "prompt de comandos" | Consegue abrir com `Ctrl+Alt+T` no Kali | [TryHackMe: Linux Fundamentals](https://tryhackme.com/room/linuxfundamentalspart1) |
| Navegar pastas | `cd`, `ls`, `pwd` | Consegue ir de uma pasta para outra | [OverTheWire: Bandit Nível 0-5](https://overthewire.org/wargames/bandit/) |
| Criar/mover/copiar arquivos | `mkdir`, `cp`, `mv`, `rm` | Consegue criar uma pasta e colocar um arquivo dentro | [LinuxJourney: File Commands](https://linuxjourney.com/lesson/files-hierarchy) |
| Ler arquivos | `cat`, `less`, `head`, `tail` | Consegue ler o conteúdo de um arquivo no terminal | [LinuxJourney: Text Commands](https://linuxjourney.com/lesson/text-processing) |
| Editar arquivos | `nano` ou `vim` | Consegue criar e salvar um arquivo com nano | [TryHackMe: Linux Fundamentals Part 2](https://tryhackme.com/room/linuxfundamentalspart2) |
| Redirecionar output | `>`, `>>`, `|` | Sabe que `comando > arquivo` salva output em arquivo | [Bash Guide: Redirection](https://tldp.org/LDP/abs/html/io-redirection.html) |
| Chained commands | `&&`, `;` | Sabe que `comando1 && comando2` roda os dois em sequência | [Explainshell: &&](https://explainshell.com/) |
| Permissões | `chmod`, `sudo` | Sabe o que é `chmod +x` e quando usar `sudo` | [LinuxJourney: Permissions](https://linuxjourney.com/lesson/file-permissions) |
| Instalar pacotes | `apt install` | Consegue instalar um pacote com sudo | [Kali Docs: Package Management](https://www.kali.org/docs/arm/kali-linux-linear-package-management/) |

**Teste rápido:** Consegue fazer isso no terminal?
```bash
mkdir -p ~/test recon && cd ~/test recon
echo "hello" > arquivo.txt
cat arquivo.txt
chmod +x arquivo.txt
rm -rf ~/test recon
```
Se conseguiu → está pronto. Se não → estude os links acima primeiro.

### 2. Redes (OBRIGATÓRIO)

Você PRECISA entender como a internet funciona. Este manual escaneia redes inteiras.

| Conceito | O que é | Por que importa aqui | Onde estudar |
|----------|---------|---------------------|-------------|
| **IP** | Endereço de uma máquina na rede | Todo scan começa por IP | [TryHackMe: Intro to Networking](https://tryhackme.com/room/introtonetworking) |
| **Porta** | "Porta de entrada" de um serviço | Nmap escaneia portas | [TryHackMe: Nmap](https://tryhackme.com/room/rnmap) |
| **DNS** | Traduz nomes em IPs | Subfinder/discovery depende disso | [TryHackMe: DNS](https://tryhackme.com/room/dnsindetail) |
| **HTTP/HTTPS** | Protocolo da web | Todo scan web é HTTP | [MDN: HTTP](https://developer.mozilla.org/pt-BR/docs/Web/HTTP) |
| **Status codes** | 200, 301, 403, 404 | Precisa entender o que cada um significa | [MDN: HTTP Status](https://developer.mozilla.org/pt-BR/docs/Web/HTTP/Status) |
| **TCP/UDP** | Protocolos de transporte | Nmap usa TCP e UDP | [TryHackMe: Intro to Networking](https://tryhackme.com/room/introtonetworking) |
| **CIDR** | Range de IPs (ex: /24) | WHOIS retorna ranges em CIDR | [IPSubnetter: CIDR](https://www.ipaddressguide.com/cidr.asp) |

**Teste rápido:** Responda sem pesquisar:
1. Qual a porta do HTTP? **80**
2. Qual a porta do HTTPS? **443**
3. Qual a porta do SSH? **22**
4. O que significa status 403? **Acesso negado**
5. O que DNS faz? **Traduz nome para IP**
6. O que é `192.168.1.0/24`? **Range de 256 IPs**

Se respondeu 5 ou 6 → está pronto. Se não → estude os links acima.

### 3. Web (OBRIGATÓRIO)

Você PRECISA entender como sites funcionam. Este manual escaneia aplicações web.

| Conceito | O que é | Por que importa aqui | Onde estudar |
|----------|---------|---------------------|-------------|
| **URL** | Endereço de uma página | Gobuster/ffuf testam URLs | [MDN: URL](https://developer.mozilla.org/pt-BR/docs/Learn/Common_questions/What_is_a_URL) |
| **Parâmetros** | `?chave=valor` na URL | SQLi/XSS atacam parâmetros | [PortSwigger: What is SSRF](https://portswigger.net/web-security/ssrf) |
| **Headers** | Metadados HTTP | WhatWeb/headers revelam tecnologias | [MDN: Headers](https://developer.mozilla.org/pt-BR/docs/Web/HTTP/Headers) |
| **Cookies** | Dados salvos no navegador | Sessões, autenticação | [PortSwigger: Cookies](https://portswigger.net/web-security/csrf) |
| **CMS** | WordPress, Joomla, Drupal | WPScan é específico para CMS | [WhatIs: CMS](https://computer.howstuffworks.com/cms.htm) |
| **API** | Interface de programação | APIs expostas são alvos | [TryHackMe: API Sec](https://tryhackme.com/room/api) |
| **DOM** | Estrutura HTML do site | XSS ataca o DOM | [MDN: DOM](https://developer.mozilla.org/pt-BR/docs/Web/API/Document_Object_Model) |

### 4. Segurança (MÍNIMO)

Você PRECISA saber o que é uma vulnerabilidade. Este manual encontra vulnerabilidades.

| Conceito | O que é | Onde estudar |
|----------|---------|-------------|
| **Vulnerabilidade** | Falha no sistema que pode ser explorada | [TryHackMe: Jr Pentester](https://tryhackme.com/path/outline/jr-penetration-tester) |
| **Exploit** | Código que explora uma vulnerabilidade | [TryHackMe: Metasploit](https://tryhackme.com/room/metasploitintro) |
| **CVE** | Identificador único de vulnerabilidade | [CVE.org](https://www.cve.org/) |
| **WAF** | Firewall que bloqueia ataques web | [OWASP: WAF](https://owasp.org/www-community/Defense_Install) |
| **Payload** | Código malicioso enviado ao alvo | [TryHackMe: Burp Suite](https://tryhackme.com/room/burpsuitebasics) |
| **SQLi** | Injeção SQL | [PortSwigger: SQLi](https://portswigger.net/web-security/sql-injection) |
| **XSS** | Cross-Site Scripting | [PortSwigger: XSS](https://portswigger.net/web-security/cross-site-scripting) |
| **Recon** | Fase de coleta de informações | **Este módulo!** |

### 5. Ferramentas (MÍNIMO)

Você PRECISA saber usar pelo menos o básico de:

| Ferramenta | Nível mínimo | Onde estudar |
|------------|-------------|-------------|
| **Terminal** | Criar pastas, ler arquivos, rodar comandos | Acima |
| **Navegador** | Abrir URLs, ver source code, F12 | [Chrome DevTools](https://developer.chrome.com/docs/devtools/) |
| **curl** | Fazer requests HTTP | [curl.se: Tutorial](https://curl.se/docs/tutorial.html) |
| **nano** | Editar arquivos no terminal | [LinuxJourney: nano](https://linuxjourney.com/lesson/file-manipulation) |

---

### Resumo: O que você precisa saber

```
✅ CONHECIMENTOS MÍNIMOS:
├── Linux: criar pastas, ler/editar arquivos, redirecionar output
├── Redes: IP, porta, DNS, HTTP, status codes, TCP/UDP
├── Web: URL, parâmetros, headers, cookies, CMS
├── Segurança: o que é vulnerabilidade, exploit, CVE
└── Ferramentas: terminal, navegador, curl, nano

❌ SE NÃO SABE ISSO:
├── Não vai conseguir rodar os comandos
├── Não vai entender os outputs
├── Não vai saber interpretar os achados
└── Estude os links acima PRIMEIRO, depois volte aqui
```

**Tempo estimado para aprender o mínimo:** 1-2 semanas (se nunca usou Linux)
**Se já usa Linux:** Pule direto para a próxima seção

---

## Antes de Começar

### O que é Reconhecimento?

Reconhecimento (recon) é a fase de **coleta de informações** antes de qualquer ataque. É como um ladrão que observa uma casa antes de entrar: ele sabe quantas portas tem, quais janelas estão abertas, que horas os moradores saem.

Em segurança ofensiva, reconhecimento significa:
- Descobrir quais domínios e IPs pertencem ao alvo
- Identificar quais serviços estão rodando
- Encontrar portas de entrada (diretórios, APIs, subdomínios)
- Saber quais tecnologias o alvo usa (para buscar vulnerabilidades conhecidas)

### Por que NÃO pular fases?

Se você pular a Fase 1 (inteligência passiva) e ir direto para scan de portas, você pode:
- Perder subdomínios inteiros que não estão no DNS público
- Não encontrar APIs internas expostas
- Gastar horas escaneando IP errado

**Cada fase gera dados que alimentam a próxima.** Pular fases = trabalhar no escuro.

### Conceitos que você PRECISA saber antes de começar

| Conceito | O que é | Exemplo |
|----------|---------|---------|
| **Domínio** | Nome de um site | `evilcorp.com` |
| **Subdomínio** | Parte do domínio | `admin.evilcorp.com`, `staging.evilcorp.com` |
| **IP** | Endereço de uma máquina na rede | `192.168.1.100` |
| **Porta** | "Porta de entrada" de um serviço | Porta 80 = web, 22 = SSH, 443 = HTTPS |
| **Serviço** | Programa rodando na porta | Apache, Nginx, OpenSSH, MySQL |
| **WAF** | Firewall que bloqueia ataques | Cloudflare, AWS WAF, ModSecurity |
| **CMS** | Sistema que gerencia o site | WordPress, Joomla, Drupal |
| **CVE** | Vulnerabilidade conhecida catalogada | CVE-2024-1234 |
| **Wordlist** | Lista de palavras para brute force | common.txt, rockyou.txt |
| **OSINT** | Informações públicas sobre o alvo | Whois, Google, redes sociais |
| **Banner** | Texto que identifica um serviço | `SSH-2.0-OpenSSH_8.9p1` |

---

### Preparação do Ambiente

Execute cada item abaixo ANTES de começar qualquer scan. Marque com ☑ quando concluir.

| # | O que fazer | Comando | Por quê | ☑ |
|---|-------------|---------|---------|:---:|
| 1 | Criar estrutura de pastas | `mkdir -p ~/recon/{targets,results,logs}` | Organizar tudo por alvo | [ ] |
| 2 | Criar pasta do alvo | `mkdir -p ~/recon/targets/ALVO` | Manter dados separados | [ ] |
| 3 | Entrar na pasta do alvo | `cd ~/recon/targets/ALVO` | Todo trabalho ficará aqui | [ ] |
| 4 | Atualizar sistema | `sudo apt update && sudo apt upgrade -y` | Ferramentas atualizadas | [ ] |
| 5 | Instalar SecLists (wordlists) | `sudo apt install seclists -y` | Necessário para brute force | [ ] |
| 6 | Verificar ferramentas | Veja seção "Ferramentas Necessárias" abaixo | Garantir que tudo funciona | [ ] |
| 7 | Anotar o escopo | Escrever em arquivo: domínios IN e OUT | Saber o que pode escanear | [ ] |

**Depois de criar a pasta, sua estrutura deve parecer:**
```
~/recon/
├── targets/
│   └── evilcorp/              ← pasta do alvo (troque "evilcorp" pelo nome real)
│       ├── 01-intel/          ← Fase 1: WHOIS, DNS, subdomínios, OSINT
│       │   └── (vazia — será preenchida na Fase 1)
│       ├── 02-enum/           ← Fase 2: validação de subs, portas, serviços
│       │   └── (vazia — será preenchida na Fase 2)
│       ├── 03-fingerprint/    ← Fase 3: tecnologias, WAF, versões
│       │   └── (vazia — será preenchida na Fase 3)
│       ├── 04-discovery/      ← Fase 4: diretórios, arquivos, endpoints
│       │   └── (vazia — será preenchida na Fase 4)
│       ├── 05-vulns/          ← Fase 5: vulnerabilidades encontradas
│       │   └── (vazia — será preenchida na Fase 5)
│       ├── 06-validacao/      ← Fase 6: validação manual dos achados
│       │   └── (vazia — será preenchida na Fase 6)
│       └── 07-relatorio/      ← Fase 7: relatório final
│           └── (vazia — será preenchida na Fase 7)
├── results/
└── logs/
```

> **Importante:** Cada fase PREENCHE a sua pasta com arquivos. Ao final do curso, você vai ter ~35-40 arquivos organizados por fase. Cada arquivo alimenta as fases seguintes.

**Crie as subpastas agora:**
```bash
mkdir -p 01-intel 02-enum 03-fingerprint 04-discovery 05-vulns 06-validacao 07-relatorio
```

---

### Ferramentas Necessárias

Verifique se cada ferramenta está instalada. Se alguma não estiver, instale-a.

| Ferramenta | Para que serve | Como verificar | Como instalar se faltar |
|------------|---------------|----------------|------------------------|
| `subfinder` | Subdomínios passivos | `subfinder -version` | `sudo apt install subfinder` |
| `amass` | Subdomínios profundos | `amass -version` | `sudo apt install amass` |
| `httpx` | Validar subdomínios vivos | `httpx -version` | `sudo apt install httpx` |
| `nmap` | Scan de portas | `nmap --version` | `sudo apt install nmap` |
| `masscan` | Scan rápido em massa | `masscan --version` | `sudo apt install masscan` |
| `whatweb` | Identificar tecnologias | `whatweb --version` | `sudo apt install whatweb` |
| `gobuster` | Encontrar diretórios | `gobuster version` | `sudo apt install gobuster` |
| `ffuf` | Fuzzing avançado | `ffuf -V` | `sudo apt install ffuf` |
| `nuclei` | Scan de vulnerabilidades | `nuclei -version` | `sudo apt install nuclei` |
| `wafw00f` | Detectar WAF | `wafw00f --version` | `sudo apt install wafw00f` |
| `nikto` | Scanner web vulnerabilidades | `nikto -Version` | `sudo apt install nikto` |
| `wpscan` | Scanner WordPress | `wpscan --version` | `sudo apt install wpscan` |
| `ncat` | Banner grabbing | `ncat --version` | `sudo apt install ncat` |
| `curl` | Requests HTTP | `curl --version` | `sudo apt install curl` |
| `dig` | Consultas DNS | `dig -v` | `sudo apt install dnsutils` |
| `whois` | Informações do domínio | `whois --version` | `sudo apt install whois` |
| `theHarvester` | OSINT de subdomínios | `theHarvester -h` | `sudo apt install theharvester` |
| `proxychains4` | Anonimato | `proxychains4 --version` | `sudo apt install proxychains4` |

---

## Setup de Rede — VPN, Tor e ProxyChains

> **Antes de escanear QUALQUER coisa, configure sua rede.** Se você escanear com seu IP real, seu ISP vai bloquear você em minutos, e o alvo vai ter seu IP nos logs para sempre.

### Por que isso importa?

Quando você faz `nmap -sT -p- --min-rate 5000 alvo.com`, o alvo recebe **milhares de pacotes** do seu IP. Isso:
- **Aciona IDS/IPS** do alvo (ele sabe que está sendo escaneado)
- **Registra seu IP** nos logs do servidor
- **Pode ser ilegal** se não tiver autorização
- **Seu ISP pode bloquear** sua conexão

### Opção 1: VPN (RECOMENDADO)

A melhor opção. Esconde seu IP real e criptografa todo o tráfego.

```bash
# Instalar NordVPN (gratuito por 30 dias, depois R$25/mês)
# Acesse: https://nordvpn.com/download/linux/
wget https://downloads.nordcdn.com/apps/linux/install.sh
sh install.sh

# Conectar (deixe rodando durante TODOS os scans)
nordvpn connect

# Verificar se funciona
curl -s https://ifconfig.me
# Deve mostrar o IP da VPN, não o seu IP real

# Desconectar quando terminar
nordvpn disconnect
```

**Alternativas gratuitas:**
| VPN | Limite | Como usar |
|-----|--------|-----------|
| **ProtonVPN** | 10GB/mês | `sudo apt install protonvpn` |
| **Windscribe** | 10GB/mês | App no site oficial |
| **Mullvad** | 5€/mês (sem limite) | App no site oficial |

### Opção 2: Tor (para Fase 1 apenas)

Tor é bom para inteligência passiva, mas **NÃO serve para scans ativos** (é muito lento).

```bash
# Instalar Tor
sudo apt install tor

# Iniciar Tor
sudo systemctl start tor

# Configurar ProxyChains para usar Tor
sudo nano /etc/proxychains4.conf
# Mude para: socks4 127.0.0.1 9050

# Testar
proxychains4 curl -s https://ifconfig.me
# Deve mostrar um IP diferente (Tor exit node)
```

### Opção 3: ProxyChains (para scans leves)

Funciona com Tor ou com qualquer proxy. Bom para Fase 1 e 2 (não para scans pesados).

```bash
# Instalar
sudo apt install proxychains4

# Configurar
sudo nano /etc/proxychains4.conf
# No final, mude:
# socks4 127.0.0.1 9050    ← para Tor
# ou
# socks5 SEU_PROXY PORTA    ← para proxy externo

# Usar (adicione "proxychains4" antes de qualquer comando)
proxychains4 subfinder -d evilcorp.com -silent
proxychains4 theHarvester -d evilcorp.com -b google
proxychains4 nmap -sT -Pn -p 80,443 evilcorp.com
```

### ⚠️ Regras de ouro de rede:

| Regra | Por quê |
|-------|---------|
| **SEMPRE use VPN para scans ativos** | Evita ban de ISP e rastreamento |
| **Use Tor apenas para passivo** | Tor é lento demais para Nmap |
| **Se banido, mude de IP** | Desconecte VPN, reconecte (novo IP) |
| **Nunca escaneie de IP fixo sem VPN** | Seu IP fica nos logs do alvo para sempre |
| **Verifique seu IP antes de começar** | `curl -s https://ifconfig.me` deve mostrar VPN, não IP real |

---

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

## Guia de Wordlists — Qual Usar para Cada Cenário

> **Usar a wordlist errada = 90% de falsos positivos ou 0 resultados.** Cada cenário tem uma wordlist ideal.

### Wordlists para Directory Discovery

| Cenário | Wordlist | Caminho | Tamanho | Quando usar |
|---------|----------|---------|---------|-------------|
| **Scan rápido inicial** | `common.txt` | `/usr/share/wordlists/dirb/common.txt` | 4.614 | SEMPRE começar por aqui |
| **Scan médio** | `directory-list-2.3-medium.txt` | `/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt` | 220.560 | Se common.txt encontrou pouco |
| **Scan completo** | `directory-list-2.3-big.txt` | `/usr/share/wordlists/dirbuster/directory-list-2.3-big.txt` | 1.284.195 | Último recurso, demora HORAS |
| **APENAS web** | `raft-small-directories.txt` | `/usr/share/seclists/Discovery/Web-Content/raft-small-directories.txt` | 62.284 | Mais focado em web |
| **APENAS admin** | `raft-small-words.txt` | `/usr/share/seclists/Discovery/Web-Content/raft-small-words.txt` | 88.073 | Focado em paths de admin |

### Wordlists para File Discovery

| Cenário | Wordlist | Caminho | Quando usar |
|---------|----------|---------|-------------|
| **Arquivos comuns** | `common.txt` | `/usr/share/wordlists/dirb/common.txt` | Primeiro scan |
| **Backups** | `backup.txt` | `/usr/share/seclists/Discovery/Web-Content/backup.txt` | Procurando .bak, .old, .sql |
| **Configurações** | `config.txt` | `/usr/share/seclists/Discovery/Web-Content/config.txt` | Procurando .env, .htaccess, config.php |
| **PHP** | `php.txt` | `/usr/share/seclists/Discovery/Web-Content/php.txt` | Se o site é PHP |
| **ASP.NET** | `aspx.txt` | `/usr/share/seclists/Discovery/Web-Content/aspx.txt` | Se o site é .NET |
| **APIs** | `api-endpoints.txt` | `/usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt` | Procurando /api/v1, /api/v2 |

### Wordlists para DNS Bruteforce

| Cenário | Wordlist | Caminho | Quando usar |
|---------|----------|---------|-------------|
| **Subdomínios comuns** | `common.txt` | `/usr/share/wordlists/dirb/common.txt` | Primeiro teste |
| **Subdomínios DNS** | `subdomains-top1million-5000.txt` | `/usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt` | Scan DNS mais profundo |
| **Subdomínios completo** | `subdomains-top1million-20000.txt` | `/usr/share/seclists/Discovery/DNS/subdomains-top1million-20000.txt` | Scan DNS muito profundo |

### Wordlists para Parameter Discovery

| Cenário | Wordlist | Caminho | Quando usar |
|---------|----------|---------|-------------|
| **Parâmetros web** | `burp-parameter-names.txt` | `/usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt` | Procurando ?id=, ?page=, ?q= |
| **APIs params** | `raft-small-params.txt` | `/usr/share/seclists/Discovery/Web-Content/raft-small-params.txt` | Parâmetros de API |

### Wordlists para Username/Password

| Cenário | Wordlist | Caminho | Quando usar |
|---------|----------|---------|-------------|
| **Senhas comuns** | `rockyou.txt` | `/usr/share/wordlists/rockyou.txt` | Brute force de senhas |
| **Senhas rápidas** | `top-20.txt` | `/usr/share/seclists/Passwords/Common-Credentials/top-20.txt` | Teste rápido |
| **Usernames** | `usernames.txt` | `/usr/share/seclists/Usernames/top-usernames-shortlist.txt` | Brute force de usuários |

### ⚠️ Dica de ouro:

> **Comece SEMPRE com `common.txt`.** Se encontrar muito pouco, use a wordlist maior. Se encontrar muito lixo, use a wordlist menor. NÃO comece com a wordlist grande — você vai gastar horas e receber milhares de falsos positivos.

---

## OPSEC — Não Deixar Rastros

> **OPSEC (Operations Security)** é garantir que o alvo NÃO saiba que você está escaneando ele. Se o alvo perceber, pode mudar configs, bloquear seu IP, ou até processar você.

### O que o alvo pode ver de você?

| O que você faz | O que o alvo vê | Risco |
|----------------|-----------------|-------|
| `nmap -sT -p- alvo.com` | Seu IP real nos logs | ⚠️ ALTO |
| `nmap -sS -p- alvo.com` | SYN packets do seu IP | ⚠️ MÉDIO |
| `gobuster dir -u alvo.com` | Seu IP fazendo requests | ⚠️ MÉDIO |
| `subfinder -d alvo.com` | NADA (passivo) | ✅ BAIXO |
| `theHarvester -d alvo.com` | NADA (passivo) | ✅ BAIXO |
| `curl http://alvo.com` | 1 request no log | ✅ BAIXO |

### Regras de OPSEC:

**1. Use VPN para TODOS os scans ativos**
```bash
# ANTES de qualquer scan ativo
nordvpn connect
curl -s https://ifconfig.me  # confirme que o IP mudou
```

**2. Limpe seus logs depois**
```bash
# Limpar histórico do bash
history -c
history -w

# Limpar logs do sistema (se tiver root)
sudo truncate -s 0 /var/log/syslog
sudo truncate -s 0 /var/log/auth.log
```

**3. Use User-Agent falso**
```bash
# Em vez de:
whatweb http://evilcorp.com

# Use:
whatweb -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" http://evilcorp.com

# Em Nmap:
nmap -sV -A -Pn --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" evilcorp.com
```

**4. Não escaneie tudo de uma vez**
```bash
# RUIM — escaneia tudo rápido e é bloqueado
nmap -sT -Pn -p- -T5 --min-rate 10000 evilcorp.com

# BOM — escaneia devagar e discretamente
nmap -sT -Pn -p 21,22,25,80,443,3306,8080 -T2 --max-rate 100 evilcorp.com
```

**5. Adicione delay entre requests**
```bash
# Gobuster com delay
gobuster dir -u http://evilcorp.com -w common.txt -t 10 --delay 0.5s

# ffuf com delay
ffuf -u http://evilcorp.com/FUZZ -w common.txt -p 0.5
```

**6. Saiba quando PARAR**

| Sinal | O que fazer |
|-------|-------------|
| Scan retornando 0 resultados | Pare. Pode estar bloqueado. Espere 30min e mude de IP |
| Respostas HTTP vindo muito rápido | Pare. Pode ser WAF retornando respostas falsas |
| IP banido (VPN desconectou) | Reconecte VPN (novo IP) e continue |
| ISP bloqueou acesso | Desconecte VPN, reconecte, mude de IP |
| Mais de 1 hora no mesmo scan | Pare. Revise se está no caminho certo |

**7. Nunca escaneie sem autorização**
- **CTF/Bootrooms:** Autorizado (HackTheBox, TryHackMe)
- **Alvo próprio:** Autorizado
- **Alvo de terceiros:** ILEGAL sem autorização por escrito
- **Bug bounty:** Autorizado se estiver no escopo do programa

### Checklist de OPSEC:

| # | Item | ☑ |
|---|------|:---:|
| 1 | VPN conectada e IP verificado | [ ] |
| 2 | User-Agent configurado nos scanners | [ ] |
| 3 | Delay entre requests configurado | [ ] |
| 4 | Logs do bash limpos | [ ] |
| 5 | Autorização confirmada (CTF/próprio) | [ ] |

---

## FASE 1 — Inteligência Passiva

**Tempo estimado:** 30-60 minutos
**Objetivo:** Descobrir O QUE existe sem gerar NENHUM tráfego para o alvo. Tudo via fontes públicas.
**Por quê:** Se o alvo tem IDS/IPS, ele NÃO vai detectar esta fase. É 100% segura.

---

### Passo 1.1 — Informações do Domínio (WHOIS e DNS)

**O que você vai fazer:** Consultar banco de dados públicos para descobrir quem registrou o domínio, quais IPs pertencem a ele, e quais servidores de DNS ele usa.

**Passo 1.1.1 — WHOIS**

```bash
whois evilcorp.com > 01-intel/whois.txt
```

**✅ Output esperado (exemplo real):**
```
   Domain Name: EVILCORP.COM
   Registry Domain ID: 1234567890_DOMAIN_COM-VRSN
   Registrar WHOIS WHO IS: WHOIS AKAMAI-LOS ANGELES
   Updated Date: 2024-01-15T12:00:00Z
   Creation Date: 2010-03-22T15:30:00Z
   Registrar Registration Expiration Date: 2025-03-22T15:30:00Z
   Registrant Organization: EvilCorp Inc.
   Registrant State/Province: California
   Registrant Country: US
   Name Server: NS1.AWSDNS.COM
   Name Server: NS2.AWSDNS.ORG
   DNSSEC: unsigned
```

**O que procurar no output:**
- **Registrant Organization:** Nome da empresa dona do domínio
- **Range de IPs:** Geralmente aparece como CIDR (ex: `192.168.0.0/24`) — anote, você vai escanear esses IPs depois
- **Name Servers:** Podem revelar infraestrutura (ex: `ns1.awsdns.com` = usa AWS)
- **Email de contato:** Pode ser usado para OSINT de pessoas
- **Data de criação:** Domínios muito novos podem ter configs padrão

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `whois: command not found` | Ferramenta não instalada | `sudo apt install whois` |
| Output vazio | Domínio privado ou proteção WHOIS | Acesse https://who.is e busque manualmente |
| Timeout | DNS lento | Use `whois -h whois.verisign-grs.com evilcorp.com` |
| Acesso bloqueado | IP banido pelo registry | Use `proxychains4 whois evilcorp.com` |

**Passo 1.1.2 — Records DNS**

```bash
dig evilcorp.com ANY > 01-intel/dns-records.txt
```

**✅ Output esperado (exemplo real):**
```
;; ANSWER SECTION:
evilcorp.com.        300    IN    A    104.21.33.15
evilcorp.com.        300    IN    A    172.67.188.22
evilcorp.com.        300    IN    MX    10 mail.evilcorp.com.
evilcorp.com.        300    IN    NS    ns1.awsdns.com.
evilcorp.com.        300    IN    NS    ns2.awsdns.org.
evilcorp.com.        300    IN    TXT   "v=spf1 include:_spf.google.com ~all"
evilcorp.com.        300    IN    TXT   "google-site-verification=abc123"
```

**O que procurar:**
- **A record:** IP do domínio principal → `104.21.33.15` (Cloudflare)
- **AAAA record:** IPv6 (se existir)
- **MX record:** Servidor de email → `mail.evilcorp.com` (pode revelar infraestrutura)
- **NS record:** Nameservers → `ns1.awsdns.com` (AWS Route 53)
- **TXT record:** SPF, DMARC, informações de verificação

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `dig: command not found` | Ferramenta não instalada | `sudo apt install dnsutils` |
| `;; no servers could be reached` | DNS bloqueando | Use `nslookup evilcorp.com 8.8.8.8` |
| Output vazio | Domínio não existe | Verifique ortografia do domínio |
| APENAS SOA record | DNS privado | Use `host evilcorp.com` como alternativa |

**Passo 1.1.3 — Reverse DNS (dos IPs encontrados)**

```bash
# Descobrir o IP do domínio primeiro
dig +short evilcorp.com
# Output esperado: 104.21.33.15

# Agora fazer reverse DNS
dig -x 104.21.33.15 > 01-intel/reverse-dns.txt
```

**✅ Output esperado (exemplo real):**
```
;; ANSWER SECTION:
15.33.21.104.in-addr.arpa. 300 IN PTR 104-21-33-15.cloudflare.net.
```

**O que procurar:** Hostnames associados ao IP. Se o IP pertence a um range grande, pode haver outros hostnames. O hostname `cloudflare.net` confirma que o site usa Cloudflare CDN.

---

### Passo 1.2 — Enumeração de Subdomínios Passiva

**O que você vai fazer:** Usar ferramentas que consultam 40+ fontes públicas (Google, VirusTotal, crt.sh, etc) para encontrar TODOS os subdomínios conhecidos. Nenhuma dessas ferramentas toca no alvo.

**Passo 1.2.1 — Subfinder (mais rápido)**

```bash
subfinder -d evilcorp.com -silent > 01-intel/subfinder.txt
```

**✅ Output esperado (exemplo real):**
```
admin.evilcorp.com
mail.evilcorp.com
staging.evilcorp.com
dev.evilcorp.com
api.evilcorp.com
www.evilcorp.com
vpn.evilcorp.com
portal.evilcorp.com
```

**O que procurar:** Lista de subdomínios. Cada linha é um subdomínio diferente.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | Domínio muito novo/privado | Use `-all` para mais fontes: `subfinder -d evilcorp.com -all -silent` |
| Timeout | API limitando | Use `subfinder -d evilcorp.com -timeout 15 -silent` |
| `command not found` | Não instalado | `sudo apt install subfinder` ou `go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest` |

**Passo 1.2.2 — Amass passivo (mais profundo)**

```bash
amass enum -passive -d evilcorp.com -o 01-intel/amass.txt
```

**✅ Output esperado (exemplo real):**
```
www.evilcorp.com
admin.evilcorp.com
mail.evilcorp.com
dev.evilcorp.com
staging.evilcorp.com
api.evilcorp.com
internal.evilcorp.com
test.evilcorp.com
jenkins.evilcorp.com
gitlab.evilcorp.com
grafana.evilcorp.com
```

**Diferença do Subfinder:** Amass usa mais fontes e gera mais resultados, mas é mais lento. Geralmente encontra 20-50% mais subdomínios que o Subfinder.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | Internet bloqueando APIs | Verifique conectividade: `curl -s https://google.com` |
| Muito lento (>10 min) | Normal do Amass | Espere ou cancele com Ctrl+C e use resultados do Subfinder |
| `command not found` | Não instalado | `sudo apt install amass` |

**Passo 1.2.3 — crt.sh (Certificate Transparency)**

```bash
curl -s "https://crt.sh/?q=evilcorp.com&output=json" | jq -r '.[].name_value' | sort -u > 01-intel/crtsh.txt
```

**✅ Output esperado (exemplo real):**
```
*.evilcorp.com
evilcorp.com
admin.evilcorp.com
api.evilcorp.com
dev.evilcorp.com
mail.evilcorp.com
staging.evilcorp.com
www.evilcorp.com
```

**O que procurar:** Subdomínios que apareceram em certificados SSL. Esses subdomínios podem não existir mais no DNS, mas existiram algum dia. O `*.evilcorp.com` significa que há um certificado wildcard.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `jq: command not found` | jq não instalado | `sudo apt install jq` |
| Output vazio | crt.sh retornou erro | Acesse https://crt.sh manualmente e busque pelo domínio |
| Timeout | crt.sh sobrecarregado | Tente novamente em 5 minutos |
| JSON malformado | API mudou | Use `curl -s "https://crt.sh/?q=evilcorp.com" | grep -oE '[a-z0-9.-]+\.evilcorp\.com' | sort -u > 01-intel/crtsh.txt` |

**Passo 1.2.4 — theHarvester (emails + subdomínios)**

```bash
theHarvester -d evilcorp.com -b all -f 01-intel/theharvester.html
```

**✅ Output esperado (exemplo real):**
```
*******************************************************************
*  _   _                                            _             *
* | |_| |__   ___    /\  /\__ _ _ ____   _____  ___| |_ ___ _ __ *
* | __|  _ \ / _ \  / /_/ / _` | '__\ \ / / _ \/ __| __/ _ \ '__|*
* | |_| | | |  __/ / __  / (_| | |   \ V /  __/\__ \ ||  __/ |   *
*  \__|_| |_|\___/ \/ /_/ \__,_|_|    \_/ \___||___/\__\___|_|   *
*                                                                 *
* theHarvester 4.x                                                *
*******************************************************************

[*] Searching 0 results...

Emails found:
-----------------
admin@evilcorp.com
info@evilcorp.com
jose.silva@evilcorp.com
maria.santos@evilcorp.com

Hosts found:
-----------------
www.evilcorp.com [104.21.33.15]
admin.evilcorp.com [104.21.33.16]
mail.evilcorp.com [192.168.1.50]
```

**O que procurar:**
- **Emails:** Podem ser usados para ataques de phishing ou brute force
- **Subdomínios:** Confirma o que já encontrou + novos
- **IPs:** Confirma ranges do WHOIS

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Muito pouco output | Fontes limitando requests | Reduza fontes: `-b google,bing,crtsh` |
| `Connection refused` | IP banido | Use `proxychains4 theHarvester -d evilcorp.com -b google` |
| `command not found` | Não instalado | `sudo apt install theharvester` |

**Passo 1.2.5 — Combinar e deduplicar**

```bash
cat 01-intel/subfinder.txt 01-intel/amass.txt 01-intel/crtsh.txt 01-intel/theharvester.txt | grep -i "evilcorp.com" | sort -u > 01-intel/subdominios-todos.txt
```

**✅ Output esperado (exemplo real — subdomínios combinados):**
```
admin.evilcorp.com
api.evilcorp.com
dev.evilcorp.com
gitlab.evilcorp.com
grafana.evilcorp.com
internal.evilcorp.com
jenkins.evilcorp.com
mail.evilcorp.com
portal.evilcorp.com
staging.evilcorp.com
test.evilcorp.com
vpn.evilcorp.com
www.evilcorp.com
```

**Verificar quantos encontrou:**
```bash
wc -l 01-intel/subdominios-todos.txt
```

**O que é um bom número:**
- 10-30 subdomínios = domínio pequeno/médio (normal)
- 30-100 subdomínios = empresa grande (normal)
- 100+ subdomínios = empresa muito grande ou com muitos serviços
- 0 subdomínios = domínio muito novo, privado, ou erro no comando

---

### Passo 1.3 — OSINT Organizacional

**O que você vai fazer:** Usar fontes públicas para descobrir informações sobre a organização que podem ajudar no ataque.

**Passo 1.3.1 — Google Dorking (no navegador)**

Abra o Firefox/Chrome e busque:

| Busca | O que encontra |
|-------|----------------|
| `site:evilcorp.com filetype:pdf` | PDFs expostos (docs internos) |
| `site:evilcorp.com inurl:admin` | Painéis de administração |
| `site:evilcorp.com intitle:"index of"` | Diretórios abertos |
| `site:evilcorp.com filetype:sql` | SQL dumps expostos |
| `site:evilcorp.com inurl:login` | Páginas de login |
| `"evilcorp.com" password` | Senhas vazadas |
| `"evilcorp.com" "confidential"` | Docs confidenciais |

**✅ Output esperado no navegador:**
```
site:evilcorp.com filetype:pdf

1. https://evilcorp.com/docs/rede-interna-2024.pdf
2. https://evilcorp.com/docs/relatorio-financeiro.pdf
3. https://staging.evilcorp.com/docs/configuracoes-api.pdf
```

**O que procurar:** PDFs de rede interna, configs de API, dados de staging = tesouro.

**Salve os resultados:** Copie os URLs encontrados e cole em `01-intel/google-dorks.txt`

**Passo 1.3.2 — Shodan (se tiver API key)**

```bash
# Instalar e configurar (primeira vez)
pip3 install shodan
shodan init SUA_API_KEY

# Buscar
shodan search "org:EvilCorp" --filename 01-intel/shodan.json
```

**✅ Output esperado (exemplo de 1 resultado):**
```json
{
  "ip_str": "104.21.33.15",
  "port": 443,
  "org": "EvilCorp Inc.",
  "product": "cloudflare",
  "version": "nginx",
  "vulns": ["CVE-2023-44487"],
  "hostnames": ["www.evilcorp.com", "admin.evilcorp.com"]
}
```

**O que procurar:** IPs, serviços expostos, vulnerabilidades conhecidas, headers interessantes.

**❌ Se não tiver API key:**
| Alternativa | Como |
|-------------|------|
| Shodan web | Acesse https://www.shodan.io e busque por `org:EvilCorp` |
| Censys | Acesse https://search.censys.io e busque o mesmo |
| ZoomEye | Acesse https://www.zoomeye.org |

**Passo 1.3.3 — Wayback Machine (URLs históricas)**

```bash
# Instalar waybackurls (primeira vez)
go install github.com/tomnomnom/waybackurls@latest

# Usar
echo "evilcorp.com" | waybackurls > 01-intel/wayback.txt
```

**✅ Output esperado (exemplo real):**
```
https://evilcorp.com/
https://evilcorp.com/admin/
https://evilcorp.com/admin/login.php
https://evilcorp.com/api/v1/users
https://evilcorp.com/api/v2/documents
https://evilcorp.com/config.php
https://evilcorp.com/debug/
https://evilcorp.com/old-site/
https://evilcorp.com/wordpress/
https://evilcorp.com/wp-admin/
https://evilcorp.com/wp-content/uploads/2023/backup.sql
https://evilcorp.com/robots.txt
https://evilcorp.com/sitemap.xml
```

**O que procurar:**
- `/admin/` → Painéis de administração
- `/api/` → Endpoints de API
- `/config.php` → Arquivo de configuração
- `/debug/` → Página de debug (pode ter infos sensíveis)
- `/old-site/` → Site antigo (pode ter menos segurança)
- `/wp-admin/` → WordPress admin
- `.sql` dumps → Backup de banco exposto

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `waybackurls: command not found` | Não instalado | `go install github.com/tomnomnom/waybackurls@latest` |
| Go não instalado | Não tem Go | `sudo apt install golang` |
| Output vazio | Domínio não tem histórico | Acesse https://web.archive.org e busque manualmente |
| Muito lento | Wayback retornando muito | Use gau (ver próximo passo) |

**Passo 1.3.4 — URLs de múltiplas fontes**

```bash
# Instalar gau (primeira vez)
go install github.com/lc/gau/v2/cmd/gau@latest

# Usar
echo "evilcorp.com" | gau > 01-intel/gau.txt

# Combinar com wayback
cat 01-intel/wayback.txt 01-intel/gau.txt | sort -u > 01-intel/todas-urls.txt
```

**✅ Output esperado de `wc -l 01-intel/todas-urls.txt`:**
```
2847 01-intel/todas-urls.txt
```
(2847 URLs únicas encontradas — é um número bom para uma empresa média)

---

### Checklist da Fase 1

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | WHOIS completo | `01-intel/whois.txt` | [ ] |
| 2 | Records DNS | `01-intel/dns-records.txt` | [ ] |
| 3 | Reverse DNS | `01-intel/reverse-dns.txt` | [ ] |
| 4 | Subdomínios (combinados) | `01-intel/subdominios-todos.txt` | [ ] |
| 5 | Emails encontrados | `01-intel/theharvester.html` | [ ] |
| 6 | Google Dorks | `01-intel/google-dorks.txt` | [ ] |
| 7 | URLs históricas | `01-intel/todas-urls.txt` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 1:

```
01-intel/
├── whois.txt              ← dados do WHOIS (empresa, IPs, nameservers)
├── dns-records.txt        ← records DNS (A, MX, NS, TXT)
├── reverse-dns.txt        ← reverse DNS dos IPs
├── subdominios-todos.txt  ← TODOS os subdomínios combinados (merge dos 4)
├── subfinder.txt          ← subdomínios do Subfinder
├── amass.txt              ← subdomínios do Amass
├── crtsh.txt              ← subdomínios do crt.sh
├── theharvester.txt       ← subdomínios + emails do theHarvester
├── google-dorks.txt       ← URLs encontradas no Google
├── wayback.txt            ← URLs do Wayback Machine
├── gau.txt                ← URLs do gau
├── todas-urls.txt         ← MERGE de wayback + gau (URLs históricas combinadas)
└── shodan.json            ← (se tiver API key) resultados do Shodan
```

### ✅ Sinal de sucesso:
- Você tem pelo menos **10 subdomínios** em `subdominios-todos.txt`
- Você tem pelo menos **100+ URLs** em `todas-urls.txt`
- Você sabe o **range de IPs** do alvo (do WHOIS/DNS)
- Você sabe **quais nameservers** o alvo usa

### ❌ Se falhou:
- Revise os erros na tabela "Se der errado" de cada passo
- Avance para Fase 2 mesmo assim — talvez com menos dados
- O mínimo para avançar: ter `subdominios-todos.txt` com pelo menos 3 subdomínios

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 1 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `subdominios-todos.txt` | Fase 2 | Validar quais subdomínios estão vivos |
| `todas-urls.txt` | Fase 4 | Encontrar endpoints antigos, parâmetros |
| `whois.txt` | Fase 2 | Saber quais IPs escanear |
| `dns-records.txt` | Fase 3 | Saber tecnologias DNS usadas |
| `google-dorks.txt` | Fase 4 | URLs sensíveis já encontradas |

**Se completou tudo → Avance para Fase 2**

---

## FASE 2 — Enumeração Ativa

**Tempo estimado:** 45-90 minutos
**Objetivo:** Confirmar quais subdomínios e serviços REALMENTE existem e estão respondendo. Agora você TOCA no alvo.
**Por quê:** Nem todo subdomínio encontrado na Fase 1 está ativo. Precisamos descobrir quais estão vivos para não gastar tempo escaneando alvos mortos.

---

### Passo 2.1 — Validar Subdomínios

**O que você vai fazer:** Verificar quais dos subdomínios encontrados na Fase 1 realmente respondem a requests HTTP.

**Passo 2.1.1 — Descobrir quais resolvem DNS**

```bash
# Primeiro, instalar dnsx se não tiver
go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest

# Resolver todos os subdomínios
cat 01-intel/subdominios-todos.txt | dnsx -silent -a > 02-enum/resolvidos.txt
```

**✅ Output esperado (exemplo real):**
```
admin.evilcorp.com [104.21.33.16]
api.evilcorp.com [104.21.33.17]
dev.evilcorp.com [192.168.1.10]
mail.evilcorp.com [192.168.1.50]
staging.evilcorp.com [192.168.1.20]
www.evilcorp.com [104.21.33.15]
```

**O que procurar:** Lista de subdomínios que têm IP associado. Subdomínios sem IP podem não existir mais.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | DNS privado ou sem resolução | Use `dig` manualmente em cada um: `dig +short admin.evilcorp.com` |
| Muito lento | Muitos subdomínios | Adicione resolvers: `dnsx -r resolvers.txt` |
| `command not found` | Não instalado | `go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest` |

**Passo 2.1.2 — Verificar quais estão HTTP vivos**

```bash
cat 02-enum/resolvidos.txt | httpx -silent -status-code -title > 02-enum/vivos.txt
```

**✅ Output esperado (exemplo real):**
```
http://admin.evilcorp.com [403] [Admin Panel - EvilCorp]
http://api.evilcorp.com [200] [EvilCorp API v2]
http://dev.evilcorp.com [200] [Development Server]
http://mail.evilcorp.com [200] [Roundcube Webmail]
http://staging.evilcorp.com [200] [EvilCorp Staging]
http://www.evilcorp.com [200] [EvilCorp - Leading the Future]
```

**O que procurar:**
- **Status 200:** Site acessível (bom alvo) — `api.evilcorp.com`, `dev.evilcorp.com`
- **Status 301/302:** Redirecionamento (pode ser interessante)
- **Status 403:** Acesso negado (pode ter conteúdo oculto) — `admin.evilcorp.com`
- **Status 404:** Não encontrado (pode ser erro de configuração)

**Salvar apenas os que têm status 200 ou 301/302:**
```bash
cat 02-enum/vivos.txt | grep -E "\[200\]|\[301\]|\[302\]" > 02-enum/vivos-filtrados.txt
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | Subdomínios bloqueando requests | Teste manualmente: `curl -I http://subdominio.com` |
| `command not found` | httpx não instalado | `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` |
| Muitos timeouts | Servidores lentos | Use `httpx -timeout 10 -silent` |

**Passo 2.1.3 — Brute Force DNS (se poucos resultados)**

Se encontrou menos de 10 subdomínios vivos, tente brute force:

```bash
gobuster dns -d evilcorp.com -w /usr/share/wordlists/dirb/common.txt -t 50 -o 02-enum/bruteforce-dns.txt
```

**✅ Output esperado (exemplo real):**
```
===============================================================
Gobuster v3.x
===============================================================
[+] Url: evilcorp.com
[+] Threads: 50
[+] Wordlist: /usr/share/wordlists/dirb/common.txt
===============================================================
Starting gobuster in DNS enumeration mode
===============================================================
ftp.evilcorp.com [Found: 192.168.1.30]
internal.evilcorp.com [Found: 192.168.1.40]
mail.evilcorp.com [Found: 192.168.1.50]
owa.evilcorp.com [Found: 192.168.1.60]
vpn.evilcorp.com [Found: 192.168.1.70]
===============================================================
Finished
===============================================================
```

---

### Passo 2.2 — Scan de Portas e Serviços

**O que você vai fazer:** Descobrir quais portas estão abertas nos IPs do alvo e quais serviços estão rodando nelas.

**IMPORTANTE:** Antes de escanear, salve a lista de IPs para não esquecer:
```bash
# Extrair IPs dos subdomínios vivos
cat 02-enum/vivos.txt | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort -u > 02-enum/ips.txt
```

**✅ Output de `02-enum/ips.txt` (exemplo):**
```
104.21.33.15
104.21.33.16
104.21.33.17
192.168.1.10
192.168.1.20
192.168.1.50
```

**Passo 2.2.1 — Scan TCP rápido (descobrir ports abertos)**

```bash
nmap -sT -Pn -p- --min-rate 5000 -T4 -iL 02-enum/ips.txt -oN 02-enum/nmap-ports.txt
```

**Explicação das flags:**
- `-sT`: TCP connect scan (funciona sem root)
- `-Pn`: Não fazer ping antes (muitos servidores bloqueiam ping)
- `-p-`: Todas as 65535 portas
- `--min-rate 5000`: Enviar no mínimo 5000 pacotes por segundo (mais rápido)
- `-T4`: Timing agressivo (mais rápido, mas mais ruidoso)
- `-iL`: Ler targets de arquivo
- `-oN`: Salvar output em formato legível

**✅ Output esperado (exemplo real para 1 IP):**
```
Nmap scan report for 104.21.33.15
Host is up (0.023s latency).

PORT      STATE SERVICE
22/tcp    open  ssh
80/tcp    open  http
443/tcp   open  https
3306/tcp  open  mysql
8080/tcp  open  http-proxy
8443/tcp  open  https-alt

Nmap scan report for 192.168.1.50
Host is up (0.018s latency).

PORT      STATE SERVICE
25/tcp    open  smtp
110/tcp   open  pop3
143/tcp   open  imap
993/tcp   open  imaps
995/tcp   open  pop3s
```

**O que procurar:**
- **22/tcp (SSH):** Acesso remoto — verificar versão (frequentemente vulnerable)
- **80/443 (HTTP/HTTPS):** Web — verificar aplicações web
- **3306 (MySQL):** Banco de dados — pode estar exposto à internet (GRAVE)
- **8080/8443 (alt HTTP):** Outras aplicações web (staging, admin)
- **25/110/143 (email):** Servidor de email — pode ter vulnerabilidades
- **3389 (RDP):** Acesso remoto Windows — ALVO PRIMÁRIO
- **6379 (Redis):** Redis exposto — frequentemente sem autenticação

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Muito lento (>30min) | Scan de 65k portas | Use portas comuns: `-p 21,22,25,53,80,110,143,443,993,995,3306,3389,5432,8080,8443` |
| IP banido | IDS bloqueando | Diminua `--min-rate` para 1000 ou use `-T3` |
| Sem root | Precisa root para SYN scan | Use `-sT` (já está no comando) |
| Output vazio | IP inacessível | Verifique se o IP está correto: `ping -c 1 104.21.33.15` |

**Passo 2.2.2 — Service detection (versões dos serviços)**

```bash
# Descobrir quais ports estão abertos
grep "open" 02-enum/nmap-ports.txt | awk '{print $1}' | cut -d'/' -f1 | tr '\n' ',' > /tmp/ports.txt

# Escanear versões nos ports abertos
nmap -sV -sC -p $(cat /tmp/ports.txt) -iL 02-enum/ips.txt -oN 02-enum/nmap-services.txt
```

**✅ Output esperado (exemplo real):**
```
PORT      STATE SERVICE VERSION
22/tcp    open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.6 (Ubuntu Linux; protocol 2.0)
|_ssh-hostkey: 2048 SHA256:abc123... (RSA)
| ssh2-enum-algos: 
|   kex_algorithms: curve25519-sha256
80/tcp    open  http    Apache/2.4.41 (Ubuntu)
|_http-title: EvilCorp - Leading the Future
|_http-server-header: Apache/2.4.41 (Ubuntu)
443/tcp   open  ssl/http Apache/2.4.41 (Ubuntu)
|_ssl-date: TLS randomness does not represent time
3306/tcp  open  mysql   MySQL 5.7.42-0ubuntu0.18.04.1
| mysql-info: Protocol: 10, Version: 5.7.42
8080/tcp  open  http    Apache Tomcat 9.0.82
|_http-title: Apache Tomcat/9.0.82
```

**O que procurar:**
- **Versão exata:** `Apache/2.4.41`, `OpenSSH/8.9p1`, `MySQL/5.7.42` → usar searchsploit depois
- **Versões antigas:** `Apache/2.4.29` (2017) → provavelmente tem CVEs conhecidas
- **Serviços inesperados:** `MySQL 5.7` exposto à internet = configuração incorreta perigosa
- **Apache Tomcat** → verificar CVEs de Tomcat

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Não detecta versões | Serviço escondendo banner | Adicione `--version-all` |
| Muitos ports altos | Serviços em portas altas | Aumente range: `-p-` |
| Muito lento | Muitos ports | Execute só nos ports que já descobriu |

**Passo 2.2.3 — UDP top ports**

```bash
nmap -sU --top-ports 20 -iL 02-enum/ips.txt -oN 02-enum/nmap-udp.txt
```

**✅ Output esperado (exemplo real):**
```
PORT      STATE SERVICE
53/udp    open  domain
123/udp   open  ntp
161/udp   open  snmp
162/udp   open  snmptrap
500/udp   open  isakmp
1900/udp  open  upnp
4500/udp  open  nat-t-ike
```

**O que procurar:**
- **53 (DNS):** DNS pode ter zone transfer habilitado
- **161 (SNMP):** SNMP exposto = informações do sistema
- **123 (NTP):** NTP pode ser usado para amplificação de ataque

---

### Passo 2.3 — Banner Grabbing

**O que você vai fazer:** Conectar manualmente a cada port aberto e pegar a "banner" — texto que identifica o serviço e versão.

**Passo 2.3.1 — Banner de serviços TCP**

```bash
# Para cada port aberto, conectar e pegar a banner
for port in 21 22 25 80 443; do
    echo "=== Port $port ===" >> 02-enum/banners.txt
    echo "" | ncat -w 3 evilcorp.com $port 2>&1 >> 02-enum/banners.txt
done
```

**✅ Output esperado (exemplo real):**
```
=== Port 21 ===
220 (vsFTPd 3.0.5)

=== Port 22 ===
SSH-2.0-OpenSSH_8.9p1 Ubuntu-3ubuntu0.6

=== Port 25 ===
220 mail.evilcorp.com ESMTP Postfix (Ubuntu)

=== Port 80 ===
HTTP/1.1 200 OK
Server: Apache/2.4.41 (Ubuntu)
X-Powered-By: PHP/7.4.3

=== Port 443 ===
HTTP/1.1 200 OK
Server: Apache/2.4.41 (Ubuntu)
Strict-Transport-Security: max-age=31536000
```

**O que procurar:**
- `SSH-2.0-OpenSSH_8.9p1` → Versão do SSH
- `220 mail.evilcorp.com ESMTP Postfix` → Servidor de email
- `220 (vsFTPd 3.0.5)` → Versão do FTP
- `X-Powered-By: PHP/7.4.3` → Linguagem e versão

**Passo 2.3.2 — Headers HTTP**

```bash
curl -I http://evilcorp.com > 02-enum/headers.txt
```

**✅ Output esperado (exemplo real):**
```
HTTP/1.1 200 OK
Date: Thu, 10 Sep 2026 14:30:00 GMT
Server: Apache/2.4.41 (Ubuntu)
X-Powered-By: PHP/7.4.3
X-Frame-Options: SAMEORIGIN
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
Strict-Transport-Security: max-age=31536000; includeSubDomains
Content-Security-Policy: default-src 'self'
Referrer-Policy: strict-origin-when-cross-origin
Connection: close
Content-Type: text/html; charset=UTF-8
```

**O que procurar:**
- `Server: Apache/2.4.41` → Versão do servidor web
- `X-Powered-By: PHP/7.4.3` → Linguagem e versão
- `X-Frame-Options` → Se tem proteção contra clickjacking ✅
- `Strict-Transport-Security` → Se força HTTPS ✅
- `Content-Security-Policy` → Se tem CSP ✅
- **Ausência de headers de segurança** = má configuração

**Passo 2.3.3 — TLS/SSL info**

```bash
nmap --script ssl-cert -p 443 evilcorp.com > 02-enum/ssl-info.txt
```

**✅ Output esperado (exemplo real):**
```
PORT    STATE SERVICE
443/tcp open  https

ssl-cert: Subject: commonName=evilcorp.com
          Issuer: commonName=R3/organizationName=Let's Encrypt
          Public Key: RSA 2048
          Not Before: 2024-06-01T00:00:00Z
          Not After:  2024-08-30T23:59:59Z
          Subject Alternative Name: DNS:evilcorp.com, DNS:*.evilcorp.com, DNS:admin.evilcorp.com
```

**O que procurar:**
- **Issuer:** `Let's Encrypt` (gratuito, mais confiável)
- **SANs:** `*.evilcorp.com` (wildcard) + `admin.evilcorp.com` (revela subdomínio)
- **Validade:** Se o certificado expirou ou está próximo de expirar

---

### Checklist da Fase 2

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Subdomínios DNS | `02-enum/resolvidos.txt` | [ ] |
| 2 | Subdomínios HTTP vivos | `02-enum/vivos-filtrados.txt` | [ ] |
| 3 | Ports TCP abertos | `02-enum/nmap-ports.txt` | [ ] |
| 4 | Serviços e versões | `02-enum/nmap-services.txt` | [ ] |
| 5 | UDP ports | `02-enum/nmap-udp.txt` | [ ] |
| 6 | Banners | `02-enum/banners.txt` | [ ] |
| 7 | Headers HTTP | `02-enum/headers.txt` | [ ] |
| 8 | SSL/TLS info | `02-enum/ssl-info.txt` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 2:

```
02-enum/
├── subdominios-todos.txt    ← cópia da Fase 1 (para referência)
├── resolvidos.txt           ← subdomínios que resolvem DNS
├── vivos.txt                ← subdomínios que respondem HTTP (com status)
├── vivos-filtrados.txt      ← apenas os vivos com status 200/301/302
├── ips.txt                  ← lista de IPs extraídos dos subdomínios vivos
├── nmap-ports.txt           ← scan de portas TCP (TODAS as 65535)
├── nmap-services.txt        ← versões dos serviços nos ports abertos
├── nmap-udp.txt             ← scan de ports UDP
├── banners.txt              ← banners dos serviços (SSH, FTP, SMTP, HTTP)
├── headers.txt              ← headers HTTP do domínio principal
└── ssl-info.txt             ← informações do certificado SSL
```

### ✅ Sinal de sucesso:
- Você tem pelo menos **3 subdomínios vivos** em `vivos-filtrados.txt`
- Você sabe **quais ports estão abertos** em cada IP
- Você sabe **a versão de cada serviço** (Apache, SSH, MySQL, etc)
- Você tem **as versões anotadas** — vai precisar disso na Fase 3

### ❌ Se falhou:
- Pode ser que o alvo esteja muito protegido. Tente: `nmap -sV -sC evilcorp.com`
- Se 0 subdomínios vivos: o alvo pode ser só um domínio sem subdomínios (normal para empresas pequenas)
- O mínimo para avançar: ter `nmap-ports.txt` com pelo menos 1 port aberta

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 2 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `vivos-filtrados.txt` | Fase 3, 4 | Fingerprinting e discovery em quem está vivo |
| `nmap-services.txt` | Fase 3, 5 | Saber versões para buscar CVEs |
| `ips.txt` | Fase 5 | Scan de vulnerabilidades nos IPs |
| `banners.txt` | Fase 6 | Validar versões de serviço |
| `headers.txt` | Fase 3, 6 | Detectar WAF e validar headers |

**Se completou tudo → Avance para Fase 3**

---

## FASE 3 — Fingerprinting

**Tempo estimado:** 20-40 minutos
**Objetivo:** Saber EXATAMENTE o que o alvo usa — CMS, frameworks, servidores, linguagens, libs.
**Por quê:** Saber que o alvo usa WordPress 5.7 com PHP 7.4 te permite buscar CVEs específicas. É como saber a marca da fechadura antes de escolher a picareta.

---

### Passo 3.1 — Fingerprinting Web

**Passo 3.1.1 — WhatWeb no domínio principal**

```bash
whatweb -a 3 -v evilcorp.com > 03-fingerprint/whatweb-principal.txt
```

**✅ Output esperado (exemplo real):**
```
http://evilcorp.com [200 OK] Apache[2.4.41], Country[US][US], HTML5, HTTPServer[Ubuntu Linux][Apache/2.4.41 (Ubuntu)], IP[104.21.33.15], PHP[7.4.3], Title[EvilCorp - Leading the Future], Ubuntu[18.04], X-Powered-By[PHP/7.4.3]
```

**O que procurar no output:**
- `[Apache/2.4.41]` → Servidor web e versão
- `[PHP/7.4.3]` → Linguagem e versão
- `[Ubuntu 18.04]` → Sistema operacional (PODE TER CVEs do SO)
- `[Title]` → Nome do site
- `[HTML5]` → Tecnologia frontend

**Passo 3.1.2 — WhatWeb em todos os subdomínios vivos**

```bash
cat 02-enum/vivos-filtrados.txt | awk '{print $1}' | whatweb -a 3 -i - > 03-fingerprint/whatweb-todos.txt
```

**✅ Output esperado (exemplo):**
```
http://admin.evilcorp.com [403 Forbidden] Apache[2.4.41]
http://api.evilcorp.com [200 OK] JSON, RESTAPI
http://dev.evilcorp.com [200 OK] Apache[2.4.41], PHP[7.4.3], WordPress[5.7]
http://mail.evilcorp.com [200 OK] Roundcube[1.6.0]
http://staging.evilcorp.com [200 OK] Apache[2.4.41], PHP[8.1.0]
http://www.evilcorp.com [200 OK] Apache[2.4.41], PHP[7.4.3], WordPress[6.4]
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| WAF bloqueando | Cloudflare/WAF detectando WhatWeb | Mude User-Agent: `whatweb -U "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"` |
| Muito lento | Agressividade alta | Reduza: `-a 2` |
| Output vazio | WAF bloqueando todas as respostas | Use httpx tech detect (próximo passo) |

**Passo 3.1.3 — httpx tech detect em massa (alternativa mais rápida)**

```bash
cat 02-enum/vivos-filtrados.txt | awk '{print $1}' | httpx -tech-detect -title -status-code -web-server -silent > 03-fingerprint/httpx-tech.txt
```

**✅ Output esperado (exemplo real):**
```
http://admin.evilcorp.com [403] [Admin Panel] [Apache/2.4.41]
http://api.evilcorp.com [200] [EvilCorp API] [nginx/1.24.0]
http://dev.evilcorp.com [200] [Dev Server] [Apache/2.4.41] [PHP/7.4.3, WordPress/5.7]
http://mail.evilcorp.com [200] [Roundcube Webmail] [Apache/2.4.41]
http://www.evilcorp.com [200] [EvilCorp] [Apache/2.4.41] [PHP/7.4.3, WordPress/6.4]
```

---

### Passo 3.2 — Detecção de WAF

**Por quê:** Se o alvo tem WAF, seus scans podem ser bloqueados ou banir seu IP. Precisa saber ANTES de escanear.

**Passo 3.2.1 — Wafw00f no domínio principal**

```bash
wafw00f -v evilcorp.com > 03-fingerprint/waf-principal.txt
```

**✅ Output esperado (exemplo real — COM WAF):**
```
                 ______
                /     _\
               / /\_/\ \   wafw00f - v2.2.1
              / __   _ \   https://github.com EnableSecurity/wafw00f
             / /\/\  \ \  @_EnableSecurity

 [*] Checking http://evilcorp.com
 [+] The site http://evilcorp.com is behind Cloudflare (Cloudflare Inc.)
```

**✅ Output esperado (exemplo real — SEM WAF):**
```
 [~] Checking http://evilcorp.com
 [-] No WAF detected by the generic detection
```

**O que fazer com essa informação:**
- **Sem WAF:** Escaneie normalmente, menos restrições
- **Com Cloudflare:** Geralmente bloqueia scans. Use `-T3` e menos threads
- **Com AWS WAF:** Pode bloquear por IP. Use ProxyChains
- **WAF diferente em cada sub:** Foque nos subdomínios SEM WAF primeiro

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `command not found` | Não instalado | `sudo apt install wafw00f` |
| Output "No WAF" mas bloqueando | WAF não detectado genericamente | Use `wafw00f -a` para testar todos os detectores |
| Timeout | WAF bloqueando wafw00f | Use `proxychains4 wafw00f -v evilcorp.com` |

**Passo 3.2.2 — Wafw00f em todos os subdomínios**

```bash
cat 02-enum/vivos-filtrados.txt | awk '{print $1}' | wafw00f -i - -o 03-fingerprint/waf-todos.json -f json
```

---

### Passo 3.3 — Buscar CVEs para versões encontradas

**O que você vai fazer:** Usar as versões encontradas nas fases anteriores para buscar vulnerabilidades conhecidas.

```bash
# Buscar CVEs para Apache 2.4.41
searchsploit apache 2.4.41

# Buscar CVEs para WordPress 5.7
searchsploit wordpress 5.7

# Buscar CVEs para PHP 7.4
searchsploit php 7.4.3

# Buscar CVEs para jQuery 3.3.1
searchsploit jquery 3.3.1
```

**✅ Output esperado (exemplo real — Apache 2.4.41):**
```
------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                       |  Path
------------------------------------------------------------------------------------- ---------------------------------
Apache 2.4.41 - 'mod_remoteip' Request Smuggling                                    | linux/webapps/49039.txt
Apache 2.4.41 - HTTP/2 Request Smuggling                                            | linux/dos/47897.py
Apache HTTP Server 2.4.41 - 'mod_cgid' RCE                                         | linux/remote/48884.py
------------------------------------------------------------------------------------- ---------------------------------
```

**O que procurar:** Vulnerabilidades com CVE que têm exploit público. Anote os números de CVE.

**❌ Se searchsploit não encontrar nada:**
| Alternativa | Como |
|-------------|------|
| Nmap NSE | `nmap --script vuln -p 80,443 evilcorp.com` |
| Nuclei | `nuclei -u http://evilcorp.com -severity critical,high` |
| Manual | Pesquise no Google: "Apache 2.4.41 CVE" |

---

### Checklist da Fase 3

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | WhatWeb principal | `03-fingerprint/whatweb-principal.txt` | [ ] |
| 2 | WhatWeb todos os subs | `03-fingerprint/whatweb-todos.txt` | [ ] |
| 3 | httpx tech detect | `03-fingerprint/httpx-tech.txt` | [ ] |
| 4 | WAF principal | `03-fingerprint/waf-principal.txt` | [ ] |
| 5 | WAF todos os subs | `03-fingerprint/waf-todos.json` | [ ] |
| 6 | CVEs buscadas | Anotadas no relatório | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 3:

```
03-fingerprint/
├── whatweb-principal.txt    ← tecnologias do domínio principal
├── whatweb-todos.txt        ← tecnologias de TODOS os subdomínios vivos
├── httpx-tech.txt           ← tecnologias via httpx (confirmação)
├── waf-principal.txt        ← WAF do domínio principal
├── waf-todos.json           ← WAF de todos os subdomínios
└── cves-encontradas.txt     ← lista de CVEs que você buscou (se/searchsploit)
```

### ✅ Sinal de sucesso:
- Você sabe o **CMS** que o alvo usa (WordPress, Joomla, Drupal, ou nenhum)
- Você sabe o **servidor web** e versão (Apache, Nginx, IIS)
- Você sabe o **WAF** (Cloudflare, AWS WAF, ou nenhum)
- Você buscou **CVEs** para as versões encontradas
- Você tem uma tabela mental: `versão | vulnerabilidade可能性`

### ❌ Se falhou:
- Se WhatWeb não detectou nada: use `httpx -tech-detect` (já deve ter na Fase 2)
- Se Wafw00f não detectou WAF: provavelmente NÃO tem WAF (bom para você)
- O mínimo para avançar: ter pelo menos a versão do servidor web

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 3 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `whatweb-principal.txt` | Fase 4, 5 | Saber se é WordPress para usar WPScan |
| `waf-todos.json` | Fase 4, 5 | Evitar subdomínios com WAF |
| `cves-encontradas.txt` | Fase 5 | Buscar vulnerabilidades específicas |
| `httpx-tech.txt` | Fase 5 | Confirmar versões para Nuclei |

**Se completou tudo → Avance para Fase 4**

---

## FASE 4 — Discovery de Conteúdo

**Tempo estimado:** 60-120 minutos
**Objetivo:** Encontrar diretórios, arquivos, endpoints e parâmetros ocultos no site.
**Por quê:** Todo site tem portas dos trás — /admin, /backup, /config, /api. Esses caminhos não aparecem no menu, mas existem.

---

### Passo 4.1 — Directory/File Discovery

**Passo 4.1.1 — Gobuster (scan rápido inicial)**

```bash
gobuster dir -u http://evilcorp.com -w /usr/share/wordlists/dirb/common.txt -t 50 -b 404,403 -o 04-discovery/gobuster-basico.txt
```

**✅ Output esperado (exemplo real):**
```
===============================================================
Gobuster v3.x
===============================================================
[+] Url:                     http://evilcorp.com
[+] Threads:                 50
[+] Wordlist:                /usr/share/wordlists/dirb/common.txt
[+] Status codes:            404,403
===============================================================
Starting gobuster in directory enumeration mode
===============================================================
/admin                [Status: 301] [Size: 315] [--> http://evilcorp.com/admin/]
/api                  [Status: 301] [Size: 313] [--> http://evilcorp.com/api/]
/backup               [Status: 403] [Size: 277]
/config               [Status: 403] [Size: 277]
/css                  [Status: 301] [Size: 313] [--> http://evilcorp.com/css/]
/docs                 [Status: 301] [Size: 314] [--> http://evilcorp.com/docs/]
/images               [Status: 301] [Size: 316] [--> http://evilcorp.com/images/]
/js                   [Status: 301] [Size: 310] [--> http://evilcorp.com/js/]
/login                [Status: 200] [Size: 1845]
/robots.txt           [Status: 200] [Size: 134]
/sitemap.xml          [Status: 200] [Size: 5671]
/uploads              [Status: 403] [Size: 277]
===============================================================
Finished
===============================================================
```

**O que procurar:**
- `/admin` → Painel administrativo ⭐
- `/backup` → Backups expostos ⭐
- `/config` → Configurações ⭐
- `/docs` → Documentação exposta ⭐
- `/uploads` → Uploads de arquivo
- `/api` → API REST
- `/robots.txt` → Pode revelar caminhos ocultos
- `/sitemap.xml` → Mapa do site

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Muitos falsos positivos | Status codes variados | Adicione: `-b 404,403,400,500` |
| Muito lento | Wordlist grande | Diminua threads: `-t 20` |
| WAF bloqueando | Rate limiting | Adicione delay: `--delay 0.2` |
| Output vazio | Site retorna tudo 404 | Teste manualmente: `curl -I http://evilcorp.com/` |

**Passo 4.1.2 — ffuf com extensões (encontrar arquivos)**

```bash
ffuf -u http://evilcorp.com/FUZZ -w /usr/share/wordlists/dirb/common.txt -e .php,.bak,.txt,.zip,.sql,.env,.old -fc 404,403 -o 04-discovery/ffuf-extensoes.json -of json
```

**✅ Output esperado (exemplo real):**
```
        /'___\  /'___\           /'___\
       /\ \__/ /\ \__/  __  __  /\ \__/
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/
         \ \_\   \ \_\  \ \____/  \ \_\
          \/_/    \/_/   \/___/    \/_/

       v2.1.0
________________________________________________

[Method: GET]     http://evilcorp.com/FUZZ
[Status: 200]     [Size: 234]     [Words: 15]     [Lines: 12]
[Duration: 45ms]

admin.php           [Status: 200] [Size: 234]
config.php          [Status: 200] [Size: 0]
config.bak          [Status: 200] [Size: 1247]
database.sql        [Status: 200] [Size: 45678]
.env                [Status: 200] [Size: 345]
phpinfo.php         [Status: 200] [Size: 67890]
robots.txt          [Status: 200] [Size: 134]
sitemap.xml         [Status: 200] [Size: 5671]
test.php            [Status: 200] [Size: 456]
backup.zip          [Status: 200] [Size: 234567]
```

**O que procurar:**
- `admin.php` → Painel admin ⭐
- `config.php` → Configuração com senhas ⭐
- `config.bak` → Backup da configuração ⭐⭐
- `database.sql` → Dump do banco de dados ⭐⭐⭐
- `.env` → Variáveis de ambiente (API keys) ⭐⭐⭐
- `phpinfo.php` → Informações do PHP
- `backup.zip` → Backup do site ⭐⭐
- `test.php` → Página de teste (pode ter vulnerabilidades)

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Muitos resultados | Wordlist muito genérica | Use wordlist menor ou mais específica |
| WAF bloqueando | Muitos requests | Adicione delay: `-p 0.1` ou use ProxyChains |
| Tudo 404 | Site é SPA (Single Page App) | Tente endpoints de API: `/api/v1/`, `/api/v2/` |
| `command not found` | ffuf não instalado | `sudo apt install ffuf` |

**Passo 4.1.3 — Scan recursivo (subdiretórios)**

Se encontrou diretórios interessantes na Fase 4.1.1, escaneie dentro deles:

```bash
ffuf -u http://evilcorp.com/admin/FUZZ -w /usr/share/wordlists/dirb/common.txt -recursion -recursion-depth 2 -fc 404 -o 04-discovery/ffuf-recursive.json -of json
```

---

### Passo 4.2 — Virtual Host Discovery

**O que você vai fazer:** Descobrir subdomínios internos que não estão no DNS público mas existem no servidor.

**Passo 4.2.1 — Descobrir o tamanho da resposta padrão**

Primeiro, descubra qual é o tamanho da resposta para um host que NÃO existe:

```bash
ffuf -u http://192.168.1.100 -H "Host: FUZZ.naoexiste.com" -w /usr/share/wordlists/dirb/common.txt -mc all -fs 0 -o /dev/null -of json -s
```

**✅ Output esperado (exemplo):**
```
[INFO] Filter: -fs 0 (response size 0)
... after scanning ...
[fs: 2345]   ← ANOTE ESTE NÚMERO. É o tamanho da resposta padrão.
```

**Passo 4.2.2 — Fuzzing de vhosts**

```bash
ffuf -u http://192.168.1.100 -H "Host: FUZZ.evilcorp.com" -w /usr/share/wordlists/dirb/common.txt -fs 2345 -mc 200,301,302 -o 04-discovery/vhosts.json -of json
```

**✅ Output esperado (exemplo real):**
```
admin.evilcorp.com    [Status: 200] [Size: 567]
dev.evilcorp.com      [Status: 302] [Size: 0]
internal.evilcorp.com [Status: 200] [Size: 890]
staging.evilcorp.com  [Status: 200] [Size: 456]
```

**O que procurar:**
- `admin.evilcorp.com` → Painel admin interno ⭐
- `staging.evilcorp.com` → Ambiente de staging (geralmente menos seguro) ⭐
- `dev.evilcorp.com` → Ambiente de desenvolvimento ⭐
- `internal.evilcorp.com` → Rede interna ⭐⭐

---

### Passo 4.3 — Descoberta de Parâmetros

**O que você vai fazer:** Descobrir parâmetros de URL que podem ser vulneráveis a SQLi, XSS, IDOR.

**Passo 4.3.1 — URLs com parâmetros (do Wayback/Gau)**

```bash
# Filtrar URLs que têm parâmetros (=)
cat 01-intel/todas-urls.txt | grep "=" | sort -u > 04-discovery/urls-com-parametros.txt

# Ver quantas encontrou
wc -l 04-discovery/urls-com-parametros.txt
```

**✅ Output esperado (exemplo real):**
```
http://evilcorp.com/page?id=5
http://evilcorp.com/search?q=test&type=all
http://evilcorp.com/api/users?id=123&format=json
http://evilcorp.com/download?file=document.pdf
http://evilcorp.com/login?redirect=/admin
http://evilcorp.com/news?page=2&sort=date
```

**O que procurar:** URLs como `page.php?id=5`, `search.php?q=test`, `api/users?id=123`

**❌ Se encontrou 0 URLs:** Use gau/waybackurls da Fase 1.3.3/1.3.4.

---

### Passo 4.4 — JavaScript Analysis

**O que você vai fazer:** Analisar arquivos JavaScript do site para encontrar endpoints de API, chaves expostas, e configurações internas.

**Passo 4.4.1 — Coletar todos os arquivos JS**

```bash
cat 02-enum/vivos-filtrados.txt | awk '{print $1}' | katana -jc -d 3 -silent | grep "\.js$" | sort -u > 04-discovery/js-files.txt
```

**✅ Output esperado (exemplo real):**
```
http://evilcorp.com/js/app.js
http://evilcorp.com/js/config.js
http://evilcorp.com/js/api.js
http://admin.evilcorp.com/js/admin.js
http://api.evilcorp.com/js/swagger.js
```

**❌ Se katana não estiver instalado:**
```bash
go install github.com/projectdiscovery/katana/cmd/katana@latest
```

**Alternativa sem katana:**
```bash
# Usar waybackurls + grep
echo "evilcorp.com" | waybackurls | grep "\.js$" | sort -u > 04-discovery/js-files.txt
```

**Passo 4.4.2 — Extrair endpoints dos JS**

```bash
# Instalar LinkFinder (primeira vez)
git clone https://github.com/GerbenJavado/LinkFinder.git /opt/linkfinder
pip3 install -r /opt/linkfinder/requirements.txt

# Rodar em cada arquivo JS
while IFS= read -r js; do
    python3 /opt/linkfinder/LinkFinder.py -i "$js" -o cli
done < 04-discovery/js-files.txt > 04-discovery/js-endpoints.txt
```

**✅ Output esperado (exemplo real):**
```
http://evilcorp.com/api/v1/users
http://evilcorp.com/api/v1/documents
http://evilcorp.com/api/v2/admin
http://evilcorp.com/api/auth/login
http://evilcorp.com/api/auth/register
http://evilcorp.com/uploads/
http://evilcorp.com/admin/api/settings
```

**Passo 4.4.3 — Buscar secrets nos JS**

```bash
grep -iE "(api.?key|token|secret|password|auth|firebase|aws|github)" 04-discovery/js-files.txt > 04-discovery/js-secrets.txt
```

**✅ Output esperado (exemplo real — se encontrar secrets):**
```
// config.js
const API_KEY = "sk-1234567890abcdef";
const FIREBASE_CONFIG = {
  apiKey: "AIzaSyD1234567890",
  authDomain: "evilcorp.firebaseapp.com"
};
const AWS_ACCESS_KEY = "AKIA1234567890ABCDEF";
```

**⚠️ Se encontrar isso → GRANDE ACHADO. Anote como severidade CRÍTICA.**

---

### Checklist da Fase 4

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Diretórios (Gobuster) | `04-discovery/gobuster-basico.txt` | [ ] |
| 2 | Arquivos com extensões (ffuf) | `04-discovery/ffuf-extensoes.json` | [ ] |
| 3 | Virtual hosts | `04-discovery/vhosts.json` | [ ] |
| 4 | URLs com parâmetros | `04-discovery/urls-com-parametros.txt` | [ ] |
| 5 | Arquivos JS | `04-discovery/js-files.txt` | [ ] |
| 6 | Endpoints em JS | `04-discovery/js-endpoints.txt` | [ ] |
| 7 | Secrets em JS | `04-discovery/js-secrets.txt` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 4:

```
04-discovery/
├── gobuster-basico.txt       ← diretórios encontrados (admin, api, backup, etc)
├── ffuf-extensoes.json       ← arquivos com extensões (.php, .bak, .sql, .env)
├── ffuf-recursive.json       ← scan recursivo dentro de diretórios encontrados
├── vhosts.json               ← virtual hosts descobertos (admin, staging, internal)
├── urls-com-parametros.txt   ← URLs com ?parametro=valor (candidatas a SQLi, XSS)
├── parametros.json           ← parâmetros descobertos via brute force
├── js-files.txt              ← todos os arquivos JavaScript encontrados
├── js-endpoints.txt          ← endpoints extraídos dos JS ( /api/users, /api/admin )
├── js-secrets.txt            ← secrets/chaves encontradas nos JS
├── google-dorks.txt          ← cópia da Fase 1 (URLs sensíveis)
└── todas-urls.txt            ← cópia da Fase 1 (URLs históricas)
```

### ✅ Sinal de sucesso:
- Você encontrou pelo menos **5 diretórios** em `gobuster-basico.txt`
- Você tem **URLs com parâmetros** em `urls-com-parametros.txt`
- Você identificou pelo menos **1 virtual host** interno (ex: staging, dev, internal)
- Você encontrou **arquivos sensíveis** em `ffuf-extensoes.json` (ex: config.php, .env)

### ❌ Se falhou:
- Se Gobuster não encontrou nada: o site pode ser SPA — tente endpoints de API
- Se ffuf não encontrou arquivos: tente extensões diferentes
- O mínimo para avançar: ter `gobuster-basico.txt` com pelo menos 3 diretórios

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 4 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `gobuster-basico.txt` | Fase 5 | Nikto vai varrer esses diretórios |
| `ffuf-extensoes.json` | Fase 5 | Arquivos sensíveis são alvos de vulnerabilidade |
| `urls-com-parametros.txt` | Fase 5 | Candidatos a SQLi, XSS |
| `js-endpoints.txt` | Fase 5 | Endpoints de API para Nuclei testar |
| `js-secrets.txt` | Fase 5, 7 | Secrets são vulnerabilidades CRÍTICAS |

**Se completou tudo → Avance para Fase 5**

---

## FASE 5 — Scan de Vulnerabilidades

**Tempo estimado:** 60-120 minutos
**Objetivo:** Identificar vulnerabilidades conhecidas e configurações incorretas nos serviços e aplicações web encontrados.
**Por quê:** Agora que você sabe O QUE o alvo usa (Fase 3) e ONDE estão os pontos de entrada (Fase 4), pode buscar vulnerabilidades específicas.

---

### Passo 5.1 — Web Vulnerability Scan

**Passo 5.1.1 — Nikto**

```bash
nikto -h http://evilcorp.com -o 05-vulns/nikto.html -Format htm
```

**✅ Output esperado (exemplo real):**
```
- Nikto v2.x
---------------------------------------------------------------------------
+ Target IP:     104.21.33.15
+ Target Hostname: evilcorp.com
+ Target Port: 80
+ Start Time:   2026-09-10 14:30:00

+ Server: Apache/2.4.41 (Ubuntu)
+ OSVDB-3233: /icons/README: Apache default file found.
+ OSVDB-3268: /docs/: Directory indexing found.
+ OSVDB-3092: /admin/: This might be interesting...
+ OSVDB-3092: /backup/: This might be interesting...
+ OSVDB-3092: /config/: This might be interesting...
+ OSVDB-3092: /uploads/: This might be interesting...
+ OSVDB-3268: /icons/: Directory indexing found.
+ Cookie PHPSESSID created without the httponly flag
+ Cookie PHPSESSID created without the secure flag
+ /admin/: Admin login page/section found.
+ OSVDB-3092: /phpmyadmin/: phpMyAdmin is free database admin tool.

+ End Time: 2026-09-10 14:35:00
+ 15 items checked - 10 interesting findings
---------------------------------------------------------------------------
```

**O que procurar:**
- `/admin/` → Painel administrativo ⭐
- `/backup/` → Backups expostos ⭐
- `/config/` → Configurações ⭐
- `/phpmyadmin/` → phpMyAdmin (banco de dados web) ⭐⭐
- `Cookie PHPSESSID created without httponly flag` → Falta de segurança ⭐
- `Cookie PHPSESSID created without secure flag` → Falta de segurança ⭐

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Muitos falsos positivos | Nikto é genérico | SEMPRE confirme manualmente cada achado |
| WAF bloqueando | Rate limiting | Use `-evasion 1` para bypass básico |
| Muito lento | Scan completo | Limite a 10 minutos: `-maxtime 600` |
| Output vazio | Site retorna 404 para tudo | Use `-Format txt` para ver mais detalhes |

**Passo 5.1.2 — Nuclei**

```bash
nuclei -u http://evilcorp.com -severity medium,high,critical -o 05-vulns/nuclei.txt
```

**✅ Output esperado (exemplo real):**
```
                     __     _
   ____  __  _______/ /__  (_)
  / __ \/ / / / ___/ / _ \/ /
 / / / / /_/ / /__/ /  __/ /
/_/ /_/\__,_/\___/_/\___/_/  v3.x

[2026-09-10 14:40:00] [critical] [apache-server-config] http://evilcorp.com
[2026-09-10 14:40:01] [high] [x-powered-by-header] http://evilcorp.com
[2026-09-10 14:40:02] [medium] [missing-strict-transport-security] http://evilcorp.com
[2026-09-10 14:40:03] [high] [phpinfo-exposure] http://evilcorp.com/phpinfo.php
[2026-09-10 14:40:04] [critical] [env-exposure] http://evilcorp.com/.env
[2026-09-10 14:40:05] [medium] [backup-file-disclosure] http://evilcorp.com/config.bak
```

**Explicação:**
- `-severity medium,high,critical`: Mostrar apenas médio, alto e crítico (ignorar low/info)
- Primeiro rode: `nuclei -update-templates` para atualizar templates

**O que procurar:**
- `[critical]` → VULNERABILIDADE GRAVE — confirmar e reportar
- `[high]` → VULNERABILIDADE ALTA — confirmar e reportar
- `[medium]` → VULNERABILIDADE MÉDIA — reportar se confirmada

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Sem resultados | Templates desatualizados | `nuclei -update-templates` |
| Muitos falsos positivos | Templates genéricos | Confirme cada achado manualmente |
| WAF bloqueando | Muitos requests | Use ProxyChains ou `-rl 50` (50 requests/s) |
| Muito lento | Scan completo | Limite: `-severity critical,high` |

**Passo 5.1.3 — Nmap NSE vuln**

```bash
nmap --script vuln -p [PORTAS-ABERTAS] -iL 02-enum/ips.txt -oN 05-vulns/nmap-vuln.txt
```

**✅ Output esperado (exemplo real):**
```
PORT    STATE SERVICE
443/tcp open  https

ssl-poodle:
  VULNERABLE:
  SSLv3 POODLE vulnerability
  State: VULNERABLE
  Risk factor: High
  CVE: CVE-2014-3566

http-shellshock:
  VULNERABLE:
  Shellshock vulnerability
  State: VULNERABLE
  CVE: CVE-2014-6271
```

---

### Passo 5.2 — WordPress (se aplicável)

Se o WhatWeb detectou WordPress na Fase 3, execute esta fase.

**Passo 5.2.1 — WPScan**

```bash
wpscan --url http://evilcorp.com -e vp,vt,u --plugins-detection mixed --no-banner -o 05-vulns/wpscan.txt
```

**✅ Output esperado (exemplo real):**
```
[+] URL: http://evilcorp.com/
[+] Started: Thu Sep 10 14:45:00 2026

Interesting Finding(s):

[+] Headers
 | Interesting Entry: X-Powered-By: PHP/7.4.3

[+] WordPress version: 5.7
 | Found By: Rss Generator (Passive Detection)
 | [!] https://wordpress.org/news/2021/03/wordpress-5-7-1-security-and-maintenance-release/

[+] WordPress theme: twentytwentyone
 | Found By: Css Style(s) In Passive Detection
 | Version: 1.3 (80% confidence)

[+] Enumerating All Plugins (via Passive Methods)
[+] Plugins Found:
 | wp-file-manager
 | Found By:被动检测
 | Version: 6.9 (100% confidence)
 | [!] https://wpscan.com/plugin/12345

[+] Enumerating Config Backups (via Passive and Aggressive Methods)
[+] Config Backups Found:
 | wp-config.php.bak
 | Found By: Aggressive Detection
 | Path: http://evilcorp.com/wp-config.php.bak

[+] Enumerating Users (via Aggressive Methods)
 | Username: admin
 | Username: jose.silva
```

**O que procurar:**
- `WordPress version: 5.7` → Versão antiga, pode ter CVEs
- `wp-file-manager: 6.9` → Plugin COM VULNERABILIDADE CONHECIDA ⭐⭐
- `wp-config.php.bak` → Backup da configuração exposto ⭐⭐⭐
- `Username: admin` → Username padrão ⭐

---

### Passo 5.3 — Cloud Storage

**Passo 5.3.1 — S3 Buckets**

```bash
# Tentar listar bucket com o nome do domínio
aws s3 ls s3://evilcorp --no-sign-request 2>&1 > 05-vulns/s3-test.txt

# Testar variações do nome
for name in evilcorp evil-corp evilcorp-prod evilcorp-backup; do
    echo "=== Testing s3://$name ===" >> 05-vulns/s3-test.txt
    aws s3 ls s3://$name --no-sign-request 2>&1 >> 05-vulns/s3-test.txt
done
```

**✅ Output esperado (exemplo real — bucket exposto):**
```
=== Testing s3://evilcorp ===
                           PRE backups/
                           PRE documents/
                           PRE images/
                           PRE uploads/

=== Testing s3://evil-corp ===
A client error (NoSuchBucket) occurred when calling the ListObjectsV2 operation

=== Testing s3://evilcorp-backup ===
                           PRE database-dumps/
                           PRE configs/
```

**⚠️ Se encontrar um bucket listável → CRÍTICO. Anote como vulnerabilidade grave.**

---

### Passo 5.4 — Subdomain Takeover

**O que você vai fazer:** Verificar se algum subdomínio aponta (CNAME) para um serviço externo que NÃO foi reclamado. Se sim, você pode "tomar" esse subdomínio.

**Passo 5.4.1 — Verificar CNAMEs**

```bash
cat 02-enum/resolvidos.txt | while read sub; do
    cname=$(dig +short "$sub" CNAME | head -1)
    if [ ! -z "$cname" ]; then
        echo "$sub -> $cname" >> 05-vulns/cnames.txt
    fi
done
```

**✅ Output esperado (exemplo real):**
```
docs.evilcorp.com -> evilcorp.s3.amazonaws.com
staging.evilcorp.com -> evilcorp-staging.herokuapp.com
blog.evilcorp.com -> evilcorp.wordpress.com
```

**Passo 5.4.2 — Subzy scan**

```bash
# Instalar (primeira vez)
go install github.com/LukaSusic/subzy@latest

# Rodar
subzy run --targets 02-enum/resolvidos.txt --concurrency 50 > 05-vulns/subzy.txt
```

**✅ Output esperado (exemplo real):**
```
[NOT VULNERABLE]  evilcorp.com
[NOT VULNERABLE]  www.evilcorp.com
[VULNERABLE]      docs.evilcorp.com  → evilcorp.s3.amazonaws.com (NoSuchBucket)
[NOT VULNERABLE]  mail.evilcorp.com
[VULNERABLE]      staging.evilcorp.com → evilcorp-staging.herokuapp.com (Heroku Error Page)
[NOT VULNERABLE]  api.evilcorp.com
```

**⚠️ Se encontrar `VULNERABLE` → CRÍTICO. Você pode assumir controle desse subdomínio.**

---

### Checklist da Fase 5

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Nikto | `05-vulns/nikto.html` | [ ] |
| 2 | Nuclei | `05-vulns/nuclei.txt` | [ ] |
| 3 | Nmap NSE vuln | `05-vulns/nmap-vuln.txt` | [ ] |
| 4 | WPScan (se WP) | `05-vulns/wpscan.txt` | [ ] |
| 5 | S3 Buckets | `05-vulns/s3-test.txt` | [ ] |
| 6 | Subdomain Takeover | `05-vulns/subzy.txt` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 5:

```
05-vulns/
├── nikto.html               ← scan de vulnerabilidades web (HTML legível)
├── nuclei.txt               ← vulnerabilidades encontradas por template
├── nmap-vuln.txt            ← vulnerabilidades via scripts NSE do Nmap
├── wpscan.txt               ← (se WordPress) vulnerabilidades do WP
├── s3-test.txt              ← teste de S3 buckets expostos
├── subzy.txt                ← teste de subdomain takeover
├── cnames.txt               ← CNAMEs dos subdomínios
└── searchsploit-results.txt ← resultados do searchsploit para CVEs
```

### ✅ Sinal de sucesso:
- Você encontrou pelo menos **2-3 vulnerabilidades** que pode CONFIRMAR
- Cada vulnerabilidade tem: **nome, URL alvo, evidência, severidade**
- Você separou **falsos positivos** de vulnerabilidades reais
- Você sabe qual vulnerabilidade é CRÍTICA, ALTA, MÉDIA, BAIXA

### ❌ Se falhou:
- Se NENHUM scanner encontrou nada: o alvo pode ser bem protegido
- Foque em vulnerabilidades de **configuração** que você já encontrou:
  - Headers de segurança ausentes (Fase 2.3.2)
  - Versões antigas (Fase 2.2.2)
  - Serviços expostos à internet (MySQL, Redis)
- O mínimo para avançar: ter pelo menos 1 achado que pode confirmar

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 5 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `nuclei.txt` | Fase 6 | Validar cada achado do Nuclei |
| `nikto.html` | Fase 6 | Validar achados do Nikto |
| `wpscan.txt` | Fase 6 | Validar plugins vulneráveis |
| `subzy.txt` | Fase 7 | Documentar takeover no relatório |

**Se completou tudo → Avance para Fase 6**

---

## FASE 6 — Análise e Validação

**Tempo estimado:** 30-60 minutos
**Objetivo:** Confirmar cada achado, eliminar falsos positivos, organizar tudo por severidade.
**Por quê:** Scanner gera muitos falsos positivos. Você precisa CONFIRMAR cada achado antes de reportar. Um falso positivo no relatório destrói sua credibilidade.

---

### Passo 6.1 — Validação Manual

Para CADA achado das fases anteriores, faça o seguinte:

| Tipo de Achado | Como Validar | Comando de Validação |
|----------------|-------------|---------------------|
| Subdomínio vivo | Acessar no navegador | `curl -I http://sub.evilcorp.com` |
| Diretório encontrado | Acessar no navegador | `curl -I http://evilcorp.com/admin` |
| Versão de serviço | Ler banner | `ncat -v evilcorp.com 22` |
| WAF detectado | Verificar headers | `curl -I http://evilcorp.com` |
| Vulnerabilidade Nikto | Acessar caminho | `curl -I http://evilcorp.com/phpmyadmin` |
| Vulnerabilidade Nuclei | Seguir instruções do output | N/A |
| WordPress vuln | Verificar versão | `curl -s http://evilcorp.com | grep "generator"` |
| S3 Bucket | Tentar listar | `aws s3 ls s3://bucket --no-sign-request` |
| CNAME takeover | Confirmar erro | `curl -I http://docs.evilcorp.com` |

**✅ Output esperado de validação de um 403 (exemplo real):**
```bash
# Admin retorna 403 — é vulnerabilidade?
curl -I http://evilcorp.com/admin
# Resposta: HTTP/1.1 403 Forbidden

# Testar com X-Forwarded-For (bypass)
curl -H "X-Forwarded-For: 127.0.0.1" http://evilcorp.com/admin
# Resposta: HTTP/1.1 403 Forbidden (não funcionou)

# Testar com POST
curl -X POST http://evilcorp.com/admin
# Resposta: HTTP/1.1 403 Forbidden (não funcionou)

# CONCLUSÃO: 403 é proteção real. NÃO é vulnerabilidade.
```

**Crie um arquivo de validação:**
```bash
echo "# Validação de Achados - $(date)" > 06-validacao/validacao.md
echo "" >> 06-validacao/validacao.md
echo "## Achados Confirmados" >> 06-validacao/validacao.md
echo "- [ ] Achado 1: [descrever]" >> 06-validacao/validacao.md
echo "- [ ] Achado 2: [descrever]" >> 06-validacao/validacao.md
```

---

### Passo 6.2 — Eliminar Falsos Positivos

**Regras para eliminar falsos positivos:**

| Regra | Exemplo | É vulnerabilidade? |
|-------|---------|:---:|
| Status 403 | `/admin` retorna 403 | ❌ Não (proteção normal) |
| Nikto genérico | `/icons/README` existe | ❌ Não (arquivo padrão Apache) |
| Nuclei "info" | Header ausente | ❌ Não (configuração padrão) |
| Versão antiga sem CVE | Apache 2.4.41 sem CVE público | ❌ Não |
| CNAME para serviço externo | `blog.evilcorp.com` → WordPress.com | ❌ Não (serviço reclamado) |
| `.env` exposto | `http://evilcorp.com/.env` retorna 200 | ✅ SIM ⭐⭐⭐ |
| `config.bak` exposto | Acessível sem auth | ✅ SIM ⭐⭐⭐ |
| Plugin WordPress vulnerável | `wp-file-manager` versão antiga | ✅ SIM ⭐⭐ |
| Subzy VULNERABLE | Subdomínio não reclamado | ✅ SIM ⭐⭐⭐ |
| S3 Bucket listável | `aws s3 ls` retorna conteúdo | ✅ SIM ⭐⭐⭐ |
| mysql exposto à internet | Porta 3306 aberta externamente | ✅ SIM ⭐⭐ |

**❌ Se um achado NÃO for vulnerabilidade, REMOVA do relatório.**

---

### Passo 6.3 — Organizar por Severidade

```bash
cat > 06-validacao/resumo-severidade.md << 'EOF'
# Resumo de Severidade

## CRÍTICO
- S3 Bucket "evilcorp-backup" listável com dumps de banco
- Subdomain Takeover em docs.evilcorp.com
- .env exposto com credenciais AWS

## ALTO
- wp-file-manager plugin vulnerable (CVE-2020-25213)
- MySQL 3306 exposto à internet
- wp-config.php.bak acessível

## MÉDIO
- Headers de segurança ausentes (X-Frame-Options, CSP)
- PHP 7.4.3 com versão desatualizada
- Cookie PHPSESSID sem httponly

## BAIXO
- Apache 2.4.41 com versão desatualizada
- phpinfo.php exposto

## INFORMATIVO
- WordPress 5.7 detectado
- Certificado Let's Encrypt
- Uso de Cloudflare CDN
EOF
```

---

### Checklist da Fase 6

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Todos os achados validados | `06-validacao/validacao.md` | [ ] |
| 2 | Falsos positivos eliminados | Revisado | [ ] |
| 3 | Achados organizados por severidade | `06-validacao/resumo-severidade.md` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 6:

```
06-validacao/
├── validacao.md              ← lista de cada achado com status (confirmado/eliminado)
└── resumo-severidade.md      ← vulnerabilidades organizadas por severidade
```

### ✅ Sinal de sucesso:
- Cada vulnerabilidade em `resumo-severidade.md` tem: **nome, URL, evidência, impacto**
- Você **confirmou manualmente** cada achado (com curl, ncat, navegador)
- Você **eliminou falsos positivos** (Nikto genérico, 403, etc)
- Sabe exatamente o que vai escrever no relatório

### ❌ Se falhou:
- Se não encontrou NENHUMA vulnerabilidade: documente "Alvo sem vulnerabilidades encontradas" no relatório
- Foque em vulnerabilidades de **configuração** que sempre existem:
  - Headers ausentes
  - Versões antigas
  - Serviços expostos

**Se completou tudo → Avance para Fase 7**

---

## FASE 7 — Relatório

**Tempo estimado:** 60-120 minutos
**Objetivo:** Documentar TUDO de forma que outra pessoa possa replicar e entender.
**Por quê:** O relatório é o ÚNICO entregável que o cliente/equipe vê. Se não está no relatório, não aconteceu.

---

### Passo 7.1 — Criar Estrutura do Relatório

```bash
cat > 07-relatorio/relatorio-recon.md << 'EOF'
# Relatório de Reconhecimento

| Campo | Valor |
|-------|-------|
| **Alvo** | evilcorp.com |
| **Data** | 10/09/2026 |
| **Autor** | [SEU NOME] |
| **Classificação** | CONFIDENCIAL |

---

## 1. Resumo Executivo

Durante o reconhecimento de evilcorp.com, foram identificadas 3 vulnerabilidades
de severidade crítica, 3 de severidade alta, e 3 de severidade média.
As principais descobertas incluem:

- **CRÍTICO:** S3 Bucket "evilcorp-backup" listável com dumps de banco de dados
- **CRÍTICO:** Subdomain Takeover em docs.evilcorp.com (CNAME para S3 não reclamado)
- **CRÍTICO:** Arquivo .env exposto com credenciais AWS
- **ALTO:** Plugin WordPress "wp-file-manager" vulnerable (CVE-2020-25213)
- **ALTO:** MySQL porta 3306 exposto à internet
- **ALTO:** wp-config.php.bak acessível sem autenticação

## 2. Escopo

- **Alcance:** *.evilcorp.com, IPs 104.21.33.0/24, 192.168.1.0/24
- **Exclusões:** Nenhum

## 3. Metodologia

| Fase | Ferramentas | Resultados |
|------|------------|------------|
| 1 - Inteligência Passiva | Subfinder, Amass, crt.sh, theHarvester | 47 subdomínios encontrados |
| 2 - Enumeração Ativa | httpx, Nmap, ncat | 12 subdomínios vivos, 8 ports abertos |
| 3 - Fingerprinting | WhatWeb, wafw00f, searchsploit | WordPress 5.7, Apache 2.4.41, sem WAF |
| 4 - Discovery | Gobuster, ffuf, Wayback | 15 diretórios, 342 URLs com parâmetros |
| 5 - Vulns | Nikto, Nuclei, WPScan, Subzy | 9 vulnerabilidades encontradas |
| 6 - Validação | Manual (curl, ncat) | 9 confirmadas, 0 falsos positivos |

## 4. Descobertas

### 4.1 Subdomínios (47 encontrados, 12 ativos)

| Subdomínio | Status | IP |
|------------|--------|-----|
| www.evilcorp.com | 200 OK | 104.21.33.15 |
| admin.evilcorp.com | 403 Forbidden | 104.21.33.16 |
| api.evilcorp.com | 200 OK | 104.21.33.17 |
| docs.evilcorp.com | 200 OK | (S3) |
| staging.evilcorp.com | 200 OK | 192.168.1.20 |

### 4.2 Ports e Serviços

| IP | Port | Serviço | Versão |
|----|------|---------|--------|
| 104.21.33.15 | 22 | SSH | OpenSSH 8.9p1 |
| 104.21.33.15 | 80 | HTTP | Apache 2.4.41 |
| 104.21.33.15 | 443 | HTTPS | Apache 2.4.41 |
| 104.21.33.15 | 3306 | MySQL | MySQL 5.7.42 |

### 4.3 Vulnerabilidades Web

#### [CRÍTICO] .env Expost
- **URL:** http://evilcorp.com/.env
- **Evidência:** Retorna variáveis de ambiente com AWS_ACCESS_KEY
- **Comando:** `curl -s http://evilcorp.com/.env`
- **Impacto:** Credenciais AWS expostas podem permitir acesso à infraestrutura cloud

#### [ALTO] wp-file-manager Vulnerável
- **Plugin:** wp-file-manager 6.9
- **CVE:** CVE-2020-25213
- **Evidência:** WPScan detectou versão vulnerável
- **Impacto:** Upload de arquivos arbitrários (RCE)

### 4.4 Subdomain Takeover

| Subdomínio | CNAME | Status |
|------------|-------|--------|
| docs.evilcorp.com | evilcorp.s3.amazonaws.com | VULNERABLE (NoSuchBucket) |
| staging.evilcorp.com | evilcorp-staging.herokuapp.com | VULNERABLE (Heroku Error Page) |

## 5. Recomendações

| # | Severidade | Recomendação |
|---|-----------|-------------|
| 1 | CRÍTICO | Remover .env da web imediatamente |
| 2 | CRÍTICO | Revogar credenciais AWS expostas |
| 3 | CRÍTICO | Reclamar/restringir subdomínio docs.evilcorp.com |
| 4 | ALTO | Atualizar plugin wp-file-manager para versão corrigida |
| 5 | ALTO | Restringir acesso MySQL à rede interna |
| 6 | ALTO | Remover wp-config.php.bak |
| 7 | MÉDIO | Adicionar headers de segurança (X-Frame-Options, CSP) |
| 8 | MÉDIO | Atualizar PHP para versão suportada |
| 9 | MÉDIO | Adicionar flags httponly e secure nos cookies |

## 6. Ferramentas Utilizadas

Subfinder, Amass, crt.sh, theHarvester, httpx, Nmap, ncat, WhatWeb, wafw00f,
searchsploit, Gobuster, ffuf, Waybackurls, Nikto, Nuclei, WPScan, Subzy, AWS CLI

## 7. Anexos

- Arquivos de output de cada ferramenta (01-intel/ a 05-vulns/)
EOF
```

---

### Checklist da Fase 7

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Relatório completo | `07-relatorio/relatorio-recon.md` | [ ] |
| 2 | Resumo executivo escrito | Seção 1 preenchida | [ ] |
| 3 | Todas as descobertas documentadas | Seção 4 preenchida | [ ] |
| 4 | Recomendações listadas | Seção 5 preenchida | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 7:

```
07-relatorio/
└── relatorio-recon.md    ← relatório completo e profissional
```

### ✅ Sinal de sucesso:
- O relatório tem **Resumo Executivo** que qualquer pessoa entende
- Cada vulnerabilidade tem: **nome, URL, evidência (comando+output), impacto, severidade**
- As **Recomendações** são específicas e acionáveis
- Outra pessoa consegue **replicar** o que você fez

**✅ Parabéns! Você completou o reconhecimento!**

---

## 📊 Visão Geral: Toda a Estrutura Final

Ao final das 7 fases, sua estrutura completa deve parecer:

```
~/recon/targets/evilcorp/
├── 01-intel/
│   ├── whois.txt
│   ├── dns-records.txt
│   ├── reverse-dns.txt
│   ├── subdominios-todos.txt
│   ├── subfinder.txt
│   ├── amass.txt
│   ├── crtsh.txt
│   ├── theharvester.txt
│   ├── google-dorks.txt
│   ├── wayback.txt
│   ├── gau.txt
│   ├── todas-urls.txt
│   └── shodan.json
├── 02-enum/
│   ├── resolvidos.txt
│   ├── vivos.txt
│   ├── vivos-filtrados.txt
│   ├── ips.txt
│   ├── nmap-ports.txt
│   ├── nmap-services.txt
│   ├── nmap-udp.txt
│   ├── banners.txt
│   ├── headers.txt
│   └── ssl-info.txt
├── 03-fingerprint/
│   ├── whatweb-principal.txt
│   ├── whatweb-todos.txt
│   ├── httpx-tech.txt
│   ├── waf-principal.txt
│   └── waf-todos.json
├── 04-discovery/
│   ├── gobuster-basico.txt
│   ├── ffuf-extensoes.json
│   ├── ffuf-recursive.json
│   ├── vhosts.json
│   ├── urls-com-parametros.txt
│   ├── parametros.json
│   ├── js-files.txt
│   ├── js-endpoints.txt
│   └── js-secrets.txt
├── 05-vulns/
│   ├── nikto.html
│   ├── nuclei.txt
│   ├── nmap-vuln.txt
│   ├── wpscan.txt
│   ├── s3-test.txt
│   ├── subzy.txt
│   ├── cnames.txt
│   └── searchsploit-results.txt
├── 06-validacao/
│   ├── validacao.md
│   └── resumo-severidade.md
└── 07-relatorio/
    └── relatorio-recon.md
```

**Total de arquivos esperados:** ~35-40 arquivos organizados por fase.

---

## 🔗 O que você precisa ter para avançar para os Próximos Módulos

Cada módulo do curso depende de dados específicos que você coletou aqui. Veja o que precisa estar **confirmado e documentado** antes de avançar:

### Para o Módulo 02 — Web & Aplicações

| Dado necessário | De onde vem | Onde está | Status ☑ |
|-----------------|-------------|-----------|:---:|
| **URLs ativas com status HTTP** | Fase 2 | `02-enum/vivos-filtrados.txt` | [ ] |
| **Versões de servidores web** | Fase 2 | `02-enum/nmap-services.txt` | [ ] |
| **CMS detectado (WordPress, etc)** | Fase 3 | `03-fingerprint/whatweb-principal.txt` | [ ] |
| **WAF detectado** | Fase 3 | `03-fingerprint/waf-principal.txt` | [ ] |
| **Diretórios encontrados** | Fase 4 | `04-discovery/gobuster-basico.txt` | [ ] |
| **URLs com parâmetros** | Fase 4 | `04-discovery/urls-com-parametros.txt` | [ ] |
| **Endpoints de API** | Fase 4 | `04-discovery/js-endpoints.txt` | [ ] |

**Para quê:** O Módulo 02 vai usar esses dados para testar SQLi, XSS, SSRF, CSRF nos endpoints que você encontrou.

### Para o Módulo 03 — Exploração

| Dado necessário | De onde vem | Onde está | Status ☑ |
|-----------------|-------------|-----------|:---:|
| **Versões de serviços com CVE** | Fase 3, 5 | `05-vulns/nmap-vuln.txt` | [ ] |
| **Plugins WordPress vulneráveis** | Fase 5 | `05-vulns/wpscan.txt` | [ ] |
| **Portas abertas e serviços** | Fase 2 | `02-enum/nmap-services.txt` | [ ] |
| **Credenciais encontradas** | Fase 4 | `04-discovery/js-secrets.txt` | [ ] |
| **Vulnerabilidades confirmadas** | Fase 6 | `06-validacao/resumo-severidade.md` | [ ] |

**Para quê:** O Módulo 03 vai usar esses dados para explotar as vulnerabilidades que você encontrou (Metasploit, Hydra, etc).

### Para o Módulo 04 — Pós-exploração

| Dado necessário | De onde vem | Onde está | Status ☑ |
|-----------------|-------------|-----------|:---:|
| **Subdomínios internos** | Fase 2, 4 | `02-enum/vivos-filtrados.txt` | [ ] |
| **IPs internos** | Fase 2 | `02-enum/ips.txt` | [ ] |
| **Serviços de rede (SSH, SMB, WinRM)** | Fase 2 | `02-enum/nmap-services.txt` | [ ] |

**Para quê:** O Módulo 04 vai usar esses dados para pivotar na rede interna, escalar privilégios, e manter acesso.

### Para o Módulo 06 — Análise de Rede

| Dado necessário | De onde vem | Onde está | Status ☑ |
|-----------------|-------------|-----------|:---:|
| **IPs alvo** | Fase 2 | `02-enum/ips.txt` | [ ] |
| **Portas e protocolos** | Fase 2 | `02-enum/nmap-ports.txt` | [ ] |
| **Serviços UDP** | Fase 2 | `02-enum/nmap-udp.txt` | [ ] |

**Para quê:** O Módulo 06 vai usar essos dados para capturar e analisar tráfego de rede (Wireshark, tcpdump).

### Resumo: O que NÃO pode faltar

```
MINÍMO PARA AVANÇAR:
├── 02-enum/vivos-filtrados.txt    ← saber quais URLs testar
├── 02-enum/nmap-services.txt      ← saber versões para buscar CVEs
├── 03-fingerprint/whatweb-principal.txt ← saber se é WordPress
├── 04-discovery/gobuster-basico.txt    ← saber quais diretórios existem
├── 06-validacao/resumo-severidade.md   ← saber quais vulns confirmar
└── 07-relatorio/relatorio-recon.md     ← documentar tudo
```

**Se tem esses 6 arquivos → PODE avançar para qualquer módulo.**

---

## 🔗 Conexão com os Próximos Módulos

Aqui está como o reconhecimento que você fez se conecta com CADA módulo do curso:

```
MÓDULO 01 (você está aqui)
    ↓ Você descobriu: URLs, portas, versões, vulnerabilidades
    ↓
MÓDULO 02 — Web & Aplicações
    ↓ Usa: URLs com parâmetros, diretórios, CMS detectado
    ↓ Testa: SQLi, XSS, SSRF, CSRF, autenticação
    ↓
MÓDULO 03 — Exploração
    ↓ Usa: portas abertas, versões com CVE, credenciais
    ↓ Usa: Metasploit, Hydra, Hashcat para explotar
    ↓
MÓDULO 04 — Pós-exploração
    ↓ Usa: IPs internos, subdomínios, serviços de rede
    ↓ Usa: LinPEAS, BloodHound, Mimikatz
    ↓
MÓDULO 05 — Reversing
    ↓ Usa: binários encontrados nos diretórios
    ↓ Usa: Ghidra, GDB, YARA
    ↓
MÓDULO 06 — Análise de Rede
    ↓ Usa: IPs e portas descobertos
    ↓ Usa: Wireshark, tcpdump, Bettercap
    ↓
MÓDULO 07 — Defesa
    ↓ Usa: vulnerabilidades encontradas para criar regras
    ↓ Usa: Wazuh, Suricata, Sigma
    ↓
MÓDULO 08 — Resposta a Incidentes
    ↓ Usa: logs e evidências coletadas
    ↓ Usa: Volatility, Autopsy, Sleuth Kit
    ↓
MÓDULO 09 — Ambientes
    ↓ Usa: Docker para criar labs de prática
    ↓ Reproduz: os ataques que você planejou
    ↓
MÓDULO 10 — Governança
    ↓ Usa: relatório que você escreveu
    ↓ Compara: com frameworks (NIST, MITRE, OWASP)
    ↓
MÓDULO 11 — IA
    ↓ Usa: ferramentas de IA para automatizar recon
    ↓ Melhora: os scans que você fez manualmente
```

---

## Fim do Reconhecimento

**Quando terminar a Fase 7, você terá:**
- Mapeado toda a superfície de ataque do alvo
- Identificado vulnerabilidades conhecidas
- Documentado tudo em um relatório profissional
- Sido capaz de justificar cada achado com evidências

**Próximo módulo:** [02 - Web & Aplicações](../02-web-aplicacoes/README.md)

---

## Script de Automação — Rodar Tudo de Uma Vez

> **Este script roda TODAS as 7 fases automaticamente.** Útil para quando você já entendeu o manual e quer agilidade. Salve como `recon.sh`, execute como `./recon.sh evilcorp.com`, e volte em 2-3 horas para ver os resultados.

```bash
#!/bin/bash
# Script de Automação — Reconhecimento Completo
# Uso: ./recon.sh <dominio>
# Exemplo: ./recon.sh evilcorp.com

# === CONFIGURAÇÃO ===
DOMINIO=$1
BASE_DIR="$HOME/recon/targets/$DOMINIO"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG="$BASE_DIR/logs/recon_$TIMESTAMP.log"

# Cores
VERDE="\033[0;32m"
VERMELHO="\033[0;31m"
AMARELO="\033[1;33m"
RESET="\033[0m"

log() { echo -e "[$(date +%H:%M:%S)] ${VERDE}[+]${RESET} $1" | tee -a "$LOG"; }
erro() { echo -e "[$(date +%H:%M:%S)] ${VERMELHO}[!]${RESET} $1" | tee -a "$LOG"; }
aviso() { echo -e "[$(date +%H:%M:%S)] ${AMARELO}[!]${RESET} $1" | tee -a "$LOG"; }

# === VERIFICAÇÕES ===
if [ -z "$DOMINIO" ]; then
    echo "Uso: $0 <dominio>"
    echo "Exemplo: $0 evilcorp.com"
    exit 1
fi

if ! command -v nmap &> /dev/null; then
    erro "Nmap não encontrado. Instale com: sudo apt install nmap"
    exit 1
fi

# === CRIAR ESTRUTURA ===
log "Criando estrutura de pastas para $DOMINIO..."
mkdir -p "$BASE_DIR"/{01-intel,02-enum,03-fingerprint,04-discovery,05-vulns,06-validacao,07-relatorio,logs}

log "Estrutura criada em: $BASE_DIR"
echo ""

# === FASE 1: INTELIGÊNCIA PASSIVA ===
log "========== FASE 1: INTELIGÊNCIA PASSIVA =========="

log "1.1 — WHOIS..."
whois "$DOMINIO" > "$BASE_DIR/01-intel/whois.txt" 2>/dev/null

log "1.2 — DNS Records..."
dig "$DOMINIO" ANY > "$BASE_DIR/01-intel/dns-records.txt" 2>/dev/null
dig +short "$DOMINIO" > "$BASE_DIR/01-intel/ip-direto.txt" 2>/dev/null

log "1.3 — Subfinder..."
subfinder -d "$DOMINIO" -silent > "$BASE_DIR/01-intel/subfinder.txt" 2>/dev/null

log "1.4 — Amass passivo..."
amass enum -passive -d "$DOMINIO" -o "$BASE_DIR/01-intel/amass.txt" 2>/dev/null

log "1.5 — crt.sh..."
curl -s "https://crt.sh/?q=$DOMINIO&output=json" | jq -r '.[].name_value' 2>/dev/null | sort -u > "$BASE_DIR/01-intel/crtsh.txt"

log "1.6 — theHarvester..."
theHarvester -d "$DOMINIO" -b google,bing,crtsh -f "$BASE_DIR/01-intel/theharvester.html" 2>/dev/null

log "1.7 — Combinar subdomínios..."
cat "$BASE_DIR/01-intel/subfinder.txt" "$BASE_DIR/01-intel/amass.txt" "$BASE_DIR/01-intel/crtsh.txt" 2>/dev/null | grep -i "$DOMINIO" | sort -u > "$BASE_DIR/01-intel/subdominios-todos.txt"

SUB_COUNT=$(wc -l < "$BASE_DIR/01-intel/subdominios-todos.txt" 2>/dev/null || echo "0")
log "Subdomínios encontrados: $SUB_COUNT"

log "1.8 — Wayback URLs..."
echo "$DOMINIO" | waybackurls > "$BASE_DIR/01-intel/wayback.txt" 2>/dev/null

log "1.9 — gau URLs..."
echo "$DOMINIO" | gau > "$BASE_DIR/01-intel/gau.txt" 2>/dev/null

log "1.10 — Combinar URLs..."
cat "$BASE_DIR/01-intel/wayback.txt" "$BASE_DIR/01-intel/gau.txt" 2>/dev/null | sort -u > "$BASE_DIR/01-intel/todas-urls.txt"

URL_COUNT=$(wc -l < "$BASE_DIR/01-intel/todas-urls.txt" 2>/dev/null || echo "0")
log "URLs históricas encontradas: $URL_COUNT"

log "Fase 1 concluída."
echo ""

# === FASE 2: ENUMERAÇÃO ATIVA ===
log "========== FASE 2: ENUMERAÇÃO ATIVA =========="

log "2.1 — Resolver DNS..."
cat "$BASE_DIR/01-intel/subdominios-todos.txt" | dnsx -silent -a > "$BASE_DIR/02-enum/resolvidos.txt" 2>/dev/null

log "2.2 — Validar HTTP vivos..."
cat "$BASE_DIR/02-enum/resolvidos.txt" | httpx -silent -status-code -title > "$BASE_DIR/02-enum/vivos.txt" 2>/dev/null

log "2.3 — Filtrar vivos (200/301/302)..."
cat "$BASE_DIR/02-enum/vivos.txt" | grep -E "\[200\]|\[301\]|\[302\]" > "$BASE_DIR/02-enum/vivos-filtrados.txt" 2>/dev/null

log "2.4 — Extrair IPs..."
cat "$BASE_DIR/02-enum/vivos.txt" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | sort -u > "$BASE_DIR/02-enum/ips.txt" 2>/dev/null

log "2.5 — Nmap ports (top 1000)..."
nmap -sT -Pn -p 21,22,25,53,80,110,143,443,993,995,3306,3389,5432,8080,8443,8888,9090 -T3 --max-rate 100 -iL "$BASE_DIR/02-enum/ips.txt" -oN "$BASE_DIR/02-enum/nmap-ports.txt" 2>/dev/null

log "2.6 — Nmap service detection..."
PORTAS=$(grep "open" "$BASE_DIR/02-enum/nmap-ports.txt" | awk '{print $1}' | cut -d'/' -f1 | tr '\n' ',' | sed 's/,$//')
if [ ! -z "$PORTAS" ]; then
    nmap -sV -sC -p "$PORTAS" -T3 --max-rate 100 -iL "$BASE_DIR/02-enum/ips.txt" -oN "$BASE_DIR/02-enum/nmap-services.txt" 2>/dev/null
fi

log "2.7 — Banner grabbing..."
for port in 21 22 25 80 443; do
    echo "=== Port $port ===" >> "$BASE_DIR/02-enum/banners.txt"
    echo "" | ncat -w 3 "$DOMINIO" $port 2>&1 >> "$BASE_DIR/02-enum/banners.txt" 2>/dev/null
done

log "2.8 — Headers HTTP..."
curl -sI "http://$DOMINIO" > "$BASE_DIR/02-enum/headers.txt" 2>/dev/null

log "Fase 2 concluída."
echo ""

# === FASE 3: FINGERPRINTING ===
log "========== FASE 3: FINGERPRINTING =========="

log "3.1 — WhatWeb principal..."
whatweb -a 3 "$DOMINIO" > "$BASE_DIR/03-fingerprint/whatweb-principal.txt" 2>/dev/null

log "3.2 — WhatWeb todos os subs..."
cat "$BASE_DIR/02-enum/vivos-filtrados.txt" | awk '{print $1}' | whatweb -a 3 -i - > "$BASE_DIR/03-fingerprint/whatweb-todos.txt" 2>/dev/null

log "3.3 — httpx tech detect..."
cat "$BASE_DIR/02-enum/vivos-filtrados.txt" | awk '{print $1}' | httpx -tech-detect -title -status-code -web-server -silent > "$BASE_DIR/03-fingerprint/httpx-tech.txt" 2>/dev/null

log "3.4 — Wafw00f..."
wafw00f "$DOMINIO" > "$BASE_DIR/03-fingerprint/waf-principal.txt" 2>/dev/null

log "Fase 3 concluída."
echo ""

# === FASE 4: DISCOVERY DE CONTEÚDO ===
log "========== FASE 4: DISCOVERY DE CONTEÚDO =========="

log "4.1 — Gobuster dirs..."
gobuster dir -u "http://$DOMINIO" -w /usr/share/wordlists/dirb/common.txt -t 20 -b 404,403 --delay 0.2s -o "$BASE_DIR/04-discovery/gobuster-basico.txt" 2>/dev/null

log "4.2 — ffuf extensões..."
ffuf -u "http://$DOMINIO/FUZZ" -w /usr/share/wordlists/dirb/common.txt -e .php,.bak,.txt,.zip,.sql,.env,.old -fc 404,403 -p 0.5 -o "$BASE_DIR/04-discovery/ffuf-extensoes.json" -of json 2>/dev/null

log "4.3 — URLs com parâmetros..."
cat "$BASE_DIR/01-intel/todas-urls.txt" | grep "=" | sort -u > "$BASE_DIR/04-discovery/urls-com-parametros.txt" 2>/dev/null

PARAM_COUNT=$(wc -l < "$BASE_DIR/04-discovery/urls-com-parametros.txt" 2>/dev/null || echo "0")
log "URLs com parâmetros: $PARAM_COUNT"

log "Fase 4 concluída."
echo ""

# === FASE 5: SCAN DE VULNERABILIDADES ===
log "========== FASE 5: SCAN DE VULNERABILIDADES =========="

log "5.1 — Nikto..."
nikto -h "http://$DOMINIO" -o "$BASE_DIR/05-vulns/nikto.html" -Format htm 2>/dev/null

log "5.2 — Nuclei..."
nuclei -u "http://$DOMINIO" -severity medium,high,critical -o "$BASE_DIR/05-vulns/nuclei.txt" 2>/dev/null

log "5.3 — Nmap vuln..."
nmap --script vuln -p "$PORTAS" -T3 -iL "$BASE_DIR/02-enum/ips.txt" -oN "$BASE_DIR/05-vulns/nmap-vuln.txt" 2>/dev/null

log "Fase 5 concluída."
echo ""

# === FASE 6: VALIDAÇÃO ===
log "========== FASE 6: VALIDAÇÃO =========="

log "6.1 — Criando checklist de validação..."
cat > "$BASE_DIR/06-validacao/validacao.md" << VALFIM
# Validação de Achados - $(date)
## Verifique manualmente cada achado abaixo:
- [ ] Abrir cada URL encontrada no navegador
- [ ] Confirmar que cada vulnerabilidade é REAL (não falso positivo)
- [ ] Testar cada achado com curl/ncat
- [ ] Organizar por severidade
VALFIM

log "Fase 6 concluída — VALIDE MANUALMENTE os achados."
echo ""

# === FASE 7: RELATÓRIO ===
log "========== FASE 7: RELATÓRIO =========="

log "7.1 — Criando relatório..."
cat > "$BASE_DIR/07-relatorio/relatorio-recon.md" << RELFIM
# Relatório de Reconhecimento

| Campo | Valor |
|-------|-------|
| **Alvo** | $DOMINIO |
| **Data** | $(date +%d/%m/%Y) |
| **Autor** | $(whoami) |
| **Classificação** | CONFIDENCIAL |

---

## 1. Resumo Executivo
[ESCREVA AQUI]

## 2. Escopo
- **Alcance:** $DOMINIO
- **Exclusões:** [ESCREVA AQUI]

## 3. Metodologia
| Fase | Resultados |
|------|------------|
| 1 - Inteligência Passiva | $SUB_COUNT subdomínios, $URL_COUNT URLs |
| 2 - Enumeração Ativa | $(wc -l < "$BASE_DIR/02-enum/vivos-filtrados.txt" 2>/dev/null) vivos |
| 3 - Fingerprinting | Ver 03-fingerprint/ |
| 4 - Discovery | $(wc -l < "$BASE_DIR/04-discovery/urls-com-parametros.txt" 2>/dev/null) URLs com params |
| 5 - Vulns | Ver 05-vulns/ |

## 4. Descobertas
[ESCREVA AQUI os achados de cada fase]

## 5. Recomendações
[ESCREVA AQUI]

## 6. Ferramentas Utilizadas
Subfinder, Amass, crt.sh, theHarvester, httpx, Nmap, ncat, WhatWeb, wafw00f, Gobuster, ffuf, Nikto, Nuclei

## 7. Anexos
- 01-intel/ — Inteligência passiva
- 02-enum/ — Enumeração ativa
- 03-fingerprint/ — Fingerprinting
- 04-discovery/ — Discovery de conteúdo
- 05-vulns/ — Vulnerabilidades
RELFIM

log "Relatório criado: $BASE_DIR/07-relatorio/relatorio-recon.md"
echo ""

# === RESUMO FINAL ===
log "============================================"
log "  RECONHECIMENTO CONCLUÍDO!"
log "============================================"
log ""
log "Estrutura: $BASE_DIR"
log ""
log "PRÓXIMOS PASSOS:"
log "1. VALIDE os achados na Fase 6 (abre cada URL, confirma cada vuln)"
log "2. PREENCHA o relatório na Fase 7"
log "3. Organize por severidade"
log "4. Avance para o Módulo 02 - Web & Aplicações"
log ""
log "Total de arquivos:"
find "$BASE_DIR" -type f | wc -l
log ""
log "Logs: $LOG"
```

**Como usar:**
```bash
# Salvar
nano recon.sh

# Tornar executável
chmod +x recon.sh

# Rodar (com VPN ligada!)
nordvpn connect
./recon.sh evilcorp.com

# Voltar em 2-3 horas e verificar os resultados
ls -la ~/recon/targets/evilcorp/
```

---

## Alvos para Praticar — Onde Treinar

> **NUNCA pratique em alvos reais sem autorização.** Use essas plataformas para treinar o que aprendeu no manual. Todas são gratuitas ou têm plano gratuito.

### TryHackMe (RECOMENDADO para iniciantes)

| Room | URL | O que pratica | Duração |
|------|-----|---------------|---------|
| **Recon** | tryhackme.com/room/recon | Subfinder, Nmap, enumeração | 2-3h |
| **被动 Recon** | tryhackme.com/room/passiverecon | Whois, DNS, Shodan, theHarvester | 2-3h |
| **Active Recon** | tryhackme.com/room/activerecon | Nmap, Gobuster, WhatWeb | 3-4h |
| **Nmap** | tryhackme.com/room/rnmap | Todos os tipos de scan Nmap | 2-3h |
| **Metasploit Intro** | tryhackme.com/room/metasploitintro | Metasploit básico | 3-4h |
| **Burp Suite** | tryhackme.com/room/burpsuitebasics | Proxy, Repeater, Intruder | 3-4h |
| **SQL Injection** | tryhackme.com/room/sqlinjectionlm | SQLi básico | 2-3h |
| **XSS** | tryhackme.com/room/xss | XSS básico | 2-3h |
| **OWASP Top 10** | tryhackme.com/room/owasptop10 | Top 10 vulnerabilidades | 4-6h |
| **Linux PrivEsc** | tryhackme.com/room/linuxprivesc | Escalação Linux | 3-4h |

**Como usar:**
1. Crie conta gratuita em https://tryhackme.com
2. Entre na room
3. Leia a teoria
4. Execute os comandos no laboratório virtual
5. Resolva os challenges

### HackTheBox (para intermediários)

| Machine | Tipo | O que pratica | Dificuldade |
|---------|------|---------------|-------------|
| **Starting Point** | Trace | Guiado passo-a-passo | Fácil |
| **Archetype** | Windows | SMB, SQL, privesc | Fácil |
| **Blue** | Windows | EternalBlue, Metasploit | Fácil |
| **Lame** | Linux | FTP, sudo, privesc | Fácil |
| **Jerry** | Windows | Tomcat, WAR deploy | Fácil |
| **Bastard** | Windows | Drupal, CVE, IIS | Médio |
| **Support** | Windows | SCCM, privesc | Médio |

**Como usar:**
1. Crie conta em https://hackthebox.com
2. Va para "Starting Point" (gratuito)
3. Resolva as máquinas guiadas
4. Depois, tente as máquinas do.Pro Labs

### PortSwigger Academy (para web)

| Lab | Vulnerabilidade | O que pratica | Dificuldade |
|-----|-----------------|---------------|-------------|
| **SQL Injection** | SQLi no login | Injeção SQL básica | Fácil |
| **SQL Injection (Union)** | Union-based SQLi | UNION SELECT | Médio |
| **Reflected XSS** | XSS refletido | Injeção de script | Fácil |
| **Stored XSS** | XSS armazenado | XSS persistente | Médio |
| **SSRF** | Server-Side Request Forgery | Acesso a redes internas | Médio |
| **CSRF** | Cross-Site Request Forgery | Forçar ações | Médio |
| **Path Traversal** | Directory Traversal | Acesso a arquivos | Fácil |
| **File Upload** | Upload malicioso | Web shell | Médio |

**Como usar:**
1. Acesse https://portswigger.net/web-security
2. Escolha um tópico
3. Leia a teoria
4. Resolva os labs (gratuitos)
5. Anote os payloads que funcionaram

### OverTheWire (para Linux/Reversing)

| Wargame | O que pratica | Dificuldade |
|---------|---------------|-------------|
| **Bandit** | Linux básico, comandos | Fácil |
| **Natas** | Web security | Médio |
| **Leviathan** | Reversing, binaries | Médio |
| **Krypton** | Criptografia | Médio |

### PicoCTF (para CTF)

| Category | O que pratica | Dificuldade |
|----------|---------------|-------------|
| **Web Exploitation** | SQLi, XSS, auth bypass | Fácil-Médio |
| **Cryptography** | Criptografia básica | Médio |
| **Reverse Engineering** | Reversing de binários | Médio |
| **Forensics** | Análise de arquivos | Médio |
| **Binary Exploitation** | Buffer overflow | Difícil |

### Plataforma escolhida por nível:

```
INICIANTE → TryHackMe (salas guiadas)
    ↓
INTERMEDIÁRIO → PortSwigger (web labs)
    ↓
INTERMEDIÁRIO → HackTheBox Starting Point
    ↓
AVANÇADO → HackTheBox machines
    ↓
EXPERT → OSCP labs, Pro Labs
```

---

## Guia de Validação Manual — Como Confirmar um Achado

> **Scanner encontrou algo? Não acredite cegamente.** Aqui está como confirmar CADA tipo de achado manualmente.

### 1. Como testar SQL Injection básico

**Cenário:** Você encontrou uma URL com parâmetro: `http://evilcorp.com/page?id=5`

```bash
# Teste 1: Adicionar aspas simples (causar erro de SQL)
curl -s "http://evilcorp.com/page?id=5'"
# Se retornar erro de SQL → VULNERÁVEL ✅
# Se retornar 200 normal → provavelmente NÃO é vulnerável

# Teste 2: Boolean-based (true/false)
curl -s "http://evilcorp.com/page?id=5 AND 1=1"  # Deve retornar a página normal
curl -s "http://evilcorp.com/page?id=5 AND 1=2"  # Deve retornar conteúdo diferente
# Se os dois retornos forem DIFERENTES → VULNERÁVEL ✅

# Teste 3: Comentário
curl -s "http://evilcorp.com/page?id=5--"
# Se retornar a página normal (sem erro) → pode ser vulnerável

# Teste 4: Time-based (mais confiável)
curl -s -o /dev/null -w "%{time_total}" "http://evilcorp.com/page?id=5 AND SLEEP(5)"
# Se demorar ~5 segundos → VULNERÁVEL ✅
# Se retornar rápido → NÃO é vulnerável
```

**Output que indica vulnerabilidade:**
```
You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version
```
```
Warning: mysql_fetch_array() expects parameter 1 to be resource, boolean given
```

### 2. Como testar XSS básico

**Cenário:** Você encontrou um campo de busca: `http://evilcorp.com/search?q=teste`

```bash
# Teste 1: Tag de script básica
curl -s "http://evilcorp.com/search?q=<script>alert(1)</script>"
# Se o output contiver <script>alert(1)</script> → pode ser vulnerável

# Teste 2: Verificar se o input é refletido
curl -s "http://evilcorp.com/search?q=TESTEXSS12345" | grep "TESTEXSS12345"
# Se aparecer no output → input é refletido (pré-requisito para XSS)

# Teste 3: Verificar se há sanitização
curl -s "http://evilcorp.com/search?q=<img/src=x onerror=alert(1)>"
# Se aparecer no output sem ser filtrado → VULNERÁVEL ✅

# Teste 4: Verificar Content-Type
curl -sI "http://evilcorp.com/search?q=teste" | grep -i "content-type"
# Se for text/html → XSS é possível
# Se for application/json → XSS é mais difícil
```

**⚠️ IMPORTANTE:** Não execute XSS em produção. Use apenas em labs (PortSwigger, TryHackMe).

### 3. Como confirmar um diretório 403

**Cenário:** Gobuster encontrou `/admin` com status 403.

```bash
# Teste 1: Verificar se é 403 real
curl -I http://evilcorp.com/admin
# 403 Forbidden = proteção real

# Teste 2: Tentar com POST
curl -X POST http://evilcorp.com/admin
# Se retornar 200 → pode ser bypassável

# Teste 3: Tentar com X-Forwarded-For
curl -H "X-Forwarded-For: 127.0.0.1" http://evilcorp.com/admin
# Se retornar 200 → pode ser bypassável

# Teste 4: Tentar com methods diferentes
curl -X PUT http://evilcorp.com/admin
curl -X DELETE http://evilcorp.com/admin
# Se algum retornar 200 → vulnerabilidade

# Teste 5: Tentar path traversal
curl http://evilcorp.com/admin/../
curl http://evilcorp.com/admin%2f
# Se retornar algo diferente → pode ser bypassável
```

### 4. Como confirmar WordPress

```bash
# Teste 1: Verificar generator tag
curl -s http://evilcorp.com | grep -i "generator"
# <meta name="generator" content="WordPress 5.7" /> → confirmado

# Teste 2: Verificar readme
curl -s http://evilcorp.com/readme.html | grep "WordPress"
# Se retornar versão → confirmado

# Teste 3: Verificar xmlrpc
curl -sI http://evilcorp.com/xmlrpc.php
# Se retornar 200 → ativo (pode ser usado para brute force)

# Teste 4: Verificar wp-login
curl -sI http://evilcorp.com/wp-login.php
# Se retornar 200 → login ativo
```

### 5. Como confirmar S3 Bucket exposto

```bash
# Teste 1: Listar bucket
aws s3 ls s3://NOME-BUCKET --no-sign-request
# Se retornar arquivos → EXPUESTO ✅

# Teste 2: Tentar download de arquivo
aws s3 cp s3://NOME-BUCKET/arquivo.txt . --no-sign-request
# Se funcionar → CRÍTICO ✅

# Teste 3: Testar variações do nome
for nome in evilcorp evil-corp evilcorp-prod evilcorp-backup evilcorp-staging; do
    echo "=== $nome ==="
    aws s3 ls s3://$nome --no-sign-request 2>&1
done
```

### 6. Como confirmar Subdomain Takeover

```bash
# Teste 1: Verificar CNAME
dig +short docs.evilcorp.com CNAME
# Se retornar CNAME para serviço externo → suspeito

# Teste 2: Verificar se serviço retorna erro
curl -I http://docs.evilcorp.com
# Se retornar:
# - "NoSuchBucket" → S3 não reclamado ✅
# - "Heroku Error Page" → Heroku não reclamado ✅
# - "GitHub Pages" → GitHub não reclamado ✅
# - "Fastly" → Fastly não reclamado ✅

# Teste 3: Subzy (já feito na Fase 5)
# Se retornou VULNERABLE → confirmado
```

### 7. Como confirmar Headers de Segurança Ausentes

```bash
# Verificar TODOS os headers
curl -sI http://evilcorp.com

# Verificar cada header individualmente
curl -sI http://evilcorp.com | grep -i "x-frame-options"
curl -sI http://evilcorp.com | grep -i "content-security-policy"
curl -sI http://evilcorp.com | grep -i "strict-transport-security"
curl -sI http://evilcorp.com | grep -i "x-content-type-options"
curl -sI http://evilcorp.com | grep -i "x-xss-protection"

# Se NÃO retornar nenhum → MÁ CONFIGURAÇÃO (reportar como MÉDIO)
```

### Tabela de decisão rápida:

| Scanner diz | Você confirma com | É vulnerabilidade? |
|-------------|-------------------|:---:|
| Nikto: `/admin` found | `curl -I http://alvo/admin` | ❌ Não (só existe) |
| Nikto: cookie sem httponly | `curl -sI \| grep set-cookie` | ✅ Sim (MÉDIO) |
| Nuclei: env-exposure | `curl -s http://alvo/.env` | ✅ Sim (CRÍTICO) |
| Nuclei: phpinfo | `curl -s http://alvo/phpinfo.php` | ✅ Sim (MÉDIO) |
| WPScan: plugin vulnerable | Verificar versão do plugin | ✅ Sim (ALTO-CRÍTICO) |
| Nmap: MySQL 3306 open | `nc -v alvo 3306` | ✅ Sim (ALTO) |
| Subzy: VULNERABLE | `curl -I http://sub.alvo` | ✅ Sim (CRÍTICO) |
| S3: bucket listável | `aws s3 ls` | ✅ Sim (CRÍTICO) |
| Gobuster: /backup 403 | `curl http://alvo/backup/` | ❌ Provavelmente não |
| Nmap: vuln script found | Manualmente testar exploit | ⚠️ Depende |

---

## Apêndice A — Troubleshooting

### Ferramenta não encontrada

| Ferramenta | Comando para instalar |
|------------|----------------------|
| subfinder | `sudo apt install subfinder` |
| httpx | `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` |
| nuclei | `sudo apt install nuclei` |
| katana | `go install github.com/projectdiscovery/katana/cmd/katana@latest` |
| dnsx | `go install github.com/projectdiscovery/dnsx/cmd/dnsx@latest` |
| ffuf | `sudo apt install ffuf` |
| gobuster | `sudo apt install gobuster` |
| amass | `sudo apt install amass` |
| wafw00f | `sudo apt install wafw00f` |
| nikto | `sudo apt install nikto` |
| wpscan | `sudo apt install wpscan` |
| ncat | `sudo apt install ncat` |
| proxychains4 | `sudo apt install proxychains4` |
| seclists | `sudo apt install seclists` |

### Scan muito lento

| Causa | Solução |
|-------|---------|
| Nmap -p- em IP grande | Use `-p 21,22,25,53,80,110,143,443,993,995,3306,3389,5432,8080,8443` |
| Gobuster com wordlist grande | Use `common.txt` (4600) em vez de `directory-list-2.3-medium.txt` (220k) |
| Amass enum completo | Use `-passive` para enumeração passiva |
| UDP scan | Limitze a `--top-ports 20` |

### Scan bloqueado

| Causa | Solução |
|-------|---------|
| WAF bloqueando | Reduza threads, adicione delay, use ProxyChains |
| IP banido | Espere 30 min ou mude de IP (VPN/Tor) |
| Rate limiting | Diminua `--min-rate` no Nmap, `-t` no Gobuster |

### Output vazio

| Ferramenta | Possível causa | Solução |
|------------|---------------|---------|
| subfinder | Domínio muito novo/privado | Use `-all` ou tente Amass |
| amass | Internet bloqueando APIs | Verifique conectividade |
| httpx | Subdomínios não respondem HTTP | Teste com `curl -I` manualmente |
| wafw00f | WAF não na database | Use `wafw00f -a` para testar todos |
| nuclei | Templates desatualizados | Rode `nuclei -update-templates` |

---

## Apêndice B — Referência Rápida

### Qual ferramenta usar?

| Cenário | Primária | Alternativa |
|---------|----------|-------------|
| Subdomínios passivos | Subfinder | Amass -passive |
| Subdomínios profundos | Amass -brute | Gobuster dns |
| Validar subdomínios | httpx | curl -I |
| Scan de portas | Nmap -sT | Masscan |
| Tecnologias | WhatWeb | httpx -tech-detect |
| WAF | Wafw00f | Headers manuais |
| Diretórios | Gobuster dir | ffuf |
| Fuzzing complexo | ffuf | Gobuster |
| Vulns web | Nikto + Nuclei | Nmap NSE |
| WordPress | WPScan | WhatWeb |
| Cloud | aws CLI | cloud_enum |
| Takeover | Subzy | Nuclei takeover |
| Banner | Ncat | curl -I |
| Anonimato | ProxyChains | VPN |

### Fluxo visual

```
PREPARAÇÃO
    ↓
FASE 1: Inteligência Passiva (não toca no alvo)
    ↓ WHOIS, DNS, Subfinder, Amass, crt.sh, theHarvest, Google Dorks, Wayback
    ↓
FASE 2: Enumeração Ativa (tocando no alvo)
    ↓ Validar subs (httpx) → Nmap ports → Service detection → Banner grab
    ↓
FASE 3: Fingerprinting
    ↓ WhatWeb, Wafw00f, httpx -tech-detect, searchsploit CVEs
    ↓
FASE 4: Discovery de Conteúdo
    ↓ Gobuster → ffuf → vhosts → params → JS analysis
    ↓
FASE 5: Scan de Vulnerabilidades
    ↓ Nikto, Nuclei, Nmap NSE, WPScan, Cloud, Takeover
    ↓
FASE 6: Validação
    ↓ Confirmar achados → Eliminar falsos positivos → Organizar
    ↓
FASE 7: Relatório
    ↓ Resumo → Escopo → Metodologia → Descobertas → Recomendações
    ↓
FIM ✓
```

---

## Apêndice C — O que fazer se NADA funcionar

Às vezes, TUDO dá errado. Aqui está o que fazer em cada cenário:

### Cenário 1: "O alvo não existe ou não tem website"

```bash
# Verificar se o domínio resolve
dig +short evilcorp.com

# Se não retornar nada:
# 1. Verifique se digitou certo
# 2. Tente com www: www.evilcorp.com
# 3. O domínio pode ser novo (menos de 24h)
# 4. O domínio pode ter expirado
```

**Alternativa:** Busque o domínio em https://who.is para confirmar se existe.

### Cenário 2: "WAF bloqueia TODOS os scans"

```bash
# 1. Use ProxyChains + Tor
proxychains4 nmap -sT -Pn -p 80,443 evilcorp.com

# 2. Reduza velocidade drasticamente
nmap -sT -Pn -p 80,443 -T1 --min-rate 100 evilcorp.com

# 3. Mude de IP (VPN)
# Conecte-se a uma VPN e repita o scan

# 4. Foque em inteligência passiva
# Use apenas Subfinder, Amass, crt.sh, Wayback (não tocam no alvo)
```

### Cenário 3: "Ferramentas Go não instalam"

```bash
# 1. Instale Go primeiro
sudo apt install golang

# 2. Configure GOPATH
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# 3. Adicione ao .bashrc para persistir
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc

# 4. Agora instale as ferramentas
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
```

### Cenário 4: "Scan retorna 0 resultados"

```bash
# 1. Verifique se o IP está correto
ping -c 1 evilcorp.com

# 2. Verifique se as portas estão realmente abertas
nmap -sT -Pn -p 80,443 evilcorp.com

# 3. Se 0 ports abertos, pode ser:
#    - Firewall bloqueando
#    - IP errado
#    - O serviço está em porta não padrão

# 4. Tente scan de ports ALTO
nmap -sT -Pn -p- -T4 evilcorp.com

# 5. Se ainda nada, pode ser que o alvo esteja MUITO protegido
# Nesse caso, documente: "Alvo não respondeu a scans"
```

### Cenário 5: "Nuclei não encontra nada"

```bash
# 1. Atualize templates
nuclei -update-templates

# 2. Rode com verbose
nuclei -u http://evilcorp.com -v

# 3. Rode com severity ALL (incluindo info)
nuclei -u http://evilcorp.com -severity info,low,medium,high,critical

# 4. Se ainda nada, o site pode estar muito bem protegido
# Foque em outros scanners (Nikto, Nmap NSE)
```

### Cenário 6: "Go não instala (erro de compilação)"

```bash
# Alternativa: use Docker
docker run -it projectdiscovery/subfinder -d evilcorp.com -silent

# Ou baixe binário pré-compilado
wget https://github.com/projectdiscovery/subfinder/releases/latest/download/subfinder_linux_amd64.zip
unzip subfinder_linux_amd64.zip
chmod +x subfinder
./subfinder -d evilcorp.com -silent
```

### Regra de ouro quando tudo falha

> **Se uma ferramenta não funciona, use a ALTERNATIVA da tabela de referência (Apêndice B). Se a alternativa também não funciona, documente o erro e AVANÇE para a próxima fase. Nunca pare uma fase inteira por causa de UMA ferramenta quebrada.**
