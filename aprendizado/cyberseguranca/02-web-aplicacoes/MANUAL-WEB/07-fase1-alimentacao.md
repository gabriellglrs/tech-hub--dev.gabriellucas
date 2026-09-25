## FASE 1 — Alimentação (importar o Módulo 01)

**Tempo estimado:** 20-40 minutos
**Objetivo:** Transformar o recon que você já fez (Módulo 01) em listas de alvos web prontas para testar — escopo, endpoints, parâmetros, fingerprint e secrets.
**Por quê:** Testar web às cegas = repetir fuzzing que já foi feito, ignorar WAF e perder secrets que já eram achado crítico. Os dados já existem — aqui você só organiza o que o recon produziu.

---

### Passo 1.1 — Verificar que os dados do Módulo 01 existem

**O que você vai fazer:** Confirmar que o recon do Módulo 01 foi feito neste alvo. Sem ele, não há Fase 1.

```bash
# Entrar na pasta do alvo
cd ~/recon/targets/evilcorp

# Ver a estrutura completa (01 a 07 deve existir)
ls -la

# Verificar os arquivos MÍNIMOS para o teste web
ls -la 02-enum/vivos-filtrados.txt 04-discovery/urls-com-parametros.txt 04-discovery/gobuster-basico.txt
```

**✅ Output esperado:**
```
02-enum/vivos-filtrados.txt          ← URLs vivas com status HTTP
04-discovery/urls-com-parametros.txt ← URLs com parâmetros (candidatas a SQLi/XSS)
04-discovery/gobuster-basico.txt     ← diretórios já descobertos
```

**O que procurar:** Se os 3 arquivos existem e não estão vazios, você pode avançar.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `No such file or directory` | Recon não rodou neste alvo | Volte ao Módulo 01 e complete as fases 2 e 4 |
| Arquivo vazio (0 bytes) | Scan falhou | Rode de novo: `ffuf -u https://alvo/FUZZ -w common.txt -o 04-discovery/ffuf-dirs.json` |
| Pasta `targets/` não existe | Você nunca fez recon | `mkdir -p ~/recon/targets/evilcorp` e comece pelo Módulo 01 |

---

### Passo 1.2 — Montar o escopo web

**O que você vai fazer:** Consolidar as URLs vivas do recon na lista oficial de alvos deste teste — é ela que vai para o escopo do Burp e guia todas as fases.

```bash
# Criar a pasta da fase
mkdir -p 08-alimentacao

# URLs vivas do recon (só HTTP/HTTPS)
grep -E "https?://" 02-enum/vivos-filtrados.txt | sort -u > 08-alimentacao/escopo-web.txt

# Documentar o escopo IN/OUT (obrigatório — é sua prova de autorização)
cat > 08-alimentacao/escopo-web.md << 'EOF'
# Escopo do Teste Web — evilcorp.com
## IN (autorizado)
- https://evilcorp.com
- https://admin.evilcorp.com
- https://api.evilcorp.com
## FORA DO ESCOPO
- https://cdn.thirdparty.com (CDN de terceiros)
- Qualquer coisa fora de *.evilcorp.com
## Período: 2026-09-20 a 2026-09-27
## Contato de emergência: security@evilcorp.com
EOF

# Ver
cat 08-alimentacao/escopo-web.txt
```

**✅ Output esperado (escopo-web.txt):**
```
https://evilcorp.com
https://admin.evilcorp.com
https://api.evilcorp.com
```

**O que procurar:**
- **admin/api subdomains** → alvos de maior valor (Fases 3-5)
- **URLs fora de `*.evilcorp.com`** → REMOVA (CDN, terceriros = fora do escopo)

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Output vazio | vivos-filtrados sem URLs | Rode a Fase 2 do Módulo 01 (enumeração) primeiro |
| Muitas URLs (>50) | Recon pegou CDN/terceiros | Filtre manualmente mantendo só o domínio do alvo |

---

### Passo 1.3 — Importar endpoints e parâmetros (do Módulo 01)

**O que você vai fazer:** Reunir TODOS os pontos de entrada já descobertos — endpoints JS e URLs com parâmetros — que as Fases 2 e 3 vão testar.

```bash
# Endpoints extraídos de JavaScript no recon (LinkFinder/katana)
cp 04-discovery/js-endpoints.txt 08-alimentacao/endpoints-web.txt 2>/dev/null

# URLs com parâmetros (candidatas a injeção)
cp 04-discovery/urls-com-parametros.txt 08-alimentacao/params-web.txt 2>/dev/null

# Complementar endpoints com as URLs descobertas no wayback/discovery
grep -E "https?://" 01-intel/todas-urls.txt 2>/dev/null | sort -u >> 08-alimentacao/endpoints-web.txt
sort -u 08-alimentacao/endpoints-web.txt -o 08-alimentacao/endpoints-web.txt

# Ver o que temos
wc -l 08-alimentacao/endpoints-web.txt 08-alimentacao/params-web.txt
head -10 08-alimentacao/params-web.txt
```

