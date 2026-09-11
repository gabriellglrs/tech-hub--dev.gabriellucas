# Modulo 0: Pre-Requisitos

> Fundamentos que TODO profissional de cyberseguranca precisa saber.

---

## Por que este modulo existe?

Antes de aprender a atacar ou defender, voce precisa entender como a internet funciona e como usar um computador. Sem base, os modulos seguintes nao fazem sentido.

**Ambiente:** [Kali Linux](../INSTALACAO.md) — siga o guia de instalacao antes de comecar.

---

## Estrutura

```
00-pre-requisitos/
├── 00-computacao/       ← O que e computador, processos, servicos
│   ├── 00-o-que-e-computador.md
│   ├── 01-processos-e-servicos.md
│   └── 02-cliente-e-servidor.md
│
├── 01-redes/            ← Fundacao de tudo
│   ├── 01-o-que-e-uma-rede.md
│   ├── 02-enderecamento-ip.md
│   ├── 03-dns.md
│   ├── 04-portas-e-protocolos.md
│   └── 05-tcp-ip-osi.md
│
├── 02-sistemas/         ← Linux, Web, VMs
│   ├── 06-linux-basico.md
│   ├── 07-http-e-web.md
│   └── 08-maquinas-virtuais.md
│
├── 03-seguranca/        ← Etica, Legalidade, CIA, Ameacas
│   └── 09-conceitos-seguranca.md
│
└── 04-ferramentas/      ← Comandos, editores, Nmap basico
    ├── 12-comandos-rede.md
    └── 13-editores-texto.md
```

---

## Ordem de Estudo

```
PARTE 0: COMPUTACAO → 00-computacao/
PARTE 1: REDES → 01-redes/
PARTE 2: SISTEMAS → 02-sistemas/
PARTE 3: SEGURANCA → 03-seguranca/
PARTE 4: FERRAMENTAS → 04-ferramentas/
✅ Pronto para Modulo 1 (Reconhecimento)!
```

---

## Checklist

### Computacao
- [ ] Consigo explicar o que e um computador (CPU, RAM, HD, NIC)
- [ ] Sei a diferenca entre processo e servico (daemon)
- [ ] Consigo usar systemctl para gerenciar servicos
- [ ] Entendo o modelo cliente-servidor

### Redes
- [ ] Consigo explicar o que e IP, DNS e porta
- [ ] Sei a diferenca entre TCP e UDP
- [ ] Consigo usar `ip a`, `ping`, `nslookup`, `ss -tlnp`
- [ ] Entendo a diferenca entre protocolo e servico

### Sistemas
- [ ] Consigo usar o terminal Linux (navegacao, arquivos, permissoes)
- [ ] Consigo gerenciar servicos com systemctl
- [ ] Consigo usar pipes (|) para encadear comandos
- [ ] Entendo HTTP/HTTPS, metodos, status codes, cookies
- [ ] Consigo usar curl para fazer requisicoes HTTP
- [ ] Sei o que sao APIs REST e JSON
- [ ] Consigo configurar uma VM com VirtualBox

### Seguranca
- [ ] Consigo explicar a triade CIA
- [ ] Entendo o que e Cybersecurity e seus ramos (ofensivo/defensivo)
- [ ] Sei a diferenca entre estudar uma tecnica e atacar um sistema
- [ ] Entendo que SEM AUTORIZACAO = CRIME
- [ ] Conheco ambientes seguros para praticar

### Ferramentas
- [ ] Consigo usar `whois` para consultar dominios
- [ ] Consigo fazer um scan basico com `nmap`
- [ ] Consigo usar editores de texto (nano/vim)

---

## Labs

👉 **[Acessar LABS.md](LABS.md)** — labs organizados por plataforma

---

## Navegacao

```
◀ Inicio da Trilha
│
▼
┌─────────────────────────────────────────┐
│  Modulo 0: Pre-Requisitos              │
│  00-computacao/ → 01-redes/ →           │
│  02-sistemas/ → 03-seguranca/ →         │
│  04-ferramentas/                        │
└─────────────────────────────────────────┘
│
▼
Modulo 1: Reconhecimento
```

**Proximo:** [Modulo 1: Reconhecimento](../01-reconhecimento/)
