# Labs de Ambientes Especiais

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Kali Linux | ⭐⭐ | Com Docker, Trivy, kube-hunter |
| Módulos 1-3 | ⭐⭐⭐ | Fundamentos de ataque |
| Docker básico | ⭐ | Containers, images, volumes |

---

## Labs por Plataforma

### TryHackMe (6 labs)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 1 | Docker Security | Containers, Dockerfile, escape | ⭐⭐ | https://tryhackme.com/room/dockersecurity |
| 2 | Attacking & Defending K8s | Kubernetes pentest e hardening | ⭐⭐⭐ | https://tryhackme.com/room/attackinganddefendingkubernetes |
| 3 | Android Hacking 101 | Mobile security, ADB, APK | ⭐⭐ | https://tryhackme.com/room/androidhacking101 |
| 4 | WiFi Hacking 101 | WPA2, Aircrack-ng, handshake | ⭐⭐ | https://tryhackme.com/room/wifihacking101 |
| 5 | AWS Fundamentals | AWS security, IAM, S3 | ⭐⭐ | https://tryhackme.com/room/awsfundamentals |
| 6 | Cloud Security | Cloud security geral | ⭐⭐ | https://tryhackme.com/room/cloudsecurity |

> **Nota:** URLs podem mudar — verifique no site da plataforma.

### HackTheBox (1 lab)

| # | Lab | Tópicos | Dificuldade | URL |
|---|-----|---------|-------------|-----|
| 7 | Cloud Machines | Cloud exploitation | ⭐⭐⭐ | https://app.hackthebox.com/machines |

### Prática Local (8 labs)

| # | Lab | Tópicos | Dificuldade | Comando |
|---|-----|---------|-------------|---------|
| 8 | Trivy scan image | Scan de vulnerabilidade em imagem | ⭐⭐ | `trivy image nginx:latest` |
| 9 | kube-hunter scan | Pentest em cluster K8s | ⭐⭐⭐ | `kube-hunter --remote 10.0.0.1` |
| 10 | Falco runtime | Detecção de ameaças em runtime | ⭐⭐⭐ | `docker run falcosecurity/falco:latest falco` |
| 11 | MobSF scan APK | Análise estática de Android | ⭐⭐ | `mobsfscan app.apk` |
| 12 | Docker escape test | Testar escape de container | ⭐⭐⭐ | `docker run -it --privileged alpine sh` |
| 13 | AWS Prowler audit | Auditoria AWS CIS | ⭐⭐⭐ | `prowler aws --profile default` |
| 14 | ScouterSuite | Auditoria multi-cloud | ⭐⭐⭐ | `scout aws --no-browser` |
| 15 | Aircrack-ng capture | Captura de handshake WPA2 | ⭐⭐ | `airodump-ng wlan0mon` |

---

## Resumo

| Plataforma | Labs | Foco |
|:-----------|:-----|:-----|
| TryHackMe | 6 | Docker, K8s, Android, WiFi, AWS, Cloud |
| HackTheBox | 1 | Cloud machines |
| Local | 8 | Trivy, kube-hunter, Falco, MobSF, Docker, AWS, Aircrack |
| **Total** | **15** | |
