# Módulo 9: Ambientes Especiais

> Cloud, Containers, Wireless e Mobile — onde a segurança muda.

---

## O que você vai aprender

Neste módulo, você vai aprender sobre **ambientes especializados** que têm suas próprias regras de segurança. Cloud, containers, redes wireless e mobile são áreas com ferramentas e técnicas próprias.

## Pré-requisitos

- Módulos 1-5 recomendados
- Conhecimento de cada ambiente (AWS/Docker/Wi-Fi/Android)

## Fluxo de Estudo

```
1. 01-cloud-e-containers.md → AWS, Azure, GCP, Docker, K8s, Trivy
        ↓
2. 02-wireless.md → Aircrack-ng, Wifite, Evil Twin
        ↓
3. 03-mobile.md → MobSF, Frida, Apktool, Objection
```

## Arquivos deste Módulo

| # | Arquivo | O que você vai aprender | Ferramentas |
|---|---------|------------------------|-------------|
| 1 | [01-cloud-e-containers.md](01-cloud-e-containers.md) | Auditoria de cloud e segurança de containers | `Pacu, Prowler, Trivy, Kube-bench, Falco` |
| 2 | [02-wireless.md](02-wireless.md) | Atacar e defender redes Wi-Fi | `Aircrack-ng, Wifite, Kismet, Hostapd` |
| 3 | [03-mobile.md](03-mobile.md) | Analisar apps Android e iOS | `MobSF, Frida, Apktool, Objection, mitmproxy` |

## Dicas Práticas

- **Cloud: misconfigurations são o maior problema** — S3 público, Security Groups abertos
- **Containers: não rodar como root** — use `USER app` no Dockerfile
- **Wireless: modo monitor primeiro** — sem ele, não pode capturar pacotes
- **Mobile: MobSF automatiza** — upload do APK e relatório completo

## Erros Comuns

1. **Não isolar VM de cloud** — chaves AWS na VM comprometida = desastre
2. **Rodar containers como root** — risco de escape
3. **Esquecer o modo monitor** — wireless sem modo monitor não funciona

## Referências

- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [OWASP Mobile Top 10](https://owasp.org/www-project-mobile-top-10/)
- [Aircrack-ng Documentation](https://www.aircrack-ng.org/)

---

**Anterior:** [Módulo 8: Resposta a Incidentes](../08-resposta/)
**Próximo:** [Módulo 10: Governança & Criptografia](../10-governanca/)
