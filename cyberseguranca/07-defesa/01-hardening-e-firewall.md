# 🔒 Hardening & Firewall

> Endurecer sistema operacional, serviços e kernel para reduzir superfície de ataque. Filtrar tráfego na borda e no host. Princípio: negar tudo, liberar só o necessário.

---

## Instalação das Ferramentas

```bash
sudo apt install -y lynis ufw iptables-persistent openscap-scanner
```

---

## 🚀 Hardening — Passo a Passo

### Passo 1: Auditoria inicial (Lynis)
```bash
sudo apt install -y lynis
sudo lynis audit system
# Veja o score e as sugestões em /var/log/lynis.log
```

### Passo 2: Atualizações e pacotes mínimos
```bash
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
# Remover serviços desnecessários:
sudo systemctl disable --now telnet avahi-daemon
```

### Passo 3: Hardening de kernel (sysctl)
```bash
sudo nano /etc/sysctl.conf
# Adicionar:
net.ipv4.conf.all.rp_filter = 1
net.ipv4.tcp_syncookies = 1
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.disable_ipv6 = 1
kernel.randomize_va_space = 2
sudo sysctl -p
```

### Passo 4: Contas e senhas
```bash
# Política de senha
sudo nano /etc/security/pwquality.conf
# minlen = 12, ucredit = -1, etc

# Bloquear root SSH
sudo nano /etc/ssh/sshd_config
# PermitRootLogin no
# PasswordAuthentication no  (usar chave)
sudo systemctl restart sshd
```

### Passo 5: CIS Benchmark (OpenSCAP)
```bash
sudo apt install -y openscap-scanner
sudo oscap xccdf eval --profile xccdf_org.ssgproject.content_profile_cis \
  /usr/share/openscap/scap/ssg/content/ssg-ubuntu2204-ds.xml
```

---

## 🔥 Firewall — Passo a Passo

### UFW (Ubuntu, mais simples)
```bash
sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp comment 'SSH'
sudo ufw allow 80,443/tcp comment 'Web'
sudo ufw enable
sudo ufw status verbose
```

### iptables (clássico)
```bash
# Bloquear tudo, liberar loopback e estabelecidas
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables-save | sudo tee /etc/iptables/rules.v4
```

### nftables (moderno, substitui iptables)
```bash
sudo apt install -y nftables
sudo nft add table inet filter
sudo nft add chain inet filter input '{ type filter hook input priority 0; policy drop; }'
sudo nft add rule inet filter input ct state established,related accept
sudo nft add rule inet filter input tcp dport 22 accept
```

## Comparativo de Firewalls

| Feature | ufw | iptables | nftables | firewalld |
|:---|:---|:---|:---|:---|
| Sintaxe | Fácil | Complexa | Média | Fácil |
| Performance | Boa | Média | Alta | Boa |
| Ubuntu default | ✅ | ✅ | ✅ | ❌ |

---

## Ferramentas

| Ferramenta | Para quê |
|:---|:---|
| **lynis** | Auditoria completa, score de hardening |
| **openSCAP** | Validação CIS Benchmark |
| **cis-cat** | Scanner CIS oficial (requer licença) |
| **debsecan** | Vulnerabilidades em pacotes Debian/Ubuntu |

## Checklist CIS essencial

- [ ] Atualizações automáticas (unattended-upgrades)
- [ ] Firewall ativo
- [ ] SSH só com chave, sem root
- [ ] `umask 027`, permissões `/etc/shadow 640`
- [ ] Logs com `auditd` habilitado
- [ ] Remover `telnet, rsh, talk`

## Dicas extras

```bash
# Rate limit SSH contra brute force (ufw)
sudo ufw limit 22/tcp

# Log de bloqueios
sudo ufw logging on
sudo dmesg | grep -i ufw
```

### Resumo da ordem — Por que essa sequência?

Defesa segue a ordem: **auditar → endurecer → filtrar → monitorar**.

```
PASSO 1: Lynis → Auditar o sistema atual
├── POR QUE: Antes de corrigir, precisa saber o que está errado
├── O QUE PROCURAR: Score baixo,Alertas de hardening, configuraçõesinseguras
├── COMANDO: sudo lynis audit system
├── QUANDO AVANÇAR: Quando tiver relatório completo
└── DICAS: Salve o relatório: sudo lynis audit system --logfile /tmp/lynis.log

        ↓

PASSO 2: CIS Benchmark → Aplicar padrões de segurança
├── POR QUE: CIS é o padrão mundial de hardening
├── O QUE FAZER: Seguir recomendações do CIS para seu SO
├── FERRAMENTA: OpenSCAP (auditoria automatizada)
├── COMANDO: sudo oscap xccdf eval --profile cis --results results.xml /usr/share/xml/scap/ssg/content/ssg-ubuntu2204-ds.xml
├── QUANDO AVANÇAR: Quando corrigir falhas críticas
└── DICAS: Foque nas recomendações "high severity" primeiro

        ↓

PASSO 3: UFW → Configurar firewall básico
├── POR QUE: Firewall é a primeira linha de defesa
├── O QUE FAZER: Bloquear tudo, depois liberar o necessário
├── COMANDOS:
│   sudo ufw enable
│   sudo ufw default deny incoming
│   sudo ufw default allow outgoing
│   sudo ufw allow 22/tcp    # SSH
│   sudo ufw allow 80/tcp    # HTTP
│   sudo ufw allow 443/tcp   # HTTPS
├── QUANDO AVANÇAR: Quando tiver regras básicas
└── ERROS COMUNS: Não esqueça de allow SSH antes de enable!

        ↓

PASSO 4: iptables/nftables → Regras avançadas
├── POR QUE: UFW é limitado, iptables/nft dá controle total
├── O QUE FAZER: Regras específicas por IP, porta, protocolo
├── COMANDO: sudo iptables -A INPUT -s 10.0.0.0/8 -p tcp --dport 22 -j ACCEPT
├── QUANDO AVANÇAR: Quando precisar de regras complexas
└── DICAS: Use nftables (novo) ou iptables (clássico)

        ↓

PASSO 5: Suricata/Snort → Monitorar intrusões
├── POR QUE: Firewall filtra, mas IDS detecta ataques
├── O QUE FAZER: Instalar e configurar regras de detecção
├── COMANDO: sudo suricata -c /etc/suricata/suricata.yaml -i eth0
├── QUANDO AVANÇAR: Quando tiver IDS rodando
└── DICAS: Atualize regras: suricata-update

        ↓

PASSO 6: Wazuh/ELK → Centralizar logs (SIEM)
├── POR QUE: Logs dispersos são inúteis, centralizar permite correlação
├── O QUE FAZER: Instalar Wazuh ou Elastic Stack
├── QUANDO PARAR: Quando tiver dashboards com alertas
└── DICAS: Wazuh é mais fácil, ELK é mais poderoso
```

---

## Lab Prático

1. **TryHackMe — Blue Team** — Configure UFW para negar/liberar tráfego, audite um servidor com Lynis e aplique recomendações CIS Benchmark.
   - https://tryhackme.com/room/blue
2. **TryHackMe — Linux Hardening** — Pratique hardening de kernel (sysctl), políticas de senha, permissões de arquivos e configuração SSH segura.
   - https://tryhackme.com/room/linuxhardening
3. **CyberDefenders — IDA** — Analise alertas de firewall e correlacione com tentativas de intrusão reais.
   - https://cyberdefenders.org
