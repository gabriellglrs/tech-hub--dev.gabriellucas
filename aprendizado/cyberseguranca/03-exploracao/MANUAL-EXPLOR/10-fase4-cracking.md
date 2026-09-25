## FASE 4 — Cracking de Hashes (hashid, John, Hashcat)

**Tempo estimado:** 45-90 minutos
**Objetivo:** Transformar hashes coletados (Fase 1) em senhas legíveis — 100% offline, sem tocar no alvo.
**Por quê:** Hash cracking não gera NENHUM tráfego para o alvo (zero risco de ban/lockout) e frequentemente revela senhas reutilizadas em outros serviços.

> **📡 Dados usados nos passos abaixo (de onde vêm):**
> - **Input principal:** `15-alimentacao/hashes-suspeitos.txt` — consolidado na Fase 1 (Passo 1.6) a partir de:
>   - MANUAL-RECON: `04-discovery/js-secrets.txt` (hashes/senhas em JS e configs expostas)
>   - MANUAL-WEB: `10-injecao/sqlmap-dump.txt` (tabelas de usuário dumpadas por SQLMap — Fase 3 do Módulo 02) + `08-alimentacao/secrets-web.txt`
> - **Wordlists contextuais:** `15-alimentacao/wordlist-bruteforce.txt` ← CeWL do próprio site
> - **Credenciais em texto para reuso:** `15-alimentacao/credenciais-texto.txt` (testar na Fase 3)

---

### Passo 4.1 — Identificar o tipo de hash (hashid)

**O que você vai fazer:** NUNCA tente quebrar um hash sem saber o formato — usar o modo errado é perder horas. O `hashid` diz o que é.

```bash
# Instalar (primeira vez)
sudo apt install -y hashid

# Identificar um hash
hashid '5f4dcc3b5aa765d61d8327deb882cf99'

# Identificar todos do arquivo consolidado na Fase 1
# (vem de 04-discovery/js-secrets.txt + 10-injecao/sqlmap-dump.txt do MANUAL-WEB)
while read h; do
    echo "=== $h ==="
    hashid -m "$h" | grep -v "^$"
done < 15-alimentacao/hashes-suspeitos.txt > 18-cracking/hashid-resultados.txt

cat 18-cracking/hashid-resultados.txt
```

**✅ Output esperado (exemplo real):**
```
Hash: 5f4dcc3b5aa765d61d8327deb882cf99
[+] MD5
[+] Domain Cached Credentials - MD4(MD4(($pass)).(strtolower($username)))
```

**O que procurar:**
| Formato visto | Modo do Hashcat | John |
|---------------|:---:|------|
| MD5 (32 hex) | `-m 0` | `--format=raw-md5` |
| SHA1 (40 hex) | `-m 100` | `--format=raw-sha1` |
| SHA256 (64 hex) | `-m 1400` | `--format=raw-sha256` |
| `$2a$`/`$2y$` (bcrypt) | `-m 3200` | `--format=bcrypt` |
| NTLM (32 hex, Windows) | `-m 1000` | `--format=NT` |
| `$1$` (md5crypt) | `-m 500` | `--format=md5crypt` |
| `$6$` (sha512crypt) | `-m 1800` | `--format=sha512crypt` |
| `$apr1$` (Apache) | `-m 1600` | `--format=md5-apr` |

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Múltiplos formatos | Hash é genérico (hex puro) | Trate como MD5/SHA1 (mais comuns) e tente os dois |
| `hashid: command not found` | Não instalado | `sudo apt install hashid` |
| Não identifica | Formato exótico | `hashcat --example-hashes \| grep -i <trecho>` ou site https://hashcat.net/wiki/doku.php?id=example_hashes |

---

### Passo 4.2 — Crackear com John the Ripper (CPU, muitos formatos)

**O que você vai fazer:** John é o mais compatível e detecta o formato automaticamente. Comece sempre por ele.

```bash
# 1) Rodar com detecção automática + wordlist pequena
john --wordlist=/usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt \
    15-alimentacao/hashes-suspeitos.txt

# 2) Ver o que já foi quebrado (o mais importante!)
john --show 15-alimentacao/hashes-suspeitos.txt

# 3) Se não quebrou, aplique REGRAS (mutações: maiúscula, ano, símbolo)
john --wordlist=/usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt --rules \
    15-alimentacao/hashes-suspeitos.txt

# 4) Salvar resultados
john --show --format=raw-md5 15-alimentacao/hashes-suspeitos.txt > 18-cracking/john-resultados.txt
```

**✅ Output esperado (encontrou):**
```
Admin123       : (repr)
suporte2024    : suporte
evilcorp2024!  : admin

2 password hashes cracked, 1 left
```

