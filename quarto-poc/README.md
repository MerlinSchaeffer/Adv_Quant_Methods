# Quarto course site + Lecture 6 (RCTs) proof-of-concept

A **Quarto website** that replaces the old Hugo/Wowchemy site, plus a fully migrated
**Quarto reveal.js** deck for Lecture 6 — the template for porting the rest of the course.

## What's here
**Website** (`quarto render` builds it all into `_site/`):
- `_quarto.yml` — website project config (navbar, KU theme, which pages to render).
- `index.qmd` · `about.qmd` · `lectures.qmd` · `exam.qmd` · `resources.qmd` — the site pages
  (content carried over from the old Hugo `content/`).
- `theme/ku-web.scss` — KU brand theme for the HTML pages (Bootstrap/cosmo based).

**Lecture 6 deck:**
- `6-RCTees.qmd` — the deck (ported from `6-RCTees.Rmd`, restyled, pedagogically edited).
- `exercise1.Rmd`, `exercise2.Rmd` — the in-class exercises (`webexercises`; embedded via `<iframe>`).
- `theme/ku.scss` — KU reveal.js slide theme (port of `static/Lectures/template/Merlin169.css`).
- `img/` — figures + KU/UCPH logos.

Data (`../assets/APAD.RData`) and bibliography (`../Stats_II.bib`) are read from the repo,
so this folder lives at the repo root.

## Deploying the site
The site needs R + TeX to render, so build **locally**, then upload the finished `_site/`:
```sh
quarto render exercise1.Rmd && quarto render exercise2.Rmd   # exercises -> HTML (once)
quarto render                                                # builds the whole site into _site/
quarto publish netlify                                       # uploads _site to Netlify
```
(`_site/` is git-ignored; `quarto publish` pushes the pre-rendered output, so Netlify doesn't need
R/Quarto installed.)

## How to render it yourself
1. Install Quarto once: `brew install --cask quarto` (or the .pkg from quarto.org). Check: `quarto --version`.
2. From this folder:
   ```sh
   quarto render exercise1.Rmd   # produces exercise1.html  (needs R + rmarkdown)
   quarto render exercise2.Rmd   # produces exercise2.html
   quarto render 6-RCTees.qmd    # produces 6-RCTees.html
   ```
   Or, in RStudio, just open `6-RCTees.qmd` and click **Render** (live preview works too).
3. Open `6-RCTees.html` in a browser. `E` = speaker notes off/on, `F` = fullscreen, `O` = slide overview.

## R packages this deck needs
Beyond your existing course setup: `RefManageR`, `kableExtra`, `pacman`, and — for the TikZ DAGs —
`magick` + `pdftools` (TeX Live must be installed, which it is on this machine).
`exercise*.Rmd` additionally need `webexercises`.

## Gotchas worth knowing (learned building this)
- **`execute: echo: true` is required in the YAML.** Without it, Quarto does *not* honour
  `knitr::opts_chunk$set()`'s echo default and silently drops **all** code echoes — the slides
  render with tables/plots but no source. This one line is essential for every deck.
- Render in a **UTF-8 locale** (RStudio does this automatically) or the Unicode minus in tables
  prints as `<U+2212>`.
- Inverse/section slides get their full-bleed red from `background-color="#901A1E"` on the heading
  (a CSS `background-color` only fills the content box, not the whole slide).

## Notes / decisions
- Citations use **RefManageR** inline (`Citet`, `PrintBibliography`), exactly like the originals —
  so no `@key` rewriting was needed. (Quarto-native `@key` citations are an option later.)
- TikZ chunks render unchanged via knitr under Quarto.
- Render in a **UTF-8 locale** (RStudio does this) or the Unicode minus in tables prints as `<U+2212>`.
- One pre-existing bug surfaced: `Stats_II.bib` entry `wiedner_local_2025` has an unbraced `title`
  (invalid strict BibTeX). RefManageR tolerates it; Pandoc citeproc would not. Worth fixing.
