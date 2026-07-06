# Regenerate the consumption-vs-production snapshot for the closing slide.
# Source: Global Carbon Project, redistributed by Our World in Data.
#   cd quarto-poc && Rscript img/L4/make_consumption_cache.R   (UTF-8 locale)
suppressMessages({library(readr); library(dplyr)})

url <- "https://github.com/owid/co2-data/raw/master/owid-co2-data.csv"
owid <- read_csv(url, show_col_types = FALSE,
                 col_select = c(country, iso_code, year,
                                co2_per_capita, consumption_co2_per_capita))

consumption <- owid %>%
  filter(!is.na(consumption_co2_per_capita), !is.na(co2_per_capita),
         !is.na(iso_code), iso_code != "") %>%  # drop world/region aggregates
  group_by(country) %>% filter(year == max(year)) %>% ungroup() %>%
  rename(production = co2_per_capita,
         consumption = consumption_co2_per_capita)

saveRDS(consumption, "data/owid_consumption.rds")
cat("saved", nrow(consumption), "countries, year",
    unique(consumption$year), "->",
    sprintf("%.1f KB\n", file.size("data/owid_consumption.rds")/1024))
