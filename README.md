<div align="center">

# 🐧 Minhas Config Linux Terminal

### Zsh + Oh My Zsh + Powerlevel10k pronto pra dev e cyberseg

**zsh • p10k • fzf • zoxide • eza • bat • ripgrep**

</div>

---

## 👀 Preview

> Dica: tire um print com `fastfetch` + `ll` e salve como `docs/preview.png`

Prompt atual: segmento OS + `~` (esquerda) + `✔ at HH:MM:SS` (direita) — estilo `lean` powerline.

---

## 📂 O que vem no repo?

```
minhas_config_linux_terminal/
├── install.sh        # instalador automático com backup
├── .gitignore
├── zsh/
│   ├── .zshrc        # <-- seu ~/.zshrc exportado do Ubuntu
│   └── .p10k.zsh     # <-- seu ~/.p10k.zsh (p10k configure)
└── docs/
    └── preview.png   # print do terminal
```

| Arquivo | Vai para |
|:---|:---|
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.p10k.zsh` | `~/.p10k.zsh` |

---

## ✅ Pré-requisitos

- Ubuntu 22.04/24.04
- Fonte Nerd Font (JetBrainsMono NF) selecionada no terminal
- `git`

## 🚀 Instalação em 30 segundos (máquina nova)

```bash
git clone https://github.com/gabriellglrs/minhas_config_linux_terminal.git
cd minhas_config_linux_terminal
chmod +x install.sh
./install.sh            # só base dev
./install.sh --sec     # base + cyberseg (nmap, sqlmap, nikto, hydra, john, hashcat, wireshark, tcpdump, nc, socat, gobuster, ffuf)
exec zsh
```

> Só copiar sem instalar nada:
> ```bash
> ./install.sh --copy-only
> ```

## 💾 Exportar sua config atual (no Ubuntu onde já está pronto)

Rode **no Ubuntu com o terminal configurado**:

```bash
cd ~/minhas_config_linux_terminal  # ou onde você clonou
cp ~/.zshrc ./zsh/.zshrc
cp ~/.p10k.zsh ./zsh/.p10k.zsh 2>/dev/null || echo "sem .p10k.zsh (rode p10k configure)"
# opcional: lista de pacotes pra documentar
dpkg --get-selections | grep -E "zsh|fzf|ripgrep|bat|eza|zoxide" > docs/packages.txt
git add zsh/.zshrc zsh/.p10k.zsh
git commit -m "feat: exporta zsh + p10k do Ubuntu"
git push
```

Depois pra editar e salvar de volta:
```bash
cp ~/.zshrc ./zsh/.zshrc
git add . && git commit -m "feat: atualiza zshrc" && git push
```

## 🛠️ Problemas comuns

| Sintoma | Solução |
|:---|:---|
| 🔲 Ícones `�` | instale Nerd Font + selecione no terminal |
| `fd/bat não encontrado` | no Ubuntu é `fdfind/batcat` — o install.sh já cria link em `~/.local/bin` |
| Shell ainda é bash | `chsh -s $(which zsh)` + logout/login |
| Prompt quebrou após copiar | `p10k configure` e depois re-exporte com `cp ~/.p10k.zsh ./zsh/.p10k.zsh` |

## 🔄 Manutenção

```bash
# atualizar plugins/tema
git -C ~/.oh-my-zsh/custom/themes/powerlevel10k pull
git -C ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions pull
```
