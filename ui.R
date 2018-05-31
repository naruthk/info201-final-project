library(ggplot2)
library(dplyr)
library(shiny)

national <- read.csv("data/arrests_national.csv", stringsAsFactors = FALSE)
state_and_national <- read.csv("data/estimated_crimes.csv", stringsAsFactors = FALSE)
state <- state_and_national[23:1144,]

state_abbreviations <- unique(state$state_abbr,incomparables = FALSE)

my_ui <- fluidPage(
  titlePanel("Crimes Rates in the US"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("state_choice", label="Selected State", choices = state_abbreviations)
  ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("How the different types of crimes connected to each other in different states?", 
                           plotOutput("plot1", click = "plot_click"),br(),
                           verbatimTextOutput("click1"),br(),
                           textOutput("explanation", inline = TRUE)),
                           tabPanel("Plot", plotOutput("plot2")),
                           tabPanel("Plot", plotOutput("plot3")),
                           tabPanel("Plot", plotOutput("plot4"))
                           
                  ),
      h1("Reference:"),br(),
      p(strong("Please visit:"), a(href="https://crime-data-explorer.fr.cloud.gov/", "crime-data-explorer.fr.cloud.gov"))
      )
)
)

  shinyUI(my_ui)