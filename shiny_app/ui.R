source("R/filter_data_life_expectancy.R")
source("R/filter_data_life_expectancy_simd.R")

# create variables for input choices

date_ranges <- sort(unique(life_expectancy_data_all_SIMD$date_code))
sexes <- unique(life_expectancy_data_all_SIMD$sex)
simd_quints <- sort(unique(le_data_individual_simds$simd_quintiles))

# build the UI
ui <- dashboardPage(
  dashboardHeader(
    title = "Health in Scotland"
  ),
  dashboardSidebar(),
  dashboardBody(
    tabsetPanel(
      tabPanel(
        "Overview",
    
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
            leafletOutput("LE_map"),
            plotOutput("LE_by_simd_plot")
          )
        )
      ),
      tabPanel(
        "Tab 2"
      ),
      tabPanel(
        "Tab 3"
      ),
      tabPanel(
        "Tab 4"
      )
    )
  )
)
