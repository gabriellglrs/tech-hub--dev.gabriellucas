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

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `pwd` | Mostra onde você está | `pwd` |
| `ls` | Lista arquivos | `ls -la` |
| `cd` | Muda de pasta | `cd /home` |
| `cd ..` | Volta uma pasta | `cd ..` |
| `cd ~` | Vai para home | `cd ~` |
| `cd -` | Volta para pasta anterior | `cd -` |

### Ver Arquivos

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `cat` | Mostra conteúdo do arquivo | `cat arquivo.txt` |
| `less` | Mostra conteúdo (paginado) | `less arquivo.txt` |
| `head` | Primeiras 10 linhas | `head -20 arquivo.txt` |
| `tail` | Últimas 10 linhas | `tail -20 arquivo.txt` |
| `wc` | Conta linhas/palavras | `wc -l arquivo.txt` |
| `file` | Tipo do arquivo | `file imagem.png` |

### Criar e Editar

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `touch` | Cria arquivo vazio | `touch novo.txt` |
| `mkdir` | Cria pasta | `mkdir -p pasta/subpasta` |
| `cp` | Copia arquivo | `cp arquivo.txt copia.txt` |
| `mv` | Move/renomeia | `mv antigo.txt novo.txt` |
| `rm` | Deleta arquivo | `rm arquivo.txt` |
| `rmdir` | Deleta pasta vazia | `rmdir pasta` |
| `rm -rf` | Deleta pasta com tudo | `rm -rf pasta/` |

### Ajuda

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `man` | Manual do comando | `man ls` |
| `--help` | Ajuda rápida | `ls --help` |
| `which` | Onde está o comando | `which python` |
| `type` | Tipo do comando | `type ls` |

---

## 🔧 Nível 2: Intermediário (Dia a Dia)

### Permissões

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `chmod` | Mudar permissões | `chmod 755 script.sh` |
| `chown` | Mudar dono | `chown user:group arquivo` |
| `sudo` | Rodar como root | `sudo apt update` |
| `su` | Trocar de usuário | `su - root` |

#### Permissões explicadas

```
rwx = leitura(4) + escrita(2) + execução(1)

chmod 755 = rwxr-xr-x
             │││ │││ │││
             │││ │││ └┴┴── Outros
             │││ └┴┴────── Grupo
             └┴┴────────── Dono
```

### Usuários e Grupos

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `whoami` | Quem sou eu | `whoami` |
| `id` | UID, GID, grupos | `id` |
| `useradd` | Criar usuário | `useradd -m novo` |
| `userdel` | Deletar usuário | `userdel -r velho` |
| `passwd` | Mudar senha | `passwd usuario` |
| `groupadd` | Criar grupo | `groupadd devs` |
| `usermod` | Modificar usuário | `usermod -aG sudo novo` |

### Processos

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `ps` | Ver processos | `ps aux` |
| `top` | Processos em tempo real | `top` |
| `htop` | Top melhorado | `htop` |
| `kill` | Matar processo | `kill -9 1234` |
| `killall` | Matar por nome | `killall firefox` |
| `bg` | Processo em background | `bg` |
| `fg` | Trazer para foreground | `fg` |
| `jobs` | Ver processos background | `jobs` |
| `nohup` | Processo sobrevive logout | `nohup script.sh &` |

### Redirecionamento e Pipes

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `>` | Redirecionar saída | `ls > lista.txt` |
| `>>` | Adicionar ao final | `echo "linha" >> arquivo` |
| `<` | Entrada de dados | `sort < dados.txt` |
| `\|` | Pipe (conectar comandos) | `ls \| grep ".txt"` |
| `&&` | Executar se anterior OK | `cmd1 && cmd2` |
| `\|\|` | Executar se anterior falhar | `cmd1 \|\| cmd2` |
| `;` | Executar sequencialmente | `cmd1 ; cmd2` |

