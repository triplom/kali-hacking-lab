# Girus Warm-Up Exercises — Kali Hacking Lab

Build Linux and Docker fluency before running the hacking lab. These exercises run inside Girus, your local interactive lab platform, and cover the foundational skills assumed throughout the study plan.

> **Girus cluster must be running.** Check with `girus list clusters`. If not running: `girus create cluster`.
> Open the UI at `http://localhost:8000` or launch exercises directly from the CLI.

---

## Exercise Index

| ID | Girus Lab | Topic | Maps To |
|----|-----------|-------|---------|
| WU-1 | `linux-comandos-basicos` | CLI fluency, pipes, redirection | Week 0 prerequisites |
| WU-2 | `linux-permissoes-arquivos` | chmod, SUID/SGID, ACLs | Week 0, security context |
| WU-3 | `linux-gerenciamento-processos` | ps, kill, signals, background jobs | Week 0, process control |
| WU-4 | `linux-monitoramento-sistema` | ss, netstat, journalctl | Month 1 recon prereqs |
| WU-5 | `docker-fundamentos` | docker run, ps, stop, rm | Docker lab setup |
| WU-6 | `docker-gerenciamento-containers` | exec, logs, inspect | Managing lab containers |

---

## WU-1 — Linux CLI Fluency

**Girus lab:** `linux-comandos-basicos`

```bash
girus lab start linux-comandos-basicos
```

### Why this matters
The hacking lab depends entirely on the terminal — piping nmap output into files, grepping logs, redirecting tool output. Slow CLI = slow hacking.

### Steps

**1. Navigate and list files**
```bash
ls -la /etc
ls -la /var/log
```
_Expected:_ Long listing with permissions, owner, size, and date columns. `/var/log` contains log files like `auth.log`, `syslog`.

**2. Read files**
```bash
cat /etc/passwd
head -5 /etc/passwd
tail -5 /etc/passwd
```
_Expected:_ `head` shows first 5 lines (root, daemon, bin…); `tail` shows the last 5 system/service accounts.

**3. Pipe and filter**
```bash
cat /etc/passwd | grep bash
cat /etc/passwd | cut -d: -f1
```
_Expected:_ `grep bash` shows only users with `/bin/bash` as shell. `cut -d: -f1` extracts just usernames.

**4. Redirect output**
```bash
ls /etc > /tmp/etc_list.txt
cat /tmp/etc_list.txt | wc -l
```
_Expected:_ File created; `wc -l` returns a count of lines (typically 150–200+ on a full system).

**5. Find files**
```bash
find /etc -name "*.conf" 2>/dev/null
find / -name "passwd" 2>/dev/null
```
_Expected:_ List of `.conf` files under `/etc`. The `2>/dev/null` suppresses permission errors.

**6. Search inside files**
```bash
grep -r "root" /etc/passwd
grep -rn "error" /var/log/syslog 2>/dev/null | head -20
```
_Expected:_ Lines containing "root" from `/etc/passwd`. `-n` adds line numbers.

### Validation checklist
- [ ] `ls -la` output shows permissions in `-rwxr-xr-x` format
- [ ] `cat /etc/passwd | grep bash` returns at least one line (root or a user)
- [ ] `/tmp/etc_list.txt` exists and `wc -l` returns > 0
- [ ] `find /etc -name "*.conf"` returns multiple results

---

## WU-2 — File Permissions and SUID/SGID

**Girus lab:** `linux-permissoes-arquivos`

```bash
girus lab start linux-permissoes-arquivos
```

### Why this matters
SUID/SGID bits are common privilege escalation vectors. You need to read permission strings and understand what attackers look for — and why DVWA's PHP files having wrong permissions causes issues.

### Steps

**1. Read permission strings**
```bash
ls -la /bin/passwd
ls -la /tmp
ls -la /etc/shadow
```
_Expected:_
```
-rwsr-xr-x 1 root root ... /bin/passwd   ← SUID set (s in owner execute)
drwxrwxrwt ... /tmp                       ← sticky bit (t)
-rw-r----- 1 root shadow ... /etc/shadow  ← only root + shadow group
```

**2. Change permissions with chmod**
```bash
mkdir /tmp/testdir
touch /tmp/testdir/file.txt
chmod 755 /tmp/testdir
chmod 644 /tmp/testdir/file.txt
ls -la /tmp/testdir/
```
_Expected:_ `drwxr-xr-x` for directory, `-rw-r--r--` for file.

**3. Find SUID binaries (attacker technique)**
```bash
find / -perm -4000 -type f 2>/dev/null
```
_Expected:_ List of SUID binaries such as `/usr/bin/sudo`, `/bin/su`, `/usr/bin/passwd`. Any unexpected SUID binary is a privilege escalation candidate.

**4. Find world-writable files**
```bash
find / -perm -o+w -type f 2>/dev/null | grep -v proc | head -20
```
_Expected:_ Files writable by any user. On a hardened system this should be minimal. On Metasploitable2 this list is long — a sign of poor hardening.

