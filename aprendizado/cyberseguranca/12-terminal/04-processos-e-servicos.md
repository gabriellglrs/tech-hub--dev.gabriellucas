# Processos e Servicos

> Todo programa que roda e um processo. Todo servico e um processo que roda em background. Gerenciar processos e essencial para seguranca.

---

## O que sao processos?

```
Quando voce abre o terminal:
- Um processo "bash" e criado

Quando voce roda um programa:
- Um processo e criado com um PID (Process ID)

Quando o programa termina:
- O processo e destruido
```

### PID — Identificador do Processo

Cada processo tem um numero unico (PID). E como o RG do processo.

```bash
# Meu processo bash atual
echo $$
# 12345 (seu PID)

# Ver processos
ps aux | grep bash
# usuario  12345  0.0  0.0  /bin/bash
```

---

## ps — Ver Processos

```bash
ps                        # Processos do terminal atual
ps aux                    # TODOS os processos (recomendado)
ps -ef                    # Todos (formato diferente)
ps aux | grep nginx       # Filtra por nome
ps -u usuario             # Processos de um usuario
ps -p 1234                # Detalhes de um PID
```

### Saida do `ps aux`

```
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root         1  0.0  0.0 169432 11836 ?        Ss   Jan06   0:02 /sbin/init
www-data   567  0.5  1.2 723456 48780 ?        Sl   Jan06  12:30 nginx: worker
usuario   1234  0.0  0.0  21456  3456 pts/0    Ss   10:00   0:00 -bash
```

### Colunas

| Coluna | Significado |
|:-------|:------------|
| USER | Dono do processo |
| PID | Numero identificador |
| %CPU | Uso de CPU |
| %MEM | Uso de memoria |
| VSZ | Memoria virtual |
| RSS | Memoria fisica |
| STAT | Status (S=sleeping, R=running, Z=zombie) |
| COMMAND | Comando que criou |

---

## top e htop — Monitor em Tempo Real

```bash
top                       # Monitor basico (atualiza a cada 1s)
htop                      # Versao bonita (precisa instalar)
```

### Instalar htop

```bash
sudo apt install htop
```

### Atalhos do top

| Tecla | Funcao |
|:------|:-------|
| `q` | Sair |
| `k` | Matar processo (mata pelo PID) |
| `1` | Mostra CPU de cada nucleo |
| `M` | Ordena por memoria |
| `P` | Ordena por CPU |
| `H` | Mostra threads |

### Atalhos do htop

| Tecla | Funcao |
|:------|:-------|
| `F5` | Arvore de processos |
| `F6` | Ordenar |
| `F9` | Matar processo |
| `F10` | Sair |
| `↑↓` | Navegar |

---

## kill — Matar Processos

```bash
kill 1234                 # Manda sinal SIGTERM (termina graciosamente)
kill -9 1234              # Manda SIGTERM (forca, so se nada funcionar)
kill -15 1234             # SIGTERM (padrao, mais gentil)
kill -HUP 1234            # SIGHUP (reinicia processo)
killall nginx             # Mata todos os processos nginx
pkill -f "python server"  # Mata processos que contenham "python server"
```

### Sinais Importantes

| Sinal | Numero | Funcao |
|:------|:------:|:-------|
| SIGHUP | 1 | Reinicia |
| SIGINT | 2 | Interrompe (Ctrl+C) |
| SIGKILL | 9 | Mata (nao pode ser ignorado) |
| SIGTERM | 15 | Termina graciosamente |
| SIGSTOP | 19 | Pausa |
| SIGCONT | 18 | Continua pausado |

### Analogia

```
kill 1234     = "Por favor, saia" (gentil)
kill -9 1234  = "SAIA AGORA" (forca total)
killall nginx = "Todos os nginx, SAIAM"
```

---

## bg e fg — Background e Foreground

```bash
# Rodar em background
comando &

# Ver processos em background
jobs

# Trazer para foreground
fg %1

# Pausar e mandar para background
Ctrl+Z
bg %1
```

### Exemplo

```bash
# Inicia scan em background
nmap -p- 192.168.1.0/24 &

# Continua trabalhando...
ls -la

# Ve os jobs em background
jobs
# [1]+  Running  nmap -p- 192.168.1.0/24 &

# Trazer para foreground
fg %1
```

---

## systemctl — Gerenciar Servicos

> Servicos sao processos que rodam em background e iniciam com o sistema.

```bash
systemctl status nginx              # Status do nginx
systemctl start nginx               # Inicia
systemctl stop nginx                # Para
systemctl restart nginx             # Reinicia
systemctl reload nginx              # Recarrega configuracao
systemctl enable nginx              # Habilita no boot
systemctl disable nginx             # Desabilita no boot
systemctl is-active nginx           # Esta ativo? (sim/nao)
systemctl is-enabled nginx          # Esta habilitado? (sim/nao)
```

### Ver todos os servicos

```bash
systemctl list-units --type=service              # Ativos
systemctl list-units --type=service --all         # Todos
systemctl --failed                                # Que falharam
systemctl list-unit-files --type=service          # Padrao do sistema
```

### logs de servicos

```bash
journalctl -u nginx                # Logs do nginx
journalctl -u nginx --since "1h"   # Ultima hora
journalctl -u nginx -f             # Logs em tempo real
journalctl -u nginx --no-pager     # Sem paginacao
```

---

## /proc — Arquivos de Processos

```bash
ls /proc/1234/             # Informacoes do processo PID 1234
cat /proc/1234/cmdline     # Comando que criou o processo
cat /proc/1234/status      # Status detalhado
cat /proc/1234/environ     # Variaveis de ambiente
```

### Por que isso e importante para seguranca?

```
Quando voce suspeita de um processo malicioso:
1. Descobre o PID: ps aux | grep suspeito
2. Ve o comando: cat /proc/PID/cmdline
3. Ve as variaveis: cat /proc/PID/environ
4. Ve onde esta: ls -la /proc/PID/exe
```

---

## Exercicios Praticos

### Exercicio 1: Liste processos

```bash
# Veja todos os processos
ps aux | head -20

# Conte quantos processos existem
ps aux | wc -l

# Encontre processos do nginx (se existir)
ps aux | grep nginx
```

### Exercicio 2: Mate um processo

```bash
# Abra um processo em background
sleep 1000 &

# Veja o PID
ps aux | grep sleep

# Mate
kill <PID>

# Verifique
ps aux | grep sleep
```

### Exercicio 3: Servicos

```bash
# Veja status do SSH
systemctl status sshd

# Veja todos os servicos ativos
systemctl list-units --type=service | grep active

# Veja se algum falhou
systemctl --failed
```

### Exercicio 4: htop

```bash
# Instale e abra
sudo apt install htop
htop

# Navegue com as setas
# Pressione F5 para ver arvore
# Pressione F10 para sair
```

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Listar processos com `ps aux`
- [ ] Monitorar com `top` ou `htop`
- [ ] Matar processos com `kill` e `killall`
- [ ] Usar `jobs`, `bg`, `fg` para background/foreground
- [ ] Gerenciar servicos com `systemctl`
- [ ] Ver logs de servicos com `journalctl`
- [ ] Investigar processos com `/proc`

---

<div align="center">

**⬅️ [Anterior: Permissoes](03-permissoes-e-usuarios.md)** | **[Proximo: Texto](05-texto-e-manipulacao.md) ➡️**

</div>
