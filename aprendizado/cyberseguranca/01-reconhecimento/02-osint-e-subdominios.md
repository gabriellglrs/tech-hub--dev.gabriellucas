# 🚀 Go Tools

> Ferramentas de segurança instaladas via `go install`. ProjetcDiscovery é o principal framework.

---

## 📚 O que é OSINT e Enumeração de Subdomínios?

**OSINT** (Open Source Intelligence) é coletar informações de fontes públicas. **Subdomínios** são partes do domínio principal (api.empresa.com, mail.empresa.com) que podem revelar serviços escondidos.

### Por que isso é importante?

- Empresas escondem serviços em **subdomínios não documentados**
- Emails de funcionários servem para **phishing direcionado**
- Informações públicas podem revelar **stack tecnológico**
- É o passo que separa um ataque genérico de um **direcionado**

### O que você vai descobrir?

| Tipo | O que revela | Como usar |
|:---|:---|:---|
| Subdomínios | APIs, painéis, VPNs | Acesso alternativo |
| Emails | Funcionários reais | Phishing, brute force |
| IPs | Onde hospeda | Escaneamento direto |
| Tecnologias | Frameworks, CMS | Ataques específicos |

### Ferramentas

| Ferramenta | O que faz | Prioridade |
|:---|:---|:---|
| **Subfinder** | Descobre subdomínios via 40+ fontes DNS | Principal |
| **Amass** | Enumeração passiva e ativa | Complementar |
| **theHarvester** | Coleta emails e subdomínios | Complementar |
| **Shodan CLI** | Busca de dispositivos/serviços na internet | Complementar |

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

### Resumo da ordem — Por que essa sequência?

O pipeline Go Tools segue a lógica: **descobrir → validar → explorar**. Cada ferramenta alimenta a próxima.

```
PASSO 1: Instalar Go → Pré-requisito para todas as ferramentas
├── POR QUE: Subfinder, Nuclei e httpx são escritos em Go e precisam dele para rodar
├── O QUE PROCURAR: `go version` deve retornar uma versão instalada
├── QUANDO AVANÇAR: Quando `go version` funcionar e ~/go/bin estiver no PATH
└── SE DER ERRADO: Se "go: command not found", adicione: export PATH=$PATH:$(go env GOPATH)/bin

        ↓

PASSO 2: Instalar ferramentas (subfinder, nuclei, httpx)
├── POR QUE: Cada ferramenta tem uma função específica no pipeline
├── O QUE PROCURAR: Binários em ~/go/bin/ (subfinder, nuclei, httpx)
├── QUANDO AVANÇAR: Quando os três comandos rodarem sem erro
└── SE DER ERRADO: Se erro de compilação, verifique se o Go está atualizado: go get -u

        ↓

PASSO 3: Atualizar templates do Nuclei
├── POR QUE: Templates desatualizados = vulnerabilidades novas não detectadas
├── O QUE PROCURAR: Mensagem "Successfully updated" e contagem de templates
├── COMANDO: nuclei -update-templates
├── QUANDO AVANÇAR: Quando os templates estiverem atualizados
└── SE DER ERRADO: Se falhar, verifique conexão com a internet e permissões de ~/.nuclei/

        ↓

PASSO 4: Rodar o pipeline (subfinder | httpx | nuclei)
├── POR QUE: Subfinder descobre alvos, httpx valida quais estão ativos, nuclei scanea vulns
├── O QUE PROCURAR: Subdomínios listados, URLs com status 200, vulnerabilidades encontradas
├── COMANDO: subfinder -d target.com -silent | httpx -mc 200 -silent | nuclei -severity critical,high
├── QUANDO AVANÇAR: Quando tiver resultados de vulnerabilidades
└── SE DER ERRADO: Se vazio, tente sem -silent para ver erros, ou teste domínios diferentes

        ↓

PASSO 5: Separar etapas (para debug e análise)
├── POR QUE: Rodar tudo junto esconde onde o problema está
├── O QUE PROCURAR: Quantos subdomínios encontrou, quais estão vivos, quais têm vulns
├── COMANDO: subfinder -d target.com -all -silent > subdomains.txt (depois analise cada arquivo)
├── QUANDO AVANÇAR: Quando entender onde o pipeline falha
└── SE DER ERRADO: Se subfinder não achar nada, verifique se o domínio existe: dig target.com
```

