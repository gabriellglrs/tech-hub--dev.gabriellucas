## Alvos para Praticar — Onde Treinar

> **NUNCA pratique em alvos reais sem autorização.** Use essas plataformas para treinar o que aprendeu no manual. Todas são gratuitas ou têm plano gratuito.

### TryHackMe (RECOMENDADO para iniciantes)

| Room | URL | O que pratica | Duração |
|------|-----|---------------|---------|
| **Brute It** | tryhackme.com/room/bruteit | Hydra SSH, hash cracking, privesc | 1-2h |
| **Hashing Fun** | tryhackme.com/room/hashingfun | John, Hashcat, identificar hashes | 1h |
| **Metasploit Intro** | tryhackme.com/room/metasploitintro | msfconsole, search, use, sessions | 3-4h |
| **Kenobi** | tryhackme.com/room/kenobi | Exploração Samba + privesc | 2-3h |
| **Ice** | tryhackme.com/room/ice | MS17-010, Metasploit, Meterpreter | 3-4h |
| **Mr Robot** | tryhackme.com/room/mrrobot | Brute force + exploração + privesc | 4-6h |
| **Buffer Overflow Prep** | tryhackme.com/room/bufferoverflowprep | checksec, GDB, ROP (avançado) | 4-6h |

**Como usar:**
1. Crie conta gratuita em https://tryhackme.com
2. Conecte na VPN da plataforma (não use VPN comercial junto)
3. Entre na room e leia a teoria
4. Execute os comandos deste manual no laboratório virtual
5. Resolva os challenges

### HackTheBox (para intermediários)

| Machine | Tipo | O que pratica | Dificuldade |
|---------|------|---------------|-------------|
| **Starting Point (Exploit)** | Guiado | Exploração básica, privesc | Fácil |
| **Blue** | Windows | EternalBlue + Metasploit (Fase 5) | Fácil |
| **Lame** | Linux | FTP + sudo (Fases 3 e 6) | Fácil |
| **Jerry** | Windows | Tomcat, deploy de WAR (Fase 5) | Fácil |
| **Kenobi** | Linux | Samba exploit | Fácil |

**Como usar:**
1. Crie conta em https://hackthebox.com
2. Vá para "Starting Point" (gratuito)
3. Aplique este manual: Fase 1 (alimente com o recon) → 2 → 3 → 5

### OverTheWire (binary exploitation — avançado)

| Wargame | O que pratica | Dificuldade |
|---------|---------------|-------------|
| **Narnia** (10 levels) | Buffer overflow, format string | ⭐⭐-⭐⭐⭐ |
| **Behemoth** (9 levels) | Binary exploitation avançado, ROP | ⭐⭐⭐ |

**Como usar:** `ssh narnia.labs.overthewire.org -p 2226` (senha: narnia)

### PicoCTF / CyLab

| Category | O que pratica | Dificuldade |
|----------|---------------|-------------|
| **Binary Exploitation** (30+ challenges) | Buffer overflow, format string, heap | ⭐-⭐⭐⭐⭐ |
| **Web Exploitation** | Exploração de autenticação | Fácil-Médio |

**Como usar:** https://play.picoctf.org/practice

### Prática local (com os próprios scripts do manual)

| Exercício | Comando | O que pratica |
|-----------|---------|---------------|
| Hydra SSH | `hydra -l admin -P /usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt -t 4 -f ssh://192.168.1.1` | Fase 3 |
| John + Hashcat | `hashcat -m 0 hash.txt /usr/share/wordlists/rockyou.txt` | Fase 4 |
| CeWL | `cewl http://target.com -d 2 -m 5 -w wordlist.txt` | Fase 1 |
| Metasploit | `msfconsole` → `use exploit/...` | Fase 5 |

### Plataforma escolhida por nível:

```
INICIANTE → TryHackMe (Brute It, Hashing Fun, Metasploit Intro)
    ↓
INTERMEDIÁRIO → HackTheBox Starting Point + Blue
    ↓
INTERMEDIÁRIO → PicoCTF Binary Exploitation
    ↓
AVANÇADO → OverTheWire Narnia/Behemoth
    ↓
EXPERT → HackTheBox machines, OSCP labs
```

---
