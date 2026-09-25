## Setup — Burp Suite, Proxy e Ferramentas CLI

> **Antes de testar QUALQUER coisa, configure o Burp e as ferramentas.** Sem proxy capturando tráfego, você está cego; sem ferramentas instaladas, a Fase 2 trava no primeiro comando.

### Por que isso importa?

O Burp Suite é o centro de TODA a operação web: ele captura, analisa e modifica cada request entre seu browser e o alvo. Uma configuração errada faz você **perder vulnerabilidades inteiras** sem perceber (tráfego que nem passou pelo proxy).

---

### Passo 1 — VPN (OBRIGATÓRIO)

Mesmo setup do Módulo 01 — se já configurou, pule para o Passo 2.

```bash
# Instalar NordVPN (gratuito por 30 dias, depois R$25/mês)
# Acesse: https://nordvpn.com/download/linux/
wget https://downloads.nordcdn.com/apps/linux/install.sh
sh install.sh

# Conectar (deixe rodando durante TODOS os testes)
nordvpn connect

# Verificar se funciona
curl -s https://ifconfig.me
# Deve mostrar o IP da VPN, não o seu IP real
```

**Alternativas gratuitas:**
| VPN | Limite | Como usar |
|-----|--------|-----------|
| **ProtonVPN** | 10GB/mês | `sudo apt install protonvpn` |
| **Windscribe** | 10GB/mês | App no site oficial |
| **Mullvad** | 5€/mês (sem limite) | App no site oficial |

> **Atenção:** Em labs (TryHackMe, HackTheBox, PortSwigger) você conecta pela VPN DA PLATAFORMA — não use VPN comercial junto, vai conflitar.

---

### Passo 2 — Verificar Kali e Instalar Ferramentas CLI

```bash
# Sistema
lsb_release -a && uname -a

# Ferramentas principais (Kali traz quase todas)
sudo apt update
sudo apt install -y burpsuite sqlmap gobuster whatweb curl nikto wpscan seclists cewl

# Go-based (mais rápidas — ffuf, httpx, nuclei)
go install github.com/ffuf/ffuf/v2@latest
go install github.com/projectdiscovery/httpx/cmd/httpx@latest
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
export PATH=$PATH:~/go/bin   # adicione ao ~/.bashrc para persistir

# Nuclei: baixar templates (primeira vez)
nuclei -update-templates
```

**✅ Output esperado (verificação):**
```bash
for tool in burpsuite sqlmap ffuf gobuster httpx whatweb nuclei curl; do
  echo -n "$tool: "; which $tool 2>/dev/null || echo "❌ NÃO INSTALADO"
done
```
```
burpsuite: /usr/bin/burpsuite
sqlmap: /usr/bin/sqlmap
ffuf: /home/kali/go/bin/ffuf
gobuster: /usr/bin/gobuster
httpx: /home/kali/go/bin/httpx
whatweb: /usr/bin/whatweb
nuclei: /home/kali/go/bin/nuclei
curl: /usr/bin/curl
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `burpsuite: command not found` | Não instalado | `sudo apt install burpsuite` |
| Java não encontrado | Java ausente/incompatível | `sudo apt install openjdk-17-jdk` |
| `ffuf/nuclei: command not found` | Go bin fora do PATH | `export PATH=$PATH:~/go/bin` |
| `nuclei -update-templates` falha | Sem internet/GitHub bloqueado | `ping -c 3 github.com` e repita |
| Erro de repositório | Índice desatualizado | `sudo apt update` e tente de novo |

---

### Passo 3 — Iniciar o Burp Suite

```bash
burpsuite &
```

**Ações no Burp (janela GUI):**
1. Na tela de boas-vindas, selecione **Temporary Project** → **Next**
2. Selecione **Use Burp defaults** → **Start Burp**
3. Aguarde carregar (30-60 segundos)

**✅ Output esperado:** janela principal com abas Dashboard, Target, Proxy, Intruder, Repeater.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Burp trava na inicialização | Memória insuficiente | `burpsuite -Xmx4g` |
| Tela preta | Problema de display | `export DISPLAY=:0` antes de abrir |
| Porta 8080 em uso | Outro processo | `sudo kill $(sudo lsof -t -i:8080)` e reinicie |

---

### Passo 4 — Configurar Proxy Listener

1. No Burp: **Proxy → Options** (ou **Proxy → Listeners**)
2. Confirme o listener ativo:

**✅ Output esperado:**
```
Running    127.0.0.1:8080    HTTP
```

**Se não existir listener:** clique **Add** → porta `8080` → **Loopback only** → protocolo `HTTP` → **OK**.

---

### Passo 5 — Configurar o Browser (FoxyProxy)

**Opção A — FoxyProxy (Recomendado):**
1. Firefox → **Add-ons** → buscar "FoxyProxy" → instalar
2. **Options → Add New Proxy:** Title `Burp`, Type HTTP, IP `127.0.0.1`, Port `8080`
3. Ative o perfil **Burp** (ícone fica AZUL)

**Opção B — Manual:**
1. Firefox → **Settings → Network Settings**
2. **Manual proxy configuration:** HTTP Proxy `127.0.0.1`, Port `8080`
3. Marque **✓ Use this proxy server for all protocols**

**✅ Teste de confirmação:**
```bash
curl -x http://127.0.0.1:8080 http://httpbin.org/ip
```
```json
{
  "origin": "127.0.0.1"
}
```
Se o `origin` mostrar seu IP real → o proxy NÃO está funcionando.

---

### Passo 6 — Instalar o CA Certificate do Burp

1. Com proxy ativado, acesse `http://burp` no Firefox
2. Clique em **CA Certificate** → salve `cacert.der`
3. Firefox → **Settings → Privacy & Security → Certificates → View Certificates**
4. Aba **Authorities** → **Import** → selecione `cacert.der`
5. Marque **✓ Trust to identify websites** → OK

