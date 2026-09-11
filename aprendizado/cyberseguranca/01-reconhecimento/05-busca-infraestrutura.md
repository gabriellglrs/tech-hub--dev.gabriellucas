# 🌐 Busca de Infraestrutura

> Mapeie a infraestrutura completa de uma organização — de ASN a dispositivos individuais.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 1h30min | ⭐⭐ Intermediário | `BGPView, whois, amass, Censys, FOFA, ZoomEye` |

</div>

---

## 📚 Parte 1: ASN e BGP — A Chave para a Infraestrutura Completa

### O que é ASN?

**ASN (Autonomous System Number)** é um número único que identifica uma organização na internet. Cada empresa grande (Google, Amazon, sua empresa de internet) tem pelo menos um ASN.

**Por que isso importa?**

Quando você pesquisa apenas `example.com`, encontra apenas o que está no DNS. Mas a empresa pode ter **dezenas de ranges de IPs** que não aparecem em DNS — servidores internos, ambientes de staging, infraestrutura adquirida de outra empresa, data centers esquecidos.

```
EMPRESA (Target Inc)
    ↓
ASN (AS12345)
    ↓
PREFIXOS / CIDRs
    ├── 203.0.113.0/24
    ├── 198.51.100.0/22
    └── 192.0.2.0/23
    ↓
HOSTS (cada IP dentro desses ranges)
    ↓
SERVIÇOS (portas abertas, serviços rodando)
    ↓
SUPERFÍCIE DE ATAQUE COMPLETA
```

### Conceitos Fundamentais

| Conceito | O que é | Exemplo |
|:---------|:--------|:--------|
| **ASN** | Número único de identificação de uma organização na internet | AS12345 |
| **Prefixo/CIDR** | Bloco de IPs anunciado por um ASN | 203.0.113.0/24 |
| **BGP** | Protocolo que roteia tráfego entre ASNs (como os "correios" da internet) | — |
| **PEERINGDB** | Banco de dados público de redes e seus ASNs | peeringdb.com |
| **BGPView** | API pública para consultar rotas BGP | bgpview.io |

### Relação: Empresa → ASN → Ranges → Hosts

```
Target Inc (empresa)
    │
    ├── Tem ASN AS12345
    │   ├── Anuncia prefixo 203.0.113.0/24 (256 IPs)
    │   ├── Anuncia prefixo 198.51.100.0/22 (1024 IPs)
    │   └── Total: 1280 IPs potenciais para escanear
    │
    ├── Tem ASN AS67890 (aquisição)
    │   └── Anuncia prefixo 192.0.2.0/23 (512 IPs)
    │
    └── Total de superfície: 1792 IPs
        └── Cada IP pode ter portas abertas
            └── Cada porta pode ter serviços vulneráveis
```

### Como Descobrir o ASN de uma Organização

#### Método 1: BGPView API (mais confiável)

```bash
# Buscar ASN pelo nome da organização
curl -s "https://api.bgpview.io/search?query_term=Target+Inc" | \
  jq '.data.asns[] | {asn: .asn, name: .name, description: .description}'

# OUTPUT ESPERADO:
# {
#   "asn": 12345,
#   "name": "TARGET-INC",
#   "description": "Target Inc, US"
# }
```

**O que significa?** A organização "Target Inc" está associada ao ASN AS12345. Esse ASN é a porta de entrada para toda a infraestrutura pública da empresa.

#### Método 2: amass intel

```bash
# Descobrir ASN de uma organização
amass intel -org "Target Inc" -o amass_asns.txt

# OUTPUT:
# AS12345 | TARGET-INC | Target Inc
# AS67890 | TARGET-CDN | Target content delivery
```

#### Método 3: whois por organização

```bash
whois -h whois.radb.net -- '-i origin AS12345'
```

### De ASN para Ranges de IPs

```bash
# Puxar todos os prefixos IPv4 do ASN
ASN=12345
curl -s "https://api.bgpview.io/asn/AS${ASN}/prefixes" | \
  jq -r '.data.ipv4_prefixes[].prefix' > cidr_ranges.txt

# OUTPUT ESPERADO (cidr_ranges.txt):
# 203.0.113.0/24
# 198.51.100.0/22
# 192.0.2.0/23

# Ver quantos ranges foram encontrados
wc -l cidr_ranges.txt
# 3 cidr_ranges.txt

# Para múltiplos ASNs (se a empresa tem mais de um)
for asn in 12345 67890; do
  curl -s "https://api.bgpview.io/asn/AS${asn}/prefixes" | \
    jq -r '.data.ipv4_prefixes[].prefix'
done | sort -u > all_cidrs.txt
```

