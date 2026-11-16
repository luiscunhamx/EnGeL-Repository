#show: doc => article(
$if(title)$
  title: [$title$],
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
$if(margin)$
  margin: ($for(margin/pairs)$$margin.key$: $margin.value$,$endfor$),
$endif$
$if(papersize)$
  paper: "$papersize$",
$endif$
$if(mainfont)$
  font: ("$mainfont$",),
$endif$
$if(fontsize)$
  fontsize: $fontsize$,
$endif$
$if(section-numbering)$
  sectionnumbering: "$section-numbering$",
$endif$
$if(protocol-id)$
  protocol-id: "$protocol-id$",
$endif$
$if(short-title)$
  short-title: [$short-title$],
$endif$
$if(version)$
  version: "$version$",
$endif$
$if(engel-assets)$
  assets: "$engel-assets$",
$endif$
$if(engel-bench)$
  bench: true,
$endif$
  doc,
)
