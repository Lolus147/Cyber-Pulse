# 🛡️ Cyber-Pulse: Integrated Threat Detection & Monitoring (SOC)

**Cyber-Pulse: Prywatne, domowe Centrum Operacyjne Bezpieczeństwa (SOC). Zbudowane z użyciem WireGuard do omijania blokad operatora (CGNAT), Suricata (IDS) i CrowdSec (IPS) do aktywnej obrony przed zagrożeniami oraz Pi-hole do filtrowania DNS. Posiada autorski panel zarządzania w terminalu Zsh oraz w pełni skonteneryzowaną analitykę (Prometheus + Grafana) do automatycznego monitorowania sieci.**

---

## 🎯 Opis Projektu
Celem tego projektu było zaprojektowanie i wdrożenie bezpiecznej, odizolowanej i w pełni monitorowanej bramy sieciowej typu "Home Lab" na terminalu HP t620. Urządzenie pełni rolę centralnego punktu SOC dla sieci lokalnej, zapewniając bezpieczny dostęp zdalny z pominięciem restrykcyjnych zapór dostawcy internetu (ISP), jednocześnie aktywnie blokując globalne ataki.

![Panel CLI Cyber-Pulse](link_do_zdjecia_twojego_terminala.png)

---

## 🏗️ Architektura Sieci
Infrastruktura została zaprojektowana tak, aby oddzielić warstwę monitoringu od mechanizmów aktywnej obrony. Ruch sieciowy przepływa przez bezpieczny tunel VPN, jest poddawany głębokiej inspekcji przez duet IDS/IPS, a wszystkie logi trafiają do skonteneryzowanych paneli analitycznych.

```mermaid
flowchart LR
    subgraph Zdalnie ["📍 Warszawa"]
        PC["💻 Komputer<br>(Klient Admin / PuTTY)"]
    end

    subgraph Internet ["🌐 Zewnętrzna Sieć"]
        VPN{{"🔒 Szyfrowany Tunel<br>(WireGuard)"}}
    end

    subgraph Siec_Domowa ["🏠 Sieć Lokalna"]
        Router["🌐 Router<br>(Brama Internetowa)"]

        subgraph SOC [" "]
            WG["🛡️ Interfejs Wewnętrzny<br>(Odbiór ruchu VPN)"]
            DNS["🛑 Pi-hole<br>(Filtrowanie zapytań)"]
            IDS["🕵️ Suricata<br>(Inspekcja pakietów IDS)"]
            IPS["👮 CrowdSec<br>(Aktywne blokowanie IPS)"]
            Monitor["📊 Grafana + Prometheus<br>(Wizualizacja SOC)"]

            Alfa["📡 Karta Sieciowa Alfa<br>(Tryb Monitora)"]
            Kismet["📻 Kismet<br>(Wireless Radar)"]

            WG --> DNS
            WG --> IDS
            IDS --> IPS
            IPS -.->|Logi| Monitor
            DNS -.->|Dane| Monitor
            Alfa -.->|Nasłuch| Kismet

            Tytul["🖥️ Serwer HP t620 (SOC Cyber-Pulse)"]
            style Tytul fill:none,stroke:none,font-weight:bold,color:#888
        end
    end

    PC <===>|Penetracja blokad operatora| VPN
    VPN <===> Router
    Router <===> WG
