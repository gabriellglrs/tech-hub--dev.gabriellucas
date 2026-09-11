# Maquinas Virtuais e Home Lab

> Maquinas virtuais sao computadores dentro do seu computador. Essencial para praticar seguranca sem quebrar nada.

---

## O que sao Maquinas Virtuais?

Uma **maquina virtual (VM)** e um computador simulado dentro do seu computador real. Um **Home Lab** e seu laboratorio pessoal onde voce pratica ataques e defesas sem riscos.

### Por que isso e importante?

- **Praticar seguranca** sem danar seu computador real
- **Criar ambientes de teste** — servidores vulneraveis para atacar
- **Snapshot** — se quebrar algo, volte ao estado anterior
- **Isolamento** — seus experimentos nao afetam a internet real
- **Kali Linux + Metasploitable** — setup padrao para aprender

---

## VirtualBox (Gratuito)

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
         Configuracoes → Rede
         → Adaptador 1: "Adapter nas redes host-only"

Passo 4: Inicie a VM
         Clique em "Iniciar"
         → Login: kali / kali
```

---

## Redes Virtuais

| Modo | O que faz | Quando usar |
|:-----|:----------|:------------|
| **NAT** | VM acessa internet pelo host | Acesso a internet |
| **Bridged** | VM esta na mesma rede fisica | Acessar VM de fora |
| **Host-only** | So comunica com host e outras VMs | **LAB SEGURO** |
| **Internal** | So comunica com outras VMs | Rede isolada |

> **Regra de ouro:** Use Host-only para seu lab — Isola suas VMs da internet real.

---

## VMs que voce precisa

### 1. Kali Linux (Atacante)

- Sistema com todas as ferramentas de seguranca
- Login padrao: `kali / kali`
- Download: https://www.kali.org/get-kali/

### 2. Metasploitable 2 (Vitima)

- Sistema INTENCIONALMENTE vulneravel
- Para praticar ataques
- Download: https://sourceforge.net/projects/metasploitable/files/

### 3. OWASP Juice Shop (Web vulneravel)

- Aplicacao web com falhas intencionais
- Para praticar web security
- Docker: `docker run -p 3000:3000 bkimminich/juice-shop`

---

## Snapshots (Seguranca)

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

## Validacao

Depois de estudar este arquivo, voce deve conseguir:

- [ ] Instalar VirtualBox
- [ ] Importar uma VM
- [ ] Entender a diferenca entre NAT e Host-only
- [ ] Tirar e restaurar um snapshot

---

<div align="center">

**⬅️ [Anterior: HTTP e Web](07-http-e-web.md)** | **[Proximo: Conceitos de Seguranca](../03-seguranca/09-conceitos-seguranca.md) ➡️**

</div>
