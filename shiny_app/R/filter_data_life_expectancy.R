filter_data_LE <- function(input, data) {
  eventReactive(input$update_life_expect_map,
          {data %>% 
              filter(date_code == input$date_range_choice) %>% 
              filter(sex == input$sex_choice) %>%  
              select(value)
          })
}