### Busca e Localização

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `find` | Buscar arquivos | `find / -name "*.conf"` |
| `locate` | Buscar no banco de dados | `locate arquivo` |
| `grep` | Buscar em conteúdo | `grep -r "texto" /etc/` |
| `which` | Localizar comando | `which nmap` |
| `whereis` | Localizar binário, fonte | `whereis python` |
| `updatedb` | Atualizar banco locate | `sudo updatedb` |

### Compactação

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `tar -czf` | Criar .tar.gz | `tar -czf backup.tar.gz pasta/` |
| `tar -xzf` | Extrair .tar.gz | `tar -xzf backup.tar.gz` |
| `tar -cjf` | Criar .tar.bz2 | `tar -cjf backup.tar.bz2 pasta/` |
| `zip` | Criar .zip | `zip -r archive.zip pasta/` |
| `unzip` | Extrair .zip | `unzip archive.zip` |
| `gzip` | Comprimir arquivo | `gzip arquivo` |
| `gunzip` | Descomprimir | `gunzip arquivo.gz` |

### Download e Transferência

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `wget` | Baixar arquivo | `wget https://site.com/arquivo.zip` |
| `curl` | Transferir dados | `curl -O https://site.com/arquivo` |
| `scp` | Copiar via SSH | `scp arquivo.txt user@host:/path/` |
| `rsync` | Sincronizar arquivos | `rsync -avz src/ dest/` |
| `ssh` | Conexão remota | `ssh user@192.168.1.1` |

### Disco e Sistema

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `df` | Espaço em disco | `df -h` |
| `du` | Tamanho de pastas | `du -sh /home` |
| `mount` | Montar disco | `mount /dev/sdb1 /mnt` |
| `umount` | Desmontar disco | `umount /mnt` |
| `lsblk` | Blocos de disco | `lsblk` |
| `fdisk` | Particionar disco | `sudo fdisk -l` |
| `free` | Memória RAM | `free -h` |
| `uname` | Info do sistema | `uname -a` |
| `uptime` | Tempo ligado | `uptime` |
| `hostname` | Nome do host | `hostname` |
| `date` | Data e hora | `date` |
| `cal` | Calendário | `cal 2026` |

### Gerenciamento de Pacotes

#### Debian/Ubuntu (apt)

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `apt update` | Atualizar lista | `sudo apt update` |
| `apt upgrade` | Atualizar pacotes | `sudo apt upgrade -y` |
| `apt install` | Instalar pacote | `sudo apt install nmap` |
| `apt remove` | Remover pacote | `sudo apt remove firefox` |
| `apt search` | Buscar pacote | `apt search editor` |
| `apt list` | Listar instalados | `apt list --installed` |
| `dpkg -i` | Instalar .deb | `sudo dpkg -i pacote.deb` |
| `dpkg -l` | Listar pacotes | `dpkg -l \| grep nome` |

#### Red Hat/Fedora (dnf/yum)

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `dnf install` | Instalar | `sudo dnf install nmap` |
| `dnf remove` | Remover | `sudo dnf remove firefox` |
| `dnf update` | Atualizar | `sudo dnf update` |

#### Arch (pacman)

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `pacman -S` | Instalar | `sudo pacman -S nmap` |
| `pacman -R` | Remover | `sudo pacman -R firefox` |
| `pacman -Syu` | Atualizar | `sudo pacman -Syu` |

---

## ⚡ Nível 3: Avançado

### Texto e Processamento

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `awk` | Processar texto | `awk '{print $1}' arquivo` |
| `sed` | Editar texto | `sed -i 's/antigo/novo/g' arquivo` |
| `sort` | Ordenar | `sort -u arquivo.txt` |
| `uniq` | Remover duplicatas | `sort arquivo \| uniq` |
| `cut` | Cortar colunas | `cut -d':' -f1 /etc/passwd` |
| `tr` | Traduzir caracteres | `echo "ABC" \| tr 'A-Z' 'a-z'` |
| `wc` | Contar linhas/palavras | `wc -l *.txt` |
| `diff` | Comparar arquivos | `diff a.txt b.txt` |
| `column` | Formatar em colunas | `mount \| column -t` |

### Expressões Regulares

