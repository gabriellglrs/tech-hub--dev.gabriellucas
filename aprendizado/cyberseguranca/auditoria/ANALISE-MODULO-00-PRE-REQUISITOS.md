# ANÁLISE COMPLETA — MÓDULO 00: PRÉ-REQUISITOS

> Data: 2026-09-11
> Status: **PENDENTE DE CORREÇÃO**
> Nota atual: **5.5 / 10**

---

## 1. Resumo Executivo

O módulo 00-pre-requisitos possui uma **estrutura sólida** com 13 arquivos organizados em 4 pastas (Redes, Sistemas, Segurança, Ferramentas). A cobertura de redes é **forte** — IP, DNS, portas, TCP/UDP, OSI estão bem explicados com analogias e comandos práticos. Linux básico e HTTP/Web também estão razoáveis. No entanto, existem **lacunas críticas** que podem fazer um iniciante total ficar perdido no módulo 01. As principais falhas são: (1) **ausência de fundamentos de computação** (CPU, memória, processos, serviços, cliente/servidor), (2) **falta de explicação sobre o que é um "serviço"** antes de falar de portas, (3) **conceitos de segurança publicados na ordem errada** (fail2ban/UFW aparecem antes de o aluno entender o que é um ataque), (4) **Python e Windows podem ser postergados**, e (5) **falta uma ponte clara entre "conhecimentos teóricos" e "como usar no reconhecimento"**. O módulo 01 espera que o aluno já saiba usar `curl`, `dig`, `whois`, `nmap` e entender HTTP a fundo — o módulo 00 cobre parcialmente, mas não o suficiente para um zero total.

---

## 2. O que já está bom

**Pontos fortes do módulo:**

- **Redes (01-redes):** Excelente cobertura. IP, DNS, portas, TCP/UDP, OSI estão bem organizados com analogias do dia-a-dia, tabelas claras e comandos práticos. A progressão IP → DNS → Portas → TCP/IP é lógica.
- **Analogias visuais:** Cada arquivo usa diagramas ASCII e analogias caseiras (CEP, prédio de escritórios, etc.) — ótimo para iniciantes.
- **Comandos com output esperado:** Os arquivos mostram o comando E o que esperar de saída — essencial para quem nunca usou terminal.
- **Checkpoints:** Cada arquivo tem checkpoint com itens concretos — permite autoavaliação.
- **LABS.md bem estruturado:** Labs com TryHackMe, OverTheWire (Bandit), PicoCTF e HackTheBox Starting Point. Progressão clara.
- **HTTP/Web (07-http-e-web.md):** Bom coverage de métodos HTTP, status codes, headers, cookies, APIs. Curl e wget incluídos.
- **Ferramentas de rede (12-comandos-rede.md):** Boa compilação de comandos essenciais com exemplos práticos.
- **Editores de texto (13-editores-texto.md):** Nano e Vim cobertos adequadamente para um módulo de pré-requisitos.

---

## 3. O que está faltando

**Lacunas identificadas (classificadas por criticidade):**

### 🔴 Crítico (impede progressão para Módulo 01)

| # | Lacuna | Por quê é crítico |
|---|--------|-------------------|
| 1 | **Computação básica** — CPU, memória, processos, serviços, arquivos, diretórios, permissões, programas, cliente/servidor | O módulo 01 usa termos como "processo", "serviço", "daemon" sem explicar. Um zero total não sabe o que é um "serviço rodando em uma porta". |
| 2 | **Conceito de "serviço"** antes de portas | O arquivo 04 fala "porta 22 = SSH" mas nunca explica que SSH é um **programa que roda no servidor e "escuta" na porta 22**. O aluno entende a porta, mas não o serviço. |
| 3 | **Cliente/Servidor** — conceito fundamental | Módulo 01 usa "servidor web", "servidor DNS", "servidor de email" constantemente. O módulo 00 nunca define explicitamente o modelo cliente/servidor. |
| 4 | **TLS/SSL** — explicação superficial | O arquivo 07 menciona HTTPS = HTTP + TLS mas não explica o que TLS faz (troca de chaves, certificados, CA). Módulo 01 fala em "Certificate Transparency" e "certificados SSL" sem base. |
| 5 | **Orientação ética e legal** — completamente ausente | Módulo 01 ensina ferramentas de ataque (Nmap, Masscan, theHarvester). Não existe NENHUMA menção a: autorização, escopo, laboratório vs. alvo real, responsabilidade legal, diferença entre estudar e atacar. Isso é **obrigatório** antes de qualquer ferramenta ofensiva. |
| 6 | **O que é Cybersecurity** — definição formal ausente | O módulo pula direto para CIA/malware/fail2ban sem nunca responder "o que é segurança da informação?" de forma ampla. Falta: segurança ofensiva vs. defensiva, Red/Blue/Purple Team, SOC, pentest, vulnerability assessment. |

