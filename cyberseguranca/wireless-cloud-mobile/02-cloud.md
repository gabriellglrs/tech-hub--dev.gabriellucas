# ☁️ Segurança em Cloud (AWS / Azure / GCP)

> Enumeração, misconfiguration e escalada em nuvem.

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
