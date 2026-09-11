# Automacao e Cron

> O profissional automatiza tudo que e repetitivo. Cron e systemd timers fazem tarefas rodarem sozinhas.

---

## Cron — Agendador de Tarefas

### O que e cron?

Cron e um daemon que executa comandos em horarios agendados. E como um despertador para o computador.

### Editar cron

```bash
crontab -e                    # Edita cron do usuario atual
sudo crontab -u usuario -e    # Edita cron de outro usuario
crontab -l                    # Lista tarefas
crontab -r                    # Remove TODAS as tarefas
```

### Sintaxe

```
┌───────────── minuto (0-59)
│ ┌──────────── hora (0-23)
│ │ ┌────────── dia do mes (1-31)
│ │ │ ┌──────── mes (1-12)
│ │ │ │ ┌────── dia da semana (0-7, 0=7=domingo)
│ │ │ │ │
* * * * * comando
```

### Exemplos

```bash
# Todo dia as 2h da manha
0 2 * * * /scripts/backup.sh

# Toda hora
0 * * * * /scripts/check.sh

# A cada 5 minutos
*/5 * * * * /scripts/monitor.sh

# Segunda a sexta as 9h
0 9 * * 1-5 /scripts/report.sh

# Todo dia 1 as meia-noite
0 0 1 * * /scripts/monthly.sh

# A cada 15 minutos
*/15 * * * * /scripts/scan.sh

# Segunda e quarta as 10h
0 10 * * 1,3 /scripts/audit.sh
```

### Atalhos

| Atalho | Significado |
|:-------|:------------|
| `@reboot` | Quando o sistema inicia |
| `@yearly` | Uma vez por ano (0 0 1 1 *) |
| `@monthly` | Uma vez por mes (0 0 1 *) |
| `@weekly` | Uma vez por semana (0 0 * * 0) |
| `@daily` | Uma vez por dia (0 0 * * *) |
| `@hourly` | Uma vez por hora (0 * * * *) |

### Logs

```bash
# Logs do cron
grep CRON /var/log/syslog
journalctl -u cron

# Saida dos scripts
0 * * * * /script.sh >> /var/log/script.log 2>&1
```

---

## Systemd Timers

### O que sao?

Timers sao a versao moderna do cron. Mais poderosos, com mais features.

### Criar timer

```bash
# Servico
cat > ~/.config/systemd/user/scan.service << 'EOF'
[Unit]
Description=Scan automatico

[Service]
Type=oneshot
ExecStart=/home/usuario/scripts/scan.sh
EOF

# Timer
cat > ~/.config/systemd/user/scan.timer << 'EOF'
[Unit]
Description=Executa scan a cada hora

[Timer]
OnCalendar=hourly
Persistent=true

[Install]
WantedBy=timers.target
EOF

# Ativar
systemctl --user daemon-reload
systemctl --user enable scan.timer
systemctl --user start scan.timer

# Verificar
systemctl --user list-timers
```

### Calendarios

```
OnCalendar=hourly          # A cada hora
OnCalendar=daily           # Todo dia
OnCalendar=weekly          # Toda semana
OnCalendar=*-*-* 02:00:00 # Todo dia as 2h
OnCalendar=Mon..Fri *-*-* 09:00:00  # Seg-Sex as 9h
OnCalendar=*-*-01 00:00:00  # Todo primeiro do mes
```

---

## at — Execucao Unica

```bash
# Agendar para daqui 5 minutos
echo "/scripts/scan.sh" | at now + 5 minutes

# Agendar para as 22h
echo "/scripts/backup.sh" | at 22:00

# Agendar para amanha
echo "/scripts/report.sh" | at tomorrow

# Ver tarefas
atq

# Remover tarefa
atrm 1
```

---

## Scripts de Autostart

### /etc/rc.local

```bash
# Executa no boot (antes do login)
cat > /etc/rc.local << 'EOF'
#!/bin/bash
# Meu script de boot
/home/usuario/scripts/start-services.sh &
exit 0
EOF
chmod +x /etc/rc.local
```

### Systemd service

```bash
cat > /etc/systemd/system/meu-servico.service << 'EOF'
[Unit]
Description=Meu servico customizado
After=network.target

[Service]
Type=simple
User=usuario
ExecStart=/home/usuario/scripts/meu-servico.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable meu-servico
systemctl start meu-servico
```

---

## Exemplo: Monitor de Seguranca

