library(shiny)

# Loaded the server R script.
source("server.R")

# Loaded the UI R script.
source("ui.R")

# Created shiny app using the source server and UI.
shinyApp(ui = my_ui, server = my_server)