### ⚠️ Importante (causa dificuldade no Módulo 01)

| # | Lacuna | Impacto |
|---|--------|---------|
| 7 | **ARP** — não mencionado | Módulo 01 usa ARP em contexto de rede. O aluno não sabe o que é. |
| 8 | **NAT** — não explicado | CIDR e sub-rede estão lá, mas NAT (essencial para entender IP público vs. privado) é mencionado superficialmente. |
| 9 | **IPv6** — ausente | Módulo 01 menciona registros AAAA. O módulo 00 não explica o básico de IPv6. |
| 10 | **HTTP a fundo** — incompleto | Métodos GET/POST estão lá, mas faltam: PUT, PATCH, DELETE detalhados; Content-Type; Body vs. Headers; cookies detalhadamente; sessão vs. token; APIs RESTful. |
| 11 | **HTML/CSS/JS conceitual** — ausente | Para entender fingerprinting e JavaScript analysis, o aluno precisa saber o que é uma tag HTML, o que JavaScript faz no navegador, o que é um framework front-end. |
| 12 | **Banco de dados** — ausente | SQL Injection é o ataque #1 do OWASP. O aluno precisa entender o que é um banco de dados relacional e o que é SQL a nível conceitual. |
| 13 | **Ferramentas de reconhecimento** — conceito ausente | O módulo 00 não introduz a ideia de que existem ferramentas para coletar informações (OSINT). O módulo 01 lança o aluno direto em Nmap/Whois/dig sem contexto. |

### 🔄 Desejável (melhora experiência de aprendizado)

| # | Lacuna |
|---|--------|
| 14 | **VPN conceitual** — mencionado no glossário mas não explicado no módulo |
| 15 | **Proxy** — aparece no glossário mas não no módulo |
| 16 | **Logs e auditoria** — aparece no 09-conceitos-seguranca.md mas superficialmente |
| 17 | **Terminologia de ameaças** — threat actor, attack surface, asset, risk, impact estão parcialmente cobertos |
| 18 | **Conceito de "shell"** — não definido antes de ser usado no módulo 01 |
| 19 | **Pipe (|) no Linux** — fundamental para o pipeline subfinder | httpx | nuclei, mas não ensinado |

---

## 4. O que precisa ser melhor explicado

**Conteúdos existentes que estão superficiais ou confusos para iniciantes:**

### 4.1. `04-portas-e-protocolos.md` — Falta o conceito de serviço
- O arquivo explica portas e protocolos, mas **nunca define o que é um "serviço"**.
- Um iniciante lê "porta 22 = SSH" e entende a porta, mas não entende que existe um **programa (sshd)** rodando no servidor que "escuta" na porta 22 e aceita conexões.
- **Sugestão:** Adicionar seção "O que é um serviço?" antes de listar portas.

### 4.2. `09-conceitos-seguranca.md` — Tool cards prematuros
- O arquivo mistura conceitos fundamentais (CIA, malware, vetores de ataque) com **configuração prática de fail2ban, UFW, chmod/chown**.
- Um iniciante não consegue configurar fail2ban se ainda não entende o que é um "serviço" ou como o SSH funciona.
- **Sugestão:** Separar conceitos de segurança de ferramentas de segurança. Mover fail2ban/UFW para depois de Linux básico, ou melhor, integrar aos labs.

