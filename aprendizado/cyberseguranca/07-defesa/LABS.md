# Labs de Defesa

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Kali Linux | ⭐⭐ | Com Suricata, Wazuh agent |
| Módulos 1-3 | ⭐⭐⭐ | Ataque concluído (só entende quem ataca) |
| Linux básico | ⭐ | systemctl, logs, firewall |

---

## Labs por Plataforma

### TryHackMe (7 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | Wazuh | SIEM, regras customizadas, monitoramento | ⭐⭐ | https://tryhackme.com/room/wazuhct |
| 2 | IDS Evasion | Evasão de IDS/IPS, detecção | ⭐⭐⭐ | https://tryhackme.com/room/idsevasion |
| 3 | Monday Monitor | Wazuh SIEM na prática | ⭐⭐ | https://tryhackme.com/room/mondaymonitor |
| 4 | Linux Fundamentals | Linux basics (hardening) | ⭐ | https://tryhackme.com/room/linuxfundamentalspart1 |
| 5 | Linux Fundamentals 2 | Linux intermediário | ⭐⭐ | https://tryhackme.com/room/linuxfundamentalspart2 |
| 6 | Linux Fundamentals 3 | Linux avançado | ⭐⭐⭐ | https://tryhackme.com/room/linuxfundamentalspart3 |
| 7 | SOC Level 1 | SOC operations, triagem | ⭐⭐ | https://tryhackme.com/room/soclevel1 |

> **Nota:** URLs podem mudar — verifique no site da plataforma.

### HackTheBox (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 8 | Active Machines (defense) | Defesa em máquinas ativas | ⭐⭐⭐ | https://app.hackthebox.com/machines |

### Prática Local (6 labs)

| # | Lab | Tópicos | Dificuldade | Comando |
|---|-----|---------|-------------|---------|
| 9 | UFW firewall | Configurar regras de firewall | ⭐⭐ | `sudo ufw default deny incoming && sudo ufw allow 22` |
| 10 | Fail2Ban | Proteção contra brute force | ⭐⭐ | `sudo fail2ban-client status sshd` |
| 11 | Suricata scan | IDS com Suricata | ⭐⭐⭐ | `sudo suricata -c /etc/suricata/suricata.yaml -i eth0` |
| 12 | Wazuh agent | Instalar e conectar agent | ⭐⭐ | `sudo apt install wazuh-agent && sudo systemctl start wazuh-agent` |
| 13 | Sigma rules | Regras de detecção genéricas | ⭐⭐⭐ | `sigma check rules/` |
| 14 | Syslog config | Configurar envio de logs | ⭐⭐ | `sudo systemctl restart rsyslog` |

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 7 | Wazuh, IDS, SOC, Linux |
| HackTheBox | 1 | Active machines defense |
| Local | 6 | UFW, Fail2Ban, Suricata, Wazuh, Sigma, Syslog |
| **Total** | **14** | |
