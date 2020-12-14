#####----- libraries -----#####
library(tidyverse)
library(janitor)
library(here)

source("config.R")

#####-----life expectancy stats-----#####
# 1. input raw data
life_expectancy_data <- read_csv("data/raw_data/life_expectancy.csv")

life_expectancy_data_clean <- life_expectancy_data %>%
  # 2.1 clean col names
  janitor::clean_names() %>% 
  # 2.2 convert dates to ordered and filter for past decade
  mutate(date_code = as.ordered(date_code)) %>% 
  arrange(date_code) %>% 
  filter(date_code > start_date_code_life_expectancy) %>%
  # 2.3 not every year contains detail for specific URC
  filter(urban_rural_classification == "All") %>%
  # 2.4 LE for each age band is not necessary for analysis
  filter(age == "0 years")

# 3. output clean data
life_expectancy_data_clean %>% 
  write_csv("data/clean_data/life_expectancy_clean.csv")

#####-----life satisfaction stats-----#####
# 1.Load in raw data set

health_survey <- read_csv("data/scottish_health_survey.csv") %>% clean_names()

# 2. Create tibble to name health boards

end_id <- c(15, 16, 17, 19, 20, 22, 24,
            25, 26, 29, 28, 30, 31, 32)
start_substr <- "S080000"
hb_codes <- c()
for (id in  end_id) {
  hb_codes<- c(hb_codes, paste(start_substr, id, sep = ""))
}
hb_names <- c("NHS Ayrshire and Arran",
              "NHS Borders",
              "NHS Dumfries and Galloway",
              "NHS Forth Valley",
              "NHS Grampian",
              "NHS Highland",
              "NHS Lothian",
              "NHS Orkney",
              "NHS Shetland",
              "NHS Western Isles",
              "NHS Fife",
              "NHS Tayside",
              "NHS Greater Glasgow and Clyde",
              "NHS Lanarkshire")
health_board_names <- tibble(
  "health_board" = c(hb_codes),
  "health_board_name" = c(hb_names)
)

# 3. Join raw data set with health board codes to allow useof health board name as variable

life_satisfaction <- left_join(
  health_survey, 
  health_board_names, 
  by=c("feature_code" = "health_board"))

# 4. Filter data to narrow down variable choices to health board/Scotland and sex.
#NB other variables already aggregated so totals left in to allow view of "Scotland"
# data and "All" sexes.

life_satisfaction <- life_satisfaction %>% 
  filter(date_code == "2016-2019") %>% 
  filter(measurement == "Percent") %>% 
  filter(str_detect(feature_code, "S08|S92")) %>% 
  filter(str_detect(scottish_health_survey_indicator, "Life satisfaction")) %>% 
  mutate(indicator = 
           recode(scottish_health_survey_indicator, 
                  "Life satisfaction: Above the mode (9 to 10-Extremely satisfied)" 
                  = "Very satisfied (above mode)",
                  "Life satisfaction: Below the mode (0-Extremely dissatisfied to 7)" 
                  = "Very dissatisfied (below mode)",
                  "Life satisfaction: Mode (8)" 
                  = "Satisfied (mode)")) %>% 
  mutate(health_board_name = 
           if_else(is.na(health_board_name), "Scotland", health_board_name)) %>% 
  mutate(indicator_factor = factor(indicator, 
                                   levels = c("Very dissatisfied (below mode)",
                                              "Satisfied (mode)",
                                              "Very satisfied (above mode)"))) %>% 
  arrange(indicator_factor)

# 5. Output cleaned data to csv file

write_csv(life_satisfaction, file = "data/clean_data/life_satisfaction_clean.csv")




#####-----drug related hospital stats-----#####
  # 1.input raw data and clean col names and scottish area codes
drug_related_hospital <- read_csv(here("data/raw_data/drug_related_hospital_discharge.csv")) %>%
  clean_names()

council_area <- read_csv(here("data/raw_data/council_area_codes.csv")) %>% 
  clean_names()

drug_related_hospital_clean <- drug_related_hospital %>% 
  # 2. convert dates to ordered and filter for past decade
  mutate(date_code = as.ordered(date_code)) %>% 
  arrange(date_code) %>% 
  filter(date_code > start_date_code_drug_years)

council_area_clean <- council_area %>% 
  # 3. re-name and select nessesary cols from data set
  select(feature_code = ca,
         council_area = ca_name,
         NHS_name = hb_name,
         NHS_code = hb)

  # 4. inner join feature code
drug_hospital_area <- inner_join(drug_related_hospital_clean,
                                 council_area_clean)
  # 5. output clean data
drug_hospital_area %>% 
  write_csv("data/clean_data/drug_hospital_area.csv")

#####-----alcohol related hospital stats-----#####
# 1. input alcohol related hospital incedents
alcohol_hospital_stats <- read.csv(here("data/raw_data/alcohol_hospital_stats.csv")) %>% 
  clean_names()

alcohol_hospital_stats_clean <- alcohol_hospital_stats %>% 
  # 2 cleaning the data
  # 2. 1 re-name and selecting nessesary cols
  select(feature_code,
         date_code,
         units,
         count = value,
         alcohol_condition,
         hospital_classification = type_of_hospital) %>% 
  # 2.2 ordering the date
  mutate(date_code = as.ordered(date_code)) %>% 
  arrange(date_code) %>% 
  # convert dates to ordered and filter for past decade
  filter(date_code > start_date_code_alcohol_years) %>% 
  # 2.3 changing All within hospital_classification to General Hospital
  mutate(hospital_classification = str_replace_all(hospital_classification,
                                                   "All", "General Hospital"))

# 3. inner join feature code
alcohol_hospital_area <- inner_join(alcohol_hospital_stats_clean,
                                    council_area_clean)
# 4. output clean data
alcohol_hospital_area %>% 
  write_csv("data/clean_data/alcohol_hospital_area.csv")







#####-----smoking survey response -----######
# 1. input raw data
smoking_scot_survey <- read_csv("data/raw_data/scot smoking survey data.csv")
council_area_clean <- council_area %>% 
  clean_names()
# 2. clean raw data
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
  filter(is.na(date_end)) %>% 
  filter(str_detect(feature_code, "S12"))


# 3. add council area data
council_area_clean <- council_area %>%
  clean_names() %>% 
  select(feature_code = ca,
         council_area = ca_name) %>% 
  unique()

# 4. join the datasets (joining on feature code) & remove duplicate rows

smoking_clean_join <- inner_join(smoking_data_clean, council_area_clean)

# 5. output clean data
smoking_clean_join %>% 
  write_csv("data/clean_data/clean_smoking.csv")

