# 🧰 Mini-Guia: Preparação para Reconhecimento

> Este guia preenche os gaps entre o Módulo 00 (Pré-requisitos) e o que o Módulo 01 (Reconhecimento) exige.

---

## 📋 O que o Módulo 01 Exige que o Módulo 00 Não Ensinou

| Ferramenta/Conhecimento | Status | O que fazer |
|:------------------------|:------:|:------------|
| **Go (golang)** | 🟠 Precisa de mini-guia | Instalar para ferramentas modernas |
| **jq** | 🟠 Precisa de mini-guia | Processar JSON em terminal |
| **Pipelines complexos** | 🟡 Precisa de mini-explicação | `comando1 | comando2 | comando3` |
| **curl avançado** | 🟡 Precisa de mini-explicação | Headers, métodos, output |
| **Python** | 🟢 Já ensinado no Módulo 00 | — |
| **Linux básico** | 🟢 Já ensinado no Módulo 00 | — |
| **DNS/Redes** | 🟢 Já ensinado no Módulo 00 | — |

---

## 🛠️ Go (golang) — Instalação e Uso

### O que é Go?

Go é uma linguagem de programação criada pelo Google. Muitas ferramentas modernas de segurança são escritas em Go porque são rápidas e compiladas em binário único.

### Ferramentas de segurança em Go

| Ferramenta | Para quê |
|:-----------|:---------|
| **Subfinder** | Enumeração de subdomínios |
| **Nuclei** | Scanner de vulnerabilidades |
| **httpx** | Probe de endpoints HTTP |
| **ffuf** | Fuzzing de web |
| **katana** | Web crawler |
| **Amass** | Enumeração DNS profunda |

### Instalação no Kali Linux

```bash
# Instalar Go
sudo apt update && sudo apt install golang -y

# Verificar instalação
go version
# OUTPUT: go version go1.22.x linux/amd64

# Configurar GOPATH (onde as ferramentas serão instaladas)
echo 'export GOPATH=$HOME/go' >> ~/.zshrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.zshrc
source ~/.zshrc

# Verificar configuração
go env GOPATH
# OUTPUT: /root/go (ou /home/usuario/go)
```

### Instalar ferramentas em Go

```bash
# Subfinder (enumeração de subdomínios)
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Nuclei (scanner de vulnerabilidades)
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# httpx (probe HTTP)
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# ffuf (fuzzing)
go install -v github.com/ffuf/ffuf/v2@latest

# katana (web crawler)
go install -v github.com/projectdiscovery/katana/cmd/katana@latest

# Verificar se instalou
which subfinder
# OUTPUT: /root/go/bin/subfinder
```

### Como usar

```bash
# Após instalar, as ferramentas ficam em ~/go/bin/
subfinder -d target.com
nuclei -u https://target.com

# Ou adicione ao PATH para usar de qualquer lugar
export PATH=$PATH:~/go/bin
```

---

## 🧩 jq — Processador de JSON no Terminal

### O que é jq?

`jq` é como o `grep`, mas para JSON. Permite filtrar, transformar e extrair dados de respostas JSON.

### Instalação

```bash
sudo apt install jq -y

# Verificar
jq --version
# OUTPUT: jq-1.6
```

### Uso Básico

```bash
# JSON de exemplo
echo '{"name": "Target Inc", "asn": 12345, "ips": ["203.0.113.1", "203.0.113.2"]}' | jq '.'

# OUTPUT:
# {
#   "name": "Target Inc",
#   "asn": 12345,
#   "ips": [
#     "203.0.113.1",
#     "203.0.113.2"
#   ]
# }

# Extrair campo específico
echo '{"name": "Target Inc", "asn": 12345}' | jq '.name'
# OUTPUT: "Target Inc"

# Extrair número
echo '{"name": "Target Inc", "asn": 12345}' | jq '.asn'
# OUTPUT: 12345

# Extrair item de array
echo '{"ips": ["203.0.113.1", "203.0.113.2"]}' | jq '.ips[0]'
# OUTPUT: "203.0.113.1"

# Extrair todos os itens de array
echo '{"ips": ["203.0.113.1", "203.0.113.2"]}' | jq -r '.ips[]'
# OUTPUT:
# 203.0.113.1
# 203.0.113.2

# Extrair campo de objeto aninhado
echo '{"data": {"asns": [{"asn": 12345, "name": "TARGET"}]}}' | jq '.data.asns[0].asn'
# OUTPUT: 12345
```

### jq no Reconhecimento

```bash
# BGPView API — extrair prefixos
curl -s "https://api.bgpview.io/asn/AS12345/prefixes" | \
  jq -r '.data.ipv4_prefixes[].prefix'

# OUTPUT:
# 203.0.113.0/24
# 198.51.100.0/22

# GitHub API — extrair nomes de repositórios
curl -s "https://api.github.com/orgs/targetcorp/repos" | \
  jq -r '.[].name'

# OUTPUT:
# api-gateway
# mobile-app
# docs

# Shodan — extrair portas
curl -s "https://api.shodan.io/shodan/host/203.0.113.1?key=API_KEY" | \
  jq '.ports[]'
```

### jq Combinado com Outros Comandos

