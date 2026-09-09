# 🚀 Go Tools

> Ferramentas de segurança instaladas via `go install`. ProjetcDiscovery é o principal framework.

---

## 🚀 Passo a Passo — Pipeline de Recon com Go Tools

Essas ferramentas são as mais modernas para reconhecimento automatizado. Vamos montar um pipeline completo.

### Passo 1: Instalar Go (pré-requisito)
```bash
# Primeiro, instale o Go (linguagem que roda essas ferramentas)
sudo apt install -y golang-go

# Verifique se instalou
go version

# Adicione o PATH para poder rodar os comandos
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.zshrc
source ~/.zshrc
```

### Passo 2: Instalar as ferramentas
```bash
# Subfinder (descobrir subdomínios)
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Nuclei (scan de vulnerabilidades)
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# httpx (verificar URLs ativas)
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
```

### Passo 3: Atualizar templates do Nuclei
```bash
# IMPORTANTE: atualize os templates antes de usar
nuclei -update-templates
```

### Passo 4: Rodar o pipeline completo
```bash
# Tudo em uma linha — descobre subdomínios, verifica quais estão ativos, e scan de vulns
subfinder -d target.com -silent | httpx -mc 200 -silent | nuclei -severity critical,high
```

### Passo 5: Separar cada etapa (para entender melhor)
```bash
# Etapa 1: Descobrir subdomínios
subfinder -d target.com -all -silent > subdomains.txt
cat subdomains.txt   # veja quantos encontrou

# Etapa 2: Verificar quais estão ativos (respondem HTTP)
cat subdomains.txt | httpx -mc 200 -silent > live.txt
cat live.txt   # veja quais estão de pé

# Etapa 3: Scan de vulnerabilidades nos ativos
cat live.txt | nuclei -severity critical,high
```

### Resumo da ordem:
```
1. sudo apt install golang-go     → instalar Go
2. go install subfinder/nuclei/httpx → instalar ferramentas
3. nuclei -update-templates       → atualizar templates
4. subfinder | httpx | nuclei     → rodar pipeline
```

---

## Pré-requisito: Instalar Go

```bash
# Instalar Go
sudo apt install -y golang-go

# Verificar instalação
go version

# Garantir que ~/go/bin está no PATH
# Adicionar ao ~/.zshrc:
export PATH=$PATH:$(go env GOPATH)/bin

# Recarregar
source ~/.zshrc
```

---

## Subfinder

Enumeração passiva de subdomínios. Coleta de múltiplas fontes (DNS, certificate transparency, etc).

### Instalação
```bash
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-d` | Domínio alvo |
| `-o` | Output para arquivo |
| `-oJ` | Output JSON |
| `-silent` | Só mostrar subdomínios encontrados |
| `-all` | Usar todas as fontes |
| `-timeout` | Timeout por fonte |
| `-providers-config` | Config de API keys |

### Exemplos práticos

```bash
# Enumeração básica
subfinder -d target.com

# Com output para arquivo
subfinder -d target.com -o subdomains.txt

# Mais completo (todas as fontes)
subfinder -d target.com -all

# Output JSON
subfinder -d target.com -oJ subdomains.json

# Silencioso (só subdomínios)
subfinder -d target.com -silent

# Múltiplos domínios
subfinder -dL domains.txt -o subdomains.txt

# Com timeout
subfinder -d target.com -timeout 30
```

### Usando com outras ferramentas

```bash
# Subfinder + httpx (verificar quais estão ativos)
subfinder -d target.com -silent | httpx -mc 200 -o live.txt

# Subfinder + Nuclei (scan de vulnerabilidades)
subfinder -d target.com -silent | nuclei -t cves/

# Subfinder + Gobuster (brute force DNS)
subfinder -d target.com -silent > subfinder_subs.txt
gobuster dns -d target.com -w wordlist.txt -o gobuster_subs.txt
cat subfinder_subs.txt gobuster_subs.txt | sort -u > all_subs.txt
```

### Configuração de API Keys (opcional)
```bash
# Criar arquivo ~/.config/subfinder/provider-config.yaml
# Adicionar chaves de APIs para mais resultados:
# virustotal:
#   - YOUR_API_KEY
# shodan:
#   - YOUR_API_KEY
# censys:
#   - YOUR_API_ID:YOUR_API_SECRET
```

---

## Nuclei

Scanner de vulnerabilidades baseado em templates. Detecta CVEs, misconfigurations, exposição de dados, etc.

### Instalação
```bash
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-u` | URL alvo |
| `-l` | Lista de URLs |
| `-t` | Template(s) específico(s) |
| `-tags` | Filtrar por tags |
| `-severity` | Filtrar por severidade |
| `-o` | Output |
| `-json` | Output JSON |
| `-silent` | Só mostrar findings |
| `-rate-limit` | Requests por segundo |
| `-c` | Concorrentes |
| `-timeout` | Timeout |
| `-update-templates` | Atualizar templates |
| `-list` | Listar templates |

