# 🖥️ Comandos Linux — Do Básico ao Avançado

> Guia completo de comandos Linux para uso diário e cybersegurança. Copie, cole, use.

---

## 📚 O que é o Terminal?

O **terminal** (linha de comando) é a forma mais poderosa de interagir com o Linux. Enquanto a interface gráfica mostra botões, o terminal mostra o poder real do sistema.

### Por que usar o terminal?

- **Velocidade** — um comando faz o que 10 cliques fazem
- **Automação** — scripts executam tarefas repetitivas
- **Remoto** — SSH funciona em qualquer lugar
- **Recursos** — menos uso de RAM que interfaces gráficas
- **Segurança** — essencial para servidores e cybersegurança

---

## 🔰 Nível 1: Básico (Primeiros Passos)

### Navegação

```bash
# Onde estou?
$ pwd
/home/devgabriellucas

# Listar arquivos (formato simples)
$ ls
Documentos  Downloads  Imagens  Músicas  Vídeos

# Listar detalhado (com permissões, dono, tamanho, data)
$ ls -la
total 32
drwxr-xr-x 5 devgabriellucas devgabriellucas 4096 mar 10 14:30 .
drwxr-xr-x 3 root            root            4096 mar 10 14:20 ..
-rw-r--r-- 1 devgabriellucas devgabriellucas  220 mar 10 14:20 .bash_logout
-rw-r--r-- 1 devgabriellucas devgabriellucas 3771 mar 10 14:20 .bashrc
drwxr-xr-x 2 devgabriellucas devgabriellucas 4096 mar 10 14:30 Documentos

# Listar ocultos (arquivos que começam com .)
$ ls -la | grep "^\."
-rw-r--r-- 1 devgabriellucas devgabriellucas  220 mar 10 14:20 .bash_logout

# Listar por tamanho (maior primeiro)
$ ls -lhS
-rw-r--r-- 1 devgabriellucas devgabriellucas 1.2G mar 10 14:30 video.mp4
-rw-r--r-- 1 devgabriellucas devgabriellucas 450M mar 10 14:25 backup.tar.gz
-rw-r--r-- 1 devgabriellucas devgabriellucas  12K mar 10 14:20 config.txt

# Listar por data (mais recente primeiro)
$ ls -ltr
total 20
-rw-r--r-- 1 devgabriellucas devgabriellucas  220 mar 10 14:20 .bash_logout
-rw-r--r-- 1 devgabriellucas devgabriellucas 3771 mar 10 14:20 .bashrc
drwxr-xr-x 2 devgabriellucas devgabriellucas 4096 mar 10 14:35 Downloads  ← mais novo

# Entrar em pasta
$ cd /home/devgabriellucas/Documentos
$ pwd
/home/devgabriellucas/Documentos

# Voltar uma pasta
$ cd ..
$ pwd
/home/devgabriellucas

# Voltar para home
$ cd ~
$ pwd
/home/devgabriellucas

# Voltar para pasta anterior (alterna entre as duas)
$ cd /var/log
$ pwd
/var/log
$ cd -
$ pwd
/home/devgabriellucas
```

### Ver Arquivos

```bash
# Mostrar todo o conteúdo (ruim para arquivos grandes)
$ cat /etc/hostname
DESKTOP-FGAQDIS

# Mostrar com numeração de linhas
$ cat -n /etc/passwd | head -5
     1	root:x:0:0:root:/root:/bin/bash
     2	daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
     3	bin:x:2:2:bin:/bin:/usr/sbin/nologin
     4	sys:x:3:3:sys:/dev:/usr/sbin/nologin
     5	sync:x:4:65534:sync:/bin:/bin/sync

# Primeiras 20 linhas
$ head -20 /var/log/syslog
mar 10 14:20:15 DESKTOP systemd[1]: Started Session 1 of User devgabriellucas.
mar 10 14:20:15 DESKTOP systemd[842]: Reached target Paths.
mar 10 14:20:15 DESKTOP systemd[842]: Started OpenBSD Secure Shell server.

# Últimas 20 linhas (útil para logs)
$ tail -20 /var/log/auth.log
mar 10 14:30:22 DESKTOP sudo: devgabriellucas : TTY=pts/0 ; PWD=/home/devgabriellucas ; USER=root ; COMMAND=/usr/bin/apt update

# Últimas linhas EM TEMPO REAL (ctrl+C para sair)
$ tail -f /var/log/syslog

# Contar linhas
$ wc -l /etc/passwd
42 /etc/passwd

# Contar palavras
$ wc -w /etc/passwd
63 /etc/passwd

# Tipo do arquivo
$ file imagem.png
imagem.png: PNG image data, 1920 x 1080, 8-bit/color RGB

$ file script.sh
script.sh: Bourne-Again shell script, ASCII text executable
```

### Criar e Editar

```bash
# Criar arquivo vazio
$ touch novo.txt
$ ls -la novo.txt
-rw-r--r-- 1 devgabriellucas devgabriellucas 0 mar 10 14:40 novo.txt

# Criar pasta
$ mkdir projetos
$ ls -la | grep projetos
drwxr-xr-x 2 devgabriellucas devgabriellucas 4096 mar 10 14:40 projetos

# Criar pasta com subpastas
$ mkdir -p projetos/web/css projetos/web/js
$ ls -R projetos/
projetos/:
web

projetos/web:
css js

# Copiar arquivo
$ cp arquivo.txt copia.txt
$ ls -la | grep arquivo
-rw-r--r-- 1 devgabriellucas devgabriellucas 1234 mar 10 14:40 arquivo.txt
-rw-r--r-- 1 devgabriellucas devgabriellucas 1234 mar 10 14:40 copia.txt

# Copiar pasta inteira
$ cp -r projetos/ projetos_backup/

# Renomear arquivo
$ mv antigo.txt novo_nome.txt

# Mover arquivo para outra pasta
$ mv arquivo.txt /tmp/

# Deletar arquivo (CUIDADO! não tem "lixeira")
$ rm arquivo.txt

# Deletar pasta com tudo dentro
$ rm -rf pasta_antiga/

# Deletar todos os .txt da pasta atual
$ rm *.txt
```