```bash
# Buscar subdomínios e extrair apenas os domínios
curl -s "https://api.hackertarget.com/hostsearch/?q=target.com" | \
  cut -d',' -f1

# Buscar certificados e extrair nomes
curl -s "https://crt.sh/?q=target.com&output=json" | \
  jq -r '.[].name_value' | sort -u
```

---

## 🔗 Pipelines — Encadeando Comandos

### O que é um pipeline?

Um pipeline pega a **saída** de um comando e usa como **entrada** de outro. É como uma esteira de produção:

```
COMANDO 1 → saída → COMANDO 2 → saída → COMANDO 3 → resultado final
```

### Exemplos Progressivos

#### Nível 1: Pipe simples

```bash
# Listar processos e buscar "nginx"
ps aux | grep nginx

# O que acontece:
# ps aux → lista todos os processos
# |       → pega essa lista
# grep nginx → mostra apenas os que contêm "nginx"
```

#### Nível 2: Múltiplos pipes

```bash
# Buscar subdomínios, testar quais estão ativos
subfinder -d target.com -silent | httpx -mc 200

# O que acontece:
# subfinder -d target.com -silent → lista subdomínios (saída: texto)
# |                               → pega essa lista
# httpx -mc 200                   → testa quais retornam HTTP 200
```

#### Nível 3: Pipeline completo de reconhecimento

```bash
# Pipeline: subdomínios → HTTP → vulnerabilidades
subfinder -d target.com -silent | \
  httpx -mc 200 -silent | \
  nuclei -severity critical,high

# O que acontece:
# subfinder → descobre subdomínios
# httpx     → filtra apenas os que respondem
# nuclei    → escaneia vulnerabilidades nos que respondem
```

#### Nível 4: Pipeline com filtragem

```bash
# Encontrar subdomínios, extrair IPs, escanear portas
subfinder -d target.com -silent | \
  httpx -mc 200 -silent | \
  while read url; do
    ip=$(dig +short $(echo $url | sed 's|https\?://||' | cut -d'/' -f1))
    echo $ip
  done | sort -u | nmap -iL - -Pn -sV --top-ports 100
```

### Operadores Úteis

| Operador | O que faz | Exemplo |
|:---------|:----------|:--------|
| `\|` | Pipe (entrada do próximo comando) | `comando1 \| comando2` |
| `>` | Salvar saída em arquivo | `comando > arquivo.txt` |
| `>>` | Adicionar ao final do arquivo | `comando >> arquivo.txt` |
| `<` | Usar arquivo como entrada | `comando < arquivo.txt` |
| `&&` | Executar próximo se anterior funcionar | `comando1 && comando2` |
| `\|\|` | Executar próximo se anterior falhar | `comando1 \|\| comando2` |
| `;` | Executar próximo independente | `comando1 ; comando2` |

---

## 🌐 curl Avançado

### O que o Módulo 00 ensinou

```bash
curl https://example.com  # Requisição básica
```

### O que o Módulo 01 exige

```bash
# Ver headers de resposta
curl -s -I https://target.com

# Requisição POST com dados
curl -s -X POST https://target.com/api/users \
  -H "Content-Type: application/json" \
  -d '{"name": "test"}'

# Salvar output em arquivo
curl -s https://target.com/api/data -o resultado.json

# Seguir redirecionamentos
curl -s -L https://target.com

# Combinar com jq
curl -s https://api.target.com/data | jq '.results[]'

# Ver status code
curl -s -o /dev/null -w "%{http_code}" https://target.com

# Headers customizados (simular browser)
curl -s -H "User-Agent: Mozilla/5.0" \
     -H "Accept: application/json" \
     https://target.com/api
```

---

## 🔄 Resumo: Fluxo de Instalação

Execute esses comandos no Kali Linux **antes** de começar o Módulo 01:

```bash
# 1. Atualizar sistema
sudo apt update && sudo apt upgrade -y

# 2. Instalar Go
sudo apt install golang -y

# 3. Configurar GOPATH
echo 'export GOPATH=$HOME/go' >> ~/.zshrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.zshrc
source ~/.zshrc

# 4. Instalar jq
sudo apt install jq -y

# 5. Instalar ferramentas de reconhecimento
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest

# 6. Atualizar templates do Nuclei
nuclei -update-templates

# 7. Verificar instalação
echo "=== Verificação ==="
go version
jq --version
subfinder -version
nuclei -version
httpx -version
```

---

## ✅ Checklist de Preparação

Antes de começar o Módulo 01, verifique:

- [ ] Go instalado (`go version` retorna versão)
- [ ] jq instalado (`jq --version` retorna versão)
- [ ] subfinder funcional (`subfinder -version`)
- [ ] nuclei funcional (`nuclei -version`)
- [ ] httpx funcional (`httpx -version`)
- [ ] Entende pipes (`comando1 | comando2`)
- [ ] Conhece curl básico (`curl https://...`)
- [ ] Conhece jq básico (`curl ... | jq '.campo'`)

---

## ❓ Troubleshooting

| Problema | Solução |
|:---------|:--------|
| `go: command not found` | Reinicie o terminal ou `source ~/.zshrc` |
| `subfinder: command not found` | Verifique se `~/go/bin` está no PATH |
| `jq: command not found` | Execute `sudo apt install jq -y` |
| `permission denied` | Use `sudo` ou verifique permissões |
| Erro de compilação Go | Verifique se Go está atualizado: `sudo apt install golang` |
