library(tidyverse)
library(janitor)
library(here)

  #input raw data and clean col names
drug_related_hospital <- read_csv(here("data/drug/drug_related_hospital_discharge.csv")) %>%
  clean_names()

  #input scottish area codes
council_area <- read_csv(here("area_codes/council_area.csv")) %>% 
  clean_names()

drug_related_hospital_clean <- drug_related_hospital %>% 
  # convert dates to ordered and filter for past decade
  mutate(date_code = as.ordered(date_code)) %>% 
  arrange(date_code) %>% 
  filter(date_code > "2007/2008")

council_area_clean <- council_area %>% 
  # re-name and select nessesary cols from data set
  select(feature_code = ca,
         council_area = ca_name,
         NHS_name = hb_name,
         NHS_code = hb)

  # inner join feature code
drug_hospital_area <- inner_join(drug_related_hospital_clean,
                                 council_area_clean)
  #output clean data
drug_hospital_area %>% 
  write_csv("data/clean_data/drug_hospital_area.csv")




