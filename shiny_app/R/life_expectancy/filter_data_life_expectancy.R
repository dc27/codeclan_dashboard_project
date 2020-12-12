filter_data_LE <- function(input, data) {
  data %>% 
      filter(date_code == input$date_range_choice) %>% 
      filter(sex == input$sex_choice) %>%  
      select(value)
}
