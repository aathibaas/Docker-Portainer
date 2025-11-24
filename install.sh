#!/bin/bash
# ========================================
# Docker & Portainer Setup Script
# Für Ubuntu 24.04.x LTS
# Erstellt von Aathithjan Baasgaran
# ========================================

set -e  # Stoppe bei Fehler

# Root-Prüfung
if [ "$EUID" -ne 0 ]; then
  echo "❌ Bitte mit sudo oder als root ausführen."
  exit 1
fi

echo "🐳 Starte Docker & Portainer Setup..."

# 1. System aktualisieren
echo "📦 Update & Upgrade..."
apt update && apt full-upgrade -y
apt autoremove -y
apt autoclean -y

# 2. Notwendige Pakete für Docker-Repo
echo "🧰 Installiere benötigte Pakete..."
apt install -y ca-certificates curl gnupg

# 3. Docker GPG-Key & Repository hinzufügen (offiziell)
echo "🔑 Füge offiziellen Docker GPG-Key & Repository hinzu..."

install -m 0755 -d /etc/apt/keyrings
if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  chmod a+r /etc/apt/keyrings/docker.gpg
fi

# Ubuntu-Codename automatisch auslesen (z.B. noble)
UBUNTU_CODENAME=$(grep VERSION_CODENAME /etc/os-release | cut -d'=' -f2)

cat <<EOF > /etc/apt/sources.list.d/docker.list
deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $UBUNTU_CODENAME stable
EOF

# 4. Docker installieren (Engine, CLI, Compose-Plugin)
echo "🐳 Installiere Docker Engine (offiziell)..."
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 5. Docker-Dienst aktivieren
echo "✅ Aktiviere und starte Docker Dienst..."
systemctl enable docker
systemctl start docker

# 6. Docker-Netzwerk erstellen (Name frei wählbar)
echo ""
echo "🌐 Docker-Netzwerk erstellen"
read -rp "Name für das Docker-Netzwerk (z.B. internal-net): " DOCKER_NET_NAME

if [ -z "$DOCKER_NET_NAME" ]; then
  echo "⚠️ Kein Name angegeben, verwende Standard: internal-net"
  DOCKER_NET_NAME="internal-net"
fi

# Prüfen, ob Netzwerk bereits existiert
if docker network ls --format '{{.Name}}' | grep -q "^${DOCKER_NET_NAME}\$"; then
  echo "ℹ️ Docker-Netzwerk '${DOCKER_NET_NAME}' existiert bereits – überspringe Erstellung."
else
  echo "🧱 Erstelle Docker-Netzwerk '${DOCKER_NET_NAME}'..."
  docker network create --driver bridge "${DOCKER_NET_NAME}"
fi

# 7. Portainer installieren (aktuelle Community Edition)
echo "📦 Installiere Portainer CE im Netzwerk '${DOCKER_NET_NAME}'..."

# Data-Volume für Portainer
docker volume create portainer_data >/dev/null 2>&1 || true

# Prüfen ob Container schon existiert
if docker ps -a --format '{{.Names}}' | grep -q '^portainer$'; then
  echo "ℹ️ Portainer-Container existiert bereits – stoppe und lösche ihn..."
  docker stop portainer >/dev/null 2>&1 || true
  docker rm portainer >/dev/null 2>&1 || true
fi

# Portainer starten
docker run -d \
  --name portainer \
  --restart=always \
  --network "${DOCKER_NET_NAME}" \
  -p 8000:8000 \
  -p 9443:9443 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

echo ""
echo "✅ Docker & Portainer Setup abgeschlossen!"
echo "------------------------------------------"
echo "🔹 Docker Version:"
docker --version || echo "Docker nicht gefunden?"

echo ""
echo "🔹 Portainer läuft nun unter:"
echo "   https://<DEINE-SERVER-IP>:9443"
echo "   (Beim ersten Aufruf Admin-Benutzer erstellen)"
echo ""
echo "🔹 Docker-Netzwerk:"
echo "   Name: ${DOCKER_NET_NAME}"
docker network inspect "${DOCKER_NET_NAME}" >/dev/null 2>&1 && echo "   ✅ Netzwerk existiert."
echo ""
