# hping3 Cheatsheet

> **Legal Notice:** Use hping3 only on systems you own or have explicit written permission to test.

hping3 is a raw packet crafting and sending tool. It gives you full control over TCP/UDP/ICMP/RAW IP packets — essential for firewall testing, OS fingerprinting, and understanding how protocols work at the packet level.

---

## Installation

```bash
sudo apt install hping3   # pre-installed on Kali
```

## Basic Syntax

```bash
hping3 [options] target
```

---

## TCP Packet Crafting

```bash
# Default: TCP SYN to port 0
hping3 10.10.0.25

# TCP SYN to specific port (stealth scan — like nmap -sS)
hping3 -S -p 80 10.10.0.25

# TCP ACK scan (bypass stateless firewalls)
hping3 -A -p 80 10.10.0.25

# TCP FIN scan
hping3 -F -p 80 10.10.0.25

# TCP RST
hping3 -R -p 80 10.10.0.25

# TCP PUSH
hping3 -P -p 80 10.10.0.25

# TCP URG
hping3 -U -p 80 10.10.0.25

# Null scan (no flags)
hping3 -p 80 10.10.0.25    # --tcp flag = none by default

# XMAS scan (FIN+PUSH+URG)
hping3 -F -P -U -p 80 10.10.0.25

# Set custom window size
hping3 -S -p 80 --win 65535 10.10.0.25

# TCP with custom TTL
hping3 -S -p 80 --ttl 128 10.10.0.25

# TCP with custom MSS
hping3 -S -p 80 --tcpopt-mss 1460 10.10.0.25
```

---

## UDP Packets

```bash
# UDP to port 53 (DNS)
hping3 --udp -p 53 10.10.0.25

# UDP to port 161 (SNMP)
hping3 --udp -p 161 10.10.0.25

# UDP with data payload
hping3 --udp -p 53 -d 20 10.10.0.25
```

---

## ICMP Packets

```bash
# ICMP ping (like standard ping)
hping3 --icmp 10.10.0.25

# ICMP with custom payload size
hping3 --icmp -d 120 10.10.0.25

# ICMP flood (DoS test — lab only)
hping3 --icmp --flood 10.10.0.25
```

---

## Port Scanning

```bash
# Scan a port range (increments dest port each packet)
hping3 -S --scan 1-1024 10.10.0.25

# Scan specific ports
hping3 -S --scan 22,80,443,8080,8443 10.10.0.25

# Scan all 65535 ports
hping3 -S --scan 0-65535 10.10.0.25

# Scan with faster timing
hping3 -S --scan 1-1024 --faster 10.10.0.25
```

---

## Firewall Testing

```bash
# Check if port is open, closed, or filtered
# SYN/ACK reply = open
# RST reply = closed
# No reply = filtered (firewall dropping)
# ICMP unreachable = filtered (firewall rejecting)

hping3 -S -p 22 10.10.0.25   # SYN to SSH
hping3 -A -p 22 10.10.0.25   # ACK to SSH (different behavior = stateful FW)

# Firewall rule testing — can you bypass with fragmented packets?
hping3 -S -p 80 -f 10.10.0.25          # fragment packets

# Source port manipulation (bypass FW rules allowing DNS responses)
hping3 -S -p 80 --baseport 53 10.10.0.25

# Change source IP (spoofing — only works if you don't need a response)
hping3 -S -p 80 -a 1.2.3.4 10.10.0.25
```

---

## OS Fingerprinting

```bash
# Analyze TTL and TCP window size to guess OS:
# Windows: TTL=128, Window=65535
# Linux:   TTL=64, Window=5840 or 29200
# macOS:   TTL=64, Window=65535
# Cisco:   TTL=255

hping3 -S -p 80 --tcp-timestamp 10.10.0.25
# Look at: ip->ttl, tcp->win, tcp->ts fields in output
```

---

## Traceroute

```bash
# ICMP traceroute
hping3 --traceroute -V -1 10.10.0.25

# TCP traceroute to port 80 (bypass ICMP filters)
hping3 --traceroute -S -p 80 10.10.0.25

# UDP traceroute
hping3 --traceroute --udp -p 53 10.10.0.25
```

---

## Data Payload

