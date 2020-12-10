library(shiny)
library(here)
library(tidyverse)
library(readr)
library(ggplot2)
library(dplyr)
library(shinythemes)

drugs <- read.csv(here("data/clean_data/drug_hospital_area.csv"))

council_area <- unique(drugs$council_area)
date_code <- unique(drugs$date_code)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Drug Misuse Discharge's from Hospital"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            
            selectInput(inputId = "date_code",
                        "Select year",
                        choices = sort(date_code),
                        selected = "2017/2018"),
            
            checkboxGroupInput(inputId = "council_area",
                               label = "Council Region:",
                               choices = sort(council_area),
                               selected = NULL),
            
            actionButton(inputId = "update",
                         label = "Update Plot")
        ),

        # Show a plot of the generated distribution
    mainPanel(
        plotOutput("drug_count"),
        
        "Number and EASR of hospital stays related to a drug misuse diagnosis. Hospital activity is data routinely drawn from hospital administrative systems across all NHS hospitals in Scotland. These data contain statistics derived from General Acute Inpatient / Day cases Records (Scottish Morbidity Records 01 or SMR01 database), which includes all inpatient and day cases discharged from acute medical specialties (all specialties other than mental health, maternity, neonatal and geriatric long stay specialties), and where drug misuse was mentioned in the records at some point during the patients’ hospital stay."
        
    )
    )
)
    

# Define server logic required to draw a histogram
server <- function(input, output) {

    filtered_drugs <- eventReactive(input$update,{drugs %>% 
            filter(date_code %in% input$date_code) %>% 
            filter(council_area %in% input$council_area)
    })
    
    output$drug_count <- renderPlot({
        filtered_drugs() %>% 
            ggplot() +
            aes(x = council_area, y = value) +
            geom_col(position = "dodge", colour = "grey") +
            scale_fill_brewer(palette = 1) +
            labs(x = "Council Region",
                 y = "Count",
                 title = "Drug Related Dishcharges from Hospital") +
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
                  panel.background = element_rect(fill = "white", colour = "grey"))
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
