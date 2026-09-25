## FASE 1 — Alimentação (importar Módulos 01 e 02)

**Tempo estimado:** 20-40 minutos
**Objetivo:** Consolidar TUDO que você já descobriu no recon (Módulo 01) e no web testing (Módulo 02) em listas de alvos prontas para atacar.
**Por quê:** Exploração às cegas = travar contas erradas e perder horas. Os dados já existem — aqui você só organiza o que os módulos anteriores produziram.

---

### Passo 1.1 — Verificar que os dados dos módulos anteriores existem

**O que você vai fazer:** Confirmar que o recon do Módulo 01 e os testes web do Módulo 02 (MANUAL-WEB) foram feitos neste alvo. Sem eles, não há Fase 1.

```bash
# Entrar na pasta do alvo
cd ~/recon/targets/evilcorp

# Ver a estrutura completa (01 a 14 deve existir: 01-07 = Módulo 01, 08-14 = Módulo 02)
ls -la

# Verificar os 3 arquivos MÍNIMOS do Módulo 01 (MANUAL-RECON)
ls -la 02-enum/nmap-services.txt 05-vulns/nmap-vuln.txt 06-validacao/resumo-severidade.md

# Verificar os arquivos do Módulo 02 (MANUAL-WEB) — a Fase 1 também importa deles
ls -la 09-descoberta/logins-formularios.txt 09-descoberta/logins-web.txt 08-alimentacao/secrets-web.txt 2>/dev/null
```

**✅ Output esperado:**
```
02-enum/nmap-services.txt     ← portas, serviços e versões (MANUAL-RECON)
05-vulns/nmap-vuln.txt        ← vulnerabilidades detectadas pelo Nmap NSE (MANUAL-RECON)
06-validacao/resumo-severidade.md ← vulnerabilidades confirmadas por severidade (MANUAL-RECON)

09-descoberta/logins-formularios.txt ← campos de login web (MANUAL-WEB, Passo 2.9)
09-descoberta/logins-web.txt         ← caminhos de login/painel (MANUAL-WEB, Passo 2.9)
08-alimentacao/secrets-web.txt       ← segredos críticos de JS (MANUAL-WEB, Passo 1.7)
```

**O que procurar:** Se os 3 arquivos do Módulo 01 existem e não estão vazios, você pode avançar. Os arquivos do Módulo 02 são obrigatórios para o Passo 1.4 (formulários) — se não existirem, preencha-os manualmente ou complete o MANUAL-WEB antes.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `No such file or directory` (Módulo 01) | Recon não rodou neste alvo | Volte ao Módulo 01 e complete as fases 2, 5 e 6 |
| `logins-formularios.txt` não existe | Você não fez o MANUAL-WEB (Fase 2) | Preencha manualmente no Passo 1.4 — abra os logins no navegador (F12 → Network) |
| Arquivo vazio (0 bytes) | Scan falhou | Rode o scan de novo: `nmap -sV -oN 02-enum/nmap-services.txt <ip>` |
| Pasta `targets/` não existe | Você nunca fez recon | `mkdir -p ~/recon/targets/evilcorp` e comece pelo Módulo 01 |

---

### Passo 1.2 — Extrair serviços e portas (do Módulo 01)

**O que você vai fazer:** Transformar o output do Nmap numa lista `IP:PORTA:serviço` — é esta lista que diz "aqui tem brute force possível".

```bash
# Criar a pasta da fase
mkdir -p 15-alimentacao

# Extrair linhas com "open" do Nmap → alvos-servicos.txt
grep "open" 02-enum/nmap-services.txt | grep -v "Nmap scan" | \
  awk '{print $1": "$3" "$4}' > 15-alimentacao/alvos-servicos.txt

# Ver o que temos
cat 15-alimentacao/alvos-servicos.txt
```

**✅ Output esperado (exemplo real):**
```
10.0.0.1: 22/tcp OpenSSH 8.9p1
10.0.0.1: 21/tcp vsftpd 3.0.3
10.0.0.1: 80/tcp Apache httpd 2.4.41
10.0.0.1: 445/tcp Samba smbd 4.11.6
10.0.0.1: 3306/tcp MySQL 5.7.42
10.0.0.1: 3389/tcp ms-wbt-server
```

