# 🛡️ Módulo 7: Labs de Defesa e Hardening

## Pré-requisitos

| Pré-requisito | Nível | Observação |
|---------------|-------|------------|
| Linux básico | ⭐⭐ | Navegação, permissões, gerenciamento de pacotes |
| Rede básica | ⭐⭐ | TCP/IP, portas, protocolos |
| Serviços Linux | ⭐⭐ | systemd, systemctl |
| Linha de comando | ⭐⭐ | Comfortável com terminal |
| Conceitos de segurança | ⭐ | Familiaridade com ameaças |

---

## Exercício 1: Auditoria com Lynis

**Tempo estimado:** 30 min

**Objetivo:** Auditar a segurança de um sistema Linux usando o Lynis, identificando vulnerabilidades e obtendo um score de conformidade.

**Conhecimentos envolvidos:**
- Hardening de sistemas
- CIS Benchmark
- Score de segurança
- Relatórios de auditoria

**Ferramentas:**
- Lynis
- apt (para instalação)

**Passo a passo:**

```bash
# 1. Instalar o Lynis
sudo apt update && sudo apt install -y lynis

# 2. Executar auditoria completa
sudo lynis audit system

# 3. Salvar relatório detalhado
sudo lynis audit system --logfile /tmp/lynis-report.dat

# 4. Verificar o score obtido
grep "hardening_index" /var/log/lynis.log

# 5. Listar apenas warnings e sugestões
sudo lynis audit system 2>&1 | grep -E "warning|suggestion"

# 6. Focar em subsystems específicos
sudo lynis audit system --tests-from-group "firewalls"
sudo lynis audit system --tests-from-group "authentication"
```

**Macetes:**
- O score ideal é acima de 70 para sistemas em produção
- Salve o relatório em `/tmp` para análise posterior
- Foque nos **warnings** primeiro — são os problemas mais críticos
- Rode periodicamente para manter conformidade
- Use `--no-colors` para facilitar cópia do output

**Checklist:**
- [ ] Lynis instalado corretamente
- [ ] Auditoria completa executada
- [ ] Score obtido e anotado
- [ ] Warnings identificados e documentados
- [ ] Relatório salvo em `/tmp`
- [ ] Pelo menos 3 recomendações implementadas

**Link de referência:** https://tryhackme.com/room/linuxfundamentalspart1

---

## Exercício 2: Configurar UFW (Firewall)

**Tempo estimado:** 25 min

**Objetivo:** Configurar um firewall básico no Linux usando o UFW, criando regras de entrada e saída para proteger o sistema.

**Conhecimentos envolvidos:**
- Regras de entrada/saída
- Portas e protocolos
- Políticas padrão
- Gerenciamento de firewall

**Ferramentas:**
- UFW (Uncomplicated Firewall)
- apt

**Passo a passo:**

```bash
# 1. Instalar o UFW
sudo apt update && sudo apt install -y ufw

# 2. Definir políticas padrão (CUIDADO: não bloqueie SSH!)
sudo ufw default deny incoming
sudo ufw default allow outgoing

# 3. Permitir SSH (evita lockout!)
sudo ufw allow 22/tcp

# 4. Permitir HTTP e HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# 5. Habilitar o firewall
sudo ufw enable

# 6. Verificar status das regras
sudo ufw status verbose
sudo ufw status numbered

# 7. Testar conectividade
curl -I http://example.com
ping 8.8.8.8

# 8. Adicionar regras adicionais
sudo ufw allow from 192.168.1.0/24 to any port 3306
sudo ufw deny 3389/tcp
```

**Macetes:**
- **SEMPRE** permita SSH antes de habilitar o UFW
- Use `ufw status numbered` para ver regras com números
- Para remover regra: `ufw delete [número]`
- Teste a conectividade após cada regra
- Regras de IP são mais seguras que portas abertas globalmente

**Checklist:**
- [ ] UFW instalado
- [ ] Políticas padrão configuradas (deny incoming, allow outgoing)
 SSH permitido (porta 22)
- [ ] HTTP/HTTPS permitidos
- [ ] UFW habilitado e funcionando
- [ ] Teste de conectividade realizado
- [ ] Pelo menos 1 regra personalizada criada

