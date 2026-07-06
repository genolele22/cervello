#!/usr/bin/env python3
"""Genera un PDF unico e colorato del corso di disegno (dai file markdown)."""
import re
import math
from pathlib import Path
from fpdf import FPDF
from fpdf.enums import MethodReturnValue, XPos, YPos

BASE = Path(__file__).resolve().parent
FONT = "/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf"
FONT_B = "/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf"

FILES = [
    "00-regole-del-gioco.md",
    "sessione-01-personaggio-da-scarabocchio.md",
    "sessione-02-la-faccia-che-sente.md",
    "sessione-03-la-prima-vignetta.md",
    "sessione-04-la-striscia.md",
    "sessione-05-far-muovere-il-personaggio.md",
    "sessione-06-il-posto-dove-succede.md",
    "sessione-07-la-mia-prima-paginetta.md",
]

# --- Palette ----------------------------------------------------------------
TEXT = (45, 45, 45)
MUTED = (120, 120, 120)
RULES_COLOR = (60, 70, 150)
WARN = (200, 50, 35)
WARN_BG = (252, 232, 228)
PALETTE = [
    (37, 99, 175),    # blu
    (230, 90, 40),    # arancio
    (22, 150, 110),   # verde
    (146, 84, 191),   # viola
    (0, 151, 178),    # teal
    (224, 72, 118),   # rosa
    (236, 150, 18),   # ambra
]


def tint(c, f=0.86):
    return tuple(int(ci + (255 - ci) * f) for ci in c)


# --- Parsing markdown -> blocchi -------------------------------------------
def strip_front_matter(text):
    if text.startswith("---"):
        parts = text.split("---", 2)
        if len(parts) == 3:
            return parts[2].lstrip("\n")
    return text


def clean_inline(s):
    """Tiene **grassetto** (per markdown=True di fpdf2), toglie gli * singoli."""
    return re.sub(r"(?<!\*)\*(?!\*)", "", s)


def parse_blocks(text):
    text = strip_front_matter(text)
    blocks, para, bullets = [], [], []

    def flush_para():
        if para:
            blocks.append(("p", clean_inline(" ".join(para))))
            para.clear()

    def flush_bullets():
        if bullets:
            blocks.append(("ul", [clean_inline(b) for b in bullets]))
            bullets.clear()

    for line in text.split("\n"):
        st = line.strip()
        if not st:
            flush_para(); flush_bullets(); continue
        if st.startswith("### "):
            flush_para(); flush_bullets(); blocks.append(("h3", clean_inline(st[4:])))
        elif st.startswith("## "):
            flush_para(); flush_bullets(); blocks.append(("h2", clean_inline(st[3:])))
        elif st.startswith("# "):
            flush_para(); flush_bullets(); blocks.append(("h1", clean_inline(st[2:])))
        elif st.startswith("- "):
            flush_para(); bullets.append(st[2:])
        else:
            flush_bullets(); para.append(st)
    flush_para(); flush_bullets()
    return blocks


