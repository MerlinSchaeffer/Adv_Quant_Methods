pacman::p_load(
  tidyverse, # Data manipulation,
  ggplot2, # beautiful figures,
  wbstats, # download data from Worldbank. Tremendous source of global socio-economic data.
  estimatr, # OLS with robust SE
  texreg, # regression tables with nice layout,
  directlabels, # Labels addded to ggplot2 lines,
  democracyData) # download democracy data used in the scholarly literature.

# Worldbank data
Dat_regbaby <- wb_data(
  # Download % of registered new borns and GDP per capita.
  c("SP.REG.BRTH.ZS", "NY.GDP.PCAP.CD"),
  start_date = 2002, end_date = 2022) %>%
  rename(RegistBaby = SP.REG.BRTH.ZS, # rename variables,
         GDPpp = NY.GDP.PCAP.CD) %>%
  select(country, date, RegistBaby, GDPpp) %>% # Keep only 4 variables
  drop_na(RegistBaby, GDPpp) # Drop cases with missing data

# Citizenship data
Dat_citi_rights <- download_fh(verbose = FALSE) %>% # Download Freedom House data for all countries since 1972,
  rename(country = fh_country, # rename variables,
         citizen_rights = fh_total_reversed,
         date = year) %>%
  # Keep only 3 variables.
  select(country, date, citizen_rights)

# Join Worldbank registered babies and Citizenship rights data
Dat <- inner_join(Dat_regbaby, Dat_citi_rights, by = c("country", "date"))

# Socialism index
Dat <- Dat %>%
  mutate(socialist = case_when( # Years socialist minus years since,
    country == "China" ~ date - 1949,
    country == "Vietnam" ~ date - 1945,
    country == "Algeria" ~ date - 1962,
    str_detect(country,"Portugal|Bangladesh") ~ date - 1972,
    country == "Guinea-Bissau" ~ date - 1973,
    country == "India" ~ date - 1976,
    country == "Nicaragua" ~ date - 1979,
    country == "Sri Lanka" ~ date - 1978,
    country == "Tanzania" ~ date - 1964,
    country == "Albania" ~ (1992 - 1944) - (date - 1992),
    str_detect(country, "Angola|Cabo Verde|Madagascar") ~ (1992 - 1975) - (date - 1992),
    str_detect(country,"Belarus|Bulgaria") ~ (1990 - 1946) - (date - 1990),
    str_detect(country, "Benin|Mozambique") ~ (1990 - 1975) - (date - 1990),
    country == "Chad" ~ (1975 - 1962) - (date - 1975), country == "Congo, Rep." ~ (1992 - 1970) - (date - 1992),
    country == "Czech Republic" ~ (1990 - 1948) - (date - 1990), country == "Djibouti" ~ (1992 - 1981) - (date - 1992),
    country == "Ethiopia" ~ (1991 - 1974) - (date - 1991), country == "Ghana" ~ (1966 - 1960) - (date - 1966),
    country == "Guinea" ~ (1984 - 1958) - (date - 1984), country == "Hungary" ~ (1989 - 1949) - (date - 1989),
    country == "Iraq" ~ (2005 - 1958) - (date - 2005), country == "Mali" ~ (1991 - 1960) - (date - 1991),
    country == "Mauritania" ~ (1978 - 1961) - (date - 1978), country == "Mongolia" ~ (1992 - 1924) - (date - 1992),
    country == "Myanmar" ~ (1988 - 1962) - (date - 1988), country == "Poland" ~ (1989 - 1945) - (date - 1989),
    country == "Romania" ~ (1989 - 1947) - (date - 1989), country == "Russian Federation" ~ (1991 - 1922) - (date - 1991),
    country == "Seychelles" ~ (1991 - 1977) - (date - 1991), country == "Senegal" ~ (1981 - 1960) - (date - 1981),
    country == "Sierra Leone" ~ (1991 - 1978) - (date - 1991), country == "Somalia" ~ (1991 - 1969) - (date - 1991),
    country == "Sudan" ~ (1985 - 1969) - (date - 1985), country == "Syria" ~ (2012 - 1963) - (date - 2012),
    country == "Tunisia" ~ (1988 - 1964) - (date - 1988), country == "Ukraine" ~ (1991 - 1919) - (date - 1991),
    country == "Yemen, Rep." ~ (1991 - 1967) - (date - 1991), country == "Zambia" ~ (1991 - 1973) - (date - 1991),
    str_detect(country,"Slovenia|Croatia|Serbia|Montenegro|Bosnia and Herzegovina|North Macedonia|Kosovo") ~ (1992 - 1943) - (date - 1992),
    TRUE ~ 0),
    socialist = case_when( # Min. 5 years given socialist history,
      (socialist < 5 & socialist > 0) | socialist < 0 ~ 5,
      TRUE ~ socialist)) %>% 
  drop_na() # Drop countries with missing values.

# 1. Country with smallest % registered newborn
Dat %>% filter(RegistBaby == min(Dat$RegistBaby))