### Ajuda

```bash
# Manual completo do comando (q para sair)
$ man ls
LS(1)                        User Commands                        LS(1)

NAME
       ls - list directory contents

SYNOPSIS
       ls [OPTION]... [FILE]...

# Ajuda rápida
$ ls --help
Usage: ls [OPTION]... [FILE]...
List information about the FILEs...

# Onde está o comando
$ which python
/usr/bin/python3

$ which nmap
/usr/bin/nmap

# Tipo do comando
$ type ls
ls is aliased to `ls --color=auto'

$ type cd
cd is a shell builtin
```

---

## 🔧 Nível 2: Intermediário (Dia a Dia)

### Permissões

```bash
# Ver permissões
$ ls -la script.sh
-rwxr-xr-- 1 devgabriellucas devgabriellucas 1024 mar 10 14:50 script.sh
││││││││││
│││││││└┴┴── Outros (r-- = 4)
│││││└┴────── Grupo (r-x = 5)
│││└┴──────── Dono (rwx = 7)
│└─────────── Tipo (- = arquivo, d = pasta, l = link)

# Permissões numéricas
r = 4 (leitura)
w = 2 (escrita)
x = 1 (execução)

chmod 755 = rwxr-xr-x  (dono: tudo, grupo/outros: ler+executar)
chmod 644 = rw-r--r--  (dono: ler+escrever, grupo/outros: ler)
chmod 700 = rwx------  (só o dono pode fazer tudo)
chmod 777 = rwxrwxrwx  (todos fazem tudo) ← NUNCA usar isso!

# Dar permissão de execução
$ chmod +x script.sh
$ ls -la script.sh
-rwxr-xr-x 1 devgabriellucas devgabriellucas 1024 mar 10 14:50 script.sh

# Agora posso rodar
$ ./script.sh

# Remover permissão de escrita para outros
$ chmod o-w arquivo.txt

# Mudar dono
$ sudo chown root:root /etc/arquivo

# Mudar dono recursivamente
$ sudo chown -R www-data:www-data /var/www/
```

### Usuários e Grupos

```bash
# Quem sou eu?
$ whoami
devgabriellucas

# Informações completas
$ id
uid=1000(devgabriellucas) gid=1000(devgabriellucas) groups=1000(devgabriellucas),27(sudo),33(www-data)

# Criar usuário
$ sudo useradd -m -s /bin/bash joao
$ sudo passwd joao
New password: ********

# Criar usuário com expiration
$ sudo useradd -m -e 2026-12-31 -s /bin/bash estagiario

# Deletar usuário
$ sudo userdel -r usuario_antigo

# Criar grupo
$ sudo groupadd desenvolvedores

# Adicionar usuário ao grupo
$ sudo usermod -aG desenvolvedores joao
$ sudo usermod -aG sudo joao          # dar sudo
$ sudo usermod -aG www-data joao      # acesso ao web server

# Ver grupos de um usuário
$ groups joao
joao : joao desenvolvedores sudo

# Listar todos os usuários
$ cat /etc/passwd | grep -v nologin | grep -v false
root:x:0:0:root:/root:/bin/bash
devgabriellucas:x:1000:1000:devgabriellucas:/home/devgabriellucas:/bin/bash
joao:x:1001:1001:joao,,,:/home/joao:/bin/bash

# Listar todos os grupos
$ getent group
root:x:0:
sudo:x:27:devgabriellucas,joao
www-data:x:33:
devgabriellucas:x:1000:
desenvolvedores:x:1002:joao
```

### Processos

```bash
# Ver processos do usuário atual
$ ps aux | head -5
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
devgabr+  1234  0.0  0.1  16844  3200 pts/0    Ss   14:20   0:00 -zsh
devgabr+  5678  2.1  5.4 1234560 89012 pts/0   Sl+  14:25   0:15 firefox
devgabr+  9012  0.5  1.2  456780 19800 pts/0   S+   14:30   0:03 code

# Ver processos de um programa específico
$ ps aux | grep firefox
devgabr+  5678  2.1  5.4 1234560 89012 pts/0   Sl+  14:25   0:15 /usr/lib/firefox/firefox

# Matar processo por PID
$ kill 5678

# Matar processo forçadamente (não recomenda)
$ kill -9 5678

# Matar todos os processos de um programa
$ killall firefox

# Ver processos em tempo real (q para sair)
$ top
  PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
  5678 devgabr+  20   0 1234560 89012  34567 S   2.1   5.4   0:15.23 firefox
  9012 devgabr+  20   0  456780 19800  12345 S   0.5   1.2   0:03.45 code

# Processos por memória (top 10)
$ ps aux --sort=-%mem | head -11
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
devgabr+  5678  2.1  5.4 1234560 89012 pts/0   Sl+  14:25   0:15 firefox
devgabr+  9012  0.5  1.2  456780 19800 pts/0   S+   14:30   0:03 code

# Processos por CPU (top 10)
$ ps aux --sort=-%cpu | head -11

# Rodar comando em background
$ long_script.sh &

# Ver processos em background
$ jobs
[1]+  Running                 long_script.sh &

# Trazer para foreground
$ fg 1

# Rodar processo que sobrevive logout
$ nohup long_script.sh &
```

### Redirecionamento e Pipes

```bash
# Salvar saída em arquivo (sobrescreve)
$ ls -la > lista.txt

# Adicionar ao final do arquivo
$ echo "nova linha" >> lista.txt

# Pipe: usar saída de um como entrada de outro
$ ls -la | grep ".txt"
-rw-r--r-- 1 devgabriellucas devgabriellucas  123 mar 10 14:50 notas.txt
-rw-r--r-- 1 devgabriellucas devgabriellucas  456 mar 10 14:51 lista.txt

