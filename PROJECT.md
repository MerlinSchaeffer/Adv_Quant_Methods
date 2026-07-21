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
- **Replicated studies flagged in the reading lists (2026-07-06, professor-requested):** every
  study whose *original data students load and re-run in R* is listed as a **skim** reading under
  its lecture in `lectures.qmd` (NOT on the landing page — professor moved it there), each with a
  bold "— … you replicate in R." tag. The five (course-wide, migrated or not): Schaeffer & Kas 2024
  (APAD survey experiment, L5–6), Sherman & Berk 1984 (Minneapolis DV field experiment, L7),
  Legewie 2013 (terror-attack natural experiment, L7; also used L8/11, `Legewie_ESS_02.dta`),
  Angrist & Krueger 1991 (quarter-of-birth IV, L10), Manacorda, Miguel & Vigorito 2011 (cash-transfer
  RDD, L13). *Criterion = hands-on replication;* Card & Dahl 2011 and Dale & Krueger 2002 (L9) are
  shown as published tables, **not** re-run, so they are excluded. Manacorda is **not** in
  `Stats_II.bib` (cited inline only; DOI 10.1257/app.3.3.1 verified via Crossref).
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

## Lecture 8 (2026-07-21) — Multiple OLS: adjusting for observed confounders
`8-Multiple-OLS.qmd` (31 slides) + `8-exercise1/2.Rmd`. **Not a faithful port — deliberately
rebuilt** (professor chose this after a pre-port review). The original L8 no longer fitted the
course: as ported, **L7 had absorbed most of it**. The old deck's Part 1 was a Minneapolis/IV
recap (= L7's exercise 2), its Part 2 re-taught the Legewie Bali design (= L7's lecture Part 1
*and* exercise 1), and its single exercise was near-identical to L7's exercise 1. Its own schedule
slide said "re-visited" twice. Students would have met Bali a third time.
- **New spine = omitted variable bias**, which was the genuinely unique and best-taught content in
  the original. **3-part arc:** (1) *the crack in last week's natural experiment* — Legewie's
  balance table shows the treated are younger (reachability bias), age-as-confounder DAG, then a
  **simulated toy example where we set the truth to 1** and watch bivariate OLS return 0.17 while
  multiple OLS returns 1.14; (2) *omitted variable bias* — the gap built up arithmetically, the
  formula $\tilde\beta = \beta + (\beta_{C \rightarrow Y} \times \beta_{D \rightarrow C})$ verified
  on screen (1.135 + −0.961 = 0.174, exact), the **sign table** (bias direction from two signs),
  and a vocabulary slide tidying selection/confounder/omitted-variable bias; (3) *how OLS does it*
  — Frisch–Waugh 3 steps, "why it works" (down-weights typical cases, up-weights untypical),
  estimation is still OLS, **what multiple OLS cannot fix** (observed vs unobserved confounder DAG,
  the honesty slide), then the applied Bali/Portugal payoff.
- **~10 slides of IV recap replaced by one "Where we are" bridge slide** ranking the three designs
  by credibility: randomize (L6) > natural experiment (L7) > adjust (today). Blunt on purpose.
