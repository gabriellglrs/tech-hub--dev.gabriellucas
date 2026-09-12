# Anexo C: Quando Parar — Critérios de Parada e Escopo

## Princípios Éticos

### Regra de Ouro
**NUNCA** execute testes de segurança sem autorização explícita por escrito.

### Autorização Necessária
1. **Escrito e assinado** pelo proprietário do alvo
2. **Escopo definido** (URLs, IPs, domínios)
3. **Período de teste** especificado
4. **Contato de emergência** fornecido
5. **Regras de engajamento** acordadas

---

## Quando Parar

### Parada Imediata
Pare imediatamente se:
1. **Dano colateral** — Você afetou serviços não incluídos no escopo
2. **Serviço indisponível** — O alvo caiu ou ficou lento
3. **Dados sensíveis** — Você acessou dados de usuários reais
4. **Atividade suspeita** — Outros estão monitorando seus testes
5. **Limite de tempo** — Período de teste expirou

### Parada por Ética
Pare se:
1. **Não há mais o que testar** — Todos os endpoints foram cobertos
2. **Repetição** — Vulnerabilidades já encontradas e documentadas
3. **Escopo excedido** — Você está fora do escopo definido
4. **Risco alto demais** — Teste pode causar danos irreversíveis

---

## Limites do Escopo

### Dentro do Escopo
- URLs e IPs especificados no contrato
- Subdomínios listados explicitamente
- Portas e serviços definidos

### Fora do Escopo
- Serviços de terceiros (CDN, cloud providers)
- Usuários reais (não execute phishing real)
- Dados pessoais (não exfiltre PII)
- Infraestrutura de produção (use staging quando possível)

---

## Dicas para Não Exceder o Escopo

### 1. Documente Tudo
```bash
# Salve cada request e response
# Documente cada ação tomada
# Mantenha logs de todas as ferramentas
```

### 2. Use Ambientes de Staging
```bash
# Prefira testes em ambiente de staging
# Evite testes em produção
# Use dados fictícios sempre que possível
```

### 3. Controle a Velocidade
```bash
# Não execute muitos requests por segundo
# Use rate limiting em todas as ferramentas
# Espere entre cada teste
```

### 4. Monitore o Impacto
```bash
# Verifique se o alvo está respondendo normalmente
# Monitore logs do servidor
# Esteja preparado para parar imediatamente
```

---

## Checklist de Escopo

### Antes do Teste
- [ ] Contrato assinado com escopo definido
- [ ] Período de teste especificado
- [ ] Contato de emergência configurado
- [ ] Ambiente de staging disponível
- [ ] Dados fictícios preparados

### Durante o Teste
- [ ] Todos os requests estão dentro do escopo
- [ ] Nenhum dado real foi acessado
- [ ] Velocidade控制ada
- [ ] Logs sendo salvos

### Após o Teste
- [ ] Todos os findings documentados
- [ ] Nenhum dado sensível no relatório
- [ ] Recomendações claras
- [ ] Contato de emergência desligado

---

## Situações Especiais

### Alvo Responde com 403/401
**Ação:** Não tente bypassar autenticação sem autorização explícita

### Alvo tem WAF (Web Application Firewall)
**Ação:** Reduza a velocidade, não tente DoS o WAF

### Alvo está lento
**Ação:** Pare os testes, verifique se é causado por seus testes

### Alvo cai
**Ação:** Pare imediatamente, contate o responsável

### Você encontra dados sensíveis
**Ação:** Não exfiltre, documente e reporte no relatório

---

## Responsabilidades do Tester

1. **Confidencialidade** — Mantenha os dados do alvo seguros
2. **Integridade** — Não modifique dados sem necessidade
3. **Disponibilidade** — Não cause indisponibilidade propositalmente
4. **Transparência** — Documente tudo, oculte nada
5. **Profissionalismo** — Mantenha postura ética sempre

---

## Contato de Emergência

### Informações para Contato
- **Nome:** [Responsável pelo teste]
- **Email:** [Email de contato]
- **Telefone:** [Telefone de emergência]
- **Horário:** [Horário de disponibilidade]

### O que Reportar
- Vulnerabilidade crítica encontrada
- Dano colateral causado
- Dados sensíveis acessados
- Qualquer situação fora do comum

---

## Conclusão

Lembre-se: **O objetivo é melhorar a segurança, não causar danos.**

Seja ético, seja profissional, seja responsável.

Quando em dúvida, **PARE** e consulte o responsável pelo alvo.
