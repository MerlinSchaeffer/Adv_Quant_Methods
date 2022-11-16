pacman::p_load(
  tidyverse, # Data manipulation,
  texreg, # regression tables with nice layout,
  estimatr, # Regression for weighted data,
  modelr, # Turn results of lm() into a tibble,
  ivreg) # IV 2SLS

# Load data from Card (1995)
data("SchoolingReturns", package = "ivreg")

SchoolingReturns <- SchoolingReturns %>%
  transmute(
    # Log to the power of 2 wage. 
      # That is, an increase in 1 implies a doubling!
      # Accordingly, OLS coefficients can be interpreted as
      # as % change with 1 meaning a 100% increase.
    log_wage = log2(wage),
    # Years of eucation
    education = as.numeric(education),
    # Black
    black = case_when(
      ethnicity == "afam" ~ 1,
      TRUE ~ 0),
    # Family education as numeric
    fameducation = as.numeric(fameducation),
    # Age as numeric
    age = as.numeric(age),
    # parental status at age 14
    parents14 = factor(parents14),
    # Southern US states as categorical 
    south = factor(south),
    # Marital status as categorical
    married = factor(married),
    # 4-year private/public college in municipality
    nearcollege4 = factor(nearcollege4),
    # 2-year private/public college in municipality
    nearcollege2 = factor(nearcollege2))

# 1. Bivariate OLS
ols_bi <- lm_robust(log_wage ~ education, data = SchoolingReturns)
screenreg(ols_bi, # Regression table
          include.ci = FALSE, digits = 3)

# 2. Good\bad controls
# ...

# 3. Multiple OLS
ols_mult <- lm_robust(log_wage ~ education + age + fameducation + black + parents14, data = SchoolingReturns)
screenreg(list(ols_bi, ols_mult), # Regression table
          include.ci = FALSE, digits = 3)

# 4. First stage
frst_stage <- lm_robust(education ~ nearcollege4 + nearcollege2 + age + fameducation + black + parents14, data = SchoolingReturns)
screenreg(frst_stage, # Regression table
          include.ci = FALSE, digits = 3)

# 5. Reduced form
rdcd_frm <- lm_robust(log_wage ~ nearcollege4 + nearcollege2 + age + fameducation + black + parents14, data = SchoolingReturns)
screenreg(rdcd_frm, # Regression table
          include.ci = FALSE, digits = 3)

# 6. Wald-IV estimates
0.186 / 0.629
0.097 / 0.345

# 7. Second stage
SchoolingReturns <- SchoolingReturns %>%
  add_predictions(frst_stage) %>%
  rename(pred_educ = pred)

second_stage <- lm_robust(log_wage ~ pred_educ + nearcollege2 + age + fameducation + black + parents14, data = SchoolingReturns)
screenreg(second_stage, # Regression table
          include.ci = FALSE, digits = 3)


# 8. 2SLS-IV
twoSLS <- ivreg(log_wage ~ education + nearcollege2 + age + fameducation + black + parents14 | 
                  nearcollege4 + nearcollege2 + age + fameducation + black + parents14,
                data = SchoolingReturns)

screenreg(list(ols_bi, ols_mult, twoSLS), # Regression table
          include.ci = FALSE, digits = 3)
