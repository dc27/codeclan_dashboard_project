source("R/life_expectancy/create_le_simd_plot.R")
source("R/life_expectancy/create_hb_map.R")

# create variables for input choices

date_ranges <- sort(unique(life_expectancy_data_all_SIMD$date_code))
sexes <- unique(life_expectancy_data_all_SIMD$sex)
simd_quints <- sort(unique(le_data_individual_simds$simd_quintiles))

# Alcohol input for plot
alcohol_condition <- unique(alcohol$alcohol_condition)
council_area_alcohol <- unique(alcohol$council_area)
date_code_alcohol <- unique(alcohol$date_code)

# Drug input for plot  
council_areas <- sort(unique(drugs$council_area))
date_code_drugs <- sort(unique(drugs$date_code))

# create variables for smoking tab input choices

smoking_genders <- sort(unique(scotland_smoking_data$gender),
                        decreasing = TRUE)
smoking_ages <- sort(unique(scotland_smoking_data$age))


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
                              "2016-2018")
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
                  actionButton("update_LE", "Update plot")
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
              title = "Life Satisfaction (2016-2019)",
              column(
                5,
                conditionalPanel(condition = "output.graph_tab",
                                 checkboxGroupInput(
                                   inputId = "sex_choices_life_satisfaction_group",
                                   label = "Sex:",
                                   choices = sex_choices_life_satisfaction,
                                   selected = "All",
                                   inline = TRUE)),
                conditionalPanel(condition = "output.map_tab",
                                 radioButtons(
                                   inputId = "sex_choices_life_satisfaction_one",
                                   label = "Sex:",
                                   choices = sex_choices_life_satisfaction,
                                   selected = "All",
                                   inline = TRUE)),
                tags$br()
              ),
              column(
                4,
                tags$br(),
                dropdownButton(
                  label = "Select Health Board(s)",
                  status = "default",
                  circle = FALSE,
                  checkboxGroupInput(
                   width = 250,
                   inputId = "area_choices_life_satisfaction",
                   label = "Health Board Area",
                   choices = area_choices_life_satisfaction,
                   selected = "Scotland"
                  )
                )
              ),
              column(
                3,
                tags$br(),
                align = "center",
                conditionalPanel(condition = "output.graph_tab",
                                 actionButton(inputId = "update_LS_graph",
                                              label = "Update plot")),
                conditionalPanel(condition = "output.map_tab",
                                 actionButton(inputId = "update_LS_map",
                                              label = "Update map"))
                                 
              ),
              fluidRow(
                tabBox(
                  id = "LS_tab",
                  width = 12,
                  tabPanel(
                    value = "graph",
                    "Graph",
                    plotOutput("satisfaction_plot")
                  ),
                  tabPanel(
                    value = "map",
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
        titlePanel("Hospital Related Alcohol Incidents"),
        
        # Sidebar with a slider input for number of bins 
        sidebarLayout(
          sidebarPanel(
            
            # Year selection
            selectInput("date_code_alcohol",
                        "Select year",
                        choices = sort(date_code_alcohol),
                        selected =  "2018/2019"),
            
            # Alcohol related condition selection
            selectInput(inputId = "alcohol_condition",
                        label = "Alcohol Related Condition",
                        choices = sort(alcohol_condition),
                        selected = "All alcohol conditions"),
            
            # Council Area Code selection - multiple 
            dropdownButton(label = "Select Council Area(s)",
                           status = "default",
                           circle = FALSE,
                           checkboxGroupInput(inputId = "council_area_alcohol",
                               label = "Council Region:",
                               choices = council_areas,
                               selected = c("Aberdeen City",
                                            "City of Edinburgh",
                                            "Glasgow City"))),
            tags$br(),
            
            # Update button
            actionButton(inputId = "update_alcohol_plot",
                         label = "Update Plot")
          ),
          
          # Show a plot of the generated distribution
          mainPanel(
            tabBox(
              width = 12,
              tabPanel(
                "By Council Area",
                plotOutput("alcohol_discharge")                
              ),
              tabPanel(
                "Over Time",
                plotOutput("alcohol_over_time")
              )

            ),
            box(
              width = 12,
              tags$h3("Alcohol-related hospital statistics (ARHS) provide an annual update to figures on the alcohol-related inpatient and day case activity taking place within general acute hospitals and psychiatric hospitals in Scotland")                
            )
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
                        choices = sort(date_code_drugs),
                        selected = "2017/2018"),
            
            dropdownButton(label = "Select Council Area(s)",
                           status = "default",
                           circle = FALSE,
                           checkboxGroupInput(inputId = "council_area_drugs",
                               label = "Council Region:",
                               choices = sort(council_areas),
                               selected = c("Aberdeen City",
                                            "City of Edinburgh",
                                            "Glasgow City"))),
            tags$br(),
            
            actionButton(inputId = "update_drugs_plot",
                         label = "Update Plot")
          ),
          
          # Show a plot of the generated distribution
          mainPanel(
            tabBox(
              width = 12,
              tabPanel(
                "By Council Area",
                plotOutput("drug_count")
              ),
              tabPanel(
                "Over Time",
                plotOutput("drugs_over_time")
              )
            ),
            box(
              width = 12,
              tags$h3("Number and EASR of hospital stays related to a drug misuse diagnosis. Hospital activity is data routinely drawn from hospital administrative systems across all NHS hospitals in Scotland. These data contain statistics derived from General Acute Inpatient / Day cases Records (Scottish Morbidity Records 01 or SMR01 database), which includes all inpatient and day cases discharged from acute medical specialties (all specialties other than mental health, maternity, neonatal and geriatric long stay specialties), and where drug misuse was mentioned in the records at some point during the patients’ hospital stay.")
            )
          )
        )
      ),
      tabPanel(
        "Smoking",
        titlePanel("Scotland Smoking Data"),
        sidebarLayout(
          sidebarPanel(
            # user inputs:
            # age range input
            selectInput(inputId = "age",
                        label = "Age Range?",
                        choices = smoking_ages,
                        selected = "All"
                        
            ),
            # gender input
            selectInput(inputId = "gender",
                        label = "Gender?",
                        choices = smoking_genders,
                        selected = "All"
            ),
            #council area input
            selectInput(inputId = "council",
                        label = "Which Council Area?",
                        choices = council_areas,
                        selected = "City of Edinburgh"
            ),
            # add button so variable choices update only when confirmed
            actionButton(inputId = "confirm_variable_choices", 
                         label = "Confirm")
          ),
          mainPanel(
            plotOutput("smoking_plot")
          )
        )
      )
    )
  )
)