**Link de referência:** https://tryhackme.com/room/linuxfundamentalspart1

---

## Exercício 3: Regras Avançadas com iptables

**Tempo estimado:** 40 min

**Objetivo:** Criar regras de firewall complexas usando iptables, manipulando chains, targets e critérios de correspondência.

**Conhecimentos envolvidos:**
- Chains (INPUT, OUTPUT, FORWARD)
- Targets (ACCEPT, DROP, REJECT)
- Matching por IP, porta, protocolo
- NAT e port forwarding

**Ferramentas:**
- iptables
- iptables-persistent

**Passo a passo:**

```bash
# 1. Verificar regras atuais
sudo iptables -L -v -n
sudo iptables -L -v -n --line-numbers

# 2. Limpar todas as regras (CUIDADO!)
sudo iptables -F
sudo iptables -X

# 3. Configurar política padrão
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# 4. Permitir tráfego loopback
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A OUTPUT -o lo -j ACCEPT

# 5. Permitir conexões estabelecidas
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# 6. Permitir SSH de IP específico
sudo iptables -A INPUT -s 192.168.1.100 -p tcp --dport 22 -j ACCEPT

# 7. Bloquear IP específico
sudo iptables -A INPUT -s 10.10.10.10 -j DROP

# 8. Permitir HTTP/HTTPS
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# 9. Rate limiting no SSH (anti-brute force)
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set --name SSH
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 --name SSH -j DROP

# 10. Port forwarding (8080 → 80)
sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j REDIRECT --to-port 80

# 11. Salvar regras
sudo apt install -y iptables-persistent
sudo netfilter-persistent save

# 12. Verificar e testar
sudo iptables -L -v -n
```

**Macetes:**
- Sempre verifique com `iptables -L -v -n` antes de alterar
- Use `--line-numbers` para facilitar remoção de regras
- Para remover regra: `iptables -D INPUT [número]`
- Salve as regras com `iptables-save > /etc/iptables/rules.v4`
- Use `iptables-restore` para restaurar backup

**Checklist:**
- [ ] Regras atuais verificadas
- [ ] Política padrão configurada (DROP INPUT)
- [ ] Loopback permitido
- [ ] Conexões estabelecidas permitidas
- [ ] Pelo menos 3 regras customizadas criadas
- [ ] Rate limiting configurado
- [ ] Regras salvas permanentemente

**Link de referência:** https://tryhackme.com/room/linuxfundamentalspart1

---

## Exercício 4: IDS com Suricata

**Tempo estimado:** 45 min

**Objetivo:** Instalar e configurar o Suricata como sistema de detecção de intrusões (IDS), monitorando tráfego e gerando alertas.

**Conhecimentos envolvidos:**
- Regras de detecção
- Alertas e logs
- Assinaturas de rede
- Análise de tráfego

**Ferramentas:**
- Suricata
- suricata-update
- tcpdump

**Passo a passo:**

```bash
# 1. Instalar Suricata
sudo apt update && sudo apt install -y suricata

# 2. Atualizar regras
sudo suricata-update

# 3. Verificar regras instaladas
ls /var/lib/suricata/rules/
cat /var/lib/suricata/rules/suricata.rules | head -20

# 4. Criar regra customizada
sudo nano /etc/suricata/custom.rules
```

```bash
# Regra: Alerta quando alguém faz scan de portas
alert tcp any any -> $HOME_NET any (msg:"PORT SCAN detected"; flags:S; threshold:type both, track by_src, count 5, seconds 60; sid:1000001; rev:1;)

# Regra: Alerta para tentativas de brute force SSH
alert tcp any any -> $HOME_NET 22 (msg:"SSH Brute Force Attempt"; flags:S,12; threshold:type both, track by_src, count 10, seconds 60; sid:1000002; rev:1;)
```

