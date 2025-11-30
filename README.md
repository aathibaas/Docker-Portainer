  # 🐳 Docker & Portainer Setup Script für Ubuntu 24.04.x

  Dieses Script automatisiert die Installation von **Docker**, **Docker Compose**
  und **Portainer CE** auf einem Ubuntu-Server.
  Es ist optimiert für Projekte wie **TopBarSwiss**, **Admin-Dashboards**,
  **Datenbanken**, **Game-Server** und andere containerbasierte Anwendungen.

  Ziel ist ein wiederholbares, stabiles und sauberes Setup, das auf jedem meiner VPS
  identisch funktioniert.

  ---

  ## ⚙️ Funktionen

  Das Script übernimmt die komplette Grundinstallation für Docker und Portainer:

  ### 🧹 Entfernt alte Docker-Pakete
  Verhindert Konflikte mit Ubuntu-Repositories:

  - docker.io
  - docker-doc
  - docker-compose
  - docker-compose-v2
  - podman-docker

  ### 🔑 Offizielles Docker-Repository einrichten
  - Importiert den Docker GPG-Key  
  - Fügt die offizielle Docker-APT-Quelle hinzu  
  - Installiert Docker-Pakete direkt aus der offiziellen Quelle  

  ### 🐳 Docker Engine & Compose installieren
  Installiert folgende Pakete:

  - docker-ce
  - docker-ce-cli
  - containerd.io
  - docker-buildx-plugin
  - docker-compose-plugin

  ### 👤 Benutzer für Docker freischalten
  Das Script erkennt automatisch den tatsächlichen Benutzer hinter sudo
  und fügt ihn korrekt der Gruppe `docker` hinzu.

  ### 🌐 Frei wählbarer Docker-Netzwerkname
  Beim Start des Scripts erscheint eine Eingabe:

      Bitte Namen für das Docker-Netzwerk eingeben:
      > mynetwork

  Das Netzwerk wird exakt mit diesem Namen erstellt.

  ### 📦 Portainer CE installieren
  Das Script erstellt:

  - das Docker-Volume `portainer_data`
  - startet den Portainer-Container
  - bindet die Docker-Sock ein
  - konfiguriert automatischen Neustart
  - verwendet das ausgewählte Netzwerk

  Portainer läuft anschließend sofort über HTTPS.
readme_part_2: |
  ## 🚀 Verwendung

  Das Script kann direkt über `curl` ausgeführt werden:

      bash <(curl -s https://raw.githubusercontent.com/aathibaas/docker-portainer-setup/main/install-docker-portainer.sh | sed 's/\r$//')

  Während der Installation wirst du nach dem gewünschten Namen für das Docker-Netzwerk gefragt:

      Bitte Namen für das Docker-Netzwerk eingeben:
      > topbarswiss

  ---

  ## 🔒 Voraussetzungen

  - Ubuntu 24.04.x LTS  
  - Root-Zugriff (sudo)  
  - Internetverbindung  
  - Ideal für frische oder bereinigte Systeme  

  ---

  ## 📌 Kompatibilität

  Getestet mit:

  - Ubuntu Server 24.04.3 LTS (Noble Numbat)
  - Funktioniert mit allen 24.04.x Versionen

  Unterstützte Plattformen:

  - Netcup  
  - Hetzner  
  - Contabo  
  - Bare-metal Installationen  

  ---

  ## 🧠 Warum ich dieses Script geschrieben habe

  Ich nutze Docker für nahezu alle meine Projekte – egal ob Websites, Admin-Oberflächen,
  Datenbanken, Game-Server oder interne Tools.
  Um jedes Mal ein einheitliches, sicheres und sauberes Setup zu haben,
  habe ich dieses Script geschrieben.

  Es spart Zeit, verhindert Fehler und sorgt dafür,
  dass jeder Docker-Server exakt gleich eingerichtet wird.

  ---

  ## 🔌 Ports

  Portainer verwendet standardmäßig:

  - 9443 → HTTPS Webinterface  
  - 8000 → Edge Agent (optional)  

  ---

  ## 🧑‍💻 Autor

  **Aathithjan Baasgaran**
