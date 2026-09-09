# Módulo 2: Análise de Rede

> Capturar e interpretar o que está passando pela rede.

---

## O que você vai aprender

Neste módulo, você vai aprender a **capturar e analisar tráfego de rede**. É como ter um "raio-x" da rede — você vê tudo que está passando por ela, incluindo senhas, dados e comunicações.

## Pré-requisitos

- Módulo 1 (Reconhecimento) concluído
- Conhecimento básico de redes (TCP, UDP, HTTP, DNS)

## Fluxo de Estudo

```
1. 01-sniffing-e-captura.md → Wireshark, TCPDump, Netcat, Socat
        ↓
2. 02-proxy-e-anonimato.md → Proxychains, Tor, Bettercap, Responder
```

## Arquivos deste Módulo

| # | Arquivo | O que você vai aprender | Ferramentas |
|---|---------|------------------------|-------------|
| 1 | [01-sniffing-e-captura.md](01-sniffing-e-captura.md) | Capturar e filtrar tráfego de rede | `Wireshark, TCPDump, Netcat, Socat` |
| 2 | [02-proxy-e-anonimato.md](02-proxy-e-anonimato.md) | Trafegar de forma anônima e interceptar comunicações | `Proxychains, Tor, Bettercap, Responder, mitmproxy` |

## Dicas Práticas

- **Wireshark é essencial** — aprenda os filtros BPF e Display
- **Netcat é a "faca suíça"** — faça tudo: port scan, reverse shell, transferência de arquivos
- **Proxychains + Tor = anonimato básico** — mas não é perfeito
- **Bettercap para MITM** — ARP spoofing em rede local

## Erros Comuns

1. **Esquecer `sudo`** — sniffing requer permissões de root
2. **Não filtrar** — capturar tudo gera arquivos gigantes e difíceis de analisar
3. **Usar Tor sem entender** — Tor é lento e nem sempre anônimo o suficiente

## Referências

- [Wireshark Display Filter Reference](https://www.wireshark.org/docs/man-pages/wireshark-filter.html)
- [TryHackMe - Wireshark](https://tryhackme.com/room/wireshark)
- [HackTricks - Network](https://book.hacktricks.wiki/)

---

**Anterior:** [Módulo 1: Reconhecimento](../01-reconhecimento/)
**Próximo:** [Módulo 3: Web & Aplicações](../03-web-aplicacoes/)
