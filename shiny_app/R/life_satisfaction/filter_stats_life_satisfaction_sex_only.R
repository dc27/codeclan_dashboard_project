filter_stats_life_satisfaction_sex_only <- function(input, data) {
  data %>%
      filter(sex %in%
               c(input$sex_choices_life_satisfaction)) %>% 
      mutate(multiplier =
               recode(indicator,
                      "Very satisfied (above mode)" = 1,
                      "Very dissatisfied (below mode)" = 0,
                      "Satisfied (mode)" = 1)) %>%
      mutate(satisfied_score = value * multiplier) %>% 
      group_by(feature_code) %>% 
      summarise(value = sum(satisfied_score),
                .groups = "drop_last") %>% 
      arrange(feature_code) %>% 
      filter(!str_detect(feature_code, "S9"))
                
}
