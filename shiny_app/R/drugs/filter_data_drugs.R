filter_data_drugs <- function(input, data) {
  data %>%
    filter(measurement == "Count") %>% 
    filter(date_code %in% input$date_code_drugs) %>% 
    filter(council_area %in% input$council_area_drugs)
}