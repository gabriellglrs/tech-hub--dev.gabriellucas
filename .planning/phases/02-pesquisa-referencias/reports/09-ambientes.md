## Módulo 09: Ambientes Especiais

### Labs Existentes (LABS.md)

| # | Lab | Plataforma | URL | Status Validação |
|---|-----|-----------|-----|-----------------|
| 1 | Docker Security com Trivy | Local (Kali) | https://tryhackme.com/room/dockersecurity | ⏳ Pendente validação |
| 2 | Pentest em Kubernetes | Local (Kali) | https://tryhackme.com/room/attackinganddefendingkubernetes | ⏳ Pendente validação |
| 3 | Análise de Malware Android | Local (Kali) | https://tryhackme.com/room/androidhacking101 | ⏳ Pendente validação |
| 4 | WiFi Handshake Capture | Local (Kali) | https://tryhackme.com/room/wifihacking101 | ⏳ Pendente validação |
| 5 | AWS Pentesting | Local (Kali) | https://tryhackme.com/room/awsfundamentals | ⏳ Pendente validação |
| 6 | Pentest Mobile API (Final) | Local (Kali) | https://tryhackme.com/room/androidhacking101 | ⚠️ Link duplicado (android não é mobile API) |

**Resumo existente:** 6 exercícios, todos labs locais. Ferramentas: Trivy, kube-hunter/kube-bench, jadx/apktool, aircrack-ng, AWS CLI/Pacu, Burp Suite/MobSF/Frida. **Forte em:** cobertura ampla (Docker, K8s, Android, WiFi, AWS, Mobile API). **Fraqueza:** poucos labs em plataformas interativas.

### Labs Candidatos Novos

| # | Lab | Plataforma | URL | Tópico Coberto | Status Validação |
|---|-----|-----------|-----|---------------|-----------------|
| 1 | Docker Security | TryHackMe | https://tryhackme.com/room/dockersecurity | Container security, Trivy | ⏳ Pendente (rate-limit) |
| 2 | Attacking & Defending K8s | TryHackMe | https://tryhackme.com/room/attackinganddefendingkubernetes | Kubernetes pentest | ⏳ Pendente (rate-limit) |
| 3 | Android Hacking 101 | TryHackMe | https://tryhackme.com/room/androidhacking101 | Mobile security | ⏳ Pendente (rate-limit) |
| 4 | WiFi Hacking 101 | TryHackMe | https://tryhackme.com/room/wifihacking101 | Wireless security | ⏳ Pendente (rate-limit) |
| 5 | AWS Fundamentals | TryHackMe | https://tryhackme.com/room/awsfundamentals | Cloud security AWS | ⏳ Pendente (rate-limit) |
| 6 | Docker Basics | TryHackMe | https://tryhackme.com/room/dockerbasics | Docker fundamentals | ⏳ Pendente (rate-limit) |
| 7 | Kubernetes | TryHackMe | https://tryhackme.com/room/kubernetes | K8s fundamentals | ⏳ Pendente (rate-limit) |
| 8 | Cloud Security | TryHackMe | https://tryhackme.com/room/cloudsecurity | Cloud security general | ⏳ Pendente (rate-limit) |
| 9 | Cloud Machines | HackTheBox | https://app.hackthebox.com/machines | Cenários cloud | ✅ Ativo |

### Tópicos Ausentes (vs Certificações)

| Tópico | Certificação | Prioridade | Justificativa |
|--------|-------------|-----------|---------------|
| Azure/GCP cloud pentesting | Security+ Domain 3 | Importante | Multi-cloud é padrão de mercado |
| IoT security (OT/ICS) | CEH Module 18 | Importante | Mencionado em CEH mas não coberto |
| Container escape techniques | OSCP (indireto) | Importante | Técnica avançada de exploração |
| Serverless security (Lambda) | Security+ Domain 3 | Opcional | Cloud moderno |
| Mobile reverse engineering | CEH Module 17 | Importante | Análise de APK avançada |
| Bluetooth/Zigbee security | CEH Module 16 | Opcional | Wireless além de WiFi |

### Resumo

- **Labs existentes:** 6 (locais com ferramentas reais)
- **Labs candidatos novos:** 9 (8 THM, 1 HTB)
- **Total potencial:** 15 labs
- **Plataforma mais forte:** TryHackMe (8 rooms de cloud/Docker/K8s/mobile)
- **Força do módulo:** Cobertura mais ampla de todos os módulos (Docker, K8s, Android, WiFi, AWS, Mobile API)
- **Gaps críticos:** Azure/GCP, IoT/OT, container escape
- **Ação necessária:** Corrigir link duplicado do exercício 6