**✅ Output esperado (`--show`):**
```
admin:Admin123
```

**O que procurar:** `usuário:senha` em cada linha. O que NÃO apareceu em `--show` continua pendente.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `Unknown ciphertext format` | Formato não detectado | `john --format=raw-md5 hash.txt` (force o formato) |
| 0 cracked | Wordlist fraca | Use `--rules`, depois rockyou, depois Hashcat |
| `Already cracked` | Rodou antes | É normal — `--show` mostra o histórico |
| Muito lento | Hash difícil (bcrypt) | Normal: bcrypt é lento **por design**. Deixe rodando ou use GPU |

---

### Passo 4.3 — Crackear com Hashcat (GPU, 100x mais rápido)

**O que você vai fazer:** Para hashes simples (MD5/SHA1/NTLM) em volume, Hashcat na GPU é imbatível.

```bash
# MD5 (modo 0)
hashcat -m 0 15-alimentacao/hashes-suspeitos.txt /usr/share/wordlists/rockyou.txt -o 18-cracking/hashcat-md5.txt

# SHA-256 (modo 1400)
hashcat -m 1400 15-alimentacao/hashes-suspeitos.txt /usr/share/wordlists/rockyou.txt -o 18-cracking/hashcat-sha256.txt

# NTLM (modo 1000) — Windows
hashcat -m 1000 15-alimentacao/hashes-suspeitos.txt /usr/share/wordlists/rockyou.txt -o 18-cracking/hashcat-ntlm.txt

# Ver resultados
hashcat -m 0 --show 15-alimentacao/hashes-suspeitos.txt
```

**✅ Output esperado (encontrou):**
```
5f4dcc3b5aa765d61d8327deb882cf99:password
Session..........: hashcat
Status...........: Cracked
Guesses Total: 14344385 TIME: 00:00:12
```

**O que procurar:** `hash:senha` no arquivo de output. Status `Cracked` = sucesso.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `No devices found` / GPU não detectada | Driver | Use John (CPU) ou `hashcat -D 1` (forçar CPU) |
| `Token length exception` | Hash inválido/lixo do grep | Filtre: só hashes de 32/40/64 chars hex |
| `Exhausted` (esgotou) | Wordlist não tem a senha | Passe para Passo 4.4 (regras e máscaras) |
| Muito lento em bcrypt | bcrypt é lento | Normal — deixe rodando horas ou use John |

---

### Passo 4.4 — Escalar: regras e máscaras (quando a wordlist falhou)

**O que você vai fazer:** Expandir uma wordlist pequena em milhões de variações (senha → Senha123! → senha2024...).

```bash
# === REGRAS (mutações inteligentes) ===
# best64 = 64 regras mais eficazes (80% dos casos)
hashcat -m 0 hashes.txt /usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt \
        -r /usr/share/hashcat/rules/best64.rule -o 18-cracking/hashcat-regras.txt

# Regra mais agressiva (demora mais)
hashcat -m 0 hashes.txt rockyou.txt -r /usr/share/hashcat/rules/d3ad0ne.rule

# === MÁSCARAS (brute force puro com padrão) ===
# ?l = minúscula, ?u = maiúscula, ?d = dígito, ?s = símbolo
hashcat -m 0 hashes.txt -a 3 ?l?l?l?l?l?d?d?d?d           # 4 letras + 4 dígitos
hashcat -m 0 hashes.txt -a 3 ?u?l?l?l?l?l?d?d?d?d?s?s      # Senha2024!
hashcat -m 0 hashes.txt -a 3 ?d?d?d?d?d?d?d?d              # só 8 dígitos

# === WORDLIST DO ALVO + REGRAS (combinação vencedora) ===
hashcat -m 0 hashes.txt 15-alimentacao/wordlist-bruteforce.txt \
        -r /usr/share/hashcat/rules/best64.rule -o 18-cracking/hashcat-cewl.txt
```

**✅ Output esperado (máscara acertou):**
```
5f4dcc3b5aa765d61d8327deb882cf99:password
Guesses Base: Wordlist (1000)
Guesses Loop: Mask (?l?l?l?l?l?d?d?d?d) (100000000)
Status.......: Cracked
```

