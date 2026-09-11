# Guia de Instalação — Kali Linux

> Todo comando, instalação e ambiente assume Kali Linux. Este é o único SO suportado nesta trilha.

---

## Por que Kali Linux?

Kali Linux é o padrão da indústria para penetration testing e segurança ofensiva:

- **600+ ferramentas** de segurança pré-instaladas (Nmap, Metasploit, Burp Suite, etc.)
- **Padrão OSCP/CEH** — ambiente exigido por certificações profissionais
- **Rolling releases** — atualizações constantes com ferramentas modernas
- **Comunidade ativa** — documentação, tutoriais, suporte
- **Obrigatório nesta trilha** — todos os comandos assumem Kali

---

## Pré-requisitos

| Item | Mínimo | Recomendado |
|:-----|:-------|:------------|
| RAM | 4 GB | 8 GB |
| Disco | 50 GB | 80 GB |
| CPUs | 2 | 4 |
| Internet | Sim | Sim |

---

## Instalação via VirtualBox

### Passo 1: Baixar Kali Linux

```bash
# Acesse e baixe a ISO de rede (netinst) ou completa:
# https://www.kali.org/get-kali/
# Escolha: "Installer" → "amd64" (64 bits)
```

### Passo 2: Criar VM no VirtualBox

```
1. VirtualBox → Nova → Nome: "Kali Linux"
2. Tipo: Linux → Versão: Debian (64-bit)
3. Memória: 4096 MB (4 GB)
4. Disco virtual: 50 GB, VDI, dinâmico
5. CPU: 2 cores (Configurações → Sistema → Placa-mãe → Processador)
```

### Passo 3: Configurar VM

```
1. Configurações → Sistema → Desmarcar "Floppy"
2. Configurações → Rede → Adapter 1 → NAT (para internet)
3. Configurações → Rede → Adapter 2 → Host-only (para lab local)
4. Configurações → Armazenário → Inserir ISO do Kali
```

### Passo 4: Instalar Kali

```
1. Iniciar VM → Graphical install
2. Idioma: Português (Brasil) ou English
3. Local: Brasil ou United States
4. Hostname: kali
5. Usuário: kali / Senha: kali (ou crie sua própria)
6. Disco: Use o disco inteiro (Guided - use entire disk)
7. Desktop: XFCE (recomendado, leve) ou GNOME
8. Instalar GRUB: Sim → /dev/sda
9. Reiniciar
```

### Passo 5: Instalar Guest Additions

```bash
# Após instalar o Kali, dentro da VM:
sudo apt update && sudo apt upgrade -y
sudo apt install -y virtualbox-guest-x11
# Reiniciar a VM
```

---

## Instalação via VMware

### Passo 1: Baixar VMware Workstation Pro

```
# https://www.vmware.com/products/workstation-pro.html
# Gratuito para uso pessoal
```

### Passo 2: Criar VM

```
1. File → New Virtual Machine
2. Typical → Installer disc image (ISO): selecione ISO do Kali
3. Guest OS: Linux → Debian 12.x 64-bit
4. Disk: 50 GB, Split
5. Customize Hardware: RAM 4 GB, CPUs 2
6. Finish → Power on
```

### Passo 3: VMware Tools

```bash
# Dentro do Kali:
sudo apt update && sudo apt upgrade -y
sudo apt install -y open-vm-tools-desktop
sudo reboot
```

---

## Primeira Configuração

### Atualizar sistema

```bash
sudo apt update && sudo apt upgrade -y
```

### Instalar ferramentas básicas

```bash
# Ferramentas essenciais que NÃO vêm pré-instaladas
sudo apt install -y git curl wget python3-pip golang-go
```

### Configurar Git

```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"
```

### Criar diretório de trabalho

```bash
mkdir -p ~/cyberseguranca/{labs,tools,notes}
cd ~/cyberseguranca
```

---

## Verificação de Ferramentas

### Script de verificação

