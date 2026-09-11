# 🐙 GitHub e GitLab OSINT

> Repositórios públicos são uma mina de ouro — descubra tecnologias, endpoints, secrets e infraestrutura exposta em código-fonte.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 45min | ⭐⭐ Intermediário | `GitHub Dorking, GitDorker, truffleHog, git-secrets` |

</div>

---

## 📚 O que é GitHub/GitLab OSINT?

**GitHub/GitLab OSINT** é usar repositórios públicos para descobrir informações sobre uma organização. Desenvolvedores frequentemente publicam código que contém:

- **Endpoints de API** (`/api/v1/users`, `/api/internal/admin`)
- **Strings de conexão** (`mongodb://user:pass@host:27017/db`)
- **Chaves de API** (`AKIAIOSFODNN7EXAMPLE`, `sk_live_...`)
- **Configurações internas** (`config.production.yml`, `.env`)
- **Tecnologias utilizadas** (frameworks, bibliotecas, versões)
- **Estrutura do projeto** (pastas, arquivos, arquitetura)

### Por que isso importa?

```
EMPRESA (Target Inc)
    ↓
GitHub/GitLab
    ↓
Repositórios públicos
    ↓
Código-fonte
    ↓
├── Endpoints de API (ataque: API abuse)
├── Secrets/credenciais (ataque: credential stuffing)
├── Configurações (ataque: misconfiguration)
├── Tecnologias (ataque: CVE específicos)
├── Estrutura (ataque: social engineering)
└── Infraestrutura (ataque: network recon)
```

### O que é Dorking?

**Dorking** é usar operadores de busca avançados para encontrar conteúdo específico. No GitHub, isso permite buscar por:

| Operador | O que faz | Exemplo |
|:---------|:----------|:--------|
| `org:` | Busca em repositórios de uma organização | `org:targetcorp` |
| `path:` | Busca em caminhos específicos | `path:.env` |
| `filename:` | Busca por nome de arquivo | `filename:config` |
| `extension:` | Busca por extensão | `extension:json` |
| `repo:` | Busca em um repositório específico | `repo:user/project` |
| `language:` | Busca por linguagem | `language:python` |
| `created:` | Busca por data de criação | `created:>2025-01-01` |

---

## 🚀 Passo a Passo — GitHub Dorking

### Passo 1: Google Dorks para GitHub

Use o Google para buscar no GitHub:

```bash
# Buscar configurações de banco de dados
site:github.com "targetcorp" "mongodb://" OR "mysql://" OR "postgres://"

# Buscar chaves de API
site:github.com "targetcorp" "api_key" OR "apikey" OR "api-key"

# Buscar arquivos .env (configurações sensíveis)
site:github.com "targetcorp" filename:.env

# Buscar configurações AWS
site:github.com "targetcorp" "AKIA" OR "aws_access_key"

# Buscar endpoints de API
site:github.com "targetcorp" "/api/v1" OR "/api/v2" OR "/api/internal"

# Buscar strings de conexão
site:github.com "targetcorp" "mongodb+srv://" OR "redis://"

# Buscar configurações de produção
site:github.com "targetcorp" filename:config path:production

# Buscar chaves privadas SSH
site:github.com "targetcorp" filename:id_rsa OR filename:id_ed25519
```

**OUTPUT ESPERADO:**
```
GitHub - targetcorp/api-gateway: API Gateway service
GitHub - targetcorp/config-production: Production configuration
GitHub - targetcorp/mobile-app: Mobile application source code
```

**O que significa?** Cada resultado é um repositório público que pode conter informações úteis sobre a organização.

### Passo 2: GitHub Search Interface

Acesse https://github.com/search e use:

```
# Buscar na organização
org:targetcorp

# Combinar com palavras-chave
org:targetcorp password
org:targetcorp secret
org:targetcorp api_key
org:targetcorp config
org:targetcorp endpoint
```

### Passo 3: GitDorker (Automação)

```bash
# Instalar GitDorker
git clone https://github.com/obheda12/GitDorker.git
cd GitDorker
pip3 install -r requirements.txt

# Executar com dorks específicos
python3 GitDorker.py -q "Target Corp" -d dorks/medium_dorks.txt -t 20 -o gitdorker_results.csv

# OUTPUT ESPERADO:
# [+] Found: https://github.com/targetcorp/api-gateway/blob/main/config.yml
# [+] Found: https://github.com/targetcorp/mobile-app/blob/main/.env.example
# [+] Found: https://github.com/targetcorp/docs/blob/main/api-reference.md
```

### Passo 4: Buscar Secrets com truffleHog

```bash
# Instalar truffleHog
pip3 install trufflehog

# Escanear repositório específico
trufflehog git https://github.com/targetcorp/api-gateway

# Escanear todos os repositórios da organização
trufflehog github --org=targetcorp --only-verified

# OUTPUT ESPERADO:
# Found unverified result:
# Repository: targetcorp/api-gateway
# File: config/database.yml
# Line: 42
# Commit: abc123
# Diff: +  password: SuperSecret123!
```

