library(tidyverse)
library(dplyr)
library(readr)
library(text) # Python-driven large language models
library(estimatr)
textrpp_initialize()

# Read the CSV files
Q1 <- read_csv("assets/Quizz-participation/2025/Quiz_Week1.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct, score)
Q2 <- read_csv("assets/Quizz-participation/2025/Quiz_Week2.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct, score)
Q3 <- read_csv("assets/Quizz-participation/2025/Quiz_Week3.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct, score)
Q4 <- read_csv("assets/Quizz-participation/2025/Quiz_Week4.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct, score)
Q5 <- read_csv("assets/Quizz-participation/2025/Quiz_Week5.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct, score)
Q6 <- read_csv("assets/Quizz-participation/2025/Quiz_Week6.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct, score)
Q7 <- read_csv("assets/Quizz-participation/2025/Quiz_Week7.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct, score)
Q8 <- read_csv("assets/Quizz-participation/2025/Quiz_Week8.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct, score)
Q9 <- read_csv("assets/Quizz-participation/2025/Quiz_Week9.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct, score)
Q10 <- read_csv("assets/Quizz-participation/2025/Quiz_Week10.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct, score)
Q11 <- read_csv("assets/Quizz-participation/2025/Quiz_Week11.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct, score)
Q12 <- read_csv("assets/Quizz-participation/2025/Quiz_Week12.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct, score)
Q13 <- read_csv("assets/Quizz-participation/2025/Quiz_Week13.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct, score)

# Combine the dataframes into a single dataframe
dataframes <- list(Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12, Q13)
Q <- bind_rows(dataframes, .id = "source_df") # %>% filter(name != "Charlotte Baarts")

# Reshape to wide
Qw <- pivot_wider(Q, id_cols = name, names_from = source_df, values_from = c(score, correct))

# Use group_by and summarize to count the occurrences of each name
result <- Q %>%
  group_by(name) %>%
  summarize(
    mcorrect = mean(correct),
    mscore = mean(score),
    appearances = n(), in_dataframes = list(unique(source_df)))

# Convert the list of dataframes to a character vector
result$in_dataframes <- sapply(result$in_dataframes, toString)

# LLM  zero-shot encoding 
## 1. Predict gender of first names.
###################################
zeroshot <- text::textZeroShot(
  # The list of first names to be predicted.
  sequences = result$name,
  # The possible genders for the first names.
  candidate_labels = c("woman"),
  # Indicates whether multiple genders should be predicted for each first name.
  multi_label = FALSE,
  # The template for the hypothesis that is generated for each first name.
  hypothesis_template = "A Person with this name is a {}.",
  # The model that is used to predict the gender.
  model = "alexandrainst/scandi-nli-base") %>%
  # Renames the column `sequences` to `name`.
  rename(name = sequence)

result <- left_join( # Join apax and name encoded data
  result, # The original survey data.
  rbind( # Stack zero-shot columns into one long tibble
    zeroshot %>% select(name, labels_x_1, scores_x_1) %>% rename(gender = labels_x_1, scores = scores_x_1)) %>% #,
    # zeroshot %>% select(name, labels_x_2, scores_x_2) %>% rename(gender = labels_x_2, scores = scores_x_2)) %>%
    # Turn into wide tibble with one row per name
    pivot_wider(names_from = gender, values_from = scores), by = "name")

# LLM  zero-shot encoding 
## 2. Predict Stats!
###################################
zeroshot <- text::textZeroShot(
  # The list of first names to be predicted.
  sequences = result$name,
  # The possible genders for the first names.
  candidate_labels = c("Statistics"),
  # Indicates whether multiple genders should be predicted for each first name.
  multi_label = FALSE,
  # The template for the hypothesis that is generated for each first name.
  hypothesis_template = "A Person with this name is great at {}.",
  # The model that is used to predict the gender.
  model = "alexandrainst/scandi-nli-base") %>%
  # Renames the column `sequences` to `name`.
  rename(name = sequence)

result <- left_join( # Join apax and name encoded data
  result, # The original survey data.
  rbind( # Stack zero-shot columns into one long tibble
    zeroshot %>% select(name, labels_x_1, scores_x_1) %>% rename(statskills = labels_x_1, scores = scores_x_1)) %>% #,
    # zeroshot %>% select(name, labels_x_2, scores_x_2) %>% rename(gender = labels_x_2, scores = scores_x_2)) %>%
    # Turn into wide tibble with one row per name
    pivot_wider(names_from = statskills, values_from = scores), by = "name") %>%
  mutate(
    Statistics = scale(Statistics) %>% as.numeric())


ggplot(data = result, aes(y = mscore, x = Statistics)) +
  geom_point() +
  geom_smooth()

lm_robust(mscore ~ woman + Statistics, data = result, weights = (appearances / 13))

# Print the result
result %>% print(n = 102)

# Who is not qualified?
result %>%
  filter(appearances < 10) %>%
  print(.)

save(result, file = "/Users/fsm788/Documents/Adv_Quant_Methods/static/Lectures/14-Conclusion/Result.RData")
