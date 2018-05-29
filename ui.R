
library(ggplot2)
library(dplyr)
library(shiny)


my_ui <- fluidPage(
  titlePanel("Crimes Rates in the US"),
  
  sidebarLayout(
    sidebarPanel(
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Plot", plotOutput("plot1")),
                  tabPanel("Plot", plotOutput("plot2")),
                  tabPanel("Plot", plotOutput("plot3")),
                  tabPanel("DUI Against Various Theft Types", plotOutput("plot4"))
                  
    )
  )
  
)
)
shinyUI(my_ui)