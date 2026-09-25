# 📦 01. Preparação e Wordlists

> A wordlist certa na ferramenta certa = minutos de trabalho. A wordlist errada = horas de falso positivo ou zero resultados.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 40min | ⭐⭐ Básico/Intermediário | `seclists, crunch, cewl` |

</div>

---

## 🎓 Por que isso importa?

Antes de qualquer ataque de brute force, spraying ou enumeração, você precisa de **listas de palavras relevantes para o alvo**. Usar a wordlist errada é o erro mais comum de iniciantes: a pessoa roda `rockyou.txt` (14 milhões de senhas) contra SSH e espera dias de processamento — quando uma lista de 1.000 senhas comuns resolveria em 30 segundos.

**Impacto real:**
- Uma wordlist de 10 senhas sazonais (`Summer2025!`, `Company2024!`) pode quebrar 30 contas em ambientes AD
- Uma wordlist customizada do site do alvo (`CeWL`) descobre senhas contextuais que listas genéricas nunca encontram
- SecLists tem 1.83 GB de listas organizadas por cenário — conhecer a estrutura é saber qual usar

**Regra de ouro:** Comece sempre pela lista MENOR. Escale apenas se a menor não funcionar.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Terminal Linux (cd, ls, cat, pipe) | Sim | Módulo 00 |
| O que é brute force | Sim | Módulo 00 |
| Instalação de pacotes (apt) | Sim | Módulo 00 |

---

## 🎯 Quando usar este módulo

- Antes de brute force (Hydra, Medusa) — precisa de senhas/usuários para testar
- Antes de enumeração (Gobuster, ffuf) — precisa de wordlists de conteúdo
- Quando wordlists genéricas não funcionam — precisa de listas customizadas
- Quando o alvo tem contexto próprio (empresa, produtos) — CeWL extrai palavras do site

---

## 🔄 Como funciona na prática

```
┌──────────────────────────────────────────────────────────┐
│  1. IDENTIFICAR O CENÁRIO                                │
│     - Brute force SSH/FTP → Passwords/                   │
│     - Directory discovery → Discovery/Web-Content/        │
│     - DNS subdomains → Discovery/DNS/                    │
│     - User enumeration → Usernames/                      │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  2. ESCOLHER A WORDLIST MENOR                            │
│     - common.txt (web), Top1000.txt (senhas)             │
│     - sempre começar pela lista pequena                   │
└──────────────────────┬───────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────┐
│  3. ESCALAR SE NECESSÁRIO                                │
│     - Se a menor não achou → lista maior                 │
│     - Se nenhuma funciona → wordlist customizada         │
│     - Crunch para padrões, CeWL para sites              │
└──────────────────────────────────────────────────────────┘
```

---

## 🛠️ Ferramentas

| Ferramenta | O que faz | Quando usar |
|:-----------|:----------|:------------|
| **SecLists** | Coleção completa de wordlists (1.83 GB) | SEMPRE — primeira opção |
| **Crunch** | Gera wordlists por padrão/caractere | Quando precisa de senhas numéricas, padrões específicos |
| **CeWL** | Gera wordlists a partir de sites | Quando o alvo tem contexto próprio (empresa, blog) |

---

## 📁 SecLists — A Base de Tudo

### Instalação

```bash
# Pré-instalado no Kali. Se ausente:
sudo apt install -y seclists
```

### Estrutura do diretório

```
/usr/share/seclists/
├── Discovery/
│   ├── Web-Content/        # Diretórios e arquivos web
│   ├── DNS/                # Subdomínios
│   └── Infrastructure/     # IPs, portas
├── Passwords/              # Senhas
│   ├── Common-Credentials/ # Credenciais comuns
│   ├── Default-Credentials/ # Credenciais padrão
│   └── Leaked-Databases/   # Dados vazados
├── Usernames/              # Usuários
│   └── Names/              # Nomes
├── Fuzzing/                # Payloads para fuzzing
└── Web-Shells/             # Webshells
```

> **Nota:** O symlink `/usr/share/wordlists/seclists` também aponta para o mesmo diretório. Ambos os caminhos funcionam.

### Wordlists por cenário de uso

#### Discovery/Web-Content (diretórios web)

