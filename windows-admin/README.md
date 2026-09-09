# 🪟 Administração Windows

> Windows domina o ambiente corporativo. Active Directory, Group Policy e logs do Windows são essenciais para segurança empresarial.

---

## 📚 O que é Administração Windows?

**Administração Windows** é gerenciar servidores e estações de trabalho Windows: Active Directory, Group Policy, logs de segurança, PowerShell e hardening do sistema.

### Por que é importante?

- **80%+ dos computadores corporativos** usam Windows
- **Active Directory** é o sistema de autenticação padrão
- **90% dos ataques** começam com credenciais Windows
- **Logs do Windows** são essenciais para forense
- **PowerShell** é ferramenta de ataque e defesa

---

## 📁 Estrutura

```
windows-admin/
├── 01-powershell/         # PowerShell e automação
├── 02-active-directory/   # Active Directory e LDAP
├── 03-group-policy/       # Group Policy Objects
├── 04-logs/               # Logs e Event Viewer
├── 05-hardening/          # Segurança do Windows
└── 06-seguranca/          # Segurança avançada
```

## 📚 Trilha de Estudo

| # | Módulo | O que você vai aprender |
|:--|:-------|:------------------------|
| 1 | [01-powershell](01-powershell/) | Cmdlets, scripts, remoting |
| 2 | [02-active-directory](02-active-directory/) | DC, OU, GPO, Kerberos |
| 3 | [03-group-policy](03-group-policy/) | GPO, hardening, auditoria |
| 4 | [04-logs](04-logs/) | Event Viewer, Sysmon, wevtutil |
| 5 | [05-hardening](05-hardening/) | Firewall, Defender, UAC |
| 6 | [06-seguranca](06-seguranca/) | AMSI, LAPS, attack/defense |

---

## 🎯 O que você vai conseguir fazer

- [ ] Automatizar tarefas com PowerShell avançado
- [ ] Gerenciar Active Directory (usuários, grupos, OUs)
- [ ] Criar e aplicar Group Policies
- [ ] Analisar logs de segurança do Windows
- [ ] Fazer hardening de servidores Windows
- [ ] Entender como atacantes usam PowerShell

---

## 🔗 Recursos

- [PowerShell Documentation](https://docs.microsoft.com/powershell/)
- [TryHackMe: Windows Fundamentals](https://tryhackme.com/room/windowsfundamentals1xbx)
- [AD Security](https://adsecurity.org/) — Referência de AD security
- [TryHackMe: Active Directory Basics](https://tryhackme.com/room/adbasics)

---

<div align="center">

**⬅️ [Voltar ao README](../README.md)**

</div>
