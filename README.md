# 🛡️ Cyber-Pulse: Integrated Threat Detection & Monitoring (SOC)

**Cyber-Pulse: Prywatne, domowe Centrum Operacyjne Bezpieczeństwa (SOC). Zbudowane z użyciem WireGuard do omijania blokad operatora (CGNAT), Suricata (IDS) i CrowdSec (IPS) do aktywnej obrony przed zagrożeniami oraz Pi-hole do filtrowania DNS. Posiada autorski panel zarządzania w terminalu Zsh oraz w pełni skonteneryzowaną analitykę (Prometheus + Grafana) do automatycznego monitorowania sieci.**

---

## 🖥️ Platforma Sprzętowa (Hardware)
Sercem całego systemu jest energooszczędny terminal (Thin Client), który idealnie sprawdza się w roli bezgłośnego, domowego serwera pracującego w trybie 24/7. Wykorzystanie lekkich narzędzi i konteneryzacji pozwala na płynne działanie systemów bezpieczeństwa na ograniczonych zasobach.

* **Urządzenie:** HP t620 Thin Client
* **System Operacyjny:** Debian GNU/Linu
* **Procesor (CPU):** AMD GX-415GA SOC (4) @ 1.500GHz
* **Pamięć RAM:** 4 GB DDR3L
* **Dysk (Storage):** 120 GB M.2 2242 SATA III SSD (TLC)
* **Moduł Zwiadu Radiowego:** Zewnętrzna karta sieciowa USB Alfa Network AWUS036AXM (Wi-Fi 6E). Skonfigurowana w trybie monitora / packet injection na potrzeby systemu nasłuchu Kismet.



![Panel CLI Cyber-Pulse](link_do_zdjecia_twojego_terminala.png)

---

## 🏗️ Architektura Sieci

* **Szyfrowany tunel (VPN):** Zapewnia bezpieczny, zdalny punkt wejścia do sieci domowej z zewnątrz.
* **Lokalny serwer DNS:** Pełni rolę pierwszej linii obrony i "czarnej dziury" dla niechcianego ruchu.
* **System IDS/IPS:** Duet narzędzi do głębokiej inspekcji ruchu sieciowego oraz automatycznego blokowania ataków.
* **Środowisko analityczne (Docker):** Odizolowana warstwa odpowiedzialna za ciągłe zbieranie logów i wyświetlanie ich na głównym ekranie dowodzenia.
* **Radar Wi-Fi:** Niezależny moduł z zewnętrzną kartą sieciową do monitorowania przestrzeni radiowej wokół domu.

Dokładny podział ról oraz technologie wykorzystane w każdej z tych warstw zostały opisane w dalszej części dokumentacji.

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
