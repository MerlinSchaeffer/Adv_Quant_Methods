library(tidyverse)
library(dplyr)
library(readr)
library(text) # Python-driven large language models

# Read the CSV files
Q1 <- read_csv("assets/Quizz-participation/Quiz_Week1.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct)
Q2 <- read_csv("assets/Quizz-participation/Quiz_Week2.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct)
Q3 <- read_csv("assets/Quizz-participation/Quiz_Week3.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct)
Q4 <- read_csv("assets/Quizz-participation/Quiz_Week4.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct)
Q5 <- read_csv("assets/Quizz-participation/Quiz_Week5.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct)
Q6 <- read_csv("assets/Quizz-participation/Quiz_Week6.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct)
Q7 <- read_csv("assets/Quizz-participation/Quiz_Week7.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct)
Q8 <- read_csv("assets/Quizz-participation/Quiz_Week8.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct)
Q9 <- read_csv("assets/Quizz-participation/Quiz_Week9.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct)
Q10 <- read_csv("assets/Quizz-participation/Quiz_Week10.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct)
Q11 <- read_csv("assets/Quizz-participation/Quiz_Week11.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct)
Q12 <- read_csv("assets/Quizz-participation/Quiz_Week12.csv") %>% mutate(correct = (`n correct` / (`n correct` + `n incorrect`)) * 100) %>% select(name, correct)
# Q13 <- read_csv("assets/Quizz-participation/Quiz_Week13.csv") %>% select(name)

# Combine the dataframes into a single dataframe
dataframes <- list(Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11, Q12) # , Q13)
Q <- bind_rows(dataframes, .id = "source_df") %>% filter(name != "Charlotte Baarts")

# Use group_by and summarize to count the occurrences of each name
result <- Q %>%
  group_by(name) %>%
  summarize(
    mcorrect = mean(correct),
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
    pivot_wider(names_from = statskills, values_from = scores), by = "name")


# LLM  zero-shot encoding 
## 3. Non-Danish name 
###################################
zeroshot <- text::textZeroShot(
  # The list of first names to be predicted.
  sequences = result$name,
  # The possible genders for the first names.
  candidate_labels = c("Danish"),
  # Indicates whether multiple genders should be predicted for each first name.
  multi_label = FALSE,
  # The template for the hypothesis that is generated for each first name.
  hypothesis_template = "A Person with this name is {}.",
  # The model that is used to predict the gender.
  model = "alexandrainst/scandi-nli-base") %>%
  # Renames the column `sequences` to `name`.
  rename(name = sequence)

result <- left_join( # Join apax and name encoded data
  result, # The original survey data.
  rbind( # Stack zero-shot columns into one long tibble
    zeroshot %>% select(name, labels_x_1, scores_x_1) %>% rename(Danish = labels_x_1, scores = scores_x_1)) %>% #,
    # zeroshot %>% select(name, labels_x_2, scores_x_2) %>% rename(gender = labels_x_2, scores = scores_x_2)) %>%
    # Turn into wide tibble with one row per name
    pivot_wider(names_from = Danish, values_from = scores), by = "name")

# Print the result
result %>% print(n = 102)

# Who is not qualified?
result %>%
  filter(appearances < 7 | 
           (appearances < 8 & (str_detect(in_dataframes, "11") | str_detect(in_dataframes, "12"))) |
           (appearances < 9 & str_detect(in_dataframes, "11, 12"))) %>%
  print(.)

save(result, file = "/Users/fsm788/Documents/Teaching/My classes/Multiple Regression and Causal Inference/static/Lectures/14-Conclusion/Result.RData")
