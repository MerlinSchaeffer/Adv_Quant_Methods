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
- **Angrist / Mastering 'Metrics videos migrated (2026-07-23, professor-requested):** the old Hugo
  per-lecture landing pages each had a "Don't miss out on this video by Joshua Angrist" YouTube
  embed. The new site has no per-lecture pages, so these are now **`▶ Watch` items in each
  lecture's `<ul class="readings">`** on `lectures.qmd`, styled with a new `.rtag-watch` badge
  (slate `#425570` on `#eef2f6`, added to `ku-web.scss` next to `.rtag-read`/`.rtag-skim`). They
  **link out to YouTube** (`target="_blank"`), NOT embedded — keeps the page light and the homepage
  clean (professor's no-clutter principle). All 6 IDs verified live via YouTube oembed. Mapping:
  L5 `6YrIDhaUQOE` (Selection Bias/private university, Angrist·MRU); L6 `eGRd8jBdNYg` (Randomized
  Trials, Angrist·MRU) + `QqN3eke9jXg` (Computers in the Classroom, Mastering Metrics); L7 & L10
  both `yHypzxYikqk` (Old School IV, Mastering Metrics — same clip, flagged as a re-watch on L10);
  L9 `OwNxEaOF8yY` (Regression Part I: Call in the CIA, Mastering Metrics); L11 `J8IHdu-oM64`
  (interaction terms — **Nick Huntington-Klein, NOT Angrist**, labelled correctly). The Lectures
  intro paragraph now explains the ▶ Watch tag. Any future ported lecture with an old video embed:
  add the same `.rtag-watch` `<li>`.
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

## Cross-lecture coherence pass (2026-07-25, after L14 — "meta overview")
With all 14 decks done, a bird's-eye consistency review (language, notation, design, flow,
chronology, difficulty). **Verdict: highly coherent** — one template, one callout colour code, a
connected cross-reference web (the L4→L12 forward-ref resolves; every "last week" lines up). Four
fixes applied (commit `d8a187a`, all rendered/verified/published):
1. **Notation — L14 causal DAGs I/X → Z/D.** The Conclusion used the original's I (instrument) / X
   (treatment); the whole course teaches **Z / D**. Relabelled the DAGs + prose so the synthesis
   matches (descriptive-half generic `X`, e.g. polynomial powers, left as-is). Wald stays λ=ρ/φ=ITT/r.
2. **Language — standardised to British** across L1/L4/L6/L8/L12 (course was ~90 % British already;
   L6 was the worst, incl. a visible "randomize?" title → "randomise?"; also `generalized`→`generalised`).
   **Left alone:** external Angrist/MRU video titles in `lectures.qmd` (proper citations), and image
   **filenames** — a first `sed` pass over-reached and rewrote `img/randomization*.png` paths to
   `randomisation`, breaking `include_graphics` (files on disk keep the `z`); reverted the paths only.
   **Lesson: scope spelling seds to prose — never touch `include_graphics()` paths or factor levels.**
3. **Design — added "Today's important functions" to L6 & L7**, the only two method decks missing the
   R-reference slide every other one has. L7's forward-references `ivreg()` as next week's one-step 2SLS.
4. **Didactics — κ→λ bridge on L7's LATE slide:** a one-line backgrnote ("RCT gave us κ for *everyone*;
   an instrument gives λ for **compliers** only — hence the new letter"). The effect-symbol shift
   L6(κ)→L7+(λ) is now explicit.
- **Not changed (noted, not defects):** L14's two-goals split reorganises lectures thematically (the
  descriptive L11/L12 are taught *after* the causal L6–L10, since L13 RDD needs L12's polynomials) —
  right teaching order, so the synthesis regroups rather than replays; and the many relative "last
  week" references are fine **as long as the course is always taught 1→14**.