**Dica:** Para ver erros, remova o `-silent` e rode cada etapa separadamente.

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

### 🎯 Quando usar o Subfinder
Quando precisar descobrir **quantos subdomínios existem** para um domínio. Use quando:
- Começando o reconhecimento de um novo alvo
- Precisar de uma lista **ampla** de subdomínios
- Quiser usar **múltiplas fontes** (40+ APIs) automaticamente
- Precisar de resultados em **batch** (múltiplos domínios)

### 🛠️ Como o Subfinder te ajuda
- **40+ fontes** → DNS, certificate transparency, VirusTotal, Shodan, etc
- **Rápido** → Encontra dezenas de subdomínios em segundos
- **Passivo** → Não toca no alvo (não é detectado)
- **Pipe friendly** → Alimenta outras ferramentas (httpx, nuclei)

### ➡️ Depois de rodar o Subfinder — Próximos passos
1. **Lista de subdomínios pronta?** → Passe para httpx: `subfinder -d empresa.com -silent | httpx -mc 200`
2. **URLs ativas encontradas?** → Passe para nuclei: `cat live.txt | nuclei -severity critical,high`
3. **Subdomínios interessantes?** → Escaneie cada um com Nmap
4. **Salve o output** → `subfinder -d empresa.com -o subdomains.txt`

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

# OUTPUT ESPERADO:
# [INF] Running against target.com
# [INF] Sources found: 23
# [INF] Found 45 subdomains for target.com (in 12.34 seconds)
# api.target.com
# mail.target.com
# vpn.target.com
# dev.target.com
# staging.target.com
# ...

# Com output para arquivo
subfinder -d target.com -o subdomains.txt
# OUTPUT ESPERADO:
# [INF] Found 45 subdomains for target.com
# [INF] Results saved to subdomains.txt

# Mais completo (todas as fontes)
subfinder -d target.com -all
# OUTPUT ESPERADO:
# [INF] Sources found: 40
# [INF] Found 67 subdomains for target.com (in 25.12 seconds)

# Output JSON
subfinder -d target.com -oJ subdomains.json
# OUTPUT ESPERADO:
# {"host":"api.target.com","input":"target.com","source":"crtsh"}
# {"host":"mail.target.com","input":"target.com","source":"virustotal"}

# Silencioso (só subdomínios)
subfinder -d target.com -silent
# OUTPUT ESPERADO:
# api.target.com
# mail.target.com
# vpn.target.com

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

### 🎯 Quando usar o Nuclei
Depois de descobrir URLs ativas. Use quando:
- Tiver uma **lista de URLs** para testar
- Precisar **automatizar** a busca por CVEs conhecidos
- Quiser **classificar** vulnerabilidades por severidade
- Precisar scanar **múltiplos alvos** rapidamente

### 🛠️ Como o Nuclei te ajuda
- **9000+ templates** → CVEs, misconfigurations, exposições, tecnologias
- **Automático** → Roda tudo sem intervenção manual
- **Severidade** → Classifica em critical, high, medium, low
- **Rápido** → Processa centenas de URLs por minuto

### ➡️ Depois de rodar o Nuclei — Próximos passos
1. **Vulnerabilidades encontradas?** → Pesquise o CVE no Google: "CVE-2024-1234 exploração"
2. **Misconfigurations?** → Teste manualmente com curl ou Burp Suite
3. **Crítico encontrado?** → Documente e passe para fase de exploração (Módulo 3)
4. **Salve o output** → `nuclei -u http://alvo.com -json -o nuclei_results.json`

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

### 🎯 Quando usar o httpx
Depois de descobrir subdomínios ou URLs. Use quando:
- Precisar saber **quais URLs respondem** HTTP
- Precisar **filtrar** URLs mortas (status 404, timeout)
- Precisar **coletar informações** (título, tecnologias, status)
- Precisar **validar** resultados do subfinder

### 🛠️ Como o httpx te ajuda
- **Filtra URLs mortas** → Só retorna URLs que respondem
- **Coleta dados** → Título, status code, tecnologias, web server
- **Rápido** → Processa centenas de URLs por segundo
- **Pipe friendly** → Recebe input de subfinder e alimenta nuclei

