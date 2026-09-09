# Módulo 4: Exploração

> Quebrar senhas e explorar serviços para obter acesso.

---

## O que você vai aprender

Neste módulo, você vai aprender a **quebrar senhas e explora serviços** para obter acesso não autorizado. É a fase onde o ataque realmente acontece — depois de descobrir o alvo, agora vamos entrar.

## Pré-requisitos

- Módulo 1 (Reconhecimento) concluído
- Módulo 2 (Análise de Rede) recomendado
- Conhecimento de autenticação (SSH, FTP, HTTP, SMB)

## Fluxo de Estudo

```
1. 01-brute-force-e-cracking.md → Hydra, John, Hashcat
        ↓
2. 02-wordlists-e-ferramentas.md → SecLists, Crunch, CeWL
```

## Arquivos deste Módulo

| # | Arquivo | O que você vai aprender | Ferramentas |
|---|---------|------------------------|-------------|
| 1 | [01-brute-force-e-cracking.md](01-brute-force-e-cracking.md) | Quebrar senhas e hashes de serviços | `Hydra, John, Hashcat` |
| 2 | [02-wordlists-e-ferramentas.md](02-wordlists-e-ferramentas.md) | Usar e criar listas de senhas e usuários | `SecLists, Crunch, CeWL` |

## Dicas Práticas

- **Hydra para serviços** — SSH, FTP, HTTP forms, SMB, RDP
- **John para hashes** — mais formatos suportados que Hashcat
- **Hashcat para GPU** — muito mais rápido que John para hashes simples
- **Comece com listas pequenas** — `Top1000.txt` antes de `rockyou.txt`

## Erros Comuns

1. **Usar `-t 64` no Hydra** — threads demais causam falsos positivos
2. **Não identificar o hash** — use `hashid` antes de tentar quebrar
3. **Esquecer regras** — John e Hashcat com `--rules` quebram mais senhas

## Referências

- [Hashcat Example Hashes](https://hashcat.net/wiki/doku.php?id=example_hashes)
- [TryHackMe - Brute Force](https://tryhackme.com/room/bruteit)
- [HackTricks - Brute Force](https://book.hacktricks.wiki/)

---

**Anterior:** [Módulo 3: Web & Aplicações](../03-web-aplicacoes/)
**Próximo:** [Módulo 5: Pós-Exploração](../05-pos-exploracao/)
