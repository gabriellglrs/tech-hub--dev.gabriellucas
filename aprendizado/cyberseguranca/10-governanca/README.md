# 📜 Módulo 10: Governança e Criptografia

> **"Segurança sem governança é tática sem estratégia. Criptografia sem entendimento é ferramenta sem uso."**

---

## 📋 Informações do Módulo

| 📊 Detalhe | 📝 Valor |
|:---|:---|
| ⏱️ **Tempo Estimado** | 4-5 horas |
| 🎯 **Nível** | ⭐ Iniciante/Intermediário |
| 📁 **Arquivos** | 2 |
| 🔧 **Ferramentas** | 6 principais |
| 📚 **Pré-requisitos** | Conceitos básicos de segurança, Linux básico |

---

## 🎯 Objetivos de Aprendizagem

Ao final deste módulo, você será capaz de:

- [ ] Entender os principais frameworks de segurança (ISO 27001, NIST CSF)
- [ ] Implementar controles GRC (Governança, Risco e Compliance)
- [ ] Realizar avaliação de riscos em organizações
- [ ] Aplicar criptografia simétrica e assimétrica
- [ ] Proteger dados sensíveis com ferramentas open-source
- [ ] Entender a LGPD e suas implicações para profissionais
- [ ] Usar OpenSSL, GPG e age para criptografia

---

## 🗺️ Mapa Visual do Módulo

```
┌─────────────────────────────────────────────────────────────────┐
│               📜 GOVERNANÇA E CRIPTOGRAFIA                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │  📋 GRC      │───▶│  🔐 CRIPTO   │───▶│  🛡️ COMPLIANCE│      │
│  │  GOVERNANÇA  │    │  GRAFIA      │    │  & LEIS      │      │
│  └──────────────┘    └──────────────┘    └──────────────┘      │
│         │                   │                   │               │
│         ▼                   ▼                   ▼               │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐      │
│  │ ISO 27001    │    │ AES / RSA    │    │ LGPD         │      │
│  │ NIST CSF     │    │ OpenSSL      │    │ GDPR         │      │
│  │ OpenSCAP     │    │ GPG / age    │    │ PCI DSS      │      │
│  │ Lynis        │    │ SHA-256      │    │ HIPAA        │      │
│  └──────────────┘    │ CyberChef    │    └──────────────┘      │
│                      └──────────────┘                           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📦 Arquivos do Módulo

| # | Arquivo | Conteúdo | Ferramentas |
|:-:|:--------|:---------|:------------|
| 1 | [01-grc-e-compliance.md](01-grc-e-compliance.md) | Governança, gestão de riscos e compliance | `OpenSCAP` `Lynis` |
| 2 | [02-criptografia.md](02-criptografia.md) | Criptografia simétrica, assimétrica e hash | `OpenSSL` `GPG` `age` `CyberChef` |

---

## 🔧 Ferramentas Utilizadas

```
┌─────────────────────────────────────────────────────────────┐
│                    FERRAMENTAS DO MÓDULO                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  📋 GRC & AUDITORIA        🔐 CRIPTOGRAFIA                   │
│  ├── OpenSCAP (compliance) ├── OpenSSL (suite completa)      │
│  └── Lynis (hardening)     ├── GPG (chaves públicas)        │
│                            ├── age (moderno)                 │
│                            └── CyberChef (GUI)               │
│                                                              │
│  📊 FRAMEWORKS              📜 LEIS                           │
│  ├── ISO 27001             ├── LGPD (Brasil)                │
│  ├── NIST CSF              ├── GDPR (Europa)                │
│  └── CIS Benchmarks        └── PCI DSS                      │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 💡 Dicas de Ouro

### ⚡ Dica 1: GRC não é "coisa de advogado"
```
💡 Governança, Risco e Compliance é essencial para QUALQUER
profissional de segurança. Sem GRC, a técnica não tem valor.
```

### ⚡ Dica 2: LGPD é lei no Brasil
```bash
# Todo profissional de segurança PRECISA entender:
# - Dados pessoais são dados que identificam uma pessoa
# - Multas de até 2% do faturamento (teto R$ 50 milhões)
# - Prazo para notificação: 72 horas
```

### ⚡ Dica 3: OpenSSL é a ferramenta definitiva
```bash
# Gere chaves RSA
openssl genpkey -algorithm RSA -out private.pem -pkeyopt rsa_keygen_bits:2048

# Cifre um arquivo
openssl enc -aes-256-cbc -salt -in arquivo.txt -out arquivo.enc

# Gere hash SHA-256
openssl dgst -sha256 arquivo.txt
```

