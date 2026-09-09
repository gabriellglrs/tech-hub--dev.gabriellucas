# 📱 Segurança Mobile (Android / iOS)

> Análise de APK/IPA: estática, dinâmica e instrumentação.

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
