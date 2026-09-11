# 🕸️ Frameworks OSINT

> Ferramentas que automatizam coleta de inteligência de fontes públicas — Maltego, Recon-ng, SpiderFoot.

---

## 📚 O que são Frameworks OSINT?

**Frameworks OSINT** são ferramentas que **automatizam** a coleta de informações de múltiplas fontes públicas de uma vez. Em vez de rodar 10 ferramentas separadas, você roda uma que faz tudo.

### Por que isso é importante?

- **Velocidade** → Coleta de 100+ fontes em minutos
- **Automação** → Não precisa rodar cada ferramenta manualmente
- **Correlação** → Cruza dados de múltiplas fontes
- **Visualização** → Maltego mostra relações em grafos
- **Repetibilidade** → Mesmo pipeline sempre que precisar

### Como funciona na prática?

```
Ferramenta manual:
├── theHarvester → emails
├── subfinder → subdomínios
├── whois → registro
├── dig → DNS
├── shodan → serviços
└── Juntar tudo manualmente → relatório

Framework OSINT:
└── Roda tudo de uma vez → correlaciona → relatório automático
```

### O que você vai descobrir?

| Tipo | Ferramenta | O que revela |
|:---|:---|:---|
| Emails | Recon-ng, SpiderFoot | Funcionários reais |
| Subdomínios | Recon-ng, Maltego | APIs, painéis internos |
| IPs | Todos | Onde hospeda |
| Redes sociais | Maltego, SpiderFoot | Pessoas, relacionamentos |
| Tecnologias | Recon-ng | Stack tecnológico |
| Vazamentos | Recon-ng, SpiderFoot | Credenciais expostas |

### Frameworks mais usados

| Framework | O que é | Nível | Prioridade |
|:---|:---|:---|:---|
| **Maltego** | Análise visual em grafos | Iniciante | Principal |
| **Recon-ng** | Framework modular para automação | Intermediário | Principal |
| **SpiderFoot** | OSINT automatizado com 200+ módulos | Iniciante | Complementar |

---

## 🚀 Passo a Passo — Montando um pipeline OSINT

Vamos aprender a usar cada framework para automatizar o reconhecimento.

### Passo 1: Instalar e configurar

```bash
# Maltego (interface gráfica)
sudo apt install -y maltego
# Ou baixe em https://www.maltego.com/downloads/
# Requer conta gratuita em https://www.maltego.com/registration/

# Recon-ng (terminal)
sudo apt install -y recon-ng
# Ou via pip:
pip3 install recon-ng

# SpiderFoot (web UI)
pip3 install spiderfoot
# Ou via Docker:
docker pull spiderfoot/spiderfoot
docker run -p 5001:5001 spiderfoot/spiderfoot
```

### Passo 2: Recon-ng — Pipeline automatizado

```bash
# Iniciar Recon-ng
recon-ng

# Criar workspace
workspaces create empresa_com
db insert domains
# Inserir: empresa.com

# Instalar módulos necessários
module install recon/domains-hosts/hackertarget
module install recon/domains-contacts/whois_pocs
module install recon/hosts-hosts/resolve
module install recon/hosts-ports/shodan_hostname

# Rodar módulos
modules load recon/domains-hosts/hackertarget
run

# Ver resultados
show hosts

# Exportar
db export /tmp/results.csv
```

### Passo 3: Maltego — Visualização em grafos

```
1. Abra o Maltego e faça login
2. Crie novo grafo: File → New Graph
3. Adicione entidade: Domain → digite "empresa.com"
4. Clique direito → Run Transform
5. Escolha: "To All Transforms"
6. Veja o grafo ser construído automaticamente

Transforms disponíveis:
├── Domain → IP addresses
├── Domain → Email addresses
├── Domain → Subdomains
├── Domain → DNS records
├── Email → Social profiles
├── IP → Services
└── Muito mais...
```

### Passo 4: SpiderFoot — Web UI

```bash
# Iniciar SpiderFoot
spiderfoot -l 0.0.0.0:5001

# Acesse no navegador: http://localhost:5001
# 1. Digite o alvo: empresa.com
# 2. Selecione os módulos (ou "All")
# 3. Clique em "Scan"
# 4. Aguarde o resultado
# 5. Veja o relatório completo
```

### Resumo da ordem — Por que essa sequência?

```
PASSO 1: Instalar framework → Pré-requisito
├── POR QUE: Precisa ter a ferramenta antes de usar
├── O QUE PROCURAR: Maltego pede conta, Recon-ng precisa de módulos
├── QUANDO AVANÇAR: Quando o framework rodar
└── SE DER ERRADO: Se Maltego não abrir, verifique Java: java -version

        ↓

PASSO 2: Criar workspace → Organizar resultados
├── POR QUE: Manter dados organizados por alvo
├── O QUE PROCURAR: Workspace criado, banco de dados vazio
├── QUANDO AVANÇAR: Quando tiver o workspace pronto
└── SE DER ERRADO: Se der erro, tente: workspaces create nome_teste

        ↓

PASSO 3: Rodar módulos → Coletar dados
├── POR QUE: Cada módulo coleta um tipo de informação
├── O QUE PROCURAR: Hosts, emails, IPs, subdomínios
├── QUANDO AVANÇAR: Quando tiver dados de todas as fontes
└── SE DER ERRADO: Se módulo falhar, verifique internet e API keys

        ↓

PASSO 4: Analisar e correlacionar → Encontrar padrões
├── POR QUE: Dados isolados não revelam tudo
├── O QUE PROCURAR: Relações entre entidades, dados sensíveis
├── QUANDO AVANÇAR: Quando tiver um mapa completo
└── SE DER ERRADO: Se muito dado, filtre por relevância
```

