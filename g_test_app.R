library(shiny)
library(tidyverse)
library(shinythemes)
library(janitor)
library(here)

#read in cleaned data

life_satisfaction <- read_csv(here("data/clean_data/life_satisfaction_clean.csv"))

#Determine lists for input buttons/checkboxes

sex_choices_life_satisfaction <-  life_satisfaction %>% 
  distinct(sex) %>% 
  pull()

area_choices_life_satisfaction <- life_satisfaction %>% 
  distinct(health_board_name) %>%
  arrange(desc(health_board_name)) %>% 
  pull()
 

# define ui

ui <- fluidPage(
                
                sidebarLayout(
                  sidebarPanel(
                    checkboxGroupInput(inputId = "sex_choices_life_satisfaction",
                                      label = "Sex",
                                      choices = sex_choices_life_satisfaction,
                                      selected = "All"),
                    
                    checkboxGroupInput(inputId = "area_choices_life_satisfaction",
                                        label = "Health Board Area/Country",
                                        choices = area_choices_life_satisfaction,
                                        selected = "Scotland"),
                    
                    actionButton(inputId = "update",
                                 label = "Show plot")
                    
                  ),
                  
                  mainPanel("",
                               plotOutput("plot"))
   )
                  
  )

# define server

server <- function(input, output){
  
  filtered_stats_life_satisfaction <- eventReactive(input$update, {
    life_satisfaction %>% 
      filter(sex %in% c(input$sex_choices_life_satisfaction)) %>% 
      filter(health_board_name %in% c(input$area_choices_life_satisfaction))
  })
  
  output$plot <- renderPlot({
    filtered_stats_life_satisfaction() %>% 
      ggplot(aes(x = health_board_name, y = value, fill = indicator_factor)) +
      geom_col(position = "dodge") +
      labs(x = "Health Board",
           y = "Percentage",
           title = "Life Satisfaction in Scotland") +
      theme(plot.title = element_text(hjust = 0.5, size=18),
            axis.text.x = element_text(vjust=1,size=14),
            axis.text.y = element_text(hjust=1,size=14)) +
      facet_wrap(~ sex)
  })

  
}

shinyApp(ui = ui, server = server)


