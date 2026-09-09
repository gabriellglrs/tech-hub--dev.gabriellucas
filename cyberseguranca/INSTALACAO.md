# 🛠️ Guia de Instalação

> Como instalar TODAS as ferramentas usadas nesta trilha. Siga passo a passo.

---

## 📋 Pré-requisitos

Antes de instalar qualquer coisa, você precisa:

1. **Linux instalado** (Ubuntu/Debian recomendado)
   - Se não tem: instale Ubuntu no VirtualBox ou use WSL2 no Windows
   - Guia: https://ubuntu.com/tutorials

2. **Terminal aberto** (Ctrl+Alt+T no Ubuntu)

3. **Conexão com internet**

---

## 🔧 Instalação Básica

### Atualizar o sistema
```bash
sudo apt update && sudo apt upgrade -y
```

### Instalar dependências básicas
```bash
sudo apt install -y curl wget git unzip build-essential
```

---

## 🕵️ Módulo 1: Reconhecimento

### Whois
```bash
sudo apt install -y whois
# Testar: whois google.com
```

### Dig e NSLookup
```bash
sudo apt install -y dnsutils
# Testar: dig google.com
```

### Nmap
```bash
sudo apt install -y nmap
# Testar: nmap --version
```

### Masscan (mais rápido que Nmap)
```bash
sudo apt install -y masscan
# Testar: masscan --version
```

### Subfinder
```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
# Ou via apt (se disponível):
sudo apt install -y subfinder
# Testar: subfinder --version
```

### TheHarvester
```bash
sudo apt install -y theharvester
# Testar: theHarvester --help
```

### Amass
```bash
sudo apt install -y amass
# Testar: amass --version
```

### httpx
```bash
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
# Testar: httpx --version
```

### Nuclei
```bash
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest
# Atualizar templates:
nuclei -update-templates
# Testar: nuclei --version
```

---

## 🌐 Módulo 2: Web & Aplicações

### WhatWeb
```bash
sudo apt install -y whatweb
# Testar: whatweb google.com
```

### Wafw00f
```bash
sudo apt install -y wafw00f
# Testar: wafw00f --help
```

### WPScan
```bash
sudo apt install -y wpscan
# Testar: wpscan --help
```

### Gobuster
```bash
sudo apt install -y gobuster
# Testar: gobuster --version
```

### FFUF
```bash
go install github.com/ffuf/ffuf/v2@latest
# Testar: ffuf -h
```

### Nikto
```bash
sudo apt install -y nikto
# Testar: nikto --help
```

### SQLMap
```bash
sudo apt install -y sqlmap
# Testar: sqlmap --version
```

### Burp Suite (Community Edition)
```bash
# Download: https://portswigger.net/burp/communitydownload
# É um arquivo .jar - precisa de Java:
sudo apt install -y default-jre
# Executar: java -jar burpsuite_community.jar
```

### feroxbuster
```bash
sudo apt install -y feroxbuster
# Testar: feroxbuster --version
```

### Arjun
```bash
pip3 install arjun
# Testar: arjun --help
```

### Kiterunner
```bash
go install github.com/assetnote/kiterunner@latest
# Testar: kr --help
```

### Ffuf
```bash
go install github.com/ffuf/ffuf/v2@latest
# Testar: ffuf -h
```

---

## 🔑 Módulo 3: Exploração

### Hydra
```bash
sudo apt install -y hydra
# Testar: hydra -h
```

### John the Ripper
```bash
sudo apt install -y john
# Testar: john --help
```

### Hashcat
```bash
sudo apt install -y hashcat
# Testar: hashcat --version
# Para GPU:
sudo apt install -y nvidia-driver-535
```

### hashid
```bash
pip3 install hashid
# Testar: hashid --help
```

### SecLists (Wordlists)
```bash
sudo apt install -y seclists
# Localização: /usr/share/seclists/
# Testar: ls /usr/share/seclists/Passwords/
```

### CeWL
```bash
sudo apt install -y cewl
# Testar: cewl --help
```

### Crunch
```bash
sudo apt install -y crunch
# Testar: crunch --help
```

---

## 🔧 Módulo 4: Pós-Exploração

### Impacket
```bash
pip3 install impacket
# Testar: smbclient.py --help
```

### LinPEAS
```bash
curl -L https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh | sh
# Ou:
wget https://github.com/carlospolop/PEASS-ng/releases/latest/download/linpeas.sh
chmod +x linpeas.sh
```

### WinPEAS
```bash
# Download: https://github.com/carlospolop/PEASS-ng/releases
# Arquivo .exe - executa no Windows
```

### Socat
```bash
sudo apt install -y socat
# Testar: socat -V
```

### Netcat
```bash
sudo apt install -y netcat-openbsd
# Testar: nc -h
```

### Ligolo-ng
```bash
# Download: https://github.com/nicocha30/ligolo-ng/releases
# Seguir instruções do GitHub
```

### Chisel
```bash
# Download: https://github.com/jpillora/chisel/releases
# Ou:
go install github.com/jpillora/chisel@latest
```

---

## 🔬 Módulo 5: Engenharia Reversa

### Ghidra
```bash
# Download: https://ghidra-sre.org/
# É Java - precisa de JDK:
sudo apt install -y openjdk-17-jdk
# Extrair e executar: ./ghidraRun
```

### Radare2
```bash
sudo apt install -y radare2
# Testar: r2 -v
```

### GDB + GEF
```bash
sudo apt install -y gdb
# Instalar GEF:
bash -c "$(curl -fsSL https://raw.githubusercontent.com/hugsy/gef/main/gef.sh)"
# Testar: gdb --version
```

### checksec
```bash
sudo apt install -y checksec
# Ou:
pip3 install checksec.py
# Testar: checksec --version
```

