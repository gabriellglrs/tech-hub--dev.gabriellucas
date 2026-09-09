# ☁️ Segurança em Cloud (AWS / Azure / GCP)

> Enumeração, misconfiguration e escalada em nuvem.

---

## 📚 O que é Segurança em Cloud e Containers?

**Cloud Security** é proteger serviços em nuvem (AWS, Azure, GCP). **Container Security** é proteger Docker e Kubernetes — ambientes isolados que rodando aplicações.

### Por que isso é importante?

- **90% das empresas** usam cloud hoje
- Containers podem ter **vulnerabilidades na imagem**
- Kubernetes mal configurado = **porta de entrada**
- Credenciais AWS vazadas = **conta comprometida em minutos**

### Como funciona na prática?

```
Configurar CLI (AWS CLI, kubectl)
        ↓
Escanear imagens Docker (Trivy, Grype)
        ↓
Auditar Kubernetes (kube-hunter)
        ↓
Monitorar em runtime (Falco)
        ↓
Detectar ameaças (Wazuh, CloudTrail)
```

### Ferramentas

| Ferramenta | Para que serve |
|:---|:---|
| **Trivy** | Scan de vulnerabilidades em imagens |
| **kube-hunter** | Pentest em Kubernetes |
| **kube-bench** | Verificar configurações CIS |
| **Falco** | Detecção de ameaças em runtime |
| **ScoutSuite** | Auditoria multi-cloud |

## 🛠️ Instalação

```bash
# AWS CLI
sudo apt install -y awscli

# Docker
sudo apt install -y docker.io docker-compose

# Trivy (scan de containers)
go install github.com/aquasecurity/trivy@latest

# kube-hunter (scan de Kubernetes)
pip3 install kube-hunter
```

---

## 🚀 Passo a Passo

### Passo 1: Enumeração pública (sem credencial)
```bash
# S3 buckets (AWS)
pip install cloud_enum
cloud_enum -k target --quickscan

# Azure blobs
cloud_enum -k target --quickscan -t azure

# ScoutSuite (audit sem credencial, só público)
scout aws --no-browser
```

### Passo 2: Com credencial (Pacu / Prowler)
```bash
# Prowler (CIS AWS)
pip install prowler
prowler aws --profile default

# Pacu (framework de exploit AWS)
pip install pacu
pacu
> import_keys default
> run iam__enum_users
> run s3__bucket_finder
```

### Passo 3: Escalada IAM
```bash
# Ver permissões
aws iam get-account-authorization-details
aws sts get-caller-identity

# Se tem iam:PassRole + ec2:RunInstances → privesc
pacu> run iam__privesc_scan
```

### Passo 4: GCP / Azure
```bash
# GCP
gcloud auth list
gcloud projects list

# Azure
az login
az ad sp list --all
```

---

## Ferramentas

| Ferramenta | Cloud | Uso |
|:---|:---|:---|
| **pacu** | AWS | Exploração pós-compromisso |
| **scoutsuite** | Multi | Auditoria misconfig |
| **prowler** | AWS/Azure | CIS Benchmark |
| **cloud_enum** | Multi | Enumeração pública |
| **trivy cloud** | Multi | Scan de infra como código |

## Misconfigs comuns

- S3 bucket público com `ListBucket`
- IAM role com `*:*`
- Security group `0.0.0.0/0` na porta 22/3389
- Chaves hardcoded no GitHub

---

### Resumo da ordem — Por que essa sequência?

Cloud/Containers segue: **configurar → escanear → auditar → monitorar**.

```
PASSO 1: Configurar CLI → Ter acesso às APIs cloud
├── POR QUE: Ferramentas precisam de autenticação para acessar cloud
├── O QUE FAZER: Instalar AWS CLI, configurar credenciais
├── COMANDO: aws configure (preencher com Access Key)
├── QUANDO AVANÇAR: Quando `aws s3 ls` funcionar
└── DICAS: Use IAM roles, nunca hardcode chaves

        ↓

PASSO 2: Escanear containers → Encontrar vulnerabilidades
├── POR QUE: Imagens Docker podem ter CVEs conhecidos
├── O QUE FAZER: Usar Trivy ou Grype
├── COMANDO: trivy image nginx:latest
├── QUANDO AVANÇAR: Quando tiver relatório de vulnerabilidades
└── DICAS: Atualize imagens regularmente

        ↓

PASSO 3: Auditar Kubernetes → Verificar configurações
├── POR QUE: K8s mal configurado = porta de entrada
├── O QUE FAZER: Usar kube-hunter, kube-bench
├── COMANDO: kube-hunter --remote 10.0.0.0/24
├── QUANDO AVANÇAR: Quando tiver relatório
└── DICAS: Verifique RBAC, secrets, network policies

        ↓

PASSO 4: Monitorar → Detectar ameaças em runtime
├── POR QUE: Vulnerabilidades em tempo real precisam de detecção
├── O QUE FAZER: Falco para runtime, Wazuh para SIEM
├── QUANDO PARAR: Quando tiver monitoramento ativo
└── DICAS: Configure alertas para comportamentos anômalos
```

---

## 🧪 Labs Práticos

### TryHackMe
- **[Cloud](https://tryhackme.com/room/awsfundamentals)** — AWS Fundamentals:枚举 e enumeração de serviços cloud
- **[Docker](https://tryhackme.com/room/dockersecurity)** — Docker Security: vulnerabilidades em containers
- **[Kubernetes](https://tryhackme.com/room/kubernetespwn)** — Kubernetes exploitation: privesc em clusters K8s

### HackTheBox
- **[Cloud](https://app.hackthebox.com/challenges/cloud)** — Desafios de cloud misconfiguration (AWS/Azure/GCP)
- **[Containers](https://app.hackthebox.com/challenges/containers)** — Escape de container e docker breakout
- **[Pro Labs: RastaLabs](https://app.hackthebox.com/prolabs/rastalabs)** — Ambiente enterprise com cloud e containers

### Exercícios Locais
```bash
# Scan de imagem Docker com Trivy
docker pull nginx:latest
trivy image nginx:latest

# Scan de manifesto Kubernetes
trivy config ./k8s-manifests/

# Enumerar buckets S3 públicos
cloud_enum -k target_company --quickscan

# Auditar configuração AWS com Prowler
prowler aws --compliance cis_2.0_aws
```

### Desafio Integrado
1. Suba um container vulnerable (ex: `docker run -d vulnerabledvwa`)
2. Escaneie com Trivy e identifique CVEs
3. Execute exploit no container
4. Documente o relatório de findings

> **Dica:** Para labs de cloud, sempre use contas sandbox/gratuitas (AWS Free Tier, GCP Free Trial) e nunca use credenciais reais em Produção.

---

## Lab Prático

### Exercício 1: Docker Security
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/dockersecurity
- **O que vai praticar:** Scan de imagens, configuração segura
- **Tempo estimado:** 45 min

### Exercício 2: AWS pentesting
- **Plataforma:** TryHackMe
- **Link:** https://tryhackme.com/room/awsfundamentals
- **O que vai praticar:** Enumeração AWS, configurações inseguras
- **Tempo estimado:** 60 min

### Dica de Estudo
> Comece com Docker local antes de ir para cloud. Entenda como containers funcionam antes de tentar escapar.

---
