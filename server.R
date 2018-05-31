
library(ggplot2)
library(dplyr)
library(shiny)

national <- read.csv("data/arrests_national.csv", stringsAsFactors = FALSE)
state_and_national <- read.csv("data/estimated_crimes.csv", stringsAsFactors = FALSE)
state <- state_and_national[23:1144,]

average_violent_crime <- summarize(state, average = mean(violent_crime, na.rm = TRUE))
average_homicide <- summarize(state, average = mean(homicide, na.rm = TRUE))
average_rape_legacy <- summarize(state, average = mean(rape_legacy, na.rm = TRUE))
average_rape_revised <- summarize(state, average = mean(rape_revised, na.rm = TRUE))
average_robbery <- summarize(state, average = mean(robbery, na.rm = TRUE))
average_property_crime <- summarize(state, average = mean(property_crime, na.rm = TRUE))
average_aggravated_assault <- summarize(state, average = mean(aggravated_assault, na.rm = TRUE))
average_burglary <- summarize(state, average = mean(burglary, na.rm = TRUE))
average_larceny <- summarize(state, average = mean(larceny, na.rm = TRUE))
average_motor_vehicle_theft <- summarize(state, average = mean(motor_vehicle_theft, na.rm = TRUE))

my_server <- function(input, output) {
  
  filtered <- reactive({
    data <- state %>%
      filter(state_abbr == input$state_choice)
    
    return(data)
  })
  
  output$plot1 <- renderPlot({
    
    plot <- ggplot(data = filtered(),mapping = aes(x = year)) + 
      geom_point(mapping = aes(y = violent_crime, color = "violent_crime")) +
      geom_point(mapping = aes(y = homicide, color = "homicide")) +
      geom_point(mapping = aes(y = rape_legacy, color = "rape_legacy")) +
      geom_point(mapping = aes(y = rape_revised, color = "rape_revised")) +
      geom_point(mapping = aes(y = robbery, color = "robbery")) +
      geom_point(mapping = aes(y = aggravated_assault, color = "aggravated_assault")) +
      geom_point(mapping = aes(y = property_crime, color = "property_crime")) +
      geom_point(mapping = aes(y = burglary, color = "burglary")) +
      geom_point(mapping = aes(y = larceny, color = "larceny")) +
      geom_point(mapping = aes(y = motor_vehicle_theft, color = "motor_vehicle_theft")) +
      scale_colour_manual("Types of crime",breaks = c("violent_crime", "homicide",
                                                      "rape_legacy","rape_revised",
                                                      "robbery","aggravated_assault",
                                                      "property_crime","burglary",
                                                      "larceny","motor_vehicle_theft"),
                          values = c("red", "orange","yellow3","green","purple",
                                     "pink","slateblue4","lightsalmon4","black","turquoise4")) +
      scale_y_log10() +
      ggtitle(paste("Amounts of different types of crimes in the state of",
                    input$state_choice)) + 
      xlab("Year") + ylab("Number of crimes") +
      theme(axis.text = element_text(size = rel(1.5)),
            axis.title.x = element_text(size = rel(1.5),face = "bold"),
            axis.title.y = element_text(size = rel(1.5),face = "bold"),
            plot.title = element_text(size = rel(1.5), 
                                      face = "bold",hjust = 0.5))
    
    return(plot)
  })
  
  output$click1 <- renderText({
    paste0("Year = ", input$plot_click$x, "\nNumber of crimes = ", input$plot_click$y)
  })
  
  output$explanation <- renderText({
    return(paste("The graph above shows the data of different types of crimes
                 for the selected state of",input$state_choice,"from 1995 to 2016. 
                 According to the graph, in every states, property crime was the most
                 and homicide was the less prevalent crime. To sum up, considering every states from 1995 to 2016, 
                 property crime amounted to the highest record of",max(state[10],na.rm = TRUE),
                 "number of crimes and homicide set a lowest record of",
                 min(state[5],na.rm = TRUE),"number of crimes. Considering every states from 1995 to 2016:
                 The average number of violent crimes is",
                 average_violent_crime,". The average number of homicide is",
                 average_homicide,".The average number of rape legacy is",
                 average_rape_legacy,". The average number of rape revised is",
                 average_rape_revised,". The average number of robbery is",
                 average_robbery,". The average number of aggravated assault is",
                 average_aggravated_assault,". The average number of property crime is",
                 average_property_crime,".The average number of burglary is",
                 average_burglary,". The average number of larceny is",
                 average_larceny,". The average number of motor vehicle theft is",
                 average_motor_vehicle_theft,". Comparing the graph to these average values
                 indicates whether the selected state is safer or more dangerous 
                 than  other states."))
  })
}

shinyServer(my_server)