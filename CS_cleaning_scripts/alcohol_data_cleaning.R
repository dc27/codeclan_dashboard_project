library(tidyverse)
library(janitor)
library(here)

  # input alcohol related hospital incedents
alcohol_hospital_stats <- read.csv(here("data/alcohol/alcohol_hospital_stats.csv")) %>% 
  clean_names()
  # input scottish council area codes
council_area <- read_csv(here("data/area_codes/council_area.csv")) %>% 
  clean_names()

alcohol_hospital_stats_clean <- alcohol_hospital_stats %>% 
  # cleaning the data
  # re-name and selecting nessesary cols
  select(feature_code,
         date_code,
         units,
         count = value,
         alcohol_condition,
         hospital_classification = type_of_hospital) %>% 
  # ordering the date
  mutate(date_code = as.ordered(date_code)) %>% 
  arrange(date_code) %>% 
  # convert dates to ordered and filter for past decade
  filter(date_code > "2007/2008") %>% 
  # changing All within hospital_classification to General Hospital
  mutate(hospital_classification = str_replace_all(hospital_classification,
                                                   "All", "General Hospital"))

council_area_clean <- council_area %>% 
  # re-name and select necessary cols from data set
  select(feature_code = ca,
         council_area = ca_name,
         NHS_name = hb_name,
         NHS_code = hb)

  # inner join feature code
alcohol_hospital_area <- inner_join(alcohol_hospital_stats_clean,
                                    council_area_clean)
  #output clean data
alcohol_hospital_area %>% 
  write_csv("data/clean_data/alcohol_hospital_area.csv")