**O que significa?** Cada linha é um bloco de IPs que pertence à organização. Esses ranges são onde a empresa hospeda sua infraestrutura.

### IPs sem DNS — Os Ativos "Invisíveis"

Muitos servidores não têm registro DNS. Esses são os mais difíceis de encontrar — e muitas vezes os mais vulneráveis:

```bash
# Encontrar IPs sem PTR record (sem DNS reverso)
while read ip; do
  ptr=$(dig +short -x "$ip" 2>/dev/null)
  if [ -z "$ptr" ]; then
    echo "Sem PTR: $ip"
  fi
done < discovered_ips.txt

# OUTPUT:
# Sem PTR: 203.0.113.50
# Sem PTR: 203.0.113.128
```

**Por que isso importa?** IPs sem DNS reverso são frequentemente:
- Servidores internos que foram expostos acidentalmente
- Ambientes de staging/teste que ninguém lembrou de remover
- Infraestrutura de empresas adquiridas que ainda não foi integrada
- Servidores "órfãos" que ninguém gerencia

### Fluxo Completo de ASN Mapping

```
PASSO 1: Nome da empresa → ASN
├── BGPView API: "Target Inc" → AS12345
├── amass intel: amass intel -org "Target Inc"
└── Output: lista de ASNs

        ↓

PASSO 2: ASN → Prefixos CIDR
├── BGPView API: AS12345 → 203.0.113.0/24, 198.51.100.0/22
├── amass intel: amass intel -asn 12345
└── Output: lista de ranges

        ↓

PASSO 3: CIDRs → Hosts ativos
├── Nmap host discovery: nmap -sn 203.0.113.0/24
├── validação de hosts
└── Output: lista de IPs ativos

        ↓

PASSO 4: Hosts → Serviços
├── Nmap port scan: nmap -sV -sC IP
├── Service detection
└── Output: portas abertas, versões

        ↓

PASSO 5: Correlacionar com DNS
├── Subdomínios apontam para esses IPs?
├── Alguns IPs não têm subdomínio? (ativos "invisíveis")
└── Output: superfície de ataque completa
```

### Ferramentas para ASN Mapping

| Ferramenta | Tipo | O que faz | Custo |
|:-----------|:-----|:----------|:------|
| **BGPView** | API web | Busca ASN por nome, lista prefixos | Gratuito |
| **amass intel** | CLI | ASN mapping integrado ao Amass | Gratuito |
| **Metabigor** | CLI | Org → ASN → CIDR automatizado | Gratuito |
| **bgp.he.net** | Web | Interface visual de BGP | Gratuito |
| **PEERINGDB** | Web/API | Banco de dados de redes | Gratuito |
| **ASNHunter** | CLI | Multi-source ASN recon | Gratuito |

### Exercício Prático: ASN Mapping

**Objetivo:** Mapeie a infraestrutura da organização "Example Corp"

```bash
# Passo 1: Encontrar ASN
curl -s "https://api.bgpview.io/search?query_term=Example+Corp" | \
  jq '.data.asns[] | {asn: .asn, name: .name}'

# Passo 2: Listar prefixos (substitua ASNUMERO pelo ASN encontrado)
curl -s "https://api.bgpview.io/asn/ASNUMERO/prefixes" | \
  jq -r '.data.ipv4_prefixes[].prefix' > ranges.txt

# Passo 3: Contar ranges
wc -l ranges.txt

# Passo 4: Escanear um range específico
nmap -sn -Pn 203.0.113.0/24 -oG hosts.txt
```

### Interpretação dos Resultados

| Resultado | O que significa | Próximo passo |
|:----------|:----------------|:--------------|
| ASN encontrado com 1 range pequeno (/24) | Empresa pequena ou division específica | Escaneie o range completo |
| ASN encontrado com múltiplos ranges | Infraestrutura robusta | Priorize ranges maiores |
| IP sem DNS reverso | Possível ativo "invisível" | Escaneie com Nmap |
| IP com PTR para outro domínio | Possível aquisição ou infra compartilhada | Verifique relação com a empresa |

---

## 📚 Parte 2: Motores de Busca de Infraestrutura

> Motores de busca para dispositivos, serviços e vulnerabilidades na internet inteira — Censys, FOFA, ZoomEye.

**Busca de infraestrutura** é usar motores de busca especializados para encontrar **dispositivos, serviços e vulnerabilidades** expostos na internet. É como o Google, mas para servidores, câmeras, bancos de dados e qualquer coisa conectada.

### Por que isso é importante?

