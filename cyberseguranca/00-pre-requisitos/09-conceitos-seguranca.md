# 🔐 Conceitos de Segurança

> Antes de aprender a atacar, você precisa entender **o que é segurança** e **por que ataques funcionam**. Estes são os pilares de tudo.

---

## 🏠 Analogia

```
Segurança de uma casa:
- Trancar a porta (Prevenção)
- Ter alarme (Detecção)
- Ter seguro (Recuperação)

Segurança digital é a mesma coisa, só que no mundo virtual
```

---

## 🔺 Triade CIA

A **Triade CIA** são os 3 pilares da segurança:

```
         Confidencialidade
               /\
              /  \
             /    \
            /  CIA \
           /________\
Integridade    Disponibilidade
```

| Pilar | O que protege | Exemplo de ataque |
|:------|:--------------|:------------------|
| **Confidencialidade** | Dados só quem pode ver | Vazamento de senhas |
| **Integridade** | Dados não são alterados | SQL Injection |
| **Disponibilidade** | Sistema funciona quando precisa | DDoS |

---

## 🎯 Tipos de Ameaças

### Por quem?

| Tipo | O que é | Exemplo |
|:-----|:--------|:--------|
| **Script Kiddie** | Iniciante usando ferramentas prontas | Usar Metasploit sem entender |
| **Hacker** | Expert técnico | Exploração zero-day |
| **Insider** | Funcionário da empresa | Vazamento interno |
| **APT** | Grupo organizado (estados) | APT28 (Rússia) |

### Por quê?

| Motivo | Exemplo |
|:-------|:--------|
| **Dinheiro** | Ransomware, fraude |
| **Espionagem** | Roubar segredos industriais |
| **Vingança** | Ex-funcionário |
| **Hacktivismo** | Anonymous |
| **Curiosidade** | Explorar vulnerabilidades |

---

## 🦠 Tipos de Malware

| Tipo | O que faz |传播方式 |
|:-----|:----------|:--------|
| **Virus** | Se anexa a arquivos | Arquivos infectados |
| **Worm** | Se espalha sozinho pela rede | Rede |
| **Trojan** | Finge ser algo útil | Downloads falsos |
| **Ransomware** | Sequestra dados e cobra resgate | Email, RDP |
| **Spyware** | Espia suas ações | Software gratuito |
| **Rootkit** | Esconde processos maliciosos | Exploração |
| **Keylogger** | Grava o que você digita | Trojan |

---

## 🎯 Vetores de Ataque

| Vetor | O que é | Como se proteger |
|:------|:--------|:-----------------|
| **Email** | Phishing, anexos maliciosos | Não clique em links suspeitos |
| **Web** | XSS, SQL Injection | Atualizar, usar WAF |
| **Rede** | Man-in-the-Middle | Usar HTTPS, VPN |
| **USB** | Dispositivos infectados | Não pluge USB desconhecido |
| **Social Engineering** | Enganar o humano | Treinamento, desconfiança |
| **Força Bruta** | Testar senhas | Senhas fortes, 2FA |

---

## 🛡️ Controles de Segurança

### Preventivos (evitam o ataque)
- Firewall
- Antivírus
- Senhas fortes
- Criptografia
- Treinamento

### Detectivos (descobrem o ataque)
- IDS/IPS
- Logs
- Monitoramento
- SIEM

### Corretivos (respondem ao ataque)
- Backup
- Plano de resposta
- Restauração

---

## 📋 Princípios de Segurança

| Princípio | O que significa |
|:----------|:----------------|
| **Least Privilege** | Menor permissão possível |
| **Defense in Depth** | Múltiplas camadas |
| **Zero Trust** | Não confiar em ninguém |
| **Separation of Duties** | Dividir responsabilidades |
| **Need to Know** | Só quem precisa vê |

---

## 🔐 Criptografia Básica

| Conceito | O que é | Exemplo |
|:---------|:--------|:--------|
| **Hash** | Transformação unidirecional | MD5, SHA256 |
| **Simétrica** | Mesma chave | AES |
| **Assimétrica** | Chave pública + privada | RSA |
| **TLS/SSL** | Criptografia na web | HTTPS |

---

## ✅ Checkpoint

- [ ] Consigo explicar a triade CIA
- [ ] Sei a diferença entre vírus, worm e trojan
- [ ] Conheço os principais vetores de ataque
- [ ] Entendo os 3 tipos de controle de segurança

---

<div align="center">

**⬅️ [Anterior: Máquinas Virtuais](08-maquinas-virtuais.md)** | **[Próximo: Python Básico] ➡️**

</div>