### 4.3. `06-linux-basico.md` — Falta serviços e processos
- O arquivo cobre navegação, arquivos, permissões e instalação de pacotes.
- Mas não explica **o que é um serviço no Linux**, como listar serviços (`systemctl`), como iniciar/parar serviços, o que é um daemon.
- Módulo 01 usa `systemctl` implicitamente ao falar de ferramentas que precisam ser instaladas e rodadas.
- **Sugestão:** Adicionar seção sobre serviços/systemd.

### 4.4. `10-python-basico.md` — Pode ser postergado
- Python é útil para automação avançada, mas **não é pré-requisito para o Módulo 01**.
- O Módulo 01 usa Go (subfinder, nuclei, httpx) — não Python.
- Manter Python no módulo 00 infla desnecessariamente e pode intimidar iniciantes.
- **Sugestão:** Mover Python para módulo posterior ou torná-lo opcional no 00.

### 4.5. `11-windows-basico.md` — Pode ser postergado
- Windows é importante para pentest corporativo, mas **não é pré-requisito para Reconhecimento**.
- O Módulo 01 foca em ferramentas Linux (Nmap, Subfinder, etc.).
- **Sugestão:** Mover Windows básico para módulo posterior (talvez junto com Active Directory no módulo 04).

---

## 5. O que está fora de lugar

**Conteúdos que deveriam ser movidos:**

| Conteúdo | Localização atual | Onde deveria estar |
|----------|-------------------|-------------------|
| fail2ban configuração | 09-conceitos-seguranca.md | Módulo 07 (Defesa) ou lab específico |
| UFW configuração detalhada | 09-conceitos-seguranca.md | Módulo 07 (Defesa) |
| chmod/chown detalhado | 09-conceitos-seguranca.md | 06-linux-basico.md (já tem parcialmente) |
| passwd configuração detalhada | 09-conceitos-seguranca.md | 06-linux-basico.md ou módulo posterior |
| Política de senha | 09-conceitos-seguranca.md | Módulo 07 (Defesa) |
| Python básico | 10-python-basico.md | Módulo posterior (opcional no 00) |
| Windows básico | 11-windows-basico.md | Módulo posterior (junto com AD) |
| Máquinas virtuais detalhado | 08-maquinas-virtuais.md | Pode ficar, mas simplificar (só VirtualBox + Kali + Metasploitable) |

---

## 6. O que pode ser removido

**Conteúdos desnecessários para esse estágio:**

| Conteúdo | Por quê remover |
|----------|-----------------|
| PowerShell detalhado (11-windows-basico.md) | Irrelevante para reconhecimento em Linux |
| Registry do Windows | Avançado demais para pré-requisitos |
| Ferramentas Windows (Process Explorer, Autoruns, etc.) | Módulo 01 não usa nenhuma |
| Scripts Python complexos (socket, hashlib) | Infla o módulo sem benefício imediato |
| Configuração de política de senha detalhada | Desnecessário para reconhecimento |
| Google Dorking no 00 | Não está no 00, mas se estivesse seria avançado |

---

## 7. Conhecimentos obrigatórios antes de Reconhecimento

**Lista priorizada — o que o aluno PRECISA saber antes de entrar no Módulo 01:**

### Tier 1 — Sem isso, o aluno fica completamente perdido

