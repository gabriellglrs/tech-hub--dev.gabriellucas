# 🛠️ Ferramentas de Desenvolvimento

> Ferramentas que tornam o terminal muito mais produtivo. Instaladas com `./install.sh` (sem `--sec`).

---sim

## 🚀 Passo a Passo — Como usar as Ferramentas Dev

Essas ferramentas substituem comandos clássicos por versões muito melhores. Vamos configurar tudo.

### Passo 1: Configurar aliases no .zshrc
```bash
# Adicione essas linhas no final do seu ~/.zshrc:
alias cat="bat --paging=never"
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias lt="eza --tree --level=2 --icons"
alias find="fd"
alias grep="rg"

# Depois recarregue:
source ~/.zshrc
```

### Passo 2: Testar cada ferramenta
```bash
# Agora teste:
cat arquivo.py        # deve mostrar com syntax highlighting
ll                    # deve listar com ícones
lt                    # deve mostrar árvore
fd .txt               # deve buscar arquivos
rg "function" .       # deve buscar conteúdo
```

### Passo 3: Aprender os atalhos do fzf
```bash
# Pressione Ctrl+T → aparece um seletor de arquivos
# Pressione Ctrl+R → busca no histórico de comandos
# Pressione Alt+C  → busca diretórios para fazer cd
```

### Passo 4: Usar zoxide para navegar
```bash
# Em vez de: cd /home/user/projetos/python/meu_projeto
# Digite apenas:
z meu_projeto

# Para voltar ao diretório anterior:
z -
```

### Resumo da ordem:
```
1. Editar ~/.zshrc → adicionar aliases
2. source ~/.zshrc → recarregar
3. Testar cat/ll/lt → ver se funciona
4. Ctrl+T/Ctrl+R   → testar fzf
5. z projeto        → testar zoxide
```

---

## fzf — Fuzzy Finder

Busca interativa em arquivos, histórico, processos, branches git, etc.

### Atalhos no Zsh

| Atalho | Função |
|:---|:---|
| `Ctrl+T` | Buscar arquivo no diretório atual |
| `Ctrl+R` | Buscar no histórico de comandos |
| `Alt+C` | Buscar e cd para um diretório |

### Uso via terminal

```bash
# Buscar arquivos
find . -type f | fzf

# Buscar com preview
find . -type f | fzf --preview 'cat {}'

# Buscar com extensão específica
find . -type f -name "*.py" | fzf

# Buscar no histórico
history | fzf

# Buscar processos
ps aux | fzf

# Buscar IP no histórico
history | fzf | grep -oP '\d+\.\d+\.\d+\.\d+'

# Kill process interativamente
kill -9 $(ps aux | fzf | awk '{print $2}')

# Git branch interativo
git branch | fzf | xargs git checkout

# Git log interativo
git log --oneline | fzf | cut -d' ' -f1 | xargs git show
```

### Config no .zshrc
```bash
# Ativar fzf como plugin do Zsh (se instalado)
# Adicionar ao plugins: plugins=(git fzf ...)
```

---

## fd — Find, mas moderno

Busca de arquivos com syntax mais amigável e mais rápido que `find`.

> No Ubuntu, o pacote se chama `fdfind`. O install.sh cria um symlink `fd → fdfind`.

### Exemplos práticos

```bash
# Buscar arquivo por nome
fd .txt
fd arquivo

# Buscar por extensão
fd -e py
fd -e js -e ts

# Buscar em diretório específico
fd . /home/user/projeto

# Ignorar diretórios
fd -E node_modules -E .git

# Buscar por regex
fd "^[A-Z].*\.py$"

# Listar apenas arquivos (sem diretórios)
fd -t f

# Listar apenas diretórios
fd -t d

# Buscar arquivo modificado nos últimos 7 dias
fd -t f --changed-within 7d

# Buscar com tamanho
fd -t f -S +10M    # maiores que 10MB
fd -t f -S -1k     # menores que 1KB

# Executar comando em cada resultado
fd -e py -x wc -l    # contar linhas de cada .py
fd -e log -x rm      # deletar todos os .log

# Output null-separated (para usar com xargs)
fd -0 .txt | xargs -0 rm
```

### vs find

| Comando fd | Comando find equivalente |
|:---|:---|
| `fd .txt` | `find . -name "*txt*"` |
| `fd -e py` | `find . -name "*.py"` |
| `fd -t f` | `find . -type f` |
| `fd -S +10M` | `find . -size +10M` |
| `fd --changed-within 7d` | `find . -mtime -7` |

---

## bat — cat com syntax highlighting

`cat` moderno com numeração de linhas, syntax highlighting e Git integration.

> No Ubuntu, o pacote se chama `batcat`. O install.sh cria um symlink `bat → batcat`.

### Exemplos práticos