**O que procurar:**
- **22/tcp (SSH), 21/tcp (FTP), 445/tcp (SMB), 3389/tcp (RDP)** → brute force possível (Fase 3)
- **3306/tcp (MySQL), 5432 (PostgreSQL)** → acesso a banco (não brute force cego!)
- **80/443 (HTTP)** → painéis de login web (Fase 3, HTTP form)

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | Formato do Nmap diferente | Abra `nmap-services.txt` e ajuste o `awk` ao formato real |
| Muita poluição (script output) | `-sC` misturou linhas | Filtre: `grep "/tcp" 02-enum/nmap-services.txt` |

---

### Passo 1.3 — Extrair CVEs e vulnerabilidades (do Módulo 01)

**O que você vai fazer:** Tirar do `nmap-vuln.txt` e do `resumo-severidade.md` as vulnerabilidades que podem virar EXPLORAÇÃO (Fase 5).

```bash
# CVEs detectadas pelo Nmap NSE
grep -iE "CVE-|VULNERABLE" 05-vulns/nmap-vuln.txt | sort -u > 15-alimentacao/alvos-cve.txt

# Resumo de severidade do recon (já validado na Fase 6 do Módulo 01)
cp 06-validacao/resumo-severidade.md 15-alimentacao/severidade-recon.md

# Ver
cat 15-alimentacao/alvos-cve.txt
```

**✅ Output esperado (exemplo real):**
```
VULNERABLE: Microsoft Windows SMBv1 Remote Code Execution (MS17-010)
  State: VULNERABLE
  IDs:  CVE:CVE-2017-0144
CVE-2017-0144
VULNERABLE: OpenSSH 7.2p2 User Enumeration (CVE-2018-15473)
```

**O que procurar:**
- **CVE com "VULNERABLE" confirmado** → candidato direto ao Metasploit (Fase 5)
- **MS17-010 / EternalBlue** → exploit clássico e confiável
- **Versões antigas sem CVE** → anote para busca manual no Searchsploit (Fase 2)

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | Nmap `--script vuln` não rodou | `nmap --script vuln -p <ports> -oN 05-vulns/nmap-vuln.txt <ip>` |
| Muitos falsos positivos | NSE é genérico | Trate como "suspeito" — confirme na Fase 2 com searchsploit |

---

### Passo 1.4 — Importar superfície de login web (do Módulo 02)

**O que você vai fazer:** Pegar as URLs de login, formulários e endpoints que você descobriu no Módulo 02 (MANUAL-WEB — Burp, Gobuster, ffuf) e virar a lista de alvos HTTP do Hydra. Os arquivos já foram gerados lá: aqui é só importar.

```bash
# 0) IMPORTAR os arquivos prontos do MANUAL-WEB (Passo 2.9 do Módulo 02)
#    - 09-descoberta/logins-formularios.txt ← campos e mensagem de erro de cada form
#    - 09-descoberta/logins-web.txt         ← caminhos de login/painel
cp 09-descoberta/logins-formularios.txt 15-alimentacao/formularios.txt 2>/dev/null
cp 09-descoberta/logins-web.txt 15-alimentacao/alvos-login-web.txt 2>/dev/null

# 1) Complementar com URLs de login/painéis do discovery (Módulo 01)
grep -iE "login|signin|admin|wp-login|auth|panel|dashboard" 04-discovery/gobuster-basico.txt \
  | awk '{print $2}' | sort -u >> 15-alimentacao/alvos-login-web.txt
sort -u 15-alimentacao/alvos-login-web.txt -o 15-alimentacao/alvos-login-web.txt

# 2) Só se você NÃO fez o Módulo 02: criar formularios.txt manualmente
#    (formato: URL;campo_usuario;campo_senha;mensagem_de_erro)
# Se o arquivo já veio do Passo 0 acima, NÃO sobrescreva!
[ -s 15-alimentacao/formularios.txt ] || cat > 15-alimentacao/formularios.txt << 'EOF'
http://evilcorp.com/login;username;password;Invalid credentials
http://evilcorp.com/wp-login.php;log;pwd;ERROR: The password you entered
http://evilcorp.com/admin/;user;pass;Login failed
EOF

# Ver o que temos
cat 15-alimentacao/alvos-login-web.txt
cat 15-alimentacao/formularios.txt
```

