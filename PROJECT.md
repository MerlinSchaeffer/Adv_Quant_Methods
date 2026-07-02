# Course modernization project — Multiple OLS & Fundamentals of Causal Inference

Working notes so any new session (or collaborator) can pick this up. Last updated 2026-07-02.

## Goal
Modernize Merlin Schaeffer's BSc course website + lecture slides. The professor must be able to
operate, understand, and update everything himself. Style to preserve: **little text, lots of
visuals**, KU red (`#901A1E`) + KU/UCPH logos. Audience: 21-year-old sociology BSc students in Copenhagen.

## Decision (agreed)
**Migrate off Hugo + xaringan to a single Quarto toolchain** (Option A of the original proposal).
- Slides: xaringan/remark → **Quarto reveal.js**.
- Website (Hugo/Wowchemy "Academic", now abandonware, pinned to Hugo 0.89.4): replaced by a
  **Quarto website** — prototyped and working (see below).
- Approach: build a **proof-of-concept for one lecture first**, iterate on look + pedagogy, then roll
  the pattern out to the other 13 decks.

## Current state — DONE
The POC lives in **`quarto-poc/`** (self-contained, at repo root). It is a full migration of
**Lecture 6 (RCTs)** — originally `static/Lectures/6-RCTees/`:
- `6-RCTees.qmd` — the deck (35 slides), ported faithfully, then restyled, then **pedagogically
  edited**, then refined twice more with the professor (see "Second design pass" + "Feedback round").
- `exercise1.Rmd`, `exercise2.Rmd` — the two in-class exercises (still `webexercises`; embedded via iframe).
- `theme/ku.scss` — the modern KU reveal.js theme (see "Design system" below).
- `img/` — figures + KU/UCPH logos.
- `README.md` — how to render + gotchas.

**The Quarto website is now built** (in the same `quarto-poc/` folder — it is one Quarto project):
`_quarto.yml` (website project, KU navbar), `index.qmd` (home + hero + cards), `about.qmd`
(course description + the R setup steps), `lectures.qmd` (all 14 lectures; Lecture 6 links to its
slides + both exercises, the rest marked "coming soon"), `exam.qmd`, `resources.qmd`, and
`theme/ku-web.scss` (Bootstrap/cosmo + KU brand). `quarto render` builds the whole site into `_site/`,
including the reveal deck; deploy with `quarto publish netlify` (see `quarto-poc/README.md`).
Verified end-to-end in a browser: navbar/pages render, and the Lectures page opens the 32-slide deck.

What has been applied to the deck (the **template for the other 13**):
1. **Faithful port** — all R chunks, TikZ DAGs, `modelsummary`/`kableExtra` tables, `RefManageR`
   citations, panel-tabsets, incremental reveals, ggplot figures.
2. **Modern lean redesign** — Inter typography, hairline red rule under titles, booktabs tables,
   light GitHub code blocks, flat left-accent callouts, red inline code, refined title/section slides.
3. **Layout fixes** — bigger KU logo (watermark, top-right), slide number moved to bottom-right,
   R console output no longer wraps, **all slides verified to fit** (no vertical/horizontal overflow).
4. **Local countdown timer** — replaced external `letstimeit.com` iframes with a self-contained
   HTML/JS component (`<div class="ku-timer" data-min="15"></div>`); auto-starts on the slide.
5. **Font normalization** — consistent tiers: `.lead` (display) / base (body) / `.small` (dense) /
   `.backgrnote` (caption). Avoid the legacy `.font10…200` utilities.
6. **Pedagogical editing** (tone approved by professor):
   - Student-facing "By the end of today you can…" learning goals.
   - New "two parallel worlds" potential-outcomes table (counterfactuals) before any algebra.
   - Reframed the selection-bias equation in plain language.
   - Consolidated repetitive RCT slides; simplified the DAG explanation.
   - Rebuilt the coefficient plot (KU red, value labels, honest headline).
   - Replaced the wall-of-text summary with a one-line logic chain.
   - Added a bridge slide to multiple regression (next weeks).
   - **Ask-then-reveal boxes** — see convention below.

## Second design pass (2026-07-02, professor requested)
A refinement round over both the deck and the website. New conventions that the other 13 decks
**must follow** (all implemented in Lecture 6 + the two themes):
- **Title slide hierarchy:** deck YAML `title:` = the lecture topic (big), `subtitle:` = a one-line
  tagline. The course-name eyebrow above the title comes from CSS (`#title-slide .title::before`
  in `theme/ku.scss`) — one place to change it for all decks.
- **Per-slide wayfinding:** YAML sets `slide-number: c/t` and
  `footer: "Lecture N · <topic>"` (footer auto-hidden on the title slide, bottom-left, quiet).
