# Anexo A: Troubleshooting — Solução de Problemas Comuns

## Problemas com Burp Suite

### Burp não inicia
**Sintoma:** Erro ao abrir Burp Suite
**Solução:**
```bash
# Verificar Java
java -version

# Instalar OpenJDK 17
sudo apt install openjdk-17-jdk

# Aumentar memória
burpsuite -Xmx4g
```

### Proxy não conecta
**Sintoma:** Browser não recebe resposta
**Solução:**
```bash
# Verificar se porta 8080 está em uso
ss -tlnp | grep 8080

# Matar processo na porta
sudo kill $(sudo lsof -t -i:8080)

# Verificar firewall
sudo iptables -L -n | grep 8080
```

### SSL/TLS Error
**Sintoma:** "SSL_ERROR_RX_RECORD_TOO_LONG"
**Solução:**
1. Verificar CA Certificate instalado
2. Firefox → Preferences → Certificates → Authorities
3. Importar `cacert.der` novamente
4. Confiar para identificar websites

### Intercept não aparece
**Sintoma:** Request não aparece no Burp Intercept
**Solução:**
1. Verificar se Intercept está **on** (botão azul)
2. Verificar proxy configurado no browser
3. Verificar escopo no Target → Scope

---

## Problemas com SQLMap

### SQLMap não encontrado
**Sintoma:** `command not found: sqlmap`
**Solução:**
```bash
sudo apt install sqlmap
```

### SQLMap retorna "not injectable"
**Sintoma:** SQLMap não encontra vulnerabilidade
**Solução:**
```bash
# Testar manualmente primeiro
# Usar level e risk maiores
sqlmap -u "URL" --batch --risk=3 --level=5

# Testar com technique específica
sqlmap -u "URL" --batch --technique=BEU
```

### Rate limiting
**Sintoma:** SQLMap para de funcionar
**Solução:**
```bash
# Adicionar delay
sqlmap -u "URL" --batch --delay=1

# Usar threads menores
sqlmap -u "URL" --batch --threads=1
```

---

## Problemas com Nuclei

### Nuclei não encontrado
**Sintoma:** `command not found: nuclei`
**Solução:**
```bash
go install github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
export PATH=$PATH:~/go/bin
```

### Templates não atualizam
**Sintoma:** Erro ao usar templates
**Solução:**
```bash
nuclei -update-templates
# Verificar conexão com internet
ping -c 3 github.com
```

### Muitos falsos positivos
**Sintoma:** Nuclei reporta muitas vulnerabilidades falsas
**Solução:**
```bash
# Filtrar por severity
nuclei -u URL -severity critical,high

# Usar tags específicas
nuclei -u URL -tags sqli,xss

# Verificar manualmente cada finding
```

---

## Problemas com Hydra

### Hydra não encontrado
**Sintoma:** `command not found: hydra`
**Solução:**
```bash
sudo apt install hydra
```

### Hydra retorna erro de formato
**Sintoma:** "Invalid format"
**Solução:**
```bash
# Verificar formato correto
hydra -h | grep https-post-form

# Exemplo correto:
hydra -l admin -P wordlist.txt target.com https-post-form "/login:username=^USER^&password=^PASS^:Invalid"
```

### Rate limiting
**Sintoma:** Hydra para de funcionar
**Solução:**
```bash
# Adicionar delay
hydra -l admin -P wordlist.txt target.com https-post-form "/login:username=^USER^&password=^PASS^:Invalid" -w 5
```

---

## Problemas com Upload

### Upload bloqueado
**Sintoma:** "File type not allowed"
**Solução:**
1. Testar bypass de extensão
2. Alterar Content-Type
3. Adicionar magic bytes
4. Usar polyglot file

### Webshell não executa
**Sintoma:** Webshell uploaded mas PHP não executa
**Solução:**
1. Verificar se servidor executa PHP
2. Testar outras extensões (phtml, php5)
3. Verificar se há WAF bloqueando

---

## Problemas de Rede

### Conexão timeout
**Sintoma:** Requests não retornam
**Solução:**
```bash
# Verificar conectividade
ping -c 3 target.com

# Verificar DNS
nslookup target.com

# Verificar portas abertas
nmap -p 80,443 target.com
```

### Firewall bloqueando
**Sintoma:** Requests bloqueados
**Solução:**
```bash
# Verificar regras de firewall
sudo iptables -L -n

# Verificar se há proxy
echo $http_proxy
echo $https_proxy
```

---

## Contato para Suporte

Se nenhum dos acima resolver:
1. Verificar logs do Burp: `~/.BurpSuite/`
2. Verificar logs do sistema: `/var/log/syslog`
3. Buscar documentação oficial das ferramentas
4. Consultar comunidades: Reddit, Stack Overflow, GitHub Issues
