# Módulo 7: Defesa

> Proteger sistemas, redes e aplicações contra ataques.

---

## O que você vai aprender

Neste módulo, você vai aprender a **defender sistemas e redes** contra ataques. É o outro lado da moeda — depois de entender como atacar, agora vamos aprender a proteger. Este módulo pode ser estudado **em paralelo** com os módulos ofensivos.

## Pré-requisitos

- Conhecimento básico de Linux e redes
- Módulos 1-4 recomendados (para entender o que está defendendo)

## Fluxo de Estudo

```
1. 01-hardening-e-firewall.md → Lynis, CIS, UFW, iptables, nftables
        ↓
2. 02-monitoramento-e-siem.md → Suricata, Snort, Zeek, Wazuh, ELK
```

## Arquivos deste Módulo

| # | Arquivo | O que você vai aprender | Ferramentas |
|---|---------|------------------------|-------------|
| 1 | [01-hardening-e-firewall.md](01-hardening-e-firewall.md) | Endurecer sistemas e filtrar tráfego | `Lynis, CIS Benchmark, UFW, iptables, nftables` |
| 2 | 02-monitoramento-e-siem.md](02-monitoramento-e-siem.md) | Detectar intrusões e centralizar logs | `Suricata, Snort, Zeek, Wazuh, Elastic Stack` |

## Dicas Práticas

- **Hardening primeiro** — firewall sem hardening é como ter trancas na porta mas janelas abertas
- **UFW para iniciantes** — simples e eficaz no Ubuntu
- **Suricata para IDS/IPS** — multi-thread, mais rápido que Snort
- **Wazuh para SIEM** — open-source, fácil de instalar

## Erros Comuns

1. **Bloquear tudo sem pensar** — comece com deny all, depois libere o necessário
2. **Não monitorar logs** — IDS sem SIEM é inútil, os alertas se perdem
3. **Esquecer de atualizar** — hardening sem patches é temporário

## Referências

- [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks)
- [TryHackMe - Blue](https://tryhackme.com/room/blueteam)
- [Suricata Getting Started](https://suricata.io/getting-started/)

---

**Anterior:** [Módulo 6: Engenharia Reversa](../06-reversing/)
**Próximo:** [Módulo 8: Resposta a Incidentes](../08-resposta/)
