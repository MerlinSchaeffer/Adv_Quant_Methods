## Q1. Packages and data ----

# Load packages
pacman::p_load(tidyverse, ggplot2, estimatr, texreg, wbstats)

# Get income data
dat_income <- wb_data("NY.GNP.PCAP.PP.CD",
                      start_date=2019, end_date=2019) %>% 
  rename(income = NY.GNP.PCAP.PP.CD) %>% 
  select(country, income) %>% 
  drop_na(income)

# Get CO2 data
dat_co2 <- wb_data("EN.ATM.CO2E.PC",
                      start_date=2019, end_date=2019) %>% 
  rename(co2 = EN.ATM.CO2E.PC) %>% 
  select(country, co2) %>% 
  drop_na(co2)

# Join the two datasets
(dat <- inner_join(dat_income, dat_co2, by = "country"))

# Recode income data to '000s of $
dat <- dat %>% mutate(
  income = income/1000
)

# Mean of income variable
mean(dat$income)

#----

## Q2. OLS regression ----

# Run regression
ols <- lm_robust(co2~income,data=dat)
screenreg(ols, include.ci = FALSE)

#----

## Q3. Outliers ----

# Scatterplot for eyeballing
dat %>% ggplot(aes(x=income,y=co2)) +
  geom_point() +
  geom_smooth(method=lm)

# Find most likely outlier based on eyeballing
dat %>% filter(co2>30)

# Diagnostic outlier plot
lm(co2~income,data=dat) %>%
  plot(., which=5)

# Find observation with Cook's distance > .5
dat$country[139]

# Filter out that observation
dat2 <- dat %>% filter(country!="Qatar")

# Run new regression
ols2 <- lm_robust(co2~income, data=dat2)
screenreg(list(ols,ols2), include.ci = FALSE)

#----

## Q4. Categorical predictor ----

# Recode to poor/medium/rich countries
(dat3 <- dat2 %>% mutate(
  income2 = case_when(
    income < 10 ~ "poor",
    income < 30 ~ "medium",
    T ~ "rich"
  )
))

# Run OLS
ols3 <- lm_robust(co2~income2, data=dat3)
screenreg(list(ols,ols2,ols3), include.ci = FALSE)

#----

## Q5. Coefficient plots ----

# Prepare data
plotdata <- lm_robust(co2~income2, data=dat3) %>% 
  tidy() %>% 
  mutate(
    term = case_when(
      term=="income2poor" ~ "Poor",
      term=="income2rich" ~ "Rich",
      term=="(Intercept)" ~ "Intercept"
    )
  )

# Coefficient plot
ggplot(data = plotdata, aes(y = estimate, 
                            # Order by effect size
                            x = reorder(term, estimate))) +
  geom_hline(yintercept = 0, color = "red", lty = "dashed") +
  # Point with error-bars,
  geom_pointrange(aes(min = conf.low, max = conf.high)) +
  coord_flip() + # Flip Y- & X-Axis,
  labs(
    title = "Regression of CO2 emissions",
    x = "Country income group",
    # Write Greek beta into axis title.
    y = expression("Estimate of"~beta)) +
  theme_minimal()

#----





