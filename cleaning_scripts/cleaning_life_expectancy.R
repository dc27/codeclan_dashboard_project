library(tidyverse)

# input raw data
life_expectancy_data <- read_csv("data/raw_data/life_expectancy.csv")

life_expectancy_data_clean <- life_expectancy_data %>%
  # clean col names
  janitor::clean_names() %>% 
  # convert dates to ordered and filter for past decade
  mutate(date_code = as.ordered(date_code)) %>% 
  arrange(date_code) %>% 
  filter(date_code > "2006-2008") %>%
  # not every year contains detail for specific URC
  filter(urban_rural_classification == "All") %>%
  # LE for each age band is not necessary for analysis
  filter(age == "0 years")

# output clean data
life_expectancy_data_clean %>% 
  write_csv("data/clean_data/life_expectancy_clean.csv")