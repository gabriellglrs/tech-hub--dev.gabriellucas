# 🎯 Módulo 5: Pós-Exploração

> Seja o fantasma da rede — mantenha acesso, escale privilégios e domine o ambiente.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 📁 Arquivos | 🔧 Ferramentas |
|:--------:|:--------:|:-----------:|:--------------:|
| 5-6 horas | ⭐⭐⭐ Avançado | 2 | 10 |

</div>

---

## 🎓 Objetivos do Módulo

Ao final deste módulo, você será capaz de:

- [ ] Manter acesso persistente em sistemas comprometidos
- [ ] Escalar privilégios de usuario para admin/root
- [ ] Movimentar lateralmente entre máquinas da rede
- [ ] Extrair credenciais e hashes de sistemas Windows
- [ ] Criar túneis de rede para acessar redes internas

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Linux básico | Sim | Módulo 0 do curso |
| Windows (Active Directory, SMB, WMI) | Sim | Fundamentos de Windows |
| Módulo 4: Exploração | Sim | [Módulo 4](../04-exploracao/) |
| Ter obtido acesso a uma máquina | Sim | Labs anteriores |

---

## 🗺️ Mapa do Módulo

```
┌─────────────────────────────────────────────────────────┐
│                 PÓS-EXPLORAÇÃO                          │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   ┌─────────────────────────────────────────────────┐   │
│   │           ENUMERAÇÃO PÓS-ACESSO                 │   │
│   │                                                 │   │
│   │  • smbclient.py ──── Enumerar shares            │   │
│   │  • wmiexec.py ────── Executar comandos remotos  │   │
│   │  • secretsdump.py ── Extrair hashes SAM/NTDS    │   │
│   │  • psexec.py ─────── Shell como serviço         │   │
│   └──────────────────────┬──────────────────────────┘   │
│                          │                               │
│                          ▼                               │
│   ┌─────────────────────────────────────────────────┐   │
│   │           ESCALAÇÃO & PERSISTÊNCIA              │   │
│   │                                                 │   │
│   │  • evil-winrm ────── Shell WinRM persistente    │   │
│   │  • LinPEAS ────────── Linux privilege escalation│   │
│   │  • WinPEAS ────────── Windows privilege escalation│  │
│   └──────────────────────┬──────────────────────────┘   │
│                          │                               │
│                          ▼                               │
│   ┌─────────────────────────────────────────────────┐   │
│   │           TÚNEIS & PIVOTING                     │   │
│   │                                                 │   │
│   │  • socat ────── Túneis TCP/UDP genéricos        │   │
│   │  • ligolo-ng ── Pivot via agente                 │   │
│   │  • chisel ───── Proxy reverso e SOCKS            │   │
│   └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 📚 Conteúdo

| # | Arquivo | O que você vai aprender | Ferramentas | Tempo |
|:--|:--------|:------------------------|:------------|:-----:|
| 1 | [01-enum-e-movimentacao.md](01-enum-e-movimentacao.md) | Enumerar redes Windows e se movimentar lateralmente | `smbclient.py, wmiexec.py, secretsdump.py, psexec.py, evil-winrm` | 3h |
| 2 | [02-pivoting-e-tunneling.md](02-pivoting-e-tunneling.md) | Criar túneis e encontrar privesc | `socat, ligolo-ng, chisel, LinPEAS, WinPEAS` | 3h |

---

## 💡 Dicas de Ouro

> **Dica 1:** Impacket é o canivete suíço do pentester Windows. Domine `psexec.py`, `wmiexec.py` e `secretsdump.py` — eles resolvem 90% dos cenários.

> **Dica 2:** Prefira `wmiexec.py` sobre `psexec.py` quando possível. WMI gera menos logs e é mais discreto.

> **Dica 3:** LinPEAS/WinPEAS rodam em tudo e mostram caminhos de escalada. Sempre rode primeiro para mapear o terreno.

---

## ⚠️ Erros Comuns (e como evitar)

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Não verificar o que já foi obtido | Explorar sem saber o que já tem disponível | Analise credenciais e tokens antes de avançar |
| Usar psexec.py em tudo | Gera muitos logs e é detectável | Prefira wmiexec.py para operações discretas |
| Esquecer de persistir | Perder acesso e ter que recomeçar | Configure backdoor ou credenciais persistentes |

---

## 🧪 Laboratório Prático

> **Exercícios detalhados com passo a passo, macetes e links!**

👉 **[Acessar LABS.md](LABS.md)** — 6+ exercícios práticos com objetivos, ferramentas, macetes e links diretos

## 🎮 Labs Recomendados

| Lab | Plataforma | Dificuldade | Tempo | Link |
|:----|:----------:|:-----------:|:-----:|:----:|
| Active Directory | TryHackMe | ⭐⭐⭐ | 3h | [Link](https://tryhackme.com/room/diamondDistrict) |
| Internal | HackTheBox | ⭐⭐⭐ | 2h | [Link](https://app.hackthebox.com/) |

---

## 📖 Referências e Aprofundamento

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| Impacket Examples | Tool | [github.com/fortra/impacket](https://github.com/fortra/impacket) |
| TryHackMe - Active Directory | Lab | [tryhackme.com](https://tryhackme.com/room/diamondDistrict) |
| HackTricks - Windows | Referência | [book.hacktricks.wiki](https://book.hacktricks.wiki/) |

---

## ✅ Checklist do Módulo

- [ ] Li todos os arquivos
- [ ] Instalei todas as ferramentas
- [ ] Completei os labs práticos
- [ ] Consigo explicar cada ferramenta
- [ ] Sei quando usar cada uma

---

<div align="center">

**⬅️ [Módulo 4: Exploração](../04-exploracao/)** | **[Módulo 6: Engenharia Reversa](../06-reversing/) ➡️**

</div>
