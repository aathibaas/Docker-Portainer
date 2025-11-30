#!/usr/bin/env bash
set -euo pipefail

echo "=== Docker & Portainer Setup ==="

if [ "$(id -u)" -ne 0 ]; then
  echo "Bitte mit root-Rechten ausführen, z.B.:"
  echo "  sudo $0"
  exit 1
fi

TARGET_USER="${SUDO_USER:-$USER}"
echo "Benutzer für docker-Gruppe: $TARGET_USER"

# ===============================
# Netzwerkname abfragen
# ===============================
echo ""
read -rp "Bitte Namen für das Docker-Netzwerk eingeben: " NET_NAME

if [ -z "$NET_NAME" ]; then
  echo "Netzwerkname darf nicht leer sein!"
  exit 1
fi

echo "Docker-Netzwerk wird angelegt als: $NET_NAME"
echo ""

echo "=== System aktualisieren ==="
apt update
apt upgrade -y

echo "=== Alte Docker-Versionen entfernen ==="
apt remove -y docker.io docker-doc docker-compose docker-compose-v2 podman-docker || true
apt autoremove -y

echo "=== Voraussetzungen installieren ==="
apt update
apt install -y ca-certificates curl gnupg

echo "=== Docker GPG-Key & Repository einrichten ==="
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  > /etc/apt/sources.list.d/docker.list

echo "=== Docker installieren ==="
apt update
apt install -y \
  docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Docker-Dienst aktivieren ==="
systemctl enable --now docker
docker version || echo "Warnung: 'docker version' konnte nicht ausgeführt werden."

echo "=== Benutzer zur docker-Gruppe hinzufügen ==="
if id "$TARGET_USER" &>/dev/null; then
  usermod -aG docker "$TARGET_USER"
  echo "Benutzer $TARGET_USER wurde zur Gruppe 'docker' hinzugefügt."
else
  echo "Benutzer $TARGET_USER existiert nicht, überspringe usermod."
fi

# ===============================
# Netzwerk erstellen (mit Name)
# ===============================
echo "=== Docker Netzwerk '$NET_NAME' erstellen ==="
docker network create "$NET_NAME" || echo "Netzwerk '$NET_NAME' existiert bereits."
docker network ls

echo "=== Volume erstellen ==="
docker volume create portainer_data || true

echo "=== Portainer starten ==="
docker run -d \
  -p 8000:8000 \
  -p 9443:9443 \
  --name portainer \
  --restart=always \
  --network "$NET_NAME" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:lts

echo "=== Container laufen ==="
docker ps

echo ""
echo "=== Fertig! ==="
echo "Portainer erreichbar unter: https://<SERVER-IP>:9443"
echo "Docker-Netzwerk: $NET_NAME"
