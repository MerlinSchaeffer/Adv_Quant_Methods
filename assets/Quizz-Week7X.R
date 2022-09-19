pacman::p_load(
  tidyverse, # Data manipulation,
  ggplot2, # beautiful figures,
  texreg, # regression tables with nice layout,
  estimatr, # Regression for weighted data,
  modelr, # Turn results of lm() into a tibble,
  modelsummary, # for balance tables,
  ivreg, # IV 2SLS,
  masteringmetrics, # Data and examples from Mastering Metrics
  remotes) # Install beta version packages from GitHub.

# Load the data from the Minneapolis Domestic Violence Experiment
data("mdve", package = "masteringmetrics")

mdve <- mdve %>%
  mutate(
  ID = as.numeric(ID)) %>%
  select(ID, T_RANDOM, T_FINAL)


mdve <- left_join(mdve, read_dta("./assets/08250-0008-Data.dta"), by = "ID")

