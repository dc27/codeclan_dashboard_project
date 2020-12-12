filter_stats_life_satisfaction <- function(input, data) {
    data %>% 
      filter(sex %in% 
               c(input$sex_choices_life_satisfaction)) %>% 
      filter(health_board_name %in% 
               c(input$area_choices_life_satisfaction))
}