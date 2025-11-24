Docker & Portainer Setup – Ubuntu 24.04 LTS

Dieses Bash-Script installiert und konfiguriert automatisch:

- Docker Engine (offiziell von Docker)
- Docker Compose Plugin
- Ein benutzerdefiniertes Docker-Bridge-Netzwerk
- Portainer CE (Web-UI für Docker)
- Setzt DOCKER_MIN_API_VERSION für maximale Kompatibilität

Getestet mit Ubuntu 24.04.x LTS (Noble Numbat)


WAS DAS SCRIPT ERLEDIGT

- Systemupdate + Cleanup
- Installation aller benötigten Pakete
- Hinzufügen des offiziellen Docker-Repositories
- Installation von:
  docker-ce
  docker-ce-cli
  containerd.io
  docker-buildx-plugin
  docker-compose-plugin
- Setzen von:
  DOCKER_MIN_API_VERSION=1.24
- Aktivieren & Neustarten von Docker
- Erstellen eines Docker-Bridge-Netzwerks (Name frei wählbar)
- Installation & Start von Portainer im erstellten Netzwerk


## 🚀 Verwendung

```bash
bash <(curl -s https://raw.githubusercontent.com/aathibaas/Docker-Portainer/refs/heads/main/installation.sh | sed 's/\r$//')
```


5. Netzwerk-Namen eingeben

Beispiel:
internal-net

Wenn du nichts eingibst, wird automatisch "internal-net" verwendet.


NACH DER INSTALLATION

Portainer ist erreichbar unter:

https://<DEINE-SERVER-IP>:9443

Beim ersten Aufruf:
- Admin-User erstellen
- Als Environment: Docker Standalone auswählen
- Docker Socket wird automatisch erkannt
- Fertig


NÜTZLICHE DOCKER BEFEHLE

Docker Status prüfen
systemctl status docker

Container anzeigen
docker ps -a

Netzwerke anzeigen
docker network ls

Portainer Logs anzeigen
docker logs -f portainer


WICHTIGE HINWEISE

- Port 9443 muss erreichbar sein (UFW/Firewall prüfen)
- Script immer mit sudo / root ausführen
- Für produktive Umgebungen empfohlen:
  - UFW konfigurieren
  - Fail2Ban
  - Reverse Proxy oder Cloudflare Tunnel
  - Regelmäßige Backups des portainer_data Volumes


Autor: Aathithjan Baasgaran
Optimiert für schnelle, saubere Docker-Setups auf Ubuntu 24.04
