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
| Redirecionar output | `>`, `>>`, `\|` | Sabe que `comando > arquivo` salva output em arquivo | [Bash Guide: Redirection](https://tldp.org/LDP/abs/html/io-redirection.html) |
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
