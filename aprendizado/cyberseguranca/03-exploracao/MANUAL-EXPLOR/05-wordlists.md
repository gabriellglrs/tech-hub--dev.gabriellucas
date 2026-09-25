## Guia de Wordlists — Qual Usar para Cada Cenário

> **Usar a wordlist errada = horas perdidas ou lockout garantido.** Cada cenário tem uma wordlist ideal — e a ordem importa: SEMPRE comece pela menor.

### Regra de ouro

```
1. IDENTIFIQUE a tarefa (senha / usuário / diretório)
2. Comece pela lista MENOR (Top1000, top-usernames, common.txt)
3. Se não achou, ESCALE para a lista maior
4. rockyou.txt = ÚLTIMO RECURSO (14 milhões de senhas = lockout)
```

### Wordlists para Senhas (Brute Force e Cracking)

| Cenário | Wordlist | Caminho | Tamanho | Quando usar |
|---------|----------|---------|---------|-------------|
| **Primeiro teste** | `top-20.txt` | `/usr/share/seclists/Passwords/Common-Credentials/top-20.txt` | 20 | Teste rápido de credencial default |
| **Padrão (COMECE AQUI)** | `Top1000.txt` | `/usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt` | 1.000 | SSH/FTP sem risco alto de lockout |
| **Médio** | `Top10000.txt` | `/usr/share/seclists/Passwords/Leaked-Databases/Top10000.txt` | 10.000 | Se Top1000 falhou e há margem |
| **Completo** | `rockyou.txt` | `/usr/share/wordlists/rockyou.txt` | 14.000.000 | Só offline (cracking) ou lab controlado |
| **Credenciais default** | `Default-Credentials/` | `/usr/share/seclists/Passwords/Default-Credentials/` | variável | Routers, bancos de dados, painéis |
| **Senhas em português** | Gerar com Crunch/CeWL | veja abaixo | variável | Alvos brasileiros |

> ⚠️ **rockyou.txt em brute force ONLINE = travou a conta do alvo em minutos.** Use rockyou para CRACKING OFFLINE (Fase 4), não para Hydra (Fase 3).

### Wordlists para Usuários

| Cenário | Wordlist | Caminho | Tamanho |
|---------|----------|---------|---------|
| **Padrão (COMECE AQUI)** | `top-usernames-shortlist.txt` | `/usr/share/seclists/Usernames/top-usernames-shortlist.txt` | ~30 |
| **Usuários comuns** | `names.txt` | `/usr/share/seclists/Usernames/names.txt` | ~60.000 |
| **Variações de root/admin** | `roots.txt` | `/usr/share/seclists/Usernames/roots.txt` | ~100 |
| **Do próprio alvo** | `usernames-candidatos.txt` | `08-alimentacao/` (gerado na Fase 1) | 10-200 |

> 💡 **A melhor wordlist de usuários é a que veio DO ALVO** — emails do theHarvester (Módulo 01) e usuários descobertos no Módulo 02. Gere na Fase 1.

### Wordlists para Web (Fase 3 — HTTP forms e Fase 1)

| Cenário | Wordlist | Caminho | Quando usar |
|---------|----------|---------|-------------|
| **Parâmetros HTTP** | `burp-parameter-names.txt` | `/usr/share/seclists/Discovery/Web-Content/burp-parameter-names.txt` | Descobrir campos de form |
| **Diretórios comuns** | `common.txt` | `/usr/share/seclists/Discovery/Web-Content/common.txt` | Confirmar páginas de login |
| **Backups** | `backup.txt` | `/usr/share/seclists/Discovery/Web-Content/backup.txt` | Procurar .bak de configs com senhas |

### Wordlists customizadas (contexto do alvo)

```bash
# CeWL — extrai palavras do site do alvo (vira candidato a senha)
cewl http://evilcorp.com -d 2 -m 5 -w 11-cracking/cewl-evilcorp.txt
# -d 2 = profundidade de links, -m 5 = mínimo de 5 caracteres

# Crunch — gera por padrão (ex: 4 dígitos + "2024")
crunch 8 8 -t @@@@2024 -o 11-cracking/crunch-2024.txt
# @ = letra minúscula, % = número, ^ = símbolo

# Unir tudo e deduplicar (wordlist final do alvo)
cat /usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt \
    11-cracking/cewl-evilcorp.txt \
    11-cracking/crunch-2024.txt | sort -u > 11-cracking/wordlist-final.txt
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `cewl: command not found` | Não instalado | `sudo apt install cewl` |
| `crunch: command not found` | Não instalado | `sudo apt install crunch` |
| CeWL retorna 0 palavras | Site exige JS | Use `cewl -e "Mozilla/5.0..."` ou extraia manualmente do HTML |
| Wordlist gigante demais | Uniu tudo sem dedup | `sort -u` + `wc -l` para conferir tamanho |

### Referência rápida: qual usar?

| Tarefa | Wordlist | Ferramenta | Fase |
|--------|----------|-----------|:----:|
| Senha de SSH | `Top1000.txt` | Hydra | 3 |
| Usuário de SSH | `top-usernames-shortlist.txt` + `usernames-candidatos.txt` | Hydra | 3 |
| Login HTTP form | `Top1000.txt` | Hydra http-post-form | 3 |
| Senha de hash MD5 | `rockyou.txt` | Hashcat `-m 0` | 4 |
| Senha de hash NTLM | `rockyou.txt` | Hashcat `-m 1000` | 4 |
| Senha contexto do alvo | `cewl-evilcorp.txt` | John/Hashcat + `--rules` | 4 |

---

**Se entendeu qual usar → Avance para [06 - OPSEC](06-opsec.md)**