## Lecture 14 (2026-07-25) — Conclusion — MIGRATION COMPLETE (L1–14)
`14-Concl.qmd` (25 slides, 19 notes). **The final deck.** A course synthesis on a lovely
self-referential running example — **the class's own weekly-quiz results**. Two-goals structure:
*(1) describe patterns* (dummy → multiple → interaction → polynomial → transformation → combined) and
*(2) identify causal mechanisms* (OVB → RCT → ITT/Wald → 2SLS → control → mediator → RDD), each on the
quiz data or a clean DAG. No exercises (it's a wrap-up), so lighter than the other ports.
- **PRIVACY — the key decision (professor: anonymise; also asked "does the data need committing?"):**
  the source `Result.RData` holds **75 real student first names** + quiz scores + LLM-inferred
  gender/skill. The rendered deck never displays a name (they're only in `eval=FALSE` code), but
  committing the file would ship them. **Fix: `data/quiz_results.rds`** — real names replaced with
  **gender-matched synthetic Danish names** (seeded; `woman > 0.5` → female name), every numeric
  column untouched, so **all plots/models are numerically identical** (verified mean %correct =
  92.24). The real `Result.RData` stays in the old `static/Lectures/` tree, outside `quarto-poc/`, so
  **no real student data enters the repo or the site.** Answer to the professor's question: the data
  is needed to *render* but **not to serve** (the published deck is static images); committing the
  tiny anonymised file keeps the deck re-renderable (the "you can update it yourself" principle),
  which is why we commit it rather than gitignoring. **Any future deck built on class data: anonymise
  the same way before committing.**
- **Harmonised to the ported course (the L8 lesson, amplified — this deck recaps everything):**
  - **Wald notation:** the original wrote λ = ITT/r; ported to **λ = ρ/φ = reduced form / first
    stage = ITT/r** (shows all three, bridging L7/L10's ρ/φ with the original symbols). Same fix as
    the variable-label harmonisation convention.
  - **RDD added to the "Two Goals" overview** (it was missing — now a full lecture, L13), and the RDD
    recap slide redrawn with **L13's palette** (slate below / KU red above / black jump bar) instead
    of the old purple/green.
  - Subtitle **"13. Conclusion" → Lecture 14**.
- **Honesty touches (professor cares):** the LLM gender split in this cohort is **63 women / 9 men**,
  so the deck's gender regression rests on nine men — added a red "read it with humility" caveat, and
  the coefficient is **n.s. (−1.6, p = 0.32)**. Kept the LLM **"stats-skill-from-your-name"** slide as
  a *measurement-validity* lesson: the model returns a confident number that is **pure noise**
  (slope −0.43, p = 0.45, R² = 0.006) — a nice spurious-correlation punchline.
- **Packages:** `equatiomatic` (used for `extract_eq()` — the model-equation display on the OLS-knife
  slide) was **documented-but-not-installed** — installed it. `essentials` dropped (unused / not on
  CRAN for R 4.6). `masteringmetrics` present (the RDD recap reuses `mlda`).
- **Kept the deck's best pedagogy:** the **variance-decomposition plots** (blue = explained from the
  mean to the fitted line, red = residual from the line to the point) on the null / OLS-knife / poly /
  transform slides — the clearest R² picture in the course. Jitter is now **visual only** (integer
  `appearances` stays clean for the models; the original jittered the modelling variable in place,
  which slightly attenuates slopes — fixed).
- **Same structural gotcha as L13 bit again:** wrote the two part dividers as `#` (level-1) → Quarto
  nested the following `##` as **vertical stacks** (only 8 top-level sections). **Dividers must be
  `##` with `.inverse`.** (Now flagged twice — worth remembering for any future deck.)
- **No images** — all ggplot + 4 TikZ DAGs (OVB, RCT, ITT, I/C/M-mediator), so it renders in ~10 s
  offline. Dropped the Durkheim blogger-hotlink opener (made "The goal of empirical sociology" a clean
  inverse text slide, bookending the course — same treatment as the L1/L6/L13 openers).
- Verified in-browser: **25 slides, zero overflow, zero R errors, no `&nbsp;`, no tofu**; `extract_eq`
  equation renders, all 4 DAGs render, the variance-decomposition + RDD recap plots render. Wired into
  `_quarto.yml` + `lectures.qmd` (**"All 14 lectures are fully migrated"**, no "coming soon" badges
  left). **The Quarto migration of the lecture decks is now complete: L1–14 + the 0-Prep setup page
  (about.qmd).**

## Lecture 13 (2026-07-24) — Regression discontinuity designs (RDD)
`13-RegDD.qmd` (34 slides, 24 notes) + `13-exercise1/2.Rmd`. **Faithful port, restructured into the
template + two deliberate cross-references woven in** (the pre-port review confirmed L13 is *not* a
repeat of L7/L10 — it reuses their λ/LATE/natural-experiment vocabulary as load-bearing scaffolding,
the same relationship L10 has with L7).
- **3-part arc:** (1) *the logic* — RCT recap (κ) → rules-not-randomness → the "just barely either
  side is as-good-as-random" intuition (`RDD_intuition{,2}.png`) → continuity + no-sorting → the
  central bias-vs-reliability trade-off (LATE); (2) *parametric OLS* — MLDA drinking-age example,
  the centred-running-variable / dummy / interaction spec, **problem 1 = functional form (the L12
  recap)**, **problem 2 = bandwidth** (`rdbwselect`); (3) *non-parametric* — local-linear beats
  global polynomial at the boundary, the triangular kernel, `rdrobust()`, the mva placebo check, then
  three real studies (Pereira women/corruption, Schaeffer far-right/discrimination).
- **The load-bearing new slide (the L7/L10 check the professor asked for): "You already know this λ"**
  (beige `#f5f0e8` ask-then-reveal). Sharp RDD = **IV with perfect compliance**: everyone above the
  cutoff is treated, so **φ = 1** and $\lambda = \rho/\phi$ = **the jump itself** — no dividing. Also
  flags the **two senses of "local"**: L7's LATE is local to *compliers*, RDD's is local to the
  *cutoff*. This is what stops students filing RDD as an unrelated trick; wire the same bridge if the
  design ever recurs.
- **Polynomials kept as a recap, not re-derived (professor asked to keep some recap).** "Problem 1"
  explicitly says **"Recall Lecture 12"** and reuses L12's `poly(age0, 2, raw = TRUE)` idiom + the
  overfitting-beware box, sharpened to the RDD-specific point (a wild boundary swing lands right on
  λ). Do **not** re-teach polynomials from scratch — L12 now owns them.
- **Running example = minimum legal drinking age → mortality** (`masteringmetrics::mlda`, n = **48**
  binned one-month age cells — *not* individuals; flagged on the data slide). **Verified numbers:**
  linear parametric λ = **7.66** → quadratic **9.55** → `rdrobust` all-cause **9.60** (robust CI
  [1.1, 18.3], **robust p = 0.027**, h = 0.493, 12 cells); motor-vehicle **4.9 = 51 %** of the
  all-cause jump. **Report robust inference, not conventional** — `rdrobust`'s `summary()` headline
  row is the *robust* p (`$pv[3]`/`$ci[3,]`), which differs from `$pv[1]`; I first wrote the
  conventional p (0.008) and it contradicted the on-screen output. **Honesty fix (professor cares):**
  the mva subgroup is only **marginally** significant under robust inference (p = 0.06, CI
  [−0.2, 9.7]) — the slide gives the point estimate as a logic check, *not* a second significance
  claim, with a backgrnote saying so.
- **Exercises = Manacorda, Miguel & Vigorito 2011 (Uruguay PANES, `causaldata::gov_transfers`,
  n = 1948)** — the RDD replication PROJECT.md already flagged. Ex1 = **parametric** RDD, welfare →
  political support, **λ = +0.10** (p ≈ 0.001, significant; D = 1 *below* the cutoff = received the
  transfer — the treated side is flipped vs. the deck, flagged in a callout). Ex2 = **`rdrobust`**:
  at the MSE-optimal bandwidth (h ≈ 0.005) the estimate is a tiny, **insignificant** +0.025 (too few
  obs); widen to h = 0.02 and it becomes **−0.096, significant**. **The sign lesson (new, honest):**
  `rdrobust` reports *above − below*, and here the treated sit *below*, so its −0.10 is the **same
  finding** as Ex1's +0.10 — bookkeeping, not contradiction; Ex2 teaches this explicitly (MCQ enforces
  the sign) plus a bias-vs-reliability + p-hacking discussion.
- **Bugs found & fixed during the build (all would have shipped broken):**
  - The **original exercises had `ref.label="nonlinear_rdds"`** pointing at a chunk that doesn't exist
    → empty/erroring solutions. Rewrote the solution chunks.
  - The **original ex1 mislabelled the treated side** (`rule` = "Welfare" for `Income_Centered >= 0`,
    but PANES paid households *below* the line). Corrected.
  - `rdrobust`/`rdbwselect` `summary()` is **25/20 lines and overflows a slide** — it clipped the
    actual estimate table (the payoff). Fix: `trim_rd()`/`trim_bw()` helpers (`capture.output` →
    `cat` the essential lines) shown in a **panel-tabset** (Estimate / R code). **Any long console
    output on a slide needs trimming — the overflow just hides the important tail silently.**
  - **`modelsummary` prepends a stray `&amp;nbsp;` to a *single*-model column header** (double-model
    tables are clean) — it rendered as literal "&nbsp;Deaths per 100,000". Fix: an `ms()` wrapper
    (`gsub("&amp;nbsp;", "", as.character(modelsummary(..., output="kableExtra")))` + `results='asis'`).
    Reuse for any single-model table. (Also: all `modelsummary` chunks need `results = 'asis'`, else
    the whole table double-escapes.) **Update 2026-09-15:** it is not only single-model tables
    (L10's 3-model table and L11's 2-model tables were hit too). Where the `modelsummary()` call is
    *echoed* to students (L4, L10, L11), don't wrap it — those decks instead wrap knitr's `chunk` hook
    in the setup chunk to `gsub()` the `&amp;nbsp;` out of all output, so the visible code stays plain.
    L3's one (hidden) table uses the inline gsub. Check with `grep -c '&amp;nbsp;' _site/*.html`.
  - **`num_fitb` (the L12 helper) is too strict for these answers:** it accepts only the 2-decimal
    form (`0.10`), but `modelsummary` shows `0.100` and `rdrobust` shows `0.025`/`−0.096`, so a
    student typing exactly what they read was marked wrong. Replaced with an `ans("0.1","0.10",
    "0.100")`-style helper that lists the natural decimal forms and auto-adds Danish-comma variants.
    **Watch this on any exercise whose answer comes from `rdrobust`/`modelsummary` output.**
- **Packages:** `causaldata` + `rdrobust` were **documented but not installed** (same gap as
  `masteringmetrics` L7, `ivreg` L10) — installed both. `essentials`/`equatiomatic` dropped from the
  setup (not on CRAN for R 4.6 / unused). `masteringmetrics` already present.
- **Structural gotcha (new): `#` (level-1) headings become vertical stacks in Quarto reveal.** I first
  wrote the three part dividers as `#` — Quarto nested each following `##` under them as a *vertical*
  slide (5 top-level `<section>`s, broken linear nav). **Dividers must be `##` with the `.inverse`
  class**, like every other deck; there is no `#` heading in a ported deck except code comments.
- **Images:** localized to `img/L13/` — `RDD_intuition{,2}.png`, `electoral_threshold.png` (was an
  epthinktank hotlink), `women_elected_{threshold,effects}.png`, `Krzysz.png`, `Figure_1.png`
  (audit-study baseline), `Figure2a-1.png` (the RDD plot), `Map_Italy.png` (resized to 1200px).
  **Dropped the theeffectbook fuzzy-RDD DAG** (the deck teaches only *sharp* RDD — showing a fuzzy DAG
  was a quiet mismatch), the two `laserfiche` stock photos, the blogger "goal of social science"
  photo (L1/L6 already have that slide), the `pbs.twimg` decorative shot, and the commented-out
  NBA/Matthew-effect example.
- **Bib fix:** `pereira_does_nodate` was mangled (`volume = n/a`, no year) — verified via Crossref
  (DOI 10.1111/lsq.12409 → *LSQ* 48(4):731–763, 2023) and added `year`/`volume`/`pages`. Manacorda
  stays inline-only (still not in `Stats_II.bib`, per convention). `schaeffer_when_2025` +
  `romarri_far-right_2020` already present.
- **RDD plot palette:** control (below cutoff) = slate `#6b7f95`, treated (above) = KU red `#901A1E`,
  cutoff line black dashed. The "OLS finds the trade-off" slide draws both local lines + dashed
  counterfactual extensions + a **black bar = the jump at 21** (the single clearest RDD teaching plot).
- Verified in-browser: **34 slides, zero overflow, zero R errors, no broken images, no tofu**; all
  ggplot RDD plots + the kernel plot render; the ask-then-reveal φ=1 payoff shows; both exercise
  iframes load with new-tab links + ku-timers; **both exercises grade correctly** (Danish comma
  accepted, natural decimal forms accepted, Ex2's sign enforced). Wired into `_quarto.yml` +
  `lectures.qmd` (callout → **1–13**, L13 un-"soon"ed with slides + 2 exercises).

## Lecture 12 (2026-07-23) — Polynomials & transformations
`12-Polynomials.qmd` (24 slides, 15 notes) + `12-exercise1/2.Rmd`. **Faithful on the core,
re-vehicled controls** (professor's call, mirroring L11). The payoff of L4's "don't fix the curve
here — that's L12's job" note.
- **Core (new, no collision):** LOESS to see the shape; **polynomials** (`I(x^2)`,
  `poly(x, 2, raw = TRUE)`, quadratic interpretation, higher-order **overfitting** warning); **log₂
  transformation** ("per doubling"); a **fit comparison** (linear vs quadratic vs log). Running
  example = **life expectancy ~ health spending** (WB `SP.DYN.LE00.IN` + `SH.XPD.CHEX.PP.CD`),
  which is used nowhere else. **Verified numbers:** linear R²=**0.455** → quadratic R²=**0.588**
  (β₁=7.47, β₂=−0.68; \$1k→\$2k slope = 6.12 yrs, diminishing returns) → **log₂ R²=0.710** (a
  doubling of spending ≈ **+3.6 years**). Log wins on fit *and* interpretability.
- **Re-vehicled the controls (like L11):** the original threaded the **hand-coded 19-arm socialism
  index × `equal_liberty`** through *every* model as a control. Replaced with a single **canonical
  `civ_liberties`** control (v2xcl_rol, "Civil liberties" label) + `year`. The interaction recap is
  now a **conceptual bridge** ("a polynomial is a variable interacted with itself" → callback to
  L11), **no socialism, no `rockchalk`/3D**. Life expectancy + health spending come in **one**
  `wb_data(c(LifeExpect = ..., HealthExp = ...))` — the named vector supplies the column names.
- **Panel data:** every model uses `clusters = country` (repeated country-years are not
  independent) — kept from the original and flagged on a slide.
- **OWID embed kept** (professor's pick): one Our World in Data life-expectancy grapher iframe as
  the opening hook; the rest dropped. Localized `img/L12/LOWESS.png`; dropped the Wikipedia/BBC baby
  photos and the helpingwithmath log diagram (replaced by a clean inline `log2` demo plot).
- **Exercises (ESS xenophobia ~ age, different data from the deck):** Ex1 = fit & read a quadratic
  of age (β₁=0.19, β₂=−0.005/decade; **turning point ≈ 182 — far outside the 15–90 range**, so it's
  a gently flattening rise, not a hump — teaches recognising a meaningless extrapolated turn). Ex2 =
  log₂ of age (doubling ≈ +0.41) + poly-vs-log comparison (**equally good**, R²≈0.128) → prefer the
  simpler log + a prediction plot. **Fixed a bug carried from the original:** ex1 filtered
  `cntry == "DE"` (Germany) but relabelled the reference "Denmark" — corrected to `DK`.
- **Two bugs found & fixed during the build (both would have shipped broken):**
  - The three-model **fit-comparison table** used `coef_omit = ".*"` to show only GOF stats —
    modern `modelsummary` **errors** ("matched and omitted all coefficients") and rendered the error
    text onto the slide. Replaced with a manual `tibble`/`kable` (in a Fit / R-code tabset). **Never
    use `coef_omit = ".*"`; build a small glance table by hand instead.**
  - `civ_liberties`/`year` showed as raw variable names in the tables — added them to every
    `coef_rename` for the canonical "Civil liberties" label (design-system requirement).
- Verified in-browser: **24 slides, 15 notes, zero overflow, zero code clips, zero R errors, no
  broken images**; OWID embed + both exercises' iframes load; exercises **grade correctly** (Danish
  comma accepted, turning-point tolerance 180–182). Wired into `_quarto.yml` + `lectures.qmd`
  (callout → **1–12**).

## Lecture 11 (2026-07-23) — Interaction effects
`11-Conditionals.qmd` (26 slides, 18 notes) + `11-exercise1/2.Rmd`. **Part 1 faithful; Part 2
re-vehicled** after a pre-port review (professor's call across three questions). Two halves, both
kept, but Part 2's example was rebuilt.
- **Part 1 (continuous × categorical), faithful:** xenophobia ~ education × country (ESS r9,
  Denmark vs. Bulgaria). The full pedagogy — the multiplicative spec (`cntry * eduyrs`), the
  **conditional main-terms trap** (each main term now holds only where the other = 0), **mean-
  centring** as the fix, the interaction term's **dual/symmetric reading**, and an education × gender
  second example. **Verified numbers:** education slope in **Denmark −0.113** (educated Danes less
  xenophobic) vs. **+0.040 in Bulgaria** (flat), interaction **+0.153**. Centring moves the country
  coefficient from an uninterpretable −0.375 (gap at zero years' schooling) to +1.650 (gap at
  average) — the classic demonstration.
- **Part 2 (continuous × continuous), RE-VEHICLED onto the L9 triangle:** the original used the
  **hand-coded 19-arm socialism `case_when`** the professor already had removed from L2/L9, plus the
  stale `$2.15` line (mislabelled `$5.50`). Replaced with `poverty ~ state_ownership * civ_liberties`
  — L9's exact variables, canonical "civil liberties" label, `$3.00` line, both
  predictors mean-centred. Continues the L9 thread ("confounder or mediator?") into "**do they
  interact?**". The additive `state_ownership` slope is **−3.781**, *identical to L9* — deliberate
  continuity.
- **CRITICAL honesty fix (professor cares about academic conduct):** with the re-vehicled V-Dem data
  the interaction term is **not significant (p = 0.24)**. The original deck read its interaction as a
  substantive finding; that would be over-claiming. The ported deck now teaches the **non-
  significance as the lesson** — a red "read the table first / a picture is not a p-value" box on the
  interpretation slide, and a closing "**two layers of humility**" slide (the interaction isn't even
  significant; *and even if it were*, an interaction is still only description, not causation).
  **When re-vehicling an example onto different data, re-check significance — a story that held on
  the old data may not survive.**
- **Visuals — professor chose "both":** a static 3D `persp()` plane per example to build the
  "interaction = a warped/twisting surface" intuition, then **2D predicted-line plots** (focal slope
  at low/mean/high moderator) for actually reading off the conditional slopes. **Used base R
  `persp()`, NOT `rockchalk`/`plotly`** — both were missing, and `plotly` would embed heavy
  interactive widgets that don't print in speaker/PDF view. `persp()` is what `rockchalk::plotPlane`
  wraps anyway; renders as a static PNG, zero new dependencies. There is a `plane()` helper in the
  setup chunk. **Viewing angle `theta = 300, phi = 20`, kept IDENTICAL on the additive and
  interaction planes** (2026-07-23, professor asked) so you can flip between the two slides and watch
  the surface go from flat to twisted — the default `theta = 45` made the warp nearly invisible.
  The "Read it as lines" slide now carries the predicted-lines **R code in a Plot / R-code
  panel-tabset** (`expand.grid` → `predict` → `geom_line` — the workflow students must learn).
- **Exercises:**
  - Ex1 = the Legewie **treatment × country** interaction across 10 countries (PT reference). A
    *third* use of the Legewie data (L7 replicate, L8 adjust, L11 interact) but a genuinely different
    analysis; professor kept it. PT effect **0.330** (continuity again), Slovenia **1.232**, most
    `treat:cntry` terms significantly negative → "most effects significantly smaller than Portugal".
  - Ex2 = **NEW**: read the *same* V-Dem interaction from the **other** side (civil-liberties slope at
    levels of state ownership), driving home the **symmetry** lesson (`mc_state:mc_civ` ≡
    `mc_civ:mc_state`), then decide it is **not significant** — a deliberate cautionary counterpart to
    ex1's significant interaction. Teaches recognising a null interaction and the p-hacking trap.
- **The deck uses NO image files** — all TikZ + ggplot + `persp()`, so it renders in ~10 s offline.
  Dropped from the original: the hand-coded socialism index, two DW news `<iframe>`s, `letstimeit`
  timers, `essentials`/`furniture`, and the stock hotlinks (Marx-Engels-Lenin-Stalin etc.). The
  `xeno_quest.png` image was not needed (the RQ is now a clean text slide).
- **Gotcha (new):** a long `modelsummary(list(...), ...)` call on ONE line overflows a half-column
  (`.push-left`) code block — the content scrolls under `overflow:auto`, which on a projector reads
  as a hard clip (caught it 64 px over). **Break `modelsummary()` arguments across lines in
  half-column code chunks.** The `getBoundingClientRect().bottom` overflow sweep does *not* catch
  horizontal code overflow; measure `code`-content right vs. the block's right edge separately.
- **Exercise data-load pattern reminder:** the visible student `read_dta("file.dta")` must be
  `eval = FALSE` with a separate hidden `../assets/` read for the render — a bare evaluated student
  path fails at render (bit ex1 first pass).
- **Float bug bit the closing slide too (2026-07-23):** the "two layers of humility" `.lead`
  sentence sat *after* two `.push-left`/`.push-right` boxes and got sucked into the float gap — it
  "flew around" (professor's words). Fix: `::: {.lead .center style="clear: both;"}`. Same recurring
  pattern PROJECT.md flags for L7/L9 — any full-width block after two floats needs `clear: both`.
- Verified in-browser: **26 slides, 18 notes, zero overflow, zero R errors, no broken images**; all
  3 `persp()` planes + the DAG render; both exercises embed webexercises and **grade correctly**
  (Danish comma accepted). Wired into `_quarto.yml` + `lectures.qmd` (callout updated to **1–11**).

## Lecture 10 (2026-07-21) — IV & two-stage least squares
`10-IV-2SLS.qmd` (29 slides, 19 notes) + `10-exercise1/2.Rmd`. **Faithful port** — the pre-port
review confirmed L10 is *not* a repeat of L7 (see the note under "Next steps"). The Wald recap was
**kept deliberately**: 2SLS reduces to Wald with one instrument and no controls, and the deck
verifies that on screen to four decimals.
- **3-part arc:** (1) *does education pay off?* — ability bias, why controlling fails here (the
  decisive confounders are unmeasured), Angrist & Krueger's quarter-of-birth idea, the Wald recap;
  (2) *2SLS* — what Wald cannot do, stage one **keeps the predicted part**, stage two, `ivreg()`,
  the **2SLS = Wald** identity, and the control-vs-instrument mirror; (3) *the exclusion
  restriction* — Buckles & Hungerman, instrument-turns-confounder, and the $1/\phi$ amplification.
- **The L8 callback is the conceptual heart** and is now explicit: controlling keeps the
  **residuals** of $D$ (the part *not* correlated with the confounder); instrumenting keeps the
  **predicted values** of $D$ (the part that *is* correlated with the instrument). Same Frisch–Waugh
  machinery, opposite half retained. Presented as an ask-then-reveal, since the inversion is what
  confuses students.
- **Key numbers (all verified, `masteringmetrics::ak91`, n = 329,509):** naïve OLS **0.0709**
  (≈7.1%); first stage $\phi$ = **0.0516** years; reduced form $\rho$ = **0.00512**; Wald
  $\rho/\phi$ = **0.0992**; `ivreg(lnw ~ s | qob)` = **0.0992** — identical, which is the lecture's
  central demonstration.
  - **Deliberate teaching moment:** IV (9.9%) comes out **larger** than OLS (7.1%), the *opposite*
    of the ability-bias prediction students make earlier in the deck. The slide asks them to explain
    it and gives three honest candidates: LATE≠ATE (compliers are legal-minimum leavers),
    measurement error biasing OLS toward zero, and instrument weakness. Do not smooth this over —
    the failed prediction is the best teaching moment in the deck.
  - **The fragility payoff:** $\phi$ = 0.0516 years ≈ **19 days**, so $1/\phi \approx$ **19**. A
    hypothetical direct effect of birth quarter on log wages of just **0.001** (undetectable) biases
    the IV estimate by 0.0194 — **20% of the whole result**. That makes "weak instrument" concrete:
    not merely imprecise, but *fragile*.
- **Exercises:**
  - Ex1 = **Acemoglu & Angrist child-labour laws** (`masteringmetrics::child_labor`, 648k rows):
    first stage $\phi$ = **0.0801**, reduced form $\rho$ = **0.01121**, Wald = **0.1399**, and
    `ivreg()` 2SLS = **0.1399** — identical *even with controls*, which is Frisch–Waugh again.
    Modernised off `essentials::as.scalar`. Runtime ~12 s; that is normal, not a hang.
  - Ex2 = **NEW, on instrument fragility**: measure $\phi$, convert to days, compute $1/\phi$,
    quantify what a 0.001 violation does (20%), then show that recoding the instrument as a **Q4
    dummy** changes the Wald estimate from 0.0992 to **0.0740** — same data, same idea, several
    percentage points apart. Closes on why "n = 330,000 and highly significant" answers neither worry.
- **`ivreg` was in `about.qmd`'s setup list but NOT actually installed** — same gap
  `masteringmetrics` had for L7. Installed (0.6.8); no about.qmd edit needed. **Check the setup list
  is actually installed, not just documented, when porting.**
- **Dropped:** ~206 lines of commented-out Poland/Solidarity (Hager et al.) material and its
  `img/Hager*.png` / `Ea*.png`; three `letstimeit` iframes; the dead `uniavisen.dk` hotlink and the
  watermarked `c8.alamy.com` stock preview.
- **The deck uses NO image files at all** — every figure is TikZ or ggplot, so it renders in ~16 s
  with zero external dependencies (same virtue as L7). The 329k-row jitter scatters of the original
  were replaced by the classic **AK91 sawtooth** (mean schooling by year×quarter of birth), which is
  both better pedagogy and far lighter.
- **Gotcha (new):** the deck sets `options(digits = 3)`, which silently truncates *inline* `r`
  values — `round(wald, 4)` printed as `0.099` while the caption promised four decimals. Use
  **`sprintf("%.4f", x)`** for any inline number whose precision the surrounding text claims.
- Verified in-browser: **29 slides, zero overflow, zero R errors, no broken images**, all 7 TikZ
  DAGs render; both exercises embed webexercises. Wired into `_quarto.yml` + `lectures.qmd`
  (the "Lectures 1–7 and 9" callout on that page updated to **1–10**).

## L6 overflow cleanup (2026-07-21)
Four pre-existing overflows fixed in `6-RCTees.qmd`. **Method worth reusing:** measure each
element's `getBoundingClientRect().bottom` relative to the section, divided by reveal's scale, and
flag anything past 900 slide-units — far more reliable than `scrollHeight - clientHeight`, which
produces false positives on panel-tabsets and floated columns.
- **Opening vaccine slide** (the reported bug): the `polack_safety_2020` source line was clipped.
  The image is 1200×1065, so `out.width='55%'` made it ~780px tall. Now **44%**, and the image is
  **localized to `img/L6/vaccine_trial.jpg`** — it was hotlinked from `pbs.twimg.com` (alive, but a
  Twitter CDN dependency on a lecture's opening slide).
- **"Goal of empirical sociology"** (+18px): image 60% → 55%. Its `researchleap.com` hotlink is
  still live and is **shared with L1**, so localising it is a separate two-deck cleanup.
- **"The causal effect"** (+43px, real): the 24-line code block was clipped mid-`)`. Compressed the
  two `lm_robust()` calls to one line each (they are short enough; matches how L8/L9 write them),
  wrapped the table in `::: {.small}`, and added `style="clear: both;"` to the green box — this
  slide has the **float-collapse pattern** (a `. . .` fragment whose only child is a floated
  `.push-right`, so the fragment measures 0px high).
- **The `Exp1`/`Exp2` stimulus slides**: both images are strongly **portrait** (866×1456 and
  941×1358), so a width-based `out.width` made them ~1000px tall — Exp1 ran 132px past the slide.
  Now 52% / 62%. **Lesson: size portrait images from the aspect ratio, not by eye** — available
  height is ~780px, so `out.width ≈ 780 × (w/h) / 800` as a fraction of the column.
- Two residual measurements are **confirmed artefacts, not bugs** (checked visually): the
  "Do the groups actually differ?" tabset (940) and "It's real research!" (925).

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
- ~~Pre-existing overflow in L6~~ — **all fixed 2026-07-21** (see below). Every other deck had
  **zero overflow**; the L6 problems were confirmed pre-existing by re-measuring with every note
  removed (byte-identical results), so the notes rollout did not cause them.
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
    pipeline (live `wb_data(c(poverty = "SI.POV.DDAY"))`, $3.00 line).
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
`4-OLS-Wisdoms.qmd` (39 slides) + `4-exercise1/2.Rmd`. **Not a faithful port** — the professor
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
  `/1000` → `gdp_k` for readable slopes). **Region + income group come from
  `wb_countries()`**, joined by `iso3c`. Region ref =
  Sub-Saharan Africa (`fct_relevel`); a clean monotonic gradient SSA 0.9 t → N. America 10.6 t.
- **Exercises use INCOME GROUP** (Low→High, another free WB categorical) so students practise
  the same skills on a *different* variable, not slide transcription: Ex1 = diagnostics +
  categorical dummy coding; Ex2 = coefficient plot + prediction plot, with the scaffolded
  "carbon divide" discussion. LPM binary = "high emitter (>2 t)"; splits 55/45 and predicts
  P>1 for Qatar (the LPM cautionary tale, shown on the slide).
- **WB calls: TWO, no tryCatch (professor's call, 2026-09-22).** Both indicators come in **one**
  `wb_data(c(co2 = "EN.GHG.CO2.PC.CE.AR5", gdp = "NY.GDP.PCAP.PP.KD"), ...)` — *naming* the
  indicator vector makes wbstats name the columns, so the old `rename()` steps are gone. The
  second call is `wb_countries()`, unavoidable: `region`/`income_level` live on a different
  endpoint. `wb_data()` defaults to `country = "countries_only"`, so the old
  `filter(region != "Aggregates")` is redundant and was dropped. Most-recent year is now a
  single `drop_na(co2, gdp) %>% group_by(country) %>% filter(date == max(date))` — "the latest
  year we observe both" instead of two separate extractions joined (N = 191 either way; slope
  identical to 4 digits). **The `tryCatch` wrappers are gone** — students could not read them,
  and the API is reliable enough. Column kept as `date` (not renamed to `year`) so the cached
  `data/Dat_L4.rds` is a true drop-in for the exercise "Stuck?" URL; regenerate it with the
  pipeline in the deck's `wb-data`/`wb-build` chunks. The per-indicator caches
  (`wb_co2_raw.rds`, `wb_gdp_raw.rds`, `wb_countries_raw.rds`) are deleted. `9-exercise1/2.Rmd`
  carry a copy of this pipeline and were updated in lockstep — keep them in sync.
- **Ask-then-reveal on the first regression (professor's request, 2026-09-23):** slide 8
  "A first regression" now ends on a blue `**Discuss:**` box asking students to say the
  `gdp_k` slope out loud with units; the green payoff box moved to a new slide 9,
  "Reading the slope". Both slides use the **identical** `push-left`/`push-right` layout and
  the same `ref.label = "ols1"` chunk, so advancing swaps only the blue box for the green one
  — that visual anchoring is what makes it read as a reveal rather than a new slide. Speaker
  notes split accordingly (slide 8 = the three slips to listen for: missing units, forgetting
  the /1000 rescale, causal verbs; slide 9 = the payoff, then the low-$R^2$ pivot into Part 1).
- **Slides 13 / 14 / 15 / 18, as the professor settled them (2026-09-23):**
  - **13 "Not every outlier is an error"** — Discuss box + the two photos side by side. No tabset.
  - **14 "So: keep or drop?"** — the verdict box on its own slide. Not a preference: title +
    Discuss box + verdict box alone eat 550px of the 900px slide, so keeping panels there forced
    every figure to ~220px (illegible country labels). Also matches the 8/9 ask-then-reveal.
  - **15 "Removing the artefact"** — FIVE panels: *Outliers again* · *Linearity again* ·
    *The scatter* · *Petro vs. rest* · *Log–log*. All post-Palau, matching the slide's own
    `drop-palau` chunk. The tab strip wraps to two rows in the 65% `.right-column`; harmless.
  - **18 "CO2 by world region"** — boxplot now carries each region's **mean** as a white-outlined
    diamond (`stat_summary(fun = mean, shape = 23, color = "white", stroke = 1.1)`). The white
    outline is load-bearing: a solid marker disappears into the jitter cloud in the dense regions.
    This answers the slide's own Discuss box — with only a categorical predictor the prediction
    *is* the group mean — and lets you show the mean sitting above the median where a few heavy
    emitters pull it up.
- **Slide 20 "A dummy *is* a regression line" — restored from the PRE-QUARTO deck (2026-09-23).**
  The professor missed it: the old Hugo deck
  (`static/Lectures/4-OLS-Wisdom/4-OLS-Wisdoms.Rmd`, the `categorical` chunk in the
  "Categorical predicators" panelset) explained dummies by coding **two** categories 0/1
  (Belgium/Britain), scattering the outcome on that 0/1 X, and running `geom_smooth(method="lm")`
  through it, with a green box asking what $\hat{Y}$ is for each group and how the gap relates to
  $\hat{\beta}$. Adapted to CO2: **Sub-Saharan Africa (0) vs. Europe & Central Asia (1)** — chosen
  over the SSA/North America pair the rest of the deck uses because **North America has only 3
  countries** (Bermuda, Canada, US) and 46-vs-3 makes a lopsided scatter; 46 vs 48 reads properly.
  The numbers do the teaching: intercept **0.91** = SSA's mean exactly, slope **4.68** = the
  difference in means exactly (verified with `all.equal`). Jittered points, not country labels
  (94 names on two x-positions is a pile), plus the **same white-outlined mean diamonds as slide
  18** — the OLS line is pinned through both, which is the whole point. **Placed BEFORE dummy
  coding** (professor's call): 18 boxplot → **19 "A dummy *is* a regression line"** (blue question
  box) → **20 "$\hat{\beta}$ *is* a difference in means"** (red answer box, same figure via
  `ref.label`, values live off `b_bi`) → 21 dummy-coding table → 22 R. The picture now motivates
  the bookkeeping instead of explaining it afterwards. **Slide 18's Discuss box was deleted** — it
  asked the same question worse, and asking it twice kills the reveal.
- **Photos — full frames, no crop** (professor asked for scaling, not cropping): `img/L4/koror.jpg`
  (1100×733, 3:2) and `img/L4/ras_laffan.jpg` (1100×825, 4:3). **Licensing — the credit lines must
  stay, the site is public:** Koror–Babeldaob Bridge aerial by **Luka Peternel, CC BY-SA 4.0**;
  Ras Laffan LNG terminal by **Matthew Smith (Flickr), CC BY 2.0**, in `.backgrnote` divs linking
  to the Commons file pages. The two `out.width` values **differ on purpose** (86% / 76%): the
  aspect ratios differ, so unequal widths are what make them the same height side by side.
- **The photo pair uses flexbox, NOT `.push-left`/`.push-right`.** Those are floats, and floated
  children give a container zero height — the photos then spill out and shove everything below
  them off the slide. Cost an hour; do not "tidy" it back to the house float classes.
- **`scatter_co2(d, log = FALSE)` lives in the deck's `setup` chunk.** The CO2-vs-GDP scatter (with
  `geom_smooth(method = "lm")` → OLS line + 95% CI) is drawn on slide 7 and twice more in the
  slide-15 panels; `log = TRUE` switches both axes to `log10` for the Log–log panel. One definition
  so they cannot drift; all uses are `echo = FALSE`, so students never see the helper.
  **The log panel is called as `scatter_co2(Dat %>% filter(co2 > 0), log = TRUE)`** — Tuvalu and
  Nauru have CO2 recorded as exactly 0, and `log(0)` is `-Inf`. The professor chose to filter them
  **silently** (no on-slide footnote), so that panel's n is 2 lower than the others by design.
- **Petro panel:** petro = **oil + gas rents above 10% of GDP** (`NY.GDP.PETR.RT.ZS` +
  `NY.GDP.NGAS.RT.ZS`), 25 countries (Libya, Iraq, Kuwait, Qatar, Saudi, Brunei, UAE, Russia,
  Norway at exactly 10.0 …). Slopes: **petro 0.290 vs. 0.080** tonnes per $1k — 3.6× steeper.
  **The rents series stops in 2021** while CO2/GDP run to 2023, so the flag is built from each
  country's *most recent available* rents and treated as structural, not year-matched. The
  `petro-data` chunk sits on slide 15 right after `drop-palau`, so Palau is already gone.
  ⚠️ **This is a THIRD `wb_data()` call in L4**, in a hidden `include = FALSE` chunk, added after
  the professor cut the deck down to two. The visible Preparation pipeline is untouched (and so
  are all the exercises that mirror it). If that third call is unwanted, fold `oil`/`gas` into the
  main `wb_data()` call — but that changes the code students copy and the exercise pipelines too.
- **Two forward-references, both deliberate:** the Petro panel says interactions are **L11**; the
  Log–log panel says re-scaling curved relationships is **L12**. Both in `.backgrnote` under the
  figure, matching the linearity slide's existing "that is Lecture 12's job" note.
- **Predictions slide (now 28) shows its ggplot code (2026-09-23).** Step 3 used to be
  `echo = FALSE`, so students saw the prediction plot but never the code that drew it — while the
  coefficient-plot slide right before it *did* show its code. Now split into **"Step 3: the code"**
  (`fig.show = 'hide'`) and **"Step 4: the plot"** (`ref.label = "predplot"`), the same pattern as
  the coefficient slide. The `synth` and `predict` chunks are also commented much more heavily at
  the professor's request: why the countries are fictional, why `seq()` must stay inside the
  observed range, what `newdata` is for, that "confidence" is uncertainty about the *average*
  prediction and not where countries fall, and that `predict()` returns a **matrix** that has to be
  `as_tibble()`d and `bind_cols()`ed back beside its `gdp_k`. Those last two are where student code
  actually breaks.
- **Preview-pane gotcha (not a deck bug):** clicking inside the Browser-pane preview makes reveal
  re-scale the whole deck into a tiny corner. It reproduces on untouched slides, and a fresh
  navigate fixes it. Drive fragments with `Reveal.nextFragment()` instead of clicking, and
  cache-bust with `?v=N` after replacing an image — same filename is otherwise served stale.
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
- **Hypothesis-test build (added 2026-09-15, professor-requested — restores the old deck's
  "normal around the null" figure):** new slide "A test, step by step" after the umbrella slide
  (umbrella photo restored too, localized as `img/L3/umbrella_kids.jpg`). A hidden
  `test_plot(b, se, df, step)` function draws 7 cumulative layers — H0 → SE ruler → t-curve under
  H0 → 95% test interval → our estimate (t) → share closer to 0 (1 − p) → both red tails (p).
  The `test-build` chunk prints all 7 into a `.r-stack` as `.fragment`s (`results='asis'` loop);
  the left-column step texts carry matching `fragment-index` so text and picture advance together.
  Plots need an opaque white `plot.background` or earlier layers show through. Uses the 50-person
  `lm_robust` (HC2) model, so numbers match "Put it into practice" (β̂ .042, SE .043, t .98,
  p .33 — inside). That slide's old text-only "In one small sample" tab became **"Small vs. full
  sample"**: same function, `detail = FALSE`, shared x-axis, 50 people (inside) above all 1,511
  (smaller estimate, far outside, p = .0015). Deck is now 35 slides.
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
- **tryCatch/offline-cache convention: REMOVED course-wide (professor's call, 2026-09-22).** The
  2026-07 outage fix wrapped every `wb_data()`/`wb_countries()` call in
  `tryCatch(..., error = function(e) readRDS("data/wb_*_raw.rds"))`. **Students could not read it**
  — it put error-handling machinery in front of the one line that was supposed to teach "this is
  how you fetch data". All wrappers are gone (L2-ex2, L4 + both ex, L9 + both ex, L11 + ex2, L12),
  and the five raw caches (`wb_co2_raw`, `wb_gdp_raw`, `wb_countries_raw`, `wb_poverty_raw`,
  `wb_life_raw`) are deleted — recover from git history if ever needed. **Do NOT reintroduce the
  pattern.** What stays: the student-facing "Stuck?" bullet pointing at the *joined* cache
  `data/Dat_L4.rds` via the Netlify URL — that is plain prose a student can act on, not hidden
  control flow. Caveat accepted with eyes open: the WB API *is* occasionally slow (it timed out
  once during the 2026-09-22 verification pass), so a render can now fail on an outage — rerun it.
  `wb_search()` never needed a guard: it queries the package's bundled `wb_cachelist`, not the
  network.
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
  - **Applied to L2 (deck + both exercises), L9 (deck), L11 (deck + exercise 2), and L12 (deck); pending decks
    that reuse these vars — esp. L12 (Polynomials, uses `v2xcl_rol`) — must adopt the same labels.**
    The L2 exercises'
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
- **The new site is LIVE (since 2026-07-02):** **https://merlin-ols.netlify.app** (the site was
  renamed from `willowy-quokka-e604ee`; that old hostname now 404s — it was still hard-coded in the
  L4/L9 exercise "Stuck?" boxes until 2026-09-23, so students following that fallback got nothing.
  `_publish.yml` is the source of truth for the target). A fresh
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
   ~~Lecture 10~~ — done 2026-07-21 (IV & 2SLS; **faithful port, Wald recap kept** — see its
   section above). ~~Lecture 11~~ — done 2026-07-23 (Interactions; Part 1 faithful, Part 2
   re-vehicled onto the L9 triangle). ~~Lecture 12~~ — done 2026-07-23 (Polynomials &
   transformations; re-vehicled controls to canonical `civ_liberties` — see its section above).
   ~~Lecture 13~~ — done 2026-07-24 (RDD; faithful port + the sharp-RDD↔Wald φ=1 bridge to L7/L10,
   polynomials kept as an L12 recap — see its section above).
   ~~Lecture 14~~ — done 2026-07-25 (Conclusion; course synthesis on the class's own quiz data,
   **anonymised**; Wald harmonised to ρ/φ, RDD added to the recap — see its section above).
   **✅ MIGRATION COMPLETE — all lecture decks L1–14 are ported, verified, and live.** (Colonialism
   fully gone from the course.) Remaining work is polish/content, not deck ports — see items 5–7
   below and the two content flags (quiz-count L1 "13" vs about "10 of 14"; the pending Legewie
   Fig. 3 image for L1). The `0-Prep` setup deck was folded into `about.qmd`; a standalone port is
   optional.
   **Review each deck against the already-ported ones before porting** — L8 showed that the later
   decks were written against a course that the migration has since changed underneath them.
   **But do not over-apply the L8 lesson: checked 2026-07-21, L10 is NOT a repeat of L7.**
   L7 teaches the **Wald estimator**; L10 introduces **2SLS** and recaps Wald deliberately, because
   2SLS *reduces to* Wald with a binary instrument and no controls — the recap is load-bearing
   scaffolding for the generalisation, not redundancy. The running examples are also disjoint:
   L7 = Legewie Bali / Chetty MTO / Minneapolis; **L10 = Angrist & Krueger 1991 quarter-of-birth**
   (`masteringmetrics::ak91`), with its exercise on `masteringmetrics::child_labor`. Port L10
   faithfully; **do not cut the Wald recap.**
   - **Bonus the rebuilt L8 unlocks:** L10's *"Control vs. instrument variables"* slide pairs a
     confounder DAG against an IV DAG — controlling for $C$ keeps the **residuals** of $D$ (the part
     that does *not* correlate with $C$), while an instrument keeps the **predicted values** of $D$
     (the part that *does* correlate with $Z$). It even reuses the `DAG_FrischWaugh` TikZ. That
     symmetry now lands much harder, because the rebuilt L8 makes residualisation the *explicit
     mechanism* of controlling (`add_residuals()`, the three Frisch–Waugh steps). Wire it up as a
     deliberate callback to L8 when porting.
   - L10 ships with **only one exercise** (148 lines) — same gap L8 had; it will need a second.
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