# Vários pipes encadeados
$ cat /etc/passwd | cut -d':' -f1 | sort | head -10
bin
daemon
devgabriellucas
games
gnats
irc
joao
list
lp
mail

# E se o primeiro comando falhar, execute o segundo
$ cd /pasta/que/nao/existe || echo "Pasta não encontrada!"
Pasta não encontrada!

# E só execute o segundo se o primeiro funcionar
$ mkdir nova_pasta && cd nova_pasta && pwd
/home/devgabriellucas/nova_pasta

# Executar sequencialmente (independente do resultado)
$ echo "começou" ; sleep 2 ; echo "terminou"
começou
(2 segundos depois)
terminou

# Redirecionar stdout E stderr para arquivo
$ comando > arquivo.txt 2>&1

# Só redirecionar stderr
$ comando 2> erros.txt

# Jogar stderr no lixo
$ comando 2>/dev/null

# Tee: salvar saída E mostrar na tela
$ ls -la | tee lista.txt | wc -l
25
```

### Busca e Localização

```bash
# Buscar por nome
$ find /home -name "*.txt"
/home/devgabriellucas/notas.txt
/home/devgabriellucas/Documentos/relatorio.txt

# Buscar case insensitive
$ find /home -iname "*.TXT"
/home/devgabriellucas/notas.txt

# Buscar só arquivos (não pastas)
$ find /home -name "*.py" -type f
/home/devgabriellucas/projetos/main.py
/home/devgabriellucas/scripts/backup.py

# Buscar só pastas
$ find /home -type d -name "projetos"
/home/devgabriellucas/projetos

# Arquivos maiores que 100MB
$ find / -size +100M -type f 2>/dev/null
/var/cache/apt/archives/linux-image-6.5.0-generic_6.5.0_amd64.deb
/swapfile

# Arquivos modificados nos últimos 7 dias
$ find /home -mtime -7 -type f
/home/devgabriellucas/notas.txt
/home/devgabriellucas/projetos/main.py

# Arquivos modificados na última hora
$ find /home -mmin -60 -type f

# Arquivos com SUID (importante para segurança!)
$ find / -perm -4000 -type f 2>/dev/null
/usr/bin/passwd
/usr/bin/sudo
/usr/bin/newgrp
/usr/bin/chsh
/usr/bin/chfn

# Pastas graváveis por qualquer pessoa
$ find / -type d -perm -o+w 2>/dev/null | head
/tmp
/var/tmp
/dev/shm

# Buscar e executar comando em cada resultado
$ find /home -name "*.log" -exec rm {} \;

# Buscar conteúdo em arquivos (recursivo)
$ grep -r "password" /etc/ --include="*.conf"
/etc/mysql/debian.cnf:password = senha123

# Buscar case insensitive
$ grep -ri "error" /var/log/syslog
mar 10 14:20:15 DESKTOP kernel: [   0.123456] Error: something failed

# Buscar com contexto (3 linhas antes e depois)
$ grep -A 3 -B 3 "exception" app.log
2024-03-10 14:20:15 INFO  Iniciando aplicação
2024-03-10 14:20:16 DEBUG Conectando ao banco
2024-03-10 14:20:17 ERROR Falha na conexão
                ↓
2024-03-10 14:20:17 ERROR Traceback (most recent call last):
2024-03-10 14:20:17 ERROR   File "app.py", line 42
2024-03-10 14:20:17 ERROR     connection = db.connect()
2024-03-10 14:20:18 INFO  Reconectando...

# Contar ocorrências
$ grep -c "error" /var/log/syslog
42

# Listar só arquivos que contêm o padrão
$ grep -rl "TODO" /home/devgabriellucas/projetos/
/home/devgabriellucas/projetos/main.py
/home/devgabriellucas/projetos/utils.py
```

### Compactação

```bash
# Criar backup .tar.gz
$ tar -czf backup_$(date +%Y%m%d).tar.gz /home/devgabriellucas/Documentos/
$ ls -lh backup_20260310.tar.gz
-rw-r--r-- 1 devgabriellucas devgabriellucas 45M mar 10 15:00 backup_20260310.tar.gz

# Extrair .tar.gz
$ tar -xzf backup.tar.gz

# Extrair para pasta específica
$ tar -xzf backup.tar.gz -C /tmp/

# Listar conteúdo sem extrair
$ tar -tzf backup.tar.gz
home/devgabriellucas/Documentos/
home/devgabriellucas/Documentos/relatorio.txt
home/devgabriellucas/Documentos/notas.txt

# Criar backup .tar.bz2 (mais compacto, mais lento)
$ tar -cjf backup.tar.bz2 pasta/

# Extrair .tar.bz2
$ tar -xjf backup.tar.bz2

# Criar zip
$ zip -r backup.zip pasta/
  adding: pasta/ (stored 0%)
  adding: pasta/arquivo.txt (deflated 60%)

# Extrair zip
$ unzip backup.zip

# Ver conteúdo do zip sem extrair
$ unzip -l backup.zip

# Comprimir arquivo único
$ gzip arquivo.txt        # vira arquivo.txt.gz
$ gunzip arquivo.txt.gz   # volta a ser arquivo.txt
```

### Download e Transferência

```bash
# Baixar arquivo
$ wget https://releases.ubuntu.com/22.04/ubuntu-22.04-desktop-amd64.iso
--2026-03-10 15:00:00--  https://releases.ubuntu.com/22.04/ubuntu-22.04-desktop-amd64.iso
Resolving releases.ubuntu.com... 91.189.91.83
Connecting to releases.ubuntu.com|91.189.91.83|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 3460362240 (3.2G) [application/x-iso9660-image]
Saving to: 'ubuntu-22.04-desktop-amd64.iso'

