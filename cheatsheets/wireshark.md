# Wireshark Cheatsheet

> Quick reference for Wireshark packet analysis.

```bash
# ──────────────────────────────────────────────
# LAUNCH
# ──────────────────────────────────────────────
wireshark                    # GUI
wireshark -i eth0 -k         # Capture immediately on eth0
tshark -i eth0               # CLI version
tshark -r capture.pcap       # Read pcap file

# ──────────────────────────────────────────────
# DISPLAY FILTERS (applied to captured traffic)
# ──────────────────────────────────────────────

# Protocol
http
https
ftp
ssh
dns
arp
icmp
tcp
udp
smtp
smb
eapol           # WPA handshake

# IP address
ip.addr == 192.168.1.10
ip.src == 192.168.1.10
ip.dst == 192.168.1.10
ip.addr == 192.168.1.0/24   # Subnet

# Port
tcp.port == 80
tcp.dstport == 443
tcp.srcport == 22
udp.port == 53

# HTTP
http.request.method == "POST"
http.request.method == "GET"
http.response.code == 200
http.response.code == 404
http.host == "example.com"
http.request.uri contains "login"
http.cookie

# Search content
frame contains "password"
frame contains "admin"
http contains "SELECT"

# TCP flags
tcp.flags.syn == 1
tcp.flags.reset == 1
tcp.analysis.retransmission

# Combined
http and ip.src == 192.168.1.10
(http or ftp) and ip.addr == 192.168.1.10
not arp and not icmp

# ──────────────────────────────────────────────
# CAPTURE FILTERS (set before starting capture)
# ──────────────────────────────────────────────
port 80                 # HTTP only
host 192.168.1.10       # Traffic to/from host
net 192.168.1.0/24      # Subnet only
not port 22             # Exclude SSH
tcp                     # TCP only
udp port 53             # DNS only

# ──────────────────────────────────────────────
# USEFUL ACTIONS
# ──────────────────────────────────────────────
# Follow TCP stream:
#   Right-click packet > Follow > TCP Stream

# Export HTTP objects (files):
#   File > Export Objects > HTTP

# Decrypt TLS (if you have the key):
#   Edit > Preferences > Protocols > TLS > RSA Keys

# IO Graph:
#   Statistics > I/O Graph

# Protocol hierarchy:
#   Statistics > Protocol Hierarchy

# Conversations:
#   Statistics > Conversations

# ──────────────────────────────────────────────
# TSHARK (CLI)
# ──────────────────────────────────────────────
tshark -i eth0 -w capture.pcap          # Capture to file
tshark -r capture.pcap                  # Read pcap
tshark -r capture.pcap -Y http          # Filter while reading
tshark -r capture.pcap -T fields -e http.request.uri   # Extract URIs
tshark -r capture.pcap -T fields -e http.file_data -Y "http.request.method==POST"
tshark -r capture.pcap -q -z io,phs    # Protocol hierarchy stats
```