# --- PDF --------------------------------------------------------------------
class PDF(FPDF):
    def __init__(self):
        super().__init__(format="A4")
        self.set_margins(20, 20, 20)
        self.set_auto_page_break(auto=True, margin=20)
        self.add_font("DejaVu", "", FONT)
        self.add_font("DejaVu", "B", FONT_B)
        self.add_font("DejaVu", "I", FONT)
        self.add_font("DejaVu", "BI", FONT_B)
        self.color = RULES_COLOR

    def footer(self):
        if self.page_no() == 1:
            return
        self.set_y(-14)
        self.set_font("DejaVu", "", 8)
        self.set_text_color(*MUTED)
        self.cell(0, 8, f"Corso di disegno fumetto  ·  {self.page_no()}", align="C")

    # ---- misure ----
    def mc_height(self, w, txt, lh, md=False, size=11, style=""):
        self.set_font("DejaVu", style, size)
        return self.multi_cell(w=w, h=lh, text=txt, markdown=md, dry_run=True,
                               output=MethodReturnValue.HEIGHT)

    def ensure(self, h):
        if self.get_y() + h > self.h - self.b_margin:
            self.add_page()

    # ---- mattoni grafici ----
    def paragraph(self, txt, size=11, lh=5.7, color=TEXT, gap=2.2):
        self.set_font("DejaVu", "", size)
        self.set_text_color(*color)
        self.set_x(self.l_margin)
        self.multi_cell(self.epw, lh, txt, markdown=True,
                        new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        self.ln(gap)

    def subheading(self, txt):
        self.ln(1.5)
        self.ensure(12)
        x, y = self.l_margin, self.get_y()
        # quadratino colorato
        self.set_fill_color(*self.color)
        self.rect(x, y + 1.2, 3.2, 3.2, style="F")
        self.set_font("DejaVu", "B", 12.5)
        self.set_text_color(*self.color)
        self.set_xy(x + 6, y)
        self.multi_cell(self.epw - 6, 6, txt, new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        # filetto sottile
        yy = self.get_y() + 0.5
        self.set_draw_color(*tint(self.color, 0.55))
        self.set_line_width(0.4)
        self.line(x, yy, x + 30, yy)
        self.ln(3)

    def bullets(self, items, color=None):
        color = color or self.color
        for it in items:
            self.set_font("DejaVu", "", 11)
            tw = self.epw - 7
            h = self.mc_height(tw, it, 5.6, md=True)
            self.ensure(h + 1)
            x, y = self.l_margin, self.get_y()
            self.set_fill_color(*color)
            self.ellipse(x + 0.5, y + 1.7, 2.6, 2.6, style="F")
            self.set_text_color(*TEXT)
            self.set_xy(x + 7, y)
            self.multi_cell(tw, 5.6, it, markdown=True,
                            new_x=XPos.LMARGIN, new_y=YPos.NEXT)
            self.ln(1.4)
        self.ln(1.2)

    def info_box(self, txt):
        # "Obiettivo ... · Serve ... · Durata ..." -> tre righe
        body = txt.replace(" · ", "\n").replace("·", "\n").strip()
        pad = 4
        tw = self.epw - 2 * pad
        h = self.mc_height(tw, body, 5.6, md=True) + 2 * pad
        self.ensure(h + 2)
        x, y = self.l_margin, self.get_y()
        self.set_fill_color(*tint(self.color, 0.88))
        self.rect(x, y, self.epw, h, style="F", round_corners=True, corner_radius=2.5)
        self.set_xy(x + pad, y + pad)
        self.set_text_color(*TEXT)
        self.set_font("DejaVu", "", 10.5)
        self.multi_cell(tw, 5.6, body, markdown=True,
                        new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        self.set_y(y + h)
        self.ln(3)

    def warn_box(self, heading, paras):
        pad = 4.5
        tw = self.epw - 2 * pad
        hh = self.mc_height(tw - 6, heading, 6, md=False, size=12, style="B")
        bh = sum(self.mc_height(tw, p, 5.6, md=True) + 2.2 for p in paras)
        total = pad + hh + 1.5 + bh + pad
        self.ensure(total + 2)
        x, y = self.l_margin, self.get_y()
        self.set_fill_color(*WARN_BG)
        self.rect(x, y, self.epw, total, style="F", round_corners=True, corner_radius=2.5)
        # barretta rossa a sinistra
        self.set_fill_color(*WARN)
        self.rect(x, y, 2.2, total, style="F")
        # heading con pallino
        self.set_fill_color(*WARN)
        self.ellipse(x + pad, y + pad + 1.4, 3.4, 3.4, style="F")
        self.set_xy(x + pad + 6, y + pad)
        self.set_font("DejaVu", "B", 12)
        self.set_text_color(*WARN)
        self.multi_cell(tw - 6, 6, heading, new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        self.set_xy(x + pad, y + pad + hh + 1.5)
        for p in paras:
            self.set_x(x + pad)
            self.set_font("DejaVu", "", 11)
            self.set_text_color(*TEXT)
            self.multi_cell(tw, 5.6, p, markdown=True, new_x=XPos.LMARGIN, new_y=YPos.NEXT)
            self.ln(2.2)
        self.set_y(y + total)
        self.ln(3)

    def session_band(self, number, title):
        pad = 5
        disc = 15
        gap = 4
        tw = self.epw - pad - disc - gap - pad
        self.set_font("DejaVu", "B", 15)
        th = self.multi_cell(w=tw, h=7, text=title, dry_run=True,
                             output=MethodReturnValue.HEIGHT)
        band = max(22, th + 12)
        self.ensure(band + 4)
        x, y = self.l_margin, self.get_y()
        self.set_fill_color(*self.color)
        self.rect(x, y, self.epw, band, style="F", round_corners=True, corner_radius=4)
        # disco bianco col numero
        dy = y + (band - disc) / 2
        self.set_fill_color(255, 255, 255)
        self.ellipse(x + pad, dy, disc, disc, style="F")
        self.set_xy(x + pad, dy)
        self.set_font("DejaVu", "B", 14)
        self.set_text_color(*self.color)
        self.cell(disc, disc, str(number), align="C")
        # titolo
        self.set_xy(x + pad + disc + gap, y + (band - th) / 2)
        self.set_font("DejaVu", "B", 15)
        self.set_text_color(255, 255, 255)
        self.multi_cell(tw, 7, title, new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        self.set_y(y + band)
        self.ln(5)

    def rule_card(self, number, title, body):
        pad = 4.5
        disc = 11
        txt_x_off = pad + disc + 4
        tw = self.epw - txt_x_off - pad
        self.set_font("DejaVu", "B", 12)
        th = self.multi_cell(tw, 6, title, dry_run=True, output=MethodReturnValue.HEIGHT)
        self.set_font("DejaVu", "", 10.8)
        bh = self.multi_cell(tw, 5.4, body, dry_run=True, output=MethodReturnValue.HEIGHT)
        total = pad + th + 1.5 + bh + pad
        self.ensure(total + 3)
        x, y = self.l_margin, self.get_y()
        self.set_fill_color(*tint(self.color, 0.9))
        self.rect(x, y, self.epw, total, style="F", round_corners=True, corner_radius=3)
        # disco numero
        self.set_fill_color(*self.color)
        self.ellipse(x + pad, y + pad, disc, disc, style="F")
        self.set_xy(x + pad, y + pad)
        self.set_font("DejaVu", "B", 11)
        self.set_text_color(255, 255, 255)
        self.cell(disc, disc, str(number), align="C")
        # titolo
        self.set_xy(x + txt_x_off, y + pad)
        self.set_font("DejaVu", "B", 12)
        self.set_text_color(*self.color)
        self.multi_cell(tw, 6, title, new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        # corpo
        self.set_xy(x + txt_x_off, y + pad + th + 1.5)
        self.set_font("DejaVu", "", 10.8)
        self.set_text_color(*TEXT)
        self.multi_cell(tw, 5.4, body, new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        self.set_y(y + total)
        self.ln(3.5)


def draw_cover(pdf):
    pdf.add_page()
    c = PALETTE[0]
    # pannello colorato
    px, py, pw, ph = 18, 40, pdf.w - 36, 150
    pdf.set_fill_color(*c)
    pdf.rect(px, py, pw, ph, style="F", round_corners=True, corner_radius=8)
    # pallini decorativi
    for cx, cy, r, col in [(34, 58, 5, PALETTE[1]), (pdf.w - 40, 64, 7, PALETTE[2]),
                           (pdf.w - 30, 172, 5, PALETTE[6]), (40, 176, 6, PALETTE[5])]:
        pdf.set_fill_color(*col)
        pdf.ellipse(cx, cy, r * 2, r * 2, style="F")
    # nuvoletta fumetto (decoro)
    bx, by, bw, bh = pdf.w / 2 - 22, py + 18, 44, 26
    pdf.set_fill_color(255, 255, 255)
    pdf.rect(bx, by, bw, bh, style="F", round_corners=True, corner_radius=6)
    pdf.polygon([(bx + 12, by + bh - 1), (bx + 8, by + bh + 9), (bx + 22, by + bh - 1)],
                style="F")
    pdf.set_text_color(*c)
    pdf.set_font("DejaVu", "B", 22)
    pdf.set_xy(bx, by + 6)
    pdf.cell(bw, 14, "POW!", align="C")
    # titolo
    pdf.set_text_color(255, 255, 255)
    pdf.set_font("DejaVu", "B", 34)
    pdf.set_xy(px, py + 58)
    pdf.multi_cell(pw, 15, "Corso di disegno\nfumetto", align="C")
    pdf.set_font("DejaVu", "", 13)
    pdf.set_xy(px + 10, py + 104)
    pdf.multi_cell(pw - 20, 7,
                   "Sette sessioni per giocare col disegno e con le storie.",
                   align="C")
    # sottotitolo sotto il pannello
    pdf.set_xy(px, py + ph + 12)
    pdf.set_text_color(*TEXT)
    pdf.set_font("DejaVu", "", 12)
    pdf.multi_cell(pw, 7,
                   "Per un ragazzo di 10 anni e un genitore che fa da guida\n"
                   "(non serve saper disegnare).", align="C")
    pdf.ln(4)
    pdf.set_text_color(*MUTED)
    pdf.set_font("DejaVu", "", 10.5)
    pdf.multi_cell(pw, 6,
                   "Metodo: la narrazione prima della tecnica.\nBozza — 31 maggio 2026",
                   align="C")


def render_rules(pdf, blocks):
    pdf.color = RULES_COLOR
    pdf.add_page()
    rule_no = 0
    for kind, payload in blocks:
        if kind == "h1":
            pdf.session_band("✏", payload) if False else None
            # titolo grande
            pdf.set_font("DejaVu", "B", 26)
            pdf.set_text_color(*pdf.color)
            pdf.multi_cell(pdf.epw, 12, payload, new_x=XPos.LMARGIN, new_y=YPos.NEXT)
            pdf.set_draw_color(*pdf.color)
            pdf.set_line_width(1.2)
            yy = pdf.get_y() + 1
            pdf.line(pdf.l_margin, yy, pdf.l_margin + 38, yy)
            pdf.ln(6)
        elif kind == "p":
            m = re.match(r"\*\*(\d+)\.\s*(.+?)\*\*\s*(.*)", payload, re.S)
            if m:
                rule_no += 1
                pdf.color = PALETTE[(rule_no - 1) % len(PALETTE)]
                pdf.rule_card(rule_no, m.group(2).strip(), m.group(3).strip())
            else:
                pdf.color = RULES_COLOR
                pdf.paragraph(payload, color=MUTED)


def render_session(pdf, blocks):
    pdf.add_page()
    i, n = 0, len(blocks)
    title_done = False
    while i < n:
        kind, payload = blocks[i]
        if kind == "h2":
            m = re.match(r"Sessione\s+(\d+)\s*[—-]\s*(.+)", payload)
            if m:
                num, title = m.group(1), m.group(2).strip()
                pdf.color = PALETTE[(int(num) - 1) % len(PALETTE)]
            else:
                num, title = "•", payload
                pdf.color = PALETTE[0]
            pdf.session_band(num, title)
            title_done = True
            # eventuale meta box subito dopo
            if i + 1 < n and blocks[i + 1][0] == "p" and "Durata" in blocks[i + 1][1]:
                pdf.info_box(blocks[i + 1][1])
                i += 1
        elif kind == "h3":
            if payload.lower().startswith("non fare"):
                # raccogli i paragrafi della sezione
                paras = []
                j = i + 1
                while j < n and blocks[j][0] in ("p", "ul"):
                    if blocks[j][0] == "p":
                        paras.append(blocks[j][1])
                    else:
                        paras.extend(blocks[j][1])
                    j += 1
                pdf.warn_box(payload, paras)
                i = j - 1
            else:
                pdf.subheading(payload)
        elif kind == "p":
            pdf.paragraph(payload)
        elif kind == "ul":
            pdf.bullets(payload)
        i += 1


pdf = PDF()
draw_cover(pdf)
for fname in FILES:
    blocks = parse_blocks((BASE / fname).read_text(encoding="utf-8"))
    if fname.startswith("00"):
        render_rules(pdf, blocks)
    else:
        render_session(pdf, blocks)

out = BASE / "corso-disegno-fumetto.pdf"
pdf.output(str(out))
print("PDF scritto:", out, out.stat().st_size, "bytes", "-", pdf.page_no(), "pagine")
