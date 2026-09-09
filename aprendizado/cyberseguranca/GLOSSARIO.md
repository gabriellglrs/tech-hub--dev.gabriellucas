# 📖 Glossário de Cybersegurança

> Todos os termos técnicos usados nesta trilha, explicados de forma simples para quem está começando.

---

## 🔤 Índice

- [A](#a) | [B](#b) | [C](#c) | [D](#d) | [E](#e) | [F](#f) | [G](#g) | [H](#h) | [I](#i) | [J](#j) | [K](#k) | [L](#l) | [M](#m) | [N](#n) | [O](#o) | [P](#p) | [Q](#q) | [R](#r) | [S](#s) | [T](#t) | [U](#u) | [V](#v) | [W](#w) | [X](#x) | [Y](#y) | [Z](#z)

---

## Termos por Categoria

### 🌐 Redes e Internet

| Termo | O que é (explicação simples) | Exemplo |
|:------|:-----------------------------|:--------|
| **IP** | Endereço de uma máquina na rede, como um CEP | 192.168.1.1 |
| **Porta** | "Porta de entrada" de um serviço (22=SSH, 80=HTTP) | Como apartamentos em um prédio |
| **DNS** | Traduz nomes em IPs (google.com → 142.250.74.46) | Como uma agenda telefônica |
| **HTTP** | Protocolo para sites (texto plano, sem criptografia) | http://exemplo.com |
| **HTTPS** | HTTP com criptografia (SSL/TLS) | https://exemplo.com |
| **SSH** | Acesso remoto seguro via terminal | ssh usuario@servidor |
| **FTP** | Transferência de arquivos (antigo, inseguro) | ftp://servidor |
| **SMTP** | Envio de emails | Porta 25, 587 |
| **Proxy** | Intermediário entre você e a internet | Como um novo intermediário |
| **VPN** | Rede privada virtual (criptografa tudo) | Como um túnel seguro |
| **LAN** | Rede local (casa, escritório) | 192.168.0.0/24 |
| **WAN** | Rede ampla (internet) | A internet inteira |

### 🔒 Segurança

| Termo | O que é | Exemplo |
|:------|:--------|:--------|
| **Firewall** | Barreira que filtra tráfego (bloqueia/libera) | UFW, iptables |
| **WAF** | Firewall específico para sites | Cloudflare, ModSecurity |
| **IDS** | Detector de intrusões (monitora e alerta) | Suricata, Snort |
| **IPS** | IDS que também bloqueia automaticamente | Suricata em modo inline |
| **SIEM** | Centraliza logs e detecta padrões | Wazuh, ELK Stack |
| **Vulnerabilidade** | Fraqueza que pode ser explorada | CVE-2024-1234 |
| **Exploit** | Código que explora uma vulnerabilidade | Buffer overflow |
| **Payload** | Código malicioso que é executado | Reverse shell |
| **Shell** | Interface de comando (terminal) | bash, zsh |
| **Reverse Shell** | Shell que volta para o atacante | Netcat, socat |
| **Bind Shell** | Shell que espera conexão no alvo | netcat -l -p 4444 |
| **Privilege Escalation** | Ganhar mais permissões (user → root) | sudo, SUID |
| **Root** | Administrador do Linux (acesso total) | root@servidor |
| **Admin** | Administrador do Windows | Administrator |

### 🕵️ Reconhecimento

| Termo | O que é | Exemplo |
|:------|:--------|:--------|
| **OSINT** | Inteligência de fontes públicas | Google, LinkedIn, Shodan |
| **Reconhecimento** | Coletar informações sobre o alvo | Whois, Nmap |
| **Enumeração** | Descobrir detalhes específicos | Subdomínios, portas |
| **Scan** | Varredura para encontrar algo | Nmap scan de portas |
| **Banner** | Informação que o serviço revela | "Apache 2.4.49" |
| **Subdomínio** | Parte do domínio principal | api.empresa.com |
| **FQDN** | Nome completo do domínio | www.google.com |

### 🌐 Web

| Termo | O que é | Exemplo |
|:------|:--------|:--------|
| **CMS** | Sistema para criar sites | WordPress, Joomla |
| **Framework** | Biblioteca para desenvolver | Laravel, Django |
| **API** | Interface para comunicação entre sistemas | REST, GraphQL |
| **Endpoint** | URL de uma API | /api/users |
| **JWT** | Token de autenticação | eyJhbGciOiJIUzI1... |
| **CORS** | Controle de acesso cross-origin | Access-Control-Allow-Origin |
| **CSP** | Política de segurança de conteúdo | Content-Security-Policy |
| **Cookie** | Dados salvos no navegador | Sessão, preferências |
| **Session** | Sessão do usuário logado | PHPSESSID |

### 💉 Vulnerabilidades Web

| Termo | O que é | Exemplo |
|:------|:--------|:--------|
| **SQL Injection** | Injetar SQL em formulários | ' OR 1=1 -- |
| **XSS** | Injetar JavaScript em páginas | `<script>alert(1)</script>` |
| **CSRF** | Fingir que é o usuário | Formulário falso |
| **BOLA** | Acessar dados de outros (APIs) | /users/2 sendo user 1 |
| **IDOR** | Acesso indevido por ID | Similar ao BOLA |
| **LFI** | Ler arquivos do servidor | ../../etc/passwd |
| **RFI** | Carregar arquivos remotos | http://evil.com/shell.php |
| **SSRF** | Fazer servidor acessar algo | http://localhost/admin |
| **Clickjacking** | Enganar com iframe invisível | Página falsa por cima |
| **Open Redirect** | Redirecionamento maligno | site.com/?url=evil.com |

### 🔑 Exploração

| Termo | O que é | Exemplo |
|:------|:--------|:--------|
| **Brute Force** | Testar senhas automaticamente | Hydra testando 1000 senhas |
| **Wordlist** | Lista de palavras para brute force | rockyou.txt |
| **Hash** | Senha transformada (irreversível) | MD5, SHA256, bcrypt |
| **Cracking** | Quebrar hashes | John, Hashcat |
| **Dictionary Attack** | Usar dicionário de palavras | Hydra com wordlist |
| **Rainbow Table** | Tabela pré-calculada de hashes | Tabelas gigantes |
| **Buffer Overflow** | Sobrescrever memória | EIP overwritten |
| **ROP** | Ret-Oriented Programming | Gadgets de assembly |
| **NOP Sled** | Sequência de NOPs | 0x90 repetido |
| **Payload** | Código que executa | msfvenom -p shell |

### 🔬 Engenharia Reversa

| Termo | O que é | Exemplo |
|:------|:--------|:--------|
| **Binário** | Programa compilado (executável) | ELF, .exe |
| **Decompilar** | Voltar para código fonte | Ghidra |
| **Assembly** | Linguagem de máquina legível | MOV EAX, 1 |
| **Debug** | Executar passo a passo | GDB, x64dbg |
| **Debugger** | Ferramenta de debug | GDB, OllyDbg |
| **Gadget** | Sequência de assembly em binário | pop rdi; ret |
| **NX/DEP** | Não executar stack | Proteção contra shellcode |
| **PIE** | Endereços aleatórios | ASLR para código |
| **ASLR** | Endereços aleatórios | Proteção de memória |
| **Canary** | Valor de proteção na stack | Detecta overflow |

### 🛡️ Defesa

| Termo | O que é | Exemplo |
|:------|:--------|:--------|
| **Hardening** | Tornar sistema mais seguro | Desativar serviços desnecessários |
| **Patching** | Atualizar com correções | sudo apt update |
| **Least Privilege** | Menor permissão possível | Usuário comum ≠ root |
| **Defense in Depth** | Múltiplas camadas de defesa | Firewall + IDS + Monitoramento |
| **Zero Trust** | Não confiar em ninguém | Verificar tudo sempre |
| **Compliance** | Seguir normas/leis | ISO 27001, LGPD |
| **GRC** | Governança, Risco, Conformidade | Gestão de segurança |
| **Risk** | Probabilidade de incidente | Alto/Médio/Baixo |
| **Asset** | O que precisa ser protegido | Servidor, dados, usuários |
| **Threat** | Perigo potencial | Atacante, malware |
| **Incident** | Evento de segurança | Vazamento de dados |

### 🔍 Forense e Resposta

| Termo | O que é | Exemplo |
|:------|:--------|:--------|
| **Forense** | Investigação digital | Análise de evidências |
| **Chain of Custody** | Rastreabilidade de evidências | Quem pegou, quando |
| **Timeline** | Linha do tempo de eventos | 10:00 - login, 10:05 - download |
| **Malware** | Software malicioso | Virus, trojan, ransomware |
| **Ransomware** | Sequestra dados e cobra resgate | WannaCry |
| **Rootkit** | Esconde processos maliciosos | Kernel rootkit |
| **Backdoor** | Porta dos fundos para acesso | Porta 31337 |
| **C2** | Comando e controle | Servidor do atacante |
| **Exfiltration** | Levar dados para fora | Upload para servidor externo |

### ☁️ Cloud e Containers

| Termo | O que é | Exemplo |
|:------|:--------|:--------|
| **Cloud** | Computação em nuvem | AWS, Azure, GCP |
| **Container** | Ambiente isolado | Docker |
| **Docker** | Plataforma de containers | docker run nginx |
| **Kubernetes** | Orquestração de containers | kubectl, pods |
| **IAM** | Gerenciamento de identidade | AWS IAM |
| **S3** | Storage na AWS | aws s3 ls |
| **Serverless** | Código sem servidor | AWS Lambda |
| **IaC** | Infraestrutura como código | Terraform |

### 📱 Mobile

| Termo | O que é | Exemplo |
|:------|:--------|:--------|
| **APK** | Pacote Android | app.apk |
| **IPA** | Pacote iOS | app.ipa |
| **Root (Android)** | Acesso total ao dispositivo | Magisk |
| **Jailbreak (iOS)** | Acesso total ao dispositivo | checkra1n |
| **Frida** | Hook dinâmico | frida -U -f com.app |
| **Objection** | Exploração mobile | objection explore |

### 📡 Wireless

| Termo | O que é | Exemplo |
|:------|:--------|:--------|
| **WPA2** | Protocolo de segurança WiFi | Senha do WiFi |
| **Handshake** | Autenticação WiFi | Captura para cracking |
| **Evil Twin** | WiFi falso | Redes abertas |
| **Deauth** | Desautenticar dispositivo | aireplay-ng |
| **PMKID** | Tipo de handshake | hashcat -m 22000 |

### 🏛️ Governança

| Termo | O que é | Exemplo |
|:------|:--------|:--------|
| **LGPD** | Lei Geral de Proteção de Dados | Lei 13.709/2018 |
| **GDPR** | Regulamento europeu de dados | Equivalente à LGPD |
| **ISO 27001** | Padrão internacional de segurança | Certificação |
| **NIST** | Framework dos EUA | CSF, 800-53 |
| **CIS Controls** | 18 controles prioritários | Center for Internet Security |
| **Risk Assessment** | Avaliação de riscos | Matriz de risco |
| **Business Impact** | Impacto no negócio | Alto/Médio/Baixo |
| **Audit** | Auditoria de segurança | Verificação de conformidade |

### 🔐 Criptografia

| Termo | O que é | Exemplo |
|:------|:--------|:--------|
| **Criptografia** | Transformar dados em código | AES, RSA |
| **Hash** | Transformação unidirecional | MD5, SHA256 |
| **Chave** | Senha da criptografia | 256 bits |
| **Simétrica** | Mesma chave para cifrar/decifrar | AES |
| **Assimétrica** | Chave pública + privada | RSA, ECC |
| **Digital Signature** | Prova de autenticidade | Assinar documento |
| **Certificate** | Certificado digital | SSL/TLS |
| **PKI** | Infraestrutura de chaves | CAs, certificados |

### 🛠️ Ferramentas

| Termo | O que é | Categoria |
|:------|:--------|:----------|
| **Nmap** | Scanner de portas | Reconhecimento |
| **Wireshark** | Analisador de pacotes | Rede |
| **Burp Suite** | Proxy para testes web | Web |
| **Metasploit** | Framework de exploits | Exploração |
| **SQLMap** | SQL Injection automático | Web |
| **Hydra** | Brute force em serviços | Exploração |
| **John** | Quebrador de hashes | Exploração |
| **Hashcat** | Quebrador de hashes (GPU) | Exploração |
| **Ghidra** | Descompilador | Reversa |
| **GDB** | Debugger Linux | Reversa |
| **LinPEAS** | Enumeração Linux | Pós-Exp |
| **WinPEAS** | Enumeração Windows | Pós-Exp |
| **Impacket** | Biblioteca Python para redes | Pós-Exp |
| **socat** | Conexões de rede avançadas | Rede |
| **netcat** | Ferramenta de rede swiss-army | Rede |
| **Gobuster** | Descoberta de diretórios | Web |
| **ffuf** | Fuzzing web | Web |
| **Nikto** | Scanner de vulnerabilidades | Web |
| **Trivy** | Scanner de containers | Cloud |
| **Suricata** | IDS/IPS | Defesa |

---

## 📝 Siglas Comuns

| Sigla | Significado |
|:------|:------------|
| **CVE** | Common Vulnerabilities and Exposures (identificador de vulnerabilidade) |
| **CVSS** | Common Vulnerability Scoring System (nota de gravidade) |
| **OWASP** | Open Worldwide Application Security Project |
| **CISO** | Chief Information Security Officer |
| **SOC** | Security Operations Center |
| **APT** | Advanced Persistent Threat |
| **IOC** | Indicator of Compromise |
| **TTP** | Tactics, Techniques, and Procedures |
| **MITRE** | Organização que mantém ATT&CK Framework |
| **OSINT** | Open Source Intelligence |
| **BOLA** | Broken Object Level Authorization |
| **BFLA** | Broken Function Level Authorization |
| **SSRF** | Server-Side Request Forgery |
| **LFI** | Local File Inclusion |
| **RFI** | Remote File Inclusion |
| **XSS** | Cross-Site Scripting |
| **CSRF** | Cross-Site Request Forgery |
| **CSP** | Content Security Policy |
| **CORS** | Cross-Origin Resource Sharing |
| **WAF** | Web Application Firewall |
| **IDS** | Intrusion Detection System |
| **IPS** | Intrusion Prevention System |
| **SIEM** | Security Information and Event Management |
| **GRC** | Governance, Risk, and Compliance |
| **IAM** | Identity and Access Management |
| **RBAC** | Role-Based Access Control |
| **ELF** | Executable and Linkable Format (Linux) |
| **PE** | Portable Executable (Windows) |
| **DLL** | Dynamic Link Library |
| **SUID** | Set User ID |
| **SGID** | Set Group ID |
| **ROP** | Return-Oriented Programming |
| **DEP** | Data Execution Prevention |
| **ASLR** | Address Space Layout Randomization |
| **PIE** | Position-Independent Executable |
| **NX** | No-Execute |
| **WPA2** | Wi-Fi Protected Access 2 |
| **PMKID** | Pairwise Master Key Identifier |
| **K8s** | Kubernetes |
| **IaC** | Infrastructure as Code |
| **CI/CD** | Continuous Integration/Continuous Deployment |
| **LGPD** | Lei Geral de Proteção de Dados |
| **GDPR** | General Data Protection Regulation |
| **NIST** | National Institute of Standards and Technology |
| **CIS** | Center for Internet Security |
| **ISO** | International Organization for Standardization |
| **OSCP** | Offensive Security Certified Professional |
| **CEH** | Certified Ethical Hacker |
| **PTX** | eLearnSecurity Penetration Tester Extreme |

---

<div align="center">

**Voltar ao [README Principal](README.md)**

</div>