**✅ Teste:** acesse `https://httpsbin.org` — sem aviso de SSL = sucesso.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `SSL_ERROR_RX_RECORD_TOO_LONG` | CA não instalado | Repita o import |
| Aviso "Not secure" | CA não confiável | Verifique "Trust to identify websites" |
| Firefox bloqueia `http://burp` | Enhanced Tracking Protection | Desative temporariamente |

---

### Passo 7 — Configurar Escopo (Scope)

Sem escopo, o Burp captura Google Analytics, CDN e toda a internet.

1. **Target → Scope → Include in scope → Add**
2. Configure para o alvo `target.com`:
```
https?://.*target\.com:.*
```
- `https?://` → HTTP e HTTPS
- `.*target\.com` → captura `target.com`, `api.target.com`, `admin.target.com`
- Pergunta "Out-of-scope items have been seen?" → **Yes** para hosts do alvo

**📡 Dados do Reconhecimento (Módulo 01):** importe cada URL de `~/recon/targets/<alvo>/02-enum/vivos-filtrados.txt` como **Scope Individual** (Target → Scope → Add) — assim `admin.target.com` e `api.target.com` entram no escopo **antes** do crawl.

**3. Filtrar o histórico:** **Proxy → HTTP history** → no filtro marque **Show only in-scope items**.

---

### Passo 8 — Testar o Intercept

1. **Proxy → Intercept** → garanta **Intercept is on** (AZUL)
2. No Firefox, acesse `http://httpbin.org/get`

**✅ Output esperado no Burp:**
```
GET /get HTTP/1.1
Host: httpbin.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0
Accept: text/html,application/xhtml+xml,...
Connection: close
```

Clique **Forward** para liberar. **❌ Request não aparece?** → Intercept off (ative), proxy não configurado (ver Passo 5), ou fora do escopo (Passo 7).

---

### ⚠️ Regras de ouro de setup:

| Regra | Por quê |
|-------|---------|
| **SEMPRE use VPN antes de testar** | Seu IP fica nos logs do alvo para sempre |
| **Nunca comece sem escopo definido** | Testar fora do escopo é crime mesmo com autorização parcial |
| **Confirme que o tráfego passa pelo Burp** | Sem intercept = teste inválido |
| **WAF detectado no recon? Reduza a velocidade** | Ver 06-opsec.md antes da Fase 2 |
| **CA cert instalado** | HTTPS quebrado = metade dos testes impossíveis |

---

**Se completou tudo → Avance para [04 - Checklist Setup](04-checklist-setup.md)**
