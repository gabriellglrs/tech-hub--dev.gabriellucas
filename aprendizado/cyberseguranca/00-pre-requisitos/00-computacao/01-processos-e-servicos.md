# Processos e Servicos no Linux

> No arquivo anterior voce aprendeu o que sao processos e servicos. Agora voce vai aprender como **ver, gerenciar e controlar** processos e servicos no Linux — algo que voce vai fazer o tempo todo em seguranca.

---

## Por que voce precisa disso?

Quando voce instala e roda ferramentas de seguranca (Nmap, Metasploit, etc), elas se tornam processos. Quando voce configura servicos (SSH, web server), eles ficam rodando em background. Voce precisa saber como:

- **Ver** o que esta rodando
- **Matar** um processo que travou
- **Iniciar e parar** servicos
- **Verificar** se um servico esta ativo

---

## Gerenciando Processos

### Ver processos rodando

```bash
# Lista todos os processos do usuario atual
ps

# Lista TODOS os processos (mais detalhes)
ps aux

# Saida exemplo:
# USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
# root         1  0.0  0.1 169432 13292 ?        Ss   Aug01   0:12 /sbin/init
# kali      1234  0.2  1.5 234567 45678 pts/0    Ss   10:00   0:05 /bin/bash
# kali      5678  1.3  2.1 345678 67890 pts/0    Sl   10:05   0:30 nmap -sV 192.168.1.1
```

### Entendendo a saida

| Coluna | O que significa |
|:-------|:----------------|
| **USER** | Quem esta rodando o processo |
| **PID** | Numero identificador do processo |
| **%CPU** | Quanto da CPU esta usando |
| **%MEM** | Quanto da memoria esta usando |
| **COMMAND** | Qual programa esta rodando |

### Processos em tempo real

```bash
# Monitor de processos (atualiza a cada 2 segundos)
top

# Versao mais amigavel
htop
```

### Matar processos

```bash
# Matar processo pelo PID
kill 5678

# Matar forcadamente (se kill nao funcionar)
kill -9 5678

# Matar todos os processos de um programa
killall nmap

# Matar processo pelo nome
pkill firefox
```

### Exemplo pratico

```bash
# Voce rodou um Nmap e ele travou. Como resolver?

# 1. Ache o PID do Nmap
ps aux | grep nmap
# Output: kali  5678  1.3  2.1  nmap -sV 192.168.1.1

# 2. Mate o processo
kill 5678

# 3. Verifique se morreu
ps aux | grep nmap
# Output: (nenhum resultado = processo morto)
```

---

## Gerenciando Servicos (systemd/systemctl)

### O que e systemctl?

`systemctl` e o comando para gerenciar servicos no Linux moderno. Com ele voce pode iniciar, parar, reiniciar e verificar o status de servicos.

### Comandos essenciais

```bash
# Ver status de um servico
sudo systemctl status sshd

# Output esperado (servico ativo):
# ● ssh.service - OpenBSD Secure Shell server
#      Loaded: loaded (/lib/systemd/system/ssh.service; enabled)
#      Active: active (running) since Mon 2026-09-01 10:00:00 UTC
#      Main PID: 1234 (sshd)

# Iniciar um servico
sudo systemctl start sshd

# Parar um servico
sudo systemctl stop sshd

# Reiniciar um servico
sudo systemctl restart sshd

# Habilitar servico para iniciar com o computador
sudo systemctl enable sshd

# Desabilitar servico (nao inicia mais com o computador)
sudo systemctl disable sshd
```

### Listar servicos

```bash
# Listar todos os servicos ativos
systemctl list-units --type=service

# Listar servicos que falharam
systemctl --failed

# Listar todos os servicos instalados
systemctl list-unit-files --type=service
```

### Exemplo pratico: Verificar SSH

```bash
# Ver se o SSH esta rodando
sudo systemctl status sshd

# Se estiver "active (running)", o SSH esta aceitando conexoes
# Se estiver "inactive (dead)", o SSH esta parado

# Para iniciar o SSH
sudo systemctl start sshd

# Para verificar na porta
ss -tlnp | grep :22
# Output: LISTEN  0  128  0.0.0.0:22  0.0.0.0:*  users:(("sshd",pid=1234))
```

---

## O que sao Daemon Names?

No Linux, servicos em background sao chamados de **daemons**. O nome do daemon geralmente termina com "d":

| Daemon | Servico | O que faz |
|:-------|:--------|:----------|
| **sshd** | SSH Server | Acesso remoto via terminal |
| **httpd** | Apache Web Server | Hospeda sites web |
| **nginx** | Nginx Web Server | Hospeda sites web (alternativa) |
| **mysqld** | MySQL Server | Banco de dados |
| **cron** | Agendador de tarefas | Executa tarefas automaticamente |
| **systemd** | Sistema de init | Gerencia todos os outros daemons |

---

## Verificando Portas em Uso

### O que e ss?

`ss` (socket statistics) e o comando moderno para ver conexoes de rede e portas em uso. E o substituto do `netstat`.

### Comandos essenciais

```bash
# Ver portas TCP em escuta
ss -tlnp

# Saida exemplo:
# State   Recv-Q  Send-Q  Local Address:Port  Process
# LISTEN  0       128     0.0.0.0:22          users:(("sshd",pid=1234))
# LISTEN  0       128     0.0.0.0:80          users:(("nginx",pid=2345))
# LISTEN  0       128     0.0.0.0:443         users:(("nginx",pid=2345))
```

