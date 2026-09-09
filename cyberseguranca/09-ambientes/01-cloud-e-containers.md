# ☁️ Segurança em Cloud (AWS / Azure / GCP)

> Enumeração, misconfiguration e escalada em nuvem.

---

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
