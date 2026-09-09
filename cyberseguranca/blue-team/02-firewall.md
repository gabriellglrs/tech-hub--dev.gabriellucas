# 🔥 Firewall

> Filtrar tráfego na borda e no host. Princípio: negar tudo, liberar só o necessário.

---

## 🚀 Passo a Passo

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

## Comparativo

| Feature | ufw | iptables | nftables | firewalld |
|:---|:---|:---|:---|:---|
| Sintaxe | Fácil | Complexa | Média | Fácil |
| Performance | Boa | Média | Alta | Boa |
| Ubuntu default | ✅ | ✅ | ✅ | ❌ |

## Dicas

```bash
# Rate limit SSH contra brute force (ufw)
sudo ufw limit 22/tcp

# Log de bloqueios
sudo ufw logging on
sudo dmesg | grep -i ufw
```
