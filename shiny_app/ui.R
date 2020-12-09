source("R/filter_data_life_expectancy.R")
source("R/filter_data_life_expectancy_simd.R")

# create variables for input choices

date_ranges <- sort(unique(life_expectancy_data_all_SIMD$date_code))
sexes <- unique(life_expectancy_data_all_SIMD$sex)
simd_quints <- sort(unique(le_data_individual_simds$simd_quintiles))

#Determine lists for input buttons/checkboxes for life satisfaction
sex_choices_life_satisfaction <-  life_satisfaction %>% 
  distinct(sex) %>% 
  pull()

area_choices_life_satisfaction <- life_satisfaction %>% 
  distinct(health_board_name) %>%
  arrange(desc(health_board_name)) %>% 
  pull()

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
            checkboxGroupInput(inputId = "sex_choices_life_satisfaction",
                               label = "Sex",
                               choices = sex_choices_life_satisfaction,
                               selected = "All"),
            
            dropdownButton(label = "Select Health Board(s)",
                           status = "default",
                           circle = FALSE,
                           checkboxGroupInput(
                             inputId = "area_choices_life_satisfaction",
                             label = "Health Board Area",
                             choices = area_choices_life_satisfaction,
                             selected = "Scotland")),
            
            actionButton(inputId = "update",
                         label = "Show plot"),
            
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
            plotOutput("LE_by_simd_plot"),
            plotOutput("satisfaction_plot")
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
