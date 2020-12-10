filter_data_alcohol <- function(input, data) {
  filtered_alcohol <- eventReactive(input$update_alcohol_plot,{data %>% 
      filter(date_code %in% input$date_code) %>% 
      filter(council_area %in% input$council_area) %>% 
      filter(alcohol_condition %in% input$alcohol_condition)
  })
}