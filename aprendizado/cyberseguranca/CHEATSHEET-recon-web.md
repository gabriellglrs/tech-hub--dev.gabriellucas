# Cheatsheet: Reconhecimento e Web Testing

## Nmap
```bash
nmap -sV -sC IP           # Scan básico
nmap -A -p- -T4 IP        # Scan agressivo
nmap -sS -T4 -Pn IP       # Stealth scan
nmap --script=http-enum -p 80,443 IP  # Web enum
nmap --script=smb-enum-shares -p 445 IP  # SMB enum
```

## Whois / Dig
```bash
whois domain.com
dig domain.com A/MX/NS/TXT
dig +short domain.com
dig axfr domain.com @ns1  # Zone transfer
```

## Gobuster
```bash
gobuster dir -u http://IP -w wordlist.txt
gobuster dir -u http://IP -w wordlist.txt -x php,html,txt -t 50
gobuster dns -d domain.com -w wordlist.txt
```

## FFUF
```bash
ffuf -u http://IP/FUZZ -w wordlist.txt
ffuf -u http://IP/FUZZ -w wordlist.txt -fs 4242  # Filtrar tamanho
ffuf -u "http://IP/page?id=FUZZ" -w param.txt   # Parâmetros
```

## SQLMap
```bash
sqlmap -u "http://IP/page?id=1" --batch
sqlmap -u "http://IP/page?id=1" --dbs --batch
sqlmap -u "http://IP/page?id=1" -D db --tables --batch
sqlmap -u "http://IP/page?id=1" --os-shell --batch
```

## Nikto
```bash
nikto -h http://IP
nikto -h http://IP -p 8080
nikto -h http://IP -o report.html -Format htm
```

## WhatWeb / WAFw00f
```bash
whatweb http://IP
wafw00f http://IP
```