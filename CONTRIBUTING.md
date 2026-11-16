# How to contribute (short guide for the lab)

You do not need to install anything to suggest a change: everything below works in the browser on GitHub.

## Fix or improve a protocol

1. Open the protocol on the website and click **Edit this page** (right-hand side), or open the file in `protocols/` on GitHub and click the pencil.
2. Make the change. Keep the lab's wording; write `[TO CONFIRM]` for anything you are not sure of.
3. In the YAML at the top: raise `version` (wording → 1.0.**1**; steps or values → 1.**1**.0; method change → **2**.0.0) and add a line under `version-history`.
4. Add the same line to `CHANGELOG.md`, e.g. `- EnGeL-MOLB-DNA-MAG 1.1.0 (2026-12-01): lysis time changed to 2 h.`
5. At the bottom choose **Create a new branch … and start a pull request**, and describe what you changed and why.
6. The automatic checks run on your pull request (green tick or red cross with the reason). Luís or a technician reviews and merges it.

## Ask a question or report a problem

Use **Report an issue** on the protocol page (or *Issues* on GitHub). Say which protocol, which step, and what is wrong.

## Write a new protocol

- Copy `_templates/protocol-template.qmd` to `protocols/<area>/<ID>.qmd` and fill it in, or hand in your draft in Word (on the EnGeL template) and it will be converted once.
- Reuse the text in `includes/` instead of copying it (e.g. `{{< include ../../includes/_contamination-control.qmd >}}`).
- Steps are written `(@) …` so they are numbered through the whole procedure.
- Add the protocol to `CHANGELOG.md`, and remove it from `data/planned.yml` if it was listed there.

## Never commit

Kit manuals, ISO standards, papers, raw data, personal e-mail addresses or phone numbers.
