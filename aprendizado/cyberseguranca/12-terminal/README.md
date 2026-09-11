# Módulo 12: Terminal Linux — Do Zero ao Profissional

> Domine o terminal. Todo profissional de cyberseguranca vive no terminal. Aqui voce vai do "o que e isso?" ate automatizar tarefas complexas.

---

## Por que este modulo e essencial?

O terminal e a ferramenta #1 de qualquer profissional de seguranca. Todas as ferramentas (Nmap, Metasploit, Hydra, Burp) sao controladas via terminal. Sem dominar o terminal, voce e apenas um amador.

```
Nivel 1 (Basico):      cd, ls, pwd, cat
Nivel 2 (Intermediario): pipes, grep, find, chmod
Nivel 3 (Avancado):    bash scripting, automacao, vim, tmux
Nivel 4 (Profissional): scripts complexos, automacao completa, multi-terminal
```

---

## Estrutura

```
12-terminal/
├── README.md                       ← Este arquivo
├── 01-navegacao-basica.md          ← cd, ls, pwd, caminhos
├── 02-arquivos-e-diretorios.md     ← criar, copiar, mover, deletar
├── 03-permissoes-e-usuarios.md     ← chmod, chown, users, groups
├── 04-processos-e-servicos.md      ← ps, top, kill, systemctl
├── 05-texto-e-manipulacao.md       ← cat, head, tail, cut, awk, sed
├── 06-pipes-e-redirecionamento.md  ← |, >, >>, 2>, tee, xargs
├── 07-redes-no-terminal.md         ← ip, ping, nmap, ss, curl, wget
├── 08-bash-scripting-basico.md     ← variaveis, IF, loops, argumentos
├── 09-bash-scripting-avancado.md   ← funcoes, arrays, traps, debug
├── 10-edicao-vim.md                ← navegar, editar, macros, plugins
├── 11-tmux-e-screen.md             ← multi-terminal, sessoes, splits
├── 12-automacao-e-cron.md          ← cron, systemd timers, at
└── LABS.md                         ← 25+ exercicios praticos
```

---

## Ordem de Estudo

```
NIVEL BASICO (semanas 1-2):
  01-navegacao-basica.md → 02-arquivos-e-diretorios.md
  → 03-permissoes-e-usuarios.md → 04-processos-e-servicos.md

NIVEL INTERMEDIARIO (semanas 3-4):
  05-texto-e-manipulacao.md → 06-pipes-e-redirecionamento.md
  → 07-redes-no-terminal.md

NIVEL AVANCADO (semanas 5-6):
  08-bash-scripting-basico.md → 09-bash-scripting-avancado.md
  → 10-edicao-vim.md

NIVEL PROFISSIONAL (semanas 7-8):
  11-tmux-e-screen.md → 12-automacao-e-cron.md
  → LABS.md (exercicios integrados)

Pronto para Modulo 0 (Pre-Requisitos)!
```

---

## Checklist

### Basico
- [ ] Consigo navegar entre diretorios (cd, pwd)
- [ ] Consigo listar arquivos com opcoes (ls -la, ls -R)
- [ ] Consigo criar, copiar, mover e deletar arquivos
- [ ] Consigo entender e mudar permissoes (chmod)
- [ ] Consigo ver e matar processos (ps, kill)

### Intermediario
- [ ] Consigo usar pipes para encadear comandos
- [ ] Consigo manipular texto com grep, cut, awk, sed
- [ ] Consigo redirecionar saida e erros
- [ ] Consigo usar find para localizar arquivos
- [ ] Consigo usar xargs para executar comandos em massa

### Avancado
- [ ] Consigo escrever scripts bash com variaveis, IFs e loops
- [ ] Consigo usar funcoes e arrays em scripts
- [ ] Consigo usar o Vim para editar arquivos rapidamente
- [ ] Consigo debuggar scripts bash

### Profissional
- [ ] Consigo usar tmux para gerenciar multiplas sessoes
- [ ] Consigo automatizar tarefas com cron e systemd timers
- [ ] Consigo escrever scripts completos de automacao
- [ ] Consigo criar scripts de reconhecimento automatizados

---

## Dicas de Ouro

> **Dica 1:** Use `Tab` o tempo todo — autocompleta comandos, arquivos e diretorios. Economiza horas.

> **Dica 2:** `Ctrl+R` busca no historico de comandos. Digite parte do comando e aperte Enter.

> **Dica 3:** `!!` repete o ultimo comando. `sudo !!` repete como root.

> **Dica 4:** `Ctrl+C` cancela. `Ctrl+Z` pausa. `fg` retorna ao processo pausado.

> **Dica 5:** `man comando` e seu melhor amigo. `tldr comando` e uma versao resumida.

> **Dica 6:** Alias economiza tempo: `alias ll='ls -la'` no `.bashrc`.

> **Dica 7:** Aprenda o Vim. Todo servidor remoto tem ele. Nano nao existe em muitos lugares.

---

## Referencias

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| The Linux Command Line | Livro | [linuxcommand.org](https://linuxcommand.org/) |
| Explainshell | Referencia | [explainshell.com](https://explainshell.com/) |
| OverTheWire: Bandit | Lab | [overthewire.org](https://overthewire.org/wargames/bandit/) |
| Vim Adventures | Jogo | [vim-adventures.com](https://vim-adventures.com/) |
| tldr pages | Referencia | [tldr.sh](https://tldr.sh/) |

---

<div align="center">

**[Modulo 0: Pre-Requisitos](../00-pre-requisitos/)** | **[Lab](LABS.md)**

</div>
