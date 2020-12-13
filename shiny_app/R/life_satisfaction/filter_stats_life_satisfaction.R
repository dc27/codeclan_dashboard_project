filter_stats_life_satisfaction <- function(input, data) {
    data %>% 
      filter(sex %in% 
               c(input$sex_choices_life_satisfaction_group)) %>% 
      filter(health_board_name %in% 
               c(input$area_choices_life_satisfaction))
}