- **Internet inteira** → Indexa milhões de dispositivos
- **Vulnerabilidades** → Mapeia CVEs conhecidos em IPs
- **Exposição** → Revela o que empresas esqueceram exposto
- **Alternativas** → Cada motor tem fontes diferentes (mais dados)

### Como funciona na prática?

```
Shodan:     "port:22 country:BR" → Todos os SSHs do Brasil
Censys:     "services.port=443 AND location.country=Brazil" → HTTPS no Brasil
FOFA:       "port=\"3306\" && country=\"BR\"" → MySQLs expostos
ZoomEye:    "app:nginx country:cn" → Nginxs na China
```

### O que você vai descobrir?

| Tipo | Motor | O que revela |
|:---|:---|:---|
| SSH expostos | Shodan, Censys | Portas 22 abertas |
| Web servers | Todos | Apache, Nginx, IIS |
| Bancos de dados | Todos | MySQL, PostgreSQL, MongoDB |
| Câmeras | Shodan, ZoomEye | IPs de câmeras |
| IoT/ICS | Shodan, Censys | Dispositivos industriais |
| Vazamentos | Censys, FOFA | Dados expostos |

### Motores principais

| Motor | O que é | Vantagem |
|:---|:---|:---|
| **Shodan** | O mais conhecido | Comunidade ativa, API gratuita |
| **Censys** | Mais completo | Dados históricos, API robusta |
| **FOFA** | Alternativa chinesa | Indexa coisas que outros não |
| **ZoomEye** | Similar ao Shodan | Foco em vulnerabilidades |

---

## 🚀 Passo a Passo — Usando cada motor

Vamos aprender a usar cada motor de busca de infraestrutura.

### Passo 1: Shodan CLI (já instalado no Módulo 1)

```bash
# Se não instalou ainda:
pip3 install shodan
shodan init SUA_API_KEY  # obter em https://account.shodan.io

# Buscar servidores SSH expostos no Brasil
shodan search "port:22 country:BR"
# OUTPUT ESPERADO:
# IP                   Port  Organization
# 200.100.50.25        22    Telecom Italia
# 189.20.100.50        22    Claro SA

# Ver detalhes de um IP
shodan host 200.100.50.25
# OUTPUT ESPERADO:
# 200.100.50.25
#   Hostnames: srv01.empresa.com
#   Country: Brazil
#   Ports: 22, 80, 443
#   Vulns: CVE-2021-44228

# Buscar câmeras expostas
shodan search "has_screenshot:true port:554 country:BR"

# Buscar bancos de dados
shodan search "port:3306 country:BR"  # MySQL
shodan search "port:5432 country:BR"  # PostgreSQL
shodan search "port:27017 country:BR" # MongoDB

# Contar dispositivos com vulnerabilidade
shodan count "vuln:CVE-2021-44228 country:BR"
```

#### Shodan Queries Avançadas para Bug Bounty

```bash
# Buscar por organização específica
shodan search "org:'Target Inc'"

# Buscar por dominio específico
shodan search "hostname:target.com"

# Buscar por certificado SSL (encontra subdomínios)
shodan search "ssl.cert.subject.CN:target.com"

# Buscar por certificado SHA256 (encontra todos os IPs com mesmo certificado)
shodan search "ssl.cert.sha256:abc123..."

# Buscar por tecnologia específica
shodan search "product:nginx hostname:target.com"
shodan search "product:Apache hostname:target.com"
shodan search "product:Microsoft-IIS hostname:target.com"

# Buscar por vulnerabilidade específica
shodan search "vuln:CVE-2021-44228 org:'Target Inc'"

# Buscar portas comuns de admin
shodan search "port:8080,8443,9090 org:'Target Inc'"

# Buscar FTP anônimo
shodan search "port:21 anonymous" 

# Buscar MongoDB exposto
shodan search "port:27017 product:MongoDB"

# Buscar Elasticsearch exposto
shodan search "port:9200 product:Elasticsearch"

# Buscar Docker exposto
shodan search "port:2375 product:Docker"

# Combinar filtros
shodan search "org:'Target Inc' port:443 ssl:true"
```

#### Interpretando Output do Shodan

```bash
shodan host 203.0.113.50
```

**OUTPUT:**
```
203.0.113.50
Hostnames: api.target.com
Country: United States
Organization: Target Inc
City: San Jose, California

Ports:
  22/tcp  open  ssh         OpenSSH 8.9p1
  80/tcp  open  http        nginx 1.18.0
  443/tcp open  https       nginx 1.18.0
  3306/tcp open  mysql       MySQL 8.0.28

Vulns:
  CVE-2021-44228 (Log4Shell) - CVSS: 10.0
  CVE-2022-22965 (Spring4Shell) - CVSS: 9.8
```