**✅ Output esperado (params-web.txt):**
```
https://evilcorp.com/busca?q=teste
https://evilcorp.com/produtos?id=42&page=2
https://evilcorp.com/download?file=relatorio.pdf
https://evilcorp.com/api/users?id=1
```

**O que procurar:**
- **`?id=`** → candidato direto a SQLi (Fase 3)
- **`?q=` / `?search=`** → candidato a XSS (Fase 4)
- **`?url=` / `?file=` / `?path=`** → candidato a SSRF/LFI (Fase 5)
- **`/api/`** → endpoints REST para testar métodos e auth (Fases 2 e 4)

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Ambos vazios | Discovery não rodou no Módulo 01 | Rode a Fase 4 do Módulo 01 ou siga — a Fase 2 refaz o mapeamento |
| Poucos parâmetros | Só URLs estáticas | A Fase 2 vai descobrir mais com Burp + ffuf |

---

### Passo 1.4 — Importar diretórios já descobertos (do Módulo 01)

**O que você vai fazer:** Carregar o fuzzing já feito no recon para NÃO repetir — e testar esses caminhos diretamente.

```bash
# Diretórios do gobuster (só os caminhos)
awk '{print $2}' 04-discovery/gobuster-basico.txt 2>/dev/null | sort -u > 08-alimentacao/dirs-web.txt

# Complementar com o ffuf de extensões do recon (arquivos .env, .bak...)
grep -oE '"url"[^,]*' 04-discovery/ffuf-extensoes.json 2>/dev/null | cut -d'"' -f4 >> 08-alimentacao/dirs-web.txt
sort -u 08-alimentacao/dirs-web.txt -o 08-alimentacao/dirs-web.txt

cat 08-alimentacao/dirs-web.txt
```

**✅ Output esperado (dirs-web.txt):**
```
/admin
/admin/login
/api
/backup
/login
/robots.txt
/wp-admin
/wp-login.php
/.env
/config.bak
```

**O que procurar:**
- **`/admin`, `/backup`, `/.env`** → prioridade máxima (Fase 2 testa esses caminhos direto)
- **Arquivos `.env`/`.bak`** → se ainda respondem com conteúdo = achado CRÍTICO imediato

---

### Passo 1.5 — Importar fingerprint, WAF e headers (do Módulo 01)

**O que você vai fazer:** Carregar quem é o alvo (tecnologias) e se ele tem proteção (WAF) — isso decide payloads e velocidade em TODAS as fases.

```bash
# Tecnologias detectadas no recon
cat 03-fingerprint/whatweb-principal.txt 03-fingerprint/httpx-tech.txt 2>/dev/null > 08-alimentacao/fingerprint-web.txt

# WAF detectado (se houver)
cat 03-fingerprint/waf-principal.txt 2>/dev/null > 08-alimentacao/waf-web.txt

# Headers de segurança do alvo (base para a Fase 4)
cp 02-enum/headers.txt 08-alimentacao/headers-web.txt 2>/dev/null

# Ver
cat 08-alimentacao/fingerprint-web.txt
echo "=== WAF ==="; cat 08-alimentacao/waf-web.txt
```

**✅ Output esperado (fingerprint-web.txt):**
```
http://evilcorp.com [200 OK] Apache[2.4.41], PHP[7.4.3], WordPress[6.4.2], ...
```

**O que procurar:**
- **WAF presente (Cloudflare/AWS WAF)** → REDUZA threads em todas as ferramentas (ver 06-opsec.md)
- **WordPress** → WPScan na Fase 2
- **PHP/Python/Java** → define payloads de SSTI e injeção nas Fases 3 e 5
- **Headers ausentes (CSP, X-Frame-Options)** → achados da Fase 4

---

### Passo 1.6 — Validar secrets expostos (achado CRÍTICO imediato)

**O que você vai fazer:** Se o recon achou API keys/tokens em JS, isso já é vulnerabilidade — sem precisar de nenhum teste adicional.

```bash
# Ver secrets encontrados no JS
cat 04-discovery/js-secrets.txt 2>/dev/null | tee 08-alimentacao/secrets-web.txt

# Se tiver conteúdo, documente IMEDIATAMENTE como achado crítico
if [ -s 08-alimentacao/secrets-web.txt ]; then
  echo "ACHADO CRÍTICO em $(date): secrets em JS — ver 08-alimentacao/secrets-web.txt" \
    >> 13-validacao/achados-imediatos.md 2>/dev/null || \
  { mkdir -p 13-validacao && echo "ACHADO CRÍTICO em $(date): secrets em JS" > 13-validacao/achados-imediatos.md; }
fi
```

