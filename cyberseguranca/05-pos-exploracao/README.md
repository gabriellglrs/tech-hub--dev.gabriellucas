# Módulo 5: Pós-Exploração

> Manter acesso e explorar mais após o comprometimento inicial.

---

## O que você vai aprender

Neste módulo, você vai aprender a **manter acesso e explorar sistemas** após obter o controle inicial. É a fase onde o atacante se estabelece no ambiente, coleta credenciais e se movimenta entre máquinas.

## Pré-requisitos

- Módulo 4 (Exploração) concluído
- Conhecimento de redes (SMB, WMI, Kerberos)
- Ter obtido acesso a uma máquina (via shell ou credenciais)

## Fluxo de Estudo

```
1. 01-enum-e-movimentacao.md → Impacket, Enum4linux-ng
        ↓
2. 02-pivoting-e-tunneling.md → Chisel, Ligolo-ng, Linpeas/Winpeas
```

## Arquivos deste Módulo

| # | Arquivo | O que você vai aprender | Ferramentas |
|---|---------|------------------------|-------------|
| 1 | [01-enum-e-movimentacao.md](01-enum-e-movimentacao.md) | Enumerar redes Windows e se movimentar lateralmente | `Impacket, Enum4linux-ng` |
| 2 | [02-pivoting-e-tunneling.md](02-pivoting-e-tunneling.md) | Criar túneis e encontrar privesc | `Chisel, Ligolo-ng, Linpeas, Winpeas` |

## Dicas Práticas

- **Impacket é essencial** — domine `psexec.py`, `wmiexec.py`, `secretsdump.py`
- **Enum4linux-ng para enumeração** — descobre shares, usuários e políticas
- **Linpeas/Winpeas para privesc** — roda em tudo e mostra caminhos de escalada
- **Chisel para pivoting** — acesso a redes internas a partir de máquinas comprometidas

## Erros Comuns

1. **Não verificar o que já foi obtido** — antes de explorar mais, analise o que já tem
2. **Usar métodos barulhentos** — `psexec.py` gera logs; prefira `wmiexec.py`
3. **Esquecer de persistir** — se perder o acesso, pode ser difícil voltar

## Referências

- [Impacket Examples](https://github.com/fortra/impacket)
- [TryHackMe - Active Directory](https://tryhackme.com/room/diamond District)
- [HackTricks - Windows](https://book.hacktricks.wiki/)

---

**Anterior:** [Módulo 4: Exploração](../04-exploracao/)
**Próximo:** [Módulo 6: Engenharia Reversa](../06-reversing/)
