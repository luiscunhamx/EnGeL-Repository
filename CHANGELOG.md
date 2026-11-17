# Changelog

All changes to the protocols and the handbook. Newest first. Each entry starts with the protocol ID and its new version.
Version rule: patch (x.y.**Z**) = wording; minor (x.**Y**.0) = steps or values; major (**X**.0.0) = method change.

## Unreleased

- Register and home page: new area “Sampling and experimental design” (SAMPL) with four planned protocols (design, sampling effort, field sampling, sample registration).
- check.py: header date and version must match the last version-history entry (dates of DNA-BEE, NAQC, RNA, MAR-MORPH corrected to 2026-11-17).
- GHS pictograms (assets/ghs, public domain) shown in the hazards row from a new `ghs:` header field; check.py validates the codes.
- EnGeL-FAUNA-MAR-MORPH 1.0.2 (2026-11-17): GHS pictograms (flame, exclamation mark) for ethanol 96%.
- EnGeL-MOLB-DNA-BEE 1.0.1 (2026-11-17): contributor Yevhenia Shcheka (source protocol, written in the lab).
- EnGeL-MOLB-NAQC 1.1.1 (2026-11-17): oRCID of contributor Diogo Fonseca.
- EnGeL-MOLB-RNA 1.2.2 (2026-11-17): author of the bee protocol identified as Artur Sarmento, with ORCID (the source was signed “FFR”).
- Website: clearer sidebar (section headings, current-page marker, short titles in workflow order; generated from the protocols).
- Website: home page presents the lab (statement from envigenomics.eu, cards per area with protocol counts); People page generated from data/people.yml and the protocols.
- Register: EnGeL-MOLB-MB-EW (earthworm metabarcoding, multiplex marker) added as planned.
- EnGeL-MOLB-MB 1.2.1 (2026-11-16): schematic of the two-step PCR and library structure (figure).
- EnGeL-FAUNA-MAR-MORPH 1.0.1 (2026-11-16): schematic of the MacFadyen extraction set-up (figure); ORCIDs of Filipa Reis and Pedro Martins.
- EnGeL-MOLB-DNA-MAG 1.1.2 (2026-11-16): schematic of the extraction steps (figure).
- Publish workflow deploys with GitHub Pages actions (Pages source: GitHub Actions); no gh-pages branch needed.
- EnGeL-MOLB-MB 1.2.0 (2026-11-16): back to the iTru system used in the lab (TruSeq-type phased primers; iTru5/iTru7 indexes, 5 µM, 0.7 µL each); PCR1 DNA 1–3 µL.
- EnGeL-MOLB-RNA 1.2.1 (2026-11-16): extra 100% ethanol wash confirmed.
- EnGeL-MOLB-RNA 1.2.0 (2026-11-16): isopod dry spin at ≥ 12 000 × g.
- EnGeL-MOLB-MB 1.1.0 (2026-11-16): adapters and indexes follow the BENCHMARKS handbook (Nextera-type overhangs; Adapterama iNext5/iNext7, 10 µM, 0.7 µL each).
- EnGeL-BIOINF-OBITOOLS4 1.0.1 (2026-11-16): clustering at 96%, to be adapted to the group's intraspecific variability.
- EnGeL-MOLB-RNA 1.1.0 (2026-11-16): isopod speeds in × g (RNeasy handbook equivalence).
- EnGeL-MOLB-NAQC 1.1.0 (2026-11-16): PicoGreen lambda stock and standard curve checked against the manual.
- EnGeL-MOLB-MB 1.0.0 (2026-11-16): first version (draft); merges the UC nematode and microarthropod metabarcoding protocols with a primer table.
- EnGeL-FAUNA-MAR-MORPH 1.0.0 (2026-11-16): first version (draft), from the UC microarthropod sampling and sorting protocol.
- EnGeL-MOLB-DNA-COL 1.0.0 (2026-11-16): first version (draft), NZY Tissue spin columns.
- EnGeL-MOLB-NAQC 1.0.0 (2026-11-16): first version (draft), NanoDrop, Qubit and PicoGreen.
- EnGeL-MOLB-KAPA 1.0.0 (2026-11-16): first version (draft), KAPA library quantification.
- EnGeL-MOLB-RNA 1.0.0 (2026-11-16): first version (draft), TRIzol RNA for bees and isopod hepatopancreas (translated).
- EnGeL-MOLB-DNA-BARC 1.0.0 (2026-11-16): first version (draft), DNeasy for single specimens.
- EnGeL-MOLB-DNA-BEE 1.0.0 (2026-11-16): first version (draft), honey bee guts with NZY Soil kit.
- EnGeL-BIOINF-OBITOOLS4 1.0.0 (2026-11-16): first version (draft), from the lab's OBITools4 script.
- Includes: new `_kapa-qpcr`, `_kapa-run-qc`, `_kapa-calculation` (shared by EnGeL-MOLB-KAPA and EnGeL-MOLB-MB). Filter: contributors row. Checks: fewer false unit warnings (ratios, lists, years, code).
- Handbook: EnGeL-BIOINF-OBITOOLS4 added to the planned protocols and the soil fauna metabarcoding workflow.
- EnGeL-MOLB-DNA-MAG 1.1.1 (2026-11-16): DNA extracts get their own EnGeL code (source code kept in a separate column); unused or expired kit reagents to the red bin.
- Handbook: `.vscode/` with recommended extensions (Quarto, GitHub Pull Requests) and shared Git settings; VS Code section in CONTRIBUTING.
- EnGeL-MOLB-DNA-MAG 1.1.0 (2026-11-16): lab contact; waste routes; DNA concentration rule; sample master data and Lab Pipeline records; lab rules and end-of-work routine.
- Includes: new `_waste-streams`, `_before-you-leave`; `_safety-general` now carries the EnGeL lab rules (from the lab signs).
- EnGeL-MOLB-DNA-MAG 1.0.0 (2026-11-16): first version (draft), from the InviGenius robot protocol and the UC BENCHMARKS extraction sections.
- Handbook: Quarto project set up (website, PDF, Word, bench sheets; automatic checks).
