"""Builds assets/reference.docx (styles for Word output) from pandoc's default reference document.
Run once, or after changing the house style:  python3 tools/make_reference_docx.py <pandoc-default-reference.docx>
Get the default with:  quarto pandoc -o x --print-default-data-file reference.docx > default.docx"""
import sys
from docx import Document
from docx.shared import Pt, RGBColor, Mm
from docx.enum.text import WD_COLOR_INDEX
from docx.enum.style import WD_STYLE_TYPE
FOREST = RGBColor(0x07, 0x40, 0x23)
d = Document(sys.argv[1])
for s in d.styles:
    if s.type in (WD_STYLE_TYPE.PARAGRAPH, WD_STYLE_TYPE.CHARACTER) and s.font is not None:
        if s.name in ('Source Code', 'Verbatim Char'):
            s.font.name = 'IBM Plex Mono'
        else:
            s.font.name = 'Source Sans 3'
for name in ('Heading 1', 'Heading 2', 'Heading 3', 'Title', 'Subtitle'):
    if name in [s.name for s in d.styles]:
        st = d.styles[name]; st.font.color.rgb = FOREST; st.font.bold = True
d.styles['Normal'].font.size = Pt(10.5)
if 'To confirm' not in [s.name for s in d.styles]:
    tc = d.styles.add_style('To confirm', WD_STYLE_TYPE.CHARACTER)
    tc.font.highlight_color = WD_COLOR_INDEX.YELLOW
for sec in d.sections:
    sec.page_width, sec.page_height = Mm(210), Mm(297)
    sec.left_margin = sec.right_margin = Mm(22); sec.top_margin = Mm(25); sec.bottom_margin = Mm(24)
d.save('assets/reference.docx')
print('assets/reference.docx written')