**✅ Output esperado (alvos-login-web.txt):**
```
/admin/
/admin/login
/login
/wp-admin/
/wp-login.php
```

**✅ Output esperado (formularios.txt):**
```
http://evilcorp.com/login;username;password;Invalid credentials
http://evilcorp.com/wp-login.php;log;pwd;ERROR: The password you entered
```

**O que procurar:**
- **`/wp-login.php`** → WordPress: campo `log` e `pwd` (formato do Hydra muda!)
- **`/admin/`** → painel interno: maior impacto se entrar
- **Mensagem de erro exata** (`Invalid credentials`) → Hydra precisa dela para detectar falha (parâmetro `F=`)

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | Gobuster não achou login | Procure manualmente no navegador: `<alvo>/login`, `/admin`, `/wp-admin` |
| Não sabe os campos do form | Não inspecionou no Módulo 02 | Abra o login no navegador → F12 → Network → envie login errado → veja os campos POST |
| Não tem mensagem de erro | Precisa descobrir | No navegador, logue com senha errada e copie o texto exato da falha |

> 💡 **Sem `formularios.txt`, a Fase 3 não consegue testar logins HTTP.** É o elo direto com o Módulo 02 — não pule.

---

### Passo 1.5 — Gerar usernames candidatos (OSINT do Módulo 01)

**O que você vai fazer:** Transformar os emails e usuários encontrados no recon em uma wordlist de USUÁRIOS — a melhor lista possível porque veio do próprio alvo.

```bash
# Emails do theHarvester (Módulo 01) → usuários
grep -oE "^[a-zA-Z0-9._-]+@" 01-intel/theharvester.txt 2>/dev/null | \
  sed 's/@.*//' | sort -u > 15-alimentacao/usernames-candidatos.txt

# Se não tem theHarvester.txt, tente de outras fontes do recon:
grep -rhoiE "(admin|root|test|user|suporte|dev)[a-z0-9._-]*" 01-intel/ 02-enum/ 2>/dev/null | \
  sort -u >> 15-alimentacao/usernames-candidatos.txt

# Juntar com a lista padrão do SecLists
cat /usr/share/seclists/Usernames/top-usernames-shortlist.txt \
    15-alimentacao/usernames-candidatos.txt | sort -u > 15-alimentacao/usernames-todos.txt

# Ver quantos temos
wc -l 15-alimentacao/usernames-todos.txt
cat 15-alimentacao/usernames-candidatos.txt
```

**✅ Output esperado (usernames-candidatos.txt):**
```
admin
info
jose.silva
maria.santos
suporte
```

**O que procurar:** `admin` (sempre), nomes de pessoas (do WHOIS/OSINT), `suporte`, `dev`, `test`.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | Sem emails no recon | Use só a lista padrão: `cp /usr/share/seclists/Usernames/top-usernames-shortlist.txt 15-alimentacao/usernames-todos.txt` |
| Lista grande demais (>100) | grep pegou lixo | Edite e mantenha os 10-30 mais prováveis |

---

### Passo 1.6 — Consolidar hashes e segredos (Módulos 01 e 02)

**O que você vai fazer:** Reunir tudo que parece SENHA ou HASH para a Fase 4 (cracking) — segredos de JS/.env do Módulo 02 (MANUAL-WEB Passo 1.7), hashes extraídos por SQLi no Módulo 02 (MANUAL-WEB Fase 3), hashes do recon.

