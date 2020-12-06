# libraries needed to run app
library(shiny)

# call in the scripts for the ui and the server
source("ui.R")
source("sever.R")

ui <- ui
server <- server

# run the app
shinyApp(ui, server)

