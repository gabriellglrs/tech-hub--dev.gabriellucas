# Cheatsheet: Defesa e Forense

## Lynis (Hardening)
```bash
lynis audit system
lynis audit system --quick
```

## UFW (Firewall)
```bash
sudo ufw enable
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw status verbose
```

## Suricata (IDS)
```bash
sudo suricata -c /etc/suricata/suricata.yaml -i eth0
suricata-update
suricata-update list-sources
```

## Wazuh (SIEM)
```bash
sudo /var/ossec/bin/ossec-control start
sudo /var/ossec/bin/agent-auth -M agent-name -I agent-ip
```

## Wireshark (Filtros)
```
ip.addr == IP
tcp.port == 80
http.request.method == "POST"
dns.qry.name contains "target"
frame.len > 1000
```

## TCPDump
```bash
sudo tcpdump -i eth0 -nn
sudo tcpdump -i eth0 port 80
sudo tcpdump -i eth0 -w capture.pcap
sudo tcpdump -r capture.pcap -A
```

## Forense
```bash
# Disco
sudo dd if=/dev/sda of=disk.img bs=4M
fls -r disk.img
icat disk.img inode

# Memória
volatility -f mem.raw imageinfo
volatility -f mem.raw --profile=Win7SP1x64 pslist
volatility -f mem.raw --profile=Win7SP1x64 filescan

# Malware
yara -r rules/ suspicious_file
ssdeep suspicious_file
```