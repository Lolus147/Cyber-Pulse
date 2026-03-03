#!/bin/bash
# Kolory Cyber-Pulse
BLUE='\e[1;34m'
CYAN='\e[1;36m'
GREEN='\e[1;32m'
RED='\e[1;31m'
NC='\e[0m'

echo -e "${BLUE}================================================================${NC}"
echo -e "${BLUE}   INTEGRATED THREAT DETECTION & MONITORING | ${CYAN}CYBER-PULSE${NC}"
echo -e "${BLUE}================================================================${NC}"

# Funkcja dla usług systemowych (Pi-hole, Suricata, itp.)
check_status() {
    printf "   %-35s" "$1"
    if systemctl is-active --quiet "$2"; then
        echo -e "${GREEN}● ACTIVE${NC}"
    else
        echo -e "${RED}○ DOWN${NC}"
    fi
}

# Funkcja dla kontenerów Docker (Grafana, Prometheus)
check_docker() {
    printf "   %-35s" "$1"
    # Szuka kontenera po fragmencie nazwy na liście aktywnych procesów Dockera
    if docker ps 2>/dev/null | grep -iq "$2" || sudo docker ps 2>/dev/null | grep -iq "$2"; then
        echo -e "${GREEN}● ACTIVE${NC}"
    else
        echo -e "${RED}○ DOWN${NC}"
    fi
}

# Sprawdzanie usług
check_status "Tailscale Admin (VPN Mesh)" "tailscaled"
check_status "Suricata IDS (Inspection)" "suricata"
check_status "Pi-hole (DNS Filtering)" "pihole-FTL"
check_status "Kismet Radar (Wireless IDS)" "kismet"

# Sprawdzanie kontenerów (wyszukuje fraz "grafana" i "prometheus")
check_docker "Grafana SOC (Main Dashboard)" "grafana"
check_docker "Prometheus (Data Collection)" "prometheus"

check_status "CrowdSec (IPS Status)" "crowdsec"

echo -e "${BLUE}----------------------------------------------------------------${NC}"
BANS=$(sudo cscli decisions list 2>/dev/null | grep -c "Ip")
echo -e "   CrowdSec Active Decisions: ${RED}${BANS}${NC}"
echo -e "${BLUE}================================================================${NC}"
