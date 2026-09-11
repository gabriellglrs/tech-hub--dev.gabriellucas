# Conceitos de Segurança

> Antes de aprender a atacar, você precisa entender o que é segurança e por que ataques funcionam.

---

## O que são Conceitos de Segurança?

**Segurança da informação** é o conjunto de práticas para proteger dados contra acesso não autorizado, destruição ou alteração.

```
TRIÂDE CIA
         Confidencialidade
               /\
              /  \
             / CIA \
            /________\
Integridade    Disponibilidade

CONTROLES
├── Preventivos (evitam o ataque)
├── Detectivos (descobrem o ataque)
└── Corretivos (respondem ao ataque)
```

---

## Triade CIA

| Pilar | O que protege | Exemplo de ataque |
|:------|:--------------|:------------------|
| **Confidencialidade** | Dados só quem pode ver | Vazamento de senhas |
| **Integridade** | Dados não são alterados | SQL Injection |
| **Disponibilidade** | Sistema funciona quando precisa | DDoS |

---

## Tipos de Ameaças

| Tipo | O que é | Exemplo |
|:-----|:--------|:--------|
| **Script Kiddie** | Iniciante usando ferramentas prontas | Usar Metasploit sem entender |
| **Hacker** | Expert técnico | Exploração zero-day |
| **Insider** | Funcionário da empresa | Vazamento interno |
| **APT** | Grupo organizado (estados) | APT28 (Rússia) |

---

## Tipos de Malware

| Tipo | O que faz | Propagação |
|:-----|:----------|:-----------|
| **Vírus** | Se anexa a arquivos | Arquivos infectados |
| **Worm** | Se espalha sozinho pela rede | Rede |
| **Trojan** | Finge ser algo útil | Downloads falsos |
| **Ransomware** | Sequestra dados e cobra resgate | Email, RDP |
| **Spyware** | Espia suas ações | Software gratuito |
| **Rootkit** | Esconde processos maliciosos | Exploração |
| **Keylogger** | Grava o que você digita | Trojan |

---

## Vetores de Ataque

| Vetor | O que é | Como se proteger |
|:------|:--------|:-----------------|
| **Email** | Phishing, anexos maliciosos | Não clique em links suspeitos |
| **Web** | XSS, SQL Injection | Atualizar, usar WAF |
| **Rede** | Man-in-the-Middle | Usar HTTPS, VPN |
| **USB** | Dispositivos infectados | Não pluge USB desconhecido |
| **Social Engineering** | Enganar o humano | Treinamento, desconfiança |
| **Força Bruta** | Testar senhas | Senhas fortes, 2FA |

---

## Tool Card: fail2ban

**O que é:** Intrusion Prevention System que monitora logs e bloqueia IPs com muitas tentativas falhas de login.

### Instalação

```bash
sudo apt install -y fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### Verificar status

```bash
# Output esperado:
sudo fail2ban-client status
# Status
# |- Number of jail:      1
# `- Jail list:   sshd

sudo fail2ban-client status sshd
# Status for the jail: sshd
# |- Filter
# |  |- Currently failed: 3
# |  |- Number of failures: 15
# |  `- Journal matches: _SYSTEMD_UNIT=sshd.service + _COMM=sshd
# `- Actions
#    |- Currently banned: 2
#    |- Total banned: 5
#    `- Banned IP list: 192.168.1.100 10.0.0.50
```

### Configurar proteção SSH

```bash
# Criar configuração local
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Editar configuração
sudo nano /etc/fail2ban/jail.local
```

```ini
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600
findtime = 600
```

| Parâmetro | O que faz |
|:----------|:----------|
| `maxretry = 3` | Banir após 3 tentativas falhas |
| `bantime = 3600` | Banir por 1 hora (3600 segundos) |
| `findtime = 600` | Contar tentativas nos últimos 10 min |

### Reiniciar para aplicar

```bash
sudo systemctl restart fail2ban
```

---

## Tool Card: ufw (Uncomplicated Firewall)

**O que é:** Interface simplificada para gerenciar iptables — firewall do Linux.

### Instalação

```bash
sudo apt install -y ufw
```

### Regras básicas

```bash
# Output esperado:
# Verificar status
sudo ufw status
# Status: inactive

# Habilitar firewall
sudo ufw enable
# Firewall is active and enabled on system startup

# Definir política padrão
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Permitir SSH (IMPORTANTE — caso contrário perde acesso)
sudo ufw allow ssh

# Permitir porta específica
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Verificar regras
sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22/tcp                     ALLOW IN    Anywhere
[ 2] 80/tcp                     ALLOW IN    Anywhere
[ 3] 443/tcp                    ALLOW IN    Anywhere
```

### Remover regra

```bash
# Remover por número
sudo ufw delete 2

# Remover por regra
sudo ufw delete allow 80/tcp
```

---

## Tool Card: chmod / chown

**O que é:** Gerenciam permissões de arquivos e diretórios no Linux.

### Permissões

```
rwxr-xr-x
│││ │││ │││
│││ │││ └┴┴── Outro (other)
│││ └┴┴────── Grupo (group)
└┴┴────────── Dono (user)

