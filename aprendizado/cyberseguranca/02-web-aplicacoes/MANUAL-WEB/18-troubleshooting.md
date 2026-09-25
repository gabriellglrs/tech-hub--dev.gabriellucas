# Apêndice A — Troubleshooting: Solução de Problemas Comuns

## Burp Suite

### Burp não inicia
```bash
java -version
sudo apt install openjdk-17-jdk
burpsuite -Xmx4g
```

### Proxy não conecta (browser sem resposta)
```bash
ss -tlnp | grep 8080                       # porta em uso?
sudo kill $(sudo lsof -t -i:8080)          # liberar porta
sudo iptables -L -n | grep 8080            # firewall?
```

### SSL/TLS Error (`SSL_ERROR_RX_RECORD_TOO_LONG`)
1. Verificar CA Certificate instalado (passo 3.4 do setup)
2. Firefox → Configurações → Certificados → Autoridades → importar `cacert.der`
3. Marcar "Confiar para identificar websites"

### Intercept não aparece
1. Intercept **on** (botão azul)
2. Proxy configurado no browser (127.0.0.1:8080)
3. Alvo dentro de **Target → Scope**

---

## SQLMap

| Problema | Solução |
|----------|---------|
| `command not found` | `sudo apt install sqlmap` |
| `not injectable` | `--level=5 --risk=2` e teste manual primeiro |
| Rate limiting | `--delay=1 --threads=1` |
| connection reset | `--random-agent --proxy=http://127.0.0.1:8080` |
| Muito lento | `--technique=BEU` |

---

## Nuclei

| Problema | Solução |
|----------|---------|
| `command not found` | `go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest` + `export PATH=$PATH:~/go/bin` |
| Templates não atualizam | `nuclei -update-templates` e `ping -c 3 github.com` |
| Muitos falsos positivos | `-severity critical,high` ou `-tags sqli,xss` + validação manual |

---

## Hydra

| Problema | Solução |
|----------|---------|
| `command not found` | `sudo apt install hydra` |
| "Invalid format" | confira o formato `https-post-form "/path:user=^USER^&pass=^PASS^:MENSAGEM"` |
| 0 matches em tudo | a mensagem de erro está errada — copie a EXATA do Burp |
| Rate limiting | `-w 5` (5s entre tentativas), `-t 1` |

---

## File Upload

- **"File type not allowed"** → bypass de extensão → Content-Type → magic bytes → polyglot
- **Webshell não executa** → servidor não roda PHP → tente `.phtml`/`.php5` → verifique WAF

---

## ffuf / Fuzzing

| Problema | Solução |
|----------|---------|
| Output vazio | `-fc 404` (filtra 404) |
| Falsos positivos | `-fs 0` (filtra por tamanho) |
| 429/403 em tudo | WAF — `-t 2 -p 2` (mais devagar) |

---

## Rede

```bash
ping -c 3 evilcorp.com          # conectividade
nslookup evilcorp.com           # DNS
nmap -p 80,443 evilcorp.com     # portas
echo $http_proxy $https_proxy   # proxy variável
sudo iptables -L -n             # firewall local
```

---

## Contato para suporte
1. Logs do Burp: `~/.BurpSuite/`
2. Logs do sistema: `/var/log/syslog`
3. Docs oficiais das ferramentas
4. GitHub Issues / comunidades (Reddit, Stack Overflow)

**Voltar ao índice:** [README](README.md)
