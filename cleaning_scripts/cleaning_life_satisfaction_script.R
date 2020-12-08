#Load in required packages for cleaning

library(tidyverse)
library(janitor)

#Load in raw data set

health_survey <- read_csv("data/scottish_health_survey.csv") %>% clean_names()

# Create tibble to name health boards

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

#Join raw data set with health board codes to allow useof health board name as variable

life_satisfaction <- left_join(
  health_survey, 
  health_board_names, 
  by=c("feature_code" = "health_board"))

#Filter data to narrow down variable choices to health board/Scotland and sex.
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

#Output cleaned data to csv file

write_csv(life_satisfaction, file = "data/clean_data/life_satisfaction_clean.csv")



