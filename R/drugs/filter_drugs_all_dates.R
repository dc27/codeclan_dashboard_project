filter_drugs_all_dates <- function(input, data) {
  data %>%
    filter(measurement == "Count") %>% 
    mutate(date_code = str_extract(date_code, "[0-9]{4}")) %>%
    filter(council_area %in% input$council_area_drugs)
}