library(plotly)
library(ggplot2)
library(dplyr)
library(tidyr)

national <- read.csv("data/arrests_national.csv")
national_arrests <- read.csv("data/arrests_national.csv")
state <- read.csv("data/estimated_crimes.csv")

crime_rates_national <- national %>%
  select(year, population, total_arrests, dui, robbery, 
         burglary, larceny, motor_vehicle_theft, stolen_property)

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
  
  # How does statistics on drinking under the influence (DUI)
  # compared to the rate of various types of thefts? 
  output$plot4 <- renderPlot({
    
    ggplot(crime_rates_national, aes(x = year)) +
      geom_line(aes(y = dui, color = "DUI")) +
      geom_line(aes(y = motor_vehicle_theft, color = "Motor_Theft_Vehicle")) +
      geom_line(aes(y = robbery, color = "Robbery")) +
      geom_line(aes(y = burglary, color = "Burglary")) +
      geom_line(aes(y = larceny, color = "Larceny")) +
      geom_line(aes(y = stolen_property, color = "Stolen_Property")) +
      scale_colour_manual(name = "Line Color",
                         values=c(DUI = "blue",
                                  Motor_Theft_Vehicle = "grey",
                                  Robbery = "orange",
                                  Burglary = "red",
                                  Larceny = "green",
                                  Stolen_Property = "purple")) +
    ylab(label = "Number of crimes") +
    xlab("Year") +
    ggtitle(paste("DUI Against Other Theft Crimes at the National Level")) +
    theme(plot.title = element_text(size = 20,
                                    face="bold",
                                    vjust = 1,
                                    lineheight = 0.8,
                                    margin = margin(10, 0, 10, 0)))
  })
  
  output$analysis_plot_4 <- renderText({
    paste0(
        "This plot shows the arrest records for the years 1995 - 2016. The types of arrests are stacked to show how each kind of 
        crime has progressed each year. Further statistics based on the specific year are found under this graph to look more in depth
        of the yearly numbers."
    ) 
  })
  
}

