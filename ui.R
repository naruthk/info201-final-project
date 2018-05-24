
library(ggplot2)
library(dplyr)
library(shiny)


my_ui <- fluidPage(
  titlePanel("Crimes Rates in the US"),
  
  sidebarLayout(
    sidebarPanel(
    ),
    mainPanel()
  )
  
)

shinyUI(my_ui)