```bash
# 5. Adicionar regras customizadas ao Suricata
echo "include /etc/suricata/custom.rules" | sudo tee -a /etc/suricata/suricata.yaml

# 6. Testar configuração
sudo suricata -T -c /etc/suricata/suricata.yaml

# 7. Iniciar Suricata em modo IDS
sudo suricata -c /etc/suricata/suricata.yaml -i eth0

# 8. Em outro terminal, gerar tráfego suspeito
sudo nmap -sS 127.0.0.1

# 9. Verificar alertas
sudo tail -f /var/log/suricata/fast.log
sudo tail -f /var/log/suricata/eve.json

# 10. Verificar estatísticas
sudo cat /var/log/suricata/stats.log | grep -i alert
```

**Macetes:**
- Use `suricata-update` para manter regras atualizadas
- Logs ficam em `/var/log/suricata/`
- `fast.log` mostra alertas resumidos
- `eve.json` tem logs detalhados em formato JSON
- Teste sempre a configuração com `-T` antes de iniciar
- Use `tcpdump` para capturar pacotes se necessário

**Checklist:**
- [ ] Suricata instalado e configurado
- [ ] Regras atualizadas com suricata-update
- [ ] Pelo menos 2 regras customizadas criadas
- [ ] Configuração testada com `-T`
- [ ] Suricata rodando em modo IDS
- [ ] Alertas gerados e verificados em logs
- [ ] Estatísticas de alertas analisadas

**Link de referência:** https://tryhackme.com/room/dvwa

---

## Exercício 5: SIEM com Wazuh

**Tempo estimado:** 60 min

**Objetivo:** Configurar o Wazuh para centralização de logs, análise de segurança e criação de alertas personalizados.

**Conhecimentos envolvidos:**
- Log analysis
- Dashboards e visualizações
- Alertas e notificações
- Monitoramento em tempo real

**Ferramentas:**
- Wazuh Manager
- Wazuh Agent
- curl

**Passo a passo:**

```bash
# 1. Instalar Wazuh Manager (servidor)
curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh && sudo bash ./wazuh-install.sh -a

# 2. Verificar status do serviço
sudo systemctl status wazuh-manager

# 3. Instalar agente em outro endpoint (ou no mesmo para teste)
curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh && sudo bash ./wazuh-install.sh -a

# 4. Configurar agente
sudo nano /var/ossec/etc/ossec.conf
```

```xml
<!-- Adicionar no <ossec_config> -->
<localfile>
  <log_format>syslog</log_format>
  <location>/var/log/auth.log</location>
</localfile>

<localfile>
  <log_format>syslog</log_format>
  <location>/var/log/syslog</location>
</localfile>
```

```bash
# 5. Criar regra customizada
sudo nano /var/ossec/etc/rules/local_rules.xml
```

```xml
<group name="custom,">
  <rule id="100100" level="10">
    <if_sid>5712</if_sid>
    <match>Failed password for root</match>
    <description>Root login attempt detected</description>
    <group>authentication_failures,</group>
  </rule>

  <rule id="100101" level="7">
    <if_sid>5715</if_sid>
    <match>sudo:</match>
    <description>Sudo command executed</description>
    <group>privileged_access,</group>
  </rule>
</group>
```

```bash
# 6. Reiniciar para aplicar mudanças
sudo systemctl restart wazuh-manager

# 7. Acessar dashboard (porta 443)
# https://<IP_DO_SERVIDOR> - Usuário: admin / Senha: admin

# 8. Gerar eventos de teste
sudo su -c "invalid_user" root 2>&1 || true
sudo tail -f /var/ossec/logs/alerts/alerts.log

# 9. Verificar alertas gerados
sudo cat /var/ossec/logs/alerts/alerts.log | tail -20

# 10. Verificar integridade de arquivos
sudo cat /var/ossec/etc/ossec.conf | grep syscheck
```

**Macetes:**
- Senha padrão do dashboard é admin/admin — **troque imediatamente**
- Logs ficam em `/var/ossec/logs/alerts/`
- Dashboards ficam em `https://<IP>:443`
- Crie regras em `/var/ossec/etc/rules/local_rules.xml`
- Use `wazuh-logtest` para testar regras antes de aplicar
- Configure alertas por email em `ossec.conf`