ubuntu-22.04-desktop 100%[==================>]   3.22G  45.6MB/s    in 72s

# Baixar e renomear
$ wget -O ubuntu.iso https://releases.ubuntu.com/22.04/ubuntu-22.04-desktop-amd64.iso

# Baixar com curl
$ curl -O https://example.com/arquivo.zip
$ curl -Lo arquivo.zip https://example.com/arquivo.zip

# Ver headers HTTP
$ curl -I https://google.com
HTTP/2 200
content-type: text/html; charset=UTF-8
date: Mon, 10 Mar 2026 15:00:00 GMT

# Testar API REST
$ curl -s https://api.github.com/users/gabriellglrs | head -5
{
  "login": "gabriellglrs",
  "id": 12345678,
  "node_id": "MDQ6VXNlcjEyMzQ1Njc4",

# Copiar arquivo via SSH
$ scp arquivo.txt joao@192.168.1.100:/home/joao/
$ scp joao@192.168.1.100:/home/joao/arquivo.txt ./
$ scp -r pasta/ joao@192.168.1.100:/home/joao/

# Sincronizar pastas (backup incremental)
$ rsync -avz pasta/ joao@192.168.1.100:/backup/pasta/
sending incremental file list
arquivo.txt
  1,234,567 100%   45.67MB/s    0:00:00 (xfr#1, to-chk=2/3)

# SSH básico
$ ssh joao@192.168.1.100
$ ssh -p 2222 joao@192.168.1.100    # porta diferente

# SSH com chave
$ ssh -i ~/.ssh/id_ed25519 joao@192.168.1.100

# Port forwarding (acessar porta 3000 do servidor remoto na local 8080)
$ ssh -L 8080:localhost:3000 joao@192.168.1.100
```

### Disco e Sistema

```bash
# Espaço em disco (formatado)
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        50G   32G   16G  67% /
tmpfs           3.9G     0  3.9G   0% /dev/shm
/dev/sdb1       500G  200G  300G  40% /home

# Tamanho de pastas
$ du -sh /var/log
1.2G    /var/log

# Top 10 pastas maiores
$ du -sh /* 2>/dev/null | sort -rh | head -10
32G     /home
5.2G    /var
2.1G    /usr
1.2G    /opt
800M    /tmp

# Tamanho de cada pasta dentro de uma pasta
$ du -sh /var/* | sort -rh | head
1.2G    /var/log
800M    /var/cache
500M    /var/lib
120M    /var/tmp

# Memória RAM
$ free -h
              total        used        free      shared  buff/cache   available
Mem:           15Gi       8.2Gi       2.1Gi       512Mi       5.1Gi       6.3Gi
Swap:         2.0Gi       0.5Gi       1.5Gi

# Info completa do sistema
$ uname -a
Linux DESKTOP-FGAQDIS 6.5.0-generic #1 SMP PREEMPT_DYNAMIC x86_64 GNU/Linux

# Tempo ligado
$ uptime
 15:00:00 up 3 days,  2:15,  1 user,  load average: 0.52, 0.48, 0.45

# Data e hora
$ date
Mon Mar 10 15:00:00 BRT 2026

$ date +%Y-%m-%d_%H-%M-%S
2026-03-10_15-00-00

# Calendário
$ cal 2026
                           2026
      January               February                 March
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
             1  2  3   1  2  3  4  5  6  7   1  2  3  4  5  6  7
 4  5  6  7  8  9 10   8  9 10 11 12 13 14   8  9 10 11 12 13 14
11 12 13 14 15 16 17  15 16 17 18 19 20 21  15 16 17 18 19 20 21
18 19 20 21 22 23 24  22 23 24 25 26 27 28  22 23 24 25 26 27 28
25 26 27 28 29 30 31                       29 30 31

# Blocos de disco
$ lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sda      8:0    0    50G  0 disk
├─sda1   8:1    0    50G  0 part /
sdb      8:16   0   500G  0 disk
└─sdb1   8:17   0   500G  0 part /home
sr0     11:0    1  1024M  0 rom
```

### Gerenciamento de Pacotes

```bash
# ─── Debian/Ubuntu (apt) ──────────────────────────────────────

# Atualizar lista de pacotes
$ sudo apt update
Hit:1 http://br.archive.ubuntu.com/ubuntu jammy InRelease
Hit:2 http://br.archive.ubuntu.com/ubuntu jammy-updates InRelease
Reading package lists... Done
87 packages can be upgraded.

# Atualizar todos os pacotes
$ sudo apt upgrade -y

# Instalar pacote
$ sudo apt install -y nmap git python3

# Remover pacote
$ sudo apt remove -y firefox

# Remover pacote + configurações
$ sudo apt purge -y firefox

# Limpar cache de downloads
$ sudo apt autoremove -y
$ sudo apt clean

# Buscar pacote
$ apt search editor
nano - small text editor
vim - Vi IMproved
code - Visual Studio Code

# Verificar se está instalado
$ dpkg -l | grep nmap
ii  nmap          7.93-1   amd64   Nmap Network Scanner

# Instalar .deb local
$ sudo dpkg -i pacote.deb

# Ver pacotes de um pacote (dependências)
$ apt depends nmap

# ─── Red Hat/Fedora (dnf) ────────────────────────────────────

$ sudo dnf install -y nmap
$ sudo dnf remove -y firefox
$ sudo dnf update -y
$ dnf search editor

# ─── Arch (pacman) ───────────────────────────────────────────

$ sudo pacman -S nmap
$ sudo pacman -R firefox
$ sudo pacman -Syu        # atualizar tudo
$ pacman -Ss editor
```

---

## ⚡ Nível 3: Avançado

### Texto e Processamento

```bash
# ─── AWK — Processamento de colunas ──────────────────────────

# Mostrar 1ª e 3ª coluna
$ cat /etc/passwd | awk -F':' '{print $1, $3}'
root 0
daemon 1
bin 2
devgabriellucas 1000

# Filtrar linhas com padrão
$ cat /var/log/syslog | awk '/error/ {print}'
mar 10 14:20:15 DESKTOP kernel: Error: disk failure

# Somar valores de uma coluna
$ awk '{sum+=$1} END {print "Total:", sum}' vendas.txt
Total: 15234.50

# Calcular média
$ awk '{sum+=$1; count++} END {print "Média:", sum/count}' notas.txt
Média: 7.5

# Formatar saída
$ ls -la | awk '{printf "%-20s %s\n", $9, $5}'
arquivo.txt          1234
projeto/             4096
backup.tar.gz        45000000

# ─── SED — Edição de texto ───────────────────────────────────

# Substituir texto (primeira ocorrência por linha)
$ sed 's/antigo/novo/' arquivo.txt

# Substituir TODAS as ocorrências
$ sed 's/antigo/novo/g' arquivo.txt

# Editar arquivo in-place
$ sed -i 's/antigo/novo/g' arquivo.txt

# Deletar linha específica
$ sed -i '5d' arquivo.txt

# Deletar linhas vazias
$ sed -i '/^$/d' arquivo.txt

# Mostrar só linhas 10-20
$ sed -n '10,20p' arquivo.txt

# Inserir linha após a 5ª
$ sed '5a\Nova linha aqui' arquivo.txt

# Substituir só em linhas que contenham padrão
$ sed '/password/s/antigo/novo/g' config.txt

# ─── GREP avançado ──────────────────────────────────────────

# Buscar recursivamente em todos os .conf
$ grep -r "password" /etc/ --include="*.conf" 2>/dev/null
/etc/mysql/debian.cnf:password = senha123

# Case insensitive
$ grep -ri "error" /var/log/

# Com número da linha
$ grep -n "function" app.py
42:function calculate_total(items):
87:function format_currency(value):

# Contar ocorrências
$ grep -c "GET" /var/log/nginx/access.log
15234

# Invert match (linhas que NÃO contêm)
$ grep -v "^#" config.txt | grep -v "^$"
host=localhost
port=5432
dbname=myapp

# Extended regex (múltiplos padrões)
$ grep -E "error|warning|critical" /var/log/syslog

# Só nomes dos arquivos
$ grep -rl "TODO" /home/devgabriellucas/projetos/
/home/devgabriellucas/projetos/main.py

# ─── CUT — Cortar colunas ───────────────────────────────────

# 1ª coluna (delimitador :)
$ cut -d':' -f1 /etc/passwd
root
daemon
bin

# 1ª e 3ª coluna
$ cut -d':' -f1,3 /etc/passwd
root:0
daemon:1

# Caracteres específicos
$ cut -c1-10 arquivo.txt
primeiras10

# ─── SORT e UNIQ ────────────────────────────────────────────

# Ordenar alfabeticamente
$ sort arquivo.txt

# Ordenar e remover duplicatas
$ sort -u arquivo.txt

# Contar ocorrências únicas
$ sort arquivo.txt | uniq -c | sort -rn
    152 erro
     45 warning
     12 info

# ─── TR — Traduzir caracteres ───────────────────────────────

# Minúsculas para maiúsculas
$ echo "hello world" | tr 'a-z' 'A-Z'
HELLO WORLD

# Maiúsculas para minúsculas
$ echo "HELLO" | tr 'A-Z' 'a-z'
hello

# Remover caracteres
$ echo "abc123def456" | tr -d '0-9'
abcdef

# Espaços extras por um único
$ echo "muito   espaço" | tr -s ' '
muito espaço

# ─── COLUMN — Formatar em colunas ───────────────────────────

$ mount | column -t
/dev/sda1   on  /              type ext4   (rw,relatime)
tmpfs       on  /dev/shm       type tmpfs  (rw,nosuid,nodev)
/dev/sdb1   on  /home          type ext4   (rw,relatime)

# ─── DIFF — Comparar arquivos ───────────────────────────────

$ diff arquivo1.txt arquivo2.txt
3c3
< linha antiga
---
> linha nova

$ diff -u arquivo1.txt arquivo2.txt    # formato unified
$ diff -y arquivo1.txt arquivo2.txt    # lado a lado
```

### Expressões Regulares

```bash
# Padrão | Significado | Exemplo

# .    | Qualquer caractere | grep "a.b" arquivo → aceita "axb", "a1b"
# *    | Zero ou mais        | grep "ab*" arquivo → aceita "a", "ab", "abb"
# ^    | Início da linha     | grep "^root" /etc/passwd → linhas que começam com root
# $    | Fim da linha        | grep "/bin/bash$" /etc/passwd → termina com /bin/bash
# []   | Caractere específico | grep "[aeiou]" arquivo → qualquer vogal
# [^]  | Não é esse caractere | grep "[^0-9]" arquivo → qualquer coisa que não é número
# \b   | Limitador de palavra | grep "\bword\b" → só a palavra "word" inteira

# Exemplos práticos

# Buscar endereços IP
$ grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}" arquivo.txt
192.168.1.1
10.0.0.255

# Buscar emails
$ grep -Eo "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}" arquivo.txt
user@example.com
admin@company.org

# Buscar URLs
$ grep -Eo "https?://[a-zA-Z0-9./?=&_-]+" arquivo.txt
https://example.com
http://localhost:3000/api

# Buscar datas (DD/MM/AAAA)
$ grep -Eo "[0-9]{2}/[0-9]{2}/[0-9]{4}" arquivo.txt
10/03/2026
25/12/2025

# Buscar hexadecimal
$ grep -Eo "0x[0-9a-fA-F]+" arquivo.txt
0x7fff5fbff8d0

# Buscar.telefone brasileiro
$ grep -Eo "\([0-9]{2}\) [0-9]{4,5}-[0-9]{4}" arquivo.txt
(11) 99999-1234
(21) 3333-4567
```

### Gerenciamento de Serviços (systemd)

```bash
# Ver status de um serviço
$ systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2026-03-10 14:20:15 BRT; 2h ago
   Main PID: 1234 (sshd)
      Tasks: 1 (limit: 4617)
     Memory: 5.2M
        CPU: 120ms
     CGroup: /system.slice/ssh.service
             └─1234 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

# Iniciar serviço
$ sudo systemctl start nginx

# Parar serviço
$ sudo systemctl stop nginx

# Reiniciar
$ sudo systemctl restart nginx

# Habilitar para iniciar com o boot
$ sudo systemctl enable nginx

# Desabilitar
$ sudo systemctl disable nginx

# Listar todos os serviços ativos
$ systemctl list-units --type=service --state=running
UNIT                     LOAD   ACTIVE SUB     DESCRIPTION
nginx.service            loaded active running A high performance web server
ssh.service              loaded active running OpenBSD Secure Shell server
docker.service           loaded active running Docker Application Container Engine

# Ver logs de um serviço (últimas 50 linhas)
$ journalctl -u nginx -n 50

# Logs em tempo real (ctrl+C para sair)
$ journalctl -u nginx -f

# Logs desde o último boot
$ journalctl -b -u nginx

# Logs com erro
$ journalctl -u nginx -p err

# Listar serviços que falharam
$ systemctl --failed
```

### Redes (Avançado)

```bash
# ─── IP e Interfaces ────────────────────────────────────────

# Ver endereços IP
$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN
    inet 127.0.0.1/8 scope host lo
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500
    inet 192.168.1.100/24 brd 192.168.1.255 scope global eth0

# Ver rotas
$ ip r
default via 192.168.1.1 dev eth0 proto dhcp metric 100
192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.100

# ─── Portas e Conexões ──────────────────────────────────────

# Portas abertas (TCP)
$ ss -tlnp
State   Recv-Q  Send-Q  Local Address:Port  Peer Address:Port
LISTEN  0       128     0.0.0.0:22          0.0.0.0:*    users:(("sshd",pid=1234))
LISTEN  0       511     0.0.0.0:80          0.0.0.0:*    users:(("nginx",pid=5678))
LISTEN  0       128     0.0.0.0:3306        0.0.0.0:*    users:(("mysqld",pid=9012))

# Portas abertas (UDP)
$ ss -ulnp

# Conexões estabelecidas
$ ss -tnp | grep ESTAB
ESTAB  0  0  192.168.1.100:22   192.168.1.50:54321  users:(("sshd",pid=2345))

# ─── DNS ─────────────────────────────────────────────────────

# Consulta simples
$ nslookup google.com
Server:         127.0.0.53
Address:        127.0.0.53#53

Non-authoritative answer:
Name:   google.com
Address: 142.250.79.46

# DNS detalhado
$ dig google.com
;; ANSWER SECTION:
google.com.         300     IN      A       142.250.79.46

# Buscar MX (email)
$ dig gmail.com MX
;; ANSWER SECTION:
gmail.com.          3600    IN      MX      10 smtp.google.com.

# Buscar NS (nameservers)
$ dig google.com NS
;; ANSWER SECTION:
google.com.         172800  IN      NS      ns1.google.com.

# ─── Firewall ────────────────────────────────────────────────

# UFW (simples)
$ sudo ufw status
Status: active

To                         Action      From
--                         ------      ----
22/tcp                     ALLOW       Anywhere
80/tcp                     ALLOW       Anywhere
443/tcp                    ALLOW       Anywhere

$ sudo ufw allow 8080/tcp
$ sudo ufw deny 3306/tcp
$ sudo ufw delete allow 80/tcp

# iptables (avançado)
$ sudo iptables -L -n -v
Chain INPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
  123 12345 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:22
   45  4567 ACCEPT     tcp  --  *      *       0.0.0.0/0            0.0.0.0/0            tcp dpt:80

$ sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT
$ sudo iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT
$ sudo iptables -A INPUT -j DROP    # bloquear tudo o resto
```

### DNS e Hosts

```bash
# Editar mapeamento local
$ sudo nano /etc/hosts
127.0.0.1       localhost
192.168.1.100   meu-servidor
192.168.1.101   db-server
10.0.0.5        gitlab.empresa.local

# Servidores DNS
$ cat /etc/resolv.conf
nameserver 8.8.8.8
nameserver 8.8.4.4
search empresa.local

# Verificar se hosts está sendo usado
$ getent hosts meu-servidor
192.168.1.100   meu-servidor
```

### Logs do Sistema

```bash
# Logs gerais
$ tail -f /var/log/syslog

# Autenticação (quem logou, sudo)
$ grep "Failed password" /var/log/auth.log
mar 10 14:20:15 DESKTOP sshd[1234]: Failed password for root from 192.168.1.50 port 22 ssh2

# Quem usou sudo
$ grep "sudo" /var/log/auth.log | tail -10
mar 10 14:30:22 DESKTOP sudo: devgabriellucas : TTY=pts/0 ; USER=root ; COMMAND=/usr/bin/apt update

# Logs do kernel
$ dmesg | tail -20

# Logs do nginx
$ tail -f /var/log/nginx/access.log
192.168.1.50 - - [10/Mar/2026:14:20:15 +0000] "GET /index.html HTTP/1.1" 200 1234

# Logs de erro do nginx
$ tail -f /var/log/nginx/error.log

# Logs do MySQL
$ tail -f /var/log/mysql/error.log

# Logs do Apache
$ tail -f /var/log/apache2/access.log
```

### Cron (Agendamento)

```bash
# Editar cron jobs
$ crontab -e

# Listar cron jobs
$ crontab -l
# Editar cron jobs do root
$ sudo crontab -u root -l

# ─── Formato do cron ───────────────────────────────────────
# ┌───── minuto (0-59)
# │ ┌───── hora (0-23)
# │ │ ┌───── dia do mês (1-31)
# │ │ │ ┌───── mês (1-12)
# │ │ │ │ ┌───── dia da semana (0-7, 0=7=dom)
# │ │ │ │ │
# * * * * * comando

# ─── Exemplos ──────────────────────────────────────────────

# Backup diário às 2h da manhã
0 2 * * * /home/devgabriellucas/scripts/backup.sh >> /var/log/backup.log 2>&1

# Verificar serviço a cada 5 minutos
*/5 * * * * /home/devgabriellucas/scripts/check_service.sh

# Relatório semanal (segunda às 8h)
0 8 * * 1 /home/devgabriellucas/scripts/weekly_report.sh

# Limpar cache todo domingo à meia-noite
0 0 * * 0 apt clean && apt autoremove -y

# Sincronizar arquivos a cada hora
0 * * * * rsync -avz /home/devgabriellucas/projetos/ backup@192.168.1.100:/backup/

# Enviar email de status toda sexta às 17h
0 17 * * 5 /home/devgabriellucas/scripts/send_report.sh

# Agendar desligamento (dia 25 às 23h)
0 23 25 * * shutdown -h now

# ─── Systemd Timer (alternativa moderna ao cron) ───────────

# Criar timer
$ sudo systemctl edit my-backup.timer
[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true

$ sudo systemctl enable --now my-backup.timer
$ systemctl list-timers
```

### Aliases e Funções

```bash
# ─── Aliases úteis (colocar no ~/.zshrc ou ~/.bashrc) ──────

# Navegação
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'
alias -- -='cd -'

# Listar
alias ls='ls --color=auto'
alias ll='ls -lah --color=auto --group-directories-first'
alias la='ls -A --color=auto'
alias lt='ls -lhtr --color=auto'           # por data
alias lS='ls -lhS --color=auto'            # por tamanho
alias l.='ls -d .*'                         # só ocultos

# Segurança
alias rm='rm -iv'                           # confirma antes de apagar
alias cp='cp -iv'                           # confirma antes de copiar
alias mv='mv -iv'                           # confirma antes de mover
alias chmod='chmod -v'
alias chown='chown -v'

# Atalhos
alias cls='clear'
alias h='history'
alias hg='history | grep'
alias j='jobs -l'
alias c='clear'
alias md='mkdir -p'
alias ram='free -h | awk "/Mem:/{print \"RAM: \"\$3\"/\"\$2}"'
alias disco='df -h | awk "NR==1||/\//{print \$5, \$6, \$9}"'
alias ports='ss -tlnp'
alias myip='curl -s ifconfig.me'
alias localip='ip a | grep "inet " | grep -v 127.0.0.1 | awk "{print \$2}"'

# Git
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline -10'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# ─── Funções úteis (colocar no ~/.zshrc ou ~/.bashrc) ──────

# Criar pasta e entrar nela
mkcd() { mkdir -p "$1" && cd "$1"; }

# Extrair qualquer formato
extract() {
  case $1 in
    *.tar.bz2) tar -xjf "$1" ;;
    *.tar.gz)  tar -xzf "$1" ;;
    *.tar.xz)  tar -xJf "$1" ;;
    *.tar.zst) tar --zstd -xf "$1" ;;
    *.bz2)     bunzip2 "$1" ;;
    *.gz)      gunzip "$1" ;;
    *.tar)     tar -xf "$1" ;;
    *.zip)     unzip "$1" ;;
    *.7z)      7z x "$1" ;;
    *.rar)     unrar x "$1" ;;
    *) echo "Formato não suportado: $1" ;;
  esac
}

