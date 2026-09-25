## Guia de Wordlists — Qual Usar para Cada Cenário

> **Usar a wordlist errada = horas perdidas ou WAF bloqueando na primeira requisição.** Cada cenário tem a lista ideal — e a ordem importa: SEMPRE comece pela menor.

### Regra de ouro

```
1. IDENTIFIQUE a tarefa (diretório / parâmetro / usuário / senha)
2. Comece pela lista MENOR (common.txt, top-20, burp-parameter-names)
3. Se não achou, ESCALE (raft-medium, names.txt)
4. Com WAF ativo: REDUZA o tamanho e adicione delay — lista grande = ban
```

### Wordlists para Diretórios e Endereços (Fase 2)

| Cenário | Wordlist | Caminho | Quando usar |
|---------|----------|---------|-------------|
| **Padrão (COMECE AQUI)** | `common.txt` | `/usr/share/seclists/Discovery/Web-Content/common.txt` | Primeiro fuzzing de diretórios |
| **Médio** | `raft-medium-words.txt` | `/usr/share/seclists/Discovery/Web-Content/raft-medium-words.txt` | common.txt esgotou |
| **Extensões** | `raft-small-extensions.txt` | `/usr/share/seclists/Discovery/Web-Content/raft-small-extensions.txt` | Procurar `.bak`, `.env`, `.sql` |
| **Backups/sensíveis** | `backup.txt` | `/usr/share/seclists/Discovery/Web-Content/backup.txt` | Configs com senhas expostas |
| **APIs** | `api/` | `/usr/share/seclists/Discovery/Web-Content/api/` | Endpoints REST/JSON |
| **Subdomínios** | `subdomains-top1million-5000.txt` | `/usr/share/seclists/Discovery/DNS/` | Fuzzing de vhosts (se recon não cobriu) |

### Wordlists para Parâmetros (Fases 2 e 3)

| Cenário | Wordlist | Caminho |
|---------|----------|---------|
| **Parâmetros HTTP (COMECE AQUI)** | `burp-parameter-names.txt` | `/usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt` |
| **Parâmetros comuns** | `parameter-names.txt` | `/usr/share/seclists/Discovery/Web-Content/` |

> 💡 **Antes de fuzzar parâmetros, olhe o recon:** `04-discovery/urls-com-parametros.txt` e `js-endpoints.txt` já trazem parâmetros reais do alvo — mais eficaz que qualquer wordlist.

### Wordlists para Usuários e Senhas (Fases 4 e — se escopo permitir — brute force)

| Cenário | Wordlist | Caminho | Tamanho |
|---------|----------|---------|---------|
| **Usuários padrão** | `top-usernames-shortlist.txt` | `/usr/share/seclists/Usernames/top-usernames-shortlist.txt` | ~30 |
| **Usuários do alvo** | `usernames-web.txt` | `08-alimentacao/` (gerado na Fase 1) | 10-200 |
| **Credenciais default** | `Default-Credentials/` | `/usr/share/seclists/Passwords/Default-Credentials/` | variável |
| **Senhas rápidas** | `top-20.txt` | `/usr/share/seclists/Passwords/Common-Credentials/top-20.txt` | 20 |
| **Senhas médias** | `Top1000.txt` | `/usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt` | 1.000 |

> ⚠️ **`rockyou.txt` em brute force ONLINE = WAF/lockout em minutos.** Use rockyou apenas OFFLINE (cracking no Módulo 03). Brute force de login web só com autorização explícita (veja 06-opsec.md).

### Wordlists customizadas (contexto do alvo)

```bash
# CeWL — extrai palavras do site do alvo (vocabulário real para senhas/creds)
cewl http://evilcorp.com -d 2 -m 5 -w 08-alimentacao/cewl-evilcorp.txt
# -d 2 = profundidade de links, -m 5 = mínimo de 5 caracteres

# Unir tudo e deduplicar (wordlist final do alvo)
cat /usr/share/seclists/Passwords/Common-Credentials/top-20.txt \
    08-alimentacao/cewl-evilcorp.txt | sort -u > 08-alimentacao/wordlist-web.txt
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `cewl: command not found` | Não instalado | `sudo apt install cewl` |
| CeWL retorna 0 palavras | Site exige JS | `cewl -e "Mozilla/5.0..."` ou extraia do HTML |
| ffuf termina em segundos | Wordlist pequena demais | Escale para raft-medium |
| WAF bloqueia no meio | Lista grande/threads altas | `ffuf -t 5 -p 0.5` (5 threads, 0.5s delay) |

### Referência rápida: qual usar?

| Tarefa | Wordlist | Ferramenta | Fase |
|--------|----------|-----------|:----:|
| Diretórios ocultos | `common.txt` | ffuf, gobuster | 2 |
| Parâmetros em URLs | `burp-parameter-names.txt` | ffuf | 2 |
| Extensões (.env, .bak) | `raft-small-extensions.txt` | ffuf | 2 |
| Campos de formulário | inspecione no Burp/HTML | Burp Repeater | 3 |
| Usuários para enumeração | `usernames-web.txt` | Burp Intruder | 4 |
| Senhas de form (se permitido) | `top-20.txt` → `Top1000.txt` | Hydra | 4 |

---

**Se entendeu qual usar → Avance para [06 - OPSEC](06-opsec.md)**
