filter_data_drugs <- function(input, data) {
  filtered_drugs <- eventReactive(input$update_drugs_plot,
                                  {data %>% 
                                    filter(date_code %in% input$date_code) %>% 
                                    filter(council_area %in% input$council_area)
                                  })
}