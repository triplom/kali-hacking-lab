#!/usr/bin/env bash
# =============================================================================
# lab.sh — Kali Linux Study Lab Manager
# =============================================================================
# Usage:
#   ./lab.sh start              Start all lab containers
#   ./lab.sh start web          Start only web testing labs
#   ./lab.sh start network      Start only network/exploitation labs
#   ./lab.sh start passwords    Start only password attack labs
#   ./lab.sh start forensics    Start only forensics labs
#   ./lab.sh start reporting    Start only reporting tools
#   ./lab.sh stop               Stop all containers
#   ./lab.sh stop web           Stop web labs only
#   ./lab.sh reset dvwa         Recreate a single container fresh
#   ./lab.sh status             Show all container status + access URLs
#   ./lab.sh logs dvwa          Tail logs of a container
#   ./lab.sh shell dvwa         Open shell inside a container
#   ./lab.sh targets            List all IP targets for scanning
#   ./lab.sh pull               Pull latest images for all services
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yml"
COMPOSE="docker compose -f $COMPOSE_FILE"

# --- Color helpers ---
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; CYAN='\033[0;36m'; BOLD='\033[1m'; NC='\033[0m'

info()    { echo -e "${BLUE}[*]${NC} $*"; }
success() { echo -e "${GREEN}[+]${NC} $*"; }
warn()    { echo -e "${YELLOW}[!]${NC} $*"; }
error()   { echo -e "${RED}[-]${NC} $*"; exit 1; }
header()  { echo -e "\n${BOLD}${CYAN}$*${NC}"; echo -e "${CYAN}$(printf '=%.0s' {1..60})${NC}"; }

# --- Service groups ---
WEB_SERVICES="dvwa dvwa-db webgoat juiceshop mutillidae wordpress wordpress-db"
NETWORK_SERVICES="metasploitable3-ubuntu vulnerable-ssh vulnerable-ftp vulnerable-api"
PASSWORD_SERVICES="hash-server vulnerable-ssh"
FORENSICS_SERVICES="forensics-files"
REPORTING_SERVICES="dradis notes"
MONITOR_SERVICES="ntopng"

ensure_dirs() {
  mkdir -p "$SCRIPT_DIR"/{passwords/hashes,forensics/files,reporting/notes}
  # Create placeholder hash file if none exists
  if [ ! -f "$SCRIPT_DIR/passwords/hashes/index.html" ]; then
    cat > "$SCRIPT_DIR/passwords/hashes/index.html" <<'HTML'
<h2>Hash Cracking Lab</h2>
<pre>
# MD5 hashes (rockyou candidates)
5f4dcc3b5aa765d61d8327deb882cf99   (password)
e10adc3949ba59abbe56e057f20f883e   (123456)
25f9e794323b453885f5181f1b624d0b   (123456789)
d8578edf8458ce06fbc5bb76a58c5ca4   (qwerty)
827ccb0eea8a706c4c34a16891f84e7b   (12345)

# SHA1 hashes
5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8  (password)
7c4a8d09ca3762af61e59520943dc26494f8941b  (123456)

# SHA256 hashes
5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8  (password)
8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92  (123456)

# NTLM hashes (Windows)
8846f7eaee8fb117ad06bdd830b7586c  (password)
32ed87bdb5fdc5e9cba88547376818d4  (123456)
</pre>
HTML
  fi
}

start_services() {
  local profile="${1:-all}"
  ensure_dirs
  header "Starting Lab: $profile"

  case "$profile" in
    all)
      info "Starting all lab containers..."
      $COMPOSE up -d
      ;;
    web)
      info "Starting web application labs..."
      $COMPOSE up -d dvwa dvwa-db webgoat juiceshop mutillidae wordpress wordpress-db
      ;;
    network|exploitation)
      info "Starting network/exploitation labs..."
      $COMPOSE up -d vulnerable-ssh vulnerable-ftp vulnerable-api
      warn "metasploitable3 requires manual image pull: docker pull rapid7/metasploitable3-ub1404"
      ;;
    passwords|password)
      info "Starting password attack labs..."
      $COMPOSE up -d hash-server vulnerable-ssh
      ;;
    forensics)
      info "Starting forensics labs..."
      $COMPOSE up -d forensics-files
      ;;
    reporting)
      info "Starting reporting tools..."
      $COMPOSE up -d dradis notes
      ;;
    monitor)
      info "Starting network monitor..."
      $COMPOSE up -d ntopng
      ;;
    *)
      info "Starting specific service: $profile"
      $COMPOSE up -d "$profile"
      ;;
  esac

  sleep 2
  show_status
}

