# Prepare APAX for lecture

pacman::p_load(
  tidyverse, # Data manipulation,
  furniture, # For row-means,
  haven, # Handle labelled data.
  ggplot2, # beautiful figures,
  estimatr, # Regression for weighted data,
  modelr, # Turn results of lm() into a tibble,
  texreg) # regression tables with nice layout.

APAX <- read_dta("./static/Lectures/3-RCT/APAX.dta") %>% # Read the APAX data,
  mutate(
    german = as_factor(VBY),
    nbh_exposed = case_when(
      VFB_3 == -1 | VFB_3 == 6 ~ as.numeric(NA),
      TRUE ~ zap_labels(VFB_3)),
    age = 2021 - birthyear,
    # Recode -1 & 6 to NA, and zap labels.
    dis_trainee = case_when(
      dis_trainee == -1 | dis_trainee == 6 ~ as.numeric(NA),
      TRUE ~ zap_labels(dis_trainee)),
    dis_job = case_when(
      dis_job == -1 | dis_job == 6 ~ as.numeric(NA),
      TRUE ~ zap_labels(dis_job)),
    dis_school = case_when(
      dis_school == -1 | dis_school == 6 ~ as.numeric(NA),
      TRUE ~ zap_labels(dis_school)),
    dis_house = case_when(
      dis_house == -1 | dis_house == 6 ~ as.numeric(NA),
      TRUE ~ zap_labels(dis_house)),
    dis_gov = case_when(
      dis_gov == -1 | dis_gov == 6 ~ as.numeric(NA),
      TRUE ~ zap_labels(dis_gov)),
    dis_public = case_when(
      dis_public == -1  | dis_public == 6 ~ as.numeric(NA),
      TRUE ~ zap_labels(dis_public)),
    antidiscr_law = case_when(
      antidiscr_law == -1  | antidiscr_law == 6 ~ as.numeric(NA),
      TRUE ~ zap_labels(antidiscr_law)),
    imor = as_factor(imor),
    imor = case_when(
      imor == "Mainstream" ~ "Child of immigrant",
      TRUE ~ as.character(imor)) %>% factor(),
    gender = as_factor(gender),
    gender = case_when(
      gender == "Divers" ~ "Weiblich",
      TRUE ~ as.character(gender)) %>% factor(),
    appearance = case_when(
      race == -1 & bpoc == 1 ~ as.character(NA), 
      (race == -1 & bpoc == 2) | race == 5 ~ "White",
      race == 1 ~ "Arabic",
      race == 2 ~ "Asian",
      race == 3 ~ "Black",
      race == 4 ~ "Southern"),
    article = case_when(
      article == 2 ~ "Treat_1",
      article == 3 ~ "Treat_2",
      article == 4 ~ "Contr"),
    # Average discrimination across domains.
    dis_index = rowmeans( #<<
      dis_trainee, dis_job, dis_school, 
      dis_house, dis_gov, dis_public, 
      na.rm = TRUE)) %>%
  filter(corigin != "Österreich") %>%
  mutate(
    gender = fct_drop(gender),
    imor = fct_drop(imor),
    appearance =  fct_drop(appearance)) %>%
  select(antidiscr_law, dis_index, news_hrs, news_mins, starts_with("dis_"), 
         gewFAKT, gender, age, imor, german, nbh_exposed, appearance, article)

save(APAX, file = "./static/Lectures/3-RCT/APAX.RData")
load("./static/Lectures/3-RCT/APAX.RData")