- **Logo = the plain KU seal** (`img/ku_seal.png`, cropped from the official logo): the full
  wordmark logos contain a decorative rule that cut across slide content. Watermark top-right,
  translucent (0.55) so content that runs under it stays legible.
- **Part dividers:** each deck is split into ~3 named parts matching the learning goals. Divider =
  inverse slide with `[Part n of 3]{.part-pill}` + one `.lead` sentence. The goals slide notes
  "one part per goal".
- **Closing self-check slide:** "Check yourself: today's goals" — `::: {.checklist}` list (renders
  empty tick-boxes) mirroring the opening goals, plus a green box pointing to the weekly quiz +
  Friday exercise class.
- **Website components** (in `theme/ku-web.scss`, used via `{=html}` blocks): hero with `.eyebrow`;
  `.step-grid`/`.step` (weekly rhythm); `.card-grid`/`.kucard` (quick links); `.block-label`
  (thematic groups on Lectures page); `.badge-soon`; pill-style `.lecture .links a`;
  `.req-grid`/`.req` (exam requirements). Lectures page groups the 14 lectures into thematic blocks.
- **Homepage principle (professor):** no duplicate navigation — the hero has *no* buttons (the
  "Find your way" cards are the navigation), and the "New here? Start with About & setup" callout
  sits directly under the hero, before "Your week, every week".
- Site config: `open-graph: true`, site `description:`, navbar right "Absalon ↗" external link,
  favicon = the seal.
- **Known stale content to revisit:** exam deadline "12 January 2026" (about.qmd + exam.qmd) is
  last year's; the about.qmd "set up a Project" step needs a link once the 0-Prep deck is ported.
- **Setup steps fact-checked 2026-07-02** (about.qmd): R ≥ 4.6.0 (4.6.1 is current), RStudio
  ≥ 2026.06 (link now posit.co); dropped the GitHub `wbstats` install (repo renamed
  nset-ornl→gshs-ornl, CRAN version is current anyway); **added
  `remotes::install_github("xmarquez/democracyData")`** — it is used in Lecture 9 and was in the
  final checklist but was never actually installed by the old steps. All four GitHub installs
  verified to exist (masteringmetrics, ROS-Examples/rpackage, vdemdata, democracyData).

