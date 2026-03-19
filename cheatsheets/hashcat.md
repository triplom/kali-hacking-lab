# Hashcat Cheatsheet

> Quick reference for Hashcat password cracking.

```bash
# ──────────────────────────────────────────────
# ATTACK MODES (-a)
# ──────────────────────────────────────────────
-a 0    # Dictionary (wordlist)
-a 1    # Combination (two wordlists)
-a 3    # Brute-force / Mask
-a 6    # Hybrid wordlist + mask
-a 7    # Hybrid mask + wordlist

# ──────────────────────────────────────────────
# COMMON HASH TYPES (-m)
# ──────────────────────────────────────────────
-m 0      # MD5
-m 100    # SHA1
-m 1400   # SHA256
-m 1700   # SHA512
-m 3200   # bcrypt
-m 1000   # NTLM (Windows)
-m 5600   # NetNTLMv2
-m 22000  # WPA2 (handshake)
-m 1800   # Linux sha512crypt ($6$)
-m 500    # md5crypt ($1$)
-m 7400   # sha256crypt ($5$)

# ──────────────────────────────────────────────
# MASK CHARSETS
# ──────────────────────────────────────────────
?l = lowercase (a-z)
?u = uppercase (A-Z)
?d = digits (0-9)
?s = special (!@#$...)
?a = all of the above
?b = 0x00-0xff

# ──────────────────────────────────────────────
# EXAMPLES
# ──────────────────────────────────────────────

# Dictionary attack
hashcat -a 0 -m 0 hashes.txt rockyou.txt

# Dictionary + rules
hashcat -a 0 -m 0 hashes.txt rockyou.txt -r /usr/share/hashcat/rules/best64.rule

# Brute force 6-char lowercase
hashcat -a 3 -m 0 hashes.txt ?l?l?l?l?l?l

# 8-char: upper + lower + digit
hashcat -a 3 -m 0 hashes.txt ?u?l?l?l?l?d?d?d

# Combination attack
hashcat -a 1 -m 0 hashes.txt wordlist1.txt wordlist2.txt

# Crack WPA2 handshake
hashcat -a 0 -m 22000 handshake.hccapx rockyou.txt

# Crack NTLM
hashcat -a 0 -m 1000 ntlm_hashes.txt rockyou.txt

# ──────────────────────────────────────────────
# USEFUL FLAGS
# ──────────────────────────────────────────────
--show                  # Show cracked passwords
--username              # Hash file includes usernames
-o cracked.txt          # Output to file
--potfile-disable       # Don't use .potfile cache
--increment             # Increment mask length
--increment-min 6       # Start mask at 6 chars
--increment-max 8       # Stop mask at 8 chars
-O                      # Optimized kernels (faster, limits length)
-w 3                    # Workload: 1=low, 4=nightmare

# ──────────────────────────────────────────────
# IDENTIFY HASH TYPE FIRST
# ──────────────────────────────────────────────
hash-identifier           # Interactive
hashid 'hash_here'        # CLI
hashid -m 'hash_here'     # Also show hashcat mode number
```
