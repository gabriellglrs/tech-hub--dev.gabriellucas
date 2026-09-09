# 🚪 Portas e Protocolos

> **Portas** são as "portas de entrada" de cada serviço em um computador. Protocolos são as "regras de comunicação". Juntos, permitem que dados cheguem ao lugar certo.

## 📚 O que são Portas e Protocolos?

Uma **porta** é um número que identifica um serviço específico em um computador. Um **protocolo** é o conjunto de regras que define como os dados são transmitidos.

### Por que isso é importante?

- **Portas abertas = serviços ativos** — cada porta é uma porta de entrada potencial
- **Análise de portas** é o primeiro passo em qualquer pentest
- **Firewalls bloqueiam portas** — entender portas é entender defesa
- **Cada porta tem um serviço padrão** — port 22=SSH, port 80=HTTP, port 443=HTTPS

### Como funciona na prática?

```
Computador alvo: 192.168.1.50

Porta 22  → SSH        (acesso remoto)
Porta 80  → HTTP       (web server)
Porta 443 → HTTPS      (web seguro)
Porta 3306 → MySQL     (banco de dados)
Porta 4444 → Metasploit (exploit framework)
```

Para entender portas e protocolos, você precisa dominar:
- **Portas bem-known** (0-1023)
- **TCP vs UDP** (confiável vs rápido)
- **Comandos** (netstat, ss, lsof, nmap)
- **Análise de portas** para descobrir serviços

---

## 🏠 Analogia

Imagine um prédio de escritórios:

```
┌─────────────────────────────────────┐
│          PRÉDIO (Servidor)           │
│                                      │
│  Porta 80  → Sala de recepção (Web) │
│  Porta 443 → Sala VIP (HTTPS)       │
│  Porta 22  → Escritório do chefe    │
│              (SSH)                   │
│  Porta 25  → Correio (Email)        │
│  Porta 3389 → Sala de conferência   │
│               (RDP)                  │
└─────────────────────────────────────┘
```

---

## 🔢 O que são portas?

- Números de **0 a 65535**
- Cada serviço roda em uma porta específica
- **TCP** e **UDP** usam as mesmas portas, mas são protocolos diferentes

---

## 📋 Portas mais Importantes

### Portas Bem Conhecidas (0-1023)

| Porta | Protocolo | Serviço | O que é |
|:------|:----------|:--------|:--------|
| **21** | TCP | FTP | Transferência de arquivos |
| **22** | TCP | SSH | Acesso remoto seguro |
| **23** | TCP | Telnet | Acesso remoto (INSEGURO) |
| **25** | TCP | SMTP | Envio de email |
| **53** | TCP/UDP | DNS | Resolução de nomes |
| **80** | TCP | HTTP | Web (sem criptografia) |
| **110** | TCP | POP3 | Receber email |
| **143** | TCP | IMAP | Receber email |
| **443** | TCP | HTTPS | Web (com criptografia) |
| **445** | TCP | SMB | Compartilhamento Windows |
| **3306** | TCP | MySQL | Banco de dados |
| **3389** | TCP | RDP | Área de trabalho remota |

### Portas Registradas (1024-49151)

| Porta | Serviço | Uso |
|:------|:--------|:----|
| **8080** | HTTP alternativo | Proxies, testes |
| **8443** | HTTPS alternativo | APIs |
| **5432** | PostgreSQL | Banco de dados |
| **6379** | Redis | Cache |
| **27017** | MongoDB | Banco NoSQL |

---

## 🔀 TCP vs UDP

| Característica | TCP | UDP |
|:---------------|:----|:----|
| **Confiável** | ✅ Sim | ❌ Não |
| **Ordem** | ✅ Garantida | ❌ Não garantida |
| **Velocidade** | 🐢 Mais lento | 🚀 Mais rápido |
| **Conexão** | Orientado à conexão | Sem conexão |
| **Exemplo** | Web, SSH, Email | DNS, VoIP, Games |

---

## 🔧 Comandos Práticos

### Ver portas abertas (Linux)
```bash
# Ver portas em escuta
ss -tulnp

# Saída:
# State   Recv-Q  Send-Q  Local Address:Port  Process
# LISTEN  0       128     0.0.0.0:22          users:(("sshd"))
# LISTEN  0       128     0.0.0.0:80          users:(("nginx"))
# LISTEN  0       128     0.0.0.0:443         users:(("nginx"))
```

### Ver portas abertas (Windows)
```cmd
netstat -ano

# Ou mais específico:
netstat -an | findstr "LISTENING"
```

### Testar porta específica
```bash
# Testar se porta 80 está aberta
nc -zv 192.168.1.1 80

# Testar múltiplas portas
nc -zv 192.168.1.1 22 80 443
```

---

## 💡 Dicas

> **Porta 22 (SSH)** é o alvo #1 de ataques de força bruta

> **Porta 80 (HTTP)** envia dados em texto plano — NUNCA use para senhas

> **Porta 443 (HTTPS)** é a versão segura — sempre prefira

---

## ✅ Checkpoint

- [ ] Consigo listar as 10 portas mais importantes
- [ ] Sei a diferença entre TCP e UDP
- [ ] Consigo usar `ss -tulnp` ou `netstat`
- [ ] Entendo por que porta 80 é perigosa

---

<div align="center">

**⬅️ [Anterior: DNS](03-dns.md)** | **[Próximo: TCP/IP e OSI] ➡️**

</div>
