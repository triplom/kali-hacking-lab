#!/usr/bin/env bash
# =============================================================================
# kali-attacker.sh — Launch a Kali attacker container connected to the lab
# =============================================================================
# This drops you into an interactive Kali shell with all tools pre-installed,
# connected to the same lab network so you can attack the vulnerable containers.
#
# Usage:
#   ./kali-attacker.sh               # Interactive shell
#   ./kali-attacker.sh "nmap -sV 10.10.0.10"   # Run single command
# =============================================================================

LAB_NETWORK="labs_lab-net"
CMD="${1:-/bin/bash}"

echo "[*] Launching Kali attacker container on $LAB_NETWORK ..."
echo "[*] Lab targets available at 10.10.0.0/24"
echo "[*] Type 'exit' to leave the container."
echo ""

docker run -it --rm \
  --name kali-attacker \
  --network "$LAB_NETWORK" \
  --hostname attacker \
  -v "$(pwd)/../:/mnt/host" \
  -v /usr/share/wordlists:/wordlists:ro \
  kalilinux/kali-rolling \
  bash -c "
    apt-get update -qq > /dev/null 2>&1
    apt-get install -y -qq \
      nmap nikto sqlmap hydra john hashcat \
      gobuster dirb wfuzz curl wget git \
      netcat-traditional tcpdump dnsutils \
      python3 python3-pip > /dev/null 2>&1
    echo '========================================'
    echo '  Kali Attacker Ready'
    echo '========================================'
    echo 'Lab targets:'
    echo '  10.10.0.10  - DVWA          (web)'
    echo '  10.10.0.12  - WebGoat       (web)'
    echo '  10.10.0.13  - Juice Shop    (web)'
    echo '  10.10.0.14  - Mutillidae    (web)'
    echo '  10.10.0.15  - WordPress     (web)'
    echo '  10.10.0.20  - Metasploitable3 (network)'
    echo '  10.10.0.21  - SSH server    (brute-force)'
    echo '  10.10.0.22  - FTP server    (ftp)'
    echo '  10.10.0.23  - Vulnerable API (api)'
    echo '========================================'
    echo 'Host files mounted at: /mnt/host'
    echo 'Wordlists at: /wordlists'
    echo ''
    $CMD
  "
