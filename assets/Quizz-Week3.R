# Packages for Quizz 3
pacman::p_load(
  tidyverse,
  haven,
  ggplot2, 
  estimatr,
  modelr,
  texreg,
  janitor,
  stargazer)

# Load ESS round 9 data
ESS <- read_spss("./assets/ESS9e03_1.sav") %>% 
  filter(cntry == "DK") %>%  # Keep only respondents from DK,
  select(idno, pspwght, agea, # Work with a selected number of variables,
         psppipla, nwspol) %>% 
  drop_na() # Drop respondents with missing values.

# Remove missing values coded as numerical!
ESS <- ESS %>% 
  mutate(
    political_efficacy = if_else(
      zap_labels(psppipla) > 5, NA_real_, zap_labels(psppipla)),
    nwspol = if_else(
      zap_labels(nwspol) == 8888, NA_real_, zap_labels(nwspol)))  %>%
  drop_na(political_efficacy, nwspol)

# Checking number of respondents in sample - should be 1534
nrow(ESS)

# Estimating bivariate regression model
m1 <- lm(political_efficacy ~ agea, data = ESS)
screenreg(m1, digits = 3)

# Getting confidence intervals with stargazer
stargazer(m1, 
          type = "text",
          ci = TRUE)


# Making scatter plot with confidence intervals
ESS %>% 
  ggplot(aes(x = agea, y = political_efficacy)) +
  geom_point()+
  geom_smooth(method = "lm", level = 0.95) +
  scale_x_continuous(breaks = c(15, 25, 35, 45, 55, 65, 75, 85, 95)) +
  scale_y_continuous(breaks = c(1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5))


#Estimating multiple regression model
m2 <- lm(political_efficacy ~ nwspol, data = ESS)
summary(m2)

#Estimating multiple regression models with weights
m3 <- lm_robust(political_efficacy ~ agea, weights = pspwght, data = ESS)
summary(m3)

m4 <- lm_robust(political_efficacy ~ nwspol, weights = pspwght, data = ESS)
summary(m4)




