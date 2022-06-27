filter_data_alcohol <- function(input, data) {
  data %>% 
    filter(!str_detect(units, "Per")) %>% 
    filter(hospital_classification == "General Hospital") %>% 
    filter(date_code %in% input$date_code_alcohol) %>% 
    filter(council_area %in% input$council_area_alcohol) %>% 
    filter(alcohol_condition %in% input$alcohol_condition)
}