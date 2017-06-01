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

# shinyServer
shinyServer(function(input, output) {
  
  # Text rendering for about and insights
  output$about <- renderText({about})
  output$insights <- renderText({insights})
  
})