**O que significa?** O truffleHog encontrou uma possible credencial no código. Isso pode ser um vetor de ataque real.

### Passo 5: Análise de Resultados

Para cada repositório encontrado, analise:

| Item | O que procurar | Onde |
|:-----|:---------------|:-----|
| **Endpoints** | URLs de API, rotas | Arquivos de configuração, documentação |
| **Secrets** | Chaves de API, senhas | `.env`, `config.*`, `*.yml` |
| **Tecnologias** | Frameworks, bibliotecas | `package.json`, `requirements.txt`, `go.mod` |
| **Infraestrutura** | IPs, domínios, portas | `docker-compose.yml`, `k8s/`, `terraform/` |
| **Historico** | Commits antigos | `git log --all` |

### Passo 6: Extrair de Repositórios Clonados

```bash
# Clonar repositório (apenas leitura)
git clone https://github.com/targetcorp/api-gateway.git

# Ver histórico de commits
cd api-gateway
git log --all --oneline

# Ver commits que alteraram arquivos sensíveis
git log --all --diff-filter=M -- "*.env" "*.yml" "*.json"

# Ver diff de commits específicos
git show abc123

# Buscar por secrets no código
grep -r "password" . --include="*.yml" --include="*.json" --include="*.env"
grep -r "api_key" . --include="*.py" --include="*.js" --include="*.go"
grep -r "secret" . --include="*.yml" --include="*.json"
grep -r "token" . --include="*.py" --include="*.js"

# Ver branches antigas
git branch -a

# Ver tags
git tag -l
```

---

## 🔍 GitLab OSINT

GitLab funciona de forma similar ao GitHub, mas com algumas diferenças:

### Busca no GitLab

```
# Buscar na organização
https://gitlab.com/targetcorp

# Buscar projetos públicos
https://gitlab.com/explore/projects?search=targetcorp

# Buscar por texto nos projetos
https://gitlab.com/search?search=targetcorp+password
```

### GitLab API

```bash
# Listar projetos públicos de uma organização
curl -s "https://gitlab.com/api/v4/groups/TARGETCORP/projects?visibility=public" | \
  jq '.[].name'

# Buscar em projetos
curl -s "https://gitlab.com/api/v4/projects?search=targetcorp&visibility=public" | \
  jq '.[].name'
```

---

## 🛡️ Termos Sensíveis para Buscar

Use esses termos em suas buscas:

| Categoria | Termos |
|:----------|:-------|
| **Credenciais** | `password`, `passwd`, `pwd`, `secret`, `token`, `key`, `credential` |
| **AWS** | `AKIA`, `aws_access_key`, `aws_secret_key`, `ASIA` |
| **APIs** | `api_key`, `apikey`, `api-key`, `authorization`, `bearer` |
| **Bancos** | `mongodb://`, `mysql://`, `postgres://`, `redis://`, `DATABASE_URL` |
| **SSH/TLS** | `id_rsa`, `id_ed25519`, `BEGIN RSA PRIVATE`, `BEGIN OPENSSH` |
| **Config** | `config`, `settings`, `.env`, `application.yml`, `docker-compose` |

---

## 📊 Interpretação dos Resultados

### O que cada descoberta significa?

| Descoberta | Impacto | Ação |
|:-----------|:--------|:-----|
| **Endpoint de API** | Superfície de ataque para API abuse | Testar com ferramentas de API |
| **Secret/credencial** | Acesso potencial a serviços | Verificar se é válida (autorizado apenas) |
| **Config.yml** | Informações sobre infraestrutura | Correlacionar com DNS/Shodan |
| **package.json** | Tecnologias e versões | Pesquisar CVEs específicos |
| **docker-compose.yml** | Serviços e portas | Correlacionar com portas abertas |
| **IPs em código** | Infraestrutura interna | Adicionar ao scan de rede |

### Fluxo de Correlação

```
GitHub Dorking
    ↓
Repositório encontrado: targetcorp/api-gateway
    ↓
Ler config.yml
    ↓
Encontrar: mongodb://admin:senha123@db.targetcorp.com:27017/prod
    ↓
Correlacionar:
    ├── db.targetcorp.com → DNS → 203.0.113.50
    ├── 203.0.113.50 → Nmap → Porta 27017 aberta
    ├── MongoDB v4.4 → CVE-2021-XXXXX
    └── Credencial encontrada → Possível acesso
```

---

## ⚠️ Ética e Legalidade

**IMPORTANTE:** GitHub/GitLab OSINT deve ser feito apenas em:

- ✅ Repositórios públicos
- ✅ Seu próprio repositório
- ✅ Ambiente autorizado para teste
- ✅ Dados públicos permitidos

**NÃO faça:**

