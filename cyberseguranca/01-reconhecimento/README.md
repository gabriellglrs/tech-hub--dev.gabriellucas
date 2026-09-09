# Módulo 1: Reconhecimento

> Primeira fase de qualquer ataque: descobrir o que existe no alvo.

---

## O que você vai aprender

Neste módulo, você vai aprender a **descobrir informações sobre um alvo** sem ser detectado. É como ser um detetive antes de entrar em uma casa — você precisa saber quem mora lá, quantas portas tem, e quais estão abertas.

## Pré-requisitos

- Linux básico (terminal, instalar pacotes)
- Conhecimento de redes (IP, porta, DNS, HTTP)

## Fluxo de Estudo

```
1. 01-dns-e-enumeracao.md → Whois, Dig, Nmap, Masscan
        ↓
2. 02-osint-e-subdominios.md → Subfinder, Nuclei, httpx, TheHarvester
```

## Arquivos deste Módulo

| # | Arquivo | O que você vai aprender | Ferramentas |
|---|---------|------------------------|-------------|
| 1 | [01-dns-e-enumeracao.md](01-dns-e-enumeracao.md) | Consultar DNS, descobrir portas e serviços | `Whois, Dig, Nmap, Masscan` |
| 2 | [02-osint-e-subdominios.md](02-osint-e-subdominios.md) | Coletar informações públicas e subdomínios | `Subfinder, Nuclei, httpx, TheHarvester, DNSRecon` |

## Dicas Práticas

- **Nmap é a ferramenta mais importante** — domine antes de partir para outras
- **Comece lento** — use `-T2` ou `-T3` para não ser detectado
- **Documente tudo** — salve os resultados em arquivos para analisar depois
- **Não escaneie sistemas reais** — use TryHackMe, HackTheBox ou sua própria VM

## Erros Comuns

1. **Esquecer o `-Pn`** — quando o alvo bloqueia ping, o Nmap pensa que está offline
2. **Usar `-T5`** — muito agressivo, pode ser detectado ou causar DoS acidental
3. **Não atualizar** — sempre rode `sudo nmap --script-updatedb` antes de usar scripts

## Referências

- [Nmap Official Guide](https://nmap.org/book/)
- [TryHackMe - Recon Module](https://tryhackme.com/room/ohsint)
- [HackTricks - Recon](https://book.hacktricks.wiki/)

---

**Próximo:** [Módulo 2: Análise de Rede](../02-analise-rede/)
