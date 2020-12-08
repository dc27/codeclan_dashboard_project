library(shiny)
library(tidyverse)
library(shinythemes)
library(janitor)
library(here)
library(shinyWidgets)

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
                    
                    dropdownButton(label = "Select Health Board(s)",
                                   status = "default",
                                   circle = FALSE,
                                   checkboxGroupInput(inputId = "area_choices_life_satisfaction",
                                        label = "Health Board Area",
                                        choices = area_choices_life_satisfaction,
                                        selected = "Scotland")),
                    
                    actionButton(inputId = "update",
                                 label = "Show plot")
                    
                  ),
                  
                  mainPanel("",
                            plotOutput("satisfaction_plot"))
   )
                  
  )

# define server

server <- function(input, output){
  
  filtered_stats_life_satisfaction <- eventReactive(input$update, 
                                                    ignoreNULL = FALSE,{
    life_satisfaction %>% 
      filter(sex %in% c(input$sex_choices_life_satisfaction)) %>% 
      filter(health_board_name %in% c(input$area_choices_life_satisfaction))
  })
    
  output$satisfaction_plot <- renderPlot({
    filtered_stats_life_satisfaction() %>% 
      ggplot(aes(x = health_board_name, y = value, fill = indicator_factor)) +
      geom_col(position = "dodge", colour = "grey") +
      scale_fill_brewer(palette = 1) +
      labs(y = "% Adults",
           title = "Life Satisfaction") +
      theme(plot.title = element_text(hjust = 0.5, vjust = 1, size=16),
            axis.title.x = element_blank(),
            axis.text.x = element_text(vjust=1,size=10),
            axis.text.y = element_text(hjust=1.5,size=10),
            legend.title = element_blank(),
            legend.position = "bottom",
            legend.spacing.x = unit(1.0, "cm"),
            legend.text = element_text(size = 10),
            panel.grid.major.y = element_blank(),
            plot.background = element_rect(fill = "white", colour = "grey"),
            panel.background = element_rect(fill = "white", colour = "grey"))+
      facet_wrap(~ sex)
  })

  
}

shinyApp(ui = ui, server = server)


