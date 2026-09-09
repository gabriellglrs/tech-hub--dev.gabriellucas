# 🛡️ Módulo 7: Defesa e Hardening

> **"O melhor ataque é aquele que nunca acontece. Defenda-se primeiro."**

---

## 📋 Informações do Módulo

| 📊 Detalhe | 📝 Valor |
|:---|:---|
| ⏱️ **Tempo Estimado** | 5-6 horas |
| 🎯 **Nível** | ⭐⭐ Intermediário |
| 📁 **Arquivos** | 2 |
| 🔧 **Ferramentas** | 10 principais |
| 📚 **Pré-requisitos** | Linux básico, conceitos de rede |

---

## 🎯 Objetivos de Aprendizagem

Ao final deste módulo, você será capaz de:

- [ ] Auditar a segurança de sistemas com Lynis e OpenSCAP
- [ ] Configurar firewalls com UFW, iptables e nftables
- [ ] Implementar sistemas de detecção de intrusão (IDS/IPS)
- [ ] Configurar um SIEM completo com Wazuh e ELK Stack
- [ ] Criar regras de monitoramento e alertas
- [ ] Proteger servidores contra os 10 ataques mais comuns
- [ ] Entender o framework CIS Benchmarks

---

## 🗺️ Mapa Visual do Módulo

```
┌─────────────────────────────────────────────────────────────────┐
│                    🛡️ DEFESA E HARDENING                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │  AUDITORIA   │───▶│  FIREWALL    │───▶│  MONITORAMENTO│      │
│  │  & HARDENING │    │  & FILTRO    │    │  & SIEM      │      │
│  └──────────────┘    └──────────────┘    └──────────────┘      │
│         │                   │                   │               │
│         ▼                   ▼                   ▼               │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │ Lynis        │    │ UFW          │    │ Suricata     │      │
│  │ OpenSCAP     │    │ iptables     │    │ Snort        │      │
│  │ CIS Benchmark│    │ nftables     │    │ Wazuh        │      │
│  └──────────────┘    └──────────────┘    │ ELK Stack    │      │
│                                          │ fail2ban     │      │
│                                          └──────────────┘      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📦 Arquivos do Módulo

| # | Arquivo | Conteúdo | Ferramentas |
|:-:|:--------|:---------|:------------|
| 1 | [01-hardening-e-firewall.md](01-hardening-e-firewall.md) | Endurecimento de sistemas e firewalls | `Lynis` `OpenSCAP` `UFW` `iptables` `nftables` |
| 2 | [02-monitoramento-e-siem.md](02-monitoramento-e-siem.md) | IDS/IPS e SIEM para monitoramento | `Suricata` `Snort` `Wazuh` `ELK Stack` `fail2ban` |

---

## 🔧 Ferramentas Utilizadas

```
┌─────────────────────────────────────────────────────────────┐
│                    FERRAMENTAS DO MÓDULO                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  🔍 AUDITORIA              🧱 FIREWALLS                      │
│  ├── Lynis                 ├── UFW (Ubuntu)                 │
│  └── OpenSCAP              ├── iptables                     │
│                            └── nftables                     │
│                                                              │
│  🚨 IDS/IPS                📊 SIEM                           │
│  ├── Suricata              ├── Wazuh                        │
│  └── Snort                 ├── ELK Stack (Elastic)          │
│                            └── fail2ban                     │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 💡 Dicas de Ouro

### ⚡ Dica 1: Hardening ANTES de firewall
```
Firewall sem hardening = casa com trancas na porta mas janelas abertas
```

### ⚡ Dica 2: UFW para iniciantes, iptables para avançados
```bash
# UFW - Simples e poderoso
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

# iptables - Controle total
sudo iptables -P INPUT DROP
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
```

### ⚡ Dica 3: Suricata > Snort para IDS moderno
- Multi-thread nativo
- Mais rápido em ambientes de alto tráfego
- Suporte a Lua para scripts de análise

### ⚡ Dica 4: Wazuh = SIEM gratuito e poderoso
- Agentes para Windows, Linux e macOS
- Integração nativa com Elastic Stack
- Regis de compliance (PCI DSS, HIPAA)

---

## 🤖 IA para Este Módulo

