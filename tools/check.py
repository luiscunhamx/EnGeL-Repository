"""Automatic checks for every protocol. Run:  python3 tools/check.py   (exit code 1 if any ERROR).
ERROR = must be fixed; WARN = look at it (the unit and reagent checks are pattern-based and can flag false alarms).
Checks: YAML header; section order; [TO CONFIRM] (none allowed when status is released; Open questions present);
no personal e-mail addresses; Materials reagents used in the procedure and vice versa; quantities with units;
includes and internal links exist; version history and CHANGELOG match the version."""
import os, re, sys, glob, yaml
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from prerender import read_qmd, resolve_includes, section, ROOT
os.chdir(ROOT)

SECTIONS = ['Purpose and scope', 'Principle', 'Before you start', 'Materials', 'Reagent preparation', 'Procedure',
            'Calculations', 'Quality control', 'Data and metadata', 'Safety and waste', 'Troubleshooting', 'Remarks',
            'References', 'Version history and citation']
REQUIRED = ['title', 'protocol-id', 'version', 'date', 'status', 'area', 'author', 'license', 'hazards', 'equipment', 'reagents', 'version-history']
UNITS = r'(?:cm³|cm²|m²|m³|µL|mL|L|nL|°C|min|h|s|× g|x g|rpm|%|mm|cm|m|nm|µm|ng|µg|mg|g|kg|M|mM|µM|nM|pM|bp|kb|U|V|W|mbar|Pa|ng/µL|µg/mL|mg/mL|×)'
NOUNS = r'(?:samples?|wells?|tubes?|plates?|blanks?|times|extractions?|preps|loads?|columns?|rows?|positions?|washes|steps?|individuals|specimens|runs?|days?|weeks?|months?|years?|reactions?|legs?|cycles?|bees?|groups?|copies|replicates?|ul|µl|occurrences?|mismatch(es)?|times?|librar(y|ies)|flashes|pools?)'
EMAIL = re.compile(r'[\w.+-]+@[\w-]+\.[\w.-]+')
ALLOWED_EMAILS = set(l.strip() for l in open('data/allowed_emails.txt', encoding='utf-8') if l.strip() and not l.startswith('#')) if os.path.exists('data/allowed_emails.txt') else set()

errors, warns = [], []
def err(p, m): errors.append(f'ERROR {p}: {m}')
def warn(p, m): warns.append(f'WARN  {p}: {m}')

def names(meta):
    out = []
    for r in meta.get('reagents', []) or []:
        if isinstance(r, dict):
            if r.get('name'): out.append(r['name'])
            for c in r.get('components', []) or []:
                out.append(c.get('name', c.get('text')) if isinstance(c, dict) else c)
        else: out.append(r)
    return [str(x) for x in out if x]

