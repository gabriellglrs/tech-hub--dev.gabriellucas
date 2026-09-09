# 🪟 Windows Básico

> Muitos alvos rodam Windows. Você precisa entender o básico do Windows para atacar e defender.

---

## 🏠 Analogia

```
Linux = Cozinha profissional (terminal, comandos)
Windows = Sala de estar (interface gráfica)

Para cybersegurança, você precisa dos dois:
- Linux para atacar
- Windows para entender o alvo
```

---

## 🔧 PowerShell (Terminal do Windows)

### Abrir PowerShell
```
Win + X → Windows PowerShell
Ou: Win + R → powershell → Enter
```

### Comandos Essenciais

```powershell
# Navegação
pwd                     # Onde estou
dir                     # Listar arquivos
cd C:\Users            # Mudar pasta
cd ..                   # Voltar uma pasta

# Arquivos
type arquivo.txt        # Ver conteúdo (como cat)
copy arquivo.txt copia.txt
move arquivo.txt novo.txt
del arquivo.txt

# Rede
ipconfig                # Ver IP
ipconfig /all           # Ver tudo
ping 8.8.8.8            # Testar conexão
nslookup google.com     # Consultar DNS
netstat -ano            # Ver portas abertas

# Processos
tasklist                # Listar processos
taskkill /PID 1234 /F   # Matar processo

# Serviços
net start               # Serviços rodando
net stop "NomeServiço"  # Parar serviço

# Usuários
net user                # Listar usuários
net user usuario senha  # Criar usuário
net localgroup administrators usuario /add  # Dar admin
```

---

## 📂 Onde ficam as coisas

| O que | Onde fica |
|:------|:----------|
| **Logs** | C:\Windows\System32\winevt\Logs\ |
| **Event Viewer** | Win + R → eventvwr.msc |
| **Registry** | Win + R → regedit |
| **Services** | Win + R → services.msc |
| **Task Manager** | Ctrl + Shift + Esc |
| **Control Panel** | Win + R → control |

---

## 🔐 Segurança no Windows

### Firewall
```powershell
# Ver status
Get-NetFirewallProfile

# Bloquear porta
New-NetFirewallRule -DisplayName "Block 4444" -Direction Inbound -LocalPort 4444 -Protocol TCP -Action Block

# Liberar porta
New-NetFirewallRule -DisplayName "Allow 80" -Direction Inbound -LocalPort 80 -Protocol TCP -Action Allow
```

### Usuários e Permissões
```powershell
# Ver quem é admin
net localgroup administrators

# Adicionar usuário ao grupo
net localgroup Administrators usuario /add

# Ver permissões de arquivo
icacls arquivo.txt
```

### Logs de Segurança
```powershell
# Ver logs de login
Get-WinEvent -LogName Security -MaxEvents 10

# Ver logs de sistema
Get-WinEvent -LogName System -MaxEvents 10
```

---

## 🎯 O que os atacantes procuram

| Alvo | Onde | Por quê |
|:-----|:-----|:--------|
| **Credenciais** | SAM, LSASS | Para escalar |
| **Hashes** | SAM database | Para cracking |
| **Firewall** | Regras | Para bypass |
| **Logs** | Event Viewer | Para apagar rastros |
| **Serviços** | Services.msc | Para persistência |

---

## 🔧 Ferramentas Windows para Segurança

| Ferramenta | O que faz |
|:-----------|:----------|
| **Process Explorer** | Ver processos detalhadamente |
| **Autoruns** | Ver o que inicia com o Windows |
| **TcpView** | Ver conexões de rede |
| **Sysmon** | Logs avançados do sistema |
| **PowerShell** | Automação e análise |

---

## ✅ Checkpoint

- [ ] Consigo usar PowerShell básico
- [ ] Sei onde ficam logs e registros
- [ ] Consigo ver processos e serviços
- [ ] Entendo o que atacantes procuram no Windows

---

<div align="center">

**⬅️ [Anterior: Python Básico](10-python-basico.md)** | **[Voltar ao README](README.md)**

</div>