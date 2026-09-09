# 📱 Segurança Mobile (Android / iOS)

> Análise de APK/IPA: estática, dinâmica e instrumentação.

---

## 🛠️ Instalação

```bash
# MobSF
pip3 install mobsf

# Frida
pip3 install frida-tools

# Apktool
sudo apt install -y apktool

# jadx (decompilar APK)
sudo apt install -y jadx
```

---

## 🚀 Passo a Passo

### Passo 1: Análise estática (MobSF)
```bash
docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf
# Acesse http://localhost:8000 → upload APK/IPA
# Relatório: permissões, manifest, hardcoded keys, exportados
```

### Passo 2: Descompilar APK
```bash
sudo apt install -y apktool
apktool d app.apk -o app_out
# Ver AndroidManifest.xml, smali, strings
jadx -d jadx_out app.apk
# Ler código Java decompilado
```

### Passo 3: Análise dinâmica + Frida
```bash
pip install frida-tools objection
# No device rooteado/jailbroken:
frida-ps -U  # listar apps
objection -g com.target.app explore
# Dentro do objection:
android sslpinning disable
android root disable
ios sslpinning disable
```

### Passo 4: Interceptar tráfego (mitmproxy)
```bash
mitmproxy -p 8080
# Configurar proxy no device: 127.0.0.1:8080 + instalar cert mitmproxy
# Ver chamadas API, tokens, vazamentos
```

---

## Ferramentas

| Ferramenta | Uso |
|:---|:---|
| **mobsf** | Scan automático SAST/DAST |
| **apktool / jadx** | Descompilar APK |
| **frida / objection** | Hook runtime, bypass pinning/root |
| **adb** | Debug Android |
| **mitmproxy** | Interceptar HTTPS |

## Checklist OWASP Mobile Top 10

- [ ] Armazenamento inseguro (SharedPrefs, Keychain)
- [ ] Comunicação insegura (sem pinning)
- [ ] Autenticação fraca
- [ ] Código ofuscado? (ou fácil de reverter)

---

## 🧪 Labs Práticos

### TryHackMe
- **[Mobile Hacking](https://tryhackme.com/room/androidhacking101)** — Fundamentos de análise Android
- **[Insecure Android](https://tryhackme.com/room/insecureandroid)** — App Android com vulnerabilidades OWASP Top 10

### HackTheBox
- **[Mobile Challenges](https://app.hackthebox.com/challenges/mobile)** — Desafios de engenharia reversa mobile

### Exercícios Locais
```bash
# Analisar APK com MobSF (via Docker)
docker run -it --rm -p 8000:8000 opensecurity/mobile-security-framework-mobsf
# Acesse http://localhost:8000 e faça upload de um APK

# Descompilar APK com apktool
apktool d target_app.apk -o decompiled/

# Decompilar com jadx (código Java)
jadx -d jadx_output/ target_app.apk

# Hook com Frida em app-alvo
frida-ps -U | grep target
frida -U -f com.target.app -l hook_script.js --no-pause

# Interceptar tráfego com mitmproxy
mitmproxy -p 8080
# Configurar proxy no emulador: 10.0.2.2:8080
```

### Desafio Integrado
1. Pegue um APK deCTF (ex: DIVA, InsecureBankv2)
2. Execute análise estática com MobSF
3. Descompile e encontre hardcoded secrets
4. Use Frida para bypass SSL pinning
5. Documente todas as vulnerabilidades encontradas

> **Dica:** Para testes dinâmicos, use emuladores Android (Genymotion) ou dispositivos físicos rooteados (Magisk).
