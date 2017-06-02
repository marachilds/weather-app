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
#source('scripts/analysis.R')
#source('scripts/build.R')

# shinyServer
shinyServer(function(input, output) {
  
  #Plot
  output$mainPlot <- renderPlotly({
    
    my.data <- 
    
    x <- list(
      title = "Hour"
    )
    
    thePlot <- plot_ly(my.data, 
                       x = ~time,
                       y = ~temperature, 
                       colors = "PuRd",
                       type = 'scatter', 
                       mode = 'lines+markers',
                       hoverinfo = 'text',
                       text = ~paste0('Location: ', ~get(input$city),
                                      '</br>', "Time: ", my.data$time.only,
                                      '</br>', "Temperature ", my.data$temperature)) %>%
      layout(title = "Title Here", 
             xaxis = x) %>% 
      add_trace(y = ~windSpeed, name = 'Wind Speed', mode = 'lines+markers') %>% 
      add_trace(y = ~cloudCover, name = 'Cloud Coverage', mode = 'lines+markers')
    
    plotly_build(thePlot)
    
  })

  # Text rendering for about and insights
  output$about <- renderText({about})
  output$insights <- renderText({insights})
  
})