```bash
# 1) Segredos encontrados no JS (Módulo 01 / 02) — arquivo gerado pelo MANUAL-WEB Passo 1.7
cp 08-alimentacao/secrets-web.txt 15-alimentacao/segredos-js.txt 2>/dev/null
cp 04-discovery/js-secrets.txt 15-alimentacao/segredos-js.txt 2>/dev/null   # fallback Módulo 01

# 2) Hashes/senhas extraídos por SQLi no Módulo 02 (MANUAL-WEB Fase 3 — sqlmap --dump)
#    tabelas de usuário em dump costumam ter hash por linha (MD5/SHA/bcrypt)
if [ -s 10-injecao/sqlmap-dump.txt ]; then
  grep -rhoE "[a-f0-9]{32}|[a-f0-9]{40}|[a-f0-9]{64}" 10-injecao/sqlmap-dump.txt | \
    sort -u >> 15-alimentacao/hashes-suspeitos.txt
fi

# 3) Procurar padrões de hash (MD5/SHA) em QUALQUER arquivo do recon
grep -rhoE "[a-f0-9]{32}|[a-f0-9]{40}|[a-f0-9]{64}" 01-intel/ 04-discovery/ 2>/dev/null | \
  sort -u >> 15-alimentacao/hashes-suspeitos.txt
sort -u 15-alimentacao/hashes-suspeitos.txt -o 15-alimentacao/hashes-suspeitos.txt 2>/dev/null

# 4) Procurar senhas/credenciais em configs expostas (Módulo 01 + segredos do Módulo 02)
grep -rhoiE "(password|passwd|pwd|secret|token|api_key)[\"' ]*[:=][\"' ]*[^\s\"']+" \
  04-discovery/ 08-alimentacao/ 2>/dev/null | sort -u > 15-alimentacao/credenciais-texto.txt

# Ver
echo "=== Hashes ==="; head -5 15-alimentacao/hashes-suspeitos.txt
echo "=== Credenciais ==="; cat 15-alimentacao/credenciais-texto.txt
```

**✅ Output esperado (credenciais-texto.txt):**
```
password=EvilCorp2024!
DB_PASS="s3nh4_segura"
api_key: "sk_live_abc123"
```

**O que procurar:**
- **Senha em texto puro** → pode ser usada DIRETO no Hydra (Fase 3) como `-p senha`
- **MD5/SHA de 32/40/64 hex** → vai para cracking (Fase 4)
- **api_key/token** → impacto direto (documente como achado, sem explorar além do escopo)

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Tudo vazio | Recon não achou nada exposto | Normal — siga; brute force e exploração continuam possíveis |
| Hashes são falsos positivos | hex aleatório em JS | Valide na Fase 4 com `hashid` antes de gastar tempo |

---

### Passo 1.7 — Gerar wordlist do alvo (CeWL)

**O que você vai fazer:** Criar uma wordlist com palavras do próprio site do alvo — senhas como `evilcorp2024` são muito mais prováveis que `password123`.

```bash
# Extrair palavras do site (profundidade 2, mínimo 5 caracteres)
cewl http://evilcorp.com -d 2 -m 5 -w 15-alimentacao/cewl-alvo.txt 2>/dev/null

# Ver quantas palavras gerou
wc -l 15-alimentacao/cewl-alvo.txt

# Juntar com Top1000 para a wordlist final do brute force
cat /usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt \
    15-alimentacao/cewl-alvo.txt | sort -u > 15-alimentacao/wordlist-bruteforce.txt
wc -l 15-alimentacao/wordlist-bruteforce.txt
```

**✅ Output esperado:**
```
147 15-alimentacao/cewl-alvo.txt
1147 15-alimentacao/wordlist-bruteforce.txt
```

**O que procurar:** Palavras da empresa: `evilcorp`, `portal`, `financeiro`, `logistica` — combine com anos/símbolos na Fase 4.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| 0 palavras | Site bloqueou ou exige JS | Use `-e "Mozilla/5.0..."` ou pule (não é obrigatório) |
| `cewl: command not found` | Não instalado | `sudo apt install cewl` |

---

### Checklist da Fase 1

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Dados do Módulo 01 (MANUAL-RECON) verificados | `nmap-services.txt`, `nmap-vuln.txt`, `resumo-severidade.md` | [ ] |
| 2 | Arquivos do Módulo 02 (MANUAL-WEB) localizados | `09-descoberta/logins-*.txt`, `08-alimentacao/secrets-web.txt` | [ ] |
| 3 | Serviços extraídos | `15-alimentacao/alvos-servicos.txt` | [ ] |
| 4 | CVEs extraídas | `15-alimentacao/alvos-cve.txt` | [ ] |
| 5 | Logins web importados (Módulo 02) | `15-alimentacao/alvos-login-web.txt` | [ ] |
| 6 | Formulários HTTP importados (Módulo 02) | `15-alimentacao/formularios.txt` | [ ] |
| 7 | Usernames candidatos | `15-alimentacao/usernames-todos.txt` | [ ] |
| 8 | Hashes/segredos consolidados (Módulos 01 + 02) | `15-alimentacao/hashes-suspeitos.txt` | [ ] |
| 9 | Wordlist do alvo gerada | `15-alimentacao/wordlist-bruteforce.txt` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 1:

```
15-alimentacao/
├── alvos-servicos.txt        ← IP:porta:serviço (← 02-enum/nmap-services.txt, MANUAL-RECON)
├── alvos-cve.txt             ← CVEs confirmadas (← 05-vulns/nmap-vuln.txt, MANUAL-RECON)
├── severidade-recon.md       ← cópia do resumo de severidade (← 06-validacao/, MANUAL-RECON)
├── alvos-login-web.txt       ← URLs de login (← 09-descoberta/logins-web.txt, MANUAL-WEB)
├── formularios.txt           ← campos de cada form HTTP (← 09-descoberta/logins-formularios.txt, MANUAL-WEB)
├── usernames-candidatos.txt  ← usuários do OSINT (← 01-intel/theharvester.txt, MANUAL-RECON)
├── usernames-todos.txt       ← candidatos + lista padrão SecLists
├── segredos-js.txt           ← segredos de JS (← 08-alimentacao/secrets-web.txt, MANUAL-WEB)
├── hashes-suspeitos.txt      ← hashes p/ Fase 4 (← 04-discovery/js-secrets.txt + 10-injecao/sqlmap-dump.txt)
├── credenciais-texto.txt     ← senhas em texto puro (usar direto no Hydra)
├── cewl-alvo.txt             ← palavras do site do alvo
└── wordlist-bruteforce.txt   ← wordlist final (Top1000 + CeWL)
```

### ✅ Sinal de sucesso:
- `alvos-servicos.txt` tem pelo menos **1 serviço com login** (SSH, FTP, HTTP)
- `alvos-login-web.txt` tem pelo menos **1 URL de login** OU `formularios.txt` tem pelo menos **1 form**
- `usernames-todos.txt` tem entre **10 e 50 usuários**
- Você sabe exatamente **quais CVEs** existem (ou sabe que não há)

### ❌ Se falhou:
- Sem `alvos-servicos.txt` → o Nmap do Módulo 01 não foi feito. Volte ao Módulo 01, Fase 2.
- Sem `formularios.txt` → você não documentou os logins no Módulo 02. Abra os logins no navegador, inspecione os campos (F12 → Network) e preencha manualmente.
- Sem CVEs → comum. Siga: brute force (Fases 3-4) independe de CVE.

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 1 | Usado na Fase | Para quê | Origem original |
|--------------------|---------------|----------|-----------------|
| `alvos-servicos.txt` | Fase 2 | Escolher quais serviços viram vetor | MANUAL-RECON `02-enum/nmap-services.txt` |
| `alvos-cve.txt` | Fase 2 e 5 | Cruzar CVE com exploit pronto | MANUAL-RECON `05-vulns/nmap-vuln.txt` |
| `alvos-login-web.txt` + `formularios.txt` | Fase 3 | Hydra http-post-form | MANUAL-WEB `09-descoberta/logins-*.txt` |
| `usernames-todos.txt` | Fase 3 | `-L` do Hydra | MANUAL-RECON `01-intel/theharvester.txt` |
| `wordlist-bruteforce.txt` | Fase 3 e 4 | `-P` do Hydra / wordlist do John | CeWL + SecLists |
| `hashes-suspeitos.txt` | Fase 4 | Input do hashid/John/Hashcat | MANUAL-RECON `04-discovery/js-secrets.txt` + MANUAL-WEB `10-injecao/sqlmap-dump.txt` |
| `credenciais-texto.txt` | Fase 3 e 5 | Senhas para testar direto | MANUAL-RECON `04-discovery/` + MANUAL-WEB `08-alimentacao/secrets-web.txt` |
| `severidade-recon.md` | Fase 5 | Priorizar o que explorar | MANUAL-RECON `06-validacao/resumo-severidade.md` |

**Se completou tudo → Avance para [Fase 2 — Priorização de Vetores](08-fase2-vetores.md)**
