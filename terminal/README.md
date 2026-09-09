# 🖥️ Terminal — Comandos Linux

> Guia prático de comandos para uso diário no terminal. Foco em produtividade e administração.

---

## 📂 Estrutura planejada

| Arquivo | Descrição |
|:---|:---|
| `01-comandos-basicos.md` | `ls, cd, cp, mv, rm, mkdir, cat, less, grep, find` |
| `02-bash-zsh.md` | `alias, history, pipes, redirects, zsh + oh-my-zsh + p10k` |
| `03-arquivos-permissoes.md` | `chmod, chown, umask, ACL, links` |
| `04-processos-sistema.md` | `ps, top/htop, kill, systemd, journalctl` |
| `05-rede-terminal.md` | `ip, ss, ping, curl, ssh, scp, rsync` |
| `06-texto-filtros.md` | `awk, sed, cut, sort, uniq, xargs, ripgrep` |

---

## 🚀 Como usar

Cada guia segue o padrão: **conceito + flags + exemplos práticos copiar e colar**.

```bash
# Exemplo
ls -la --color
rg "pattern" . --hidden
fd -e py -x wc -l
```

> Crie os arquivos conforme for usando. Comece por `01-comandos-basicos.md`.