- ❌ Acessar repositórios privados
- ❌ Usar credenciais encontradas em ambientes reais
- ❌ Fazer commit de secrets encontrados
- ❌ Acessar sistemas sem autorização
- ❌ Vazar informações sensíveis encontradas

> **Regra:** Se você encontrou algo sensível em repositório público, reporte ao proprietário de forma responsável.

---

## 🔗 Ferramentas Adicionais

| Ferramenta | O que faz | Link |
|:-----------|:----------|:-----|
| **GitDorker** | Automação de dorks | github.com/obheda12/GitDorker |
| **truffleHog** | Scan de secrets | github.com/trufflesecurity/truffleHog |
| **git-secrets** | Previne commits de secrets | github.com/awslabs/git-secrets |
| **gitallsearch** | Busca em múltiplos repositórios | github.com/dagrz/gitallsearch |
| **GitHub-Explorer** | Interface visual | github.com/GitHubExplorer |

---

## 🧠 Exercícios de Raciocínio

### Exercício 1: Análise de Repositório

**Cenário:** Você encontrou o repositório `targetcorp/mobile-app` no GitHub. Dentro dele, o arquivo `config/production.yml` contém:

```yaml
database:
  host: db.internal.targetcorp.com
  port: 5432
  name: production
  user: app_user
  password: ${DB_PASSWORD}

redis:
  host: cache.targetcorp.com
  port: 6379

api_keys:
  stripe: sk_live_xxxxxxxxxxxxx
  sendgrid: SG.xxxxxxxxxxxxx
```

**Pergunta:** O que você pode concluir? Quais seriam seus próximos passos?

**Raciocínio esperado:**
1. **Hostnames encontrados:** `db.internal.targetcorp.com` e `cache.targetcorp.com` → Posso fazer DNS para encontrar IPs
2. **Portas:** 5432 (PostgreSQL) e 6379 (Redis) → Posso escanear essas portas
3. **Credenciais:** `${DB_PASSWORD}` usa variável de ambiente → Provavelmente não está exposta, mas vale verificar
4. **Stripe key:** `sk_live_` → Chave de produção! Pode ser vulnerável se exposta
5. **SendGrid:** `SG.` → Chave de e-mail marketing

**Próximo passo:**
```bash
# Resolver DNS
dig db.internal.targetcorp.com +short
dig cache.targetcorp.com +short

# Escanear portas encontradas
nmap -sV -sC IP_ENCONTRADO -p 5432,6379

# Verificar se Stripe key é válida (NÃO fazer em produção!)
# Apenas documentar e reportar
```

### Exercício 2: Correlação com ASN

**Cenário:** Você descobriu que a empresa "Target Inc" tem o ASN AS12345. Ao escanear o range 203.0.113.0/24, encontrou o IP 203.0.113.50. No GitHub, encontrou um repositório com `db.internal.targetcorp.com` apontando para 203.0.113.50.

**Pergunta:** O que isso significa? Como você usaria essa informação?

**Raciocínio esperado:**
1. **Correlação confirmada:** O hostname interno está no range da empresa
2. **Ativo "invisível":** Não há subdomínio público apontando para esse IP
3. **Serviço:** Porta 5432 (PostgreSQL) está aberta
4. **Risco:** Se a credencial do GitHub funcionar, acesso direto ao banco

**Próximo passo:**
```bash
# Verificar se o PostgreSQL aceita conexão externa
nmap -sV -sC 203.0.113.50 -p 5432

# Se aceitar, documentar como finding de alto impacto
# NÃO tentar login sem autorização
```

### Exercício 3: Decision Tree

**Cenário:** Você encontrou duas coisas:
1. No GitHub: `mongodb://admin:senha123@db.targetcorp.com:27017/prod`
2. No Shodan: IP 203.0.113.50 com porta 27017 aberta

**Pergunta:** Qual sua prioridade? O que você faz primeiro?

**Raciocínio esperado:**
1. **Prioridade:** Verificar se a credencial é válida (em ambiente autorizado)
2. **Primeiro:** Confirmar que o IP pertence ao alvo (ASN/BGP)
3. **Depois:** Verificar se o MongoDB aceita conexão externa
4. **Se sim:** Documentar como critical finding
5. **Se não:** Investigar por que a porta está aberta (firewall? proxy?)

---

## ➡️ Próximo Passo

Depois de entender GitHub/GitLab OSINT:

1. **Aplique** em um alvo real (autorizado)
2. **Cruze** resultados com DNS e ASN
3. **Documente** cada descoberta no relatório
4. **Valide** com ferramentas de rede (Nmap)

---

## 📖 Referências

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| GitHub Security Best Practices | Guia | docs.github.com/en/code-security |
| GitLab Security | Guia | docs.gitlab.com/ee/user/application_security/ |
| truffleHog Documentation | Docs | trufflesecurity.com/trufflehog |
| GitDorker | Tool | github.com/obheda12/GitDorker |
