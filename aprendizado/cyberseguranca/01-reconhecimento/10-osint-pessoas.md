# 👤 10. OSINT de Pessoas — Sherlock, Maigret e ExifTool

> Todo mundo deixa rastros digitais. Sherlock encontra contas em 400+ redes sociais. ExifTool extrai metadados ocultos de fotos e documentos.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 45min | ⭐⭐ Intermediário | `Sherlock, Maigret, ExifTool` |

</div>

---

## 🎓 Por que OSINT de Pessoas?

Em pentest e bug bounty, informações pessoais são valiosas:
- **Emails** → podem ser usados para phishing
- **Nomes de usuário** → podem revelar outras contas
- **Fotos** → podem conter localização GPS
- **Documentos** → podem conter metadados com nomes, empresas, versões de software

---

## 🎯 Quando usar OSINT de Pessoas

- Você tem um email ou nome de usuário e quer descobrir outras contas
- Precisa de informações sobre um alvo humano (pentest de社員)
- Encontrou um documento ou foto e quer extrair metadados
- Está fazendo reconhecimento para engenharia social

---

## 🛠️ Como OSINT de Pessoas te ajuda

### 1. Sherlock — Busca de Usuário em 400+ Redes Sociais

O Sherlock verifica se um nome de usuário existe em mais de 400 plataformas.

**Instalação:**

```bash
sudo apt install sherlock -y

# Ou via pip
pip install sherlock-project
```

**Uso básico:**

```bash
# Buscar um usuário em todas as redes sociais
sherlock "joao_silva"

# Resultado esperado:
[*] Buscando em 400+ sites...

[+] joao_silva encontrado em:
    ├── GitHub: https://github.com/joao_silva
    ├── Twitter: https://twitter.com/joao_silva
    ├── Instagram: https://instagram.com/joao_silva
    ├── LinkedIn: https://linkedin.com/in/joao_silva
    ├── Reddit: https://reddit.com/user/joao_silva
    └── YouTube: https://youtube.com/@joao_silva

[!] joao_silva NÃO encontrado em:
    ├── TikTok
    ├── Twitch
    └── Pinterest
```

**Flags explicadas:**
- `sherlock "joao_silva"` — nome de usuário para buscar
- `--print-found` — mostra apenas plataformas onde foi encontrado
- `--csv` — exporta resultados em formato CSV
- `--tor` — usa Tor para anonimato (opcional)

**Exemplo com filtros:**

```bash
# Buscar e exportar para CSV
sherlock "joao_silva" --print-found --csv

# Buscar em plataformas específicas
sherlock "joao_silva" --site github --site twitter --site linkedin
```

---

### 2. Maigret — Sherlock + Graus de Relação

O Maigret é como o Sherlock, mas também tenta descobrir **relações** entre contas.

**Instalação:**

```bash
pip install maigret
```

**Uso básico:**

```bash
# Buscar usuário com informações detalhadas
maigret joao_silva

# Resultado esperado:
[+] joao_silva encontrado em:
    ├── GitHub (joao_silva)
    │   ├── Repositórios: 15
    │   ├── Seguidores: 42
    │   └── Último commit: 2026-01-15
    ├── Twitter (@joao_silva)
    │   ├── Tweets: 1,234
    │   └── Localização: São Paulo, BR
    └── LinkedIn (joao-silva)
        ├── Empresa: EvilCorp
        └── Cargo: Developer

[+] Informações adicionais:
    ├── Email provável: joao.silva@evilcorp.com
    └── Time zone: UTC-3
```

---

### 3. ExifTool — Metadados de Fotos e Documentos

O ExifTool extrai metadados ocultos de arquivos (fotos, PDFs, documentos Office).

**Instalação:**

```bash
sudo apt install libimage-exiftool-perl -y
```

**Uso básico:**

