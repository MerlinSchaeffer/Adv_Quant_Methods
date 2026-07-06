# =============================================================================
#  Lecture 3 — regenerate the sampling-distribution animations
#  Run once from quarto-poc/:  Rscript img/L3/make_animations.R
#  Needs: gganimate + gifski (the deck itself does NOT — it embeds the GIFs).
#  Produces: img/L3/anim_samples.gif, anim_hist.gif, anim_ci.gif
# =============================================================================

suppressMessages({
  library(tidyverse); library(haven); library(gganimate); library(gifski)
})

set.seed(1261990)

# --- Data (same preparation as the deck) -------------------------------------
ESS <- read_spss("../assets/ESS9e03_1.sav") %>%
  filter(cntry == "DK") %>%
  select(eduyrs, psppsgva, pspwght) %>%
  mutate(across(c(psppsgva, pspwght), zap_labels),
         eduyrs = pmin(pmax(eduyrs, 9), 21)) %>%
  drop_na()

true_beta <- coef(lm(psppsgva ~ eduyrs, data = ESS))["eduyrs"] %>% unname()

ku_red  <- "#901A1E"
ku_blue <- "#425570"
ku_gold <- "#b5892c"
# Raster GIF device + Inter font can't be trusted with Greek/unicode glyphs,
# so animation labels stay plain ASCII ("beta", "|") — the deck slides around
# them carry the proper math.
efficacy_lab <- "Political efficacy"

# =============================================================================
#  (1) anim_samples.gif — every random sample tells a slightly different story
# =============================================================================
n_lines <- 40
samples_pts <- map_dfr(1:n_lines, function(i)
  ESS %>% sample_n(50) %>% mutate(draw = i))

betas_line <- samples_pts %>%
  group_by(draw) %>%
  summarise(b = coef(lm(psppsgva ~ eduyrs))["eduyrs"], .groups = "drop")
samples_pts <- left_join(samples_pts, betas_line, by = "draw")

p1 <- ggplot(samples_pts, aes(x = eduyrs, y = psppsgva)) +
  # static backdrop: the whole "population"
  geom_jitter(data = ESS, width = 0.15, height = 0.15,
              alpha = 0.10, color = "grey55", size = 0.9) +
  # the TRUE line, always visible
  geom_smooth(data = ESS, method = "lm", se = FALSE,
              color = ku_blue, linewidth = 1.3) +
  # each sample's own line
  geom_smooth(aes(group = draw), method = "lm", se = FALSE,
              color = ku_red, linewidth = 1) +
  ylim(1, 5) +
  labs(x = "Years of education", y = efficacy_lab,
       title = "Random sample #{closest_state} of 50 people",
       subtitle = "blue = true line   |   red = this sample   |   grey = earlier samples") +
  theme_minimal(base_size = 15) +
  transition_states(draw, transition_length = 2, state_length = 1) +
  shadow_mark(color = "grey75", linewidth = 0.3, alpha = 0.25, exclude_layer = 1:2)

animate(p1, nframes = 120, fps = 12, width = 760, height = 520, res = 100,
        renderer = gifski_renderer("img/L3/anim_samples.gif"))
message("anim_samples.gif done")

# =============================================================================
#  (2) anim_hist.gif — the sampling distribution EMERGES, sample by sample
# =============================================================================
K  <- 150
bw <- 0.01
betas <- map_dbl(1:K, function(i) {
  s <- ESS %>% sample_n(50)
  coef(lm(psppsgva ~ eduyrs, data = s))["eduyrs"]
})
sd_b <- sd(betas)

# Each sample becomes ONE dot, stacked within its bin in arrival order
dots <- tibble(i = 1:K, b = betas) %>%
  mutate(bin = round(b / bw) * bw) %>%
  group_by(bin) %>% mutate(stack = row_number()) %>% ungroup()

# One dot revealed per frame -> slow, and each dot is visibly one slope
dot_frames <- map_dfr(1:K, function(k) dots %>% filter(i <= k) %>% mutate(frame = k))

p2 <- ggplot(dot_frames, aes(x = bin, y = stack)) +
  geom_vline(xintercept = true_beta, color = ku_blue, linewidth = 1.2) +
  geom_vline(xintercept = true_beta + c(-1.96, 1.96) * sd_b,
             color = ku_gold, linetype = "longdash", linewidth = 1) +
  geom_point(size = 3.2, color = ku_red, alpha = 0.9) +
  coord_cartesian(xlim = range(dots$bin) + c(-bw, bw),
                  ylim = c(0, max(dots$stack) + 1)) +
  labs(x = "Sample estimate of the slope (beta-hat)", y = "Number of samples",
       title = "Samples drawn: {current_frame}",
       subtitle = "each dot = one sample's slope   |   blue = true slope   |   gold = middle 95%") +
  theme_minimal(base_size = 15) +
  transition_manual(frame)