r = ler (4)    w = escrever (2)    x = executar (1)
```

### chmod — Mudar permissões

```bash
# Ver permissões atuais
ls -l arquivo.txt
# -rw-r--r-- 1 user user 1024 Sep 10 10:00 arquivo.txt
#  ││││││││
#  │└┴┴└┴┴┴── Permissões (dono/grupo/outro)
#  └──────── Tipo (- = arquivo, d = diretório)

# Modo numérico (mais comum)
chmod 755 script.sh    # rwxr-xr-x (executável)
chmod 644 arquivo.txt  # rw-r--r-- (leitura)
chmod 600 senhas.txt   # rw------- (só dono lê/escreve)

# Modo simbólico
chmod u+x script.sh    # Adicionar execução para dono
chmod g-w arquivo.txt  # Remover escrita do grupo
chmod o-rwx private/   # Remover todas permissões do outro
```

### chown — Mudar dono

```bash
# Mudar dono
sudo chown www-data:www-data /var/www/html

# Mudar recursivamente
sudo chown -R www-data:www-data /var/www/html

# Verificar
ls -ld /var/www/html
# drwxr-xr-x 2 www-data www-data 4096 Sep 10 10:00 /var/www/html
```

---

## Tool Card: passwd

**O que é:** Gerenciar senhas de usuários no Linux.

### Gerenciar senhas

```bash
# Mudar senha do usuário atual
passwd
# (current) UNIX password: 
# New password: 
# Retype new password: 
# passwd: password updated successfully

# Mudar senha de outro usuário (root)
sudo passwd usuario

# Verificar política de senha
cat /etc/login.defs | grep -E "^PASS_"
# PASS_MAX_DAYS   99999
# PASS_MIN_DAYS   0
# PASS_MIN_LEN    5
# PASS_WARN_AGE   7
```

### Configurar política forte

```bash
# Editar /etc/login.defs
sudo nano /etc/login.defs
```

| Parâmetro | Valor recomendado | O que faz |
|:----------|:------------------|:----------|
| `PASS_MAX_DAYS` | 90 | Senha expira a cada 90 dias |
| `PASS_MIN_DAYS` | 7 | Não permite mudar senha em menos de 7 dias |
| `PASS_MIN_LEN` | 12 | Senha mínima de 12 caracteres |
| `PASS_WARN_AGE` | 14 | Avisa 14 dias antes de expirar |

### Criar usuário com política forte

```bash
# Criar usuário
sudo useradd -m -s /bin/bash novousuario

# Definir senha
sudo passwd novousuario

# Verificar
id novousuario
# uid=1001(novousuario) gid=1001(novousuario) groups=1001(novousuario)
```

---

## Princípios de Segurança

| Princípio | O que significa | Exemplo |
|:----------|:----------------|:--------|
| **Least Privilege** | Menor permissão possível | Usuário comum sem sudo |
| **Defense in Depth** | Múltiplas camadas | Firewall + IDS + Antivírus |
| **Zero Trust** | Não confiar em ninguém | Verificar tudo, sempre |
| **Separation of Duties** | Dividir responsabilidades | Quem aprova não executa |
| **Need to Know** | Só quem precisa vê | Dados sensíveis restritos |

---

## Exercício 1: Configurar fail2ban

**Objetivo:** Proteger SSH contra força bruta.

```bash
# 1. Instalar e habilitar fail2ban
sudo apt install -y fail2ban
sudo systemctl enable fail2ban

# 2. Criar configuração local
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# 3. Editar configuração para SSH
sudo nano /etc/fail2ban/jail.local
# Adicionar:
# [sshd]
# enabled = true
# maxretry = 3
# bantime = 3600

# 4. Reiniciar
sudo systemctl restart fail2ban

# 5. Verificar status
sudo fail2ban-client status sshd
```

---

## Exercício 2: Configurar UFW e permissões

**Objetivo:** Configurar firewall e verificar permissões de arquivos.

```bash
# 1. Habilitar UFW
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh

# 2. Criar arquivo sensível
echo "senha=MinhaSenh@123" > senhas.txt
chmod 600 senhas.txt
ls -l senhas.txt
# -rw------- 1 user user 25 Sep 10 10:00 senhas.txt

# 3. Criar script executável
echo '#!/bin/bash' > teste.sh
echo 'echo "Hello World"' >> teste.sh
chmod +x teste.sh
./teste.sh
# Hello World

# 4. Verificar regras
sudo ufw status numbered
```

---

## Checkpoint

- [ ] Consigo explicar a triade CIA
- [ ] Sei a diferença entre vírus, worm e trojan
- [ ] Conheço os principais vetores de ataque
- [ ] Consigo instalar e configurar fail2ban
- [ ] Consigo configurar regras de firewall com UFW
- [ ] Entendo permissões de arquivo (chmod/chown)
- [ ] Consigo gerenciar senhas com passwd

---

## Labs Práticos

👉 **[Acessar LABS.md](../LABS.md)** — 8 labs organizados por plataforma

---

<div align="center">

**⬅️ [Anterior: Máquinas Virtuais](../02-sistemas/08-maquinas-virtuais.md)** | **[Próximo: Python Básico](10-python-basico.md) ➡️**

</div>
