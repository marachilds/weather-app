# server.R

# Libraries
library(dplyr)
library(rgeos)
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
source('scripts/analysis.R')
source('scripts/about.R')

# shinyServer
shinyServer(function(input, output) {
  
  selectData <- reactive({
    location <- str_split_fixed(input$city, ", ", 2)
    my.data <- weatherData(location[,1], location[,2], input$date)
    return(my.data)
  })
  
  #Plot
  output$mainPlot <- renderPlotly({
    x <- list(
      title = "Hour"
    )
    
    thePlot <- plot_ly(selectData(), 
                       x = ~time,
                       y = ~temperature, 
                       colors = "PuRd",
                       type = 'scatter', 
                       mode = 'lines+markers',
                       hoverinfo = 'text',
                       text = ~paste0('Location: ', ~get(input$city),
                                      '</br>', "Time: ", selectData()$time.only,
                                      '</br>', "Temperature ", selectData()$temperature)) %>%
      layout(title = paste("Weather in", input$city, "on", input$date), 
             xaxis = x) %>% 
      add_trace(y = ~windSpeed, name = 'Wind Speed', mode = 'lines+markers') %>% 
      add_trace(y = ~cloudCover, name = 'Cloud Coverage', mode = 'lines+markers')
    
    plotly_build(thePlot)
    
  })

  # Text rendering for about and insights
  
  output$about <- renderText({about})
  
  output$insights <- renderText({
    
    analysis(input$date, location[,1], location[,2])
    
  })
  
})