| Padrão | Significado | Exemplo |
|:-------|:------------|:--------|
| `.` | Qualquer caractere | `grep "a.b" arquivo` |
| `*` | Zero ou mais | `grep "ab*" arquivo` |
| `^` | Início da linha | `grep "^root" /etc/passwd` |
| `$` | Fim da linha | `grep "/bin/bash$" /etc/passwd` |
| `[]` | Caractere específico | `grep "[aeiou]" arquivo` |
| `[^]` | Não é esse caractere | `grep "[^0-9]" arquivo` |
| `\b` | Limitador de palavra | `grep "\bword\b" arquivo` |

### Gerenciamento de Serviços (systemd)

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `systemctl start` | Iniciar serviço | `sudo systemctl start ssh` |
| `systemctl stop` | Parar serviço | `sudo systemctl stop apache2` |
| `systemctl restart` | Reiniciar | `sudo systemctl restart ssh` |
| `systemctl status` | Ver status | `systemctl status ssh` |
| `systemctl enable` | Iniciar com boot | `sudo systemctl enable ssh` |
| `systemctl disable` | Não iniciar com boot | `sudo systemctl disable ssh` |
| `systemctl list-units` | Listar serviços | `systemctl list-units --type=service` |
| `journalctl` | Ver logs | `journalctl -u ssh -f` |

### Redes (Avançado)

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `ip a` | Endereços IP | `ip a` |
| `ip r` | Rotas | `ip r` |
| `ip link` | Interfaces | `ip link show` |
| `ss` | Portas abertas | `ss -tlnp` |
| `ss -u` | UDP listening | `ss -ulnp` |
| `netstat` | Conexões | `netstat -tunp` |
| `ping` | Testar conectividade | `ping -c 4 8.8.8.8` |
| `traceroute` | Rota até destino | `traceroute google.com` |
| `mtr` | Ping + traceroute | `mtr google.com` |
| `nslookup` | Consultar DNS | `nslookup google.com` |
| `dig` | DNS detalhado | `dig google.com` |
| `host` | DNS simples | `host google.com` |
| `curl` | HTTP requests | `curl -I https://google.com` |
| `wget` | Baixar | `wget https://site.com/arquivo` |
| `ssh` | Acesso remoto | `ssh user@host -p 22` |
| `scp` | Copiar via SSH | `scp arquivo user@host:/path/` |
| `rsync` | Sincronizar | `rsync -avz src/ user@host:dest/` |
| `iptables` | Regras de firewall | `sudo iptables -L` |
| `ufw` | Firewall simplificado | `sudo ufw allow 22/tcp` |
| `nftables` | Firewall moderno | `sudo nft list ruleset` |

### Arquivos Comprimidos e Backups

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `tar -czf` | Criar tar.gz | `tar -czf backup.tar.gz /etc/` |
| `tar -xzf` | Extrair tar.gz | `tar -xzf backup.tar.gz` |
| `tar -cjf` | Criar tar.bz2 | `tar -cjf backup.tar.bz2 pasta/` |
| `tar -xjf` | Extrair tar.bz2 | `tar -xjf backup.tar.bz2` |
| `tar -cJf` | Criar tar.xz | `tar -cJf backup.tar.xz pasta/` |
| `zip -r` | Criar zip | `zip -r archive.zip pasta/` |
| `unzip` | Extrair zip | `unzip archive.zip` |
| `gzip` | Comprimir | `gzip arquivo` |
| `gunzip` | Descomprimir | `gunzip arquivo.gz` |
| `bzip2` | Comprimir (melhor) | `bzip2 arquivo` |
| `xz` | Comprimir (melhor) | `xz arquivo` |
| `dd` | Clonar disco | `dd if=/dev/sda of=backup.img` |

