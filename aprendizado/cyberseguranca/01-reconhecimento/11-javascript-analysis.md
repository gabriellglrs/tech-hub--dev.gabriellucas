# 🔍 11. Análise de JavaScript — Endpoints e Segredos Ocultos

> Arquivos JavaScript frequentemente contêm endpoints de API, chaves de acesso e funcionalidades ocultas que não aparecem na interface.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 45min | ⭐⭐⭐ Avançado | `LinkFinder, SecretFinder, katana` |

</div>

---

## 🎓 Por que Analisar JavaScript?

Sites modernos usam JavaScript para carregar conteúdo dinamicamente. Isso significa:
- **Endpoints de API** estão no código-fonte JS
- **Chaves de API** podem estar hardcoded
- **Funções de admin** podem estar ocultas na interface
- **Parâmetros de autenticação** podem estar expostos

**Exemplo real:**
```javascript
// No JavaScript, você pode encontrar:
const API_URL = "https://api.evilcorp.com/v2/internal/users";
const ADMIN_TOKEN = "sk_live_abc123def456";
const DEBUG_ENDPOINT = "/admin/debug/info";
```

---

## 🎯 Quando usar Análise de JavaScript

- O site usa muitos arquivos JS (Single Page Application)
- Quer encontrar endpoints de API para fuzzing
- Procura chaves de API ou credenciais hardcoded
- Está fazendo reconhecimento de aplicações web modernas

---

## 🛠️ Como Análise de JavaScript te ajuda

### 1. LinkFinder — Extrair Endpoints de JavaScript

O LinkFinder extrai URLs, endpoints e parâmetros de arquivos JavaScript.

**Instalação:**

```bash
git clone https://github.com/GerbenJavorek/LinkFinder.git
cd LinkFinder
pip3 install -r requirements.txt
```

**Uso básico:**

```bash
# Extrair endpoints de um arquivo JS
python3 linkfinder.py -i https://evilcorp.com/static/app.js -o cli

# Resultado esperado:
Endpoint: /api/v1/users
Endpoint: /api/v1/users/{id}
Endpoint: /api/v2/admin/config
Endpoint: /auth/login
Endpoint: /auth/callback
Endpoint: /upload/file
Parameter: ?token=
Parameter: ?user_id=
Parameter: ?redirect=

# Extrair de uma página inteira (encontra todos os JS links)
python3 linkfinder.py -i https://evilcorp.com -d -o cli

# Resultado:
[+] Found 15 JavaScript files:
    https://evilcorp.com/static/app.js
    https://evilcorp.com/static/vendor.js
    https://evilcorp.com/static/admin.js
    ...
[+] Found 47 endpoints across all files
```

**Flags explicadas:**
- `-i` — URL de entrada (página ou arquivo JS)
- `-d` — modo deep (busca em todos os JS da página)
- `-o cli` — saída no terminal (alternativa: `-o html` para relatório)

---

### 2. SecretFinder — Encontrar Chaves e Credenciais

O SecretFinder busca padrões de secrets (chaves de API, tokens, senhas) em JavaScript.

**Instalação:**

```bash
git clone https://github.com/m4ll0k/SecretFinder.git
cd SecretFinder
pip3 install -r requirements.txt
```

**Uso básico:**

```bash
# Buscar secrets em um arquivo JS
python3 SecretFinder.py -i https://evilcorp.com/static/app.js -e

# Resultado esperado:
[+] AWS Access Key: AKIAIOSFODNN7EXAMPLE
[+] AWS Secret Key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
[+] API Token: sk_live_abc123def456ghi789
[+] Firebase Config: AIzaSyD-example1234567890
[+] GitHub Token: ghp_abc123def456ghi789
[+] Private IP: 192.168.1.100
```

**Flags explicadas:**
- `-i` — URL ou caminho do arquivo JS
- `-e` — busca por patterns expandidos (mais false positives, mais findings)
- `-r` — busca por regex customizado

---

### 3. katana — Crawling Automático de JavaScript

O katana (ProjectDiscovery) faz crawling e encontra automaticamente todos os arquivos JS.

**Instalação:**

```bash
go install github.com/projectdiscovery/katana/cmd/katana@latest
```

**Uso básico:**

```bash
# Crawl e encontrar todos os JS files
katana -u https://evilcorp.com -jc -d 3

# Resultado esperado:
https://evilcorp.com/static/app.js
https://evilcorp.com/static/chunk-1.js
https://evilcorp.com/static/chunk-2.js
https://evilcorp.com/api/config.js
https://evilcorp.com/admin/bundle.js

# Extrair endpoints de JS encontrados
katana -u https://evilcorp.com -jc -d 3 -ef css,png,jpg | grep "\.js$"

# Buscar apenas JS e extrair URLs
katana -u https://evilcorp.com -jc -d 3 -f url | grep "\.js$" | \
    xargs -I {} python3 linkfinder.py -i {} -o cli
```

**Flags explicadas:**
- `-u` — URL inicial
- `-jc` — JavaScript crawling (executa JS para encontrar endpoints dinâmicos)
- `-d 3` — profundidade máxima de 3 níveis
- `-ef css,png,jpg` — exclui estes tipos de arquivo
- `-f url` — formato de saída: URLs

---

### 4. Busca Manual de Secrets com grep

```bash
# Baixar todos os JS e buscar patterns
curl -s https://evilcorp.com/static/app.js | grep -iE "(api_key|secret|token|password|aws|firebase)" | head -20

# Resultado esperado:
const API_KEY = "abc123def456";
const AWS_ACCESS = "AKIAIOSFODNN7EXAMPLE";
// TODO: Remove before production
const DEBUG_TOKEN = "debug123";
```

---

## ➡️ Depois de usar Análise de JavaScript — Próximos passos

1. **Teste os endpoints encontrados** com curl para ver se existem
2. **Fuzz os parâmetros** com ffuf para encontrar vulnerabilidades
3. **Use as chaves encontradas** (com cautela) para acessar APIs
4. **Próximo arquivo:** [12-cors-e-api.md](12-cors-e-api.md) —Teste CORS e descubra APIs

---

## ⚠️ Erros Comuns

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Não usar -jc no katana | Perde endpoints dinâmicos carregados via JS | Sempre use `-jc` para SPAs |
| Confiar em todos os "secrets" | Muitos false positives (ex: `const example = "secret"`) | Valide cada secret manualmente |
| Analisar apenas JS principals | Perde chunks e bundles | Use `katana` para encontrar TODOS os JS |

---

## 📖 Referências

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| LinkFinder | Ferramenta | [github.com/GerbenJavorek/LinkFinder](https://github.com/GerbenJavorek/LinkFinder) |
| SecretFinder | Ferramenta | [github.com/m4ll0k/SecretFinder](https://github.com/m4ll0k/SecretFinder) |
| katana | Ferramenta | [github.com/projectdiscovery/katana](https://github.com/projectdiscovery/katana) |
| JS Deep Dive | Guia | [book.hacktricks.wiki](https://book.hacktricks.wiki/) |

---

<div align="center">

**⬅️ [10-osint-pessoas.md](10-osint-pessoas.md)** | **[12-cors-e-api.md](12-cors-e-api.md) ➡️**

</div>