| # | Conhecimento | Nível | Por quê |
|---|-------------|-------|---------|
| 1 | O que é uma rede (LAN, WAN, Internet) | Conceitual | Base de tudo |
| 2 | O que é um IP (público vs. privado) | Conceitual + Operacional | Módulo 01 usa IP constantemente |
| 3 | O que é uma porta | Conceitual | "Portas abertas" é linguagem corrente |
| 4 | O que é um serviço | Conceitual | Sem isso, "porta 22 = SSH" não faz sentido |
| 5 | O que é DNS e como traduz nomes em IPs | Conceitual + Operacional | Módulo 01 começa com DNS enum |
| 6 | TCP vs. UDP (conceito básico) | Conceitual | Nmap usa SYN scan, connect scan |
| 7 | O que é um servidor web | Conceitual | Fundamental para entender HTTP |
| 8 | Modelo cliente/servidor | Conceitual | Toda comunicação web segue esse modelo |
| 9 | HTTP: request/response, métodos, status codes | Conceitual + Operacional | Módulo 01 usa curl, analisa responses |
| 10 | O que é um terminal/shell | Conceitual + Operacional | Toda ferramenta roda no terminal |
| 11 | Linux: navegação, arquivos, permissões, sudo | Operacional | Módulo 01 assume que o aluno sabe usar o terminal |
| 12 | O que é um CVE e vulnerabilidade | Conceitual | Módulo 01 fala em CVEs |
| 13 | Ética e legalidade | Conceitual | OBRIGATÓRIO antes de qualquer ferramenta ofensiva |
| 14 | O que é Cybersecurity (visão ampla) | Conceitual | Contextualiza todo o curso |

### Tier 2 — Muito importante, melhora显著emente a experiência

| # | Conhecimento | Nível |
|---|-------------|-------|
| 15 | Máscara de sub-rede e CIDR | Conceitual + Operacional |
| 16 | ICMP (ping, traceroute) | Conceitual + Operacional |
| 17 | ARP (básico) | Conceitual |
| 18 | TLS/SSL (o que é, certificados) | Conceitual |
| 19 | Headers HTTP detalhados | Conceitual |
| 20 | Cookies e sessões | Conceitual |
| 21 | O que é uma API REST | Conceitual |
| 22 | O que é HTML (básico) | Conceitual |
| 23 | O que é JavaScript (básico) | Conceitual |
| 24 | O que é um banco de dados relacional | Conceitual |
| 25 | VirtualBox e VMs | Operacional |
| 26 | O que é um firewall | Conceitual |
| 27 | Pipe (|) no Linux | Operacional |

### Tier 3 — Pode ser aprendido depois, mas melhora compreensão

| # | Conhecimento | Nível |
|---|-------------|-------|
| 28 | IPv6 (básico) | Conceitual |
| 29 | NAT (conceito) | Conceitual |
| 30 | DHCP | Conceitual |
| 31 | Modelo OSI (detalhado) | Conceitual |
| 32 | SSH (conceito, não configuração) | Conceitual |
| 33 | FTP/SFTP | Conceitual |
| 34 | SMTP | Conceitual |
| 35 | VPN (conceito) | Conceitual |
| 36 | Proxy (conceito) | Conceitual |

---

## 8. Conhecimentos recomendados, mas não obrigatórios

| # | Conhecimento | Por quê é opcional |
|---|-------------|-------------------|
| 1 | Python básico | Módulo 01 usa Go, não Python |
| 2 | Windows/PowerShell | Módulo 01 é todo Linux |
| 3 | Bash scripting | Útil mas não bloqueia |
| 4 | Containers/Docker | Pode ser introduzido depois |
| 5 | Cloud (AWS, Azure) | Módulo 08 cobre |
| 6 | Active Directory | Módulo 04 cobre |
| 7 | Criptografia | Módulo posterior |
| 8 | Engenharia reversa | Módulo 05 |
| 9 | Análise de malware | Módulo 08 |

---

## 9. Dependências entre assuntos

**Cadeia de dependências — qual conceito precisa vir antes de qual:**

