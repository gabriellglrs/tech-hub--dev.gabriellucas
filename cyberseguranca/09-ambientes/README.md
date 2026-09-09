# 🌐 Módulo 9: Ambientes Especiais

> **"Cloud, Containers, Wireless e Mobile — cada um com suas regras, cada um com seus riscos."**

---

## 📋 Informações do Módulo

| 📊 Detalhe | 📝 Valor |
|:---|:---|
| ⏱️ **Tempo Estimado** | 6-8 horas |
| 🎯 **Nível** | ⭐⭐⭐ Avançado |
| 📁 **Arquivos** | 3 |
| 🔧 **Ferramentas** | 12 principais |
| 📚 **Pré-requisitos** | Docker básico, Conceitos de cloud, Linux avançado |

---

## 🎯 Objetivos de Aprendizagem

Ao final deste módulo, você será capaz de:

- [ ] Auditar ambientes cloud (AWS/Azure/GCP)
- [ ] Proteger containers Docker contra vulnerabilidades
- [ ] Realizar pentest em clusters Kubernetes
- [ ] Analisar malware mobile (Android/iOS)
- [ ] Auditar aplicativos Android com MobSF e Frida
- [ ] Realizar ataques e defesas em redes wireless (WiFi)
- [ ] Usar ferramentas de engenharia reversa mobile

---

## 🗺️ Mapa Visual do Módulo

```
┌─────────────────────────────────────────────────────────────────┐
│                  🌐 AMBIENTES ESPECIAIS                         │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │    ☁️ CLOUD   │───▶│  🐳 CONTAINER│───▶│  📱 MOBILE   │      │
│  │   & K8s      │    │  SECURITY    │    │  SECURITY    │      │
│  └──────────────┘    └──────────────┘    └──────────────┘      │
│         │                   │                   │               │
│         ▼                   ▼                   ▼               │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │ Trivy        │    │ kube-hunter  │    │ MobSF        │      │
│  │ Grype        │    │ kube-bench   │    │ Frida        │      │
│  │              │    │ Falco        │    │ Objection    │      │
│  └──────────────┘    └──────────────┘    │ jadx         │      │
│                                          └──────────────┘      │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  📶 WIRELESS                                            │   │
│  │  ├── Aircrack-ng (suite completa)                       │   │
│  │  ├── Wifite (automatizado)                              │   │
│  │  └── Kismet (monitoramento)                             │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📦 Arquivos do Módulo

| # | Arquivo | Conteúdo | Ferramentas |
|:-:|:--------|:---------|:------------|
| 1 | [01-cloud-e-containers.md](01-cloud-e-containers.md) | Segurança em cloud e containers | `Trivy` `Grype` `kube-hunter` `kube-bench` `Falco` |
| 2 | [02-wireless.md](02-wireless.md) | Ataque e defesa em redes wireless | `Aircrack-ng` `Wifite` |
| 3 | [03-mobile.md](03-mobile.md) | Análise de malware e apps mobile | `MobSF` `Frida` `Objection` `jadx` |

---

## 🔧 Ferramentas Utilizadas

```
┌─────────────────────────────────────────────────────────────┐
│                    FERRAMENTAS DO MÓDULO                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ☁️ CLOUD & K8s          🐳 CONTAINERS                       │
│  ├── Trivy (images)     ├── kube-hunter (pentest)           │
│  ├── Grype (deps)       ├── kube-bench (CIS)                │
│  └── Prowler (AWS)      └── Falco (runtime)                 │
│                                                              │
│  📶 WIRELESS             📱 MOBILE                            │
│  ├── Aircrack-ng        ├── MobSF (static+dynamic)          │
│  ├── Wifite             ├── Frida (instrumentation)         │
│  └── Kismet             ├── Objection (runtime)             │
│                         └── jadx (decompiler)               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 💡 Dicas de Ouro

### ⚡ Dica 1: Misconfigurations são o maior risco em cloud
```bash
# Scaneie imagens Docker com Trivy
trivy image nginx:latest

# Scaneie repositórios com Grype
grype dir:.
```

### ⚡ Dica 2: NUNCA rode containers como root
```dockerfile
# Dockerfile CORRETO
FROM node:18-alpine
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
CMD ["node", "server.js"]
```

