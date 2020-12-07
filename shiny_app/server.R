source("R/filter_data_life_expectancy.R")
source("R/create_hb_map.R")

server <- function(input, output) {
  # take ui inputs for date, sex
  life_expect_chosen_year <- filter_data_LE(
    input = input,
    data = life_expectancy_data_all_SIMD
    )
  
  # render map
  output$LE_map <- renderLeaflet({
    create_hb_map(life_expect_chosen_year())
  })
}