stop_services() {
  local profile="${1:-all}"
  header "Stopping Lab: $profile"

  case "$profile" in
    all)
      info "Stopping all lab containers..."
      $COMPOSE down
      ;;
    web)
      $COMPOSE stop dvwa dvwa-db webgoat juiceshop mutillidae wordpress wordpress-db
      ;;
    network|exploitation)
      $COMPOSE stop metasploitable3-ubuntu vulnerable-ssh vulnerable-ftp vulnerable-api
      ;;
    passwords|password)
      $COMPOSE stop hash-server vulnerable-ssh
      ;;
    forensics)
      $COMPOSE stop forensics-files
      ;;
    reporting)
      $COMPOSE stop dradis notes
      ;;
    *)
      $COMPOSE stop "$profile"
      ;;
  esac
  success "Done."
}

reset_service() {
  local svc="${1:-}"
  [ -z "$svc" ] && error "Usage: ./lab.sh reset <service-name>"
  header "Resetting: $svc"
  warn "This will destroy and recreate container $svc (data not persisted will be lost)"
  $COMPOSE rm -sf "$svc"
  $COMPOSE up -d "$svc"
  success "$svc has been reset."
}

show_status() {
  header "Lab Status"

  echo ""
  printf "${BOLD}%-30s %-12s %-8s %s${NC}\n" "CONTAINER" "STATUS" "PORT" "URL / NOTES"
  printf "%-30s %-12s %-8s %s\n" "$(printf '%.0s-' {1..29})" "$(printf '%.0s-' {1..11})" "$(printf '%.0s-' {1..7})" "$(printf '%.0s-' {1..40})"

  print_service_row() {
    local name="$1" port="$2" url="$3"
    local status
    status=$(docker inspect --format='{{.State.Status}}' "lab-$name" 2>/dev/null || echo "not found")
    local color="$RED"
    [[ "$status" == "running" ]] && color="$GREEN"
    printf "${color}%-30s %-12s${NC} %-8s %s\n" "lab-$name" "$status" "$port" "$url"
  }

  echo -e "\n${BOLD}--- Web Application Labs ---${NC}"
  print_service_row "dvwa"           "8080" "http://localhost:8080  (admin / password)"
  print_service_row "webgoat"        "8081" "http://localhost:8081/WebGoat  (guest / guest)"
  print_service_row "juiceshop"      "3000" "http://localhost:3000"
  print_service_row "mutillidae"     "8082" "http://localhost:8082  (admin / adminpass)"
  print_service_row "wordpress"      "8083" "http://localhost:8083  (admin / adminpass)"

  echo -e "\n${BOLD}--- Network & Exploitation Labs ---${NC}"
  print_service_row "metasploitable3" "2222/8084" "ssh -p 2222 vagrant@localhost | http://localhost:8084"
  print_service_row "ssh"            "2223" "ssh -p 2223 admin@localhost  (admin / password123)"
  print_service_row "ftp"            "21"   "ftp localhost  (anonymous access enabled)"
  print_service_row "vulnerable-api" "8086" "http://localhost:8086  (REST API)"

  echo -e "\n${BOLD}--- Password Attack Labs ---${NC}"
  print_service_row "hashes"         "8087" "http://localhost:8087  (hash file downloads)"

  echo -e "\n${BOLD}--- Forensics Labs ---${NC}"
  print_service_row "forensics"      "8088" "http://localhost:8088  (forensic image files)"

  echo -e "\n${BOLD}--- Reporting Tools ---${NC}"
  print_service_row "dradis"         "3001" "http://localhost:3001  (setup on first run)"
  print_service_row "notes"          "8089" "http://localhost:8089  (shared note files)"

  echo -e "\n${BOLD}--- Network Monitor ---${NC}"
  print_service_row "ntopng"         "3002" "http://localhost:3002  (admin / admin)"

  echo ""
}

