library(shiny)
library(here)
library(tidyverse)
library(readr)
library(ggplot2)
library(dplyr)
library(shinythemes)

# Load in Data
alcohol <- read.csv(here("data/clean_data/alcohol_hospital_area.csv"))

alcohol_condition <- unique(alcohol$alcohol_condition)
council_area <- unique(alcohol$council_area)
date_code <- unique(alcohol$date_code)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Hospital Related Alcohol Incedents"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            
            # Year selection
            selectInput("date_code",
                        "Select year",
                        choices = sort(date_code),
                        selected =  "2018/2019"),

            # Council Area Code selection - multiple 
            checkboxGroupInput(inputId = "council_area",
                               label = "Council Region:",
                               choices = sort(council_area),
                               selected = NULL),
            
            # Alcohol related condition selection
            selectInput(inputId = "alcohol_condition",
                        label = "Alcohol Related Condition",
                        choices = alcohol_condition,
                        selected = "All alcohol conditions"),
            
            # Update button
            actionButton(inputId = "update",
                         label = "Update Plot")
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("alcohol_discharge"),
           
           "Alcohol-related hospital statistics (ARHS) provide an annual update to figures on the alcohol-related inpatient and day case activity taking place within general acute hospitals and psychiatric hospitals in Scotland"
        )
        
    )
)

# Define server logic required to draw a plot
server <- function(input, output) {

    filtered_alcohol <- eventReactive(input$update,{alcohol %>% 
    filter(date_code %in% input$date_code) %>% 
    filter(council_area %in% input$council_area) %>% 
    filter(alcohol_condition %in% input$alcohol_condition)
    })
        
    output$alcohol_discharge <- renderPlot({
        filtered_alcohol() %>% 
            ggplot() +
            aes(x= council_area, y = count) +
            geom_col(position = "dodge", colour = "grey") +
            scale_fill_brewer(palette = 1) +
            labs(x = "Council Region",
                 y = "Count",
                 title = "Alcohol Related Incidents Within Hospital") +
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
                  panel.background = element_rect(fill = "white", colour = "grey")) +
        facet_wrap(~ alcohol_condition)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