### LVM (Logical Volume Manager)

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `pvcreate` | Criar PV | `sudo pvcreate /dev/sdb1` |
| `vgcreate` | Criar VG | `sudo vgcreate vg0 /dev/sdb1` |
| `lvcreate` | Criar LV | `sudo lvcreate -L 10G -n lv0 vg0` |
| `pvdisplay` | Ver PVs | `sudo pvdisplay` |
| `vgdisplay` | Ver VGs | `sudo vgdisplay` |
| `lvdisplay` | Ver LVs | `sudo lvdisplay` |
| `lvextend` | Aumentar LV | `sudo lvextend -L +5G /dev/vg0/lv0` |
| `resize2fs` | Redimensionar FS | `sudo resize2fs /dev/vg0/lv0` |

### DNS e Hosts

| Arquivo | O que faz |
|:--------|:----------|
| `/etc/hosts` | Mapeamento local IP→nome |
| `/etc/resolv.conf` | Servidores DNS |
| `/etc/nsswitch.conf` | Ordem de resolução |
| `/etc/hostname` | Nome do host |

### Logs do Sistema

| Arquivo | O que guarda |
|:--------|:-------------|
| `/var/log/syslog` | Logs gerais do sistema |
| `/var/log/auth.log` | Autenticação (login, sudo) |
| `/var/log/kern.log` | Logs do kernel |
| `/var/log/dmesg` | Mensagens de boot |
| `/var/log/apt/history.log` | Histórico de pacotes |
| `/var/log/nginx/` | Logs do NGINX |
| `/var/log/apache2/` | Logs do Apache |
| `/var/log/mysql/` | Logs do MySQL |

### Cron (Agendamento)

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `crontab -e` | Editar cron | `crontab -e` |
| `crontab -l` | Listar cron jobs | `crontab -l` |
| `crontab -r` | Remover todos | `crontab -r` |

#### Formato do cron

```
┌───── minuto (0-59)
│ ┌───── hora (0-23)
│ │ ┌───── dia do mês (1-31)
│ │ │ ┌───── mês (1-12)
│ │ │ │ ┌───── dia da semana (0-7, 0=7=dom)
│ │ │ │ │
* * * * * comando
```

#### Exemplos

```bash
# A cada hora
0 * * * * /path/script.sh

# Todo dia às 2h
0 2 * * * /path/backup.sh

# Segunda a sexta às 8h
0 8 * * 1-5 /path/report.sh

# A cada 5 minutos
*/5 * * * * /path/check.sh

# Primeiro dia do mês à meia-noite
0 0 1 * * /path/monthly.sh
```

### Aliases e Funções

```bash
# Criar alias (no ~/.zshrc)
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias update='sudo apt update && sudo apt upgrade -y'
alias c='clear'
alias ..='cd ..'
alias ...='cd ../..'

# Criar função (no ~/.zshrc)
mkcd() { mkdir -p "$1" && cd "$1"; }
extract() {
  case $1 in
    *.tar.bz2) tar -xjf $1 ;;
    *.tar.gz)  tar -xzf $1 ;;
    *.tar.xz)  tar -xJf $1 ;;
    *.bz2)     bunzip2 $1 ;;
    *.gz)      gunzip $1 ;;
    *.tar)     tar -xf $1 ;;
    *.zip)     unzip $1 ;;
    *.7z)      7z x $1 ;;
    *) echo "Formato não suportado" ;;
  esac
}
```

### Variáveis de Ambiente

| Comando | O que faz | Exemplo |
|:--------|:----------|:--------|
| `export` | Criar variável | `export PATH=$PATH:/new/path` |
| `echo $VAR` | Ver variável | `echo $PATH` |
| `env` | Ver todas | `env` |
| `unset` | Remover variável | `unset VARIAVEL` |
| `set` | Ver todas (inclui locales) | `set` |

#### Variáveis importantes

| Variável | O que guarda |
|:---------|:-------------|
| `$HOME` | Diretório home |
| `$USER` | Nome do usuário |
| `$PATH` | Caminhos de busca |
| `$SHELL` | Shell atual |
| `$LANG` | Idioma do sistema |
| `$PWD` | Diretório atual |
| `$OLDPWD` | Diretório anterior |
| `$HOSTNAME` | Nome do host |

### Processamento de Texto Avançado

