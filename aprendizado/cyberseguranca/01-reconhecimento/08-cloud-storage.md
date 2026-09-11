# ☁️ 8. Cloud Storage — Enumeração de Buckets S3, Azure e GCS

> Buckets S3, Azure Blob e Google Cloud Storage são frequentemente expostos publicamente. Encontrar um bucket com dados sensíveis é um finding de alto impacto.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 45min | ⭐⭐⭐ Avançado | `aws CLI, cloud_enum, curl` |

</div>

---

## 🎓 Por que Buckets Cloud São Alvos?

Empresas frequentemente configuram buckets S3/Azure/GCS para serem "públicos" sem perceber. Isso pode expor:

- **Backups de banco de dados** (`.sql`, `.bak`)
- **Código-fonte** (`.zip`, `.tar.gz` de repositórios)
- **Credenciais** (`.env`, `config.json`, `aws_access_key`)
- **Documentos internos** (PDFs, planilhas, contratos)
- **Logs de aplicações** (com dados de usuários)

---

## 🎯 Quando usar Enumeração de Cloud Storage

- Você identificou o domínio de uma empresa e quer ver se há buckets expostos
- Encontrou referências a S3 buckets em código-fonte (GitHub dorks)
- Quer testar se backups estão acessíveis publicamente
- Está fazendo pentest de infraestrutura cloud

---

## 🛠️ Como Cloud Storage te ajuda

### 1. aws CLI — Verificar Acesso Anônimo a Buckets

O AWS CLI permite testar se um bucket S3 está acessível sem autenticação.

**Instalação:**

```bash
sudo apt install awscli -y
```

**Uso básico:**

```bash
# Listar conteúdo de um bucket público (sem credenciais)
aws s3 ls s3://evilcorp-backups --no-sign-request 2>/dev/null

# Resultado esperado (ACESSÍVEL):
2026-01-15 10:30:00    123456 database-backup.sql
2026-01-10 08:15:00     45678 config-prod.zip
2026-01-05 14:20:00    234567 logs-2026.tar.gz

# Resultado esperado (INACESSÍVEL):
An error occurred (403) when calling the HeadBucket operation: Forbidden
```

**Flags explicadas:**
- `aws s3 ls` — lista objetos do bucket
- `s3://evilcorp-backups` — nome do bucket
- `--no-sign-request` — não usa credenciais AWS (teste anônimo)
- `2>/dev/null` — oculta erros de autenticação

**Download de arquivo específico:**

```bash
# Baixar um arquivo do bucket público
aws s3 cp s3://evilcorp-backups/config-prod.zip . --no-sign-request

# Resultado esperado:
download: s3://evilcorp-backups/config-prod.zip to ./config-prod.zip
```

---

### 2. cloud_enum — Scanner Multi-Cloud

O cloud_enum busca buckets em AWS, Azure e GCS simultaneamente.

**Instalação:**

```bash
git clone https://github.com/initstring/cloud_enum.git
cd cloud_enum
pip3 install -r requirements.txt
```

**Uso básico:**

```bash
# Buscar buckets com base no nome da empresa
python3 cloud_enum.py -k evilcorp -k evil-corp -k ec

# Resultado esperado:
[AWS] s3://evilcorp-backups - Status: 200 (PUBLIC!)
[AWS] s3://evilcorp-logs - Status: 403 (Private)
[AZURE] evilcorpblob.blob.core.windows.net - Status: 200 (PUBLIC!)
[GCS] evilcorp-storage.storage.googleapis.com - Status: 200 (PUBLIC!)
```

**Flags explicadas:**
- `-k evilcorp` — palavra-chave para buscar (pode usar múltiplas)
- `-k evil-corp` — segunda variação do nome
- `-k ec` — sigla da empresa

---

### 3. curl — Verificação Direta de Buckets

```bash
# Verificar se um bucket S3 existe
curl -s -o /dev/null -w "%{http_code}" https://evilcorp-backups.s3.amazonaws.com

# Resultados:
# 200 = Bucket existe e é acessível
# 403 = Bucket existe mas é privado
# 404 = Bucket não existe

# Listar conteúdo via HTTP (buckets com website habilitado)
curl -s https://evilcorp-backups.s3.amazonaws.com | head -50

# Resultado esperado:
<?xml version="1.0" encoding="UTF-8"?>
<ListBucketResult>
  <Name>evilcorp-backups</Name>
  <Contents>
    <Key>database-backup.sql</Key>
    <Size>123456</Size>
    <LastModified>2026-01-15T10:30:00.000Z</LastModified>
  </Contents>
</ListBucketResult>
```

---

### 4. GrayHatWarfare — Busca de Buckets

O site GrayHatWarfare indexa buckets S3 públicos.

**Acesse:** https://buckets.grayhatwarfare.com

**Uso:**
1. Acesse o site
2. Digite o nome da empresa: `evilcorp`
3. Veja buckets encontrados pela comunidade

---

## ➡️ Depois de usar Cloud Storage — Próximos passos

1. **Liste os arquivos** e identifique dados sensíveis (`.sql`, `.env`, `.zip`)
2. **Baixe arquivos** e analise com `strings`, `binwalk` ou `exiftool`
3. **Documente o impacto:** exposição de dados pessoais, credenciais, código-fonte
4. **Próximo arquivo:** [09-wayback-machine.md](09-wayback-machine.md) —Descubra endpoints antigos que ainda existem

---

## ⚠️ Erros Comuns

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Testar apenas S3 | Pode perder buckets Azure e GCS | Use cloud_enum para multi-cloud |
| Não verificar permissões | Falso positivo: bucket existe mas é privado | Sempre teste com `--no-sign-request` |
| Baixar dados sem autorização | Questões legais (mesmo que o bucket seja público) | Siga o escopo do pentest/bug bounty |

---

## 📖 Referências

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| aws CLI | Documentação | [aws.amazon.com/cli](https://aws.amazon.com/cli/) |
| cloud_enum | Ferramenta | [github.com/initstring/cloud_enum](https://github.com/initstring/cloud_enum) |
| GrayHatWarfare | Busca | [buckets.grayhatwarfare.com](https://buckets.grayhatwarfare.com) |
| AWS S3 Security | Guia | [docs.aws.amazon.com/s3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/security-best-practices.html) |

---

<div align="center">

**⬅️ [07-subdomain-takeover.md](07-subdomain-takeover.md)** | **[09-wayback-machine.md](09-wayback-machine.md) ➡️**

</div>