```
COMPUTAÇÃO BÁSICA
├── CPU, Memória, Armazenamento
├── Processos e Serviços
├── Arquivos e Diretórios
├── Permissões (rwx)
└── Cliente / Servidor
        ↓
SISTEMAS OPERACIONAIS
├── Linux (terminal, comandos, navegação)
│   ├── pwd, ls, cd, cat, nano
│   ├── chmod, chown
│   ├── sudo, su
│   ├── apt (instalação)
│   ├── systemctl (serviços)
│   └── Pipes (|)
├── Editores (nano, vim)
└── Máquinas Virtuais (VirtualBox)
        ↓
REDES
├── O que é uma rede (LAN, WAN)
├── IP (público, privado)
│   └── Máscara, CIDR
├── Portas
│   └── O que é um SERVIÇO
├── TCP vs UDP
├── DNS (registros A, MX, NS)
│   ├── dig, nslookup
│   └── Whois
├── ICMP (ping, traceroute)
├── ARP
├── Modelo OSI / TCP-IP
├── TLS/SSL e certificados
└── Firewall (conceito)
        ↓
WEB
├── Internet vs. Web
├── URL, domínio, IP
├── HTTP/HTTPS
│   ├── Métodos (GET, POST, PUT, DELETE)
│   ├── Headers
│   ├── Status codes
│   ├── Cookies e sessões
│   └── Request/Response
├── HTML (básico conceitual)
├── JavaScript (básico conceitual)
├── APIs REST (JSON)
├── Frontend vs. Backend
└── Servidor web vs. Application server
        ↓
SEGURANÇA
├── O que é Cybersecurity
│   ├── Ofensiva vs. Defensiva
│   ├── Red / Blue / Purple Team
│   ├── SOC, Pentest, VA
│   └── CIA Triad
├── Ética e Legalidade
│   ├── Autorização e escopo
│   ├── Laboratório vs. alvo real
│   ├── Responsabilidade legal
│   └── Diferença entre estudar e atacar
├── Tipos de ameaças
│   ├── Threat actors
│   ├── Vulnerabilidade, Exploit, Payload
│   ├── CVE, CVSS
│   └── Zero-day
├── Malware (conceito)
└── Controles (preventivo, detectivo, corretivo)
        ↓
FERRAMENTAS ( conceito )
├── ping → testar conectividade
├── traceroute → ver rota
├── nslookup/dig → DNS
├── whois → registro de domínio
├── curl → requisições HTTP
├── wget → download
├── ip/ipconfig → ver IP
├── arp → tabela ARP
├── netstat/ss → portas abertas
├── nmap → scan de portas
└── theHarvester → coleta de dados
        ↓
RECONHECIMENTO (Módulo 01)
```

---

## 10. Análise da progressão pedagógica

**O módulo começa do-zero?** Parcialmente. Redes começa do zero (bom). Linux começa do zero (bom). Mas Computação básica (o que é um computador, processos, serviços) é **pulada completamente**.

**Existe salto de dificuldade?** Sim, em dois pontos:
1. O arquivo 04 (Portas e Protocolos) pressupõe que o aluno entende o que é um "serviço" — mas nunca explica.
2. O arquivo 09 (Conceitos de Segurança) mistura teoria (CIA) com prática avançada (fail2ban, UFW) — salto enorme para um iniciante.

**Conceito usado antes de ser explicado?** Sim:
- "SSH" aparece no arquivo 04 antes de ser definido como protocolo
- "daemon" não é explicado mas implicitamente usado
- "servidor web" é usado mas nunca definido formalmente como modelo cliente/servidor
- "CVE" aparece no 09 sem explicação prévia

**Termos técnicos sem definição?** Poucos, mas importantes:
- "encapsulamento" (arquivo 05) — mencionado mas não explicado intuitivamente
- "three-way handshake" — mencionado no 05 mas sem analogia clara

**Conteúdo avançado demais para pré-requisitos?** Sim:
- Configuração detalhada de fail2ban (jail.conf, maxretry, bantime)
- Configuração detalhada de UFW (políticas, regras, delete)
- Configuração de política de senha (login.defs)
- Python com socket programming
- Windows com PowerShell avançado

**O módulo ensina ferramenta antes de conceito?** Parcialmente:
- HTTP/Web (07) ensina conceito antes de ferramenta (bom)
- Linux (06) ensina comandos antes de explicar o filesystem (razoável)
- Portas (04) lista portas antes de explicar serviços (problema)
- Ferramentas de rede (12) lista comandos sem contexto prévio de por que existem