```bash
# Extrair metadados de uma foto
exiftool foto.jpg

# Resultado esperado:
File Name                       : foto.jpg
File Size                       : 2.3 MB
File Modify Date                : 2026:01:15 10:30:00
Camera Make                     : Canon
Camera Model                    : EOS R5
Date/Time Original              : 2026:01:15 10:25:30
GPS Latitude                    : 23.5505 S  ← LOCALIZAÇÃO!
GPS Longitude                   : 46.6333 W  ← LOCALIZAÇÃO!
Software                        : Adobe Photoshop 25.0
Artist                          : João Silva  ← NOME!
Copyright                       : EvilCorp Inc.  ← EMPRESA!
```

> **⚠️ Foco:** Os campos `GPS Latitude/Longitude` revelam **exatamente onde a foto foi tirada**. O campo `Artist` revela o **nome do fotógrafo**.

**Flags explicadas:**
- `exiftool foto.jpg` — extrai todos os metadados
- `-a` — mostra tags duplicadas
- `-u` — mostra tags desconhecidas
- `-gps:*` — extrai apenas dados GPS

**Extraindo metadados de PDFs:**

```bash
# Metadados de um documento PDF
exiftool documento.pdf

# Resultado esperado:
File Name                       : documento.pdf
File Size                       : 456 KB
Creator                         : João Silva  ← AUTOR
Creator Tool                    : Microsoft Word 16.0
Create Date                     : 2026:01:10 14:30:00
Modify Date                     : 2026:01:15 09:15:00
Author                          : EvilCorp Security Team  ← EQUIPE!
Title                           : Relatório de Pentest Q1  ← TÍTULO!
```

---

## 🏢 SOCMINT Organizacional — Informações Públicas da Empresa

**SOCMINT (Social Media Intelligence)** é usar redes sociais e fontes públicas para descobrir informações sobre uma **organização**, não apenas pessoas.

### Por que isso importa?

Funcionários postam informações publicamente que podem revelar:
- **Tecnologias utilizadas** (post sobre nova stack, framework)
- **Infraestrutura interna** (screenshots com IPs, nomes de servidores)
- **Estrutura organizacional** (quem é o CTO, quem é o DevOps)
- **Vagas abertas** (revelam stack e tecnologias)
- **Reclamações** (revelam sistemas internos)

### LinkedIn OSINT

```bash
# Buscar funcionários da empresa
# LinkedIn: "site:linkedin.com 'Target Inc' 'engineer' OR 'developer'"

# Buscar por cargo
# LinkedIn: "site:linkedin.com 'Target Inc' 'security engineer'"

# Buscar por tecnologia
# LinkedIn: "site:linkedin.com 'Target Inc' 'kubernetes' OR 'docker'"

# Buscar posts públicos
# LinkedIn: "site:linkedin.com 'Target Inc' 'new project' OR 'launch'"
```

**O que encontrar:**
- **Engenheiros** → Podem ter perfis públicos com projetos
- **DevOps** → Podem mencionar ferramentas (AWS, K8s, Docker)
- **Segurança** → Podem postar sobre vulnerabilidades
- **Tech leads** → Podem ter contribuições open source

### Twitter/X OSINT

```bash
# Buscar posts sobre tecnologia
# Twitter: "from:targetcorp OR 'Target Inc' tech stack"

# Buscar reclamações de funcionários
# Twitter: "Target Inc' internal OR system OR server"

# Buscar screenshots
# Twitter: "Target Inc' screenshot OR dashboard"
```

**O que encontrar:**
- **Posts técnicos** → Devs postando sobre projetos
- **Screenshots** → Podem conter IPs, interfaces, dados
- **Reclamações** → Funcionários reclamando de sistemas
- **Check-ins** → Localização de escritórios, data centers

### Glassdoor / Reclame Aqui

```bash
# Glassdoor: informações sobre empresa
# glassdoor.com/Reviews/Target-Inc-Reviews

# Reclame Aqui (Brasil)
# reclameaqui.com.br/empresa/target-inc/
```

**O que encontrar:**
- **Reclamações** → Sistemas que funcionam mal
- **Benefícios** → Tecnologias mencionadas
- **Processos** → Como a empresa funciona
- **Estrutura** → Departamentos, hierarquia

