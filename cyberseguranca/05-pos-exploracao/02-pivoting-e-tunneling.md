# Pivoting e Tunneling

> Manter acesso e movimentar-se pela rede após exploração inicial.

---

## O que é Pivoting

Pivoting é usar uma máquina comprometida como ponto de acesso para alcançar outras redes ou máquinas que não estão diretamente acessíveis.

## Ferramentas

### Chisel
- Tunneling via HTTP/HTTPS
- Proxy reverso

### Ligolo-ng
- Tunneling sem necessidade de SOCKS
- Mais rápido que Chisel

### SSH Tunneling
```bash
# Local port forwarding
ssh -L 8080:target:80 user@pivot

# Remote port forwarding
ssh -R 8080:target:80 user@pivot

# Dynamic port forwarding (SOCKS proxy)
ssh -D 1080 user@pivot
```

## Fluxo típico
```
1. Comprometer máquina inicial
2. Configurar tunnel até a rede interna
3. Usar proxychains para acessar serviços internos
4. Explorar máquinas na rede interna
```

---

**Próximo:** [Módulo 6: Engenharia Reversa](../06-reversing/)
