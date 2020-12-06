
source("helper.R")

server <- function(input, output) {
  # take ui inputs for date, sex
  life_expect_chosen_year <- eventReactive(input$update_life_expect_map,
                                           {life_expectancy_data_all_SIMD %>% 
    filter(date_code == input$date_range_choice) %>% 
    filter(sex == input$sex_choice) %>%  
    select(value)
  })
  
  # render map
  output$LE_map <- renderLeaflet({
    create_hb_map(life_expect_chosen_year())
  })
}