```bash
# AWK - Processamento de colunas
cat /etc/passwd | awk -F':' '{print $1, $3}'    # Usuário e UID
cat log.txt | awk '/error/ {print}'               # Linhas com "error"
awk '{sum+=$1} END {print sum}' arquivo.txt       # Somar coluna

# SED - Edição de texto
sed -i 's/antigo/novo/g' arquivo.txt              # Substituir texto
sed -i '5d' arquivo.txt                           # Deletar linha 5
sed -n '10,20p' arquivo.txt                       # Mostrar linhas 10-20
sed -i '/^$/d' arquivo.txt                        # Remover linhas vazias

# FIND - Busca avançada
find / -name "*.conf" -type f                     # Buscar arquivos .conf
find / -size +100M -type f                        # Arquivos maiores que 100MB
find / -mtime -7 -type f                          # Modificados nos últimos 7 dias
find / -user root -type f                         # Arquivos do root
find / -perm -4000 -type f                        # Arquivos com SUID
find / -writable -type d 2>/dev/null              # Pastas graváveis
find / -name "*.py" -exec grep -l "import" {} \;  # Python com import

# XARGS - Executar comandos em lote
find . -name "*.txt" | xargs rm                   # Deletar todos .txt
cat urls.txt | xargs -I {} curl -O {}             # Baixar todas as URLs
ps aux | grep apache | awk '{print $2}' | xargs kill  # Matar processos

# GREP avançado
grep -r "password" /etc/ --include="*.conf"       # Buscar em .conf
grep -i "error" log.txt                           # Case insensitive
grep -n "texto" arquivo.txt                       # Com número da linha
grep -c "texto" arquivo.txt                       # Contar ocorrências
grep -v "comentario" arquivo.txt                  # Invert match
grep -A 3 -B 3 "error" log.txt                   # Contexto (3 linhas antes/depois)
grep -E "regex|padrao" arquivo.txt                # Extended regex
grep -l "pattern" *.txt                           # Só nomes dos arquivos
```

---

## 🔍 Dicas de Produtividade

### Atalhos do Teclado

| Atalho | O que faz |
|:-------|:----------|
| `Ctrl+C` | Cancelar comando |
| `Ctrl+Z` | Suspender processo |
| `Ctrl+D` | Sair/Sair do shell |
| `Ctrl+R` | Buscar no histórico |
| `Ctrl+A` | Início da linha |
| `Ctrl+E` | Fim da linha |
| `Ctrl+W` | Deletar palavra anterior |
| `Ctrl+U` | Deletar até o início |
| `Ctrl+K` | Deletar até o fim |
| `Ctrl+L` | Limpar tela |
| `Tab` | Autocompletar |
| `Tab Tab` | Mostrar opções |
| `!!` | Rodar último comando |
| `!$` | Último argumento |
| `!n` | Comando número n do histórico |

### Truques Úteis

```bash
# Rodar como último comando com sudo
sudo !!

# Criar pasta e entrar nela
mkdir -p pasta && cd pasta

# Rodar comando e salvar saída
comando 2>&1 | tee output.txt

# Contar arquivos por extensão
find . -type f | sed 's/.*\.//' | sort | uniq -c | sort -rn

# Encontrar arquivos maiores que 10MB
find / -type f -size +10M 2>/dev/null

# Verificar se porta está aberta
nc -zv host 80

# Testar conectividade rápida
timeout 5 curl -s http://site.com > /dev/null && echo "UP" || echo "DOWN"

# Backup rápido com data
tar -czf backup_$(date +%Y%m%d_%H%M%S).tar.gz /pasta/

# Listar IPs da rede
ip a | grep "inet " | awk '{print $2}'

# Verificar memória
free -h | awk '/Mem:/ {print "Uso: "$3" Livre: "$4}'

# Processos por memória
ps aux --sort=-%mem | head -10

# Portas abertas
ss -tlnp | awk '{print $4}' | cut -d':' -f2 | sort -n | uniq
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

---

<div align="center">

**⬅️ [Voltar ao README](../README.md)** | **[Próximo: Cybersegurança ➡️](CYBERSEG.md)**

</div>
