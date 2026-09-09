# 🎯 Módulo 2: Análise de Rede

> Seja um cirurgião de rede — intercepte, analise e entenda cada pacote que trafega.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 📁 Arquivos | 🔧 Ferramentas |
|:--------:|:--------:|:-----------:|:--------------:|
| 4-5 horas | ⭐⭐ Intermediário | 2 | 6 |

</div>

---

## 🎓 Objetivos do Módulo

Ao final deste módulo, você será capaz de:

- [ ] Capturar e filtrar tráfego de rede em tempo real
- [ ] Analisar pacotes para extrair credenciais e dados sensíveis
- [ ] Interceptar comunicações com técnicas de MITM
- [ ] Configurar proxies e VPNs para anonimato
- [ ] Entender protocolos em todas as camadas do modelo OSI

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Linux básico | Sim | Módulo 0 do curso |
| Redes (TCP, UDP, HTTP, DNS) | Sim | Fundamentos de Redes |
| Módulo 1: Reconhecimento | Sim | [Módulo 1](../01-reconhecimento/) |

---

## 🗺️ Mapa do Módulo

```
┌─────────────────────────────────────────────────────────┐
│                   ANÁLISE DE REDE                       │
├─────────────────────────────────────────────────────────┤
│                                                         │
│   ┌──────────────┐      ┌──────────────────────────┐   │
│   │   SNIFFING   │      │     INTERCEPTAÇÃO        │   │
│   │              │      │                          │   │
│   │  • tcpdump   │      │  • mitmproxy (HTTP/S)    │   │
│   │  • Wireshark │      │  • bettercap (ARP)       │   │
│   │  • tshark    │      │  • Responder (LLMNR)    │   │
│   └──────┬───────┘      └───────────┬──────────────┘   │
│          │                          │                   │
│          ▼                          ▼                   │
│   ┌─────────────────────────────────────────────────┐   │
│   │           PROXIES E ANONIMATO                   │   │
│   │                                                 │   │
│   │  • proxychains (rotação de proxies)             │   │
│   │  • Tor (anonimato em camadas)                   │   │
│   │  • VPN (tunelamento seguro)                     │   │
│   └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## 📚 Conteúdo

| # | Arquivo | O que você vai aprender | Ferramentas | Tempo |
|:--|:--------|:------------------------|:------------|:-----:|
| 1 | [01-sniffing-e-captura.md](01-sniffing-e-captura.md) | Capturar e filtrar tráfego de rede | `tcpdump, Wireshark, tshark` | 2h |
| 2 | [02-proxy-e-anonimato.md](02-proxy-e-anonimato.md) | Interceptar comunicações e usar proxies | `mitmproxy, bettercap, proxychains` | 3h |

---

## 💡 Dicas de Ouro

> **Dica 1:** Wireshark é essencial — aprenda filtros BPF (captura) e Display (análise) para não se afogar em milhares de pacotes.

> **Dica 2:** Use `tshark` em servidores sem GUI. É o Wireshark da linha de comando e funciona em qualquer lugar.

> **Dica 3:** Proxychains + Tor é anonimato básico, mas não é perfeito. Para operações reais, considere VPN + Tor.

---

## ⚠️ Erros Comuns (e como evitar)

| Erro | Consequência | Como evitar |
|:-----|:-------------|:------------|
| Esquecer `sudo` para sniffing | Permissão negada ou tráfego vazio | Sempre rode com privilégios de root |
| Capturar tráfego sem filtrar | Arquivos gigantes impossíveis de analisar | Use filtros BPF desde o início (`port 80`) |
| Usar Tor sem entender limitações | Lentidão e falsa sensação de segurança | Estude as limitações do Tor antes de depender dele |

---

## 🎮 Labs Recomendados

| Lab | Plataforma | Dificuldade | Tempo | Link |
|:----|:----------:|:-----------:|:-----:|:----:|
| Wireshark | TryHackMe | ⭐⭐ | 1h | [Link](https://tryhackme.com/room/wireshark) |
| Network Traffic Analysis | HackTheBox | ⭐⭐⭐ | 2h | [Link](https://app.hackthebox.com/) |

---

## 📖 Referências e Aprofundamento

| Recurso | Tipo | Link |
|:--------|:----:|:----:|
| Wireshark Display Filter Reference | Guia | [wireshark.org](https://www.wireshark.org/docs/man-pages/wireshark-filter.html) |
| TryHackMe - Wireshark | Lab | [tryhackme.com](https://tryhackme.com/room/wireshark) |
| HackTricks - Network | Referência | [book.hacktricks.wiki](https://book.hacktricks.wiki/) |

---

## ✅ Checklist do Módulo

- [ ] Li todos os arquivos
- [ ] Instalei todas as ferramentas
- [ ] Completei os labs práticos
- [ ] Consigo explicar cada ferramenta
- [ ] Sei quando usar cada uma

---

<div align="center">

**⬅️ [Módulo 1: Reconhecimento](../01-reconhecimento/)** | **[Módulo 3: Web & Aplicações](../03-web-aplicacoes/) ➡️**

</div>
