# 🕰️ 9. Wayback Machine — Endpoints Antigos Que Ainda Existem

> A Wayback Machine indexa a web desde 1996. Endpoints que foram removidos de produção podem continuar acessíveis — e contêm vulnerabilidades.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 30min | ⭐⭐ Intermediário | `waybackurls, gau, curl` |

</div>

---

## 🎓 Por que Endpoints Antigos São Perigosos?

Quando uma empresa remove uma página ou funcionalidade:
- O **código-fonte** continua nos backups
- Os **parâmetros de URL** continuam indexados
- **APIs antigas** podem não ter autenticação
- **Endpoints de debug** podem estar expostos

A Wayback Machine (web.archive.org) guarda snapshots de páginas web desde 1996. Ferramentas como `waybackurls` e `gau` extraem essas URLs automaticamente.

---

## 🎯 Quando usar Wayback Machine

- Quer encontrar endpoints que foram removidos mas ainda estão acessíveis
- Precisa de uma lista de URLs históricas para fuzzing
- Quer descobrir APIs antigas sem autenticação
- Está fazendo reconhecimento passivo (sem contato com o alvo)

---

## 🛠️ Como Wayback Machine te ajuda

### 1. waybackurls — Extrair URLs Históricas

O waybackurls extraí todas as URLs que o Wayback Machine já indexou para um domínio.

**Instalação:**

```bash
go install github.com/tomnomnom/waybackurls@latest
```

**Uso básico:**

```bash
# Extrair todas as URLs históricas
echo "evilcorp.com" | waybackurls

# Resultado esperado:
https://evilcorp.com/
https://evilcorp.com/about
https://evilcorp.com/admin
https://evilcorp.com/admin/config.php
https://evilcorp.com/api/v1/users
https://evilcorp.com/backup/database.sql
https://evilcorp.com/debug/info.php
https://evilcorp.com/login
https://evilcorp.com/wp-content/uploads/2025/backup.zip

# Filtrar apenas URLs com parâmetros (para testar SQLi/XSS)
echo "evilcorp.com" | waybackurls | grep "="

# Resultado:
https://evilcorp.com/search?q=test
https://evilcorp.com/page?id=123
https://evilcorp.com/user?name=admin
```

**Flags explicadas:**
- `echo "evilcorp.com"` — domínio alvo
- `| waybackurls` — pipe para o waybackurls
- `grep "="` — filtra apenas URLs com parâmetros

---

### 2. gau — GetAllURLs (Mais Completo)

O gau busca URLs do Wayback Machine **e** de outras fontes (Common Crawl, OTX, URLScan).

**Instalação:**

```bash
go install github.com/lc/gau/v2/cmd/gau@latest
```

**Uso básico:**

```bash
# Extrair URLs de todas as fontes
gau evilcorp.com

# Resultado esperado:
https://evilcorp.com/
https://evilcorp.com/api/v1/users
https://evilcorp.com/api/v2/users?role=admin
https://evilcorp.com/debug/config
https://evilcorp.com/wp-admin/install.php
https://evilcorp.com/old-page.html

# Filtrar por extensão (encontrar backups)
gau evilcorp.com --ext php,txt,zip,sql,bak

# Resultado:
https://evilcorp.com/config.php.bak
https://evilcorp.com/backup.sql
https://evilcorp.com/debug.txt
```

**Flags explicadas:**
- `gau evilcorp.com` — busca URLs de todas as fontes
- `--ext php,txt,zip,sql,bak` — filtra por extensões de arquivo

---

### 3. waymore — O Mais Completo (Alternativa)

O waymore busca em **40+ fontes** (Wayback, Common Crawl, AlienVault OTX, URLScan, etc.).

**Instalação:**

```bash
git clone https://github.com/xnl-h4ck3r/waymore.git
cd waymore
pip3 install -r requirements.txt
```

**Uso básico:**

```bash
# Buscar em todas as fontes
python3 waymore.py -i evilcorp.com -mode U

# Resultado esperado:
[WAYMORE] Found 15,234 URLs for evilcorp.com
[COMMON CRAWL] Found 8,456 URLs
[OTX] Found 2,134 URLs
[URLSCAN] Found 1,876 URLs
```

---

### 4. curl — Verificar se Endpoint Antigo Ainda Existe

```bash
# Testar se um endpoint encontrado ainda está ativo
curl -s -o /dev/null -w "%{http_code}" https://evilcorp.com/admin/config.php

# Resultados:
# 200 = Endpoint ainda existe! (VULNERÁVEL)
# 301/302 = Redirecionou (pode existir com auth)
# 403 = Existe mas negado (pode ser bypass)
# 404 = Realmente removido

# Listar endpoints ativos de uma lista
while read url; do
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    echo "$status $url"
done < wayback_urls.txt | grep "^200"
```

---

## ➡️ Depois de usar Wayback Machine — Próximos passos

1. **Filtre URLs** com parâmetros (`?id=`, `?q=`, `?page=`) — são candidatos a SQLi/XSS
2. **Procure backups** (`.sql`, `.bak`, `.zip`) — podem conter dados sensíveis
3. **Teste endpoints ativos** com status 200 — podem estar sem autenticação
4. **Próximo arquivo:** [10-osint-pessoas.md](10-osint-pessoas.md) —Descubra informações sobre pessoas

---

## ⚠️ Erros Comuns

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Confiar apenas no Wayback | Perde URLs do Common Crawl e OTX | Use `gau` ou `waymore` para múltiplas fontes |
| Não filtrar por extensão | Lista gigante com URLs inúteis | Use `--ext` para filtrar |
| Testar URLs sem verificar status | Perde tempo em endpoints 404 | Use `curl -w "%{http_code}"` primeiro |

---

## 📖 Referências

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| Wayback Machine | Ferramenta | [web.archive.org](https://web.archive.org) |
| waybackurls | Ferramenta | [github.com/tomnomnom/waybackurls](https://github.com/tomnomnom/waybackurls) |
| gau | Ferramenta | [github.com/lc/gau](https://github.com/lc/gau) |
| waymore | Ferramenta | [github.com/xnl-h4ck3r/waymore](https://github.com/xnl-h4ck3r/waymore) |

---

<div align="center">

**⬅️ [08-cloud-storage.md](08-cloud-storage.md)** | **[10-osint-pessoas.md](10-osint-pessoas.md) ➡️**

</div>
