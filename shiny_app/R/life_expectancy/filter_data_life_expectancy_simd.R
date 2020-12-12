filter_data_LE_simd <- function(input, data){
  eventReactive(input$update_life_expect_map, ignoreNULL = FALSE, {
    data %>%
      filter(date_code == input$date_range_choice) %>%
      # to plot confidence intervals
      pivot_wider(names_from = measurement, values_from = value) %>% 
      janitor::clean_names()
  })
}