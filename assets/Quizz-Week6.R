# R-script for Quiz Week 6
##########################
pacman::p_load(
  tidyverse, # Data manipulation,
  haven, # Handle Stata and SPSS data,
  ggplot2, # beautiful figures,
  estimatr, # Regression for weighted data,
  texreg, # regression tables with nice layout,
  modelr, # Turn results of lm() into a tibble,
  modelsummary) # for balance tables

# Read data
APAX_2 <- haven::read_dta("assets/APAX2.dta") %>%
  mutate(
    leftright = zap_labels(leftright),
    gen_trust = zap_labels(gen_trust),
    ment_happy = zap_labels(ment_happy),
    imor = as_factor(imor),
    article = as_factor(article))
save(APAX_2, file = "assets/APAX_2.RData")

# Load APAX_2 data
load("assets/APAX_2.RData")

# 1. Recoding
APAX_2 <- APAX_2 %>%
  mutate(
    # News in minutes,
    news = news_hrs*60 + news_mins, 
    news_yn = case_when( # News Yes/No,
      news < 15 ~ 0, # Less than 15  minutes,
      news >= 15 ~ 1, # More than 15  minutes,
      TRUE ~ as.numeric(NA)),
    # Outcome: Gender discrimination (z-standardized)
    gender_discr = case_when(
      gender_discr < 0 ~ as.numeric(NA),
      TRUE ~ gender_discr %>% scale() %>% as.numeric()),
    # Treatment: 
    article = article %>% 
      fct_relevel("Das Phosphan und das Leben auf der Venus") %>%
      fct_drop())

# How many women were treated?
table(APAX_2$article)

# 2. Balance table with observed news reading
APAX_2 %>%
  # Select variables for which I want my balance test,
  select(news_yn, isced, imor, leftright, gen_trust, ment_happy, gewFAKT) %>%
  rename(weights = gewFAKT) %>% # Rename the weights variable!
  datasummary_balance( # Make a balance table,
    formula = ~ news_yn, # by Reading news Yes/No
    data = . ,
    title = "Physical appearance of those who read news and those who don't") 