**Checklist:**
- [ ] Wazuh Manager instalado e funcionando
- [ ] Agente configurado e conectado
- [ ] Pelo menos 1 log source adicionado
- [ ] Regra customizada criada e testada
- [ ] Dashboard acessível
- [ ] Alertas sendo gerados corretamente
- [ ] Integridade de arquivos monitorada

**Link de referência:** https://documentation.wazuh.com/current/getting-started/index.html

---

## Exercício 6: Hardening Completo (Final Challenge)

**Tempo estimado:** 90 min

**Objetivo:** Endurecer completamente um sistema Linux do zero, aplicando todas as técnicas de defesa aprendidas no módulo.

**Conhecimentos envolvidos:**
- Todas as técnicas dos exercícios anteriores
- Auditoria de segurança
- Firewall e IDS
- Monitoramento e resposta

**Ferramentas:**
- Lynis, UFW, iptables, fail2ban, Suricata, Wazuh

**Passo a passo:**

```bash
# FASE 1: AUDITORIA INICIAL
# 1. Instalar e rodar Lynis
sudo apt update && sudo apt install -y lynis
sudo lynis audit system 2>&1 | tee /tmp/initial-audit.txt
grep "hardening_index" /var/log/lynis.log

# 2. Documentar vulnerabilidades encontradas
grep -E "warning|suggestion|critical" /tmp/initial-audit.txt > /tmp/vulnerabilities.txt
cat /tmp/vulnerabilities.txt
```

```bash
# FASE 2: HARDENING BÁSICO
# 3. Atualizar sistema
sudo apt update && sudo apt upgrade -y

# 4. Configurar UFW
sudo apt install -y ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable

# 5. Configurar fail2ban
sudo apt install -y fail2ban
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
sudo nano /etc/fail2ban/jail.local
```

```ini
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = 22
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
```

```bash
# 6. Ativar fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# 7. Configurar iptables avançado
sudo iptables -P INPUT DROP
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --set --name SSH
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 --name SSH -j DROP
sudo netfilter-persistent save
```

```bash
# FASE 3: MONITORAMENTO
# 8. Instalar Suricata
sudo apt install -y suricata
sudo suricata-update
sudo systemctl enable suricata
sudo systemctl start suricata

# 9. Configurar Wazuh Agent
curl -sO https://packages.wazuh.com/4.7/wazuh-install.sh
sudo bash ./wazuh-install.sh -a

# 10. Verificar serviços
sudo systemctl status ufw
sudo systemctl status fail2ban
sudo systemctl status suricata
sudo systemctl status wazuh-manager
```

```bash
# FASE 4: VALIDAÇÃO
# 11. Rodar auditoria final
sudo lynis audit system 2>&1 | tee /tmp/final-audit.txt

# 12. Comparar scores
echo "Score Inicial: $(grep 'hardening_index' /var/log/lynis.log | head -1)"
echo "Score Final: $(sudo lynis show details | grep hardening_index)"

# 13. Testar firewall
sudo ufw status verbose
sudo iptables -L -v -n

# 14. Verificar logs
sudo tail -f /var/log/suricata/fast.log
sudo tail -f /var/ossec/logs/alerts/alerts.log
sudo fail2ban-client status sshd
```

**Macetes:**
- **FAÇA AUDITORIA ANTES E DEPOIS** — compare os scores
- Ordem recomendada: Auditar → Atualizar → Firewall → IDS → Monitorar
- Teste cada componente individualmente antes de avançar
- Documente todas as mudanças feitas
- Mantenha SSH aberto para não ficar trancado
- Crie backup das configs originais antes de modificar

**Checklist:**
- [ ] Auditoria inicial realizada e documentada
- [ ] Sistema atualizado completamente
- [ ] UFW configurado e ativo
- [ ] fail2ban configurado e ativo
- [ ] iptables com regras avançadas
- [ ] Suricata instalado e monitorando
- [ ] Wazuh configurado e coletando logs
- [ ] Auditoria final realizada
- [ ] Score de hardening melhorou
- [ ] Todos os serviços testados e funcionando
- [ ] Documentação completa das mudanças

**Link de referência:** https://tryhackme.com/room/linuxfundamentalspart1
