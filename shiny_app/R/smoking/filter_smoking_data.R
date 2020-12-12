filter_smoking_data <- function(input, data) {
  data %>% 
    filter(age == input$age) %>%
    filter(gender == input$gender) %>%
    filter(council_area == input$council)
}