**A sequência prepara mentalmente para Reconhecimento?** Não completamente. O módulo termina com "Editores de Texto" — um anticlimax. O aluno deveria terminar o módulo 00 com a sensação de "estou pronto para descobrir coisas sobre um alvo", não com "sei editar arquivo com nano".

---

## 11. Transição 00 → 01

### O que exatamente o aluno precisa saber para acompanhar o Módulo 01:

Analisando os arquivos do Módulo 01 (01-dns-e-enumeracao.md, 02-osint-e-subdominios.md, 13-fingerprinting-web.md, 14-discovery-de-conteudo.md), o aluno precisa:

**Para 01-dns-e-enumeracao.md:**
- Saber o que é Whois e para que serve → ❌ Módulo 00 não ensina Whois
- Saber usar dig com registros A, MX, NS, TXT → ✅ Módulo 00 ensina
- Saber o que é ping e como usar → ✅ Módulo 00 ensina
- Saber o que é Nmap e como interpretar output → ❌ Módulo 00 não introduz Nmap conceitualmente
- Saber o que é um scan de portas e por que se faz → ⚠️ Módulo 00 fala de portas mas não de "escaneamento"
- Saber o que é Masscan → ❌ Módulo 00 não menciona
- Saber theHarvester → ❌ Módulo 00 não menciona

**Para 02-osint-e-subdominios.md:**
- Saber instalar Go e usar go install → ❌ Módulo 00 não ensina
- Saber o que é um pipeline (comando | comando | comando) → ❌ Módulo 00 não ensina pipes
- Saber o que é um subdomínio → ⚠️ Mencionado superficialmente
- Saber o que é API key → ❌ Não explicado
- Saber o que é Shodan → ❌ Módulo 00 não introduz

**Para 13-fingerprinting-web.md:**
- Saber o que é CMS → ❌ Módulo 00 não explica
- Saber o que é framework web → ❌ Módulo 00 não explica
- Saber o que é um User-Agent → ❌ Não explicado
- Saber interpretar output de WhatWeb → ❌ Não preparado

**Para 14-discovery-de-conteudo.md:**
- Saber o que é uma wordlist → ❌ Módulo 00 não introduz
- Saber o que é brute force conceitualmente → ⚠️ Mencionado no 09 mas não aplicado
- Saber a diferença entre 200, 301, 403, 404 → ✅ Módulo 00 ensina
- Saber usar ffuf/gobuster → ❌ Não preparado

### Conhecimentos obrigatórios antes do Reconhecimento:

| # | Conhecimento | Status no Módulo 00 |
|---|-------------|---------------------|
| 1 | IP, porta, DNS | ✅ Coberto |
| 2 | TCP/UDP | ✅ Coberto |
| 3 | Modelo OSI (básico) | ✅ Coberto |
| 4 | Linux terminal | ✅ Coberto |
| 5 | HTTP request/response | ✅ Coberto (mas pode ser mais profundo) |
| 6 | Status codes HTTP | ✅ Coberto |
| 7 | O que é um serviço | 🔴 Ausente |
| 8 | O que é um servidor | 🔴 Ausente |
| 9 | Ética e legalidade | 🔴 Ausente |
| 10 | O que é Cybersecurity | 🔴 Ausente |
| 11 | Whois (conceito) | 🔴 Ausente |
| 12 | O que é scan de portas | 🔴 Ausente |
| 13 | Conceito de OSINT | 🔴 Ausente |
| 14 | Pipes no Linux | 🔴 Ausente |
| 15 | Go (instalação) | 🔴 Ausente |

### Conhecimentos recomendados, mas não obrigatórios:

| # | Conhecimento |
|---|-------------|
| 1 | Máscara de sub-rede detalhada |
| 2 | ARP |
| 3 | TLS/SSL detalhado |
| 4 | APIs REST |
| 5 | HTML/JS conceitual |
| 6 | Banco de dados conceitual |
| 7 | VPN e Proxy |
| 8 | IPv6 |

### Conhecimentos que podem ser aprendidos posteriormente:

| # | Conhecimento |
|---|-------------|
| 1 | Python |
| 2 | Windows/PowerShell |
| 3 | Docker/Containers |
| 4 | Cloud |
| 5 | Active Directory |
| 6 | Criptografia |
| 7 | Engenharia reversa |
| 8 | Bash scripting avançado |

---

## 12. Nota atual

### Nota: **5.5 / 10**

### Justificativa detalhada:

| Critério | Nota | Comentário |
|----------|------|------------|
| **Cobertura** | 6/10 | Redes é forte. Computação básica ausente. Web razoável. Segurança parcial. Ética ausente. |
| **Profundidade** | 5/10 | Redes tem profundidade adequada. Linux é superficial (faltam serviços). HTTP é razoável. Python e Windows são profundos demais para o que é necessário. |
| **Clareza** | 7/10 | Analogias são excelentes. Formatação é boa. Checkpoints ajudam. Mas alguns conceitos são pulados. |
| **Ordem pedagógica** | 4/10 | Ordem das pastas é lógica (Redes → Sistemas → Segurança). Mas conteúdo dentro de cada pasta tem problemas: fail2ban antes de Linux completo, Python antes de ser necessário, Windows sem relevância imediata. |
| **Dificuldade** | 5/10 | Redes e Linux são acessíveis. O salto para fail2ban/UFW no arquivo 09 é grande. Python pode intimidar. |
| **Dependências** | 4/10 | Conceitos são usados antes de serem explicados (serviço, CVE, shell). Falta a cadeia completa computação → redes → web → segurança. |
| **Preparação para Reconhecimento** | 5/10 | O aluno sai sabendo IP/DNS/portas/Linux básico/HTTP. Mas não sai sabendo: ética, o que é scan, Whois, OSINT, pipes, Go, como interpretar resultados de ferramentas. |
| **Prática** | 6/10 | Labs são bons (TryHackMe, Bandit). Mas os labs do módulo não praticam exatamente o que o módulo 01 vai pedir. |
| **Coerência** | 6/10 | Tema geral é coerente. Mas a inclusão de Python e Windows quebra o foco. |
| **Lacunas** | 4/10 | Ética, computação básica, conceito de serviço, OSINT, pipes — são lacunas que causam dificuldade real. |

**Média ponderada: 5.5/10**

O módulo tem uma base sólida em redes e uma boa intenção pedagógica, mas falha em preparar o aluno para a realidade do Módulo 01. Um aluno que complete este módulo vai conseguir usar `ping` e `dig`, mas vai ficar perdido quando o Módulo 01 pedir para instalar Go, usar pipes, rodar Nmap, ou entender o que é fingerprinting. A ausência de ética e legalidade é uma falha grave que deve ser corrigida antes de qualquer conteúdo ofensivo.

---

## 13. Fontes utilizadas

| Fonte | Tipo | Utilização |
|-------|------|------------|
| **CompTIA Security+ SY0-701 Exam Objectives** | Certificação | Domínios e pré-requisitos de segurança |
| **TryHackMe Jr Penetration Tester Path** | Plataforma | Pré-requisitos e estrutura de aprendizado ofensivo |
| **TryHackMe Pre-Security Path** | Plataforma | Fundamentos de redes e Linux para iniciantes |
| **OWASP Web Security Testing Guide (WSTG)** | Padrão | Informação gathering, fingerprinting, enumeração |
| **Coursera - Linux Networking and Security** | Curso | Pré-requisitos de networking para segurança |
| **David Bombal / Occupy The Web** | Entrevista | Skills necessárias para cybersecurity em 2026 |
| **GitHub cybersecurity-roadmap-2025** | Roadmap | Fases de aprendizado e ordem de tópicos |
| **NIST Cybersecurity Framework** | Framework | Conceitos fundamentais de segurança |
| **PTES (Penetration Testing Execution Standard)** | Padrão | Metodologia de pentest e fases |
| **TCP/IP Guide (No Starch Press)** | Livro | Fundamentos de protocolos |
| **Documentação oficial Nmap, Subfinder, etc.** | Docs | Ferramentas usadas no Módulo 01 |
