national_arrests <- read.csv("data/arrests_national.csv")

state <- read.csv("data/estimated_crimes.csv")
library(plotly)
library(ggplot2)
library(dplyr)
library(tidyr)

my_server <- function(input, output) {
  

    national_arrests <- national_arrests %>%
      filter(total_arrests, violent_crime) %>%
      gather(key = "crime", value = "arrests", total_arrests, violent_crime) %>%
      select(year, "crime", "arrests") %>%
      arrange(year)
   
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
      "This plot shows the arrest records for the years 1995 - 2016. The total arrests are stacked ",
      " againsts the violent arrests to show the difference in types of crimes each year. "
     
    ) 
  })
  
  output$table <- renderDataTable({
    return(filtered())
  })
  
  
}