| Wordlist | Caminho | Tamanho | Quando usar |
|:---------|:--------|:--------|:------------|
| `common.txt` | `Discovery/Web-Content/common.txt` | ~4.600 | **SEMPRE começar aqui** |
| `big.txt` | `Discovery/Web-Content/big.txt` | ~20.000 | Se common.txt achou pouco |
| `directory-list-2.3-medium.txt` | `Discovery/Web-Content/directory-list-2.3-medium.txt` | ~220.000 | Scan completo |
| `raft-large-directories.txt` | `Discovery/Web-Content/raft-large-directories.txt` | ~62.000 | Alternativa ao medium |
| `burp-parameter-names.txt` | `Discovery/Web-Content/burp-parameter-names.txt` | ~2.600 | Parâmetros HTTP |

```bash
# Uso com Gobuster
gobuster dir -u http://target.com -w /usr/share/seclists/Discovery/Web-Content/common.txt

# Uso com ffuf
ffuf -u http://target.com/FUZZ -w /usr/share/seclists/Discovery/Web-Content/common.txt
```

#### Discovery/DNS (subdomínios)

| Wordlist | Tamanho | Quando usar |
|:---------|:--------|:------------|
| `subdomains-top1million-5000.txt` | ~5.000 | Scan DNS rápido |
| `subdomains-top1million-20000.txt` | ~20.000 | Scan DNS profundo |
| `subdomains-top1million-110000.txt` | ~110.000 | Último recurso |

```bash
gobuster dns -d target.com -w /usr/share/seclists/Discovery/DNS/subdomains-top1million-5000.txt -t 50
```

#### Passwords (senhas)

| Wordlist | Tamanho | Quando usar |
|:---------|:--------|:------------|
| `Common-Credentials/top-20.txt` | 20 | Teste rápido |
| `Passwords/Top1000.txt` | ~1.000 | Brute force rápido |
| `Passwords/Top10000.txt` | ~10.000 | Brute force padrão |
| `rockyou.txt` | ~14.000.000 | Último recurso (lento) |

```bash
# Hydra com Top1000
hydra -l admin -P /usr/share/seclists/Passwords/Top1000.txt ssh://target.com

# John com Top10000
john --wordlist=/usr/share/seclists/Passwords/Top10000.txt hash.txt
```

#### Usernames (usuários)

| Wordlist | Tamanho | Quando usar |
|:---------|:--------|:------------|
| `top-usernames-shortlist.txt` | ~30 | Teste rápido |
| `names.txt` | ~60.000 | Enumeração ampla |

```bash
hydra -L /usr/share/seclists/Usernames/top-usernames-shortlist.txt -P passwords.txt ssh://target.com
```

#### Default-Credentials (credenciais padrão)

```bash
# Listar credenciais padrão conhecidas
ls /usr/share/seclists/Passwords/Default-Credentials/
```

---

## 🔨 Crunch — Gerador de Wordlists por Padrão

### Instalação

```bash
# Pré-instalado no Kali
sudo apt install -y crunch
```

### Flags Principais

| Flag | Descrição |
|:-----|:----------|
| `<min> <max>` | Tamanho mínimo e máximo da senha (obrigatório) |
| `<charset>` | Conjunto de caracteres (padrão: a-z) |
| `-t <padrão>` | Padrão com placeholders: `@` minúsculas, `,` maiúsculas, `%` números, `^` símbolos |
| `-l <tamanho>` | Com `-t`, define quais símbolos são literais |
| `-f <arquivo> <nome>` | Usa charset pré-definido de `/usr/share/crunch/charset.lst` |
| `-o <arquivo>` | Salva saída em arquivo |
| `-p <charset>` | Gera permutações sem repetição |
| `-s <string>` | Começa a partir de uma string específica |
| `-e <string>` | Para ao atingir uma string |
| `-b <tamanho>` | Tamanho máximo por arquivo (ex: `10mib`) — requer `-o START` |
| `-c <número>` | Linhas por arquivo — requer `-o START` |
| `-d <n>@,%^` | Limita caracteres duplicados consecutivos |
| `-z <tipo>` | Comprime: `gzip`, `bzip2`, `lzma`, `7z` |

### Placeholders do `-t`

