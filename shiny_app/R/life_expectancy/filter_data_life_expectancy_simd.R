filter_data_LE_simd <- function(input, data){
  data %>%
    filter(date_code == input$date_range_choice) %>%
    # to plot confidence intervals
    pivot_wider(names_from = measurement, values_from = value) %>% 
    janitor::clean_names()
}