- **Frisch–Waugh is deliberately in BOTH L8 and L9** (professor's call): L8 derives it on the toy
  data, L9 revisits it on real cross-country data as spaced repetition. L8 carries a forward
  reference; **L9 was not edited.**
- **Real-data payoff (Portugal, `../assets/Legewie_ESS_02.dta`, 26 MB, from Absalon):** bivariate
  **0.330** (matches L7's reported +0.33 — continuity is intentional) → adjusted for age **0.313**;
  the decomposition closes exactly (0.313 + 0.0064 × 2.619 = 0.330). **The shift is deliberately
  small and the slide teaches why:** in Portugal the treated are *older* (sign flips vs. Legewie's
  pooled sample) but age barely predicts xenophobia (0.0064/year), so a big imbalance × a tiny
  effect = a tiny bias. Reinforces the product rule from the formula slide.
- **Exercises (both new):**
  - Ex1 = the **adjusted** Bali effect for Portugal with age + gender + employment (0.330 → **0.279**,
    still significant). Deliberately de-duplicated from L7 ex1, which did the *bivariate* PT + Sweden;
    this one reuses last week's `prepare()` extended with the three controls. Bonus isolates age
    alone (0.31) to show gender/employment do most of the remaining work.
  - Ex2 = **NEW, no data needed**: students get a `simulate_toy(b_bali, b_age, selection, seed)`
    function and turn the knobs. `b_age = 0.9` → the bivariate estimate goes **negative** (a strong
    enough confounder flips the sign); `b_age = 0` → bias vanishes *despite* a 3-year imbalance
    (the product rule); `selection = +0.1` → bias changes sign, estimate now too large;
    **`selection = 0` → bivariate = adjusted, i.e. what an RCT looks like** (callback to L6).
    Bonus: vary the seed to separate *bias* from *sampling error* (callback to L3).
- **Images:** `img/L8/Joscha3.png` (balance table) + `Joscha5.png` (published adjusted models),
  localized from the original. Joscha2/4 were already in `img/L7/` and are **not** duplicated.
- **Readings:** Legewie added as a **skim** under L8 in `lectures.qmd` (students re-run his data
  again this week) — per the replicated-studies convention.
- Dropped from the original: `essentials`, `furniture::rowmeans`, `equatiomatic`, three
  `letstimeit` iframes, the dead `api.time.com` hotlink (returns 000) and all other stock hotlinks.
- Verified in-browser: **31 slides, 21 speaker notes, zero overflow, zero R errors, no tofu**; all
  4 TikZ DAGs render (incl. the `double`-circle observed-confounder node); both exercises embed
  webexercises and **grade correctly** — `num_fitb()` accepts the Danish comma (`0,17` marked
  correct), MCQs mark correct/incorrect. Wired into `_quarto.yml` + `lectures.qmd`.
- **One layout fix during the build** (the recurring pattern): the "Where the gap comes from" slide
  overflowed by 40px with code + table + callout all stacked in the right column — fixed by moving
  the Discuss box to the near-empty left column.

## Lecture 7 (2026-07-13) — Natural experiments & instrumental variables
`7-NatExp-IV1.qmd` (28 slides) + `7-exercise1/2.Rmd`. The heaviest deck so far (2 running studies +
the whole IV apparatus). Mostly **faithful port**, restructured + trimmed (the original repeated the
IV DAG ~8×; consolidated to ~5 clean DAGs). Co-authored deck: kept **"Andrew Herman & Merlin
Schaeffer"**. **The deck itself uses NO live data** — all images + TikZ + hard-coded published
numbers, so it renders fast and offline.
- **3-part arc:** (1) **natural experiments** — can't RCT terrorism → John Snow cholera → Legewie's
  Bali 2002 attack during ESS fieldwork (interview date = as-if random; `Joscha2.png` design,
  `Joscha4.png` results: significant in PT/PL/FI, null in UK/NL/NO); RCT vs nat-exp = internal vs
  external validity. (2) **non-compliance / ITT** — Moving to Opportunity (Chetty et al. 2016):
  offer $Z$ ≠ move $D$, only ~48% comply (`Chetty_1.png`), ITT ≈ **+\$1,624** (`Chetty_2.png`).
  (3) **IV** — 3 requirements (first stage / as-if random / exclusion restriction), the Wald
  estimator $\lambda=\rho/\phi=1624/0.4766\approx\$3{,}400$, exclusion-restriction violation DAG
  (lottery→optimism→income), **LATE**/complier tree + monotonicity, learning goal 2: moving ≈
  **+\$3,477** (`Chetty_3.png`, TOT).
- **Exercises:**
  - Ex1 = **replicate Legewie** (`../assets/Legewie_ESS_02.dta`, 27 MB, from Absalon): weighted OLS
    `anti_immi ~ treat` for **Portugal** (+0.33 SD, p≈0.005) then **Sweden** (n.s.), coefficient
    plots. A `prepare()` helper factors out the date/treatment/index wrangling so the sample
    restriction is the one line students change. Same hidden-load / shown-`eval=FALSE` pattern.
  - Ex2 = **Minneapolis DV** (`masteringmetrics::mdve`, Sherman & Berk 1984): recode assigned vs
    actual policing → compliers = **268**; race balance on *assigned* (balanced) vs *actual* (not);
    first stage **0.79**; reduced form 0.114 (given); **IV/LATE = 0.114/0.79 ≈ 0.14**.
  - **`masteringmetrics` was NOT actually installed** (despite the old about.qmd note) — had to
    `remotes::install_github("jrnold/masteringmetrics", subdir="masteringmetrics")` (pulled
    `clubSandwich`). Needed for ex2 rendering; it's in the course setup list.
- **Modernised:** dropped `essentials::as.scalar` + `furniture::rowmeans` → base `rowMeans(across())`
  + `sqrt(diag(vcov()))`.
- **Images localised** to `img/L7/` (Joscha2/4, Chetty_1/2/3, `snow_map.jpg` — John Snow's 1854
  cholera map, downloaded from Wikimedia at 20k px/19 MB, **`sips --resampleWidth 1400`** → 0.5 MB;
  do this for any big downloaded image). Dropped the deck's many decorative stock hotlinks.
- **TikZ gotcha (new):** edge **quote-labels** `to["?"]` / `to["$\phi$"]` need
  `\usetikzlibrary{quotes}` (on top of `shapes.geometric` from L9) — render dies "I do not know
  the key '/tikz/\"?\"'" otherwise.
- Verified: **28 slides, zero overflow, no collapsed images**, all DAGs + the complier tree
  render, no tofu/errors; both exercises embed webexercises (MCQs + fitb). Wired into `_quarto.yml`
  + `lectures.qmd`.
- **Two float-clearing bugs fixed** (the recurring one — see Design system): the "RCT vs.
  natural experiment" DAG (moved *above* the two floated boxes) and the "RCT vs. ITT" green box
  (`style="clear: both;"`). The overflow sweep misses these; caught by eyeballing.
- **Didactic pass (professor asked "can students really follow IV?" — honest answer: not from the
  slides alone).** He chose two on-slide additions (declined restoring speaker notes / rolling out
  the exercise link): (1) a **"cast of characters"** anchor table mapping Z/D/Y/C/φ/ρ/λ to the MTO
  story; (2) a **"why divide? dilution intuition"** slide before the Wald algebra; (3) the exclusion
  restriction reworked into a **blue-question → red-reveal** ask-then-reveal ("the one requirement
  you cannot test"); (4) a sharper **complier-cancellation** line (never/always-takers add nothing
  to ρ or φ).
- **Speaker notes restored + edited (2026-07-13, professor asked):** the "little text, lots of
  visuals" style puts the didactic load on the lecturer's talk. Ported the original xaringan `???`
  presenter notes into **concise, edited `::: {.notes}`** on ~18 slides (press **`s`** for speaker
  view; they're `display:none` on the slide itself). Kept them to 2–3 presenter-cue sentences each,
  tightened/improved vs. the originals (added "ask first, then reveal" prompts, misconception flags,
  bridge lines). **Rolled out to every ported deck 2026-07-21 — see "Speaker notes" below.**
- **Exercise scroll fix:** the embedded exercise iframe (content ~1485 px in a scaled-0.72, 620 px
  window with macOS overlay scrollbars) is hard to scroll — added a prominent **"Open exercise N in
  a new tab ↗"** link + `scrolling="yes"` + a border on both L7 "Your turn" slides. **Rolled out
  course-wide 2026-07-21 — see "Speaker notes & iframe rollout" below.**

## Speaker notes & iframe rollout (2026-07-21, professor-requested)
Both L7-only conventions rolled out to **every ported deck (L1–7, 9)**.
- **Speaker notes** — `::: {.notes}` on the substantive slides of all 8 decks (press **`s`**):
  L1 14, L2 16, L3 19, L4 18, L5 16, L6 20, L7 18, L9 19. Skipped by design: part dividers,
  breaks, "Your turn", references, the closing function lists. Style = the L7 voice: 2–4
  presenter-cue sentences, "ask first, then reveal" prompts, misconception flags, bridge lines
  to the next lecture.
  - **Only L5 and L7 had original xaringan `???` notes** (33 and 35). L5's were ported + edited
    here; **L1, L2, L3, L4, L6 and L9 had none, so their notes were written from scratch** off the
    deck content. Worth a read-through by the professor before teaching — they encode teaching
    choices (where to pause, what to ask, what to warn about) that nobody has vetted yet.
- **Exercise iframes** — all 12 remaining exercise embeds (L2–6, L9 × 2) now match L7:
  `scrolling='yes'`, a 1px `#ddd` / 6px-radius border, and an **"Open exercise N in a new tab ↗"**
  link (`{target="_blank"}`) in the left column above the timer. L1 has no exercise iframes.
  The two *non-exercise* iframes were deliberately left alone: the V-Dem Wikipedia embed (L2)
  and the Seeing Theory demo (L3).
- Verified: all 8 decks render clean (zero R errors), note counts in the HTML match the source
  exactly, every `aside.notes` is `display:none` on the slide, and the reveal `notes` plugin is
  registered so **`s`** opens speaker view.
- **Pre-existing overflow found in L6 (NOT caused by this work — proved by re-measuring with
  every note removed: byte-identical).** 5 slides overflow the 1600×900 box: the opening
  vaccine slide (+101px — the `polack_safety_2020` source line is clipped below the fold),
  "Goal of empirical sociology" (+18px), and three panel-tabset slides (+110/+35/+43px, likely
  a measurement artefact of stacked tab panels rather than a visible problem). The vaccine
  slide is a real, visible clip — worth a fix. Every other deck: **zero overflow**.
- Hotlink check: the `laserfiche.com` stock photo on the "Your turn" slides (L2 ×2, L3 ×2,
  L6 ×2) still returns 200, so it was left in place — but it is an external hotlink on six
  slides and a candidate for localising into `img/` on the next pass.

## Lecture 5 (2026-07-13) — Selection bias (potential outcomes, confounding, DAGs)
`5-Selection-bias.qmd` (26 slides) + `5-exercise1/2.Rmd`. The course's conceptual core — a mostly
**faithful port** (the pedagogy was already strong), restructured into the template + modernised
code. Co-authored deck: kept **"Friedolin Merhout & Merlin Schaeffer"** in the author line.
- **Running example = the APAD "integration paradox"** (`schaeffer_integration_2024` — one of the
  studies students replicate, now flagged in the L5 readings). RQ: does consuming **news** increase
  how often immigrant minorities **report discrimination**? Naïve weighted OLS `dis_index ~ news_yn`
  gives **−0.093 (SE 0.129, n.s.)** — looks like *no* effect, but the comparison is confounded.
- **3-part arc:** (1) hypothesis = counterfactual comparison + the naïve OLS; (2) **potential
  outcomes** (Ferda's personal effect; the fundamental problem; ACE; Ferda-vs-Tuki selection-bias
  decomposition: observed diff = true effect +2 **+** selection bias −3; the population formula);
  (3) **DAGs** — backdoor path, confounder = selection bias, the German-citizen → news & discr.
  DAG, verdict "correlation ≠ causation". A **balance test** (`datasummary_balance`) shows news
  readers are older (44 vs 37) & more often German citizens — the observed face of the bias.
- **Data:** local `../assets/APAD.RData` (18 KB, ships with repo; students download from Absalon —
  no API, so no tryCatch). Prep: `news` (mins), `news_yn` (≥15 min), `dis_index` = `rowMeans` of
  6 domains. **Modernised:** dropped `essentials::as.scalar` / `furniture::rowmeans` (not on CRAN
  for R 4.6) → base `rowMeans` + `sqrt(diag(vcov()))`.
- **Exercises = APAD, a *different* outcome** (`antidiscr_law`, support for an anti-discrimination
  law; naïve OLS ≈ −0.10, n.s.): Ex1 = weighted scatter + outlier-cap cleaning + weighted OLS
  (coef/SE fitb) + bonus (add `age` control); Ex2 = draw a DAG + `datasummary_balance` on racial
  `appearance` (5 categories) + brainstorm *unobserved* confounders. **Exercise data-load pattern:**
  hidden `load("../assets/APAD.RData")` for the render + a shown `eval=FALSE` `load("APAD.RData")`
  for students (same split as L3's ESS exercises — a bare visible `load()` would fail at render).
- **Images localised** to `img/L5/` (`Meta.png` = the Schaeffer & Kas meta-analysis forest plot,
  280 estimates; `fork.png` = the fundamental problem). Dropped the deck's many decorative stock
  hotlinks. TikZ DAGs use the `shapes.geometric` library (L9 gotcha).
- Verified: **26 slides, zero overflow** (balance table wrapped in `.small` to fit), DAGs + all
  math render, no tofu/errors; both exercises embed webexercises. Wired into `_quarto.yml` +
  `lectures.qmd` (L5 now links slides + 2 exercises).

## Lecture 9 (2026-07-06) — Multiple OLS in practice (confounders, mediators, summary controls)
`9-Mult-OLS-in-practice.qmd` (30 slides) + `9-exercise1/2.Rmd`. **Not a faithful port** — this is
the deck the L4 flag was about: **both its exercises used the colonial `poverty ~ colonizer +
years_indep` example** (same brittle hand-coded `case_when`), and the *deck's* Part 1 used a
**hand-coded socialism index + Freedom House**, now inconsistent with the redesigned L2 (which
replaced exactly those with V-Dem `state_control`/`equal_liberty`). Both were modernised;
colonialism dropped entirely.
- **Part 1 (confounders vs. mediators + Frisch–Waugh):**
  - *Clear mediation, kept:* ESS Denmark **gender → gross wage, mediated by contracted work
    hours** (`grwage ~ gndr` vs `+ wkhct`, weighted). ~**36%** of the gap runs through hours (the
    exact % shifts with the sample kept by `drop_na()`; the slide computes it inline so it's
    always self-consistent). Reads `../assets/ESS9e03_1.sav` (the 52 MB course-staple SPSS file,
    also used by L3/11/12; no API, so no tryCatch — students download it from Absalon).
  - *Ambiguous case, rebuilt on L2's V-Dem triangle:* `poverty ~ state_control + equal_liberty`.
    On its own state control is ~+2.7 on poverty (R²≈0.02); **add freedom and its sign flips to
    −3.8** (freedom −37, state-control/freedom corr −0.69). A sign-flip is the ideal "is freedom a
    confounder or a mediator?" case and continues L2 directly. Reuses L2's exact vdem + WB-poverty
    pipeline (tryCatch → `data/wb_poverty_raw.rds`, $3.00 line).
  - *Frisch–Waugh* shown as the 3-step residualisation via `modelr::add_residuals()`; the
    residualised slope on `e_state` **equals** the multiple-model `state_control` coefficient
    (−3.781 both ways) — the payoff slide.
- **Part 2 (smart summary controls), faithful port:** Angrist quote; **Card & Dahl 2011**
  (upset home losses → +~10% at-home partner violence; the betting-market **point spread** is the
  summary control); **Dale & Krueger 2002** (college-selectivity earnings premium +7.6% → ≈0 in
  the **matched-applicant** model; the shared application portfolio summarises ambition/ability) →
  "no Harvard premium ⇒ no KU premium". Images localised to `img/L9/` (Card_n_Dahl.png,
  DaleKrueger0/2/3/4b.png, plus `football.jpg` pulled from the old S3 hotlink).
- **Exercises = carbon divide (L4), professor's pick:** multiple OLS on `co2 ~ region` vs
  `co2 ~ region + gdp_k` — the regional gaps **collapse** once wealth is controlled (N. America
  +9.7 → +1.0; R² 0.24 → 0.47), *except* MENA (+5.8, the oil regions emit beyond their wealth).
  Ex1 = fit + interpret the coefficient change (is GDP a mediator?); Ex2 = before/after
  coefficient plot (`position_dodge`) + prediction plot. Reuses the L4 carbon pipeline + caches
  (same `filter(year == max(year))` GDP fix). Bonus swaps `gdp_k` → `income_level`.
- **New bib:** none needed — `frisch_partial_1933`, `angrist_mastering_2014`, `card_family_2011`,
  `dale_estimating_2002` were all already in `Stats_II.bib`.
- **TikZ gotcha (new):** the `ellipse` node shape needs `\usetikzlibrary{shapes.geometric,...}`
  (not just `arrows.meta, positioning`) — the render dies with "I do not know the key '/tikz/
  ellipse'" otherwise. Also — **the recurring float bug (bit L9 once, L7 twice):** `.push-left`/
  `.push-right` are `float:left/right`, so **any full-width element that follows both of them on the
  same slide — an image, a TikZ DAG, *or* a callout box — gets sucked up into the float gap** (an
  image collapses to ~0 height; a box's background slides *behind* the two and its text squeezes
  into the gap). **Two fixes:** put the element *before* the two floats (works for a leading
  diagram), or give the trailing element `style="clear: both;"` (works for a closing takeaway box,
  e.g. `::: {.content-box-green style="clear: both;"}`). The overflow sweep does **not** catch this
  — eyeball any slide that has two floats plus a third block.
- Verified in-browser: **30 slides, zero overflow, no collapsed images, no tofu, no R errors**;
  all 5 DAGs render; Frisch–Waugh coefficients match; both exercises embed webexercises
  (MCQs + fitb + solution toggles). Wired into `_quarto.yml` + `lectures.qmd`.

## Lecture 4 (2026-07-06) — OLS wisdoms, rebuilt as "the carbon divide"
`4-OLS-Wisdoms.qmd` (35 slides) + `4-exercise1/2.Rmd`. **Not a faithful port** — the professor
was unhappy with the old **colonialism** running example (both the loaded "which empire
colonised better" framing *and* its brittle ~60-line hand-typed `case_when` of country names +
independence years, full of typos that silently drop cases — the same kind of hand-coding he'd
already ripped out of L2). We surveyed every deck's running example to avoid collisions
(poverty = L2/L9; democracy/freedom/socialism = L2; life expectancy = L12; wages = L10; race/
discrimination = L5; xenophobia = L7/8/11) and picked a **fresh Global North/South topic**:
- **The carbon divide:** `co2 ~ gdp` + **world region** (professor chose region as the
  categorical). Same OLS wisdoms as the old deck — outliers, linearity, dummy coding,
  coefficient plots, predictions, LPM — but with a climate-justice hook.
- **Why it teaches better than the colonial version:** the Gulf petro-states are *both* the
  Cook's D outliers *and* the source of the apparent non-linearity, so `plot(which=5)` and
  `which=1` point at the same cases. Two outliers with different characters let us teach
  **judgement**: **Palau** (Cook's D #2, a tiny-island data artefact — high residual, modest
  GDP) is *dropped*; **Qatar** (Cook's D #1, a real high-*leverage* petro-state) is *kept but
  flagged*. Dropping Palau ~doubles R². (Do **not** teach the log-transform fix here — that is
  L12's job; L4 only diagnoses.)
- **Data (all World Bank, no hand-coding):** CO₂ = `EN.GHG.CO2.PC.CE.AR5` — **the classic
  `EN.ATM.CO2E.PC` was retired/archived by the WB in 2024** (verify with `wb_data`, it 404s);
  the AR5/EDGAR per-capita series is the live replacement. GDP = `NY.GDP.PCAP.PP.KD` (PPP,
  `/1000` → `gdp_k` for readable slopes). **Region + income group come free from
  `wb_countries()`** (filter out `region == "Aggregates"`), joined by `iso3c`. Region ref =
  Sub-Saharan Africa (`fct_relevel`); a clean monotonic gradient SSA 0.9 t → N. America 10.6 t.
- **Exercises use INCOME GROUP** (Low→High, another free WB categorical) so students practise
  the same skills on a *different* variable, not slide transcription: Ex1 = diagnostics +
  categorical dummy coding; Ex2 = coefficient plot + prediction plot, with the scaffolded
  "carbon divide" discussion. LPM binary = "high emitter (>2 t)"; splits 55/45 and predicts
  P>1 for Qatar (the LPM cautionary tale, shown on the slide).
- **tryCatch/offline fallback (L2 convention):** all three WB calls are wrapped
  `tryCatch(wb_data/wb_countries(...), error = readRDS("data/wb_*_raw.rds"))`; caches committed
  (`wb_co2_raw.rds`, `wb_gdp_raw.rds`, `wb_countries_raw.rds`) + a joined `data/Dat_L4.rds` for
  the exercise "Stuck?" URL. Regenerate with the pipeline in the deck's `wb-data`/`wb-build`
  chunks. (`wb_countries()` *does* hit the API in wbstats 1.1, so it needs the guard too.)
- **New bib entry:** `chancel_global_2022` (Chancel, *Nature Sustainability* 5:931–938 —
  global carbon inequality), cited on the RQ + payoff slides. `breen_interpreting_2018` kept
  for the LPM/logistic appendix.
- **Closing "consumption vs. production" slide (professor requested):** the WB series is
  *territorial/production* CO₂ — **the World Bank has NO consumption-based (footprint/trade-
  adjusted) indicator** (checked; the "…consumption" hits are just fuel-type production
  emissions). The consumption-based data come from the **Global Carbon Project, via Our World
  in Data** (`github.com/owid/co2-data`, cols `co2_per_capita` + `consumption_co2_per_capita`).
  A dumbbell slide ("whose carbon is it?") makes the point that Denmark *produces* ~4.8 t but
  *consumes* ~8.3 t (+72%) once imported goods count, while factory economies (China −11%,
  India −17%) export embodied carbon — so the North–South gap *widens* under a fairer measure.
  The full OWID CSV is 50 MB, so it is **NOT** pulled at render: a tiny committed snapshot
  (`data/owid_consumption.rds`, 120 countries, latest year) drives the slide; regenerate with
  `Rscript img/L4/make_consumption_cache.R`. Source cited inline (backgrnote), like WB.
  A **follow-up slide** ("Run the fit again — with the consumption footprint") re-runs the
  *same* `~ gdp_k` OLS on the consumption outcome (join the snapshot onto `Dat` by `iso3c`):
  wealth explains **far more** of the footprint (R² 0.38 → **0.60**, steeper slope) than of
  production, and Qatar stops being the lone outlier — a clean quantitative payoff for the
  "how you measure the outcome changes the story" wisdom (panel-tabset: code / table / picture).
- **BUG FOUND & FIXED (would bite any WB deck): `wb_data()` returns rows in ASCENDING date
  order**, so the terse ``gdp_raw |> select(iso3c, gdp) |> distinct(iso3c, .keep_all = TRUE)``
  keeps each country's **oldest** (year-2000) value, *not* the latest — silently regressing
  ~2023 CO₂ on 2000 GDP (wrong slopes/R²). Always take the most recent explicitly:
  `group_by(iso3c) |> filter(year == max(year)) |> ungroup()` (as the CO₂ pipeline and the
  `Dat_L4.rds` cache already did). Fixed in the deck **and both exercises' starter code** —
  they now match the cached expected answers. Verified post-fix: main model slope ≈ 0.12 /
  R² ≈ 0.17 (doubles to ~0.36 after dropping Palau); consumption comparison R² 0.378 vs 0.602.
- **Gotcha (new):** the ggplot raster device can't render the Unicode subscript **₂** — it
  prints as a tofu box in axis/legend/caption labels. Use ASCII **"CO2"** *inside* `labs()`/
  `caption`/`scale_*`; keep the pretty **CO₂** only in HTML prose/headings/callouts. (Same font
  limitation PROJECT.md already noted for the L3 GIFs.)
- Verified in-browser: 33 slides, **zero overflow**; all plots render (incl. base-R
  `plot(which=5/1)` and the LPM line piercing 1); both exercises embed the webexercises JS/CSS
  (2 MCQs + fitb + solution toggles each), no unresolved inline-R, no tofu.
- **Flag for the professor:** **L9 still reuses the old colonial poverty/independence example.**
  Dropping it here doesn't touch L9, but that deck will want the same rethink when ported.

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
  kr. 600/month).
- **WB API outage fix (2026-07, the professor hit `object 'Dat' not found` mid-render):** the
  `wb_data()` call is flaky and, when it fails, `Dat` never gets built → the whole deck halts. Every
  `wb_data()` call (deck `wb-data` chunk + both exercises) is now wrapped
  `tryCatch(wb_data(...), error = function(e) readRDS("data/wb_poverty_raw.rds"))`, falling back to
  a committed raw cache (`quarto-poc/data/wb_poverty_raw.rds`, 11.7k rows — regenerate with
  `wbstats::wb_data("SI.POV.DDAY", start_date=1972, end_date=2025)` and `saveRDS`). Live-first so
  data stay fresh when the API is up; the fallback keeps renders reliable. `wb_search()` does NOT
  need this — it queries the package's bundled `wb_cachelist`, not the network. Apply the same
  tryCatch guard to any future deck that calls a live API.
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
- **Canonical variable labels (harmonised across all decks 2026-07-06, professor-approved):**
  the same construct must carry the **same academically sound label everywhere** — prose, plot
  axes, table `coef_rename`, and TikZ DAG nodes.
  - V-Dem `v2xcl_rol` → **"civil liberties"** (R variable `civ_liberties`). Introduced once (L2
    measurement slide) as *"the V-Dem equality-before-the-law-and-individual-liberty index — in
    T.H. Marshall's terms, the civil dimension of citizenship rights."* Do **not** relabel it
    "freedom", "citizenship rights", or "equality & liberty" elsewhere. The old ideological
    debate is the **"liberty–equality trade-off"** (liberty = the ideal, civil liberties = our
    measure). Keep "Freedom House" (the org / `FreedomHouse.png`) and component descriptions
    ("freedom from torture", "freedom of religion/movement") as-is — those are not the variable.
  - V-Dem `v2clstown` (reversed) → **"state ownership of the economy"** (R variable
    `state_ownership`; raw `state_own_raw`; z-score `z_state_ownership`). Higher = more state
    ownership. "Socialism" stays as the *concept* it operationalises, not the variable label.
  - WB `SI.POV.DDAY` → **"extreme poverty"** / "% below $3.00 a day (2021 PPP)".
  - **Applied to L2 (deck + both exercises) and L9 (deck); pending decks that reuse these vars
    — esp. L12 (Polynomials, uses `v2xcl_rol`) — must adopt the same labels.** The L2 exercises'
    `data/Dat_L2.rds` fallback was regenerated with the new column names (`civ_liberties`,
    `state_ownership`, `state_own_raw`) so live-path and fallback agree.
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
- **Quarto is now installed for real at `/Applications/quarto`** (v1.9.38; the professor did the
  cask install 2026-07). Use it directly. For `rmarkdown::render()` of the exercises, its bundled
  pandoc is at `/Applications/quarto/bin/tools/aarch64` → `export
  RSTUDIO_PANDOC=/Applications/quarto/bin/tools/aarch64`. (Older sessions downloaded a scratch
  Quarto tarball into the scratchpad; that's obsolete now and gets garbage-collected.)
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
   ~~Lecture 3~~ — done 2026-07-06 (Randomness & inference, 32 slides + 2 exercises).
   ~~Lecture 4~~ — done 2026-07-06 (OLS wisdoms, rebuilt as "the carbon divide"; colonialism
   dropped). ~~Lecture 9~~ — done 2026-07-06 (Multiple OLS in practice; colonial exercises +
   hand-coded socialism replaced with the V-Dem triangle + carbon divide — see its section
   above). ~~Lecture 5~~ — done 2026-07-13 (Selection bias; faithful port + modernised, APAD
   integration paradox). ~~Lecture 7~~ — done 2026-07-13 (Natural experiments & IV; Legewie Bali +
   MTO/IV + Minneapolis). ~~Lecture 8~~ — done 2026-07-21 (Multiple OLS, **rebuilt around omitted
   variable bias** after a pre-port review found it duplicated L7 — see its section above).
   **Done so far: L1–9. Next: Lecture 10 (`static/Lectures/10-IV-2SLS/`, deck + exercises).**
   Then 11 → 14. (Colonialism is now fully gone from the course.)
   **Review each deck against the already-ported ones before porting** — L8 showed that the later
   decks were written against a course that the migration has since changed underneath them.
   L10 (IV/2SLS) is the obvious next candidate for overlap: check it against L7's IV apparatus.
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
