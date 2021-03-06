# server.R

# Libraries
library(dplyr)
library(shiny)
library(plotly)
library(httr)
library(stringr)
library(rjson)
library(jsonlite)
library(anytime)
library(shinythemes)

# Scripts
source('scripts/setup.R')
source('scripts/about.R')

# shinyServer
shinyServer(function(input, output) {
  
  #Seperates location into city and state, retrieves data for specified set
  selectData <- reactive({
    location <- str_split_fixed(input$city, ", ", 2)
    my.data <- weatherData(location[,1], location[,2], input$date)
    return(my.data)
  })
  
  results <- reactive({
    return(analysis(location[,1], location[,2], input$date))
  })
  
  #Plot
  output$mainPlot <- renderPlotly({
    x <- list(
      title = "Hour"
    )
    
    thePlot <- plot_ly(selectData(), 
                       x = ~time,
                       y = ~temperature,
                       name = 'Temperature',
                       colors = "PuRd",
                       type = 'scatter', 
                       mode = 'lines+markers',
                       hoverinfo = 'text',
                       text = ~paste0('</br>', "Time: ", selectData()$time.only,
                                      '</br>', "Temperature: ", selectData()$temperature,
                                      '</br>', "Wind Speed: ", selectData()$windSpeed,
                                      '</br>', "Cloud Coverage: ", selectData()$cloudCover)) %>%
      layout(title = paste("Weather in", input$city, "on", input$date), 
             xaxis = x) %>% 
      add_trace(y = ~windSpeed, name = 'Wind Speed', mode = 'lines+markers') %>% 
      add_trace(y = ~cloudCover, name = 'Cloud Coverage', mode = 'lines+markers')
    
    plotly_build(thePlot)
    
  })
  
  # Text rendering for about and insights
  output$about <- renderText({about})
  output$insights <- renderText({insights})
  
})