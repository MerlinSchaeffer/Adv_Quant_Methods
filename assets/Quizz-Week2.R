# R-script for Quiz Week 2
##########################
pacman::p_load(
  tidyverse, # Data manipulation,
  ggplot2, # beautiful figures,
  wbstats, # download data from Worldbank. Tremendous source of global socio-economic data.
  texreg, # regression tables with nice layout,
  countrycode, # Easy recodings of country names,
  democracyData) # download democracy datasets used in the scholarly literature.

## 1.
### Get the data
(Dat_inequality <- wb_data("SI.POV.GINI", # Download Gini data:
                           start_date = 2002, end_date = 2022) %>%
   rename(gini = SI.POV.GINI) %>% # rename poverty variable,
   select(country, date, gini) %>% # Keep only 3 variables
   drop_na(gini) %>% # Drop cases with missing data,
   group_by(country) %>% # Group by country,
   filter(date == max(date)) %>% # Keep the most recent data per country.
   ungroup())

### Plot inequality around the world
ggplot(data = Dat_inequality, # Make coord system
       aes(y = gini, # Y- and X-axis of plot,
           x = reorder(country, gini))) +
  geom_bar(stat = "identity") + # plot data as is in a bar chart,
  labs(y = "Gini index of income inequality", x = "") + # Axis labels,
  theme_minimal() + # Simple background layout,
  theme(axis.text.x = element_text(angle = 60, hjust = 1)) # Write country names in a 60 degree angle.

## 2.
### Get the data
(Dat_citi_rights <- download_fh(verbose = FALSE) %>% # Download Freedom House data for all countries since 1972,
    rename(country = fh_country, # rename country ID,
           citizen_rights = fh_total_reversed, # rename Citizenship rights indicator,
           date = year) %>% # rename year,
    select(country, date, citizen_rights)) # Keep only these 3 variables.

### Join
(Dat <- inner_join(Dat_inequality, Dat_citi_rights, by = c("country", "date")))

### Scatter plot
ggplot(data = Dat, aes(y = gini, x = citizen_rights)) +
  geom_text(aes(label = country)) +
  labs(y = "Gini index of income inequality", 
       x = "Freedomhouse index of citizenship rights") +
  theme_minimal()

## 3.
cor(Dat$gini, Dat$citizen_rights) %>% round(., digits = 3)

## 4.
ols <- lm(gini ~ citizen_rights, data = Dat)
screenreg(ols, digits = 3)

## 5.
### Code the data
Dat <- Dat %>% mutate(socialist = case_when( # Years socialist minus years since,
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
    TRUE ~ socialist)) %>% drop_na() # Drop countries with missing values.

### Scatter plot
ggplot(data = Dat, aes(y = gini, x = socialist)) +
  geom_text(aes(label = country)) +
  labs(y = "Gini index of income inequality", 
       x = "Our socialism index") +
  theme_minimal()

### Correlation
cor(Dat$gini, Dat$socialist) %>% round(., digits = 3)

### OLS
ols2 <- lm(gini ~ socialist, data = Dat)
screenreg(ols2, digits = 3)

## 5.
### Z-standardization
Dat <- Dat %>%
  mutate(
    z_socialist = scale(socialist) %>% as.numeric(),
    z_citizen_rights = scale(citizen_rights) %>% as.numeric())

### OLS
ols3 <- lm(gini ~ z_citizen_rights, data = Dat)
ols4 <- lm(gini ~ z_socialist, data = Dat)
screenreg(list(ols3, ols4), digits = 3)
