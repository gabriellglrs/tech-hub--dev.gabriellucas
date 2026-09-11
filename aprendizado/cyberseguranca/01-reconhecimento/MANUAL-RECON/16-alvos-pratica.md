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
