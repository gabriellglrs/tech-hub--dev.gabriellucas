# Labs — Módulo 11: IA para Cybersegurança

---

## Lab 1: Instalação e Primeiro Uso do Ollama

**Objetivo:** Instalar Ollama e rodar seu primeiro modelo de IA.

### Passo 1: Instalar Ollama

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

### Passo 2: Verificar instalação

```bash
ollama --version
systemctl status ollama
```

### Passo 3: Baixar e rodar um modelo

```bash
# Baixar modelo leve
ollama pull llama3.2

# Rodar chat interativo
ollama run llama3.2

# Dentro do chat, teste:
# "O que é SQL Injection?"
# "Explique o que é um buffer overflow"
# "Quais são as portas comuns do MySQL?"
```

### Passo 4: Verificar recursos

```bash
# Modelos baixados
ollama ls

# Modelos rodando
ollama ps
```

### Validação

- [ ] Ollama instalado e rodando
- [ ] Modelo `llama3.2` baixado
- [ ] Consegue fazer perguntas e receber respostas

---

## Lab 2: IA Analisando Nmap

**Objetivo:** Usar IA para interpretar resultados de scan.

### Passo 1: Escanear um alvo (lab autorizado)

```bash
nmap -sV -sC -oN /tmp/nmap_scan.txt 127.0.0.1
```

### Passo 2: Alimentar com IA

```bash
ollama run llama3.1:8b <<EOF
Analise este resultado de Nmap e identifique:
1. Portas abertas e serviços
2. Versões potencialmente vulneráveis
3. Vetores de ataque possíveis
4. Ações recomendadas

$(cat /tmp/nmap_scan.txt)
EOF
```

### Passo 3: Comparar com sua análise manual

1. Primeiro, analise o scan **sozinho**
2. Depois, peça para a IA analisar
3. Compare os resultados — o que a IA achou que você não viu?

### Validação

- [ ] Scan Nmap salvo em arquivo
- [ ] IA fornece análise do scan
- [ ] Você comparou sua análise com a da IA

---

## Lab 3: Gerando Payloads com IA

**Objetivo:** Usar IA para criar payloads de exploração.

### Exercício 1: Payload SQL Injection

```bash
ollama run codellama:13b <<EOF
Gere um payload Python para testar SQL Injection em um formulário de login.
O formulário tem campos: username e password.
Use a biblioteca requests.
Inclua:
- Payload para bypass de autenticação
- Payload para UNION-based
- Payload para Time-based blind
EOF
```

### Exercício 2: Payload XSS

```bash
ollama run codellama:13b <<EOF
Gere payloads XSS para:
1. Reflected XSS em parâmetro de URL
2. Stored XSS em campo de comentário
3. DOM-based XSS
Inclua variações para contornar filtros básicos.
EOF
```

### Exercício 3: Reverse Shell

```bash
ollama run codellama:13b <<EOF
Gere reverse shells em多种语言:
1. Bash
2. Python
3. PowerShell
4. Netcat
Para cada uma, inclua a sintaxe exata e como usar.
Apenas para fins educacionais em ambiente autorizado.
EOF
```

### Validação

- [ ] Payloads gerados pela IA
- [ ] Você entende cada payload
- [ ] Testou os payloads em ambiente seguro (lab)

---

## Lab 4: Análise de Senhas com IA

**Objetivo:** Usar IA para analisar senhas quebradas.

### Passo 1: Quebrar senhas com John

```bash
# Criar arquivo de hash fictício
echo 'user1:$6$rounds=656000$fakehash' > /tmp/hashes.txt

# Usar John (exemplo)
john --wordlist=/usr/share/wordlists/rockyou.txt /tmp/hashes.txt
```

### Passo 2: Analisar com IA

```bash
ollama run llama3.2 <<EOF
Analise as senhas quebradas abaixo e identifique:
1. Padrões fracos
2. Tempo estimado para quebrar cada uma
3. Recomendações para senhas mais fortes
4. Classificação de risco

Senhas encontradas:
$(john --show /tmp/hashes.txt 2>/dev/null || echo "Nenhuma senha quebrada ainda")
EOF
```