### Vagas de Emprego

```bash
# LinkedIn Jobs
# linkedin.com/jobs/search/?company=Target+Inc

# Glassdoor Jobs
# glassdoor.com/Job/target-inc-jobs-SRCH_KE0,10.htm

# Gupy, InfoJobs, etc.
```

**O que encontrar:**
- **Stack tecnológica** → "Precisamos de devs React, Node, PostgreSQL"
- **Ferramentas** → "Experiência com AWS, Docker, K8s"
- **Nível de segurança** → "Conhecimento em OWASP, pentest"
- **Novos projetos** → "Estamos contratando para novo projeto de mobile"

### Fluxo de SOCMINT Organizacional

```
PASSO 1: LinkedIn
├── Funcionários → nomes, cargos, tecnologias
├── Posts → projetos, ferramentas
└── Vagas → stack, tecnologias

        ↓

PASSO 2: Twitter/X
├── Posts técnicos → ferramentas, frameworks
├── Screenshots → IPs, interfaces
└── Reclamações → sistemas internos

        ↓

PASSO 3: Glassdoor
├── Reclamações → sistemas com problemas
├── Benefícios → tecnologias mencionadas
└── Estrutura → departamentos

        ↓

PASSO 4: Vagas
├── Stack → linguagens, frameworks
├── Ferramentas → AWS, Docker, K8s
└── Segurança → OWASP, pentest

        ↓

RESULTADO: Mapa de tecnologias e infraestrutura
```

### Exemplo Prático

**Cenário:** Você está fazendo reconhecimento da "Target Corp"

**LinkedIn:**
- "Target Corp está contratando DevOps Engineer com experiência em Kubernetes e AWS"
- "Dev sênior postou: 'Migrando nossos microserviços para K8s'"

**Twitter:**
- "Conf screenshottando nosso novo dashboard de monitoramento com Grafana"
- "Novo sistema de pedidos扔no ar!"

**Glassdoor:**
- "O sistema legado em Java 8 está caindo toda hora"
- "Migraram do Jira para o Linear recentemente"

**O que você conclui:**
1. **Stack:** Java 8 (legado), Kubernetes, AWS, Grafana
2. **Sistemas:** Dashboard de monitoramento, sistema de pedidos
3. **Migração:** Java → K8s (pode haver versões antigas)
4. **Ferramentas:** Jira → Linear

---

## ➡️ Depois de usar OSINT de Pessoas — Próximos passos

1. **Use o email encontrado** para buscar em HaveIBeenPwned (breaches)
2. **Use o nome de usuário** para buscar em GitHub (código exposto)
3. **Use a localização GPS** para geolocalização precisa
4. **Combine com SOCMINT organizacional** para mapear tecnologias
5. **Próximo arquivo:** [11-javascript-analysis.md](11-javascript-analysis.md) —Analise JavaScript para encontrar endpoints ocultos

---

## ⚠️ Erros Comuns

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Não usar --print-found | Lista gigante com sites onde NÃO foi encontrado | Sempre use `--print-found` |
| Confiar em metadados de JPGs comprimidos | Metadados podem ser removidos em upload | Teste com vários formatos |
| Não verificar metadados de PDFs | Perde informações de autor e empresa | Sempre teste PDFs encontrados |

---

## 📖 Referências

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| Sherlock | Ferramenta | [github.com/sherlock-project/sherlock](https://github.com/sherlock-project/sherlock) |
| Maigret | Ferramenta | [github.com/soxoj/maigret](https://github.com/soxoj/maigret) |
| ExifTool | Ferramenta | [exiftool.org](https://exiftool.org/) |
| OSINT Framework | Referência | [osintframework.com](https://osintframework.com/) |

---

<div align="center">

**⬅️ [09-wayback-machine.md](09-wayback-machine.md)** | **[11-javascript-analysis.md](11-javascript-analysis.md) ➡️**

</div>