```bash
#!/bin/bash
# monitor.sh — Monitora mudancas no sistema

LOG="/var/log/security-monitor.log"
SNAPSHOT="/tmp/snapshot"

# Funcao de log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG"
}

# Verificar arquivos modificados
verificar_arquivos() {
    find /etc -mtime -1 -type f 2>/dev/null | while read ARQ; do
        log "ARQUIVO MODIFICADO: $ARQ"
    done
}

# Verificar servicos novos
verificar_servicos() {
    systemctl list-units --type=service --state=running | diff "$SNAPSHOT/services.txt" - > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        log "MUDANCA EM SERVICOS DETECTADA"
        systemctl list-units --type=service --state=running > "$SNAPSHOT/services.txt"
    fi
}

# Verificar usuarios
verificar_usuarios() {
    diff "$SNAPSHOT/users.txt" <(cut -d: -f1 /etc/passwd) > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        log "MUDANCA EM USUARIOS DETECTADA"
        cut -d: -f1 /etc/passwd > "$SNAPSHOT/users.txt"
    fi
}

# Criar snapshot inicial
mkdir -p "$SNAPSHOT"
if [ ! -f "$SNAPSHOT/services.txt" ]; then
    systemctl list-units --type=service --state=running > "$SNAPSHOT/services.txt"
    cut -d: -f1 /etc/passwd > "$SNAPSHOT/users.txt"
    log "Snapshot inicial criado"
fi

# Executar verificacoes
verificar_arquivos
verificar_servicos
verificar_usuarios
```

### Agendar com cron

```bash
# Rodar a cada 5 minutos
crontab -e
# */5 * * * * /home/usuario/scripts/monitor.sh
```

---

## Exemplo: Backup Automatico

```bash
#!/bin/bash
# backup.sh — Backup de arquivos importantes

set -euo pipefail

# Config
DESTINO="/backup"
DIA=$(date +%Y%m%d)
ARQUIVO="backup_${DIA}.tar.gz"
RETENCAO=7

# Criar destino
mkdir -p "$DESTINO"

# Backup
tar -czf "${DESTINO}/${ARQUIVO}" \
    /etc/ \
    /home/usuario/docs/ \
    /home/usuario/scripts/ \
    2>/dev/null

# Deletar backups antigos
find "$DESTINO" -name "backup_*.tar.gz" -mtime +$RETENCAO -delete

echo "Backup completo: ${DESTINO}/${ARQUIVO}"
```

### Agendar

```bash
# Todo dia as 2h
crontab -e
# 0 2 * * * /home/usuario/scripts/backup.sh >> /var/log/backup.log 2>&1
```

---

## Variaveis de Ambiente

```bash
# Ver todas
env
printenv

# Definir para sessao
export MEU_VAR="valor"

# Definir para sempre
echo 'export MEU_VAR="valor"' >> ~/.bashrc
source ~/.bashrc

# PATH — onde o bash procura comandos
echo $PATH
# /usr/local/bin:/usr/bin:/bin

# Adicionar ao PATH
export PATH="$PATH:/home/usuario/scripts"
```

---

## Exercicios Praticos

### Exercicio 1: Cron basico

```bash
# Crie um script que mostra a data e hora
cat > /tmp/hora.sh << 'EOF'
#!/bin/bash
echo "$(date)" >> /tmp/hora.log
EOF
chmod +x /tmp/hora.sh

# Agende para rodar a cada minuto
crontab -e
# * * * * * /tmp/hora.sh

# Espere 2 minutos e veja o log
cat /tmp/hora.log

# Limpe
crontab -r
rm /tmp/hora.sh /tmp/hora.log
```

### Exercicio 2: Timer systemd

```bash
# Crie um timer que roda a cada 10 minutos
cat > ~/.config/systemd/user/teste.service << 'EOF'
[Unit]
Description=Teste

[Service]
Type=oneshot
ExecStart=/bin/echo "Timer executou!"
EOF

cat > ~/.config/systemd/user/teste.timer << 'EOF'
[Unit]
Description=Timer de teste

[Timer]
OnCalendar=*:0/10
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now teste.timer
systemctl --user list-timers
```

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Criar e gerenciar tarefas com cron
- [ ] Usar systemd timers
- [ ] Agendar tarefas com at
- [ ] Criar scripts de autostart
- [ ] Automatizar backups e monitoramento
- [ ] Gerenciar variaveis de ambiente

---

<div align="center">

**⬅️ [Anterior: Tmux](11-tmux-e-screen.md)** | **[Lab](LABS.md) ➡️**

</div>
