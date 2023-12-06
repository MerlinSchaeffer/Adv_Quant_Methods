library(tidyverse)
library(dplyr)
library(readr)

# Read the CSV files
Q1 <- read_csv("assets/Quizz-participation/Quiz_Week1.csv") %>% select(name)
Q2 <- read_csv("assets/Quizz-participation/Quiz_Week2.csv") %>% select(name)
Q3 <- read_csv("assets/Quizz-participation/Quiz_Week3.csv") %>% select(name)
Q4 <- read_csv("assets/Quizz-participation/Quiz_Week4.csv") %>% select(name)
Q5 <- read_csv("assets/Quizz-participation/Quiz_Week5.csv") %>% select(name)
Q6 <- read_csv("assets/Quizz-participation/Quiz_Week6.csv") %>% select(name)
Q7 <- read_csv("assets/Quizz-participation/Quiz_Week7.csv") %>% select(name)
Q8 <- read_csv("assets/Quizz-participation/Quiz_Week8.csv") %>% select(name)
Q9 <- read_csv("assets/Quizz-participation/Quiz_Week9.csv") %>% select(name)
Q10 <- read_csv("assets/Quizz-participation/Quiz_Week10.csv") %>% select(name)
Q11 <- read_csv("assets/Quizz-participation/Quiz_Week11.csv") %>% select(name)
# Q12 <- read_csv("assets/Quizz-participation/Quiz_Week12.csv") %>% select(name)
# Q13 <- read_csv("assets/Quizz-participation/Quiz_Week13.csv") %>% select(name)

# Combine the dataframes into a single dataframe
dataframes <- list(Q1, Q2, Q3, Q4, Q5, Q6, Q7, Q8, Q9, Q10, Q11) # , Q12) # , Q13)
Q <- bind_rows(dataframes, .id = "source_df") %>% filter(name != "Charlotte Baarts")

# Use group_by and summarize to count the occurrences of each name
result <- Q %>%
  group_by(name) %>%
  summarize(appearances = n(), in_dataframes = list(unique(source_df)))

# Convert the list of dataframes to a character vector
result$in_dataframes <- sapply(result$in_dataframes, toString)

# Print the result
result %>% # print(n = 102)
  filter(appearances < 6 | 
           (appearances < 7 & (str_detect(in_dataframes, "10") | str_detect(in_dataframes, "11"))) |
           (appearances < 8 & str_detect(in_dataframes, "10, 11"))) %>%
  print(.)

