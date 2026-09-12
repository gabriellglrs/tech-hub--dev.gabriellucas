# Fase 1: Configuração do Burp Suite e Proxy Intercept

**Tempo estimado:** 20-30 minutos
**Objetivo:** Configurar o Burp Suite para ser o centro de TODA a operação — capturar, analisar e modificar todo o tráfego HTTP/HTTPS entre seu browser e o alvo.
**Por quê:** Burp Suite é a ferramenta mais importante deste módulo. Sem ele configurado corretamente, você não consegue ver nem modificar requests. Uma configuração errada pode fazer você perder vulnerabilidades inteiras.

---

### Passo 1.1 — Iniciar o Burp Suite

**O que você vai fazer:** Abrir o Burp Community Edition e criar um projeto temporário.

```bash
burpsuite &
```

**Ações no Burp (janela GUI):**
1. Na tela de boas-vindas, selecione **Temporary Project** → clique **Next**
2. Selecione **Use Burp defaults** → clique **Start Burp**
3. Aguarde o Burp carregar (pode levar 30-60 segundos)

**✅ Output esperado:** A janela principal do Burp Suite aparece com abas: Dashboard, Target, Proxy, Intruder, Repeater, etc.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `burpsuite: command not found` | Não instalado | `sudo apt install burpsuite` |
| Erro de Java | Java incompatível | `sudo apt install openjdk-17-jdk` |
| Burp trava na inicialização | Memória insuficiente | Aumente memória: edite `/usr/bin/burpsuite` e adicione `-Xmx4g` |
| Tela preta | Problema de display | Tente: `export DISPLAY=:0` antes de abrir |

---

### Passo 1.2 — Configurar Proxy Listener

**O que você vai fazer:** Verificar que o Burp está escutando tráfego na porta 8080.

1. No Burp, vá para **Proxy → Options** (ou **Proxy → Listeners**)
2. Verifique que existe um listener ativo:

**✅ Output esperado:**
```
Running    127.0.0.1:8080    HTTP
```

**O que procurar:**
- **Running** → listener está ativo
- **127.0.0.1:8080** → endereço e porta corretos
- **HTTP** → protocolo correto

**Se não existir listener:**
1. Clique **Add**
2. Bind to port: `8080`
3. Bind to address: `Loopback only`
4. Protocol: `HTTP`
5. Clique **OK**

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Porta 8080 já em uso | Outro processo usando a porta | `sudo kill $(sudo lsof -t -i:8080)` e reinicie Burp |
| Listener não inicia | Conflito de configuração | Delete todos os listeners e crie um novo |

---

### Passo 1.3 — Configurar Browser para Usar o Proxy

**O que você vai fazer:** Redirecionar TODO o tráfego do Firefox pelo proxy do Burp.

**Se você já configurou o FoxyProxy no Passo 0.3 do checklist, ative o perfil "Burp" e pule para o Passo 1.4.**

**Se NÃO configurou ainda:**

**Opção A — FoxyProxy (Recomendado):**
1. No Firefox, clique no ícone do FoxyProxy
2. Selecione o perfil **Burp**
3. O ícone ficará AZUL → proxy ativo

**Opção B — Configuração Manual:**
1. Firefox → **Settings** → **Network Settings** → **Settings...**
2. Selecione **Manual proxy configuration**
3. HTTP Proxy: `127.0.0.1`, Port: `8080`
4. Marque: **✓ Use this proxy server for all protocols**
5. Clique **OK**

**✅ Teste de confirmação:**
```bash
curl -x http://127.0.0.1:8080 http://httpbin.org/ip
```

**Output esperado:**
```json
{
  "origin": "127.0.0.1"
}
```

Se o `origin` mostrar seu IP público → o proxy NÃO está funcionando.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `curl: (7) Connection refused` | Burp não está rodando | Abra o Burp Suite |
| Origin mostra IP público | Proxy não configurado no browser | Verifique FoxyProxy ou configuração manual |
| Funciona no curl mas não no browser | CA Certificate não instalado | Veja Passo 1.4 |

---

### Passo 1.4 — Instalar CA Certificate do Burp

**O que você vai fazer:** Instalar o certificado raiz do Burp para que ele possa interceptar tráfego HTTPS sem erros de certificate.

**Passo 1.4.1 — Baixar o certificate:**
1. Com proxy ativado, acesse `http://burp` no Firefox
2. Clique em **CA Certificate**
3. Salve o arquivo `cacert.der` na pasta Downloads

**Passo 1.4.2 — Importar no Firefox:**
1. No Firefox, vá → **Settings → Privacy & Security → Certificates → View Certificates**
2. Na aba **Authorities**, clique **Import...**
3. Selecione o arquivo `cacert.der`
4. Marque: **✓ Trust to identify websites**
5. Clique **OK**

**✅ Teste de confirmação:**
Acesse `https://httpsbin.org` no Firefox. Se não aparecer aviso de certificate → está funcionando.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `SSL_ERROR_RX_RECORD_TOO_LONG` | CA não instalado | Repita o import |
| Aviso "Not secure" | CA não é confiável | Verifique se marcou "Trust to identify websites" |
| Firefox bloqueia | Enhanced Tracking Protection | Desative temporariamente para `http://burp` |

---

### Passo 1.5 — Testar Intercept

**O que você vai fazer:** Confirmar que o Burp está capturando requests HTTP.

1. No Burp, vá para **Proxy → Intercept**
2. Garanta que **Intercept is on** está AZUL (clique se necessário)
3. No Firefox, acesse `http://httpbin.org/get`