```bash
# Ver arquivo com syntax highlighting
bat arquivo.py
bat script.sh

# Ver com numeração de linhas
bat -n arquivo.py

# Ver sem numeração
bat --plain arquivo.py

# Ver todas as linhas (sem pager)
bat --paging=never arquivo.py

# Ver com linguagem específica
bat -l json arquivo.txt

# Ver como linguagem específica
bat --language python arquivo.txt

# Highlight de linhas específicas
bat --highlight-line 10 arquivo.py

# Ver como linhas
bat -l sh arquivo.sh

# Ver com header/footer
bat --decorations=always arquivo.py

# Comparar arquivos
diff <(bat a.py) <(bat b.py)

# Ver com wrap
bat --wrap=auto arquivo.py

# Integrar com less
export BAT_PAGER="less -RF"
```

### Aliases úteis (adicionar ao .zshrc)
```bash
alias cat="bat --paging=never"
alias catpy="bat -l python"
alias catsh="bat -l sh"
```

---

## eza — ls moderno

`ls` com ícones, cores, tree view e Git status.

### Exemplos práticos

```bash
# Listar com cores e ícones
eza --icons

# Listar com detalhes
eza -la

# Tree view
eza --tree

# Tree com profundidade
eza --tree --level=2

# Tree com ícones
eza --tree --icons

# Listar com Git status
eza -la --git

# Ordenar por tamanho
eza -la --sort=size

# Ordenar por modificação
eza -la --sort=modified

# Listar apenas diretórios
eza -d */

# Listar com header
eza -la --header

# Tree com apenas arquivos
eza --tree --level=2 -f

# Cores personalizadas
eza --color=always

# Octal permissions
eza -la --permissions=octal
```

### Aliases úteis (adicionar ao .zshrc)
```bash
alias ll="eza -la --icons --git"
alias lt="eza --tree --level=2 --icons"
alias la="eza -la --icons"
```

---

## zoxide — cd inteligente

`cd` que lembra seus diretórios e permite navegar com poucas letras.

### Exemplos práticos

```bash
# Navegar para um diretório que você visitou antes
z projeto          # vai para o diretório mais recente que contém "projeto"
z doc              # vai para ~/Documents ou qualquer pasta com "doc"
z src              # vai para ~/src

# Voltar ao diretório anterior
z -

# Listar diretórios conhecidos
z -l               # ou: zoxide query -l

# Buscar diretórios
z -l | grep python

# Interativo (como fzf)
zi                  # busca interativa de diretórios

# Adicionar diretório manualmente
zoxide add /caminho/para/diretorio

# Query (buscar sem navegar)
zoxide query projeto
zoxide query -l     # listar todos
```

### Comando principal

| Comando | Função |
|:---|:---|
| `z texto` | cd para diretório que contenha "texto" |
| `z -` | voltar ao diretório anterior |
| `zi` | busca interativa |
| `z -l` | listar diretórios conhecidos |

### Configuração
```bash
# zoxide é inicializado automaticamente pelo install.sh
# Se precisar adicionar manualmente ao .zshrc:
eval "$(zoxide init zsh)"
```

---

## ripgrep (rg) — grep moderno

Busca em conteúdo de arquivos muito mais rápido que grep.

### Exemplos práticos

```bash
# Buscar texto em arquivos
rg "pattern" .

# Buscar case-insensitive
rg -i "error" .

# Buscar por extensão
rg -t py "function"
rg -t js "import"
rg -t json "key"

# Ignorar extensão
rg -T js "pattern"

# Listar arquivos que contêm o padrão
rg -l "pattern" .

# Contar ocorrências
rg -c "pattern" .

# Buscar com contexto (linhas antes/depois)
rg -C 3 "error" .    # 3 linhas antes e depois
rg -B 2 "error" .    # 2 linhas antes
rg -A 2 "error" .    # 2 linhas depois

# Buscar em arquivos ignorados (git)
rg --hidden "pattern" .
rg -u "pattern" .    # untracked também

# Buscar com regex
rg "^\s*def\s+\w+" .          # definições de função Python
rg "https?://[^\s]+" .         # URLs

# Buscar e substituir (usar sed depois)
rg -l "old_string" | xargs sed -i 's/old_string/new_string/g'

# Buscar em stream (stdin)
echo "teste" | rg "test"

# Buscar com encoding
rg -e "utf8" --encoding utf-8 .

# Ignorar diretórios
rg --glob='!node_modules' "pattern" .

# Estatísticas
rg -c "pattern" . | sort -t: -k2 -n -r | head -10
```

### Aliases úteis
```bash
alias grep="rg"
```

### vs grep

| Comando rg | Comando grep equivalente |
|:---|:---|
| `rg "pattern" .` | `grep -r "pattern" .` |
| `rg -l "pattern"` | `grep -rl "pattern"` |
| `rg -c "pattern"` | `grep -rc "pattern"` |
| `rg -i "pattern"` | `grep -ri "pattern"` |
| `rg -t py "pattern"` | `grep -r --include="*.py" "pattern"` |

---

## Resumo dos aliases

Adicione ao seu `~/.zshrc`:

```bash
# Modern tools
alias cat="bat --paging=never"
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias lt="eza --tree --level=2 --icons"
alias find="fd"
alias grep="rg"

# Navigation
# zoxide já sobrescreve cd automaticamente

# fzf já funciona com Ctrl+T, Ctrl+R, Alt+C
```
