# Fase 0: Checklist de Setup do Ambiente

**Tempo estimado:** 15-20 minutos
**Objetivo:** Garantir que TODO o ambiente está pronto ANTES de começar o teste. Se algo falhar aqui, o teste inteiro pode ser invalidado.
**Por quê:** Nada é pior do que gastar 2 horas num teste para descobrir que o Burp não estava capturando tráfego porque o proxy não estava configurado. Este checklist elimina esse risco.

---

### Passo 0.1 — Verificar Kali Linux

**O que você vai fazer:** Confirmar que está rodando Kali Linux atualizado, onde todas as ferramentas de segurança estão pré-instaladas.

```bash
lsb_release -a && uname -a
```

**✅ Output esperado:**
```
Distributor ID: Kali
Description:    Kali GNU/Linux Rolling
Release:        2025.x
Codename:       kali-rolling
Linux kali 6.x.x-kali1-amd64 #1 SMP Debian 6.x.x x86_64 GNU/Linux
```

**O que procurar:**
- **Kali Rolling** → versão correta
- **x86_64** → arquitetura correta (64 bits)

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `lsb_release: command not found` | Kali antigo ou outro SO | Instale Kali 2024+ ou use VM |
| Não mostra "Kali" | Não é Kali | Use VM do Kali oficial |

---

### Passo 0.2 — Verificar Burp Suite

**O que você vai fazer:** Confirmar que o Burp Suite Community Edition está instalado e funcional.

```bash
which burpsuite
java -version 2>&1 | head -1
```

**✅ Output esperado:**
```
/usr/bin/burpsuite
openjdk version "17.0.x" 2024-xx-xx
```

**O que procurar:**
- **`/usr/bin/burpsuite`** → instalado
- **Java 17+** → necessário para Burp 2024+

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `which burpsuite` vazio | Não instalado | `sudo apt install burpsuite` |
| Java não encontrado | Java não instalado | `sudo apt install openjdk-17-jdk` |
| Burp não inicia | Java incompatível | Instale OpenJDK 17: `sudo apt install openjdk-17-jdk` |

---

### Passo 0.3 — Configurar Proxy no Browser

**O que você vai fazer:** Configurar o Firefox para redirecionar TODO o tráfego HTTP/HTTPS pelo Burp Suite.

**Opção A — FoxyProxy (Recomendado):**
1. Abra Firefox → **Add-ons** → buscar "FoxyProxy"
2. Instale a extensão
3. Clique no ícone do FoxyProxy → **Options**
4. Clique **Add New Proxy**:
   - **Title:** `Burp`
   - **Proxy Type:** HTTP
   - **Proxy IP:** `127.0.0.1`
   - **Port:** `8080`
5. Salve e ative o perfil **Burp**

**Opção B — Configuração Manual:**
1. Firefox → **Settings** → **Network Settings**
2. Selecione **Manual proxy configuration**
3. HTTP Proxy: `127.0.0.1`, Port: `8080`
4. Marque: **✓ Use this proxy server for all protocols**

**✅ Teste de confirmação:**
```bash
# Com proxy ativado, teste:
curl -x http://127.0.0.1:8080 http://httpbin.org/ip
```

**Output esperado:**
```json
{
  "origin": "127.0.0.1"
}
```

Se o `origin` mostrar seu IP real (não `127.0.0.1`), o proxy NÃO está funcionando.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `curl: (7) Connection refused` | Burp não está rodando | Abra o Burp Suite primeiro |
| Origin mostra IP real | Proxy não configurado | Verifique se o FoxyProxy está ativo |
| SSL error | CA Certificate não instalado | Veja Passo 0.4 |

---

### Passo 0.4 — Instalar CA Certificate do Burp

**O que você vai fazer:** Instalar o certificado raiz do Burp no Firefox para que ele possa interceptar tráfego HTTPS sem erros.

1. Com proxy ativado, acesse `http://burp` no Firefox
2. Clique em **CA Certificate** → salve o arquivo `cacert.der`
3. No Firefox, vá → **Settings → Privacy & Security → Certificates → View Certificates**
4. Na aba **Authorities**, clique **Import**
5. Selecione o arquivo `cacert.der`
6. Marque: **✓ Trust to identify websites** → OK

**✅ Teste de confirmação:**
Acesse `https://httpsbin.org` no Firefox com proxy ativado. Se não aparecer erro SSL → certificate instalado corretamente.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `SSL_ERROR_RX_RECORD_TOO_LONG` | CA não instalado ou não confiável | Repita o import do certificate |
| Aviso de certificate inválido | CA não está na lista de confiáveis | Verifique se marcou "Trust to identify websites" |
| Firefox bloqueia | Firefox enhanced tracking protection | Desative temporariamente para `http://burp` |

---

### Passo 0.5 — Verificar Ferramentas Essenciais

**O que você vai fazer:** Confirmar que todas as ferramentas necessárias para o teste estão instaladas.

```bash
echo "=== Verificando ferramentas ==="
for tool in sqlmap nuclei httpx subfinder ffuf whatweb curl; do
  echo -n "$tool: "
  which $tool 2>/dev/null || echo "❌ NÃO INSTALADO"
done
echo "=== Verificação concluída ==="
```

**✅ Output esperado:**
```
=== Verificando ferramentas ===
sqlmap: /usr/bin/sqlmap
nuclei: /usr/bin/nuclei
httpx: /usr/bin/httpx
subfinder: /usr/bin/subfinder
ffuf: /usr/bin/ffuf
whatweb: /usr/bin/whatweb
curl: /usr/bin/curl
=== Verificação concluída ===
```

