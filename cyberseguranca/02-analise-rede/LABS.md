# Laboratório Prático — Análise de Rede

> Guia completo de exercícios para praticar o que aprendeu. Cada exercício tem objetivo, passo a passo, macetes e o que esperar do resultado.

---

## Pré-requisitos

- [ ] Ferramentas instaladas (ver Instalação no módulo principal)
- [ ] Conta no TryHackMe (gratuita: https://tryhackme.com)
- [ ] Conta no HackTheBox (gratuita: https://hackthebox.com)
- [ ] tcpdump instalado (`sudo apt install tcpdump`)
- [ ] Wireshark/tshark instalado (`sudo apt install wireshark tshark`)
- [ ] mitmproxy instalado (`sudo apt install mitmproxy`)
- [ ] bettercap instalado (`sudo apt install bettercap`)
- [ ] Permissões root (para sniffing e ARP spoofing)

---

## O que você vai praticar

| Exercício | Conhecimento | Ferramentas | Dificuldade | Tempo |
|:----------|:-------------|:------------|:-----------:|:-----:|
| 1 | Protocolos, pacotes, filtros | tcpdump | ⭐ | 30 min |
| 2 | Pcap analysis, protocol dissectors | Wireshark, tshark | ⭐⭐ | 40 min |
| 3 | Proxy, HTTPS, certificates | mitmproxy | ⭐⭐ | 35 min |
| 4 | ARP, sniffing, MITM | bettercap | ⭐⭐⭐ | 45 min |
| 5 | SOCKS, proxy chains, anonimato | proxychains, tor | ⭐⭐ | 25 min |
| 6 | Técnicas completas de análise | tcpdump, Wireshark, tshark | ⭐⭐⭐⭐ | 60 min |

---

## Exercício 1: Captura de Pacotes com tcpdump

### Objetivo
Capturar e filtrar tráfego de rede usando tcpdump, identificando protocolos e dados relevantes.

### Conhecimentos Praticados
- Captura de pacotes em tempo real
- Filtros BPF (Berkeley Packet Filter)
- Protocolos TCP, UDP, HTTP

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| tcpdump (básico) | `tcpdump -i eth0` |
| tcpdump (filtrar porta) | `tcpdump -i eth0 port 80` |
| tcpdump (salvar arquivo) | `tcpdump -i eth0 -w captura.pcap` |
| tcpdump (ler arquivo) | `tcpdump -r captura.pcap` |

### Passo a Passo

```
PASSO 1: Listar interfaces de rede disponíveis
├── Comando: sudo tcpdump -D
├── O que esperar: Lista de interfaces (eth0, wlan0, any, etc.)
└── Se der errado: Usar ip link show para ver interfaces

PASSO 2: Capturar todo o tráfego
├── Comando: sudo tcpdump -i eth0 -c 100
├── O que esperar: 100 pacotes capturados e exibidos na tela
└── Se der errado: Usar -i any para capturar de todas as interfaces

PASSO 3: Filtrar por porta HTTP
├── Comando: sudo tcpdump -i eth0 port 80 -nn
├── O que esperar: Apenas pacotes HTTP (porta 80)
└── Se der errado: Usar port 443 para HTTPS

PASSO 4: Filtrar por host específico
├── Comando: sudo tcpdump -i eth0 host 192.168.1.1 -nn
├── O que esperar: Apenas tráfego de/para o IP especificado
└── Se der errado: Verificar IP do alvo com ping

PASSO 5: Capturar com verbose
├── Comando: sudo tcpdump -i eth0 -vv port 80
├── O que esperar: Detalhes expandidos dos pacotes
└── Se der errado: Usar -vvv para ainda mais detalhes

PASSO 6: Salvar captura em arquivo
├── Comando: sudo tcpdump -i eth0 -w captura_http.pcap port 80
├── O que esperar: Arquivo .pcap criado com a captura
└── Se der errado: Usar Ctrl+C para parar a captura após gerar tráfego
```

### Macetes
> **Macete 1:** `-nn` evita resolver nomes e portas — output mais limpo e rápido.

> **Macete 2:** `port 80` filtra apenas HTTP — essencial para analisar tráfego web.

> **Macete 3:** `-w arquivo.pcap` salva para análise posterior no Wireshark.

> **Macete 4:** `-c 100` limita a 100 pacotes — útil para testes rápidos.

### Checklist
- [ ] Capturar tráfego geral da rede
- [ ] Filtrar por porta e host
- [ ] Usar verbose para detalhes
- [ ] Salvar captura em arquivo .pcap

### Link para o exercício
https://tryhackme.com/room/introtoshark

### Tempo estimado: 30 minutos

---

## Exercício 2: Análise com Wireshark

### Objetivo
Analisar pacotes capturados no Wireshark, encontrando dados sensíveis e padrões de tráfego.

### Conhecimentos Praticados
- Análise de arquivos .pcap
- Filtros Wireshark
- Extração de dados de pacotes

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| Wireshark (GUI) | `wireshark captura.pcap` |
| tshark (CLI) | `tshark -r captura.pcap` |
| tshark (filtrar) | `tshark -r captura.pcap -Y "http.request"` |

### Passo a Passo

```
PASSO 1: Abrir captura no Wireshark
├── Comando: wireshark captura.pcap
├── O que esperar: Interface gráfica com lista de pacotes
└── Se der errado: Usar tshark para análise via terminal

PASSO 2: Aplicar filtro de protocolo
├── Comando (Wireshark): Digitar "http" no filtro
├── Comando (tshark): tshark -r captura.pcap -Y "http"
├── O que esperar: Apenas pacotes HTTP visíveis
└── Se der errado: Tentar "tcp" para todos os pacotes TCP

PASSO 3: Filtrar requisições POST
├── Comando (Wireshark): Filtro "http.request.method==POST"
├── Comando (tshark): tshark -r captura.pcap -Y "http.request.method==POST"
├── O que esperar: Requisições POST com dados enviados
└── Se der errado: Tentar "http.request" para todas as requisições

PASSO 4: Seguir stream TCP
├── Comando (Wireshark): Clicar em pacote → Follow → TCP Stream
├── O que esperar: Dados completos da conversa (pode incluir senhas)
└── Se der errado: Filtrar primeiro por IP de origem/destino

PASSO 5: Exportar dados extraídos
├── Comando (Wireshark): File → Export Specified Packets → Save
├── O que esperar: Pacotes filtrados salvos em novo arquivo
└── Se der errado: Usar File → Export Packet Dissections para CSV

PASSO 6: Análise via terminal com tshark
├── Comando: tshark -r captura.pcap -Y "http.request.method==POST" -T fields -e http.host -e http.request.uri -e http.file_data
├── O que esperar: Host, URI e dados dos POSTs extraídos
└── Se der errado: Verificar campos disponíveis com tshark -G fields
```

### Macetes
> **Macete 1:** Filtros Wireshark usam sintaxe específica — `http.request.method==POST` (com `==`).

> **Macete 2:** "Follow TCP Stream" mostra o conteúdo completo da comunicação em texto.

> **Macete 3:** `tshark` é ideal para automação e scripts — mesma lógica do Wireshark mas em CLI.

> **Macete 4:** Use "follow http stream" para ver dados HTML e parâmetros de formulário.

### Checklist
- [ ] Abrir e navegar captura no Wireshark
- [ ] Aplicar filtros de protocolo
- [ ] Seguir stream TCP para ver dados
- [ ] Extrair dados com tshark

### Link para o exercício
https://tryhackme.com/room/wireshark

### Tempo estimado: 40 minutos

---

## Exercício 3: Interceptação com mitmproxy

### Objetivo
Interceptar tráfego HTTPS e modificar requests/responses usando mitmproxy como proxy intermediário.

### Conhecimentos Praticados
- Proxy HTTP/HTTPS
- Certificados SSL/TLS
- Interceção de tráfego

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| mitmproxy | `mitmproxy` |
| mitmweb | `mitmweb` (interface web) |
| mitmdump | `mitmdump -w arquivo` (dump para arquivo) |

### Passo a Passo

```
PASSO 1: Iniciar mitmproxy
├── Comando: mitmproxy --listen-port 8080
├── O que esperar: Interface TUI aguardando conexões
└── Se der errado: Verificar se a porta 8080 está livre

PASSO 2: Configurar navegador para usar proxy
├── Configuração: Proxy → 127.0.0.1:8080 (HTTP e HTTPS)
├── O que esperar: Tráfego passando pelo mitmproxy
└── Se der errado: Verificar se o proxy está rodando com netstat -tlnp

PASSO 3: Instalar certificado CA
├── Comando: Abrir http://mitm.it no navegador via proxy
├── O que esperar: Página para baixar certificado CA
└── Se der errado: Acessar http://mitm.it:8080

PASSO 4: Interceptar requisição
├── Ação: Navegar para qualquer site HTTP
├── O que esperar: Requisições aparecendo no mitmproxy
└── Se der errado: Verificar se o navegador está usando o proxy

PASSO 5: Modificar request
├── Ação: Selecionar request → e (edit) → modificar dados → Enter
├── O que esperar: Request modificado sendo enviado ao servidor
└── Se der errado: Usar Shift+e para editar body

PASSO 6: Script de automação
├── Comando: mitmproxy -s script_interceptar.py
├── O que esperar: Script rodando em cada request/response
└── Se der errado: Criar script simples de print primeiro
```

### Macetes
> **Macete 1:** `mitmweb` abre interface web — mais fácil para iniciantes que o TUI.

> **Macete 2:** `--mode transparent` intercepta sem configuração de proxy no navegador.

> **Macete 3:** `-s script.py` permite automação — modificar headers, logar dados, etc.

> **Macete 4:** Para HTTPS, o certificado CA precisa ser instalado e confiável no SO/navegador.

### Checklist
- [ ] Iniciar mitmproxy e configurar navegador
- [ ] Instalar certificado CA
- [ ] Interceptar e visualizar requisições
- [ ] Modificar um request
- [ ] Criar script básico de automação

### Link para o exercício
https://tryhackme.com/room/dvwa

### Tempo estimado: 35 minutos

---

## Exercício 4: Man-in-the-Middle com bettercap

### Objetivo
Realizar ataque ARP spoofing e interceptar tráfego de outros dispositivos na rede local.

### Conhecimentos Praticados
- ARP spoofing/poisoning
- Sniffing de credenciais
- Man-in-the-Middle (MITM)

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| bettercap | `sudo bettercap -iface eth0` |
| ARP spoof | `set arp.spoof on` |
| Net probe | `net.probe on` |

### Passo a Passo

```
PASSO 1: Iniciar bettercap
├── Comando: sudo bettercap -iface eth0
├── O que esperar: Prompt do bettercap
└── Se der errado: Verificar interface com ip link show

PASSO 2: Descobrir hosts na rede
├── Comando: net.probe on
├── O que esperar: Lista de IPs descobertos na subnet
└── Se der errado: Usar net.show para listar hosts encontrados

PASSO 3: Configurar ARP spoofing
├── Comando: set arp.spoof.fullduplex true
├── O que esperar: Configuração para spoofing em ambas direções
└── Se der errado: Definir alvo específico com set arp.spoof.targets <IP>

PASSO 4: Ativar ARP spoofing
├── Comando: arp.spoof on
├── O que esperar: Pacotes ARP spoofing sendo enviados
└── Se der errado: Verificar se tem permissões root

PASSO 5: Sniff tráfego
├── Comando: net.sniff on
├── O que esperar: Tráfego interceptado sendo exibido
└── Se der errado: Usar net.sniff on com滤波 para reduzir ruído

PASSO 6: Parar ataque
├── Comando: arp.spoof off && net.sniff off
├── O que esperar: Tráfego voltando ao normal
└── Se der errado: Usar arp -a para verificar tabelas ARP
```

### Macetes
> **Macete 1:** `set arp.spoof.fullduplex true` faz spoofing em ambas direções (gateway e alvo).

> **Macete 2:** `net.probe on` descobre hosts automaticamente antes de iniciar spoofing.

> **Macete 3:** `net.sniff on` captura credenciais em texto plano — HTTP, FTP, Telnet.

> **Macete 4:** Use `set arp.spoof.targets <IP>` para limitar o ataque a um alvo específico.

### Checklist
- [ ] Iniciar bettercap e descobrir hosts
- [ ] Configurar e ativar ARP spoofing
- [ ] Capturar tráfego de rede
- [ ] Identificar credenciais em texto plano
- [ ] Parar ataque e restaurar rede

### Link para o exercício
https://tryhackme.com/room/metasploitexploitation

### Tempo estimado: 45 minutos

---

## Exercício 5: Proxychains e Anonimato

### Objetivo
Configurar proxychains para rotear tráfego através de proxies SOCKS/Tor, aumentando o anonimato.

### Conhecimentos Praticados
- Cadeia de proxies
- SOCKS4/SOCKS5
- Roteamento via Tor

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| proxychains | `proxychains comando` |
| tor | `sudo service tor start` |
| config | `/etc/proxychains4.conf` |

### Passo a Passo

```
PASSO 1: Instalar dependências
├── Comando: sudo apt install proxychains tor
├── O que esperar: Pacotes instalados
└── Se der errado: Verificar repositórios com sudo apt update

PASSO 2: Iniciar serviço Tor
├── Comando: sudo service tor start
├── O que esperar: Tor rodando na porta 9050 (SOCKS5)
└── Se der errado: Verificar status com sudo service tor status

PASSO 3: Configurar proxychains
├── Comando: sudo nano /etc/proxychains4.conf
├── O que esperar: Arquivo de configuração aberto
└── Se der errado: Criar arquivo se não existir

PASSO 4: Definir tipo de proxy chain
├── Configuração: Alterar para "strict_chain" ou "dynamic_chain"
├── O que esperar: strict_chain = todos os proxies obrigatórios; dynamic_chain = usa disponíveis
└── Se der errado: dynamic_chain é mais tolerante a falhas

PASSO 5: Adicionar proxy Tor
├── Configuração: Adicionar linha "socks5 127.0.0.1 9050" na seção [ProxyList]
├── O que esperar: Proxy Tor configurado
└── Se der errado: Verificar se Tor está rodando na porta 9050

PASSO 6: Testar anonimato
├── Comando: proxychains curl ifconfig.me
├── O que esperar: IP diferente do seu IP real (IP do Tor)
└── Se der errado: Verificar se Tor está ativo e proxychains configurado
```

### Macetes
> **Macete 1:** `strict_chain` é mais seguro mas falha se um proxy cair — use `dynamic_chain` para tolerância.

> **Macete 2:** Adicione proxies SOCKS5 extras na seção [ProxyList] para cadeia mais longa.

> **Macete 3:** `proxychains nmap -sT -Pn alvo` roda scan via proxy (apenas TCP connect scan).

> **Macete 4:** Verifique seu IP com `proxychains curl ifconfig.me` para confirmar anonimato.

### Checklist
- [ ] Instalar e configurar Tor
- [ ] Configurar proxychains com SOCKS5
- [ ] Testar anonimato com curl
- [ ] Rodar ferramentas via proxychains

### Link para o exercício
https://tryhackme.com/room/dvwa

### Tempo estimado: 25 minutos

---

## Exercício 6: Análise Completa de Tráfego (Desafio Final)

### Objetivo
Capturar, analisar e extrair dados de tráfego de rede usando todas as ferramentas do módulo, simulando análise forense.

### Conhecimentos Praticados
- Todas as técnicas do módulo
- Análise forense de rede
- Extração de arquivos e dados

### Ferramentas
| Ferramenta | Comando/Uso |
|:-----------|:------------|
| tcpdump | Captura de pacotes |
| Wireshark | Análise visual |
| tshark | Análise via CLI |

### Passo a Passo

```
PASSO 1: Capturar tráfego da rede local
├── Comando: sudo tcpdump -i eth0 -w analise_completa.pcap -c 10000
├── O que esperar: 10000 pacotes capturados em arquivo
└── Se der errado: Reduzir para 1000 pacotes com -c 1000

PASSO 2: Abrir no Wireshark e filtrar HTTP
├── Comando: Wireshark → Filtro: "http"
├── O que esperar: Requisições e respostas HTTP
└── Se der errado: Usar "tcp.port==80" se http não funcionar

PASSO 3: Extrair arquivos HTTP
├── Comando (Wireshark): File → Export Objects → HTTP
├── O que esperar: Lista de arquivos transferidos via HTTP
└── Se der errado: Verificar se há uploads/downloads no tráfego

PASSO 4: Analisar com tshark para credenciais
├── Comando: tshark -r analise_completa.pcap -Y "http.request.method==POST" -T fields -e http.host -e http.request.uri -e http.file_data
├── O que esperar: Dados POST extraídos (podem conter senhas)
└── Se der errado: Usar -Y "http" para ver todo o tráfego HTTP

PASSO 5: Filtrar por IP suspeito
├── Comando: tshark -r analise_completa.pcap -Y "ip.addr==<IP_SUSPEITO>" -T fields -e frame.protocols -e _ws.col.Info
├── O que esperar: Tráfego relacionado ao IP suspeito
└── Se der errado: Descobrir IP suspeito analisando primeiro os pacotes

PASSO 6: Gerar relatório
├── Comando: Criar documento com IP, portas, protocolos, dados extraídos
├── O que esperar: Relatório completo da análise forense
└── Se der errado: Usar tshark com -T fields para exportar dados brutos
```

### Macetes
> **Macete 1:** Comece filtrando por HTTP para encontrar dados interesting rapidamente.

> **Macete 2:** "Export Objects → HTTP" no Wireshark extrai todos os arquivos automaticamente.

> **Macete 3:** `tshark` com `-T fields` permite extrair campos específicos para análise automatizada.

> **Macete 4:** Analise POST requests — é onde ficam credenciais e dados sensíveis.

### Checklist
- [ ] Capturar tráfego extenso
- [ ] Analisar e filtrar HTTP
- [ ] Extrair arquivos de uploads
- [ ] Identificar credenciais em POST
- [ ] Documentar findings

### Link para o exercício
https://tryhackme.com/room/cent

### Tempo estimado: 60 minutos

---

## Desafio Final

Após completar todos os exercícios, tente resolver o desafio **https://tryhackme.com/room/cent** usando tcpdump, Wireshark e tshark. Seu objetivo:

1. Capturar tráfego da máquina atacante
2. Encontrar credenciais no tráfego HTTP
3. Extrair arquivos enviados via POST
4. Identificar IP do atacante
5. Documentar todo o processo

---

## Progresso

| Exercício | Concluído | Notas |
|:----------|:---------:|:------|
| 1 - Captura com tcpdump | ⬜ | |
| 2 - Análise com Wireshark | ⬜ | |
| 3 - Interceptação com mitmproxy | ⬜ | |
| 4 - MITM com bettercap | ⬜ | |
| 5 - Proxychains e Anonimato | ⬜ | |
| 6 - Análise Completa | ⬜ | |
