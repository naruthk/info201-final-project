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
                  tabPanel("Type of crimes by state", 
                           plotOutput("plot1", click = "plot_click"),br(),
                           verbatimTextOutput("click1"),br(),
                           htmlOutput("explanation", inline = TRUE)),
                  tabPanel("Plot", plotOutput("plot2")),
                  tabPanel("National Arrests Data", plotOutput("plot3"),
                           selectInput("select_year", h3("Select Year"), choices = list(
                             "1995" = 1995, "1996" = 1996, "1997" = 1997, "1998" = 1998, 
                             "1999" = 1999, "2000" = 2000,
                           "2001" = 2001,"2002" = 2002, "2003" = 2003, 
                           "2004"= 2004,"2005" = 2005, "2006" = 2006,
                           "2007" = 2007, "2008" = 2008, "2009" = 2009,
                           "2010" = 2010,"2011" = 2011, "2012" = 2012, 
                           "2013" = 2013,"2014" = 2014,
                           "2015" = 2015,"2016" = 2016, selected = 2000)),

                    dataTableOutput("table"), textOutput("plot_info")),
                    tabPanel("DUI Against Various Theft Types", 
                             plotOutput("plot4"),
                             textOutput("analysis_plot_4"))
      )
    )
  )
)
