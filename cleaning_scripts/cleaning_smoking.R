library(tidyverse)
library(janitor)


# input raw data
smoking_scot_survey <- read_csv("data/raw_data/scot smoking survey data.csv")
council_area <- read_csv("data/raw_data/council_area_codes.csv")

# clean raw data
smoking_data_clean <- smoking_scot_survey %>%
  clean_names() %>% 
  mutate(date_code = as.ordered(date_code)) %>% 
  arrange(date_code) %>% 
  filter(measurement == "Percent") %>%
  filter(limiting_long_term_physical_or_mental_health_condition == "All") %>% 
  filter(type_of_tenure == "All") %>% 
  filter(household_type == "All") %>%
  filter(age != "16-64 years") %>%
  separate(date_code, sep = "-",
           into = c("date_start", "date_end"), remove = FALSE) %>%
  mutate(date_diff = as.integer(date_end) - as.integer(date_start)) %>% 
  filter(is.na(date_end)|(date_diff==1)) %>% 
  filter(str_detect(feature_code, "S12"))


# add council area data
council_area_clean <- council_area %>%
  clean_names() %>% 
  select(feature_code = ca,
         council_area = ca_name) %>% 
  unique()

# join the datasets (joining on feature code) & remove duplicate rows

smoking_clean_join <- inner_join(smoking_data_clean, council_area_clean)

# output clean data
smoking_clean_join %>% 
  write_csv("data/clean_data/clean_smoking.csv")