# 2. Plot the development of how many new born babies are registered by state authorities over time for Denmark, Mexico, Mali, and Vietnam. 
# You find a similar graph and its code on Slide 7 of this week's lecture.
ggplot(data = Dat %>% filter(country == "Denmark" | country == "Mali" | country == "Mexico" | country == "Vietnam"), 
       aes(y = RegistBaby, x = GDPpp, color = country)) +
  geom_line(alpha = 0.5) +
  geom_text(aes(label = date), size = 2.3) +
  scale_x_continuous(expand=c(0, 9000)) +
  geom_dl(aes(label = country), method = list(dl.combine("last.points"))) +
  theme_minimal() +
  labs(y = "Percent of babies registered at birth",
       x = "GDP per capita") +
  guides(color = "none")

# 3. Now make the plot for all countries and add a LOESS, just as in Slide 14.
ggplot(data = Dat, aes(y = RegistBaby, x = GDPpp)) +
  geom_line(aes(color = country), alpha = 0.5) +
  geom_point(aes(color = country), alpha = 0.5) +
  geom_smooth() +
  theme_minimal() +
  labs(y = "Percent of babies registered at birth",
       x = "GDP per capita in $") +
  guides(color = "none")

# 3 to 4. Make similar plots for citizenship rights and socialism as predictors.
ggplot(data = Dat, aes(y = RegistBaby, x = citizen_rights)) +
  geom_line(aes(color = country), alpha = 0.5) +
  geom_point(aes(color = country), alpha = 0.5) +
  geom_smooth() +
  theme_minimal() +
  labs(y = "Percent of babies registered at birth",
       x = "Index of Citizenship rights") +
  guides(color = "none")

ggplot(data = Dat, aes(y = RegistBaby, x = socialist)) +
  geom_line(aes(color = country), alpha = 0.5) +
  geom_point(aes(color = country), alpha = 0.5) +
  geom_smooth() +
  theme_minimal() +
  labs(y = "Percent of babies registered at birth",
       x = "Years of Socialism") +
  guides(color = "none")

# 5 to 6. Make a multiple OLS model with GDP per capita, citizenship rights, socialism, and date as predictors. 
# Use `I()` to estimate the relationship of GDPpp in $1000.
# Remember to add the option "clusters = country", because we now have repeated observations for every country.
ols <- lm_robust(RegistBaby ~ I(GDPpp / 1000) + citizen_rights + socialist + date, data = Dat, clusters = country)
screenreg(ols, include.ci = FALSE, digits = 3)

# 7. Try to improve the model by modeling the non-linear GDP per capita relationship. 
# Which is better, a $\log_2$ transformation or polynomials up to three (more than that get's quite messy, over-complex, and difficult to interpret)?
olslog <- lm_robust(RegistBaby ~ I(log2(GDPpp)) + citizen_rights + socialist + date, data = Dat, clusters = country)
olspoly2 <- lm_robust(RegistBaby ~ poly(I(GDPpp / 1000), 2, raw = TRUE) + citizen_rights + socialist + date, data = Dat, clusters = country)
olspoly3 <- lm_robust(RegistBaby ~ poly(I(GDPpp / 1000), 3, raw = TRUE) + citizen_rights + socialist + date, data = Dat, clusters = country)
screenreg(list(olslog, olspoly2, olspoly3), include.ci = FALSE, digits = 3)

# 6. Now try to further improve the non-linear fit of citizenship rights and the percent of registered new born children, by introducing up to three polynomials.
olslogpoly2 <- lm_robust(RegistBaby ~ I(log2(GDPpp)) + poly(citizen_rights, 2, raw = TRUE) + socialist + date, data = Dat, clusters = country)
olslogpoly3 <- lm_robust(RegistBaby ~ I(log2(GDPpp)) + poly(citizen_rights, 3, raw = TRUE) + socialist + date, data = Dat, clusters = country)
screenreg(list(olslog, olslogpoly2, olslogpoly3), include.ci = FALSE, digits = 3)

# 7. It seems that registration is simply a function of GDP per capita; none of the other predictors remains statistically significant.
# Visualize the relationship between registered children at birth and GDP per capita, based on a model with all controls. 
# Set date to 2022, and socialism and citizenship rights to their mean.
(fict_dat <- tibble( # 1. Make fictional data
  # Realistic variation in x: Min to max
  GDPpp = min(Dat$GDPpp):max(Dat$GDPpp), 
  # Hold other variables constant.
  socialist = mean(Dat$socialist), # Socialist
  citizen_rights = mean(Dat$citizen_rights), # Democracy
  date = 2022)) # most recent date

(fict_dat <- predict( # 2. Get predictions
  olslog, newdata = fict_dat,
  interval = "confidence", level = 0.95)$fit %>%
    as_tibble() %>% # Turn into a tibble, then
    bind_cols(fict_dat, .)) # Add to the synthetic data.

# 3. Plot the predictions
ggplot(data = fict_dat, aes(y = fit, x = GDPpp)) +
  geom_hline(yintercept = 100, color = "red") +
  geom_ribbon(aes(ymin = lwr, ymax = upr), alpha = 0.5) +
  geom_line() +
  labs(title = "Predictions percent of registered children",
       x = "By GPD per capita $
        (Socialism, Citizenship rights, and time held constant)",
       y = "Predicted percent of registered babies") +
  theme_minimal()

## As you can see: we get prediction >100%, which makes no sense! Generalized linear models can solve that problem. But that is for another semester ...