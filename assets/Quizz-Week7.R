# Run this line of code once. 
# It downloads Data from Gelman & Hill's "Regression and other Stories"
remotes::install_github("avehtari/ROS-Examples", subdir = "rpackage")

# Libraries for the analysis
pacman::p_load(
  tidyverse, # Data manipulation,
  haven, # Handle Stata data.
  ggplot2, # beautiful figures,
  estimatr, # Regression for weighted data,
  furniture, # For row-means,
  modelsummary, # for balance tables,
  rosdata, # Data from Gelman & Hill's "Regression and other Stories"
  texreg) # regression tables with nice layout.

# Load the Sesame Street data
data(sesame)
sesame <- as_tibble(sesame) # Turn into tibble.

# 1. The variable `watched` indicates whether a kid actually watched Sesame Street. 
# The variable `postlet` contains the results of the letter-recognition test. 
# Did kids who watched Sesame Street perform better on the letter-recognition test?

## -> OLS of the letter test as Y and with watched as dummy X gives the mean difference of interest
ols <- lm_robust(postlet ~ watched, data = sesame) 
screenreg(ols, include.ci = FALSE, digits = 3)


# 2. The variable `encouraged` indicates whether a kid was randomly encouraged by
# its pædagog to watch Sesame Street. The variable `prelet` contains results from 
# the same letter-recognition test, which the pædagogerne had conducted *before* they 
# started to encourage kids to watch Sesame Street. 
# Did the randomization of the encouragement work, or is there imbalance?

## This can be investigated with a balance table, as we learned in Session 5.
sesame %>%
  # Select variables for which I want my balance test,
  select(encouraged, prelet) %>%
  datasummary_balance( # Make a balance table,
    formula = ~ encouraged, # by encouraged
    data = . ,
    title = "Correctly identified letters before encouragement, by encouragement") 


# 3. The variable `encouraged` indicates whether a kid was randomly encouraged by 
# its pædagog to watch Sesame Street. Did kids who were encouraged to watch 
# Sesame Street perform better on the letter-recognition test? 

## An OLS with the letter test as Y and encouraged as dummy X gives the answer.
ols2 <- lm_robust(postlet ~ encouraged, data = sesame)
screenreg(ols2, include.ci = FALSE, digits = 3)


# 4. How many kids complied to the encouragement? 

## A table of absolute frequencies gives the answer
(sesam_tab <- sesame %>% 
   select('watched','encouraged') %>% 
   table())
## Compliers are the encouraged who watched + the non-encouraged who didn't watch:
138 + 40

# 5. How much higher was the proportion of kids who watched Sesame Street among the 
# encouraged kids compared to the non-encouraged kids?

## An OLS with witached sesame street as binary Y and encouraged as dummy X gives the answer.
ols3 <- lm_robust(watched ~ encouraged, data = sesame)
screenreg(ols3, include.ci = FALSE, digits = 3)


# 6. Based on the above information, what is the IV estimate of the local average 
# causal effect among complying kids?

## The IV estimate is the reduced form devided by the first stage; here:
2.876  / 0.362


# 7. Install the following package: `install.packages("ivreg", dependencies = TRUE)`. 
# Use the command `ivreg()` to estimate the IV Local Average Treatment Effect. 

## Solution
pacman::p_load(ivreg)
twosls <- ivreg(postlet ~ watched | encouraged, data = sesame)
screenreg(twosls)
