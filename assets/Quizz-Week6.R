# R-script for Quiz Week 6
##########################
pacman::p_load(
  tidyverse, # Data manipulation,
  furniture, # For row-means,
  ggplot2, # beautiful figures,
  estimatr, # Regression for weighted data,
  texreg, # regression tables with nice layout,
  modelr, # Turn results of lm() into a tibble,
  modelsummary) # for balance tables

# Load APAX_2 data
load("assets/APAX_2.RData")

# 1. Recoding
APAX_2 <- APAX_2 %>%
  mutate(
    # Outcome 1: Gender discrimination (z-standardize)
    gender_discr = gender_discr %>% scale() %>% as.numeric(),
    # Outcome 2: Average discrimination index across domains,
    dis_index = rowmeans( # Make an additive index,
      dis_trainee, dis_job, dis_school,
      dis_house, dis_gov, dis_public,
      na.rm = TRUE) %>% scale() %>% as.numeric(), # z-standardize
    # Treatment
    article = article %>% 
      # Define Venus article as reference.
      fct_relevel("Das Phosphan und das Leben auf der Venus") %>%
      fct_drop()) %>% # Drop empty factor levels.
  select(gender_discr, dis_index, article, gewFAKT, isced, leftright, imor) %>%
  drop_na()
  

# How many women were treated?
table(APAX_2$article)

# 2. Balance tables with randomized news reading
APAX_2 %>%
  # Select variables for which I want my balance test,
  select(article, isced, imor, leftright, gewFAKT) %>%
  rename(weights = gewFAKT) %>% # Rename the weights variable!
  datasummary_balance( # Make a balance table,
    formula = ~ article, # by Reading news Yes/No,
    data = . , # Pipe data here.
    title = "Im-balances across randomized news reading") 

# 3. Causal effect of news about mother's discrimination on perceived gender discrimination
# Estimate weighted OLS with robust SE
ols1 <- lm_robust(gender_discr ~ article, data = APAX_2, weights = gewFAKT)
# Nicely-formatted regression table with 3 digits and standard errors
screenreg(ols1, digits = 3, include.ci = FALSE)

# 4. Causal effect of news about mother's discrimination on perceived personal discrimination
# Estimate weighted OLS with robust SE
ols2 <- lm_robust(dis_index ~ article, data = APAX_2, weights = gewFAKT)
# Nicely-formatted regression table with 3 digits and standard errors
screenreg(ols2, digits = 3, include.ci = FALSE)

# 5. Coefficient plot
plot<- bind_rows( 
  # Bind results of both regression models together
  ols1 %>% tidy(), # Turn OLS1 results into tibble
  ols2 %>% tidy(), # Turn OLS2 results into tibble
  .id = "outcome") %>% # Make a variable that identifies ols1/ols2
  filter(term != "(Intercept)") %>% # Delete the intercept from the tibble
  mutate( # Rename the model to reflect their kind of outcome.
    outcome = case_when(
      outcome == 1 ~ "Women's discrimination",
      outcome == 2 ~ "Personal discrimination")) %>%
  # Plot with ggplot
  ggplot(data = ., aes(y = estimate, x = outcome, ymin = conf.low, ymax = conf.high)) +
  geom_hline(yintercept = 0, color = "red", lty = "dashed") + # Zero reference line,
  geom_pointrange() + # The estimate with 95% Confidence Interval
  labs(x = "Frequency of:",
       y = "Difference in perceived discrimination \n compared to women who read an article about Venus") +
  coord_flip() + # Flip plot by 90 degrees.
  theme_minimal()

ggsave(plot, file = "assets/Figure_Quizz6.png")