### ⚡ Dica 3: Modo monitor é essencial para wireless
```bash
# Ative o modo monitor antes de qualquer coisa
sudo airmon-ng start wlan0
# Verifique com:
iwconfig wlan0mon
```

### ⚡ Dica 4: MobSF automatiza análise mobile
```bash
# Instale e rode
docker run -it -p 8000:8000 opensecurity/mobsf
# Acesse http://localhost:8000 e faça upload do APK
```

---

## ⚠️ Erros Comuns (e como evitar)

| ❌ Erro | ✅ Solução | 💬 Por quê? |
|:--------|:----------|:------------|
| Não isolar VM de cloud | Use VM dedicada sem credenciais | Chave AWS na VM comprometida = desastre |
| Rodar containers como root | Use USER não-root no Dockerfile | Escape de container = acesso ao host |
| Esquecer modo monitor | Sempre ative antes de capturar | Sem modo monitor, não captura pacotes |
| Não escanear imagens Docker | Use Trivy/Grype no CI/CD | Vulnerabilidades em produção são caras |
| Usar apktool manualmente | Prefira MobSF para automação | MobSF gera relatório completo automaticamente |

---

## 🧪 Labs Recomendados

### 🟢 Iniciante
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| Docker Security | TryHackMe | Fundamentos Docker | [Acessar](https://tryhackme.com/room/dockersecurity) |
| Android Hacking | TryHackMe | Mobile básico | [Acessar](https://tryhackme.com/room/androidhacking101) |

### 🟡 Intermediário
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| Kubernetes | TryHackMe | Pentest K8s | [Acessar](https://tryhackme.com/room/kubernetespwned) |
| AWS Exploitation | TryHackMe | Cloud pentest | [Acessar](https://tryhackme.com/room/awse exploitation) |

### 🔴 Avançado
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| Wireless Hacking | TryHackMe | WiFi avançado | [Acessar](https://tryhackme.com/room/wifihacking) |
| Mobile Exploitation | PentesterLab | Mobile avançado | [Acessar](https://pentesterlab.com/) |

---

## ✅ Checklist de Conclusão

Antes de avançar para o próximo módulo, verifique:

- [ ] Consigo escanear imagens Docker com Trivy
- [ ] Consigo auditar Kubernetes com kube-bench
- [ ] Consigo configurar Falco para detecção em runtime
- [ ] Consigo realizar ataque wireless com Aircrack-ng
- [ ] Consigo capturar e analisar pacotes WiFi
- [ ] Consigo analisar APK com MobSF
- [ ] Consigo instrumentar apps com Frida
- [ ] Consigo decompilar APK com jadx
- [ ] Completei pelo menos 2 labs deste módulo

---

## 🔗 Navegação

```
┌─────────────────────────────────────────────────────────────────┐
│                      🗺️ MAPA DA TRILHA                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ◀── Módulo 8: Resposta a Incidentes                          │
│       │                                                         │
│       ▼                                                         │
│  ┌─────────────────────────────────────────┐ ◀── VOCÊ ESTÁ AQUI │
│  │  📌 Módulo 9: Ambientes Especiais       │                   │
│  │     01-cloud-e-containers.md            │                   │
│  │     02-wireless.md                      │                   │
│  │     03-mobile.md                        │                   │
│  └─────────────────────────────────────────┘                   │
│       │                                                         │
│       ▼                                                         │
│  Módulo 10: Governança & Criptografia ──▶                      │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**⬅️ Anterior:** [Módulo 8: Resposta a Incidentes](../08-resposta/)
**➡️ Próximo:** [Módulo 10: Governança & Criptografia](../10-governanca/)

---

## 📖 Referências

- 📘 [Trivy Documentation](https://trivy.dev/)
- 📗 [OWASP Mobile Top 10](https://owasp.org/www-project-mobile-top-10/)
- 📙 [Aircrack-ng Documentation](https://www.aircrack-ng.org/)
- 📕 [MobSF Documentation](https://mobsf.github.io/docs/)
- 🌐 [TryHackMe - Docker Security](https://tryhackme.com/room/dockersecurity)
- 🌐 [TryHackMe - Android Hacking](https://tryhackme.com/room/androidhacking101)

---

> **⏱️ Tempo estimado:** 6-8 horas | **🎯 Nível:** ⭐⭐⭐ Avançado | **📁 Próximo:** Módulo 10