# Backup rápido com data
bak() { tar -czf "$1_$(date +%Y%m%d_%H%M%S).tar.gz" "$1"; }

# Buscar no histórico
h() { history | grep "$1"; }

# Verificar se porta está aberta
checkport() { nc -zv "$1" "$2" 2>&1; }

# IP público
myip() { curl -s ifconfig.me; }

# Processo por nome
psg() { ps aux | grep -v grep | grep "$1"; }

# Criar script executável
mkscript() {
  echo "#!/usr/bin/env bash" > "$1"
  chmod +x "$1"
  echo "Script criado: $1"
}
```

### Variáveis de Ambiente

```bash
# Ver variável
$ echo $PATH
/home/devgabriellucas/.local/bin:/usr/local/bin:/usr/bin:/bin

# Criar variável (sessaão atual)
$ export MEU_APP="/opt/meu-app"

# Criar variável permanente
$ echo 'export MEU_APP="/opt/meu-app"' >> ~/.zshrc
$ source ~/.zshrc

# Ver todas as variáveis
$ env
$ printenv

# Remover variável
$ unset MEU_APP

# ─── Variáveis importantes ──────────────────────────────────

$ echo $HOME        # /home/devgabriellucas
$ echo $USER        # devgabriellucas
$ echo $PWD         # /home/devgabriellucas
$ echo $OLDPWD      # /var/log (pasta anterior)
$ echo $SHELL       # /bin/zsh
$ echo $HOSTNAME    # DESKTOP-FGAQDIS
$ echo $LANG        # en_US.UTF-8
$ echo $EDITOR      # nano (ou vim, code...)
$ echo $?           # 0 (último comando OK) ou código de erro
```

### Processamento de Texto Avançado

```bash
# ─── Combinar múltiplos comandos ────────────────────────────

