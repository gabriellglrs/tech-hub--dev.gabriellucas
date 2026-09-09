# 🖥️ Máquinas Virtuais e Home Lab

> **Máquinas virtuais** são computadores dentro do seu computador. É como ter vários PCs sem comprar nada. Essencial para praticar segurança sem quebrar nada.

## 📚 O que são Máquinas Virtuais e Home Lab?

Uma **máquina virtual (VM)** é um computador simulado dentro do seu computador real. Um **Home Lab** é seu laboratório pessoal onde você pratica ataques e defesas sem riscos.

### Por que isso é importante?

- **Praticar segurança** sem danar seu computador real
- **Criar ambientes de teste** — servidores vulneráveis para atacar
- **Snapshot** — se quebrar algo, volte ao estado anterior
- **Isolamento** — seus experimentos não afetam a internet real
- **Kali Linux + Metasploitable** — setup padrão para aprender

### Como funciona na prática?

```
┌─────────────────────────────────────────────────┐
│              SEU COMPUTADOR (Host)               │
│                                                  │
│  ┌─────────────┐  ┌─────────────┐               │
│  │  KALI LINUX │  │ METASPLOIT  │               │
│  │  (Atacante) │  │ (Vítima)    │               │
│  └──────┬──────┘  └──────┬──────┘               │
│         └───────┬────────┘                       │
│         ┌───────┴───────┐                        │
│         │  Rede Virtual │                        │
│         └───────────────┘                        │
└─────────────────────────────────────────────────┘
```

Para montar seu Home Lab, você precisa saber:
- **VirtualBox/VMware** — criar e gerenciar VMs
- **Redes virtuais** — Host-only, NAT, Bridged
- **Snapshots** — salvar e restaurar estados
- **Kali Linux** — distribuição para pentest
- **Metasploitable** — VM vulnerável para praticar

---

## 🏠 Analogia

```
Seu computador real = Casão com vários apartamentos
Máquinas virtuais = Apartamentos dentro do casão

Cada "apartamento" (VM) é um computador independente:
- Tem seu próprio sistema operacional
- Roda seus próprios programas
- Pode ser destruído sem afetar os outros
```

---

## 📋 O que é um Home Lab?

**Home Lab** é seu laboratório pessoal de segurança:

```
┌─────────────────────────────────────────────────┐
│              SEU COMPUTADOR (Host)               │
│                                                  │
│  ┌─────────────┐  ┌─────────────┐               │
│  │  KALI LINUX │  │ METASPLOIT  │               │
│  │  (Atacante) │  │ (Vítima)    │               │
│  │  192.168.56.10│ │ 192.168.56.20│              │
│  └──────┬──────┘  └──────┬──────┘               │
│         │                │                       │
│         └───────┬────────┘                       │
│                 │                                │
│         ┌───────┴───────┐                        │
│         │  Rede Virtual │                        │
│         │ 192.168.56.0/24│                       │
│         └───────────────┘                        │
└─────────────────────────────────────────────────┘
```

---

## 🔧 VirtualBox (Gratuito)

### O que é?
Software gratuito que cria máquinas virtuais. É o mais usado para iniciantes.

### Como instalar?
```bash
# Ubuntu/Debian
sudo apt install virtualbox

# Ou baixe de: https://www.virtualbox.org/wiki/Downloads
```

### Criar sua primeira VM

```
Passo 1: Baixe o Kali Linux
         https://www.kali.org/get-kali/
         → "Virtual Machines" → "VirtualBox"
         → Baixe o arquivo .ova (~5GB)

Passo 2: Importe no VirtualBox
         Arquivo → Importar Aplicativo
         → Selecione o arquivo .ova
         → Importar

Passo 3: Configure a rede
         Configurações → Rede
         → Adaptador 1: "Adapter nas redes host-only"

Passo 4: Inicie a VM
         Clique em "Iniciar"
         → Login: kali / kali
```

---

## 📊 Redes Virtuais

| Modo | O que faz | Quando usar |
|:-----|:----------|:------------|
| **NAT** | VM acessa internet pelo host | Acesso à internet |
| **Bridged** | VM está na mesma rede física | Acessar VM de fora |
| **Host-only** | Só comunica com host e outras VMs | **LAB SEGURO** |
| **Internal** | Só comunica com outras VMs | Rede isolada |

### ⚠️ Regra de ouro
> **Use Host-only para seu lab** — Isola suas VMs da internet real

---

## 📦 VMs que você precisa

### 1. Kali Linux (Atacante)
- Sistema com todas as ferramentas de segurança
- Login padrão: `kali / kali`
- Download: https://www.kali.org/get-kali/

### 2. Metasploitable 2 (Vítima)
- Sistema INTENCIONALMENTE vulnerável
- Para praticar ataques
- Download: https://sourceforge.net/projects/metasploitable/files/

### 3. OWASP Juice Shop (Web vulnerable)
- Aplicação web com falhas intencionais
- Para praticar web security
- Docker: `docker run -p 3000:3000 bkimminich/juice-shop`

---

## 🛡️ Snapshots (Segurança)

**Snapshot** salva o estado da VM. Se algo quebrar, volte ao snapshot:

```
1. Configure sua VM
2. Tire um snapshot ("Estado limpo")
3. Experimente (pode quebrar!)
4. Se quebrar → Volte ao snapshot
5. Pronto! Tudo volta ao normal
```

### Como tirar snapshot
```
VirtualBox → Clique na VM → Snapshots → Adicionar
→ Nome: "Estado limpo"
→ OK
```

---

## ✅ Checkpoint

- [ ] Consigo instalar VirtualBox
- [ ] Consigo importar uma VM
- [ ] Entendo a diferença entre NAT e Host-only
- [ ] Consigo tirar e restaurar um snapshot

---

<div align="center">

**⬅️ [Anterior: HTTP e Web](../02-sistemas/07-http-e-web.md)** | **[Próximo: Conceitos de Segurança](../03-seguranca/09-conceitos-seguranca.md) ➡️**

</div>