**5. Change file ownership**
```bash
touch /tmp/owned.txt
# (as root or with sudo)
chown root:root /tmp/owned.txt
ls -la /tmp/owned.txt
```
_Expected:_ Owner shows as `root root`.

### Validation checklist
- [ ] `ls -la /bin/passwd` shows `s` in owner execute position (SUID)
- [ ] `chmod 755` applied correctly — directory shows `drwxr-xr-x`
- [ ] `find / -perm -4000` returns `/usr/bin/sudo` or similar known SUID binaries
- [ ] World-writable file search completes (may take a moment)

---

## WU-3 — Process Management

**Girus lab:** `linux-gerenciamento-processos`

```bash
girus lab start linux-gerenciamento-processos
```

### Why this matters
During exploitation, you'll run tools in the background, kill stalled processes, and check what's running on the target. Post-exploitation also requires process awareness.

### Steps

**1. List running processes**
```bash
ps aux
ps aux | grep apache
ps aux | grep sshd
```
_Expected:_ Full process table. Filtered results show running web server or SSH daemon with PID, CPU%, MEM%, command.

**2. Process tree**
```bash
pstree -p
```
_Expected:_ Tree of processes with PIDs. Shows parent-child relationships.

**3. Run a process in background**
```bash
sleep 300 &
jobs
```
_Expected:_
```
[1] 12345
[1]+  Running   sleep 300 &
```

**4. Bring to foreground and kill**
```bash
fg 1
# Ctrl+C to stop
# Or:
kill 12345
```
_Expected:_ Process terminates. `ps aux | grep sleep` returns nothing.

**5. Send signals**
```bash
sleep 600 &
kill -SIGSTOP %1   # pause
jobs               # shows Stopped
kill -SIGCONT %1   # resume
jobs               # shows Running
kill -9 %1         # force kill
```
_Expected:_ Process moves between Running and Stopped states, then disappears after SIGKILL.

**6. Real-time process monitor**
```bash
top
# Press q to quit
# Press k, enter PID to kill from within top
```
_Expected:_ Live table sorted by CPU, auto-refreshing every 3 seconds.

### Validation checklist
- [ ] `ps aux` shows at least 10 processes
- [ ] `sleep 300 &` creates a background job visible in `jobs`
- [ ] `kill -SIGSTOP` pauses the job (status changes to `Stopped`)
- [ ] `kill -9` removes the process from `ps aux` output

---

## WU-4 — System Monitoring (Network Recon Prereqs)

**Girus lab:** `linux-monitoramento-sistema`

```bash
girus lab start linux-monitoramento-sistema
```

### Why this matters
Before you run nmap against the lab, you need to understand what "open ports" and "listening services" look like from the inside. This also helps you read Metasploitable2's service list correctly.

### Steps

**1. List open ports (attacker view from inside target)**
```bash
ss -tlnp
netstat -tlnp
```
_Expected:_
```
State    Recv-Q  Send-Q  Local Address:Port  Peer Address:Port  Process
LISTEN   0       128     0.0.0.0:22          0.0.0.0:*          sshd
LISTEN   0       128     0.0.0.0:80          0.0.0.0:*          apache2
```
`ss` is the modern replacement for `netstat`. Both show TCP listening ports.

**2. Show all connections (including UDP)**
```bash
ss -aulnp
```
_Expected:_ UDP sockets such as DNS (port 53) and DHCP clients.

**3. Check disk usage**
```bash
df -h
du -sh /var/log
```
_Expected:_ `df -h` shows filesystem usage in human-readable form. Useful for checking if a target's disk is nearly full (a sign of log flooding or a canary).

**4. Check memory**
```bash
free -h
cat /proc/meminfo | head -10
```
_Expected:_ `free -h` shows total/used/free RAM and swap in MB/GB.

**5. Read system logs**
```bash
journalctl -n 50
journalctl -u ssh
journalctl --since "1 hour ago"
```
_Expected:_ Recent system log entries. SSH-specific entries show login attempts. Useful post-exploitation: check if your connection appears in logs.

**6. Monitor live log entries**
```bash
tail -f /var/log/auth.log &
ssh localhost  # generate an auth event
# Wait 2s, then kill the tail job
kill %1
```
_Expected:_ Live auth.log shows new SSH connection attempt in real time.

### Validation checklist
- [ ] `ss -tlnp` shows at least one LISTEN entry
- [ ] `df -h` shows at least one mounted filesystem with usage %
- [ ] `journalctl -n 50` returns 50 log lines without errors
- [ ] `tail -f /var/log/auth.log` captures a live log event

---

## WU-5 — Docker Fundamentals

**Girus lab:** `docker-fundamentos`

```bash
girus lab start docker-fundamentos
```

### Why this matters
The entire hacking lab runs in Docker. You must be able to start, stop, inspect, and troubleshoot containers to manage your targets.

### Steps