### ➡️ Depois de rodar o httpx — Próximos passos
1. **URLs ativas listadas?** → Passe para nuclei: `cat live.txt | nuclei -severity critical,high`
2. **Tecnologias detectadas?** → Pesquise vulnerabilidades específicas (ex: "WordPress 5.8 CVE")
3. **Status 200/301/302?** → Essas URLs são candidatas a teste manual
4. **Salve o output** → `cat urls.txt | httpx -o live.txt`

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

## Tool Card: Shodan CLI

**O que é:** Interface CLI para Shodan — busca de dispositivos, serviços e vulnerabilidades na internet inteira.

### 🎯 Quando usar o Shodan CLI
Quando precisar descobrir **o que está exposto na internet**. Use quando:
- Precisar encontrar **dispositivos específicos** (câmeras, servidores, SCADA)
- Precisar verificar se o alvo tem **vulnerabilidades conhecidas**
- Precisar pesquisar **por serviço ou porta** específica
- Quiser fazer **OSINT** sobre uma organização

### 🛠️ Como o Shodan te ajuda
- **Internet inteira** → Indexa dispositivos, serviços, banners
- **Vulnerabilidades** → Mapeia CVEs conhecidos em IPs
- **Filtros** → País, porta, organização, vulnerabilidade
- **Histórico** → Mostra como o serviço mudou ao longo do tempo

### ➡️ Depois de rodar o Shodan — Próximos passos
1. **IPs encontrados?** → Escaneie com Nmap para detalhes
2. **Vulnerabilidades listadas?** → Pesquise o CVE e tente explorar
3. **Dispositivos industriais?** → Cuidado! ICS/SCADA pode ser perigoso
4. **Salve o output** → `shodan host IP > shodan_results.txt`

### Instalação

```bash
pip3 install shodan
shodan init YOUR_API_KEY  # obter em https://account.shodan.io
```

### Comandos essenciais

| Comando | O que faz |
|:--------|:----------|
| `shodan search <query>` | Buscar dispositivos |
| `shodan host <IP>` | Ver detalhes de um IP |
| `shodan count <query>` | Contar dispositivos |
| `shodan scan submit <IP>` | Escanear IP |
| `shodan org list` | Listar organizações |
| `shodan net <CIDR>` | Buscar rede |

### Exemplos práticos

```bash
# Buscar servidores Apache no Brasil
shodan search "apache country:BR"
# OUTPUT ESPERADO:
# Total results: 123456
# IP                   Port  Organization
# 200.100.50.25        80    Telecom Italia
# 189.20.100.50        443   Claro SA

# Ver detalhes de um IP
shodan host 200.100.50.25
# OUTPUT ESPERADO:
# 200.100.50.25
#   Hostnames: srv01.empresa.com
#   Country: Brazil
#   Organization: Telecom Italia
#   Operating System: Linux
#   Ports: 22, 80, 443
#   Vulns: CVE-2021-44228

# Contar dispositivos com vulnerabilidade
shodan count "vuln:CVE-2021-44228 country:BR"
# OUTPUT ESPERADO:
# 1234

# Buscar webcams expostas
shodan search "has_screenshot:true port:554 country:BR"

# Buscar industrial control systems
shodan search "port:502 country:BR"  # Modbus
shodan search "port:102 country:BR"  # S7comm
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

---

## Lab Prático

### Exercício 1: Subdomain Enumeration com Subfinder
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/subdomainenumeration
- **O que vai praticar:** Enumeração passiva de subdomínios com Subfinder,.httpx e análise de resultados
- **Tempo estimado:** 30 minutos

### Exercício 2: Vulnerability Scanning com Nuclei
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/rrootme
- **O que vai praticar:** Scan de vulnerabilidades com Nuclei, identificação de CVEs e análise de severidade
- **Tempo estimado:** 45 minutos

### Exercício 3: OSINT e Reconhecimento
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/ohsint
- **O que vai praticar:** Coleta de informações de fontes públicas, OSINT e correlação de dados
- **Tempo estimado:** 60 minutos

### Exercício 4: Information Gathering
- **Plataforma:** HackTheBox
- **Link:** https://app.hackthebox.com/starting-point
- **O que vai praticar:** Reconhecimento inicial de máquinas, enumeração de serviços e coleta de dados
- **Tempo estimado:** 90 minutos

### Dica de Estudo
> Crie um pipeline de reconhecimento completo: Subfinder → httpx → Nuclei. Execute em múltiplos alvos para comparar resultados. Documente todos os subdomínios encontrados e classifique por risco.