```bash
echo "=== Verificando ferramentas essenciais ==="
for cmd in nmap msfconsole python3 pip3 git curl wget; do
    if command -v $cmd &> /dev/null; then
        echo "✓ $cmd instalado"
    else
        echo "✗ $cmd NÃO instalado"
    fi
done
```

### Output esperado

```
=== Verificando ferramentas essenciais ===
✓ nmap instalado
✓ msfconsole instalado
✓ python3 instalado
✓ pip3 instalado
✓ git instalado
✓ curl instalado
✓ wget instalado
```

### Verificar versões específicas

```bash
nmap --version
# Nmap version 7.95 ( https://nmap.org )

msfconsole --version
# Metasploit Framework 6.x

python3 --version
# Python 3.12.x
```

---

## Snapshots

### Criar snapshot após instalação limpa

```
VirtualBox → Kali Linux → Snapshots → Take
Nome: "Instalação limpa - [data]"
Descrição: "Kali atualizado com ferramentas básicas"
```

### Por que snapshots são importantes

| Situação | Ação |
|:---------|:-----|
| Quebrou algo no lab | Restaurar snapshot anterior |
| Laboratório concluído | Criar snapshot antes do próximo |
| Atualização quebrou | Restaurar snapshot |

### Criar snapshot via CLI (VirtualBox)

```bash
# Listar VMs
VBoxManage list vms

# Criar snapshot
VBoxManage snapshot "Kali Linux" take "Snapshot-$(date +%Y%m%d)"
```

---

## Instalação Automática de Tudo

### Script completo

```bash
#!/bin/bash
# install-all.sh — Instalação completa para a trilha
# Uso: bash install-all.sh

echo "=== Atualizando sistema ==="
sudo apt update && sudo apt upgrade -y

echo "=== Instalando ferramentas de Reconhecimento ==="
sudo apt install -y nmap masscan theharvester amass whatweb dnsutils whois

echo "=== Instalando ferramentas de Web ==="
sudo apt install -y wpscan nikto sqlmap gobuster feroxbuster

echo "=== Instalando ferramentas de Exploração ==="
sudo apt install -y hydra john hashcat seclists

echo "=== Instalando ferramentas de Pós-Exploração ==="
sudo apt install -y socat netcat-openbsd

echo "=== Instalando ferramentas de Reversing ==="
sudo apt install -y radare2 gdb

echo "=== Instalando ferramentas de Rede ==="
sudo apt install -y wireshark tshark tcpdump bettercap proxychains4 tor

echo "=== Instalando ferramentas de Defesa ==="
sudo apt install -y lynis ufw fail2ban yara

echo "=== Instalando ferramentas de Governança ==="
sudo apt install -y openscap-scanner scap-security-guide openssl gnupg

echo "=== Instalando Docker ==="
sudo apt install -y docker.io
sudo usermod -aG docker $USER

echo "=== Instalando pip packages ==="
pip3 install impacket pwntools bcrypt

echo "=== Verificação final ==="
for cmd in nmap msfconsole python3 git docker lynis; do
    command -v $cmd &> /dev/null && echo "✓ $cmd" || echo "✗ $cmd"
done

echo "✅ Instalação concluída!"
echo "⚠️  Faça logout/login para Docker funcionar"
```

### Uso

```bash
chmod +x install-all.sh
bash install-all.sh
```

---

## Solução de Problemas

| Problema | Solução |
|:---------|:--------|
| `apt update` falha | Verificar conexão: `ping google.com` |
| `msfconsole` não abre | Reinstalar: `sudo apt install metasploit-framework` |
| VM lenta | Aumentar RAM/CPU nas configurações |
| Sem internet na VM | Verificar NAT adapter no VirtualBox |
| Guest Additions não funciona | `sudo apt install -y virtualbox-guest-x11 && sudo reboot` |

---

## Referências

- [Kali Linux Official](https://www.kali.org/)
- [Kali Documentation](https://www.kali.org/docs/)
- [Kali Tools](https://www.kali.org/tools/)
