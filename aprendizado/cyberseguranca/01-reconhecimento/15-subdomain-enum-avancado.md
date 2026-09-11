# 🕸️ 15. Subdomain Enum Avançado — OWASP Amass

> Encontre TODOS os subdomínios do alvo — não apenas os que aparecem no DNS público. Amass é a ferramenta mais completa para mapeamento de superfície de ataque.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 45min | ⭐⭐⭐ Avançado | `amass` |

</div>

---

## 🎓 Por que usar Amass?

Enquanto o Subfinder (arquivo 02) é rápido e foca em enumeração passiva, o Amass vai mais fundo:

- **50+ fontes de dados** (APIs, certificados, scraping, arquivos)
- **Brute force DNS** recursivo
- **Alterations** — gera variações de nomes (test1, test2, stg, dev)
- **Database interna** — mantém histórico entre scans
- **Visualização** — gera gráfos de relacionamento

**Quando usar Amass vs Subfinder:**

| Cenário | Subfinder | Amass |
|---------|-----------|-------|
| Scan rápido inicial | Sim | Não |
| Enumeração profunda | Não | Sim |
| Bruteforce DNS | Não | Sim |
| Múltiplas organizações | Não | Sim (via org) |
| Histórico entre scans | Não | Sim |
| Recursos limitados | Sim | Não (pesado) |

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| DNS básico | Sim | Arquivo 01 |
| Subdomínios | Sim | Arquivo 02 |
| Go (para instalar) | Sim | Arquivo 02 |

---

## 🎯 Quando usar Amass

- O Subfinder não encontrou subdomínios suficientes
- Precisa de brute force DNS
- Quer manter histórico entre scans
- Está mapeando uma organização inteira (múltiplos domínios)
- Quer visualizar relacionamentos entre descobertas

---

## 🛠️ Amass — Instalação

### Opção 1: Kali Linux (recomendado)

```bash
# Pre-installed no Kali
amass -version

# Se não estiver:
sudo apt update && sudo apt install amass
```

### Opção 2: Via Go

```bash
go install -v github.com/owasp-amass/amass/v4/...@master
```

### Opção 3: Via Docker

```bash
docker pull caffix/amass
docker run -v $(pwd)/output:/.config/amass/ caffix/amass enum -d example.com
```

---

## 🛠️ Subcomandos do Amass

O Amass tem 4 subcomandos principais:

```
amass intel    — Coletar inteligência sobre a organização
amass enum     — Enumeração DNS e mapeamento de rede
amass viz      — Visualizar resultados
amass track    — Rastrear mudanças entre scans
amass db       — Manipular o banco de dados interno
```

---

### 1. amass intel — Inteligência da Organização

Descobre domínios, ASNs e ranges IP associados a uma organização.

**Flags principais:**

| Flag | Descrição | Exemplo |
|------|-----------|---------|
| `-d` | Domínio alvo | `-d evilcorp.com` |
| `-org` | Nome da organização | `-org "Evil Corp"` |
| `-addr` | IPs/ranges | `-addr 192.168.1.0/24` |
| `-asn` | ASNs | `-asn 13374` |
| `-whois` | Reverse WHOIS | `-whois` |
| `-active` | Recon ativo (certificados) | `-active` |
| `-timeout` | Tempo em minutos | `-timeout 30` |

**Exemplos:**

```bash
# Descobrir domínios da Evil Corp
amass intel -org "Evil Corp"

# Output esperado:
# 13374, MAIN_PRODUCT -- Evil Corp
# 222222, SECONDARY_PRODUCT - Evil Corp

# Enumerar IPs de um ASN específico
amass intel -active -asn 222222 -ip

# Com timeout de 30 minutos
amass intel -timeout 30 -d evilcorp.com
```

---

### 2. amass enum — Enumeração DNS Completa

Este é o subcomando principal. Faz enumeração passiva + ativa + brute force.

**Flags principais:**

| Flag | Descrição | Exemplo |
|------|-----------|---------|
| `-d` | Domínio alvo | `-d evilcorp.com` |
| `-passive` | Apenas passivo (rápido) | `-passive` |
| `-brute` | Brute force DNS | `-brute` |
| `-w` | Wordlist customizada | `-w wordlist.txt` |
| `-src` | Mostrar fonte de cada descoberta | `-src` |
| `-ip` | Mostrar IPs | `-ip` |
| `-o` | Salvar em arquivo | `-o resultado.txt` |
| `-oA` | Salvar em TODOS os formatos | `-oA amass_scan` |
| `-json` | Output JSON | `-json out.json` |
| `-bl` | Blacklist de subdomínios | `-bl "staging.test.com"` |
| `-blf` | Blacklist via arquivo | `-blf blacklist.txt` |
| `-nf` | Subdomínios já conhecidos | `-nf known.txt` |
| `-min-for-recursive` | Mínimo para brute recursivo | `-min-for-recursive 3` |
| `-r` | DNS resolvers customizados | `-r 8.8.8.8,1.1.1.1` |
| `-rf` | Resolvers via arquivo | `-rf resolvers.txt` |
| `-max-dns-queries` | Máximo de queries simultâneas | `-max-dns-queries 200` |
| `-noalts` | Sem alterações de nomes | `-noalts` |
| `-timeout` | Tempo em minutos | `-timeout 30` |

**Exemplos:**

