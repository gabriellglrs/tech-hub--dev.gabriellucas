# 🔐 Módulo 11 - API Security

> **Proteja e ataque APIs REST, GraphQL e gRPC como um profissional**

## 📊 Informações do Módulo

| ⏱️ Tempo | 📊 Nível | 📁 Arquivos | 🛠️ Ferramentas |
|-----------|----------|-------------|----------------|
| 5-6 horas | ⭐⭐ Intermediário/Avançado | 2 | 8 |

### 🛠️ Ferramentas Utilizadas

`Postman` `curl` `ffuf` `Arjun` `Kiterunner` `Burp Suite` `nuclei` `jwt_tool`

---

## 🎯 Objetivos de Aprendizagem

Ao final deste módulo, você será capaz de:

- [ ] Documentar e mapear APIs completamente
- [ ] Testar autenticação e autorização em endpoints
- [ ] Identificar vulnerabilidades BOLA e BFLA
- [ ] Explorar injeções em APIs (SQL, NoSQL, Command Injection)
- [ ] Testar rate limiting e mitigação de abusos
- [ ] Validar e fuzzar parâmetros de entrada
- [ ] Analisar tokens JWT e OAuth para弱点
- [ ] Automatizar testes de segurança em APIs

---

## 📋 Pré-requisitos

| Conhecimento | Nível | Onde Estudar |
|--------------|-------|--------------|
| HTTP/HTTPS Avançado | Intermediário | Módulo 3 - Web Security |
| JSON/XML | Básico | Documentação online |
| JWT (JSON Web Tokens) | Intermediário | jwt.io |
| OAuth 2.0 | Básico | Documentação OAuth |
| REST APIs | Intermediário | Desenvolvimento Web |

---

## 🗺️ Mapa Visual do Módulo

```
┌─────────────────────────────────────────────────────────────────┐
│                     API SECURITY                                │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │ RECONNAISSANCE│───▶│ DISCOVERY   │───▶│ ENUMERATION │         │
│  │  (1.1-1.2)  │    │  (1.3-1.5)  │    │  (1.6-1.8)  │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│         │                  │                  │                 │
│         ▼                  ▼                  ▼                 │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │  FUZZING    │───▶│ EXPLOITATION│───▶│  POST-EXPLOIT│        │
│  │  (1.9-1.11) │    │ (1.12-1.16) │    │  (1.17-1.19) │        │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 📚 Conteúdo do Módulo

### 📖 Arquivo 1: `01-api-reconnaissance.md`
- Mapeamento inicial de APIs
- Descoberta de endpoints ocultos
- Documentação automática
- Análise de Swagger/OpenAPI

### 📖 Arquivo 2: `02-api-exploitation.md`
- Testes de autenticação e autorização
- Exploração de BOLA/BFLA
- Injeções em APIs
- Rate limiting e abuso

---

## 💡 Dicas de Ouro

### 🥇 Dica 1: O Poder do Arjun
```bash
# Arjun descobre parâmetros ocultos em APIs
arjun -u https://target.com/api/ -m JSON

# Com wordlist específica para APIs
arjun -u https://target.com/api/ -m JSON -w api-params.txt

# Output em JSON para análise posterior
arjun -u https://target.com/api/ -o results.json
```

### 🥈 Dica 2: Kiterunner para APIs
```bash
# Kiterunner é especializado em APIs REST
kr scan https://target.com/ -w routes-large.kite

# Com verbs específicos
kr scan https://target.com/ -w routes-large.kite -m GET,POST,PUT

# Bruteforce de endpoints
kr brute https://target.com/ -w api-endpoints.txt
```

### 🥉 Dica 3: JWT Análise Avançada
```bash
# Decodificar JWT
echo "eyJhbGciOiJIUzI1NiIs..." | base64 -d

# jwt_tool para testes
python3 jwt_tool.py <token> -C -d wordlist.txt

# Testar Key Confusion (RS256 → HS256)
python3 jwt_tool.py <token> -X k -pk public.pem
```

### 🏅 Dica 4: Nuclei para APIs
```bash
# Templates específicos para APIs
nuclei -u https://target.com/api/ -t http/api/

# Testes de segurança em endpoints
nuclei -u https://target.com/ -t http/exposures/

# Scan completo com severity
nuclei -u https://target.com/api/ -severity critical,high
```

---

## ⚠️ Erros Comuns

| ❌ Erro | ✅ Solução |
|---------|-----------|
| Não testar todos os métodos HTTP | Sempre testar GET, POST, PUT, PATCH, DELETE |
| Ignorar endpoints sem autenticação | Mapear TODOS os endpoints primeiro |
| Não verificar rate limiting | Testar com múltiplas requisições rápidas |
| Assumir que IDs são inofensivos | Testar IDOR em todos os parâmetros numéricos |
| Não testar Content-Type | Tentar enviar JSON, XML, form-data |

---

## 🧪 Labs Recomendados

### PortSwigger API Labs
- **URL:** https://portswigger.net/web-security/all-labs#api-testing
- **Duração:** 3-4 horas
- **Foco:** BOLA, BFLA, JWT vulnerabilities
- **Nível:** Intermediário

### TryHackMe - API Security
- **URL:** https://tryhackme.com/room/apihackery
- **Duração:** 2-3 horas
- **Foco:** API enumeration and exploitation
- **Nível:** Intermediário

### WebGoat API Security
- **URL:** https://owasp.org/www-project-webgoat/
- **Duração:** 2 horas
- **Foco:** OWASP API Security Top 10
- **Nível:** Básico/Intermediário

---

## ✅ Checklist de Conclusão

Antes de avançar para o próximo módulo, verifique se você:

- [ ] Consegue mapear uma API desconhecida em menos de 30 minutos
- [ ] Identifica endpoints sem autenticação automaticamente
- [ ] Testa BOLA em pelo menos 3 parâmetros diferentes
- [ ] Configura Burp Suite para interceptar chamadas de API
- [ ] Utiliza Postman para testes automatizados
- [ ] Analisa tokens JWT e identifica弱点
- [ ] Testa rate limiting com ferramentas adequadas
- [ ] Documenta todos os achados em formato profissional
- [ ] Compreende os OWASP API Security Top 10
- [ ] Completa pelo menos 2 labs práticos

---

## 🔗 Navegação

```
Módulo Anterior                    Próximo Módulo
    │                                   │
    ▼                                   ▼
┌───────────────────┐         ┌───────────────────┐
│  10-Web-Security  │────────▶│  12-Database-     │
│     (Avançado)    │         │    Security       │
└───────────────────┘         │    (Avançado)     │
                              └───────────────────┘
```

### 📂 Estrutura do Módulo

```
11-api-security/
├── README.md                    # Este arquivo
├── 01-api-reconnaissance.md    # Mapeamento e descoberta
└── 02-api-exploitation.md      # Exploração e testes
```

### 🏠 [Voltar ao Menu Principal](../README.md)

---

> **⏱️ Tempo estimado de estudo:** 5-6 horas
> **🎯 Dificuldade:** ⭐⭐ Intermediário/Avançado
> **✅ Pré-requisitos completos?** Avance para o Módulo 12!

---

*Criado para a trilha de Cybersegurança - Módulo 11: API Security*