| Símbolo | Significado |
|:--------|:------------|
| `@` | Minúsculas (a-z) |
| `,` | Maiúsculas (A-Z) |
| `%` | Números (0-9) |
| `^` | Símbolos (!@#$%^&*) |

### Exemplos práticos

#### Exemplo 1 — Wordlist numérica de 6 caracteres

```bash
crunch 6 6 0123456789 -o 6chars.txt
```

**✅ Output esperado:**
```
Crunch will now generate the following amount of data: 117440512 bytes
112 MB
0 GB
0 TB
0 PB
Crunch will now generate the following number of lines: 16777216
```

```bash
# Verificar
wc -l 6chars.txt
head -5 6chars.txt
```

```
000000
000001
000002
000003
000004
```

#### Exemplo 2 — Senhas com padrão (ano + 4 caracteres)

```bash
crunch 8 8 -t @@@@2025 -o password2025.txt
```

Gera senhas de 8 caracteres onde os 4 primeiros variam (a-z) e os 4 últimos são `2025`.

```bash
head -5 password2025.txt
```

```
aaaa2025
aaab2025
aaac2025
aaad2025
aaae2025
```

#### Exemplo 3 — Permutações sem repetição

```bash
crunch 3 3 -p abc
```

**✅ Output esperado:**
```
abc
acb
bac
bca
cab
cba
```

> **Nota:** Com `-p`, os parâmetros min/max são ignorados. O Crunch gera todas as permutações possíveis.

#### Exemplo 4 — Senhas com maiúscula + minúscula + número

```bash
crunch 6 6 -t ,@@%%% -o custom.txt
```

Gera: 1 maiúscula + 2 minúsculas + 3 números (ex: `Aab001`, `Aab002`, ...)

#### Exemplo 5 — Dividir em arquivos grandes

```bash
crunch 8 8 0123456789 -b 10mib -o START
```

Gera arquivos `part-000` ~ `part-XXX` de até 10MB cada.

### Charsets pré-definidos

```bash
# Listar charsets disponíveis
cat /usr/share/crunch/charset.lst
```

Exemplos:
- `numeric` → 0-9
- `alpha` → a-z
- `alpha-numeric` → a-z + 0-9
- `mixalpha-numeric` → a-z + A-Z + 0-9

### Erros comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| `maximum file size exceeded` | Wordlist gigante sem `-b` | Use `-b 100mib -o START` |
| `-s and -p cannot be used together` | Flags mutuamente exclusivas | Escolha apenas uma |
| Consome toda RAM | Charset × max_length = combos gigantescos | Reduza `max` ou use `-b` |
| `file already exists` | Arquivo `-o` já existe | Delete ou renomeie antes |

---

## 🌐 CeWL — Wordlist a Partir de Sites

### Instalação

```bash
# Pré-instalado no Kali
sudo apt install -y cewl
```

### Flags Principais

| Flag | Descrição |
|:-----|:----------|
| `-w <arquivo>` | Salva wordlist em arquivo |
| `-d <profundidade>` | Profundidade de spider (padrão: 2) |
| `-m <tamanho>` | Tamanho mínimo da palavra (padrão: 3) |
| `--with-numbers` | Inclui palavras com números |
| `-e, --email` | Inclui endereços de email |
| `--email-file <arquivo>` | Salva emails em arquivo separado |
| `-a, --meta` | Inclui metadados (PDF, DOCX) |
| `--meta-file <arquivo>` | Salva metadados em arquivo separado |
| `-c, --count` | Mostra contagem de cada palavra |
| `-n, --no-words` | Não exibe wordlist no stdout |
| `-u, --ua <agente>` | User-Agent customizado |
| `--lowercase` | Converte tudo para minúsculas |
| `--exclude <arquivo>` | Lista de caminhos a excluir |
| `-H, --header <nome:valor>` | Header HTTP customizado |

### Exemplos práticos

#### Exemplo 1 — Wordlist básica de um site

```bash
cewl http://target.com -w wordlist.txt -d 2 -m 5
```

**✅ Output esperado:**
```
CeWL 6.2.1 (More Fixes) Robin Wood (robin@digi.ninja) (https://digi.ninja/)
```

```bash
wc -l wordlist.txt
# 47 wordlist.txt

head -10 wordlist.txt
```

```
target
security
enterprise
solutions
login
portal
users
admin
dashboard
api
```

#### Exemplo 2 — Extrair emails e metadados

```bash
cewl http://target.com -d 3 -m 5 -e -a --email-file emails.txt --meta_file meta.txt -w wordlist.txt
```

Gera 3 arquivos:
- `wordlist.txt` — palavras encontradas
- `emails.txt` — endereços de email
- `meta.txt` — metadados de documentos

#### Exemplo 3 — Com User-Agent customizado

```bash
cewl http://target.com -d 2 -m 4 -u "Mozilla/5.0 (Windows NT 10.0; Win64; x64)" -c -w output.txt
```

O flag `-c` mostra a contagem de ocorrências de cada palavra.

### Integração com brute force

```bash
# Gerar wordlist do site do alvo
cewl http://target.com -d 3 -m 4 -w cewl_wordlist.txt

# Usar com Hydra
hydra -l admin -P cewl_wordlist.txt ssh://target.com

# Combinar com Crunch para expandir
crunch 8 8 -t @@@@2025 -o crunch.txt
cat cewl_wordlist.txt crunch.txt | sort -u > final_wordlist.txt
```

### Erros comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| `Error: nokogiri gem not installed` | Gem Ruby faltando | `gem install nokogiri` |
| `Unable to connect` | Site inacessível ou SSL | Verifique conectividade; tente `http://` |
| Wordlist muito vazia | `-d` ou `-m` muito altos | Reduza `-d 1` e `-m 3` |
| `exiftool: command not found` | Exiftool não instalado (para `-a`) | `sudo apt install libimage-exiftool-perl` |

---

## 📋 Resumo: Qual Wordlist Usar

| Cenário | Wordlist | Ferramenta |
|:--------|:---------|:-----------|
| Brute force SSH/FTP/HTTP rápido | `Passwords/Top1000.txt` | Hydra |
| Brute force completo | `Passwords/Top10000.txt` | Hydra, John |
| Último recurso (lento) | `rockyou.txt` | Hashcat |
| Directory discovery rápido | `Discovery/Web-Content/common.txt` | Gobuster, ffuf |
| Directory discovery completo | `Discovery/Web-Content/directory-list-2.3-medium.txt` | Gobuster |
| Subdomínios | `Discovery/DNS/subdomains-top1million-5000.txt` | Gobuster DNS |
| Usuários | `Usernames/top-usernames-shortlist.txt` | Hydra -L |
| Credenciais padrão | `Passwords/Default-Credentials/` | Hydra -C |
| Senhas numéricas (6 dígitos) | Gerado com Crunch | Crunch |
| Senhas do site do alvo | Gerado com CeWL | CeWL |

---

## ❌ Erros Comuns

| Erro | Solução |
|:-----|:--------|
| "Qual wordlist usar?" | Consulte a tabela acima — identifique o cenário primeiro |
| "Rockyou.txt é muito lento" | Comece com Top1000.txt, escale apenas se necessário |
| "Crunch não gera nada" | Verifique se min ≤ max e charset não está vazio |
| "CeWL retorna lista vazia" | Reduza `-d` e `-m`; verifique se o site é acessível |
| "Não sei o tamanho da senha" | Comece com 6-8 caracteres, depois teste outros tamanhos |

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | O que praticar | Tempo |
|---|:----------:|:----|:---------------|:-----:|
| 1 | TryHackMe | [SecLists](https://tryhackme.com/room/seclists) | Navegação no SecLists, seleção para diferentes tarefas | 30min |
| 2 | TryHackMe | [Brute It](https://tryhackme.com/room/bruteit) | Brute force com wordlists apropriadas | 45min |
| 3 | OverTheWire | [Bandit Narnia](https://overthewire.org/wargames/narnia/) | Exploração básica (aplicar wordlists em contexto real) | 30min |

---

## 📚 Referências

- [SecLists no Kali](https://www.kali.org/tools/seclists)
- [Crunch — GitHub](https://github.com/crunchsec/crunch)
- [CeWL — GitHub](https://github.com/digininja/CeWL)
- [PayloadsAllTheThings — Wordlists](https://github.com/swisskyrepo/PayloadsAllTheThings)
- [HackTricks — Credential Wordlists](https://book.hacktricks.xyz/generic-methodologies-and-resources/tunneling-and-port-forwarding)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Navegar pela estrutura do SecLists e encontrar a wordlist correta para cada cenário
- [ ] Gerar wordlists numéricas e com padrão usando Crunch
- [ ] Gerar wordlists customizadas a partir de sites com CeWL
- [ ] Saber quando escalar de lista pequena para lista grande
- [ ] Combinar wordlists de diferentes fontes (`sort -u`)
- [ ] Instalar e verificar todas as ferramentas necessárias