**Dica:** Comece com Recon-ng (mais simples) e avance para Maltego (mais visual).

---

## Tool Card: Maltego

**O que é:** Ferramenta de análise visual de links — mostra relacionamentos entre entidades em grafos.

### 🎯 Quando usar o Maltego
Quando precisar **visualizar** relacionamentos. Use quando:
- Precisar ver **conexões** entre pessoas, empresas, domínios
- Precisar fazer **apresentação** visual para cliente
- Precisar **explorar** dados de forma interativa
- Quiser uma interface **gráfica** (não terminal)

### 🛠️ Como o Maltego te ajuda
- **Grafos** → Visualiza relações que texto não mostra
- **Transforms** → 100+ fontes de dados integradas
- **Exportação** → PNG, PDF, CSV
- **Integração** → Conecta com APIs externas

### ➡️ Depois de usar o Maltego — Próximos passos
1. **Grafo pronto?** → Exporte como PNG para o relatório
2. **Pessoas encontradas?** → Use para phishing ou engenharia social
3. **Subdomínios encontrados?** → Escaneie com Nmap
4. **IPs encontrados?** → Verifique no Shodan

---

## Tool Card: Recon-ng

**O que é:** Framework modular para automação de OSINT — funciona como o Metasploit mas para reconhecimento.

### 🎯 Quando usar o Recon-ng
Quando precisar **automatizar** coleta. Use quando:
- Precisar rodar **múltiplos módulos** sem intervenção
- Precisar de **output estruturado** (JSON, CSV)
- Precisar **repetir** o mesmo pipeline para vários alvos
- Quiser uma ferramenta de **terminal** (sem GUI)

### 🛠️ Como o Recon-ng te ajuda
- **Modular** → 100+ módulos para diferentes fontes
- **Automático** → Roda tudo sem intervenção
- **Banco de dados** → Salva tudo em SQLite
- **Exportação** → CSV, JSON, relatórios

### ➡️ Depois de rodar o Recon-ng — Próximos passos
1. **Hosts encontrados?** → Exporte e passe para Nmap
2. **Emails encontrados?** → Use para brute force com Hydra
3. **Contatos encontrados?** → Documente para engenharia social
4. **Exporte tudo** → `db export /tmp/results.csv`

---

## Tool Card: SpiderFoot

**O que é:** OSINT automatizado com 200+ módulos — interface web, coleta e correlação automática.

### 🎯 Quando usar o SpiderFoot
Quando precisar de **visão completa** rapidamente. Use quando:
- Precisar coletar dados de **200+ fontes** de uma vez
- Precisar de **interface web** (não terminal)
- Precisar de **correlação automática** entre dados
- Quiser um **relatório** completo em HTML

### 🛠️ Como o SpiderFoot te ajuda
- **200+ módulos** → Email, social media, DNS, tecnologias
- **Web UI** → Fácil de usar no navegador
- **Correlação** → Cruza dados automaticamente
- **Relatório** → HTML com todos os achados

### ➡️ Depois de rodar o SpiderFoot — Próximos passos
1. **Relatório pronto?** → Exporte como HTML
2. **Vazamentos encontrados?** → Teste as credenciais
3. **Pessoas encontradas?** → Use para engenharia social
4. **Tecnologias encontradas?** → Pesquise CVEs específicos

---

## Comparação: Qual usar?

| Critério | Maltego | Recon-ng | SpiderFoot |
|:---------|:--------|:---------|:-----------|
| **Interface** | Gráfica (GUI) | Terminal (CLI) | Web UI |
| **Facilidade** | ⭐⭐⭐ Fácil | ⭐⭐ Médio | ⭐⭐⭐ Fácil |
| **Velocidade** | Lento | Rápido | Rápido |
| **Automação** | Baixa | Alta | Alta |
| **Visualização** | Excelente | Ruim | Boa |
| **Módulos** | 100+ | 100+ | 200+ |
| **Uso ideal** | Apresentação | Automação | Visão completa |

---

## Lab Prático

### Exercício 1: Recon-ng Básico
- **Objetivo:** Configure um workspace e rode 3 módulos
- **Módulos:** hackertarget, whois_pocs, resolve
- **Tempo estimado:** 30 minutos

### Exercício 2: Maltego Graph
- **Objetivo:** Crie um grafo de reconhecimento completo
- **Entidades:** Domain → IP → Email → Social Profile
- **Tempo estimado:** 45 minutos

### Exercício 3: SpiderFoot Scan
- **Objetivo:** Rode um scan completo e analise o relatório
- **Alvo:** Um domínio de prática (ex: tryhackme.com)
- **Tempo estimado:** 30 minutos

### Exercício 4: Comparação de Resultados
- **Objetivo:** Rode os 3 frameworks no mesmo alvo e compare
- **Analise:** Quais encontrou em um e não no outro?
- **Tempo estimado:** 60 minutos

### Dica de Estudo
> Comece com Recon-ng para aprender a lógica de módulos. Depois use Maltego para visualizar. SpiderFoot é ótimo para uma primeira visão rápida de qualquer alvo.
