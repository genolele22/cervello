#!/usr/bin/env python3
"""Legge il briefing del giorno e lo invia su Telegram."""
import os
import sys
from datetime import date
from pathlib import Path

import httpx

TOKEN = os.environ["TELEGRAM_BOT_TOKEN"]
CHAT_ID = os.environ["TELEGRAM_CHAT_ID"]
NOTE_DIR = Path.home() / "cervello/02-operativo/note-giornaliere"


def send(text: str) -> None:
    url = f"https://api.telegram.org/bot{TOKEN}/sendMessage"
    # Telegram limita i messaggi a 4096 caratteri
    for chunk in [text[i:i+4096] for i in range(0, len(text), 4096)]:
        httpx.post(url, json={"chat_id": CHAT_ID, "text": chunk, "parse_mode": "Markdown"})


def main() -> None:
    today = date.today().strftime("%Y-%m-%d")
    note_file = NOTE_DIR / f"{today}.md"

    if not note_file.exists():
        send(f"⚠️ Briefing del {today} non trovato.")
        sys.exit(1)

    content = note_file.read_text(encoding="utf-8").strip()
    send(f"☀️ *Briefing {today}*\n\n{content}")


if __name__ == "__main__":
    main()