### Entendendo as flags

| Flag | O que faz |
|:-----|:----------|
| `-t` | Mostrar apenas portas TCP |
| `-u` | Mostrar apenas portas UDP |
| `-l` | Mostrar apenas portas em escuta (listening) |
| `-n` | Mostrar numeros de porta (nao nomes) |
| `-p` | Mostrar o processo (PID/nome) que usa a porta |

### Exemplo pratico

```bash
# Quais servicos estao rodando no meu computador?
ss -tlnp

# Output:
# PORTA 22  → sshd (SSH)
# PORTA 80  → nginx (web server)
# PORTA 443 → nginx (HTTPS)
# PORTA 3306 → mysqld (banco de dados)

# Isso significa que:
# - Alguem pode acessar meu computador via SSH (porta 22)
# - Meu site esta na porta 80
# - Meu banco de dados esta na porta 3306
```

---

## Logs: Onde ficam os registros

### O que sao logs?

Logs sao registros de tudo que acontece no sistema. Cada servico, cada login, cada erro — tudo fica salvo em arquivos de log.

### Onde ficam?

```
/var/log/
├── auth.log        ← Log de autenticacao (logins, tentativas)
├── syslog          ← Log geral do sistema
├── kern.log        ← Log do kernel
├── apache2/        ← Logs do Apache
├── nginx/          ← Logs do Nginx
└── mysql/          ← Logs do MySQL
```

### Como ver logs?

```bash
# Ver ultimas 20 linhas do log do sistema
sudo tail -20 /var/log/syslog

# Ver log de autenticacao (quem tentou logar)
sudo tail -20 /var/log/auth.log

# Ver logs em tempo real
sudo tail -f /var/log/auth.log
```

### Relacao com Cybersecurity

Logs sao **essenciais** para seguranca. Eles mostram:
- Quem tentou acessar o sistema
- De onde veio o ataque
- O que o atacante fez
- Se houve falhas de seguranca

Durante um pentest, analisar logs e parte do reconhecimento. Durante defesa, logs sao a primeira pista para detectar ataques.

---

## Pipes (|) — Conectando comandos

### O que e um pipe?

Um pipe (`|`) pega a **saida** de um comando e usa como **entrada** do proximo comando. E como uma esteira de montagem — o resultado de um passo vai para o proximo.

### Como funciona?

```bash
# SEM pipe: ve todos os processos (muita informacao)
ps aux

# COM pipe: filtra so os processos do Nmap
ps aux | grep nmap

# COM pipe: ve as ultimas 5 linhas
ps aux | tail -5

# COM pipe: conta quantos processos existem
ps aux | wc -l
```

### Analogia

```
COMANDO 1          PIPE           COMANDO 2
ps aux            |            grep nmap
   │                              │
   │  Mostra todos os             │  Filtra so os que
   │  processos                   │  contem "nmap"
   │                              │
   └──────► Resultado vai ───────►┘
            para grep
```

### Exemplo pratico para seguranca

```bash
# Ver quais processos estao usando a rede
ss -tunp | grep ESTABLISHED

# Ver processos do Nmap
ps aux | grep nmap

# Ver logs de autenticacao recentes (ultimas 50 linhas)
sudo tail -50 /var/log/auth.log | grep "Failed password"

# Ver quais portas estao abertas e quem as usa
ss -tlnp | awk '{print $4, $6}'
```

### Por que pipes sao criticos?

No Módulo 01 (Reconhecimento), voce vai usar pipelines como:

```bash
# Pipeline de reconhecimento
subfinder -d target.com -silent | httpx -mc 200 | nuclei -severity critical,high
```

Isso significa:
1. `subfinder` descobre subdominios
2. `|` envia os resultados para o proximo comando
3. `httpx` verifica quais estao ativos
4. `|` envia os URLs ativos para o proximo
5. `nuclei` scan de vulnerabilidades

Sem entender pipes, esse pipeline e confuso. Com pipes, e logico.

---

## Exercicio Practico

### Exercicio 1: Processos

1. Abra o terminal e rode `ps aux | wc -l` — quantos processos estao rodando?
2. Rode `ps aux | grep bash` — quantos shells bash estao abertos?
3. Abra outro terminal (Ctrl+Shift+T) e repita — o numero mudou?

### Exercicio 2: Servicos

1. Rode `sudo systemctl status sshd` — o SSH esta ativo?
2. Rode `ss -tlnp | grep :22` — o SSH esta escutando na porta 22?
3. Rode `ss -tlnp` — quantos servicos estao escutando portas?

### Exercicio 3: Pipes

1. Rode `ps aux | grep root` — quais processos rodam como root?
2. Rode `ss -tlnp | grep LISTEN` — quais portas estao abertas?
3. Rode `ls /var/log/` — quais arquivos de log existem?

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Ver processos com `ps aux`
- [ ] Matar um processo com `kill`
- [ ] Verificar status de servicos com `systemctl`
- [ ] Ver portas abertas com `ss -tlnp`
- [ ] Usar pipes para conectar comandos
- [ ] Entender onde ficam logs no Linux

---

<div align="center">

**⬅️ [Anterior: O que e um Computador](00-o-que-e-computador.md)** | **[Proximo: Cliente e Servidor](02-cliente-e-servidor.md) ➡️**

</div>