```bash
# Analisar logs de firewall com IA
ollama run llama3.1:8b "Analise estes logs do UFW e identifique padrões de ataque: $(cat /var/log/ufw.log)"

# Gerar regras Suricata
ollama run codellama:13b "Gere uma regra Suricata para detectar扫描 de portas Nmap na rede interna"

# Auditar configuração com IA
lynis audit system --no-colors > /tmp/lynis.txt
ollama run llama3.2 "Analise este relatório Lynis e sugira melhorias de hardening: $(cat /tmp/lynis.txt)"
```

**Ferramentas de IA para defesa:** numasec (modo AppSec), KaliGPT

---

## ⚠️ Erros Comuns (e como evitar)

| ❌ Erro | ✅ Solução | 💬 Por quê? |
|:--------|:----------|:------------|
| Bloquear tudo sem pensar | Comece com deny all, libere o necessário | Se bloquear tudo, quebra serviços essenciais |
| Não monitorar logs | Configure SIEM junto com IDS | IDS sem SIEM = alertas se perdem |
| Esquecer de atualizar | Automatize patches de segurança | Hardening sem patches é temporário |
| Não testar regras | Use `iptables -L` e `ufw status` | Regras mal configuradas bloqueiam admin |
| Configurar tudo manualmente | Use Ansible/Puppet para automação | Manual = erro humano garantido |

---

## 🧪 Laboratório Prático

> **Exercícios detalhados com passo a passo, macetes e links!**

👉 **[Acessar LABS.md](LABS.md)** — 6+ exercícios práticos com objetivos, ferramentas, macetes e links diretos

## 🧪 Labs Recomendados

### 🟢 Iniciante
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| Linux Fundamentals | TryHackMe | Base para defesa | [Acessar](https://tryhackme.com/room/linuxfundamentalspart1) |
| Bandit | OverTheWire | Linux navigation | [Acessar](https://overthewire.org/wargames/bandit/) |

### 🟡 Intermediário
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| Blue Team | TryHackMe | Defesa completa | [Acessar](https://tryhackme.com/room/blueteam) |
| Windows Event Logs | TryHackMe | Análise de logs | [Acessar](https://tryhackme.com/room/windowseventlogs) |

### 🔴 Avançado
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| SOC Level 1 | TryHackMe | Operações SOC | [Acessar](https://tryhackme.com/room/soclevel1) |
| Suricata Lab | Suricata | IDS/IPS hands-on | [Acessar](https://suricata.io/getting-started/) |

---

## ✅ Checklist de Conclusão

Antes de avançar para o próximo módulo, verifique:

- [ ] Consigo auditar um sistema com Lynis
- [ ] Consigo configurar UFW para proteger um servidor
- [ ] Consigo criar regras iptables/nftables básicas
- [ ] Consigo instalar e configurar Suricata ou Snort
- [ ] Consigo configurar o Wazuh agent
- [ ] Consigo montar um pipeline ELK Stack básico
- [ ] Consigo criar regras fail2ban personalizadas
- [ ] Consigo interpretar alertas de IDS
- [ ] Completei pelo menos 2 labs deste módulo

---

## 🔗 Navegação

```
┌─────────────────────────────────────────────────────────────────┐
│                      🗺️ MAPA DA TRILHA                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ◀── Módulo 6: Análise de Rede                                  │
│       │                                                         │
│       ▼                                                         │
│  ┌─────────────────────────────────────────┐ ◀── VOCÊ ESTÁ AQUI │
│  │  📌 Módulo 7: Defesa e Hardening       │                   │
│  │     01-hardening-e-firewall.md         │                   │
│  │     02-monitoramento-e-siem.md         │                   │
│  └─────────────────────────────────────────┘                   │
│       │                                                         │
│       ▼                                                         │
│  Módulo 8: Resposta a Incidentes ──▶                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**⬅️ Anterior:** [Módulo 6: Análise de Rede](../06-analise-rede/)
**➡️ Próximo:** [Módulo 8: Resposta a Incidentes](../08-resposta/)

---

## 📖 Referências

- 📘 [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks)
- 📗 [UFW Documentation](https://wiki.ubuntu.com/UncomplicatedFirewall)
- 📙 [Suricata Getting Started](https://suricata.io/getting-started/)
- 📕 [Wazuh Documentation](https://documentation.wazuh.com/)
- 🌐 [TryHackMe - Blue Team](https://tryhackme.com/room/blueteam)
- 🌐 [OverTheWire - Bandit](https://overthewire.org/wargames/bandit/)

---

> **⏱️ Tempo estimado:** 5-6 horas | **🎯 Nível:** ⭐⭐ Intermediário | **📁 Próximo:** Módulo 8