# Encontrar e remover arquivos .log antigos
$ find /var/log -name "*.log" -mtime +30 -exec rm {} \;

# Listar processos e salvar em arquivo com timestamp
$ ps aux > processos_$(date +%Y%m%d).txt

# Backup automático com verificação
$ tar -czf backup.tar.gz /home/ && echo "Backup OK" || echo "Backup FALHOU"

# Verificar se serviço está rodando, se não iniciar
$ systemctl is-active nginx || sudo systemctl start nginx

# Monitorar uso de disco e alertar
$ df -h | awk 'NR>1 && $5+0 > 80 {print "ALERTA: Disco cheio em "$6" ("$5" usado)"}'

# Listar IPs de uma rede
$ nmap -sn 192.168.1.0/24 | grep "report for" | awk '{print $NF}'
192.168.1.1
192.168.1.100
192.168.1.105

# Contar conexões por IP
$ ss -tnp | awk '{print $5}' | cut -d':' -f1 | sort | uniq -c | sort -rn | head
     45 192.168.1.50
     12 10.0.0.5
      3 172.16.0.1

# Encontrar arquivos duplicados
$ find . -type f -exec md5sum {} \; | sort | uniq -D -w32
d41d8cd98f00b204e9800998ecf8427e  arquivo1.txt
d41d8cd98f00b204e9800998ecf8427e  arquivo2.txt

