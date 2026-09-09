# 🔒 Hardening

> Endurecer sistema operacional, serviços e kernel para reduzir superfície de ataque. Baseado em CIS Benchmark.

---

## 🚀 Passo a Passo — Como fazer Hardening

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

## Ferramentas

| Ferramenta | Para quê |
|:---|:---|
| **lynis** | Auditoria completa, score de hardening |
| **openSCAP** | Validação CIS Benchmark |
| **cis-cat** | Scanner CIS oficial (requer licença) |
| **debsecan** | Vulnerabilidades em pacotes Debian/Ubuntu |

## Checklist CIS essencial

- [ ] Atualizações automáticas (unattended-upgrades)
- [ ] Firewall ativo (ver `02-firewall.md`)
- [ ] SSH só com chave, sem root
- [ ] `umask 027`, permissões `/etc/shadow 640`
- [ ] Logs com `auditd` habilitado
- [ ] Remover `telnet, rsh, talk`