animate(p2, nframes = K, fps = 8, width = 820, height = 500, res = 100,
        renderer = gifski_renderer("img/L3/anim_hist.gif"))
message("anim_hist.gif done")

# =============================================================================
#  (3) anim_ci.gif — what "95% confidence" actually means
# =============================================================================
n_ci <- 100
ci <- map_dfr(1:n_ci, function(i) {
  s  <- ESS %>% sample_n(50)
  m  <- lm(psppsgva ~ eduyrs, data = s)
  est <- coef(m)["eduyrs"] %>% unname()
  se  <- summary(m)$coefficients["eduyrs", "Std. Error"]
  cv  <- qt(0.975, df = 48)
  tibble(i = i, est = est, lo = est - cv * se, hi = est + cv * se)
}) %>%
  mutate(covers = lo <= true_beta & hi >= true_beta)

ci_frames <- map_dfr(1:n_ci, function(k) {
  d <- ci %>% filter(i <= k)
  cov <- sum(d$covers)
  d %>% mutate(frame = k,
               flab = sprintf("%d samples  -  %d of their 95%% intervals (%.0f%%) cover the true slope",
                              k, cov, 100 * cov / k))
})
ci_frames <- ci_frames %>% mutate(flab = fct_reorder(flab, frame))

p3 <- ggplot(ci_frames, aes(y = i)) +
  geom_vline(xintercept = true_beta, color = ku_blue, linewidth = 1.1) +
  geom_segment(aes(x = lo, xend = hi, yend = i, color = covers), linewidth = 0.7) +
  geom_point(aes(x = est, color = covers), size = 1.1) +
  scale_color_manual(values = c(`TRUE` = "grey65", `FALSE` = ku_red), guide = "none") +
  labs(x = "Estimated slope with its 95% confidence interval",
       y = "Sample number",
       title = "{current_frame}",
       subtitle = "each row = one sample's 95% CI   |   red = misses the true slope (blue)") +
  theme_minimal(base_size = 15) +
  transition_manual(flab)

animate(p3, nframes = n_ci, fps = 11, width = 900, height = 520, res = 100,
        renderer = gifski_renderer("img/L3/anim_ci.gif"))
message("anim_ci.gif done")

# =============================================================================
#  (4) anim_band.gif — the sloped sample lines that live UNDER the CI band
#      (pairs with the "Uncertainty, drawn" slide near the end of the lecture)
# =============================================================================
n_band <- 40
band_pts <- map_dfr(1:n_band, function(i)
  ESS %>% sample_n(50) %>% mutate(draw = i))

# The 95% confidence band we would actually report, from one n=50 sample
ref_fit <- lm(psppsgva ~ eduyrs, data = ESS_first <- ESS %>% sample_n(50))
grid <- tibble(eduyrs = seq(9, 21, length.out = 60))
pred <- predict(ref_fit, newdata = grid, interval = "confidence", level = 0.95)
band <- bind_cols(grid, as_tibble(pred))

p4 <- ggplot(band_pts, aes(x = eduyrs, y = psppsgva)) +
  geom_jitter(data = ESS, width = 0.15, height = 0.15,
              alpha = 0.08, color = "grey55", size = 0.9) +
  # accumulating sample regression lines — these sit UNDER the band
  geom_smooth(aes(group = draw), method = "lm", se = FALSE,
              color = ku_red, linewidth = 0.7, alpha = 0.5) +
  # the 95% confidence band, laid over the lines
  geom_ribbon(data = band, aes(x = eduyrs, ymin = lwr, ymax = upr),
              inherit.aes = FALSE, fill = ku_blue, alpha = 0.22) +
  geom_line(data = band, aes(x = eduyrs, y = fit),
            inherit.aes = FALSE, color = ku_blue, linewidth = 1.2) +
  ylim(1, 5) +
  labs(x = "Years of education", y = efficacy_lab,
       title = "Each red line is one sample's regression line",
       subtitle = "blue band = a 95% CI for the line   |   the sample lines mostly fall inside it") +
  theme_minimal(base_size = 15) +
  transition_states(draw, transition_length = 2, state_length = 1) +
  shadow_mark(color = "grey70", linewidth = 0.3, alpha = 0.25, exclude_layer = c(1, 3, 4))

animate(p4, nframes = 120, fps = 12, width = 780, height = 520, res = 100,
        renderer = gifski_renderer("img/L3/anim_band.gif"))
message("anim_band.gif done")
