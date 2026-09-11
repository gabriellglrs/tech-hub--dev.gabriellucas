# 🌐 Busca de Infraestrutura

> Motores de busca para dispositivos, serviços e vulnerabilidades na internet inteira — Censys, FOFA, ZoomEye.

---

## 📚 O que é Busca de Infraestrutura?

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
