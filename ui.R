# install.packages("shinythemes")
library(shinythemes)
library(ggplot2)
library(dplyr)
library(shiny)

juvenile_data <- read.csv("data/arrests_national_juvenile.csv", stringsAsFactors = FALSE)
juvenile_data <- filter(juvenile_data, year == 2016) %>% 
  filter(offense_name != "Curfew and Loitering Law Violations" & offense_name != "Runaway")

my_ui <- fluidPage(
  theme = "bootstrap.css",
  titlePanel("Crimes Rates in the United States"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("crimes", label = "Select Crimes", choices = juvenile_data["offense_name"]),
      sliderInput("year", label = "Select Year", min = 1994, max = 2016, value = c(1994:2016))
      
    ),
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Introduction",includeMarkdown("intro.md")),
                  tabPanel("Plot", plotOutput("plot1")),
                  tabPanel("Comparison in Juvenile and Adults Crime", br(),
                           textOutput("intro_to_graph"), br(), plotOutput("plot2"), br(), textOutput("conclusion_to_grph"), br(),
                           dataTableOutput("table")),
                  tabPanel("Plot", plotOutput("plot3")),
                  tabPanel("Plot", plotOutput("plot4")),
                  tabPanel("Conclusion", includeMarkdown("conclusion.md"))
                  
    )
  )
  
)
)
shinyUI(my_ui)

