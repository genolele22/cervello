#!/bin/bash
set -e

BOT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "=== 1. Creo virtualenv ==="
python3 -m venv "$BOT_DIR/venv"
"$BOT_DIR/venv/bin/pip" install --upgrade pip
"$BOT_DIR/venv/bin/pip" install -r "$BOT_DIR/requirements.txt"

echo ""
echo "=== 2. Installo il servizio systemd ==="
sudo cp "$BOT_DIR/cervello-bot.service" /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable cervello-bot
sudo systemctl start cervello-bot

echo ""
echo "=== Fatto! ==="
echo "Controlla lo stato con: systemctl status cervello-bot"
echo "Vedi i log con:         journalctl -u cervello-bot -f"
