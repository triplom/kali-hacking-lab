#!/usr/bin/env bash
# =============================================================================
# setup-wordlists.sh — Ensure wordlists are available for lab attacks
# =============================================================================

echo "[*] Checking wordlists..."

# Install wordlists package on Kali if not present
if [ ! -f /usr/share/wordlists/rockyou.txt ]; then
  echo "[*] Installing wordlists package..."
  echo "marques" | sudo -S apt-get install -y wordlists 2>/dev/null
  echo "[*] Extracting rockyou.txt..."
  echo "marques" | sudo -S gunzip -k /usr/share/wordlists/rockyou.txt.gz 2>/dev/null || true
fi

if [ -f /usr/share/wordlists/rockyou.txt ]; then
  echo "[+] rockyou.txt available: $(wc -l < /usr/share/wordlists/rockyou.txt) entries"
else
  echo "[!] rockyou.txt not found. Download manually:"
  echo "    sudo apt install wordlists && sudo gunzip /usr/share/wordlists/rockyou.txt.gz"
fi

# Check dirbuster wordlists
if [ -d /usr/share/wordlists/dirbuster ]; then
  echo "[+] Dirbuster wordlists available"
else
  echo "[!] Install with: sudo apt install dirbuster"
fi

# Check SecLists
if [ -d /usr/share/seclists ]; then
  echo "[+] SecLists available"
else
  echo "[!] SecLists not found. Install with: sudo apt install seclists"
fi

echo ""
echo "[*] Wordlist summary:"
ls -lh /usr/share/wordlists/ 2>/dev/null || echo "    /usr/share/wordlists not found"