**1. Pull and run a container**
```bash
docker run hello-world
docker run -d --name webtest -p 8888:80 nginx
```
_Expected:_ `hello-world` prints a success message. `nginx` starts detached, port 8888 on host maps to 80 in container.

**2. List running containers**
```bash
docker ps
docker ps -a   # includes stopped containers
```
_Expected:_
```
CONTAINER ID   IMAGE    COMMAND              CREATED        STATUS        PORTS                  NAMES
a1b2c3d4e5f6   nginx    "/docker-entrypoint…"  2 minutes ago  Up 2 minutes  0.0.0.0:8888->80/tcp   webtest
```

**3. Stop and remove**
```bash
docker stop webtest
docker rm webtest
docker ps -a   # webtest should be gone
```
_Expected:_ `docker stop` prints the container name. `docker ps -a` no longer shows `webtest`.

**4. Run with environment variables**
```bash
docker run -d --name dbtest \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=testdb \
  mysql:5.7
docker ps
```
_Expected:_ `dbtest` shows as Up. Env vars are passed into the container.

**5. Docker images**
```bash
docker images
docker image rm hello-world
docker images  # hello-world gone
```
_Expected:_ Image list shows all pulled images. After removal, hello-world no longer appears.

**6. Clean up**
```bash
docker stop dbtest
docker rm dbtest
docker system prune -f
```
_Expected:_ `system prune` reports space reclaimed from stopped containers and dangling images.

### Validation checklist
- [ ] `docker run hello-world` prints "Hello from Docker!"
- [ ] `docker ps` shows `webtest` running with port `0.0.0.0:8888->80/tcp`
- [ ] `docker stop webtest && docker rm webtest` completes without errors
- [ ] `docker ps -a` confirms `webtest` is gone after removal
- [ ] `docker system prune` completes and reports reclaimed space

---

## WU-6 — Container Management (exec, logs, inspect)

**Girus lab:** `docker-gerenciamento-containers`

```bash
girus lab start docker-gerenciamento-containers
```

### Why this matters
When a lab target misbehaves — DVWA not loading, WebGoat not starting — you need to exec into it, read its logs, and inspect its config. These are the core troubleshooting commands.

### Steps

**1. Start a test container**
```bash
docker run -d --name target nginx
```
_Expected:_ Container ID printed; container starts in background.

**2. Execute commands inside a running container**
```bash
docker exec target ls /etc/nginx
docker exec target cat /etc/nginx/nginx.conf
docker exec -it target bash
```
_Expected:_ `ls /etc/nginx` lists nginx config files. `exec -it ... bash` drops you into an interactive shell inside the container. Type `exit` to leave.

**3. Read container logs**
```bash
docker logs target
docker logs --tail 20 target
docker logs -f target &   # live follow
curl http://localhost:80  # generate a log entry
sleep 2 && kill %1        # stop the log follow
```
_Expected:_ `docker logs` shows nginx access and error logs. After `curl`, a new access log line appears.

**4. Inspect container metadata**
```bash
docker inspect target
docker inspect target | grep -A5 '"IPAddress"'
docker inspect target | grep -A5 '"Mounts"'
```
_Expected:_ Full JSON metadata. IP address shown under `Networks`. Mounts section shows any volume mounts.

**5. Copy files in/out of containers**
```bash
docker cp target:/etc/nginx/nginx.conf /tmp/nginx.conf
cat /tmp/nginx.conf
echo "# modified" >> /tmp/nginx.conf
docker cp /tmp/nginx.conf target:/etc/nginx/nginx.conf
```
_Expected:_ Config file copied out, edited, and copied back. Useful for modifying target configs during labs.

**6. Container resource usage**
```bash
docker stats target --no-stream
```
_Expected:_
```
CONTAINER ID   NAME     CPU %   MEM USAGE / LIMIT   MEM %   NET I/O   BLOCK I/O
a1b2c3...      target   0.00%   5.5MiB / 15.6GiB    0.03%   ...       ...
```

**7. Clean up**
```bash
docker stop target && docker rm target
```

### Validation checklist
- [ ] `docker exec target ls /etc/nginx` returns `nginx.conf` and `conf.d/`
- [ ] `docker exec -it target bash` opens an interactive shell (type `exit` to leave)
- [ ] `docker logs target` shows nginx startup messages
- [ ] `docker inspect target` returns JSON with `IPAddress` populated
- [ ] `docker cp` successfully copies a file out of and back into the container
- [ ] `docker stats --no-stream` shows CPU and MEM usage columns

---

## Quick Reference

```bash
# Start any exercise
girus lab start <lab-id>

# List all available labs
girus lab list

# Check cluster status
girus list clusters

# Open Girus UI
xdg-open http://localhost:8000
```

| Girus Lab ID | Category |
|-------------|----------|
| `linux-comandos-basicos` | Linux |
| `linux-permissoes-arquivos` | Linux |
| `linux-gerenciamento-processos` | Linux |
| `linux-monitoramento-sistema` | Linux |
| `docker-fundamentos` | Docker |
| `docker-gerenciamento-containers` | Docker |