**O que significa?**
- **22/tcp ssh OpenSSH 8.9p1** → SSH exposto, versão específica
- **80/443 nginx 1.18.0** → Web server com versão conhecida
- **3306/mysql MySQL 8.0.28** → Banco de dados exposto externamente (CRÍTICO)
- **CVEs** → Vulnerabilidades conhecidas nesse IP

### Passo 2: Censys

```bash
# Instalar Censys CLI
pip3 install censys

# Login (precisa de conta em https://censys.io/)
censys config
# Digite: API ID e API Secret

# Buscar hosts
censys search "services.port=443 AND location.country=Brazil"

# Buscar por serviço específico
censys search "services.service_name=SSH AND location.country=US"

# Buscar por vulnerabilidade
censys search "services.port=443 AND services.tls.certificates.leaf.names=*.google.com"

# Ver detalhes de um host
censys host 200.100.50.25

# Buscar em inventário
censys inventory
```

#### Censys Queries Avançadas

```bash
# Buscar por organização
censys search "autonomous_system.organization:Target Inc"

# Buscar por domínio em certificado
censys search "services.tls.certificates.leaf.names:target.com"

# Buscar por tecnologia
censys search "services.software.product:nginx AND services.port:443"

# Buscar por CVE
censys search "services.vulnerabilities.cve:CVE-2021-44228"

# Buscar por IP específico
censys search "ip:203.0.113.0/24"

# Buscar por porta e serviço
censys search "services.port:3306 AND services.service_name:MySQL"

# Buscar hosts com mais de X portas
censys search "services.count>5 AND autonomous_system.asn:12345"
```

#### Censys vs Shodan — Quando usar cada?

| Cenário | Shodan | Censys |
|:--------|:-------|:-------|
| Busca rápida por porta/país | ✅ Melhor | ⚠️ Mais lento |
| Dados históricos | ⚠️ Limitado | ✅ Excelente |
| Certificados SSL | ⚠️ Básico | ✅ Detalhado |
| API para automação | ✅ Boa | ✅ Excelente |
| CVE hunting | ✅ Bom | ✅ Melhor |
| Organização/ASN | ⚠️ Limitado | ✅ Melhor |

### Passo 3: FOFA

```bash
# FOFA é web-based: https://fofa.info/
# Syntax de busca:

# Porta específica
port="3306" && country="BR"

# Serviço específico
app="nginx" && country="CN"

# Texto no banner
banner="SSH-2.0-OpenSSH" && country="BR"

# Combinação
port="443" && org="Amazon" && country="US"

# Output via API:
# https://fofa.info/api/v1/search/all?email=EMAIL&key=KEY&qbase64=cG9ydD0iMzMwNiI=
```

### Passo 4: ZoomEye

```bash
# ZoomEye é web-based: https://www.zoomeye.org/
# Syntax de busca:

# Porta e país
port:22 country:br

# App específico
app:nginx country:cn

# CVE específica
vuln:CVE-2021-44228

# IoT
has_screenshot:true port:554

# Via API:
# curl -H "API-KEY: YOUR_KEY" "https://api.zoomeye.org/host/search?query=port:22+country:br"
```

### Resumo da ordem — Por que essa sequência?

```
PASSO 1: Shodan → O mais básico e conhecido
├── POR QUE: Comece pelo mais simples
├── O QUE PROCURAR: Portas abertas, serviços, vulnerabilidades
├── QUANDO AVANÇAR: Quando dominar o Shodan
└── SE DER ERRADO: Se API key expirar, gere nova em https://account.shodan.io

        ↓

PASSO 2: Censys → Mais completo e com dados históricos
├── POR QUE: Dados que o Shodan não mostra
├── O QUE PROCURAR: Histórico de vulnerabilidades, certificados TLS
├── QUANDO AVANÇAR: Quando precisar de dados mais detalhados
└── SE DER ERRADO: Se API limitar, upgrade para plano pago

        ↓

PASSO 3: FOFA → Alternativa com mais indexação
├── POR QUE: Indexa coisas que outros não encontram
├── O QUE PROCURAR: Banners, tecnologias específicas
├── QUANDO AVANÇAR: Quando o Shodan/Censys não mostrarem o suficiente
└── SE DER ERRADO: Se retornar pouco, tente语法 diferente

        ↓

PASSO 4: ZoomEye → Foco em vulnerabilidades
├── POR QUE: Melhor para busca por CVE
├── O QUE PROCURAR: Dispositivos com CVEs conhecidos
├── QUANDO AVANÇAR: Quando precisar focar em vulnerabilidades
└── SE DER ERRADO: Se API limitar, use a interface web
```