```bash
# Set payload size
hping3 -S -p 80 -d 100 10.10.0.25

# Set payload from file
hping3 -S -p 80 --file /tmp/payload.txt 10.10.0.25

# Set payload as string
hping3 -S -p 80 -E /dev/urandom -d 100 10.10.0.25
```

---

## Flood / DoS (Lab Only!)

```bash
# TCP SYN flood to port 80
hping3 --flood -S -p 80 10.10.0.25

# ICMP flood
hping3 --flood --icmp 10.10.0.25

# UDP flood
hping3 --flood --udp -p 53 10.10.0.25

# Flood with random source IPs
hping3 --flood -S -p 80 --rand-source 10.10.0.25
```

---

## Packet Count & Timing

```bash
# Send exactly N packets then stop
hping3 -S -p 80 -c 5 10.10.0.25

# Set interval between packets (microseconds)
hping3 -S -p 80 -i u100 10.10.0.25   # 100 microseconds
hping3 -S -p 80 -i 1 10.10.0.25      # 1 second

# Faster mode (don't wait for responses)
hping3 -S -p 80 --faster 10.10.0.25
```

---

## Source Address Options

```bash
# Custom source port (useful for firewall bypass)
hping3 -S -p 80 --baseport 1234 10.10.0.25

# Increment source port each packet
hping3 -S -p 80 --keep 10.10.0.25

# Spoof source IP (response won't reach you)
hping3 -S -p 80 -a 192.168.1.100 10.10.0.25

# Random source IP
hping3 -S -p 80 --rand-source 10.10.0.25

# Specify source interface
hping3 -S -p 80 -I eth0 10.10.0.25
```

---

## Output & Verbosity

```bash
# Verbose output
hping3 -S -p 80 -V 10.10.0.25

# Quiet mode (only summary)
hping3 -S -p 80 -q 10.10.0.25

# Show hex dump of packets
hping3 -S -p 80 -x 10.10.0.25
```

---

## Common Flag Reference

| Short | Long | Description |
|-------|------|-------------|
| `-S` | `--syn` | Set SYN flag |
| `-A` | `--ack` | Set ACK flag |
| `-F` | `--fin` | Set FIN flag |
| `-R` | `--rst` | Set RST flag |
| `-P` | `--push` | Set PUSH flag |
| `-U` | `--urg` | Set URG flag |
| `-p` | `--destport` | Destination port |
| `--baseport` | | Source port |
| `-1` | `--icmp` | ICMP mode |
| `--udp` | | UDP mode |
| `-d` | `--data` | Data payload size |
| `-c` | `--count` | Packet count |
| `-i` | `--interval` | Interval between packets |
| `-I` | `--interface` | Network interface |
| `-a` | `--spoof` | Source address |
| `--rand-source` | | Random source IP |
| `-f` | `--frag` | Fragment packets |
| `-x` | `--hexdump` | Hex dump |
| `-V` | `--verbose` | Verbose |
| `-q` | `--quiet` | Quiet |
| `--flood` | | Flood mode |
| `--faster` | | Don't wait for replies |
| `--traceroute` | | Traceroute mode |
| `--scan` | | Port scan mode |
| `--ttl` | | Set TTL |
| `--win` | | Set TCP window size |

---

## Lab Exercises (Metasploitable 2 at 10.10.0.25)

```bash
# 1. Compare hping3 vs Nmap SYN scan
nmap -sS -p 22,80,443 10.10.0.25
hping3 -S -p 22 -c 3 10.10.0.25
hping3 -S -p 80 -c 3 10.10.0.25

# 2. Identify firewall behavior
hping3 -S -p 12345 10.10.0.25   # closed port → RST
hping3 -A -p 80 10.10.0.25      # ACK to open port → RST (stateless)

# 3. Port range scan
hping3 -S --scan 20-25 10.10.0.25   # scan FTP/SSH ports

# 4. Traceroute to target
hping3 --traceroute -V -1 10.10.0.25
```

---

## Resources

- [InfoSecLab hping3 Guide](https://pontocom.gitbook.io/infoseclab/vulntesting/hping3)
- [hping3 Man Page](https://linux.die.net/man/8/hping3)
- [hping3 GitHub](https://github.com/antirez/hping)
