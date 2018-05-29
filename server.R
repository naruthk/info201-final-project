national <- read.csv("data/arrests_national.csv")
state <- read.csv("data/estimated_crimes.csv")

library(datasets)
data(iris)

crime_rates_national <- national %>%
  select(year, population, total_arrests, dui, robbery, 
         burglary, larceny, motor_vehicle_theft, stolen_property)

my_server <- function(input, output) {
  
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
                                    margin = margin(10, 0, 10, 0))) +
      labs(caption = "The rate of driving under the influence (DUI) decreases
            from 1995 to 2016 along with other type of thefts as well.
            What is extremely evidential is that the numbers of DUI and larceny 
            crimes exceed that of crimes such as burglary, robbery, and etc. 
            Overall, there has been a decrease in the number of crimes from
            1995 to 2016.
           ")
    
    # ggplot(data = filtered(), 
    #        mapping = aes(x = Year, y = Number_of_Eviction_Judgment)) +
    #   geom_point() + geom_smooth(method = "lm") +
    #   ggtitle(paste("DUI Against Other Theft Crimes")) +
    #   theme(
    #     plot.title = element_text(size = 20, 
    #                               face="bold",
    #                               vjust = 1, 
    #                               lineheight = 0.8,
    #                               margin = margin(10, 0, 10, 0))) +
    #   labs(y = "Number of Evictions", 
    #        caption = "
    #        Remark: This table displays the rate of evictions over the years. 
    #        Note that certain states may not have the data to display.")
    # 
  })
  
}

shinyServer(my_server)