### pwntools
```bash
pip3 install pwntools
# Testar: python3 -c "from pwn import *; print('OK')"
```

### ropper
```bash
pip3 install ropper
# Testar: ropper --version
```

### ROPgadget
```bash
pip3 install ROPGadget
# Testar: ROPgadget --version
```

### msfvenom (Metasploit)
```bash
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
chmod 755 msfinstall
./msfinstall
# Testar: msfvenom --version
```

---

## 📡 Módulo 6: Análise de Rede

### tcpdump
```bash
sudo apt install -y tcpdump
# Testar: tcpdump --version
```

### Wireshark
```bash
sudo apt install -y wireshark
# Adicionar usuário ao grupo:
sudo usermod -aG wireshark $USER
# Re-login para efeito
# Testar: wireshark --version
```

### tshark
```bash
sudo apt install -y tshark
# Testar: tshark --version
```

### mitmproxy
```bash
sudo apt install -y mitmproxy
# Testar: mitmproxy --version
```

### bettercap
```bash
sudo apt install -y bettercap
# Testar: bettercap -eval "exit"
```

### Proxychains
```bash
sudo apt install -y proxychains4
# Editar config: sudo nano /etc/proxychains4.conf
# Adicionar no final: socks5 127.0.0.1 9050
# Testar: proxychains4 curl ifconfig.me
```

### Tor
```bash
sudo apt install -y tor
sudo systemctl start tor
# Testar: proxychains4 curl ifconfig.me
```

---

## 🛡️ Módulo 7: Defesa

### Lynis
```bash
sudo apt install -y lynis
# Testar: lynis --version
```

### OpenSCAP
```bash
sudo apt install -y libopenscap8
# Ou instalar via Ubuntu Security Guide
```

### UFW
```bash
sudo apt install -y ufw
# Testar: sudo ufw status
```

### iptables
```bash
# Já vem no Linux
# Testar: sudo iptables -L
```

### Suricata
```bash
sudo apt install -y suricata
# Testar: suricata --build-info
```

### fail2ban
```bash
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
# Testar: sudo fail2ban-client status
```

### Wazuh
```bash
# Seguir: https://documentation.wazuh.com/current/installation-guide/index.html
# Ou usar Docker:
docker-compose -f docker-compose.yml up -d
```

---

## 🔍 Módulo 8: Resposta a Incidentes

### Volatility 3
```bash
pip3 install volatility3
# Testar: volatility3 --help
```

### Autopsy
```bash
# Download: https://www.autopsy.com/download/
# Ou instalar via apt:
sudo apt install -y autopsy
```

### Yara
```bash
sudo apt install -y yara
# Testar: yara --version
```

### dd (já vem no Linux)
```bash
# Testar: dd --version
```

### ewfmount
```bash
sudo apt install -y ewf-tools
# Testar: ewfmount --help
```

---

## ☁️ Módulo 9: Ambientes Especiais

### Docker
```bash
sudo apt install -y docker.io
sudo usermod -aG docker $USER
# Re-login
# Testar: docker --version
```

### Trivy
```bash
sudo apt install -y trivy
# Testar: trivy --version
```

### kubectl
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
# Testar: kubectl version --client
```

### kube-hunter
```bash
pip3 install kube-hunter
# Testar: kube-hunter --help
```

### Aircrack-ng
```bash
sudo apt install -y aircrack-ng
# Testar: aircrack-ng --help
```

### Wifite
```bash
sudo apt install -y wifite
# Testar: wifite --help
```

### jadx (Android)
```bash
sudo apt install -y jadx
# Testar: jadx --version
```

### Frida
```bash
pip3 install frida-tools
# Testar: frida --version
```

### MobSF
```bash
git clone https://github.com/MobSF/Mobile-Security-Framework-MobSF.git
cd Mobile-Security-Framework-MobSF
./setup.sh
# Testar: python3 manage.py runserver
```

---

## 📜 Módulo 10: Governança & Criptografia

### OpenSSL
```bash
sudo apt install -y openssl
# Testar: openssl version
```

### GPG
```bash
sudo apt install -y gnupg
# Testar: gpg --version
```

### age
```bash
sudo apt install -y age
# Testar: age --version
```

### CyberChef
```bash
# Online: https://gchq.github.io/CyberChef/
# Ou download: https://github.com/gchq/CyberChef/releases
```

---

## ✅ Verificação Final

### Script de verificação
```bash
echo "=== Verificando ferramentas ==="
for cmd in whois dig nmap masscan subfinder theharvester amass httpx nuclei whatweb wafw00f wpscan gobuster ffuf nikto sqlmap hydra john hashcat hashid socat netcat gdb checksec pwntools tcpdump tshark wireshark mitmproxy bettercap proxychains4 lynis ufw suricata fail2ban volatility3 yara docker trivy kubectl aircrack-ng openssl gpg; do
    if command -v $cmd &> /dev/null; then
        echo "✓ $cmd instalado"
    else
        echo "✗ $cmd NÃO instalado"
    fi
done
```

### Instalar tudo de uma vez
```bash
# Copie e cole este bloco no terminal:
sudo apt update && sudo apt upgrade -y && \
sudo apt install -y whois dnsutils nmap masscan theharvester amass subfinder whatweb wafw00f wpscan gobuster nikto sqlmap hydra john hashcat socat netcat gdb wireshark tshark mitmproxy bettercap proxychains4 tor lynis ufw suricata fail2ban volatility3 yara docker.io aircrack-ng openssl gnupg age cewl crunch && \
pip3 install impacket pwntools ropper ROPGadget hashid arjun frida-tools && \
echo "✅ Instalação concluída!"
```

---

<div align="center">

**Voltar ao [README Principal](README.md)**

</div>
