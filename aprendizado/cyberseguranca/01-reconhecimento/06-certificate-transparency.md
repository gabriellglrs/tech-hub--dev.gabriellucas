# 📜 6. Certificate Transparency — Subdomínios nos Certificados SSL

> Todo certificado SSL/TLS emitido fica público em logs de transparência. Use isso para descobrir subdomínios que nunca apareceram em DNS público.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 30min | ⭐⭐ Intermediário | `crt.sh, curl, openssl` |

</div>

---

## 🎓 Por que isso importa?

Quando um administrator solicita um certificado SSL para `admin.evilcorp.com`, esse nome fica **registrado publicamente** em logs de Certificate Transparency (CT). Mesmo que o subdomínio não apareça em DNS público, ele aparece nos logs CT.

**Isso significa:** você pode descobrir subdomínios internos, de staging, e de desenvolvimento que o próprio dono não quer que você veja.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| O que é SSL/TLS | Sim | Módulo 02 |
| Como funciona DNS | Sim | Arquivo 01 deste módulo |
| Subdomínios | Sim | Arquivo 02 deste módulo |

---

## 🎯 Quando usar Certificate Transparency

- O subfinder/amass não encontrou subdomínios suficientes
- Quer encontrar subdomínios de **staging** ou **dev** (que não aparecem no DNS público)
- Precisa de uma lista **100% passiva** (sem nenhum contato com o alvo)
- Quer validar se um subdomínio suspeito realmente existiu

---

## 🛠️ Como Certificate Transparency te ajuda

### 1. crt.sh — O Banco de Dados Gratuito

O crt.sh é um site que indexa todos os certificados CT. É a forma mais fácil de descobrir subdomínios.

**Acesse:** https://crt.sh

**Uso básico:**

1. Acesse https://crt.sh
2. Digite o domínio: `evilcorp.com`
3. Clique em "Search"
4. Veja todos os certificados emitidos com subdomínios

**Resultado esperado:**

```
 crt.sh      |   evilcorp.com           | 2026-01-15 | Let's Encrypt
 crt.sh      |   admin.evilcorp.com     | 2026-01-15 | Let's Encrypt
 crt.sh      |   api.evilcorp.com       | 2026-01-15 | Let's Encrypt
 crt.sh      |   staging.evilcorp.com   | 2025-12-20 | Let's Encrypt
 crt.sh      |   dev.evilcorp.com       | 2025-12-20 | Let's Encrypt
 crt.sh      |   mail.evilcorp.com      | 2025-11-10 | DigiCert
```

> **⚠️ Foco:** `staging.evilcorp.com` e `dev.evilcorp.com` — esses subdomínios internos não apareceriam em DNS público!

---

### 2. Consulta via API do crt.sh (para scripts)

```bash
# Consultar subdomínios via API (formato JSON)
curl -s "https://crt.sh/?q=evilcorp.com&output=json" | jq -r '.[].name_value' | sort -u

# Resultado esperado:
admin.evilcorp.com
api.evilcorp.com
dev.evilcorp.com
evilcorp.com
mail.evilcorp.com
staging.evilcorp.com
www.evilcorp.com
```

**Flags explicadas:**
- `curl -s` — consulta silenciosa (sem barra de progresso)
- `?q=evilcorp.com` — domínio alvo
- `&output=json` — retorna em formato JSON
- `jq -r '.[].name_value'` — extrai apenas os nomes dos subdomínios
- `sort -u` — remove duplicatas

---

### 3. openssl — Análise de Certificado SSL

O `openssl` permite conectar diretamente a um servidor e analisar o certificado SSL.

**Instalação:**

```bash
sudo apt install openssl -y
```

**Uso básico:**

```bash
# Ver o certificado SSL de um domínio
openssl s_client -connect evilcorp.com:443 -servername evilcorp.com </dev/null 2>/dev/null | openssl x509 -noout -text

# Resultado esperado (trecho):
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number: 04:ab:cd:ef:12:34:56:78:90:ab:cd:ef:12:34:56:78
        Signature Algorithm: sha256WithRSAEncryption
        Issuer: C = US, O = Let's Encrypt, CN = R3
        Validity
            Not Before: Jan 15 00:00:00 2026 GMT
            Not After : Apr 15 23:59:59 2026 GMT
        Subject: CN = evilcorp.com
        Subject Alternative Name:
            DNS:evilcorp.com
            DNS:admin.evilcorp.com
            DNS:api.evilcorp.com
            DNS:*.evilcorp.com
```

> **🔍 Foco no SAN:** O campo "Subject Alternative Name" (SAN) lista **todos** os domínios cobertos por aquele certificado. Um certificado wildcard (`*.evilcorp.com`) cobre todos os subdomínios.

---

### 4. Extraindo SANs de múltiplos alvos

```bash
# Script para extrair SANs de vários domínios
for domain in evilcorp.com target.com another.com; do
    echo "=== $domain ==="
    echo | openssl s_client -connect $domain:443 -servername $domain 2>/dev/null | \
    openssl x509 -noout -ext subjectAltName 2>/dev/null
done

# Resultado esperado:
=== evilcorp.com
X509v3 Subject Alternative Name:
    DNS:evilcorp.com, DNS:admin.evilcorp.com, DNS:api.evilcorp.com
=== target.com
X509v3 Subject Alternative Name:
    DNS:target.com, DNS:www.target.com, DNS:staging.target.com
```

---

## ➡️ Depois de usar Certificate Transparency — Próximos passos

1. **Adicione os subdomínios encontrados** à sua lista principal do Subfinder/Amass
2. **Verifique quais estão ativos** com `httpx`
3. **Teste vulnerabilidades** com Nuclei nos subdomínios novos
4. **Combine com o Shodan** para ver portas abertas nesses subdomínios
5. **Próximo arquivo:** [07-subdomain-takeover.md](07-subdomain-takeover.md) —Descubra se esses subdomínios podem ser tomados

---

## ⚠️ Erros Comuns

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Confiar apenas em subfinder/amass | Perde subdomínios internos que só aparecem em CT | Sempre consulte crt.sh também |
| Não filtrar duplicatas | Lista inflada com o mesmo subdomínio 50 vezes | Use `sort -u` ou `uniq` |
| Ignorar subdomínios antigos | Subdomínios de staging podem ter vulnerabilidades antigas | Filtre por data: priorize os mais recentes |

---

## 📖 Referências

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| crt.sh | Ferramenta | [crt.sh](https://crt.sh) |
| Certificate Transparency | Conceito | [certificate-transparency.org](https://www.certificate-transparency.org/) |
| OpenSSL Docs | Documentação | [openssl.org/docs](https://www.openssl.org/docs/) |
| TryHackMe - OSINT | Lab | [tryhackme.com](https://tryhackme.com/room/ohsint) |

---

<div align="center">

**⬅️ [05-busca-infraestrutura.md](05-busca-infraestrutura.md)** | **[07-subdomain-takeover.md](07-subdomain-takeover.md) ➡️**

</div>
