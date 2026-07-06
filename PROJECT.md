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
- `1-Introduction.qmd` — **Lecture 1 (40 slides), the first rollout deck (2026-07-02)**: faithful
  port restructured into the template (goals → 3 part dividers → self-check; boxes per the colour
  code; local `ku-timer` break; images in `img/L1/` — per-lecture image subfolders are the
  convention from now on). Port notes: the two old "4 types of research questions" slides were
  merged into one ask-then-reveal slide; TA table + recommendations merged into one "Course
  structure" slide; the dead hotlinked Legewie coefficient-plot GIF (uchicago 403s hotlinks — also
  broken in the old deck) was dropped, as was the full-bleed stock-photo "research agenda" slide
  (now a clean inverse slide); Task 1 says R ≥ 4.6.0 to match about.qmd. **Check external images
  when porting** — test every hotlinked URL (`curl -sIL`), and localize or drop dead ones.
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
- **Weekly readings (added 2026-07-06):** each migrated lecture in `lectures.qmd` carries a
  `<ul class="readings">` with one `<li>` per source (styled in `ku-web.scss`: red bullet +
  a `.rtag` badge — `.rtag-read` / `.rtag-skim`). "Your week, every week" on `index.qmd` leads
  with a **Readings** step card pointing there. Which chapters/pages to read are **bold** at the
  end of each book citation.
  - **Citations are FULL ASA style (deliberate — the professor is a sociologist and wants students
    to learn good academic conduct):** full first names; year straight after author; book =
    *Italic Title*. City, ST/Country: Publisher; article = "Quoted Headline-Case Title." *Journal*
    Vol(Issue):Pages. with a clickable `doi:` link. **All 14 lectures already have their readings**
    (even the not-yet-ported ones, so students can prepare) — done 2026-07-06.
  - **When porting/citing, verify against Crossref, don't trust the bib:** the old Hugo landing
    pages had only shorthand (`@key[Ch. x]`) and `Stats_II.bib` is often incomplete/mangled (the
    Schaeffer & Kas article was "n/a" volume → real is *Political Psychology* 46(3):623–636;
    Chetty had no DOI; `veaux_stats_2021` author field is garbled). `curl -s
    https://api.crossref.org/works/<DOI>` (or `?query.bibliographic=…`) gets the real
    volume/issue/pages/DOI.
  - Readings sourced from `content/Lectures/<n>/*.Rmd` ("## Readings"). Core texts: De Veaux,
    Velleman & Bock, *Stats: Data and Models* (Global ed., Pearson 2021); Angrist & Pischke,
    *Mastering 'Metrics* (Princeton UP 2014); Huntington-Klein, *The Effect* (CRC 2022, free at
    theeffectbook.net).
- Site config: `open-graph: true`, site `description:`, navbar right "Absalon ↗" external link,
  favicon = the seal.
- ~~Stale exam deadline~~ — professor supplied the new date 2026-07-02: **14 January 2027, noon**
  (updated in about.qmd + exam.qmd). Still open: the about.qmd "set up a Project" step needs a link
  once the 0-Prep deck is ported.
- **TA team 2026/27 (professor, 2026-07-02):** Sofie (Fri 8–10, CSS 2-2-49), Natalie (Fri 10–12,
  CSS 2-0-30), Joakim (Fri 10–12, CSS 2-0-42) — in the L1 "Course structure" slide and the
  about.qmd schedule table. Halfdan is out; update any other mention found while porting decks.
- **Book covers localized** (`img/L1/cover_stats.jpg`, `cover_metrics.jpg`, pulled from the Saxo
  CDN which blocks in-browser hotlinking) — reuse these files whenever a deck shows the textbooks.
- **Setup steps fact-checked 2026-07-02** (about.qmd): R ≥ 4.6.0 (4.6.1 is current), RStudio
  ≥ 2026.06 (link now posit.co); dropped the GitHub `wbstats` install (repo renamed
  nset-ornl→gshs-ornl, CRAN version is current anyway); **added
  `remotes::install_github("xmarquez/democracyData")`** — it is used in Lecture 9 and was in the
  final checklist but was never actually installed by the old steps. All four GitHub installs
  verified to exist (masteringmetrics, ROS-Examples/rpackage, vdemdata, democracyData).