**Enumeração passiva (rápida, sem contato direto com o alvo):**
```bash
amass enum -passive -d evilcorp.com -src
```

**Output esperado:**
```
[ThreatCrowd]     update-wiki.evilcorp.com
[BufferOver]      my.evilcorp.com
[Crtsh]           www.lists.evilcorp.com
[VirusTotal]      ns.evilcorp.com
[URLScan]         api-staging.evilcorp.com
...
42 names discovered - scrape: 12, cert: 15, archive: 8, dns: 7
```

**Enumeração completa com brute force:**
```bash
amass enum -v -src -ip -brute -min-for-recursive 3 -d evilcorp.com
```

**Output esperado:**
```
[Google] www.evilcorp.com
[VirusTotal] ns.evilcorp.com
[Crtsh] admin.evilcorp.com
[BruteForce] dev.evilcorp.com
[BruteForce] staging.evilcorp.com
...
13139 names discovered - archive: 171, cert: 2671, scrape: 6290, brute: 991, dns: 250, alt: 2766
```

**Com wordlist customizada:**
```bash
amass enum -brute -w /usr/share/wordlists/seclists/Discovery/DNS/subdomains-top1million-5000.txt -d evilcorp.com
```

**Com blacklist (excluir subdomínios que não interessam):**
```bash
amass enum -d evilcorp.com -brute -bl "www,mail,ftp" -o resultado.txt
```

**Salvando em todos os formatos:**
```bash
amass enum -d evilcorp.com -brute -oA amass_scan
# Cria: amass_scan.json, amass_scan.txt, amass_scan.xml
```

**Múltiplos domínios:**
```bash
amass enum -d evilcorp.com -d evilcorp.org -d evilcorp.net
```

**Via arquivo de domínios:**
```bash
amass enum -df domains.txt -brute -o resultado.txt
```

---

### 3. amass viz — Visualização

```bash
# Visualizar em formato de grafo
amass viz -d3 -d evilcorp.com

# Visualizar apenas subdomínios descobertos
amass viz -d evilcorp.com
```

---

### 4. amass track — Rastrear Mudanças

```bash
# Comparar com scan anterior
amass track -d evilcorp.com -since "01/01/2026"

# Output mostra subdomínios novos e removidos
```

---

### 5. amass db — Manipular Banco de Dados

```bash
# Listar todos os subdomínios no banco
amass db -d evilcorp.com -show

# Exportar para JSON
amass db -d evilcorp.com -json export.json
```

---

## 🔗 Pipeline: Subfinder + Amass

A melhor abordagem é combinar ambos:

```bash
# 1. Subfinder (rápido, passivo)
subfinder -d evilcorp.com -silent -o subfinder.txt

# 2. Amass (profundo, com brute force)
amass enum -d evilcorp.com -brute -o amass.txt

# 3. Combinar e deduplicar
cat subfinder.txt amass.txt | sort -u > todos_subdominios.txt

# 4. Validar quais estão vivos
cat todos_subdominios.txt | httpx -silent -status-code -o vivos.txt
```

---

## ⚠️ Erros Comuns

| Erro | Causa | Solução |
|------|-------|---------|
| Amass muito lento | Brute force + muitas queries | Use `-passive` ou diminua `-max-dns-queries` |
| "No names found" | Domínio não existe ou está bloqueado | Verifique o domínio com `dig` primeiro |
| Muitos falsos positivos | DNS wildcard configurado | Use `-bl` para excluir padrões conhecidos |
| Timeout | Scan muito grande | Use `-timeout 60` |
| "Connection refused" | Firewall bloqueando DNS | Use `-r 8.8.8.8,1.1.1.1` com resolvers públicos |
| Banco de dados corrompido | Scan interrompido | Delete `~/.config/amass/` e recomece |

---

## 🎯 Cheat Sheet Rápido

```bash
# === INTEL ===
amass intel -org "Nome da Empresa"
amass intel -active -d evilcorp.com

# === ENUM ===
# Passivo (rápido)
amass enum -passive -d evilcorp.com -src

# Completo com brute force
amass enum -v -src -ip -brute -min-for-recursive 3 -d evilcorp.com

# Com wordlist customizada
amass enum -brute -w wordlist.txt -d evilcorp.com

# Múltiplos domínios
amass enum -d corp1.com -d corp2.com -brute

# Salvar todos os formatos
amass enum -d evilcorp.com -brute -oA scan_result

# Com blacklist
amass enum -d evilcorp.com -brute -bl "test,staging"

# === TRACK ===
amass track -d evilcorp.com -since "01/01/2026"

# === DB ===
amass db -d evilcorp.com -show
amass db -d evilcorp.com -json export.json
```

---

## 📚 Referências

- [OWASP Amass GitHub](https://github.com/owasp-amass/amass)
- [Amass User Guide](https://github.com/owasp-amass/amass/wiki/User-Guide)
- [Amass Tutorial](https://github.com/owasp-amass/amass/wiki/Tutorial)
- [Amass Installation](https://github.com/owasp-amass/amass/wiki/Installation-Guide)
- [OWASP Amass Project](https://owasp.org/www-project-amass/)

---

**Próximo:** [16. Detecção de WAF](16-deteccao-waf.md) — Wafw00f, Nikto e WPScan para identificar proteções antes de atacar

**Anterior:** [14. Discovery de Conteúdo](14-discovery-de-conteudo.md)
