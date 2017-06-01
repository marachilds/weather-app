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

# Scripts
source('scripts/setup.R')
source('scripts/analysis.R')
source('scripts/build.R')

# shinyServer
shinyServer(function(input, output) {
  
  #Plot
  output$mainPlot <- renderPlot({
    
  })
  
  # Text rendering for about and insights
  output$about <- renderText({about})
  output$insights <- renderText({insights})
  
})