**Ordem recomendada de escala:**
```
1. Top1000 + --rules          (segundos)
2. rockyou.txt                (minutos)
3. wordlist do alvo + rules   (minutos)  ← senhas contextuais
4. Máscara ?u?l?l?l?l?l?d?d?d?d?s?s (horas)
5. Brute force completo       (dias — quase nunca vale a pena)
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `Rule file not found` | Regra não existe | Confirme: `ls /usr/share/hashcat/rules/` |
| Máscara gigante (>8 posições) | Combinação explosiva | Mantenha máscaras curtas ou use `-i` incremental com limite |
| Nada quebra | Hash forte + senha forte | **Documente como "não crackeável com recursos atuais"** — é resultado válido |

---

### Passo 4.5 — Hashes especiais: /etc/shadow, NTLM, senhas de banco

```bash
# === /etc/shadow (vem de exploração/root — Módulo 04) ===
# Precisa de /etc/passwd + /etc/shadow juntos
unshadow /etc/passwd /etc/shadow > 18-cracking/shadow-combinado.txt
john --wordlist=/usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt --rules 18-cracking/shadow-combinado.txt

# === Vários hashes de uma vez (um por linha) ===
cat > 18-cracking/hash-lote.txt << 'EOF'
5d41402abc4b2a76b9719d911017c592
e99a18c428cb38d5f260853678922e03
098f6bcd4621d373cade4e832627b4f6
EOF
hashcat -m 0 18-cracking/hash-lote.txt /usr/share/wordlists/rockyou.txt

# === Hash de senha de banco (ex: MySQL) ===
# MySQL 5.x = SHA1(SHA1(senha)) → hashcat -m 3000
# MySQL 4.1+ = password() → identifique com hashid primeiro
```

**✅ Output esperado (`unshadow` + john):**
```
root:$6$xyz...:19793:0:99999:7:::
admin:$1$abc...:19793:0:99999:7:::

2 password hashes cracked, 0 left
```

---

### Passo 4.6 — Documentar resultados

```bash
cat > 18-cracking/hashes-crackeados.md << 'EOF'
# Hashes Crackeados — evilcorp.com

| # | Hash | Tipo | Senha | Origem (Fase 1) | Status |
|---|------|------|-------|-----------------|:---:|
| 1 | 5f4dcc3b5aa765d61d8327deb882cf99 | MD5 | password | js-secrets.txt (MANUAL-RECON `04-discovery/`) | ✅ |
| 2 | 5d41402abc4b2a76b9719d911017c592 | MD5 | hello | sqlmap-dump.txt (MANUAL-WEB `10-injecao/`) | ✅ |
| 3 | $2y$10$abc... | bcrypt | (não crackeado) | banco dump (MANUAL-WEB SQLMap) | ⏳ rockyou+rules rodando |

## Próximos passos com cada senha crackeada
- [ ] Testar no SSH (Fase 3): hydra -l admin -p <senha> ssh://10.0.0.1
- [ ] Testar no login web (Fase 3)
- [ ] Verificar reuso em outros hosts
- [ ] Registrar no relatório (Fase 7)
EOF
cat 18-cracking/hashes-crackeados.md
```

**O que procurar:** Senhas crackeadas viram `-p senha` (senha única) nos testes de reuso da Fase 3.

---

### Checklist da Fase 4

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Tipo de cada hash identificado | `18-cracking/hashid-resultados.txt` | [ ] |
| 2 | John rodou (wordlist + rules) | `18-cracking/john-resultados.txt` | [ ] |
| 3 | Hashcat rodou (se GPU ou volume) | `18-cracking/hashcat-*.txt` | [ ] |
| 4 | Regras/máscaras tentadas | `18-cracking/hashcat-regras.txt` | [ ] |
| 5 | Resultados documentados | `18-cracking/hashes-crackeados.md` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 4:

```
18-cracking/
├── hashid-resultados.txt     ← tipo de cada hash
├── john-resultados.txt       ← senhas quebradas pelo John
├── hashcat-md5.txt           ← resultados do Hashcat
├── hashcat-regras.txt        ← quebradas com regras
├── hashcat-cewl.txt          ← quebradas com wordlist do alvo
├── shadow-combinado.txt      ← (se aplicável) shadow do alvo
└── hashes-crackeados.md      ← ACHADO VALIDADO + origem
```

### ✅ Sinal de sucesso:
- Cada hash tem **tipo identificado** (ou é documentado como desconhecido)
- Pelo menos **1 hash crackeado** OU prova de que é forte demais para os recursos
- Senhas crackeadas **testadas em reuso** (Fase 3)

### ❌ Se falhou:
- Sem hashes para quebrar → volte à Fase 1, Passo 1.6 (o grep pode ter falhado).
- Tudo `Exhausted` → senhas fortes. Documente e avance; Fase 5 não depende de cracking.

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 4 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `hashes-crackeados.md` | Fase 3 (reuso) | Testar senha quebrada em outros serviços |
| `hashes-crackeados.md` | Fase 5 | Credenciais para módulos do Metasploit que exigem login |
| `hashes-crackeados.md` | Fase 6 e 7 | Evidência de impacto + métrica de crack |

**Se completou tudo → Avance para [Fase 5 — Exploração](11-fase5-exploracao.md)**
