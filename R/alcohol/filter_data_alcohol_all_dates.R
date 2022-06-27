filter_data_alcohol_all_dates <- function(input, data) {
  data %>% 
  filter(!str_detect(units, "Per")) %>% 
  filter(hospital_classification == "General Hospital") %>%
  mutate(date_code = str_extract(date_code, "[0-9]{4}")) %>%
  filter(units == "Patients") %>% 
  filter(council_area %in% input$council_area_alcohol) %>% 
  filter(alcohol_condition %in% input$alcohol_condition)
}