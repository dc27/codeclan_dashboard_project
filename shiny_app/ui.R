source("R/filter_data_life_expectancy.R")
source("R/filter_data_life_expectancy_simd.R")

# create variables for input choices

date_ranges <- sort(unique(life_expectancy_data_all_SIMD$date_code))
sexes <- unique(life_expectancy_data_all_SIMD$sex)
simd_quints <- sort(unique(le_data_individual_simds$simd_quintiles))

# Alcohol input for plot
alcohol_condition <- unique(alcohol$alcohol_condition)
  council_area_alcohol <- unique(alcohol$council_area)
  date_code_alcohol <- unique(alcohol$date_code)

# Drug input for plot  
council_area_drugs <- unique(drugs$council_area)
  date_code_drugs <- unique(drugs$date_code)

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
  dashboardSidebar(
    disable = TRUE
  ),
  dashboardBody(
    tabsetPanel(
      tabPanel(
        "Overview",
    
      # TODO: discuss layout options
        fluidRow(
          tags$br(),
          column(
            6,
            box(
              width = 12,
              title = "Life Expectancy",
              fluidRow(
                column(
                  4,
                  # user inputs:
                  # date range input
                  selectInput(inputId = "date_range_choice",
                              label = "Date Range:",
                              choices = date_ranges,
                              "2016-2018"),
                ),
                column(
                  4,
                  # sex input
                  selectInput(inputId = "sex_choice",
                              label = "Sex:",
                              choices = sexes,
                              "Female")
                ),
                column(
                  4,
                  align = "center",
                  tags$br(),
                  # add button so map updates only when told to
                  actionButton("update_life_expect_map", "Update Map")
                )
              ),
              fluidRow(
                tabBox(
                  width = 12,
                  tabPanel(
                    "By Health Board",
                    leafletOutput("LE_map")),
                  tabPanel(
                    "By SIMD",
                    plotOutput("LE_by_simd_plot")),
                  tabPanel(
                    "All Scotland",
                    plotOutput("LE_year_plot")
                  )
                )
              )
            )
          ),
          column(
            6,
            box(
              width = 12,
              title = "Life Satisfaction",
              column(
                5,
                checkboxGroupInput(inputId = "sex_choices_life_satisfaction",
                                   label = "Sex:",
                                   choices = sex_choices_life_satisfaction,
                                   selected = "All",
                                   inline = TRUE),
                tags$br()
              ),
              column(
                4,
                tags$br(),
                dropdownButton(label = "Select Health Board(s)",
                               status = "default",
                               circle = FALSE,
                               checkboxGroupInput(
                                 width = 250,
                                 inputId = "area_choices_life_satisfaction",
                                 label = "Health Board Area",
                                 choices = area_choices_life_satisfaction,
                                 selected = "Scotland"))
              ),
              column(
                3,
                tags$br(),
                align = "center",
                actionButton(inputId = "update",
                             label = "Show plot")
              ),
              fluidRow(
                tabBox(
                  width = 12,
                  tabPanel(
                    "Graph",
                    plotOutput("satisfaction_plot")
                  ),
                  tabPanel(
                    "Map",
                    leafletOutput("satisfaction_map"))
                )
              )
            )
          )
        )
      ),
      tabPanel(
        "Alcohol",
        
        # Application title
        titlePanel("Hospital Related Alcohol Incedents"),
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
          sidebarPanel(
            
            # Year selection
            selectInput("date_code_alcohol",
                        "Select year",
                        choices = sort(date_code_alcohol),
                        selected =  "2018/2019"),
            
            # Council Area Code selection - multiple 
            checkboxGroupInput(inputId = "council_area_alcohol",
                               label = "Council Region:",
                               choices = sort(council_area_alcohol),
                               selected = c("Aberdeen City",
                                            "City of Edinburgh",
                                            "Glasgow City")),
            
            # Alcohol related condition selection
            selectInput(inputId = "alcohol_condition",
                        label = "Alcohol Related Condition",
                        choices = alcohol_condition,
                        selected = "All alcohol conditions"),
            
            # Update button
            actionButton(inputId = "update_alcohol_plot",
                         label = "Update Plot")
          ),
          
          # Show a plot of the generated distribution
          mainPanel(
            plotOutput("alcohol_discharge"),
            
            "Alcohol-related hospital statistics (ARHS) provide an annual update to figures on the alcohol-related inpatient and day case activity taking place within general acute hospitals and psychiatric hospitals in Scotland"
          )
          
        )
      ),
        
      tabPanel(
        "Drugs",

      # Application title
      titlePanel("Drug Misuse Discharge's from Hospital"),
      
      # Sidebar with a slider input for number of bins 
      sidebarLayout(
        sidebarPanel(
          
          selectInput(inputId = "date_code_drugs",
                      "Select year",
                      choices = sort(date_code_alcohol),
                      selected = "2017/2018"),
          
          checkboxGroupInput(inputId = "council_area_drugs",
                             label = "Council Region:",
                             choices = sort(council_area_alcohol),
                             selected = c("Aberdeen City",
                                          "City of Edinburgh",
                                          "Glasgow City")),
          
          actionButton(inputId = "update_drugs_plot",
                       label = "Update Plot")
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
          plotOutput("drug_count"),
          
          "Number and EASR of hospital stays related to a drug misuse diagnosis. Hospital activity is data routinely drawn from hospital administrative systems across all NHS hospitals in Scotland. These data contain statistics derived from General Acute Inpatient / Day cases Records (Scottish Morbidity Records 01 or SMR01 database), which includes all inpatient and day cases discharged from acute medical specialties (all specialties other than mental health, maternity, neonatal and geriatric long stay specialties), and where drug misuse was mentioned in the records at some point during the patients’ hospital stay."
          
        )
      )
      ),
      
      
      tabPanel(
        "Tab 4"
      )
    )
  )
)