# Criar lista de pacotes instalados
$ dpkg --get-selections | grep -v deinstall > pacotes_instalados.txt

# Restaurar lista de pacotes
$ dpkg --set-selections < pacotes_instalados.txt && apt-get dselect-upgrade

# Verificar integridade de arquivos
$ md5sum -c checksums.txt
arquivo1.txt: OK
arquivo2.txt: FAILED
```

---

## 🔍 Dicas de Produtividade

### Atalhos do Teclado

| Atalho | O que faz | Quando usar |
|:-------|:----------|:------------|
| `Ctrl+C` | Cancelar comando | Algo travou, quero parar |
| `Ctrl+Z` | Suspender processo | Quero pausar e voltar depois com `fg` |
| `Ctrl+D` | Sair do shell | Fechar terminal |
| `Ctrl+R` | Buscar no histórico | "Como era aquele comando?" |
| `Ctrl+A` | Ir para início da linha | Editar começo do comando |
| `Ctrl+E` | Ir para fim da linha | Editar final do comando |
| `Ctrl+W` | Deletar palavra anterior | Corrigir última palavra |
| `Ctrl+U` | Deletar até o início | Recomeçar o comando |
| `Ctrl+K` | Deletar até o fim | Apagar até o final |
| `Ctrl+L` | Limpar tela | Tela suja |
| `Ctrl+Y` | Colar texto apagado | Desfazer Ctrl+W/U/K |
| `Tab` | Autocompletar | Sempre usar! |
| `Tab Tab` | Mostrar opções | Não sei o nome completo |
| `!!` | Ìltimo comando | Esqueci o sudo: `sudo !!` |
| `!$` | Último argumento | `mkdir pasta && cd !$` |
| `Alt+.` | Inserir último argumento | Similar ao `!$` |

### Truques Úteis

```bash
# Rodar último comando com sudo
$ vim /etc/config
E121: Não é possível abrir para escrita
$ sudo !!
$ sudo vim /etc/config

