filter_smoking_data <- function(input, data) {
  #browser()
  eventReactive(input$confirm_variable_choices,
                {
                  #browser()
                  
                  data %>% 
                    filter(age == input$age) %>%
                    filter(gender == input$gender) %>%
                    filter(council_area == input$council)
                })
}

