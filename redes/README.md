# 🌐 Redes — Fundamentos e Prática

> Conceitos de redes, protocolos, diagnóstico e configuração Linux.

---

## 📂 Estrutura planejada

| Arquivo | Descrição |
|:---|:---|
| `01-fundamentos.md` | `OSI/TCP-IP, IP, máscara, gateway, DNS, DHCP` |
| `02-comandos-rede.md` | `ip, ss, ping, traceroute, dig, tcpdump, nmap` |
| `03-config-linux.md` | `netplan, /etc/hosts, resolv.conf, iptables/nftables` |
| `04-servicos.md` | `SSH, HTTP, DNS, DHCP, VPN (wireguard)` |
| `05-troubleshooting.md` | `ping, mtr, iperf, diagnóstico de latência` |

---

## 🚀 Como usar

```bash
# Exemplos
ip a
ss -tulpn
dig @8.8.8.8 exemplo.com
mtr 1.1.1.1
```

> Complementa `cyberseguranca/offensive/04-sniffing-rede.md` mas com foco em infra, não ataque.
