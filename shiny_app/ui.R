source("helper.R")

# create variables for input choices
date_ranges <- sort(unique(life_expectancy_data_all_SIMD$date_code))
sexes <- unique(life_expectancy_data_all_SIMD$sex)

# build the UI
ui <- fluidPage(
  titlePanel("Life Expectancy by Scottish Health Board"),
  
  # TODO: discuss layout options
  sidebarLayout(
    sidebarPanel(
      
      # user inputs:
      # date range input
      selectInput(inputId = "date_range_choice",
                  label = "Date Range:",
                  choices = date_ranges,
                  "2016-2018"),
      # sex input
      selectInput(inputId = "sex_choice",
                  label = "Sex:",
                  choices = sexes,
                  "Female"),
      # add button so map updates only when told to
      actionButton("update_life_expect_map", "Update Map")
    ),
    
    mainPanel(
      leafletOutput("LE_map")
      
    )
  )
)
