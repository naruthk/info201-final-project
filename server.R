


national <- read.csv("data/arrests_national.csv")
state <- read.csv("data/estimated_crimes.csv")


library(dplyr)
library(tidyr)
library(ggplot2)

juvenile_data <- read.csv("data/arrests_national_juvenile.csv", stringsAsFactors = FALSE)
adults_data <- read.csv("data/arrests_national_adults.csv", stringsAsFactors = FALSE)

juvenile_data_req <- mutate(juvenile_data, total_arrests = total_male + total_female) %>% 
  filter(offense_name != "Curfew and Loitering Law Violations" & offense_name != "Runaway") %>% 
  select(year, offense_name, total_arrests)

adult_data_req <- mutate(adults_data, total_arrests = total_male + total_female) %>% 
  select(year, offense_name, total_arrests)

colnames(adult_data_req) <- c("year", "Offense_Name", "adults_arrests")
colnames(juvenile_data_req) <- c("year", "Offense_Name", "juvenile_arrests")

adult_data_req["juvenile_arrests"] = juvenile_data_req["juvenile_arrests"]

combined_compare_data <- adult_data_req


my_server <- function(input, output) {
  
  filtered <- reactive({
    new_data <- filter(combined_compare_data, Offense_Name == input$crimes)
    return(new_data)
  })
  
  output$intro_to_graph <- renderText({
    crime_selected <- input$crimes
    intro <- paste0("The following plot presents before the user the comparison between Adults
                     and Juvenile regarding the crime related to ", crime_selected, " in the years
                    1994 - 2016.")
  })
  
  output$plot2 <- renderPlot({
    crime_selected <- input$crimes
     ggplot(filtered(), aes(x = year)) +
      geom_line(aes(y = adults_arrests, color = "Adults_Arrested")) +
      geom_line(aes(y = juvenile_arrests, color = "Juvenile_Arrests")) +
      labs(
        x = "Year", 
        y = "Number of Arrests", 
        title = paste0("Adults and Juvenile Arrests in matter of ", crime_selected)
      ) +
      theme(plot.title = element_text(size = 20,
                                      face="bold",
                                      vjust = 1,
                                      lineheight = 0.8,
                                      margin = margin(10, 0, 10, 0))) 
      })
  output$conclusion_to_grph <- renderText({
    crime_selected <- input$crimes
    mean_adults <- summarize(filtered(), mean(adults_arrests))
    mean_juvenile <- summarize(filtered(), mean(juvenile_arrests))
    min_adults <- filter(filtered(), adults_arrests == min(adults_arrests)) %>% 
      select(year)
    max_juvenile <- filter(filtered(), juvenile_arrests == max(juvenile_arrests)) %>% 
      select(year)
    min_juvenile <- filter(filtered(), juvenile_arrests == min(juvenile_arrests)) %>% 
      select(year)
    max_adults <- filter(filtered(), adults_arrests == max(adults_arrests)) %>% 
      select(year)
    
    paste0("Now, coming to analysation of our plot, we see that the most arrests among adults were made in year ", max_adults, " and the most arrests from juveniles were in the year ", max_juvenile, ". The minimum arrests among the adults
           and juveniles were made in years ", min_adults, " and ", min_juvenile, " respectively. We can also see that in the matters
           related to " , crime_selected, ", average number of arrests in the adults for years 1994 to 2016 is ", round(mean_adults, digits = 0), ". The average
           arrests among juveniles is ", round(mean_juvenile, digits = 0), ". Thus by looking the graph and also seeing the average arrests of
           both juveniles and adults, we can conclude that adults are more involved in substance abuse.")
  })
  
  output$table <- renderDataTable({
    new_data <- filter(combined_compare_data, Offense_Name == input$crimes) %>% 
      filter(year > input$year[1] & year < input$year[2])
    return(new_data)
  })
}

shinyServer(my_server)

