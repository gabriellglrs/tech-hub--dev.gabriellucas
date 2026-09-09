# 💾 Backup e Recovery (Recuperação de Desastres)

> "Existem dois tipos de empresas: as que fazem backup e as que vão fazer." Backup salva vidas — e empregos.

---

## 📚 O que é Backup e Recovery?

**Backup** é fazer cópias de segurança dos dados. **Recovery** é restaurar esses dados quando algo dá errado: ransomware, falha de hardware, erro humano, desastre natural.

### Por que é importante?

- **Ransomware** — sem backup, você paga ou perde tudo
- **Falha de hardware** — discos quebram
- **Erro humano** — deletes acidentais
- **Compliance** — muitas regulamentações exigem backup
- **Business Continuity** — manter o negócio rodando

---

## 📁 Trilha de Estudo

| # | Arquivo | O que você vai aprender | Tempo |
|:--|:--------|:------------------------|:-----:|
| 1 | [01-fundamentos-backup.md](01-fundamentos-backup.md) | Tipos (full, incremental, differential), 3-2-1 | 30 min |
| 2 | [02-ferramentas-backup.md](02-ferramentas-backup.md) | rsync, borgbackup, restic, duplicity | 45 min |
| 3 | [03-backup-linux.md](03-backup-linux.md) | cron jobs, LVM snapshots, /etc/backups | 40 min |
| 4 | [04-backup-windows.md](04-backup-windows.md) | Windows Backup, Volume Shadow Copy | 35 min |
| 5 | [05-dr-plan.md](05-dr-plan.md) | Plano de recuperação de desastres, RTO, RPO | 40 min |
| 6 | [06-teste-restauracao.md](06-teste-restauracao.md) | Testar restores, DR drills, automação | 35 min |

---

## 🎯 O que você vai conseguir fazer

- [ ] Configurar backups automáticos com rsync/borg
- [ ] Criar snapshots LVM
- [ ] Definir RTO e RPO para sistemas
- [ ] Testar restauração de backups
- [ ] Criar um plano de recuperação de desastres

---

<div align="center">

**⬅️ [Voltar ao README](../README.md)**

</div>