### Validação

- [ ] John instalado e configurado
- [ ] IA analisa padrões de senhas
- [ ] Você entende por que senhas são fracas

---

## Lab 5: Workflow Completo — IA + Pentest

**Objetivo:** Criar um pipeline completo de pentest com IA.

### Script: `pentest-ai.sh`

```bash
#!/bin/bash
# pentest-ai.sh — Pipeline de Pentest com IA
# USO APENAS EM AMBIENTES AUTORIZADOS

TARGET=${1:-"127.0.0.1"}
REPORT="/tmp/pentest_$(date +%Y%m%d).md"

echo "# Relatório de Pentest - $TARGET" > $REPORT
echo "Data: $(date)" >> $REPORT
echo "" >> $REPORT

# Fase 1: Reconhecimento
echo "## Fase 1: Reconhecimento" >> $REPORT
echo '```' >> $REPORT
nmap -sV -sC $TARGET 2>&1 | tee -a $REPORT
echo '```' >> $REPORT

# Fase 2: Análise com IA
echo "" >> $REPORT
echo "## Análise com IA" >> $REPORT
ollama run llama3.1:8b <<EOF >> $REPORT
Analise o scan Nmap acima e identifique vulnerabilidades, 
versões desatualizadas e vetores de ataque.
EOF

echo "[+] Relatório salvo em: $REPORT"
```

### Validação

- [ ] Script criado e executável
- [ ] Pipeline roda de ponta a ponta
- [ ] Relatório gerado com análise IA

---

## Lab 6: Crie seu Próprio Assistente AI

**Objetivo:** Criar funções personalizadas de IA no terminal.

### Adicionar ao `.zshrc`

```bash
# === FUNÇÕES DE IA PARA SEGURANÇA ===

# Analisar arquivo com IA
ai-analise() {
    if [ -z "$1" ]; then
        echo "Uso: ai-analise <arquivo>"
        return 1
    fi
    ollama run llama3.1:8b "Analise este arquivo de segurança e identifique vulnerabilidades: $(cat $1)"
}

# Gerar relatório
ai-relatorio() {
    if [ -z "$1" ]; then
        echo "Uso: ai-relatorio <arquivo>"
        return 1
    fi
    ollama run llama3.2 "Gere um relatório profissional de pentest a partir destes dados: $(cat $1)"
}

# Gerar payload
ai-payload() {
    if [ -z "$1" ]; then
        echo "Uso: ai-payload <descrição do payload>"
        return 1
    fi
    ollama run codellama:13b "Gere um payload para: $1"
}

# Explicar CVE
ai-cve() {
    if [ -z "$1" ]; then
        echo "Uso: ai-cve <CVE-ID>"
        return 1
    fi
    ollama run llama3.1:8b "Explique a $1 em detalhes: vetor de ataque, impacto, PoC conceitual e remediação"
}

# Analisar logs
ai-logs() {
    if [ -z "$1" ]; then
        echo "Uso: ai-logs <arquivo de log>"
        return 1
    fi
    ollama run mistral "Analise estes logs de segurança e identifique atividade suspeita: $(cat $1)"
}
```

### Recarregar configuração

```bash
source ~/.zshrc
```

### Testar

```bash
ai-analise /tmp/nmap_scan.txt
ai-cve CVE-2021-44228
ai-payload "SQL Injection em login form PHP"
```

### Validação

- [ ] Funções adicionadas ao `.zshrc`
- [ ] Todas as funções testadas
- [ ] Você consegue usar IA diretamente no terminal

---

## Checklist Final

- [ ] Ollama instalado e funcionando
- [ ] Pelo menos 2 modelos baixados
- [ ] Analisou um scan Nmap com IA
- [ ] Gerou payloads com IA
- [ ] Criou um pipeline de pentest com IA
- [ ] Criou funções auxiliares no `.zshrc`
- [ ] Entendeu limitações e riscos da IA

---

**Voltar:** [Módulo 11](README.md)
