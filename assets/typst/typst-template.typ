// EnGeL-UC protocol layout (Option A "Continuity"): A4, Source Sans 3, forest green headings.
#let forest = rgb("#074023")
#let leaf = rgb("#72BF44")
#let grey = rgb("#5F6661")
#let rule = rgb("#C9CFCB")
#let tint = rgb("#F1F4F1")

#let article(
  title: none,
  subtitle: none,
  authors: none,
  date: none,
  abstract: none,
  abstract-title: none,
  cols: 1,
  margin: (x: 22mm, top: 25mm, bottom: 24mm),
  paper: "a4",
  lang: "en",
  region: "GB",
  font: ("Source Sans 3",),
  fontsize: 10pt,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  protocol-id: none,
  short-title: none,
  version: none,
  licence: "CC BY 4.0",
  assets: "../../assets",
  bench: false,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    header: context {
      if counter(page).get().first() > 1 or bench {
        set text(size: 8pt, fill: grey)
        grid(columns: (1fr, auto), align: (left + horizon, right + horizon),
          [#text(weight: "bold", fill: forest)[#protocol-id] #if short-title != none [· #short-title]],
          image(assets + "/logos/engel_mark.png", height: 7mm))
        v(-2mm)
        line(length: 100%, stroke: 0.4pt + rule)
      }
    },
    footer: context {
      set text(size: 8pt, fill: grey)
      let n = counter(page).get().first()
      let total = counter(page).final().first()
      if n == 1 and not bench {
        align(center, image(assets + "/logos/partners_strip.png", width: 150mm))
        v(1mm)
      }
      line(length: 100%, stroke: 0.4pt + rule)
      grid(columns: (1fr, auto),
        [EnGeL-UC · #protocol-id · version #version · #licence],
        [Page #n of #total])
    },
  )
  set par(justify: false, leading: 0.6em)
  set text(lang: lang, region: region, font: font, size: fontsize, hyphenate: true)
  show raw: set text(font: ("IBM Plex Mono",), size: 0.9em)
  set heading(numbering: sectionnumbering)
  show heading: set text(fill: forest)
  show heading.where(level: 1): it => {
    v(0.8em)
    block(width: 100%, below: 0.6em, stroke: (bottom: 1.2pt + leaf), inset: (bottom: 3pt))[#text(size: 1.25em, weight: "bold")[#it]]
  }
  show heading.where(level: 2): set text(size: 1.05em)
  set table(stroke: 0.4pt + rule, inset: 5pt, fill: (x, y) => if y == 0 { tint })
  show table: set text(size: 0.92em)

  if not bench {
    image(assets + "/logos/engel_logo.png", height: 26mm)
    v(4mm)
    line(length: 100%, stroke: 1.5pt + leaf)
    v(3mm)
    text(size: 9pt, weight: "bold", fill: grey, tracking: 0.08em)[STANDARD OPERATING PROTOCOL · #protocol-id]
    v(1mm)
  }
  if title != none {
    block(below: 1.2em)[#text(size: if bench { 15pt } else { 20pt }, weight: "bold", fill: forest)[#title]]
  }
  if toc {
    outline(title: toc_title, depth: toc_depth, indent: toc_indent)
  }
  doc
}