## Feedback round on the deck (2026-07-02, professor's 9 comments — all done)
These fixes are part of the template; apply the same standards to the other 13 decks:
- **Title slide:** author line flush left (Quarto pads `.quarto-title-author` — zeroed in ku.scss).
- **Footer size 0.4em** (professor explicitly wants 0.4em, not smaller), bottom-left at `left: 56px`
  (clear of reveal's slide-menu button), auto-hidden on the title slide.
- **Never put `.small` on a whole slide** (it shrinks the title too and makes slides look
  inconsistent). Wrap only the dense element (e.g. a balance table) in `::: {.small}`.
- **Research-question slide pattern:** two balanced columns — left: 1–2 context lines + the RQ in a
  blue box prefixed "**Research question of the day:**"; right: the evidence/figures + source.
  (The "SHOCKING NEWS" stock photo was dropped from this slide; professor did not object.)
- **Loose-list bullet bug fixed in ku.scss:** custom bullets are now absolutely positioned, so
  markdown lists with blank lines between items (`<li><p>` structure) align correctly. Don't work
  around it in content.
- **Callout audit done** — see colour code below (red is never a neutral statement).
- **Summary slide = TikZ one-line chain** (`Confounding → Randomize → Balanced groups → Raw
  difference = causal effect κ`), on a *white* slide so it matches the DAG style. "Randomize" is a
  filled KU-red node.
- **Closing order:** summary → "But what if you can't randomize?" (bridge) → "Check yourself" →
  references.
- **R code style = tidyverse style guide** in all *visible* chunks: one argument per line, 2-space
  indents, closing `)` on its own line, spaces around operators, aligned `case_when` arms,
  capitalized `#` comments, full argument names (e.g. `weights =`, not the partially-matched
  `weight =`). Apply this pass to every ported deck.

## Design system / conventions (keep consistent across all decks)
- **Callout colour code** (audited for consistency 2026-07-02):
  - **Blue box** (`.content-box-blue`) = a *question*; shown immediately. Prefix "**Discuss:**"
    (in-class question) or "**Research question of the day:**" (the lecture's running RQ).
  - **Red box** (`.content-box-red`) = either the *answer* to a blue box (always `.fragment`, so it
    appears on the next click) **or** a *warning*, prefixed "**Beware:**". Never a neutral statement.
  - **Green box** (`.content-box-green`) = a standalone positive *takeaway / result* (no Q/A pattern).
- **Type tiers:** `.lead` for big statements, base for body, `.small` for dense blocks, `.backgrnote`
  for captions/sources. Don't reach for `.fontNN`.
- **Inverse/section slides:** `## Title {.inverse background-color="#901A1E"}` (the `background-color`
  attribute is what makes the red full-bleed; the `.inverse` class flips text white + hides the logo).
- Citations: keep `RefManageR` inline (`Citet`, `PrintBibliography`) — no `@key` rewriting needed.

## Tooling / how to render
- **Quarto** must be installed. On the professor's Mac: `brew install --cask quarto` (the POC was
  built with a scratch copy of Quarto 1.9.38). Then, from `quarto-poc/`:
  - `quarto render exercise1.Rmd` and `quarto render exercise2.Rmd` → the embedded exercise HTML.
  - `quarto render 6-RCTees.qmd` → `6-RCTees.html`. Or just open the `.qmd` in RStudio and click Render.
- **R packages** beyond the existing course setup: `RefManageR`, `kableExtra`, `pacman`; for TikZ DAGs
  `magick` + `pdftools` (needs a TeX install — present on this machine). Exercises need `webexercises`.
  (`essentials` is NOT on CRAN for R 4.6 — its `as.scalar()` was replaced with base `unname()`.)

## Gotchas learned (important — bit us during the POC)
- **`execute: echo: true` is REQUIRED** in each deck's YAML. Without it Quarto silently drops *all*
  code echoes (slides render tables/plots but no source).
- **Render in a UTF-8 locale** (RStudio does this) or the Unicode minus in tables prints as `<U+2212>`.
  From a shell: `export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8`.
- **`. . .` pauses must be at the slide top level** — nested inside a `:::` div they render as literal dots.
  Use the `.fragment` class on a div instead when inside a column.
- Inverse full-bleed red needs the `background-color=` slide attribute (a CSS `background-color` only
  fills the content box).
- **Bug in `Stats_II.bib`**: entry `wiedner_local_2025` has an unbraced `title` (invalid strict BibTeX).
  `RefManageR` tolerates it; Pandoc citeproc would not. Worth fixing at some point.
- **TikZ: `step` is a reserved key** (grid spacing) — naming a node style `step/.style` fails with
  "The key '/tikz/step' requires a value". Use another name (we use `stage`).
- **Quarto auto-applies reveal's `r-stretch` to lone images**, which can collapse a wide/short image
  to 0 height. Put `{.nostretch}` on the slide heading when a figure vanishes.
- **Claude-session tooling:** rendering used a scratch Quarto 1.9.38 living in another session's
  scratchpad (`/private/tmp/claude-501/...3f2c8968.../scratchpad/quarto-dist/bin/quarto`) — this can
  be garbage-collected; install Quarto properly (`brew install --cask quarto`) before relying on it.
  For browser previews: macOS TCC blocks the preview server from reading `~/Documents`, so
  `.claude/launch.json` serves a copy of `_site/` rsynced into the session scratchpad — after every
  render, rsync `_site/` to the directory named in launch.json.

## Original source (for reference when migrating the rest)
- Hugo site: `config/`, `content/` (Lectures landing pages `.Rmd`), `static/Lectures/<n>-.../` = the
  actual xaringan decks + `exercise*.Rmd`. Theme CSS: `static/Lectures/template/Merlin169.css`.
- 14 lecture decks + a `0-Prep` deck. Data via V-Dem / World Bank APIs and local `assets/*.RData`.
- Repo is ~1 GB (committed rendered HTML, libs, caches, PDFs) — worth a cleanup pass.

## Next steps
1. ~~POC deck look + pedagogy~~ — done, professor approved (incl. two refinement rounds).
2. ~~Quarto website prototype~~ — done, refined, verified.
3. **Commit the current state to git** — everything in `quarto-poc/` + this file is still
   untracked. Do this before starting the rollout. *(recommended immediate next step)*
4. **Roll the template out to the other 13 decks** (faithful port → restyle → pedagogical edit →
   the feedback-round standards above), adding each to `lectures.qmd` + `_quarto.yml` `render:` as
   it lands. Suggested order: teaching order (1 → 14), so the site is usable from week 1 of the
   semester; Lecture 1 (`1-Intro/1-Introduction.Rmd`, 623 lines) is also the lightest full deck —
   a good second data point for the template. The DAG/IV/RDD decks (7, 10, 13) are the heaviest.
5. Content updates the professor must supply: new exam deadline (replaces 12 Jan 2026 on
   about/exam pages); link the 0-Prep setup deck once ported.
6. Polish the website (per-lecture landing pages with readings if wanted; a Quarto `listing`
   instead of the hand-written lecture list; first real Netlify deploy).
7. Optional: repo hygiene (git-ignore rendered artifacts; shrink the 1 GB checkout; fix the
   `wiedner_local_2025` bib entry); install Quarto via brew instead of the scratch copy.
