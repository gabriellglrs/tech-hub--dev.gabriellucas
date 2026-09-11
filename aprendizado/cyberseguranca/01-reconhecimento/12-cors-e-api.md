# 🌐 12. CORS e Descoberta de APIs — As Portas dos Trás da Web

> CORS mal configurado permite que sites maliciosos acessem dados de usuários. APIs expostas são a nova superfície de ataque.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 45min | ⭐⭐⭐ Avançado | `curl, ffuf, nuclei` |

</div>

---

## 🎓 O que é CORS?

CORS (Cross-Origin Resource Sharing) é um mecanismo de segurança que controla quais domínios podem acessar recursos de outro domínio. Quando mal configurado, pode permitir:

- **Leitura de dados** de usuários autenticados
- **Roubo de tokens** de sessão
- **Acesso a APIs internas** de empresas

**Exemplo de CORS vulnerável:**
```
Requisição de: https://site-malicioso.com
Para: https://api.evilcorp.com/users

Header de resposta:
Access-Control-Allow-Origin: https://site-malicioso.com
Access-Control-Allow-Credentials: true
```

---

## 🎯 Quando usar CORS e Descoberta de APIs

- Quer testar se um site permite acesso cross-origin indevido
- Precisa encontrar endpoints de API que não estão documentados
- Está fazendo pentest de aplicações web
- Quer descobrir APIs internas de empresas

---

## 🛠️ Como CORS e API te ajudam

### 1. curl — Teste Básico de CORS

```bash
# Testar se o site reflete qualquer origem (VULNERÁVEL)
curl -s -I -H "Origin: https://evil.com" https://api.evilcorp.com/users

# Resultado esperado (VULNERÁVEL):
Access-Control-Allow-Origin: https://evil.com
Access-Control-Allow-Credentials: true

# Resultado esperado (SEGURO):
Access-Control-Allow-Origin: https://evilcorp.com
```

**Teste completo:**

```bash
# Script de teste CORS completo
DOMAIN="api.evilcorp.com"

echo "=== Teste 1: Origem arbitrária ==="
curl -s -I -H "Origin: https://evil.com" "https://$DOMAIN/" | grep -i "access-control"

echo "=== Teste 2: Subdomínio fake ==="
curl -s -I -H "Origin: https://evilcorp.evil.com" "https://$DOMAIN/" | grep -i "access-control"

echo "=== Teste 3: Null origin ==="
curl -s -I -H "Origin: null" "https://$DOMAIN/" | grep -i "access-control"

echo "=== Teste 4: HTTP (não HTTPS) ==="
curl -s -I -H "Origin: http://evilcorp.com" "https://$DOMAIN/" | grep -i "access-control"
```

**Resultado esperado (VULNERÁVEL):**

```
=== Teste 1: Origem arbitrária ===
Access-Control-Allow-Origin: https://evil.com
Access-Control-Allow-Credentials: true
=== Teste 2: Subdomínio fake ===
Access-Control-Allow-Origin: https://evilcorp.evil.com
Access-Control-Allow-Credentials: true
=== Teste 3: Null origin ===
Access-Control-Allow-Origin: null
Access-Control-Allow-Credentials: true
=== Teste 4: HTTP (não HTTPS) ===
Access-Control-Allow-Origin: http://evilcorp.com
```

---

### 2. Nuclei — Templates de CORS

O Nuclei possui templates específicos para detectar CORS misconfiguration.

```bash
# Buscar vulnerabilidades de CORS
nuclei -u https://api.evilcorp.com -t http/misconfigurations/cors/

# Resultado esperado:
[cors-misconfiguration] [high] https://api.evilcorp.com
[cors-misconfiguration] [medium] https://api.evilcorp.com/users
```

---

### 3. Descoberta de APIs

#### 404 Link Finder — Encontrar endpoints via 404

```bash
# Se o site retorna 404 para endpoints não existentes, use:
ffuf -u https://evilcorp.com/FUZZ -w /usr/share/seclists/Discovery/Web-Content/api/api-endpoints.txt -mc 200,201,202,204

# Resultado esperado:
/api/v1          [Status: 200, Size: 1234]
/api/v2          [Status: 200, Size: 5678]
/api/users       [Status: 200, Size: 9012]
/api/admin       [Status: 403, Size: 345]
```

#### Swagger/OpenAPI Discovery

```bash
# Procurar documentação de API
for path in swagger.json openapi.json api-docs swagger-ui swagger/docs/v1; do
    status=$(curl -s -o /dev/null -w "%{http_code}" "https://evilcorp.com/$path")
    echo "$status https://evilcorp.com/$path"
done

# Resultado esperado:
200 https://evilcorp.com/swagger.json     ← DOCUMENTAÇÃO EXPOSTA!
200 https://evilcorp.com/api-docs         ← DOCUMENTAÇÃO EXPOSTA!
404 https://evilcorp.com/swagger-ui
404 https://evilcorp.com/openapi.json
```

#### API Endpoint Enumeration

```bash
# Enumerar endpoints de API comuns
for endpoint in /api/v1 /api/v2 /graphql /api/internal /api/admin; do
    status=$(curl -s -o /dev/null -w "%{http_code}" "https://evilcorp.com$endpoint")
    echo "$status https://evilcorp.com$endpoint"
done
```

---

## ➡️ Depois de usar CORS e API — Próximos passos

1. **Valide cada finding** com PoC (Proof of Concept)
2. **Documente o impacto** (roubo de dados, bypass de autenticação)
3. **Teste as APIs encontradas** com fuzzing (SQLi, XSS, IDOR)
4. **Parabéns!** Você completou o módulo de Reconhecimento! 🎉
5. **Próximo módulo:** [Módulo 02: Web & Aplicações](../02-web-aplicacoes/)

---

## ⚠️ Erros Comuns

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Não testar null origin | Pode perder vulnerabilidade crítica | Sempre teste com `Origin: null` |
| Confiar apenas em Nuclei | Pode perder APIs não documentadas | Use ffuf e swagger discovery também |
| Não verificar credenciais | Falso negativo: CORS aceita qualquer origem mas não envia credenciais | Sempre teste com `Access-Control-Allow-Credentials` |

---

## 📖 Referências

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| OWASP CORS | Guia | [owasp.org](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/11-Client-side_Testing/07-Testing_Cross_Origin_Resource_Sharing) |
| Nuclei CORS Templates | Templates | [github.com/projectdiscovery/nuclei-templates](https://github.com/projectdiscovery/nuclei-templates) |
| API Discovery | Guia | [book.hacktricks.wiki](https://book.hacktricks.wiki/) |
| PortSwigger API | Lab | [portswigger.net](https://portswigger.net/web-security) |

---

<div align="center">

**⬅️ [11-javascript-analysis.md](11-javascript-analysis.md)** | **Parabéns! Módulo 01 Completo! 🎉 ➡️ [Módulo 02: Web](../02-web-aplicacoes/)**

</div>
