
national_arrests <- read.csv("data/arrests_national.csv")

state <- read.csv("data/estimated_crimes.csv")
library(plotly)
library(ggplot2)
library(dplyr)
library(tidyr)

my_server <- function(input, output) {
    
    
    national_arrests <- national_arrests %>%
      gather(key = "crime", value = "arrests", total_arrests : curfew_loitering) %>%
      select(year, "crime", "arrests") %>%
      arrange(arrests)
    
    filtered <- reactive({
      data_year <- national_arrests %>%
        filter(year == input$select_year)
      return(data_year)
    })
    
    
    output$plot3 <- renderPlot({
      p<- ggplot(data = national_arrests, aes(x = year, y = arrests, fill = crime)) +
        geom_bar(stat = "identity") +
        labs(
          title = "Number of Arrests in the US",
          x = "Year",
          y = "Number of Arrests",
          fill = "Type of Crime"
        )
      return(p)
      
    })
    
    
    output$plot_info <- renderPrint({
      
      cat(
        "This plot shows the arrest records for the years 1995 - 2016. The types of arrests are stacked to show how each kind of 
        crime has progressed each year. Further statistics based on the specific year are found under this graph to look more in depth
        of the yearly numbers. "
        
      ) 
    })
    
    output$table <- renderDataTable({
      return(filtered())
    })
    
    
  }

  

    
  
  
  


