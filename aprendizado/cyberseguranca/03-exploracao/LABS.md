# Labs de Exploração

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Kali Linux | ⭐⭐ | Com Metasploit, Hydra, Hashcat |
| Módulos 1-2 | ⭐⭐⭐ | Recon e Web concluídos |
| Wordlists | ⭐⭐ | SecLists instalado |

---

## Labs por Plataforma

### TryHackMe (7 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | Brute It (SSH) | Hydra SSH brute force, hash cracking | ⭐⭐ | https://tryhackme.com/room/bruteit |
| 2 | Hashing Fun | Hashing, cracking, john, hashcat | ⭐⭐ | https://tryhackme.com/room/hashingfun |
| 3 | Metasploit Intro | msfconsole, search, use, exploit, sessions | ⭐⭐ | https://tryhackme.com/room/metasploitintro |
| 4 | Kenobi | Samba exploit, privesc, path manipulation | ⭐⭐ | https://tryhackme.com/room/kenobi |
| 5 | Ice | MS17-010, Metasploit, Meterpreter | ⭐⭐⭐ | https://tryhackme.com/room/ice |
| 6 | Mr Robot | Brute force, exploitation, privilege escalation | ⭐⭐⭐ | https://tryhackme.com/room/mrrobot |
| 7 | Buffer Overflow Prep | checksec, Ghidra, GDB, ROP chains | ⭐⭐⭐ | https://tryhackme.com/room/bufferoverflowprep |

> **Nota:** URLs podem mudar — verifique no site da plataforma.

### OverTheWire (2 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 8 | Narnia (10 levels) | Binary exploitation, buffer overflow, format string | ⭐⭐-⭐⭐⭐ | ssh://narnia.labs.overthewire.org:2226 |
| 9 | Behemoth (9 levels) | Binary exploitation avançado, ROP | ⭐⭐⭐ | ssh://behemoth.labs.overthewire.org:2221 |

### PicoCTF (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 10 | Binary Exploitation (30+) | Buffer overflow, format string, heap | ⭐-⭐⭐⭐⭐ | https://play.picoctf.org/practice |

### HackTheBox (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 11 | Starting Point (Exploit) | Basic exploitation, privesc | ⭐⭐ | https://app.hackthebox.com/starting-point |

### Prática Local (3 labs)

| # | Lab | Tópicos | Dificuldade | Comando |
|---|-----|---------|-------------|---------|
| 12 | Hydra SSH/FTP brute force | Hydra com wordlists | ⭐⭐ | `hydra -l admin -P /usr/share/seclists/Passwords/Top1000.txt ssh://192.168.1.1` |
| 13 | John + Hashcat cracking | MD5, NTLM, bcrypt | ⭐⭐ | `hashcat -m 0 hash.txt /usr/share/seclists/Passwords/rockyou.txt` |
| 14 | CeWL wordlist generation | Gerar wordlist de site | ⭐⭐ | `cewl http://target.com -d 2 -m 5 -w wordlist.txt` |

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 7 | Brute force, Metasploit, exploitation |
| OverTheWire | 2 | Binary exploitation (Narnia, Behemoth) |
| PicoCTF | 1 | Binary exploitation (30+ challenges) |
| HackTheBox | 1 | Starting point exploitation |
| Local | 3 | Hydra, hashcat, CeWL |
| **Total** | **14** | |