**Dica:** Use múltiplos motores — cada um tem fontes diferentes. O ideal é cruzar resultados.

---

## Tool Card: Censys

**O que é:** Motor de busca de infraestrutura com dados históricos — sabe o que estava exposto no passado.

### 🎯 Quando usar o Censys
Quando o Shodan não é suficiente. Use quando:
- Precisar de **dados históricos** (o que estava exposto antes)
- Precisar de **certificados TLS** (domínios associados a um IP)
- Precisar de **inventário completo** de um bloco de IPs
- Quiser **API robusta** para automação

### 🛠️ Como o Censys te ajuda
- **Histórico** → Saber o que estava exposto há 6 meses
- **Certificados** → Descobre domínios associados a IPs
- **Inventário** → Mapeia todos os serviços de um bloco
- **API** → Fácil de integrar em scripts

### ➡️ Depois de rodar o Censys — Próximos passos
1. **Hosts encontrados?** → Escaneie com Nmap para detalhes
2. **Certificados encontrados?** → Descubra subdomínios extras
3. **Vulnerabilidades encontradas?** → Pesquise o CVE
4. **Exporte** → Use a API para processar em Python

---

## Tool Card: FOFA

**O que é:** Motor de busca chinês que indexa coisas que outros não encontram.

### 🎯 Quando usar o FOFA
Quando o Shodan/Censys não mostram o suficiente. Use quando:
- Precisar de **indexação diferente** (fontes próprias do FOFA)
- Precisar buscar por **texto no banner** específico
- Precisar de **dados de dispositivos chineses** (FOFA indexa mais)
- Quiser uma **alternativa gratuita** ao Shodan

### 🛠️ Como o FOFA te ajuda
- **Indexação** → Coisas que o Shodan não encontra
- **Banners** → Busca por texto exato no banner
- **Gratuito** → Limite generoso de queries
- **API** → Fácil de usar com curl

### ➡️ Depois de rodar o FOFA — Próximos passos
1. **Resultados encontrados?** → Valide com Nmap
2. **Banners interessantes?** → Copie e analise
3. **IPs encontrados?** → Escaneie com Nmap
4. **Exporte** → Use a API para processar

---

## Comparação: Qual usar?

| Critério | Shodan | Censys | FOFA | ZoomEye |
|:---------|:-------|:-------|:-----|:--------|
| **Preço** | Freemium | Freemium | Gratuito | Freemium |
| **Facilidade** | ⭐⭐⭐ | ⭐⭐ | ⭐⭐ | ⭐⭐ |
| **Dados históricos** | Limitado | ✅ Excelente | Limitado | Limitado |
| **Indexação** | Boa | Excelente | Excelente | Boa |
| **API** | Boa | Excelente | Boa | Boa |
| **Foco** | Geral | Geral | Geral | Vulnerabilidades |
| **Ideal para** | Início | Análise profunda | Complemento | CVE hunting |

---

## Fluxo típico de Busca de Infraestrutura

```
1. Shodan → Busca básica de portas e serviços
        ↓
2. Censys → Dados históricos e certificados
        ↓
3. FOFA → Complementar com indexação diferente
        ↓
4. ZoomEye → Foco em vulnerabilidades conhecidas
        ↓
5. Cruzar resultados → Lista consolidada de alvos
        ↓
6. Nmap → Investigar cada alvo encontrado
```

---

## Lab Prático

### Exercício 1: Shodan Básico
- **Objetivo:** Encontre 10 servidores SSH expostos no Brasil
- **Comando:** `shodan search "port:22 country:BR"`
- **Tempo estimado:** 15 minutos

### Exercício 2: Censys Inventário
- **Objetivo:** Mapeie todos os serviços de um bloco de IPs
- **Comando:** `censys search "ip=200.100.50.0/24"`
- **Tempo estimado:** 20 minutos

### Exercício 3: FOFA + Nmap
- **Objetivo:** Encontre MySQLs expostos e escaneie com Nmap
- **FOFA:** `port="3306" && country="BR"`
- **Nmap:** `nmap -sV -sC IP_ENCONTRADO`
- **Tempo estimado:** 25 minutos

### Exercício 4: Comparação de Motores
- **Objetivo:** Busque o mesmo alvo em 4 motores e compare
- **Alvo:** Um IP ou domínio de prática
- **Analise:** Qual encontrou mais dados?
- **Tempo estimado:** 30 minutos

### Dica de Estudo
> Monte um script que consulta os 4 motores e consolida os resultados. Isso automatiza o processo e garante que você não perde nada.