show_targets() {
  header "Scan Targets (Internal Lab Network: 10.10.0.0/24)"
  echo ""
  printf "${BOLD}%-20s %-16s %s${NC}\n" "SERVICE" "IP" "OPEN PORTS"
  printf "%-20s %-16s %s\n" "$(printf '%.0s-' {1..19})" "$(printf '%.0s-' {1..15})" "$(printf '%.0s-' {1..30})"
  echo "dvwa               10.10.0.10   80/tcp"
  echo "dvwa-db            10.10.0.11   3306/tcp"
  echo "webgoat            10.10.0.12   8080/tcp, 9090/tcp"
  echo "juiceshop          10.10.0.13   3000/tcp"
  echo "mutillidae         10.10.0.14   80/tcp, 443/tcp"
  echo "wordpress          10.10.0.15   80/tcp"
  echo "wordpress-db       10.10.0.16   3306/tcp"
  echo "metasploitable3    10.10.0.20   21,22,80,3306,5432,8080/tcp"
  echo "vulnerable-ssh     10.10.0.21   2222/tcp"
  echo "vulnerable-ftp     10.10.0.22   21/tcp"
  echo "vulnerable-api     10.10.0.23   5000/tcp"
  echo "hash-server        10.10.0.30   80/tcp"
  echo "forensics-files    10.10.0.40   80/tcp"
  echo "dradis             10.10.0.50   3000/tcp"
  echo ""
  echo -e "${YELLOW}Tip:${NC} Run Nmap against the whole subnet:"
  echo -e "  ${CYAN}nmap -sV -sC 10.10.0.0/24${NC}"
  echo ""
  echo -e "${YELLOW}Tip:${NC} Use --network=labs_lab-net with attacker containers to reach internal IPs:"
  echo -e "  ${CYAN}docker run --rm --network=labs_lab-net kalilinux/kali-rolling nmap -sV 10.10.0.10${NC}"
}

pull_images() {
  header "Pulling Latest Images"
  $COMPOSE pull
  success "All images updated."
}

show_logs() {
  local svc="${1:-}"
  [ -z "$svc" ] && error "Usage: ./lab.sh logs <service-name>"
  $COMPOSE logs -f "$svc"
}

open_shell() {
  local svc="${1:-}"
  [ -z "$svc" ] && error "Usage: ./lab.sh shell <service-name>"
  info "Opening shell in lab-$svc ..."
  docker exec -it "lab-$svc" /bin/bash 2>/dev/null || \
  docker exec -it "lab-$svc" /bin/sh
}

show_help() {
  header "Kali Study Lab Manager"
  cat <<'EOF'

USAGE: ./lab.sh <command> [argument]

COMMANDS:
  start [profile]     Start containers. Profiles: all, web, network,
                      passwords, forensics, reporting, monitor
                      Or use a specific service name.

  stop [profile]      Stop containers (same profiles as start)

  reset <service>     Destroy and recreate a single container fresh
                      Example: ./lab.sh reset dvwa

  status              Show running status + access URLs for all labs

  targets             Show internal IPs and ports for Nmap/scanning

  logs <service>      Tail logs of a container (Ctrl+C to exit)

  shell <service>     Open an interactive shell inside a container

  pull                Pull/update all container images

  help                Show this help message

STUDY PROFILES:
  web          DVWA, WebGoat, Juice Shop, Mutillidae, WordPress
  network      Metasploitable3, SSH server, FTP server, Vulnerable API
  passwords    Hash server, SSH (for brute-force)
  forensics    File server with forensic images
  reporting    Dradis, shared notes server
  monitor      ntopng network traffic dashboard

EXAMPLES:
  ./lab.sh start web                    # Start web app labs
  ./lab.sh status                       # Check what's running
  ./lab.sh targets                      # Get IPs to scan
  ./lab.sh shell dvwa                   # Shell into DVWA
  ./lab.sh reset juiceshop              # Fresh Juice Shop instance
  ./lab.sh logs wordpress               # Watch WordPress logs

EOF
}

# =============================================================================
# Main
# =============================================================================
CMD="${1:-help}"
ARG="${2:-}"

case "$CMD" in
  start)   start_services "$ARG" ;;
  stop)    stop_services "$ARG" ;;
  reset)   reset_service "$ARG" ;;
  status)  show_status ;;
  targets) show_targets ;;
  logs)    show_logs "$ARG" ;;
  shell)   open_shell "$ARG" ;;
  pull)    pull_images ;;
  help|--help|-h) show_help ;;
  *) error "Unknown command: $CMD. Run './lab.sh help' for usage." ;;
esac
