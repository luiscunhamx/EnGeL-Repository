# EnGeL-UC Lab Protocols

Standard operating protocols of the **Environmental Genomics Laboratory (EnGeL-UC)**, Centre for Functional Ecology, University of Coimbra.
Each protocol is one Quarto Markdown file (`.qmd`). The website, PDFs, Word files and bench sheets are generated from it.

Website (after the first release): <https://luiscunhamx.github.io/EnGeL-Repository/>

## Folders

| Folder / file | Contents |
|---|---|
| `protocols/<area>/<ID>.qmd` | One file per protocol, YAML metadata at the top |
| `includes/_*.qmd` | Text used in several protocols (contamination control, safety, plate map, …). Change it once, it changes everywhere |
| `workflows/` | Pages that chain protocols (sampling → extraction → library → sequencing → bioinformatics) |
| `_templates/protocol-template.qmd` | Starting point for a new protocol |
| `data/planned.yml` | Planned protocols shown in the register |
| `data/people.yml` | People page: name, role, ORCID, optional short biography (no e-mails or phone numbers). Protocol roles are read from the protocols |
| `data/allowed_emails.txt` | Shared lab addresses allowed on protocol pages |
| `assets/` | Fonts, logos, styles, PDF layout, Word reference document |
| `assets/figures/` | Schematic figures (SVG), drawn from the protocol text; CC BY 4.0, credited as “Figure: EnGeL-UC”. Edit them in any SVG editor (e.g. Inkscape); keep values identical to the protocol |
| `tools/` | `prerender.py` (register, bench sheets, list of values to confirm), `check.py` (automatic checks), `engel.lua` (layout filter) |
| `CHANGELOG.md` | Every change, with protocol ID and version |

Generated, not edited: `register.qmd`, `bench/*-bench.qmd`, `to-confirm.qmd` and `to-confirm.csv`, `people.qmd`, `_area-cards.qmd` (home page cards; committed, because Quarto reads includes before the generator runs: commit it after a render), and the sidebar block in `_quarto.yml` (short titles, order set in `SIDEBAR_ORDER` in `tools/prerender.py`; a change shows on the next render) (every open [TO CONFIRM], per protocol, with line numbers), `_site/`.

Figures in a protocol: `![Caption ending with the credit.](../../assets/figures/<file>.svg){#fig-<name> fig-alt="Description for screen readers" width="100%"}`. Every figure needs a caption, alt text and a credit; figures from papers or kit manuals only if their licence allows it.

Status values: `draft`, `review`, `released`, `retired`. Workflow diagrams are Mermaid flowcharts inside the workflow pages (`workflows/*.qmd`).

## Build

Needs [Quarto](https://quarto.org) ≥ 1.6 and Python 3 with PyYAML (`pip install pyyaml`).

```
quarto render          # checks + register + bench sheets + website, PDFs and Word files in _site/
quarto preview         # same, opens the site in the browser and refreshes while you edit
python tools/check.py  # checks only
```

`quarto render` stops if `tools/check.py` finds an error (missing section, personal e-mail, [TO CONFIRM] left in a released protocol, version without CHANGELOG entry, …). Warnings are printed but do not stop the build.

## Rules (short)

- Never guess: values not in the sources are written `[TO CONFIRM]` and listed under *Open questions*.
- Keep the lab's wording. Protocols are general; project notes go in *Remarks*.
- No personal e-mail addresses. SI units with a space (10 µL, 4 °C, 15 000 × g). ISO dates. British English.
- Quality-control acceptance criteria come only from the lab.
- Paraphrase and cite ISO standards and kit manuals; never copy their text. Ask before reusing manufacturers' figures.
- Kit manuals, old SOPs, literature and data are **not** stored in this repository.
- Every change: version bump in the YAML (`version` + `version-history`) and a line in `CHANGELOG.md`.

How to contribute: see [CONTRIBUTING.md](CONTRIBUTING.md).

## Releases and DOI

A release (GitHub → Releases → *Draft a new release*, tag `vYYYY.MM`) publishes the website and, once the Zenodo–GitHub integration is switched on, gets a DOI for the whole handbook. Protocols in a release should have status `released` and no `[TO CONFIRM]`.

## Licence

Text CC BY 4.0 (`LICENSE`), code MIT (`LICENSE-CODE`), fonts SIL OFL; logos belong to their institutions. See `LICENSES.md`.
