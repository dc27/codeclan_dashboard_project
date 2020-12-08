library(shiny)

# call in the scripts for the ui and the server
source("ui.R")
source("sever.R")

# run the app
shinyApp(ui, server)