**❌ Se der errado:**
| Ferramenta | Comando para instalar |
|------------|----------------------|
| sqlmap | `sudo apt install sqlmap` |
| nuclei | `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest` |
| httpx | `go install github.com/projectdiscovery/httpx/cmd/httpx@latest` |
| subfinder | `sudo apt install subfinder` ou `go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest` |
| ffuf | `go install github.com/ffuf/ffuf/v2@latest` |
| whatweb | `sudo apt install whatweb` |
| curl | `sudo apt install curl` |

---

### Passo 0.6 — Criar Diretório de Relatório

**O que você vai fazer:** Criar a estrutura de pastas onde todos os outputs do teste serão salvos.

```bash
mkdir -p relatorio
echo "Setup concluído em: $(date)" > relatorio/setup.log
echo "Tester: $(whoami)" >> relatorio/setup.log
echo "Kali version: $(lsb_release -d | cut -f2)" >> relatorio/setup.log
```

**✅ Output esperado (verificação):**
```bash
ls -la relatorio/
```
```
total 12
drwxr-xr-x  2 gabriel-lucas gabriel-lucas 4096 Sep 12 14:30 .
drwxr-xr-x  3 gabriel-lucas gabriel-lucas 4096 Sep 12 14:30 ..
-rw-r--r--  1 gabriel-lucas gabriel-lucas  120 Sep 12 14:30 setup.log
```

---

### Passo 0.7 — Verificar Conectividade com o Alvo

**O que você vai fazer:** Confirmar que você consegue acessar o alvo e que ele está respondendo.

```bash
# Substitua pela URL do seu alvo
TARGET="https://target.com"

# Testar conectividade HTTP
STATUS=$(curl -s -o /dev/null -w "%{http_code}" $TARGET)
echo "Status HTTP: $STATUS"

# Testar tempo de resposta
curl -s -o /dev/null -w "Tempo de resposta: %{time_total}s\n" $TARGET
```

**✅ Output esperado:**
```
Status HTTP: 200
Tempo de resposta: 0.234s
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Status 000 | Site offline ou bloqueando | Verifique se o site está online (de outro dispositivo) |
| Status 403 | Acesso bloqueado | Verifique se precisa de VPN ou headers específicos |
| Timeout | Lentidão ou bloqueio | Aumente timeout: `curl --connect-timeout 30` |
| Status 503 | Serviço indisponível | Aguarde e tente novamente |

---

### Passo 0.8 — Verificar Intercept do Burp

**O que você vai fazer:** Confirmar que o Burp Suite está capturando tráfego HTTP corretamente.

1. No Burp Suite, vá para **Proxy → Intercept**
2. Garanta que **Intercept is on** está AZUL (ativado)
3. No Firefox, acesse `http://httpbin.org/get`
4. O request deve aparecer no Burp Intercept

**✅ Output esperado no Burp:**
```
GET /get HTTP/1.1
Host: httpbin.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:128.0) Gecko/20100101 Firefox/128.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: pt-BR,pt;q=0.9,en-US;q=0.8,en;q=0.7
Connection: close
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Request não aparece | Intercept está off | Clique em **Intercept is off** para ativar |
| Request não aparece | Proxy não configurado | Verifique FoxyProxy |
| Muitos requests | Intercept captura TUDO | Use Scope para filtrar (ver Fase 1) |

---

### Checklist Final de Setup

| # | Item | Status | ☑ |
|---|------|--------|:---:|
| 1 | Kali Linux atualizado | Rodou `lsb_release -a` | [ ] |
| 2 | Burp Suite instalado | Rodou `which burpsuite` | [ ] |
| 3 | Java 17+ instalado | Rodou `java -version` | [ ] |
| 4 | Proxy browser configurado | Testou com `curl -x http://127.0.0.1:8080` | [ ] |
| 5 | CA Certificate instalado | Acessou `https://httpsbin.org` sem erro SSL | [ ] |
| 6 | Ferramentas essenciais instaladas | Todas apareceram no loop | [ ] |
| 7 | Diretório `relatorio/` criado | `ls relatorio/` mostra setup.log | [ ] |
| 8 | Conectividade com alvo verificada | Status HTTP 200 | [ ] |
| 9 | Intercept do Burp testado | Request apareceu no Burp Intercept | [ ] |
| 10 | Escopo definido no Burp | Target → Scope configurado (ver Fase 1) | [ ] |

### ✅ Sinal de sucesso:
- TODOS os 10 itens marcados ✅
- Burp Suite está aberto e capturando tráfego
- Você consegue acessar o alvo pelo proxy

### ❌ Se algum item falhou:
- **NÃO avance para a Fase 1** — corrija primeiro
- A maioria dos problemas se resolve reinstalando a ferramenta ou reconfigurando o proxy
- Se nada funciona, reinicie o Burp Suite e o Firefox

### 🔗 O que este checklist alimenta nas próximas fases:
| Item do Setup | Usado na Fase | Para quê |
|---------------|---------------|----------|
| Burp Suite + Proxy | TODAS as fases | Capturar e modificar tráfego |
| CA Certificate | Fase 1, 3, 4, 5, 6 | Interceptar HTTPS |
| `relatorio/` | TODAS as fases | Salvar outputs organizados |
| Conectividade | Fase 2 (Recon) | Confirmar que o alvo está acessível |
| Ferramentas instaladas | Fase 2, 3, 8 | Executar scans e testes |

**Se completou tudo → Avance para Fase 1** (`01-setup-burp-proxy.md`)

---
