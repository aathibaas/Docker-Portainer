  # 🐳 Docker & Portainer Setup Script für Ubuntu 24.04.x

  Dieses Script automatisiert die Installation von **Docker**, **Docker Compose**
  und **Portainer CE** auf einem Ubuntu-Server.

  Ziel ist ein wiederholbares, stabiles und sauberes Setup, das für Server-
  Umgebungen geeignet ist, in denen Container zuverlässig und konsistent
  betrieben werden sollen.

  ---

  ## ⚙️ Funktionen

  Das Script übernimmt die komplette Grundinstallation für Docker und Portainer
  und stellt sicher, dass der Server bereit für containerbasierte Anwendungen ist.

  ### 🧹 Entfernt alte Docker-Pakete
  Verhindert Konflikte mit älteren oder distributionsbasierten Versionen:

  - docker.io
  - docker-doc
  - docker-compose
  - docker-compose-v2
  - podman-docker

  ### 🔑 Offizielles Docker-Repository einrichten
  - Importiert den offiziellen Docker GPG-Key
  - Fügt die offizielle Docker-APT-Quelle hinzu
  - Gewährleistet, dass Docker stets in aktueller Version installiert wird

  ### 🐳 Docker Engine & Compose installieren
  Installiert folgende Pakete:

  - docker-ce
  - docker-ce-cli
  - containerd.io
  - docker-buildx-plugin
  - docker-compose-plugin

  ### 👤 Benutzer für Docker freischalten
  Das Script erkennt automatisch den Benutzer, der über `sudo` arbeitet,
  und fügt ihn der Gruppe `docker` hinzu, um Befehle ohne root-Rechte
  ausführen zu können.

  ### 🌐 Frei wählbarer Docker-Netzwerkname
  Beim Start des Scripts erscheint eine Eingabeaufforderung:

      Bitte Namen für das Docker-Netzwerk eingeben:
      > meinNetzwerk

  Das Netzwerk wird exakt unter dem gewählten Namen erstellt.

  ### 📦 Portainer CE installieren
  Das Script konfiguriert:

  - das Volume `portainer_data`
  - den Portainer-Container
  - automatische Neustarts
  - die Einbindung der Docker-Sock
  - die Verwendung des zuvor gewählten Netzwerks

  Nach Abschluss ist Portainer sofort über HTTPS nutzbar.

  ## 🚀 Verwendung

  Das Script kann direkt über `curl` ausgeführt werden:

      bash <(curl -s https://raw.githubusercontent.com/aathibaas/Docker-Portainer/refs/heads/main/docker-portainer.sh | sed 's/\r$//')


  Während der Installation wirst du nach dem gewünschten Namen für das Docker-
  Netzwerk gefragt:

      Bitte Namen für das Docker-Netzwerk eingeben:
      > meinNetzwerk

  Das Script richtet anschließend Docker vollständig ein und startet Portainer.

  ---

  ## 🔒 Voraussetzungen

  - Ubuntu 24.04.x LTS  
  - Root-Rechte (sudo)  
  - Internetverbindung  
  - Empfehlung: frisches oder bereinigtes System

  ---

  ## 📌 Kompatibilität

  Getestet mit:

  - Ubuntu Server 24.04.3 LTS (Noble Numbat)
  - Funktioniert mit allen 24.04.x Versionen

  Unterstützte Hosting-Umgebungen:

  - Virtuelle Server (VPS)
  - Dedizierte Hardware
  - Private Server-Installationen

  ---

  ## 🧠 Warum dieses Script erstellt wurde

  Das Ziel war, eine einheitliche, sichere und wiederholbare Umgebung für Docker-
  Installationen zu schaffen, ohne jedes Mal manuell alle Schritte durchlaufen zu
  müssen. Die Automatisierung reduziert Fehler, spart Zeit und sorgt für eine klare,
  reproduzierbare Struktur auf jedem Server.

  ---

  ## 🔌 Ports

  Portainer verwendet standardmäßig:

  - 9443 → HTTPS Webinterface
  - 8000 → Edge Agent (optional)

  ---

  ## 🧑‍💻 Autor

  **Aathithjan Baasgaran**