### ⚡ Dica 4: age = criptografia moderna e simples
```bash
# Instale
sudo apt install age

# Cifre
age -r age1... -o arquivo.age arquivo.txt

# Descifre
age -d -i chave.txt -o arquivo.txt arquivo.age
```

---

## ⚠️ Erros Comuns (e como evitar)

| ❌ Erro | ✅ Solução | 💬 Por quê? |
|:--------|:----------|:------------|
| Achar que GRC é opcional | Estude governança junto com técnica | Sem governança, técnica não tem valor |
| Usar MD5 ou SHA1 | Use SHA-256 ou superior | MD5 e SHA1 estão quebrados há anos |
| Não entender LGPD | Leia a lei e estude casos | Multas de até 2% do faturamento |
| Criptografar com senhas fracas | Use senhas longas e aleatórias | Criptografia com senha fraca = inútil |
| Não validar certificados TLS | Sempre verifique cadeia de certificados | TLS inválido = MITM fácil |

---

## 🧪 Laboratório Prático

> **Exercícios detalhados com passo a passo, macetes e links!**

👉 **[Acessar LABS.md](LABS.md)** — 6+ exercícios práticos com objetivos, ferramentas, macetes e links diretos

## 🧪 Labs Recomendados

### 🟢 Iniciante
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| Cryptography Basics | TryHackMe | Fundamentos de crypto | [Acessar](https://tryhackme.com/room/cryptographyintro) |
| OpenSSL | Linux Journey | Prática com OpenSSL | [Acessar](https://linuxjourney.com/) |

### 🟡 Intermediário
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| Cryptopals | Cryptopals | Desafios práticos | [Acessar](https://cryptopals.com/) |
| CyberChef | GCHQ | Operações criptográficas | [Acessar](https://gchq.github.io/CyberChef/) |

### 🔴 Avançado
| Lab | Plataforma | Foco | Link |
|:----|:-----------|:-----|:-----|
| NIST CSF | NIST | Framework completo | [Acessar](https://www.nist.gov/cyberframework) |
| ISO 27001 Lead Implementer | Certificação | Governança profissional | [Acessar](https://www.iso.org/iso-27001-information-security.html) |

---

## ✅ Checklist de Conclusão

Antes de concluir a trilha, verifique:

- [ ] Entendo o que é ISO 27001 e como se aplica
- [ ] Consigo explicar o NIST Cybersecurity Framework
- [ ] Entendo os 5 pilares da LGPD
- [ ] Consigo usar OpenSSL para criptografar/descriptografar
- [ ] Consigo gerar e usar chaves GPG
- [ ] Consigo usar age para criptografia moderna
- [ ] Consigo usar CyberChef para operações criptográficas
- [ ] Entendo a diferença entre simétrica e assimétrica
- [ ] Completei pelo menos 2 labs deste módulo

---

## 🔗 Navegação

```
┌─────────────────────────────────────────────────────────────────┐
│                      🗺️ MAPA DA TRILHA                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ◀── Módulo 9: Ambientes Especiais                             │
│       │                                                         │
│       ▼                                                         │
│  ┌─────────────────────────────────────────┐ ◀── VOCÊ ESTÁ AQUI │
│  │  📌 Módulo 10: Governança & Criptografia│                   │
│  │     01-grc-e-compliance.md              │                   │
│  │     02-criptografia.md                  │                   │
│  └─────────────────────────────────────────┘                   │
│       │                                                         │
│       ▼                                                         │
│  ┌─────────────────────────────────────────┐                   │
│  │  🎉 FIM DA TRILHA! Parabéns!           │                   │
│  └─────────────────────────────────────────┘                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**⬅️ Anterior:** [Módulo 9: Ambientes](../09-ambientes/)
**🏁 FIM DA TRILHA!**

---

## 📖 Referências

- 📘 [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- 📗 [LGPD - Lei 13.709/2018](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm)
- 📙 [ISO 27001](https://www.iso.org/iso-27001-information-security.html)
- 📕 [OpenSSL Documentation](https://www.openssl.org/docs/)
- 🌐 [TryHackMe - Cryptography Basics](https://tryhackme.com/room/cryptographyintro)
- 🌐 [Cryptopals](https://cryptopals.com/)

---

> **⏱️ Tempo estimado:** 4-5 horas | **🎯 Nível:** ⭐ Iniciante/Intermediário | **🏁 FIM DA TRILHA!** 🎉
