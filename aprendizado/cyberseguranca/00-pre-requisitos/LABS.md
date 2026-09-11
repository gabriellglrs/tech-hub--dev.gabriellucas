# Labs de Pré-Requisitos

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Computador com 4GB+ RAM | ⭐ | Para VirtualBox |
| Internet | ⭐ | Para downloads e labs online |
| Kali Linux instalado | ⭐⭐ | Veja [INSTALACAO.md](../INSTALACAO.md) |

---

## Labs por Plataforma

### TryHackMe (5 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | Intro to Networking | Modelos OSI, TCP/IP, protocolos | ⭐ | https://tryhackme.com/room/whatisnetworking |
| 2 | Intro to Networking (Room 2) | Endereçamento IP, subnets | ⭐ | https://tryhackme.com/room/introtonetworking |
| 3 | Linux Fundamentals Part 1 | Comandos básicos, navegação, permissões | ⭐ | https://tryhackme.com/room/linuxfundamentalspart1 |
| 4 | Linux Fundamentals Part 2 | Usuários, processos, gerenciamento de pacotes | ⭐⭐ | https://tryhackme.com/room/linuxfundamentalspart2 |
| 5 | Linux Fundamentals Part 3 | Permissões avançadas, services, cron jobs | ⭐⭐ | https://tryhackme.com/room/linuxfundamentalspart3 |

> **Nota:** URLs podem mudar — verifique no site da plataforma.

### OverTheWire — Bandit (1 lab, 34 níveis)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 6 | Bandit (34 levels) | Linux basics, file system, permissions, networking | ⭐-⭐⭐ | ssh://bandit.labs.overthewire.org:2220 |

**Como acessar Bandit:**

```bash
# Conectar ao nível 0 (senha: bandit0)
ssh bandit0@bandit.labs.overthewire.org -p 2220

# Nível 0
bandit0@bandit:~$ ls
# readme

bandit0@bandit:~$ cat readme
# boJ9jbbUNiy... (senha do próximo nível)
```

**Progressão dos níveis:**

| Nível | Habilidade | Dica |
|:------|:-----------|:-----|
| 0→1 | Ler arquivos | `cat` |
| 1→2 | Arquivos com espaços no nome | `cat "./arquivo com espaço"` |
| 2→3 | Arquivos ocultos | `ls -la` |
| 3→4 | Diretórios ocultos | `cd` + `ls` |
| 4→5 | Arquivos não legíveis | `file` para identificar tipo |
| 5→6 | Arquivos em outros diretórios | `find` |
| 7→8 | Arquivo com nome especial | `find -name` com wildcards |
| 8→10 | Modificar arquivos | `grep`, `sort`, `strings` |
| 11→15 | Criptografia básica | `tr`, `base64`, `rot13`, `openssl` |

> **Meta:** Chegar até o nível 10+ para ter base sólida de Linux.

### PicoCTF (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 7 | General Skills (picoGym) | Command line, scripting, encoding | ⭐-⭐⭐ | https://play.picoctf.org/practice |

> **Nota:** Acesse https://play.picoctf.org/ e navegue até "General Skills".

### HackTheBox (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 8 | Starting Point | Linux basics, networking, enumeration | ⭐⭐ | https://app.hackthebox.com/starting-point |

> **Nota:** HackTheBox Starting Point é guiado — ideal para iniciantes.

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 5 | Redes, Linux fundamentals |
| OverTheWire (Bandit) | 1 (34 níveis) | Linux CLI, file system, permissions |
| PicoCTF | 1 | General skills, scripting |
| HackTheBox | 1 | Starting point, enumeration |
| **Total** | **8** | |
