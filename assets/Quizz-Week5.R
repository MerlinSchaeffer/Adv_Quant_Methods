#Selection bias quiz

# load packages and APAX data---

pacman::p_load(
  tidyverse, # Data manipulation,
  furniture, # For row-means,
  ggplot2, # beautiful figures,
  estimatr, # Regression for weighted data,
  modelr, # Turn results of lm() into a tibble,
  modelsummary, # for balance tables,
  texreg) # regression tables with nice layout.

load("C:/Users/B059064/Desktop/PHD/teaching/advanced stats/APAX.RData") # Read APAX data,
APAX <- APAX %>% mutate(
  # News in minutes,
  news = news_hrs*60 + news_mins, 
  news_yn = case_when( # News Yes/No,
    news < 15 ~ 0, # Less than 15  minutes,
    news >= 15 ~ 1, # 15  minutes and more,
    TRUE ~ as.numeric(NA)),
  # Average discrimination index across domains,
  dis_index = rowmeans(
    dis_trainee, dis_job, dis_school,
    dis_house, dis_gov, dis_public,
    na.rm = TRUE),
  # Z-standardized discrimination index.
  z_dis_index = scale(dis_index) %>% 
    as.numeric()) 

#Question 1----

# How many observations and how many variables?

nrow(APAX)

ncol(APAX)


#Question 2----

##What is a confounder?-----

#has to be related to both the treatment and the outcome

#needs to only be related to the treatment

#needs to only be related to the outcome

#Doesn't need to be related to either the treatment or the outcome in order to bias our results

#Qustion 3------

##compute selection bias-----

#groups of treated and untreated individuals are compared, but they live in different cities

# We measure their attitudes towards mintorities on a scale of 1-10, where 10 is being friendly towards
# minorities and 1 is being unfriendly to minorities

#one group(the treatment group) is subjected to an info campaign to stop discrimination

#after the treatment, the average of the treatment group is 6 and the average of the control group is 7.5

#however, by some miracle we are given a time machine and we travel back in to stop politicians from 
#enacting a frutiless and costly campaign

#In this alternate reality, where no one is treated, the average score of the treatment group is 2 and
#the average score of the control group is 7

#(hint: Look up pages 8-11 in "Mastering metrics")

#naive difference----

naive <- 6-7.5

##what is the true effect of the campaign------

true.eff <- 6-2

##how large is the selection bias?----

sel.bias <- 2-7.5

#Question 4---

# make trust binary var-------

APAX$trust_cat <- ifelse(APAX$gen_trust>=3, 1,0)

##how many obs in each category-----

table(APAX$trust_cat)


#Question 5-----

##Make balance table to see if happiness or other things are imbalanced-----


APAX %>%
  # Select variables for which I want my balance test,
  select(trust_cat, ment_happy, gewFAKT) %>%
  rename(weights = gewFAKT) %>% # Rename the weights variable!
  datasummary_balance( # Make a balance table,
    formula = ~ trust_cat, # by Reading news Yes/No
    data = . ,
    title = "Physical appearance of those who read news and those who don't") 

#Question 6----

# is happiness a confounder between trust -> dis_index?------



##does happiness impact trust?---


lm_robust(trust_cat~ment_happy, 
          weight = gewFAKT, data = APAX)


##does happiness impact dis_index?----


lm_robust(dis_index~ment_happy, 
          weight = gewFAKT, data = APAX)