**✅ Output esperado no Burp Intercept:**
```
GET /get HTTP/1.1
Host: httpbin.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7
Accept-Encoding: gzip, deflate
Connection: close
Upgrade-Insecure-Requests: 1
```

**O que procurar:**
- **GET /get** → o request está sendo capturado
- **Host: httpbin.org** → o host correto aparece
- **User-Agent** → mostra seu browser

**Ação:** Clique em **Forward** para liberar o request e ver a resposta.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Request não aparece | Intercept está off | Clique em "Intercept is off" para ativar |
| Request não aparece | Proxy não configurado | Verifique FoxyProxy (Passo 1.3) |
| Muitos requests de CDN | Scope muito amplo | Configure Scope (Passo 1.6) |

---

### Passo 1.6 — Configurar Escopo (Scope)

**O que você vai fazer:** Definir quais URLs o Burp deve capturar e quais ignorar. Sem isso, você verá tráfego de Google Analytics, CDN e outros sites irrelevantes.

1. No Burp, vá para **Target → Scope**
2. Na seção **Include in scope**, clique **Add**
3. Configure:
   - Protocol: `https?://`
   - Host or IP: `.*target\.com` (regex para capturar todos os subdomínios)
   - Port: `.*`
   - File: `.*`

**Exemplo para alvo `target.com`:**
```
https?://.*target\.com:.*
```

**O que procurar:**
- **`https?://`** → captura HTTP e HTTPS
- **`.*target\.com`** → regex que captura `target.com`, `api.target.com`, `admin.target.com`
- **`.*`** → qualquer porta e arquivo

**⚠️ IMPORTANTE:** Quando o Burp perguntar "Out-of-scope items have been seen. Do you want to add them to scope?", selecione **Yes** para todos os hosts do alvo.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Scope não filtra | Regex incorreto | Teste o regex em https://regex101.com |
| Captura sites demais | Regex muito amplo | Seja mais específico: `https?://target\.com` |
| Não captura subdomínios | Regex não tem `.*` | Adicione `.*` antes do domínio |

---

### Passo 1.7 — Configurar Filtro do HTTP History

**O que você vai fazer:** Filtrar o HTTP History para mostrar apenas requests do alvo definido no Scope.

1. No Burp, vá para **Proxy → HTTP history**
2. Clique no ícone de filtro (barra de pesquisa)
3. Na seção **Filter by MIME type**, marque **HTML, JSON, XML** (para ver respostas relevantes)
4. Na seção **Filter by HTTP status**, desmarque **4xx** e **5xx** (para ver apenas successes)
5. Na seção **Show only in-scope items**, marque **✓**

**✅ Output esperado:** A aba HTTP history agora mostra APENAS requests para o alvo definido no Scope.

---

### Passo 1.8 — Habilitar WebSockets History

**O que você vai fazer:** Verificar se o Burp está capturando conexões WebSocket (usadas por apps modernos).

1. No Burp, vá para **Proxy → WebSockets history**
2. Verifique se está vazio (nenhuma conexão WebSocket ainda) — isso é normal
3. Quando você navegar pelo site, conexões WebSocket aparecerão aqui

---

### Passo 1.9 — Configurar Session Handling (se necessário)

**O que você vai fazer:** Configurar o Burp para manter sessão automaticamente quando o alvo requer login.

1. No Burp, vá para **Project Options → Sessions**
2. Na seção **Session Handling Rules**, clique **Add**
3. Em **Rule Actions**, clique **Add** → **Get a token from existing cookie jar**
4. Configure:
   - Cookie jar: crie um novo
   - URL: `https://target.com`
5. Clique **OK**

**Quando usar:** Se o alvo requer login e você precisa testar endpoints autenticados.

---

### Checklist de Setup do Burp

| # | Item | Status | ☑ |
|---|------|--------|:---:|
| 1 | Burp Suite aberto e funcionando | Janela principal visível | [ ] |
| 2 | Proxy Listener ativo em 127.0.0.1:8080 | Proxy → Options mostra "Running" | [ ] |
| 3 | Browser configurado com proxy | curl retorna origin 127.0.0.1 | [ ] |
| 4 | CA Certificate instalado e confiável | https://httpsbin.org não dá erro SSL | [ ] |
| 5 | Intercept testado | Request aparece no Burp Intercept | [ ] |
| 6 | Scope definido no Target | Include in scope mostra regex do alvo | [ ] |
| 7 | HTTP history filtrando items in-scope | HTTP history mostra apenas alvo | [ ] |
| 8 | WebSockets history habilitado | Aba WebSockets está visível | [ ] |

### ✅ Sinal de sucesso:
- Request HTTP aparece no Burp Intercept quando você navega pelo site
- HTTP history mostra apenas requests do alvo
- Não há erros de SSL nos sites do alvo

### ❌ Se falhou:
- **NÃO avance** — Burp mal configurado = teste inútil
- A maioria dos problemas se resolve reinstalando CA Certificate ou reconfigurando o proxy
- Se nada funciona, reinicie Burp Suite + Firefox

### 🔗 O que este setup alimenta nas próximas fases:
| Item do Setup | Usado na Fase | Para quê |
|---------------|---------------|----------|
| Proxy + Intercept | Fase 2 (Recon) | Capturar requests enquanto navega |
| HTTP history | Fase 2, 3, 4, 5, 6, 7 | Analisar requests e responses |
| Scope | TODAS as fases | Filtrar tráfego irrelevante |
| Session Handling | Fase 5 (Auth) | Manter sessão autenticada |
| WebSockets | Fase 4 (Cliente) | Analisar conexões WebSocket |

**Se completou tudo → Avance para Fase 2** (`02-recon-api.md`)

---
