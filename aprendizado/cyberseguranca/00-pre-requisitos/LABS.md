# Labs de Pre-Requisitos

## Pre-requisitos

| Pre-requisito | Nivel | Observacao |
|---------------|-------|------------|
| Computador com 4GB+ RAM | ⭐ | Para VirtualBox |
| Internet | ⭐ | Para downloads e labs online |
| Kali Linux instalado | ⭐⭐ | Veja [INSTALACAO.md](../INSTALACAO.md) |

---

## Labs por Plataforma

### TryHackMe (8 labs)

| # | Lab | Topicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | Intro to Networking | Modelos OSI, TCP/IP, protocolos | ⭐ | https://tryhackme.com/room/whatisnetworking |
| 2 | Intro to Networking (Room 2) | Enderecamento IP, subnets | ⭐ | https://tryhackme.com/room/introtonetworking |
| 3 | Linux Fundamentals Part 1 | Comandos basicos, navegacao, permissoes | ⭐ | https://tryhackme.com/room/linuxfundamentalspart1 |
| 4 | Linux Fundamentals Part 2 | Usuarios, processos, gerenciamento de pacotes | ⭐⭐ | https://tryhackme.com/room/linuxfundamentalspart2 |
| 5 | Linux Fundamentals Part 3 | Permissoes avancadas, services, cron jobs | ⭐⭐ | https://tryhackme.com/room/linuxfundamentalspart3 |
| 6 | Pre Security | Fundamentos gerais de seguranca | ⭐ | https://tryhackme.com/room/presecurity |
| 7 | Intro to Cyber Security | Introducao a cyberseguranca | ⭐ | https://tryhackme.com/room/introsecurity |
| 8 | Network Security | Seguranca de redes | ⭐⭐ | https://tryhackme.com/room/networksecurity |

> **Nota:** URLs podem mudar — verifique no site da plataforma.

### OverTheWire — Bandit (1 lab, 34 niveis)

| # | Lab | Topicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 9 | Bandit (34 levels) | Linux basics, file system, permissions, networking | ⭐-⭐⭐ | ssh://bandit.labs.overthewire.org:2220 |

**Como acessar Bandit:**

```bash
# Conectar ao nivel 0 (senha: bandit0)
ssh bandit0@bandit.labs.overthewire.org -p 2220

# Nivel 0
bandit0@bandit:~$ ls
# readme

bandit0@bandit:~$ cat readme
# boJ9jbbUNiy... (senha do proximo nivel)
```

**Progressao dos niveis:**

| Nivel | Habilidade | Dica |
|:------|:-----------|:-----|
| 0→1 | Ler arquivos | `cat` |
| 1→2 | Arquivos com espacos no nome | `cat "./arquivo com espaco"` |
| 2→3 | Arquivos ocultos | `ls -la` |
| 3→4 | Diretorios ocultos | `cd` + `ls` |
| 4→5 | Arquivos nao legiveis | `file` para identificar tipo |
| 5→6 | Arquivos em outros diretorios | `find` |
| 7→8 | Arquivo com nome especial | `find -name` com wildcards |
| 8→10 | Modificar arquivos | `grep`, `sort`, `strings` |
| 11→15 | Criptografia basica | `tr`, `base64`, `rot13`, `openssl` |

> **Meta:** Chegar ate o nivel 10+ para ter base solida de Linux.

### PicoCTF (1 lab)

| # | Lab | Topicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 10 | General Skills (picoGym) | Command line, scripting, encoding | ⭐-⭐⭐ | https://play.picoctf.org/practice |

> **Nota:** Acesse https://play.picoctf.org/ e navegue ate "General Skills".

### HackTheBox (1 lab)

| # | Lab | Topicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 11 | Starting Point | Linux basics, networking, enumeration | ⭐⭐ | https://app.hackthebox.com/starting-point |

> **Nota:** HackTheBox Starting Point e guiado — ideal para iniciantes.

### PortSwigger (Web Security)

| # | Lab | Topicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 12 | Web Security Academy | HTTP, web vulnerabilities, APIs | ⭐-⭐⭐ | https://portswigger.net/web-security |

> **Nota:** Labs gratuitos de web security — essencial para entender HTTP na pratica.

---

## Labs por Topico

### Redes e Protocolos

| Lab | Plataforma | O que pratica |
|:----|:-----------|:--------------|
| Intro to Networking | TryHackMe | OSI, TCP/IP, protocolos |
| Intro to Networking (Room 2) | TryHackMe | IP, subnets, DNS |
| Network Security | TryHackMe | Seguranca de redes |

### Linux e Sistemas

| Lab | Plataforma | O que pratica |
|:----|:-----------|:--------------|
| Linux Fundamentals 1-3 | TryHackMe | Comandos, usuarios, processos |
| Bandit (OverTheWire) | OverTheWire | Linux CLI, file system |
| Starting Point | HackTheBox | Linux, enumeration |

### Web e HTTP

| Lab | Plataforma | O que pratica |
|:----|:-----------|:--------------|
| Web Security Academy | PortSwigger | HTTP, web vulnerabilities |
| Pre Security | TryHackMe | Fundamentos gerais |

### Seguranca Geral

| Lab | Plataforma | O que pratica |
|:----|:-----------|:--------------|
| Pre Security | TryHackMe | Fundamentos de seguranca |
| Intro to Cyber Security | TryHackMe | Introducao a cyberseguranca |
| General Skills | PicoCTF | Command line, scripting |

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 8 | Redes, Linux, seguranca geral |
| OverTheWire (Bandit) | 1 (34 niveis) | Linux CLI, file system, permissions |
| PicoCTF | 1 | General skills, scripting |
| HackTheBox | 1 | Starting point, enumeration |
| PortSwigger | 1 | Web security, HTTP |
| **Total** | **12** | |
