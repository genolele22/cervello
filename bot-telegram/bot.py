#!/usr/bin/env python3
import logging
import os
from datetime import date
from pathlib import Path

from telegram import Update
from telegram.ext import ApplicationBuilder, CommandHandler, MessageHandler, filters, ContextTypes

DATA_DIR = Path(os.environ.get("DATA_DIR", Path.home() / "cervello"))
TASK_FILE = DATA_DIR / "02-operativo/task-pendenti.md"
TOKEN = os.environ["TELEGRAM_BOT_TOKEN"]

logging.basicConfig(format="%(asctime)s %(levelname)s %(message)s", level=logging.INFO)
log = logging.getLogger(__name__)


def append_task(text: str) -> None:
    today = date.today().strftime("%d/%m/%Y")
    line = f"- [ ] {text} — {today}\n"
    TASK_FILE.parent.mkdir(parents=True, exist_ok=True)
    with TASK_FILE.open("a", encoding="utf-8") as f:
        f.write(line)
    log.info("Task aggiunto: %s", text)


async def cmd_id(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    await update.message.reply_text(
        f"Il tuo chat ID è: `{update.effective_chat.id}`", parse_mode="Markdown"
    )


async def cmd_briefing(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not TASK_FILE.exists():
        await update.message.reply_text("Nessun task pendente.")
        return
    content = TASK_FILE.read_text(encoding="utf-8").strip()
    if not content:
        await update.message.reply_text("Nessun task pendente.")
        return
    await update.message.reply_text(f"📋 *Task pendenti*\n\n{content}", parse_mode="Markdown")


async def handle_text(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    text = update.message.text.strip()
    append_task(text)
    await update.message.reply_text(f"✅ Task aggiunto: {text}")


def main() -> None:
    app = ApplicationBuilder().token(TOKEN).build()
    app.add_handler(CommandHandler("id", cmd_id))
    app.add_handler(CommandHandler("briefing", cmd_briefing))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, handle_text))
    log.info("Bot avviato.")
    app.run_polling()


if __name__ == "__main__":
    main()
