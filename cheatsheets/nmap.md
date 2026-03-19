# Nmap Cheatsheet

> Quick reference for the most common Nmap commands.

```bash
# ──────────────────────────────────────────────
# SCAN TYPES
# ──────────────────────────────────────────────
nmap -sS target      # SYN scan (stealth, default with root)
nmap -sT target      # TCP connect scan (no root needed)
nmap -sU target      # UDP scan
nmap -sN target      # NULL scan (no flags)
nmap -sF target      # FIN scan
nmap -sX target      # Xmas scan
nmap -sA target      # ACK scan (firewall detection)
nmap -sn target      # Ping scan only (no port scan)

# ──────────────────────────────────────────────
# PORT SPECIFICATION
# ──────────────────────────────────────────────
nmap -p 80 target           # Single port
nmap -p 22,80,443 target    # Multiple ports
nmap -p 1-1000 target       # Port range
nmap -p- target             # All 65535 ports
nmap --top-ports 100 target # Top 100 most common

# ──────────────────────────────────────────────
# DETECTION
# ──────────────────────────────────────────────
nmap -sV target      # Service/version detection
nmap -O target       # OS detection
nmap -A target       # Aggressive: OS + version + scripts + traceroute
nmap -sC target      # Default scripts

# ──────────────────────────────────────────────
# SCRIPTS
# ──────────────────────────────────────────────
nmap --script vuln target           # Vulnerability scan
nmap --script safe target           # Safe scripts
nmap --script "http-*" target       # All HTTP scripts
nmap --script=banner target         # Banner grab
nmap --script smb-vuln-ms17-010 target  # EternalBlue check

# ──────────────────────────────────────────────
# SPEED (T1=paranoid ... T5=insane)
# ──────────────────────────────────────────────
nmap -T1 target   # Very slow, stealthy
nmap -T3 target   # Default
nmap -T4 target   # Faster (recommended for CTFs)
nmap -T5 target   # Fastest, unreliable on slow networks

# ──────────────────────────────────────────────
# OUTPUT
# ──────────────────────────────────────────────
nmap -oN out.txt target   # Normal text
nmap -oX out.xml target   # XML
nmap -oG out.gnmap target # Grepable
nmap -oA out target       # All formats

# ──────────────────────────────────────────────
# MISC
# ──────────────────────────────────────────────
nmap -v target           # Verbose
nmap -vv target          # More verbose
nmap -n target           # No DNS resolution (faster)
nmap -Pn target          # Skip host discovery (treat as up)
nmap -f target           # Fragment packets (evade IDS)
nmap --open target       # Show only open ports
nmap -D RND:10 target    # Decoy scan
```