# Criar pasta e entrar
$ mkdir -p projetos/web && cd projetos/web

# Rodar comando e salvar saída + mostrar na tela
$ comando 2>&1 | tee output.txt

# Contar arquivos por extensão
$ find . -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn
     45 py
     23 txt
     12 sh
      8 md

# Backup rápido com timestamp
$ cp arquivo.txt{,.bak_$(date +%Y%m%d)}
# Resultado: arquivo.txt.bak_20260310

# Criar backup comprimido de pasta
$ tar -czf pasta_$(date +%Y%m%d).tar.gz --exclude="*.log" pasta/

# Listar IPs da máquina
$ ip a | grep "inet " | awk '{print $2}' | grep -v 127.0.0.1
192.168.1.100/24
10.0.0.5/8

# Verificar memória
$ free -h | awk '/Mem:/{printf "RAM: %s usado de %s (%s livre)\n", $3, $2, $4}'
RAM: 8.2G usado de 15G (2.1G livre)

# Portas abertas
$ ss -tlnp | awk 'NR>1 {print $4}' | sed 's/.*://' | sort -n | uniq
22
80
443
3306

# Testar se site está no ar
$ timeout 5 curl -s -o /dev/null -w "%{http_code}" https://google.com
200

# Ver processos que mais usam CPU
$ ps aux --sort=-%cpu | head -6 | awk '{printf "%-10s %5s%% %5s%% %s\n", $1, $3, $4, $11}'

# Encontrar processos zumbis
$ ps aux | awk '$8=="Z"'

# Verificar certificado SSL
$ echo | openssl s_client -connect google.com:443 2>/dev/null | openssl x509 -noout -dates
notBefore=Mar 10 00:00:00 2026 GMT
notAfter=Jun  8 23:59:59 2026 GMT

# Gerar senha aleatória
$ openssl rand -base64 32
dGhpcyBpcyBhIHJhbmRvbSBwYXNzd29yZA==

# Hash de arquivo
$ sha256sum arquivo.txt
e3b0c44298fc1c149afbf4c8996fb924...  arquivo.txt

# Contar linhas de código por extensão
$ find . -name "*.py" -exec cat {} \; | wc -l
12456
```

---

## ✅ Checkpoint

- [ ] Consigo navegar no terminal (cd, ls, pwd)
- [ ] Consigo criar, copiar e mover arquivos
- [ ] Consigo gerenciar permissões (chmod, chown)
- [ ] Consigo ver e matar processos
- [ ] Consigo usar pipes e redirecionamento
- [ ] Consigo buscar arquivos com find e grep
- [ ] Consigo usar awk e sed
- [ ] Consigo gerenciar serviços com systemctl
- [ ] Consigo configurar cron jobs
- [ ] Consigo usar expressões regulares
- [ ] Consigo gerenciar pacotes (apt/dnf/pacman)
- [ ] Consigo fazer backups e compactação
- [ ] Consigo configurar aliases e funções

---

<div align="center">

**⬅️ [Voltar ao README](../README.md)** | **[Próximo: Cybersegurança ➡️](CYBERSEG.md)**

</div>
