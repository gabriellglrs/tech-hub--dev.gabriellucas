# 🏴‍☠️ 7. Subdomain Takeover — Quando Subdomínios Perdidos Viram Portas

> Um subdomínio apontando para um serviço deletado é como uma porta aberta com o cartaz "estou disponível". Qualquer pessoa pode assumir o controle.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 45min | ⭐⭐⭐ Avançado | `Subzy, Nuclei, dig` |

</div>

---

## 🎓 O que é Subdomain Takeover?

Quando um subdomínio (ex: `blog.evilcorp.com`) aponta via CNAME para um serviço externo (ex: S3 bucket, Heroku, GitHub Pages) que foi **deletado**, qualquer pessoa pode **recriar** aquele serviço e assumir o controle do subdomínio.

**Exemplo:**
```
blog.evilcorp.com  →  CNAME  →  evilcorp-blog.s3.amazonaws.com
                                  ↑
                                  Bucket foi deletado, mas o CNAME ainda existe
                                  → Qualquer pessoa pode criar esse bucket
```

---

## 🎯 Quando usar Subdomain Takeover

- Você encontrou subdomínios via crt.sh, Subfinder ou Amass
- Quer descobrir se algum subdomínio aponta para serviços não utilizados
- Está fazendo pentest e quer identificar vetores de ataque
- Quer um finding de bug bounty de alto impacto

---

## 🛠️ Como Subdomain Takeover te ajuda

### 1. dig — Verificar CNAME Records

Antes de qualquer ferramenta, verifique manualmente se o subdomínio aponta para um serviço externo.

```bash
# Verificar CNAME de um subdomínio
dig blog.evilcorp.com CNAME +short

# Resultado esperado (VULNERÁVEL):
evilcorp-blog.s3.amazonaws.com.

# Resultado esperado (SEGURO):
blog.evilcorp.com.

# Verificar se o serviço está ativo
dig evilcorp-blog.s3.amazonaws.com A +short

# Se não retornar IP = serviço deletado = VULNERÁVEL
```

---

### 2. Subzy — Scanner Automatizado de Takeover

O Subzy verifica automaticamente se subdomínios apontam para serviços não utilizados.

**Instalação:**

```bash
# Instalar Subzy (requer Go)
go install -v github.com/LukaSvbicek/subzy@latest

# Verificar instalação
subzy -h
```

**Uso básico:**

```bash
# Verificar um subdomínio
subzy run --target blog.evilcorp.com

# Verificar lista de subdomínios
subzy run --targets subdomains.txt

# Resultado esperado:
[i] blog.evilcorp.com
  [+] VULNERABLE!
  Service: Amazon S3 Bucket
  CNAME: evilcorp-blog.s3.amazonaws.com
  Status: Not Found (404)
```

**Flags explicadas:**
- `subzy run` — executa a verificação
- `--target` — domínio ou IP para testar
- `--targets` — arquivo com lista de subdomínios (um por linha)

**Output esperado para subdomínio seguro:**

```
[i] admin.evilcorp.com
  [-] NOT VULNERABLE
  Service: Cloudflare
  Status: OK (200)
```

---

### 3. Nuclei — Templates de Takeover

O Nuclei possui templates específicos para detectar subdomain takeover.

```bash
# Verificar subdomain takeover com Nuclei
nuclei -l subdomains.txt -t http/takeovers/

# Resultado esperado:
[http-takeover] [critical] blog.evilcorp.com
[http-takeover] [high] staging.evilcorp.com
```

**Flags explicadas:**
- `-l subdomains.txt` — lista de alvos
- `-t http/takeovers/` — pasta com templates de takeover

---

### 4. Verificação Manual de Serviços Comuns

| Serviço | CNAME Pattern | Teste Manual |
|:--------|:-------------:|:------------:|
| AWS S3 | `*.s3.amazonaws.com` | `curl -I http://bucket.s3.amazonaws.com` |
| Heroku | `*.herokuapp.com` | `curl -I http://app.herokuapp.com` |
| GitHub Pages | `*.github.io` | `curl -I http://user.github.io` |
| Azure | `*.azurewebsites.net` | `curl -I http://app.azurewebsites.net` |
| Shopify | `*.myshopify.com` | `curl -I http://store.myshopify.com` |
| Fastly | `*.fastly.net` | `curl -I http://app.fastly.net` |

**Exemplo S3:**

```bash
# Se retornar "NoSuchBucket" = VULNERÁVEL
curl -I https://evilcorp-blog.s3.amazonaws.com

# Resultado esperado (VULNERÁVEL):
HTTP/1.1 404 Not Found
x-amz-error-code: NoSuchBucket
x-amz-error-message: The specified bucket does not exist
```

---

## ➡️ Depois de usar Subdomain Takeover — Próximos passos

1. **Registre o serviço** no domínio tomado (crie o bucket S3, crie o app Heroku, etc.)
2. **Documente o impacto:** cookie theft via session fixation, phishing, defacement
3. **Submeta como finding** em bug bounty programs
4. **Próximo arquivo:** [08-cloud-storage.md](08-cloud-storage.md) —枚enumere buckets S3, Azure e GCS

---

## ⚠️ Erros Comuns

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Testar apenas CNAME | Pode perder takeover via Alias/ANAME | Teste também registros A e AAAA |
| Não verificar status HTTP | Falso positivo: serviço pode retornar 404 mas estar ativo | Sempre verifique o corpo da resposta |
| Esquecer DNS cache | TTL alto pode esconder que o serviço mudou | Use `dig +trace` para ver o caminho completo |

---

## 📖 Referências

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| Subzy | Ferramenta | [github.com/LukaSvbicek/subzy](https://github.com/LukaSvbicek/subzy) |
| Nuclei Takeover Templates | Templates | [github.com/projectdiscovery/nuclei-templates](https://github.com/projectdiscovery/nuclei-templates) |
| OWASP Subdomain Takeover | Guia | [owasp.org](https://cheatsheetseries.owasp.org/cheatsheets/Subdomain_Takeover_Prevention_Cheat_Sheet.html) |
| AWS Threat Spotlight | Artigo | [aws.amazon.com](https://aws-security-blog.com/subdomain-takeover) |

---

<div align="center">

**⬅️ [06-certificate-transparency.md](06-certificate-transparency.md)** | **[08-cloud-storage.md](08-cloud-storage.md) ➡️**

</div>
