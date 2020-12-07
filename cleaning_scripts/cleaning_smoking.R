library(tidyverse)
library(janitor)


# input raw data
smoking_scot_survey <- read_csv("data/raw_data/scot smoking survey data.csv")
council_area <- read_csv("data/raw_data/council_area_codes.csv")

# clean raw data
smoking_scot_clean <- smoking_scot_survey %>%
  clean_names() %>% 
  mutate(date_code = as.ordered(date_code)) %>% 
  arrange(date_code) %>% 
  filter(measurement == "Percent") %>% 
  select(feature_code, date_code, units, value, gender)

# add council area data
council_area_clean <- council_area %>%
  clean_names() %>% 
  select(feature_code = ca,
         council_area = ca_name,
         NHS_name = hb_name,
         NHS_code = hb)
council_area_clean

# join the datasets (joining on feature code)

inner_join(smoking_scot_clean, council_area_clean)

# output clean data
smoking_scot_clean %>% 
  write_csv("data/clean_data/clean_smoking.csv")
