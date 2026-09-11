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
