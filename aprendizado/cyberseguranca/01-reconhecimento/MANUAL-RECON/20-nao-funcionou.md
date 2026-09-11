## Apêndice C — O que fazer se NADA funcionar

Às vezes, TUDO dá errado. Aqui está o que fazer em cada cenário:

### Cenário 1: "O alvo não existe ou não tem website"

```bash
# Verificar se o domínio resolve
dig +short evilcorp.com

# Se não retornar nada:
# 1. Verifique se digitou certo
# 2. Tente com www: www.evilcorp.com
# 3. O domínio pode ser novo (menos de 24h)
# 4. O domínio pode ter expirado
```

**Alternativa:** Busque o domínio em https://who.is para confirmar se existe.

### Cenário 2: "WAF bloqueia TODOS os scans"

```bash
# 1. Use ProxyChains + Tor
proxychains4 nmap -sT -Pn -p 80,443 evilcorp.com

# 2. Reduza velocidade drasticamente
nmap -sT -Pn -p 80,443 -T1 --min-rate 100 evilcorp.com

# 3. Mude de IP (VPN)
# Conecte-se a uma VPN e repita o scan

# 4. Foque em inteligência passiva
# Use apenas Subfinder, Amass, crt.sh, Wayback (não tocam no alvo)
```

### Cenário 3: "Ferramentas Go não instalam"

```bash
# 1. Instale Go primeiro
sudo apt install golang

# 2. Configure GOPATH
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# 3. Adicione ao .bashrc para persistir
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc

# 4. Agora instale as ferramentas
go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
```

### Cenário 4: "Scan retorna 0 resultados"

```bash
# 1. Verifique se o IP está correto
ping -c 1 evilcorp.com

# 2. Verifique se as portas estão realmente abertas
nmap -sT -Pn -p 80,443 evilcorp.com

# 3. Se 0 ports abertos, pode ser:
#    - Firewall bloqueando
#    - IP errado
#    - O serviço está em porta não padrão

# 4. Tente scan de ports ALTO
nmap -sT -Pn -p- -T4 evilcorp.com

# 5. Se ainda nada, pode ser que o alvo esteja MUITO protegido
# Nesse caso, documente: "Alvo não respondeu a scans"
```

### Cenário 5: "Nuclei não encontra nada"

```bash
# 1. Atualize templates
nuclei -update-templates

# 2. Rode com verbose
nuclei -u http://evilcorp.com -v

# 3. Rode com severity ALL (incluindo info)
nuclei -u http://evilcorp.com -severity info,low,medium,high,critical

# 4. Se ainda nada, o site pode estar muito bem protegido
# Foque em outros scanners (Nikto, Nmap NSE)
```

### Cenário 6: "Go não instala (erro de compilação)"

```bash
# Alternativa: use Docker
docker run -it projectdiscovery/subfinder -d evilcorp.com -silent

# Ou baixe binário pré-compilado
wget https://github.com/projectdiscovery/subfinder/releases/latest/download/subfinder_linux_amd64.zip
unzip subfinder_linux_amd64.zip
chmod +x subfinder
./subfinder -d evilcorp.com -silent
```

### Regra de ouro quando tudo falha

> **Se uma ferramenta não funciona, use a ALTERNATIVA da tabela de referência (Apêndice B). Se a alternativa também não funciona, documente o erro e AVANÇE para a próxima fase. Nunca pare uma fase inteira por causa de UMA ferramenta quebrada.**
