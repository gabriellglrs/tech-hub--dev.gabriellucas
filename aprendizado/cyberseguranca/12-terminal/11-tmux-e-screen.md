# Tmux e Screen — Multi-Terminal

> Gerenciar multiplos terminais em uma janela. Essencial para pentest — voce precisa de um scan rodando enquanto faz outra coisa.

---

## O que sao tmux e screen?

```
Terminal normal:
┌──────────────────────┐
│  Um comando rodando  │  ← Se fechar, perde tudo
└──────────────────────┘

Tmux/Screen:
┌──────────────────────┐
│  Pane 1  │  Pane 2   │
│  Nmap    │  Hydra     │  ← Sessoes persistem
│──────────│───────────│
│  Pane 3  │  Pane 4   │
│  Bash    │  Editor    │
└──────────────────────┘
```

---

## Tmux — O Padrão

### Instalar

```bash
sudo apt install tmux
```

### Iniciar

```bash
tmux                       # Nova sessao
tmux new -s nome           # Sessao com nome
tmux ls                   # Lista sessoes
tmux a -t nome             # Anexa a sessao
tmux kill-session -t nome  # Mata sessao
```

---

## Atalhos do Tmux

> Todo atalho do tmux comeca com `Ctrl+b` (prefixo)

### Sessoes

| Atalho | Funcao |
|:-------|:-------|
| `Ctrl+b c` | Nova aba |
| `Ctrl+b ,` | Renomeia aba |
| `Ctrl+b w` | Lista abas |
| `Ctrl+b n` | Proxima aba |
| `Ctrl+b p` | Aba anterior |
| `Ctrl+b &` | Fecha aba |

### Janelas (Panes)

| Atalho | Funcao |
|:-------|:-------|
| `Ctrl+b %` | Split vertical |
| `Ctrl+b "` | Split horizontal |
| `Ctrl+b ←↑↓→` | Navega entre panes |
| `Ctrl+b x` | Fecha pane atual |
| `Ctrl+b z` | Zoom no pane (fullscreen) |
| `Ctrl+b {` | Move pane pra esquerda |
| `Ctrl+b }` | Move pane pra direita |
| `Ctrl+b Space` | Alterna layouts |

### Sessao

| Atalho | Funcao |
|:-------|:-------|
| `Ctrl+b d` | Desanexa (deixa rodando) |
| `Ctrl+b [` | Modo scroll (setas/pgup) |
| `Ctrl+b ]` | Cola buffer |
| `Ctrl+b :` | Modo comando |

---

## Exemplo Completo

```bash
# Criar sessao de pentest
tmux new -s pentest

# Split: scan de um lado, editor de outro
Ctrl+b %
# No pane da direita:
vim notas.txt

# Split horizontal: mais um terminal
Ctrl+b "

# Renomear abas
Ctrl+b , 
# Digite: recon
```

### Layout pronto

```bash
# Tmuxinator (layout automatico)
# Instalar
gem install tmuxinator

# Criar projeto
tmuxinator new pentest

# Configurar ~/.tmuxinator/pentest.yml
# project_name: pentest
# windows:
#   - recon:
#       layout: main-vertical
#       panes:
#         - nmap -sV 192.168.1.1
#         - vim notas.txt
#   - exploit:
#       panes:
#         - msfconsole

# Iniciar
tmuxinator start pentest
```

---

## Persistencia

```bash
# Tmux persiste mesmo se fechar o terminal:
# 1. Roda tmux new -s trabalho
# 2. Fecha o terminal
# 3. Abre novo terminal
# 4. tmux a -t trabalho
# 5. Tudo continua rodando!
```

---

## Screen — A Alternativa

### Instalar

```bash
sudo apt install screen
```

### Comandos

```bash
screen                      # Nova sessao
screen -ls                  # Lista sessoes
screen -r -d -S nome        # Cria e anexa
screen -r nome              # Anexa a sessao
screen -X -S nome quit      # Mata sessao
```

### Atalhos do Screen

> Prefixo: `Ctrl+a`

| Atalho | Funcao |
|:-------|:-------|
| `Ctrl+a c` | Nova janela |
| `Ctrl+a n` | Proxima janela |
| `Ctrl+a p` | Janela anterior |
| `Ctrl+a "` | Lista janelas |
| `Ctrl+a A` | Renomeia janela |
| `Ctrl+a d` | Desanexa |
| `Ctrl+a k` | Fecha janela |
| `Ctrl+a S` | Split horizontal |
| `Ctrl+a \|` | Split vertical |
| `Ctrl+a Tab` | Alterna entre splits |

---

## Tmux vs Screen

| Feature | Tmux | Screen |
|:--------|:-----|:-------|
| Layouts | Sim | Limitado |
| Mouse | Sim | Nao |
| Scripts | Sim | Limitado |
| Disponibilidade | Mais comum | Em todo servidor |
| Complexidade | Facil | Facil |

**Recomendacao:** Use tmux quando disponivel, screen como fallback.

---

## Exemplo de Pentest

```bash
# Sessao completa
tmux new -s pentest

# Pane 1: Scan Nmap
nmap -sV -sC -p- 192.168.1.1 | tee scan.txt

# Pane 2: Monitoramento
Ctrl+b "
htop

# Pane 3: Notas
Ctrl+b %
vim notas.txt

# Pane 4: Exploit (quando achar algo)
Ctrl+b "
msfconsole
```

---

## Configuracao (.tmux.conf)

```bash
cat > ~/.tmux.conf << 'EOF'
# Mude o prefixo para Ctrl+a
unbind C-b
set -g prefix C-a
bind C-a send-prefix

# Split com | e -
bind | split-window -h
bind - split-window -v

# Navegacao com setas (sem prefixo)
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D

# Mouse
set -g mouse on

# Numeracao (comeca em 1)
set -g base-index 1
setw -g pane-base-index 1

# Historico
set -g history-limit 50000

# Cores
set -g default-terminal "screen-256color"
EOF
```

---

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Iniciar e gerenciar sessoes tmux
- [ ] Criar e navegar entre panes
- [ ] Desanexar e reconectar a sessoes
- [ ] Usar screen como alternativa
- [ ] Configurar tmux com .tmux.conf
- [ ] Criar layouts de pentest

---

<div align="center">

**⬅️ [Anterior: Vim](10-edicao-vim.md)** | **[Proximo: Automacao](12-automacao-e-cron.md) ➡️**

</div>
