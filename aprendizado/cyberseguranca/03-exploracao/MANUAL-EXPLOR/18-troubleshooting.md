## Apêndice A — Troubleshooting

### Ferramenta não encontrada

| Ferramenta | Comando para instalar |
|------------|----------------------|
| hydra | `sudo apt install hydra` |
| john | `sudo apt install john` |
| hashcat | `sudo apt install hashcat` |
| hashid | `sudo apt install hashid` |
| medusa | `sudo apt install medusa` |
| ncrack | `sudo apt install ncrack` |
| metasploit | `sudo apt install metasploit-framework` |
| searchsploit | `sudo apt install exploitdb` |
| cewl | `sudo apt install cewl` |
| crunch | `sudo apt install crunch` |
| seclists | `sudo apt install seclists` |
| unshadow | `sudo apt install john` |

### Brute force muito lento

| Causa | Solução |
|-------|---------|
| Hydra com threads altas | Use `-t 4` (acelera a rede segura, não o alvo) |
| Wordlist gigante (rockyou) | Use `Top1000.txt` primeiro; rockyou é para OFFLINE |
| Rede/lab lento | Reduza `-t 2`; verifique ping para o alvo |
| HTTP com WAF | `-t 1 -W 3` (1 tentativa, 3s de espera) |
| Muitos usuários | Fixe o usuário (`-l`) quando só quer senha |

### Brute force bloqueado

| Causa | Solução |
|-------|---------|
| IP banido (fail2ban) | Pare, mude de IP (VPN), espere 30min |
| Conta travada (lockout) | **PARE IMEDIATAMENTE** — troque de usuário e reduza tentativas |
| WAF HTTP 429 | `-t 1 -W 10`; se persistir, mude de vetor |
| ISP bloqueou | Reconecte VPN |
| Hydra retorna "0 valid" instantâneo | Suspeite de bloqueio — teste com `-v` para ver tentativas |

### Cracking sem resultados

| Causa | Solução |
|-------|---------|
| Formato errado | Rode `hashid` e force: `john --format=raw-md5` |
| Wordlist fraca | Adicione `--rules` (John) ou `-r best64.rule` (Hashcat) |
| Hash lixo (falso positivo do grep) | Filtre só hashes de 32/40/64 chars: `grep -E "^[a-f0-9]{32}$"` |
| Hashcat sem GPU | Use John, ou `hashcat -D 1` (CPU) |
| `Token length exception` | Hash malformado — remova da lista |
| bcrypt muito lento | É por design — deixe rodando horas ou use GPU |

### Metasploit com problemas

| Causa | Solução |
|-------|---------|
| Msfconsole não abre | `sudo apt install --reinstall metasploit-framework` |
| `no session created` | Troque o payload; confirme com `check`; verifique LHOST |
| LHOST errado | `ip addr show` — use o IP da interface do lab/VPN |
| `Exploit completed, but no session` | EDR/antivírus bloqueou — tente payload com encoder ou reverse em 443 |
| Sessão morre ao usar | `set DisablePayloadHandler false`; use shell simples em vez de meterpreter |
| Módulo não encontrado | `search <termo>`; atualize: `sudo msfdb update` |

### Output vazio / sem resultados

| Ferramenta | Possível causa | Solução |
|------------|---------------|---------|
| Hydra (HTTP) | String `F=` errada | Erre o login manualmente e copie a mensagem exata |
| Hydra (SSH) | IP banido | Verifique com `ssh user@host` manualmente |
| CeWL | Site exige JS | `cewl -e "Mozilla/5.0..."` ou pule |
| Searchsploit | Exploit-DB desatualizado | `searchsploit -u` (update) |
| hashid | Formato exótico | https://hashcat.net/wiki/doku.php?id=example_hashes |

### Falha de permissão

| Erro | Solução |
|------|---------|
| `Permission denied` ao rodar script | `chmod +x script.sh` |
| Porta baixa (<1024) no nc | `sudo nc -lvnp 80` |
| Metasploit sem acesso a device | `sudo -i` e rode msfconsole como root |
| Rockyou não encontrado | `sudo gzip -d /usr/share/wordlists/rockyou.txt.gz` |

---