## Lecture 3 (2026-07-06) — Randomness & statistical inference
`3-Random.qmd` (32 slides) + `3-exercise1/2.Rmd`. The course's hardest lecture conceptually;
kept the full pedagogical build but modernised the code.
- **3-part structure:** (1) random samples & weights, (2) sampling error & the standard error,
  (3) confidence intervals & hypothesis tests. Running question: does education predict political
  efficacy (`psppsgva`)? Answered at the end with a weighted full-sample regression
  (β≈0.025, t≈3.2, p≈0.0015 — significant).
- **Sampling-distribution build (the crux):** pretend ESS = population → true β; draw one n=50
  sample → different β̂; draw another → different again; **`replicate(1000, …)`** → live
  histogram (bell curve, true β + ±1.96·SD marked); Gauss → estimate the SE from ONE sample
  (its SE ≈ the 1000-sample SD).
- **Animations (professor wanted them back, then refined, 2026-07-06):** FOUR GIFs drive the
  build-up — `anim_samples.gif` (sample lines fanning around the truth), `anim_hist.gif` (a
  **dot-plot** where each dot = one sample's slope, revealed one-per-frame at fps 8 so the unit is
  unmistakable, bell emerging), `anim_ci.gif` (100 slope-CIs stacking, red = misses, live
  coverage-% counter → ~95%), and `anim_band.gif` (sample regression **lines** accumulating under a
  95% CI band — pairs with the "Uncertainty, drawn" slide; the professor asked to show the sloped
  lines beneath the interval). **PRE-RENDERED once** by `img/L3/make_animations.R`
  (needs `gganimate`+`gifski`) and committed as assets; the **deck just `include_graphics()`es
  them, so a normal deck render needs neither package.** Regenerate only if the data/story change:
  `cd quarto-poc && Rscript img/L3/make_animations.R` (UTF-8 locale). GIF labels stay plain ASCII
  ("beta", "|") — the raster device + Inter font mangle Greek/unicode glyphs, and keep subtitles
  short or they clip at the canvas edge.
- **Dropped heavy deps from the deck render itself:** `fixest`, `ggforce`, `essentials`.
  `essentials::as.scalar()` → base `unname()` everywhere.
- **Data:** local SPSS file `../assets/ESS9e03_1.sav` (ESS round 9, Danish subset, 52 MB) read
  with `haven::read_spss()` + `zap_labels()`. NOT an API — so the exercises' "Stuck?" box is about
  file placement in the project folder, and there is no cached-RDS fallback (students download the
  .sav from Absalon).
- Exercises follow the 8-point template (police/legal-system trust ~ education, weighted vs
  unweighted; t/p/CI reading). Both verified: solutions open, comma-tolerant blanks, MCQs.

## Lecture 2 (2026-07-04) — ported WITH a professor-approved didactic redesign
`2-Corr-n-Reg.qmd` + `2-exercise1.Rmd` + `2-exercise2.Rmd` (30 slides). Not a faithful port —
the professor found the old "socialism vs. democratic freedom" story "holprig" and approved:
- **New operationalisation of socialism:** the hand-coded 40-line Wikipedia index is GONE
  (deck + exercises). Instead: V-Dem `v2clstown` ("state ownership of the economy"),
  reversed so higher = more state control (`state_control = -v2clstown`). A dedicated slide
  defines socialism and justifies the operationalisation (valid/reliable/comparable), with an
  ask-then-reveal on why self-declared labels fail. Face-validity "sanity check" tab (extremes
  bar chart: Japan … North Korea, Denmark highlighted).