for path in sorted(glob.glob('protocols/**/*.qmd', recursive=True)):
    meta, raw = read_qmd(path)
    base = os.path.dirname(path)
    for inc in re.findall(r'\{\{<\s*include\s+(\S+)\s*>\}\}', raw):
        if not os.path.exists(os.path.normpath(os.path.join(base, inc))): err(path, f'include not found: {inc}')
    try: body = resolve_includes(raw, base)
    except FileNotFoundError: continue
    for k in REQUIRED:
        if k not in meta: err(path, f'YAML field missing: {k}')
    pid = str(meta.get('protocol-id', ''))
    if pid and not re.match(r'^EnGeL-(MOLB|FAUNA|SOIL|EDNA|SAMPL|BIOINF)-[A-Z0-9-]+$', pid): err(path, f'protocol-id not in the EnGeL-[AREA]-[SHORT] form: {pid}')
    if pid and os.path.basename(path) != pid + '.qmd': err(path, f'file name should be {pid}.qmd')
    ver = str(meta.get('version', ''))
    if not re.match(r'^\d+\.\d+\.\d+$', ver): err(path, f'version is not semantic (X.Y.Z): {ver}')
    if not re.match(r'^\d{4}-\d{2}-\d{2}$', str(meta.get('date', ''))): err(path, 'date is not ISO (YYYY-MM-DD)')
    status = meta.get('status')
    if status not in ('draft', 'review', 'released', 'retired'): err(path, f'status must be draft, review, released or retired: {status}')
    hist = meta.get('version-history') or []
    if hist and str(hist[-1].get('version')) != str(meta.get('version')): err(path, f"version {meta.get('version')} differs from the last version-history entry {hist[-1].get('version')}")
    if hist and str(hist[-1].get('date')) != str(meta.get('date')): err(path, f"date {meta.get('date')} differs from the date of the last version-history entry {hist[-1].get('date')}")
    for g in (meta.get('ghs') or []):
        if g not in [f'GHS0{i}' for i in range(1, 10)]: err(path, f'unknown GHS pictogram code: {g} (use GHS01 to GHS09)')
    for a in meta.get('author', []) or []:
        o = a.get('orcid', '') if isinstance(a, dict) else ''
        if isinstance(a, dict) and a.get('no-orcid'): continue                         # confirmed: this person has no ORCID
        if not re.match(r'^\d{4}-\d{4}-\d{4}-\d{3}[\dX]$', str(o)): err(path, f'author without valid ORCID (or no-orcid: true, only if confirmed): {a}')
    auth_names = [a.get('name') if isinstance(a, dict) else str(a) for a in (meta.get('author') or [])]
    rev = meta.get('reviewed-by')
    if rev and rev in auth_names and auth_names[-1] != rev: err(path, f'the reviewer ({rev}) must be the last author')
    if meta.get('contributors'): warn(path, 'contributors field is no longer used: list everyone as authors, with their role')
    hist = meta.get('version-history', []) or []
    if not hist or str(hist[-1].get('version')) != ver: err(path, 'last entry of version-history does not match version')
    cl = open('CHANGELOG.md', encoding='utf-8').read() if os.path.exists('CHANGELOG.md') else ''
    if f'{pid} {ver}' not in cl: err(path, f'CHANGELOG.md has no entry "{pid} {ver}"')
    heads = re.findall(r'^## (.+?)\s*(?:\{.*\})?$', body, re.M)
    order = [h for h in heads if h in SECTIONS]
    missing = [s for s in SECTIONS if s not in heads]
    if missing: err(path, 'sections missing: ' + ', '.join(missing))
    if order != [s for s in SECTIONS if s in order]: err(path, 'sections not in template order')
    if 'Minimum to record' not in section(body, 'Data and metadata'): err(path, '"Minimum to record" block missing in Data and metadata')
    n_tc = len(re.findall(r'\[TO CONFIRM', body + str(meta)))
    if n_tc and status == 'released': err(path, f'{n_tc} [TO CONFIRM] left in a released protocol')
    if n_tc and not section(body, 'Open questions').strip(): err(path, f'{n_tc} [TO CONFIRM] but no Open questions section')
    for e in set(EMAIL.findall(raw + str(meta))):
        if e not in ALLOWED_EMAILS: err(path, f'e-mail address not on the allowed list (no personal e-mails): {e}')
    work = section(body, 'Procedure') + section(body, 'Reagent preparation')
    for n in names(meta):
        if n.lower() not in work.lower(): warn(path, f'reagent listed in Materials but not found in Procedure/Reagent preparation: {n}')
    known = ' '.join(names(meta)).lower()
    for b in set(re.findall(r'\b([A-Z][\w®-]*(?: [A-Z][\w®-]*)? Buffer)\b', work)):
        if b.lower() not in known: warn(path, f'used in procedure but not listed under Materials: {b}')
    proc = re.sub(r'```.*?```', '', section(body, 'Procedure'), flags=re.S)   # code blocks are not checked for units
    for line in proc.split('\n'):
        if line.startswith('|') or line.startswith('```'): continue
        clean = re.sub(r'`[^`]*`', '', re.sub(r'\[TO CONFIRM[^\]]*\]', '', line))
        for m in re.finditer(r'(?<![\w.~:#-])(?<!Annex )(?<!Section )(?<!step )(\d+(?:[.,]\d+)?(?: \d{3})*)(?![\w.-])(?!\s*(?:–|-|to)\s*\d)\s*(\S*)', clean):
            num, nxt = m.group(1), m.group(2)
            before = clean[:m.start()]
            if re.fullmatch(r'(19|20)\d\d', num): continue                            # years in citations
            if before.endswith((':', '–', '-')) or nxt.startswith(':') or re.search(r'\d\s?$', before): continue                 # ratios, e.g. 1:10 000
            if re.search(r'(count|QuantStudio|Standards?|S|Step|Annex|Section|Plate|Position|Segment|Qubit|Buffer|NWR|NSW|AW|MW|ins|UDP|iTru|iNext|Gen|v)\s?$', before): continue
            if nxt.rstrip(')').endswith((',', 'and', 'or')) or nxt in (',', 'and', 'or', '–', '-'):
                if re.search(UNITS, clean[m.end():]): continue                     # list ending in a unit: 20, 2 and 0.2 pM
            if re.match(r'^\(@\)', line) and m.start() < 4: continue
            if re.match('^' + UNITS + r'\b', nxt) or re.match('^' + UNITS + '$', nxt.rstrip('.,;:)')) or re.match('^' + NOUNS, nxt): continue
            if nxt.startswith(('×', '%', '/', '~', 'deep-well', '-well', '+', '=', 'F-bottom')): continue          # arithmetic (18 + 2 = 20), plate models
            if re.search(r'(filters?|Greiner|×)\s?$', before): continue                      # filter names (485-12, 520), plate models, 6 × 11
            warn(path, f'number without unit? "{num} {nxt}" in: {line.strip()[:80]}')
    for link in re.findall(r'\]\(([^)#]+\.qmd)\)', raw):
        if not link.startswith('http') and not os.path.exists(os.path.normpath(os.path.join(base, link))): err(path, f'broken link: {link}')

for f in glob.glob('includes/*.qmd') + glob.glob('*.qmd') + glob.glob('workflows/*.qmd'):
    for e in set(EMAIL.findall(open(f, encoding='utf-8').read())):
        if e not in ALLOWED_EMAILS: err(f, f'e-mail address not on the allowed list: {e}')

for l in errors + warns: print(l)
print(f'\n{len(errors)} error(s), {len(warns)} warning(s)')
sys.exit(1 if errors else 0)
