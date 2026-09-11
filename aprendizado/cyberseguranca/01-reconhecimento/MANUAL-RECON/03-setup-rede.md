## Setup de Rede — VPN, Tor e ProxyChains

> **Antes de escanear QUALQUER coisa, configure sua rede.** Se você escanear com seu IP real, seu ISP vai bloquear você em minutos, e o alvo vai ter seu IP nos logs para sempre.

### Por que isso importa?

Quando você faz `nmap -sT -p- --min-rate 5000 alvo.com`, o alvo recebe **milhares de pacotes** do seu IP. Isso:
- **Aciona IDS/IPS** do alvo (ele sabe que está sendo escaneado)
- **Registra seu IP** nos logs do servidor
- **Pode ser ilegal** se não tiver autorização
- **Seu ISP pode bloquear** sua conexão

### Opção 1: VPN (RECOMENDADO)

A melhor opção. Esconde seu IP real e criptografa todo o tráfego.

```bash
# Instalar NordVPN (gratuito por 30 dias, depois R$25/mês)
# Acesse: https://nordvpn.com/download/linux/
wget https://downloads.nordcdn.com/apps/linux/install.sh
sh install.sh

# Conectar (deixe rodando durante TODOS os scans)
nordvpn connect

# Verificar se funciona
curl -s https://ifconfig.me
# Deve mostrar o IP da VPN, não o seu IP real

# Desconectar quando terminar
nordvpn disconnect
```

**Alternativas gratuitas:**
| VPN | Limite | Como usar |
|-----|--------|-----------|
| **ProtonVPN** | 10GB/mês | `sudo apt install protonvpn` |
| **Windscribe** | 10GB/mês | App no site oficial |
| **Mullvad** | 5€/mês (sem limite) | App no site oficial |

### Opção 2: Tor (para Fase 1 apenas)

Tor é bom para inteligência passiva, mas **NÃO serve para scans ativos** (é muito lento).

```bash
# Instalar Tor
sudo apt install tor

# Iniciar Tor
sudo systemctl start tor

# Configurar ProxyChains para usar Tor
sudo nano /etc/proxychains4.conf
# Mude para: socks4 127.0.0.1 9050

# Testar
proxychains4 curl -s https://ifconfig.me
# Deve mostrar um IP diferente (Tor exit node)
```

### Opção 3: ProxyChains (para scans leves)

Funciona com Tor ou com qualquer proxy. Bom para Fase 1 e 2 (não para scans pesados).

```bash
# Instalar
sudo apt install proxychains4

# Configurar
sudo nano /etc/proxychains4.conf
# No final, mude:
# socks4 127.0.0.1 9050    ← para Tor
# ou
# socks5 SEU_PROXY PORTA    ← para proxy externo

# Usar (adicione "proxychains4" antes de qualquer comando)
proxychains4 subfinder -d evilcorp.com -silent
proxychains4 theHarvester -d evilcorp.com -b google
proxychains4 nmap -sT -Pn -p 80,443 evilcorp.com
```

### ⚠️ Regras de ouro de rede:

| Regra | Por quê |
|-------|---------|
| **SEMPRE use VPN para scans ativos** | Evita ban de ISP e rastreamento |
| **Use Tor apenas para passivo** | Tor é lento demais para Nmap |
| **Se banido, mude de IP** | Desconecte VPN, reconecte (novo IP) |
| **Nunca escaneie de IP fixo sem VPN** | Seu IP fica nos logs do alvo para sempre |
| **Verifique seu IP antes de começar** | `curl -s https://ifconfig.me` deve mostrar VPN, não IP real |

---