### Exemplos práticos

```bash
# Scan básico de uma URL
nuclei -u http://target.com

# Scan de lista de URLs
nuclei -l urls.txt

# Filtrar por severidade
nuclei -u http://target.com -severity critical,high

# Filtrar por tags
nuclei -u http://target.com -tags cve,sqli,xss

# Templates específicos
nuclei -u http://target.com -t http/cves/
nuclei -u http://target.com -t http/vulnerabilities/

# Atualizar templates (importante!)
nuclei -update-templates

# Listar templates disponíveis
nuclei -list-templates

# Output JSON
nuclei -u http://target.com -json -o results.json

# Com rate limit (evitar bloqueio)
nuclei -u http://target.com -rate-limit 50

# Scan completo com todas as templates
nuclei -u http://target.com -t http/ -severity critical,high,medium

# Scan de subdomínios
subfinder -d target.com -silent | nuclei -severity critical,high
```

### Categorias de templates

| Pasta | Descrição |
|:---|:---|
| `http/cves/` | CVEs conhecidos |
| `http/vulnerabilities/` | Vulnerabilidades gerais |
| `http/exposures/` | Dados expostos |
| `http/misconfiguration/` | Configurações erradas |
| `http/technologies/` | Detecção de tecnologias |
| `dns/` | Testes DNS |
| `network/` | Testes de rede |
| `headless/` | Navegador headless (XSS, etc) |

### Dicas
```bash
# Sempre atualizar templates antes de usar
nuclei -update-templates

# Usar com Proxychains para anonimato
proxychains4 nuclei -u http://target.com

# Scan mais lento para não sobrecarregar
nuclei -u http://target.com -rate-limit 10 -timeout 10

# Usar severity para focar no importante
nuclei -u http://target.com -severity critical,high
```

---

## httpx

HTTP probing rápido. Verifica quais URLs estão ativas e coleta informações.

### Instalação
```bash
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
```

### Flags principais

| Flag | O que faz |
|:---|:---|
| `-l` | Lista de URLs/domínios |
| `-mc` | Match status code |
| `-fc` | Filter status code |
| `-o` | Output |
| `-json` | Output JSON |
| `-title` | Extrair título da página |
| `-tech-detect` | Detectar tecnologias |
| `-follow-redirects` | Seguir redirects |
| `-status-code` | Mostrar status code |
| `-content-length` | Mostrar tamanho |
| `-title` | Mostrar título |
| `-web-server` | Mostrar web server |
| `-threads` | Threads |
| `-silent` | Só output relevante |

### Exemplos práticos

```bash
# Verificar quais URLs estão ativas
cat urls.txt | httpx

# Com filtro de status code
cat urls.txt | httpx -mc 200,301,302

# Com informações detalhadas
cat urls.txt | httpx -title -status-code -tech-detect -follow-redirects

# Output JSON
cat urls.txt | httpx -json -o httpx_results.json

# Usando com subfinder
subfinder -d target.com -silent | httpx -mc 200 -o live.txt

# Scan rápido
cat urls.txt | httpx -threads 100 -silent

# Com detecção de tecnologias
cat urls.txt | httpx -tech-detect -status-code

# Filtrar por tamanho
cat urls.txt | httpx -fc 404 -fs 0
```

### Pipeline completo

```bash
# 1. Descobrir subdomínios
subfinder -d target.com -silent > subs.txt

# 2. Verificar quais estão ativos
cat subs.txt | httpx -mc 200 -silent > live.txt

# 3. Scan de vulnerabilidades nos ativos
cat live.txt | nuclei -severity critical,high

# OU tudo em uma linha:
subfinder -d target.com -silent | httpx -mc 200 -silent | nuclei -severity critical,high
```

---

## Pipeline completo de reconhecimento

```bash
# === FASE 1: Descoberta ===
subfinder -d target.com -all -silent > subdomains.txt

# === FASE 2: Probing ===
cat subdomains.txt | httpx -mc 200,301,302 -title -tech-detect -silent > live.txt

# === FASE 3: Scan ===
cat live.txt | nuclei -severity critical,high,medium -o nuclei_results.txt

# === FASE 4: Web Content Discovery ===
cat live.txt | while read url; do
  ffuf -u "$url/FUZZ" -w /usr/share/seclists/Discovery/Web-Content/common.txt -fs 0 -silent
done

# === Tudo junto (simplificado) ===
subfinder -d target.com -silent | httpx -mc 200 -silent | nuclei -severity critical,high
```