- **The "triangle" is the thread device:** 3 variables (state control, freedom `v2xcl_rol`,
  poverty), 3 edges. TikZ triangle map after the RQ: edge 1 = lecture, edges 2–3 = exercises
  (each exercise's subtitle names its edge); a closing "verdict" slide completes the triangle.
  Punchline (live data, checked): r(state control, poverty) ≈ +0.13, r(freedom, poverty) ≈ −0.33,
  r(state control, freedom) ≈ −0.69 → **no freedom–equality trade-off**.
- **World Bank content updated:** the international poverty line is now **$3.00/day (2021 PPP)**
  (changed June 2025; SI.POV.DDAY returns the new line) — PPP box recomputed (≈ kr. 20/day,
  kr. 600/month). The WB API also has outages (hit one while building) — worth a cached-data
  fallback someday.
- **Exercise files are now per-lecture:** `<N>-exercise<k>.Rmd/html` (L6's renamed to
  `6-exercise*`; deck iframes + lectures.qmd + `_quarto.yml` resources glob updated).
  Exercises no longer use the `essentials` package.
- Dropped: "Goal of empirical sociology" slide (already in L1 + L6), the third break,
  dead/stock transition images. External images localized into `img/L2/`.

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

## Exercise conventions (2026-07-04, professor approved — template for all decks)
Implemented in `2-exercise*` and retrofitted to `6-exercise*`:
1. **No slide transcription:** boilerplate code is printed in the exercise to copy; students
   *write only the line that practices the day's concept* (L2: the `inner_join()`), with a
   hidden Hint + Solution.
2. **Predict-before-compute MCQ:** before `cor()`/regressions, students commit to a rough
   estimate from the plot (options spaced widely so data drift can't flip the answer).
3. **`num_fitb()` helper** (defined in each exercise's setup): fill-in-the-blank accepts point
   AND comma decimals (Danish keyboards). Never use raw `fitb()` for numbers.
4. **Write-then-compare:** after key statistics, students write a one-sentence interpretation
   as a `# comment`, then open a hidden "Model answer" (names direction, size, units; no causal
   language) — trains the exam skill.
5. **"Stuck?" box** after the setup task: p_load check, restart-R advice, data fallback,
   t-R-ouble forum link. L2's fallback: `readRDS(url(".../data/Dat_L2.rds"))` — the cache lives
   in `quarto-poc/data/` (in `_quarto.yml` resources), regenerate it when re-rendering the deck
   with fresh data; URL currently points at the netlify.app domain — update on domain switch.
6. **Bonus task "for the fast"** with hidden solution (L2: `anti_join()` missing-countries
   investigation; robustness check without China/Vietnam).
7. **Scaffolded closing discussion** (3 concrete stepping stones + hidden talking points).
8. **"You practice: …" line in the subtitle** naming the skills.
Also: solutions say "don't peek" (typo fixed), full `weights =` argument, AI references say
ChatGPT/Gemini (Bard is dead). REMEMBER: render exercises with `rmarkdown::render()` only.

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

## Live deployment
- **The new site is LIVE (since 2026-07-02):** https://willowy-quokka-e604ee.netlify.app — a fresh
  Netlify site published by the professor via `quarto publish netlify` from `quarto-poc/` (the old
  Hugo site's Netlify deployment is untouched; switch the real course domain over when ready).
- Deploy flow after each change: render locally, then `quarto publish netlify` (uploads `_site/`;
  Netlify needs no R/Quarto). `quarto publish` remembers the site in `_publish.yml`.
- Verified post-launch: all pages + both decks 200 (Netlify pretty-URLs 301 `.html` → lowercase
  extensionless paths — fine), and all 86 referenced local assets resolve (no case-sensitivity
  issues).

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
- **Exercises (`*-exercise*.Rmd`) MUST be rendered with `rmarkdown::render()`, NOT `quarto render`.**
  Inside the website project, Quarto ignores the Rmd's `output: webexercises::webexercises_default`
  and produces plain HTML — the webexercises JS/CSS never gets embedded, so solution buttons and
  answer boxes silently stop working (bit us on Lecture 2). From `quarto-poc/`:
  `Rscript -e 'rmarkdown::render("2-exercise1.Rmd")'` (needs pandoc on the path, e.g.
  `export RSTUDIO_PANDOC=<quarto>/bin/tools/aarch64`; in RStudio it just works). The rendered
  HTML at the project root is then copied into `_site/` by the `resources:` glob.
- **TikZ: `step` is a reserved key** (grid spacing) — naming a node style `step/.style` fails with
  "The key '/tikz/step' requires a value". Use another name (we use `stage`).
- **Quarto auto-applies reveal's `r-stretch` to lone images**, which collapses them to 0 height on
  every slide except the one visible at load (bit us on 9 slides in Lecture 1). **Every deck must
  set `auto-stretch: false` in its revealjs YAML** — all images are sized manually via `out.width`
  anyway.
- **Claude-session tooling:** Quarto is NOT installed system-wide; each session downloads the
  macOS tarball (`https://github.com/quarto-dev/quarto-cli/releases/download/v1.9.38/quarto-1.9.38-macos.tar.gz`,
  ~225 MB, extracts `bin/` + `share/` directly — no top-level dir) into its own scratchpad. This
  already bit us once (a previous session's copy was garbage-collected mid-project). Install it
  properly at some point: `brew install --cask quarto`.
  For browser previews: macOS TCC blocks the preview server from reading `~/Documents`, so
  `.claude/launch.json` serves a copy of `_site/` rsynced into the session scratchpad — after every
  render, rsync `_site/` to the directory named in launch.json (update launch.json to the current
  session's scratchpad first).

## Original source (for reference when migrating the rest)
- Hugo site: `config/`, `content/` (Lectures landing pages `.Rmd`), `static/Lectures/<n>-.../` = the
  actual xaringan decks + `exercise*.Rmd`. Theme CSS: `static/Lectures/template/Merlin169.css`.
- 14 lecture decks + a `0-Prep` deck. Data via V-Dem / World Bank APIs and local `assets/*.RData`.
- Repo is ~1 GB (committed rendered HTML, libs, caches, PDFs) — worth a cleanup pass.

## Next steps
1. ~~POC deck look + pedagogy~~ — done, professor approved (incl. two refinement rounds).
2. ~~Quarto website prototype~~ — done, refined, verified.
3. ~~Commit the POC to git~~ — done (bec0e7a, pushed).
4. ~~Lecture 1~~ — done 2026-07-02. ~~Lecture 2~~ — done 2026-07-04 (didactic redesign).
   ~~Lecture 3~~ — done 2026-07-06 (Randomness & inference, 32 slides + 2 exercises; see its
   section below). **Next: Lecture 4 (`static/Lectures/4-OLS-Wisdom/`, deck + 2 exercises).**
   Then 5, 7 → 14.
   The DAG/IV/RDD decks (7, 10, 13) are the heaviest. For each deck: faithful port → template
   standards (see "Feedback round") → check external image URLs → add to `lectures.qmd` +
   `_quarto.yml` `render:` → render → verify slides fit in the browser.
   Content flag for the professor: Lecture 1 says "13 online quizzes", about.qmd says "10 of the
   14" — reconcile.
   Pending image from the professor: Fig. 3 of Legewie & Schaeffer 2016 (AJS, "Contested
   Boundaries") — the uchicago.edu hotlink is dead. When supplied, save it as
   `quarto-poc/img/L1/Legewie_fg3.png` and restore it on the "Three learning goals" slide under
   "(2) Visualization of regression results" (out.width ~55%, source cite `legewie_contested_2016`).
   Convention: per-lecture images live in `quarto-poc/img/L<N>/`.
   R-setup content audited 2026-07-02: all steps work with R 4.6 / RStudio 2026.06 (Project wizard
   and reproducibility preferences unchanged). The three RStudio IDE screenshots (Tasks 2–3 +
   workflow slide) are now local (`img/L1/rstudio-editor.png`, `rstudio-workspace.png`) but show
   the pre-2023 RStudio UI — optionally replace with fresh screenshots from the professor
   (same filenames, drop into `img/L1/`).
5. Content updates the professor must supply: new exam deadline (replaces 12 Jan 2026 on
   about/exam pages); link the 0-Prep setup deck once ported.
6. Polish the website (per-lecture landing pages with readings if wanted; a Quarto `listing`
   instead of the hand-written lecture list; first real Netlify deploy).
7. Optional: repo hygiene (git-ignore rendered artifacts; shrink the 1 GB checkout; fix the
   `wiedner_local_2025` bib entry); install Quarto via brew instead of the scratch copy.