**✅ Output esperado:**
```
api_key: "sk_live_abc123"
Authorization: Bearer eyJhbGciOi...
```

**O que procurar:**
- **API key de pagamento/nuvem** → CRÍTICO — documente, NÃO explore além do escopo
- **Token JWT hardcoded** → irá para análise na Fase 4

**❌ Se der errado:** arquivo vazio = normal (nenhum secret no recon). Siga em frente.

---

### Passo 1.7 — Conferir conectividade final

**O que você vai fazer:** Confirmar que todas as URLs do escopo respondem antes de começar a testar.

```bash
while read url; do
  status=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url")
  echo "$url → HTTP $status"
done < 08-alimentacao/escopo-web.txt
```

**✅ Output esperado:**
```
https://evilcorp.com → HTTP 200
https://admin.evilcorp.com → HTTP 403
https://api.evilcorp.com → HTTP 200
```

**O que procurar:**
- **200** → acessível, teste normalmente
- **403** → existe mas bloqueado (candidato a bypass na Fase 4)
- **000/timeout** → URL morta, remova do escopo

---

### Checklist da Fase 1

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Dados do Módulo 01 verificados | `vivos-filtrados.txt`, `urls-com-parametros.txt`, `gobuster-basico.txt` | [ ] |
| 2 | Escopo web montado + documentado | `08-alimentacao/escopo-web.txt` e `escopo-web.md` | [ ] |
| 3 | Endpoints e parâmetros importados | `08-alimentacao/endpoints-web.txt`, `params-web.txt` | [ ] |
| 4 | Diretórios do recon importados | `08-alimentacao/dirs-web.txt` | [ ] |
| 5 | Fingerprint/WAF/headers importados | `08-alimentacao/fingerprint-web.txt`, `waf-web.txt`, `headers-web.txt` | [ ] |
| 6 | Secrets validados (se houver) | `08-alimentacao/secrets-web.txt` | [ ] |
| 7 | Conectividade confirmada | URLs respondendo HTTP | [ ] |

### 📁 Sua pasta deve estar assim ao final da Fase 1:

```
08-alimentacao/
├── escopo-web.md        ← URLs IN/OUT + período (prova de autorização)
├── escopo-web.txt       ← URLs vivas do alvo (entra no scope do Burp)
├── endpoints-web.txt    ← endpoints JS/URLs (Fases 2, 3)
├── params-web.txt       ← URLs com parâmetros (Fase 3)
├── dirs-web.txt         ← diretórios do recon — NÃO refaça o fuzzing (Fase 2)
├── fingerprint-web.txt  ← tecnologias (decide payloads — Fases 3 e 5)
├── waf-web.txt          ← WAF detectado (define velocidade — todas as fases)
├── headers-web.txt      ← headers de segurança (Fase 4)
└── secrets-web.txt      ← achado CRÍTICO imediato (relatório)
```

### ✅ Sinal de sucesso:
- `escopo-web.txt` tem pelo menos **1 URL viva**
- `params-web.txt` tem pelo menos **1 parâmetro** OU a Fase 2 vai descobrir
- Você sabe **se tem WAF** (sim/não) e **qual stack** (PHP, WordPress...)
- Escopo `escopo-web.md` documentado com período e contato

### ❌ Se falhou:
- Sem dados do Módulo 01 → volte ao recon. Este manual não funciona sem recon.
- Sem params → normal; a Fase 2 mapeia a aplicação com Burp antes de testar.
- Sem WAF detectado → não significa que não exista; monitore sinais (403/429) durante os testes.

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 1 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `escopo-web.txt` + `escopo-web.md` | Fase 2 (scope Burp) e todas | O que PODE ser testado |
| `endpoints-web.txt` | Fases 2 e 3 | Alvos de teste direto no Repeater |
| `params-web.txt` | Fase 3 | Candidatos a SQLi/XSS/SSRF |
| `dirs-web.txt` | Fase 2 | Testar caminhos sem refuzzar |
| `fingerprint-web.txt` | Fases 3 e 5 | Escolher payloads (PHP vs Python vs Java vs WP) |
| `waf-web.txt` | Todas | Threads/delay de cada ferramenta |
| `headers-web.txt` | Fase 4 | Detectar headers de segurança ausentes |
| `secrets-web.txt` | Fase 7 | Achado crítico para o relatório |

**Se completou tudo → Avance para [Fase 2 — Descoberta e Superfície de Ataque](08-fase2-descoberta.md)**
