## Setup — VPN, Hydra, John, Hashcat, Metasploit

> **Antes de atacar QUALQUER coisa, configure ferramentas e rede.** Brute force gera MILHARES de tentativas do seu IP: sem VPN seu ISP bloqueia, e o alvo guarda seu IP nos logs para sempre.

### Por que isso importa?

Quando você roda `hydra -P rockyou.txt ssh://alvo.com`, o alvo recebe **milhares de tentativas de login**. Isso:
- **Trava contas** de usuários reais (antiético em produção, mesmo com autorização parcial)
- **Aciona IDS/IPS** e bloqueia seu IP em segundos
- **Registra seu IP** nos logs de autenticação do servidor
- **Pode ser ilegal** se não houver autorização **por escrito** cobrindo brute force
- **Seu ISP pode bloquear** a conexão (tráfego de força bruta)

---

### Passo 1 — VPN (OBRIGATÓRIO)

Mesmo setup do Módulo 01 — se já configurou, pule para o Passo 2.

```bash
# Instalar NordVPN (gratuito por 30 dias, depois R$25/mês)
# Acesse: https://nordvpn.com/download/linux/
wget https://downloads.nordcdn.com/apps/linux/install.sh
sh install.sh

# Conectar (deixe rodando durante TODOS os testes)
nordvpn connect

# Verificar se funciona
curl -s https://ifconfig.me
# Deve mostrar o IP da VPN, não o seu IP real
```

**Alternativas gratuitas:**
| VPN | Limite | Como usar |
|-----|--------|-----------|
| **ProtonVPN** | 10GB/mês | `sudo apt install protonvpn` |
| **Windscribe** | 10GB/mês | App no site oficial |
| **Mullvad** | 5€/mês (sem limite) | App no site oficial |

> **Atenção:** Em labs (TryHackMe, HackTheBox) você conecta pela VPN DA PLATAFORMA — não use VPN comercial junto, vai conflitar.

---

### Passo 2 — Instalar as ferramentas de exploração

```bash
# Atualizar índice de pacotes
sudo apt update

# Ferramentas principais (Kali já traz quase todas)
sudo apt install -y hydra john hashcat hashid medusa ncrack cewl crunch

# Metasploit + Searchsploit (se não vierem no Kali)
sudo apt install -y metasploit-framework exploitdb

# Verificar instalação
hydra -h | head -3
john --help | head -3
hashcat --version
searchsploit --version
msfconsole --version
```

**✅ Output esperado (hashcat):**
```
v6.2.6
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `hydra: command not found` | Não instalado | `sudo apt install hydra` |
| `msfconsole: command not found` | Metasploit ausente | `sudo apt install metasploit-framework` |
| `searchsploit: command not found` | ExploitDB ausente | `sudo apt install exploitdb` |
| Erro de repositório | Índice desatualizado | `sudo apt update` e tente de novo |
| Hashcat não acha GPU | Driver da GPU | Rode `hashcat -I` para diagnosticar; sem GPU use John |

---

### Passo 3 — Instalar e preparar wordlists

```bash
# SecLists (coleção completa)
sudo apt install -y seclists

# Descompactar rockyou (vem compactado no Kali)
sudo gzip -d /usr/share/wordlists/rockyou.txt.gz
ls -lh /usr/share/wordlists/rockyou.txt
# -rw-r--r-- 1 root root 139M rockyou.txt

# Verificar as principais listas
ls /usr/share/seclists/Passwords/Top1000.txt
ls /usr/share/seclists/Usernames/top-usernames-shortlist.txt
ls /usr/share/seclists/Discovery/Web-Content/common.txt
```

**✅ Output esperado:**
```
/usr/share/wordlists/rockyou.txt
/usr/share/seclists/Passwords/Top1000.txt
/usr/share/seclists/Usernames/top-usernames-shortlist.txt
/usr/share/seclists/Discovery/Web-Content/common.txt
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| `rockyou.txt.gz not found` | Já descompactado ou ausente | `sudo apt install wordlists` |
| SecLists ausente | Não instalado | `sudo apt install seclists` |
| Disco cheio ao descompactar | rockyou ocupa 139MB | `df -h` — libere espaço |

---

### Passo 4 — Metasploit: banco de dados e update

```bash
# Inicializar banco de dados do Metasploit (primeira vez)
msfdb init

# Iniciar o console
msfconsole

# Dentro do msfconsole — atualizar módulos
msf6 > search cache_expire:0
msf6 > exit
```

**✅ Output esperado (msfconsole — demora 30-60s para abrir):**
```
       =[ metasploit v6.3.44-dev                          ]
+ -- --=[ 2390 exploits - 1230 auxiliary                   ]
+ -- --=[ 413 payloads - 46 encoders - 11 nops             ]
+ -- --=[ 9 evasion plugins                                ]

msf6 >
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Msfconsole muito lento ao abrir | Banco de dados/primeira vez | Normal na primeira execução; espere |
| `msfdb: command not found` | Instalação incompleta | `sudo apt install --reinstall metasploit-framework` |
| Módulos desatualizados | Sem update | `sudo msfdb update && sudo msfdb reinit` |
| Sem permissão para exploit local | Rodou como usuário normal | Use `sudo -i` só quando o módulo exigir (ex: auxiliary/scanner) |

---

### Passo 5 — GPU para Hashcat (opcional, mas recomendado)

```bash
# Diagnosticar se o hashcat enxerga sua GPU
hashcat -I
```

**✅ Output esperado (com GPU NVIDIA):**
```
Backend Device ID #1 (alias: #1)
  Type           : GPU
  Vendor ID      : 10de
  Name           : NVIDIA GeForce GTX 1650
```

**❌ Se aparecer apenas CPU:** tudo bem — use `john` para hashes simples e hashcat em modo CPU (`-D 1`). GPU só acelera.

---

### Passo 6 — Configurar ProxyChains (opcional)

Para testes em que você NÃO pode aparecer com IP algum (raro em labs):

```bash
sudo apt install -y proxychains4 tor
sudo systemctl start tor
sudo nano /etc/proxychains4.conf
# No final: socks4 127.0.0.1 9050

# Testar
proxychains4 curl -s https://ifconfig.me
```

> **Limitação:** Tor é lento e muitos serviços SSH/FTP bloqueiam exit nodes. Prefira VPN.

---

### ⚠️ Regras de ouro de setup:

| Regra | Por quê |
|-------|---------|
| **SEMPRE use VPN para brute force** | Milhares de tentativas = seu IP nos logs + ban de ISP |
| **Confirme a autorização de brute force** | Nem todo escopo de pentest permite força bruta |
| **Comece com wordlist PEQUENA** | rockyou inteiro = horas + lockout garantido |
| **Use `-t 4` e `-f` no Hydra** | Poucas threads + parar no primeiro hit = menos rastro |
| **Nunca rode Hydra contra produção real** | Trava contas de gente de verdade |
| **Verifique seu IP antes de começar** | `curl -s https://ifconfig.me` deve mostrar VPN |

---

**Se completou tudo → Avance para [04 - Checklist Setup](04-checklist-setup.md)**
