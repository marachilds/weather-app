# Read in libraries
library(shiny)
library(plotly)
library(shinythemes)

# Read in source scripts
source('scripts/setup.R')

# Create Shiny UI
shinyUI(fluidPage(theme = shinytheme("superhero"),
  
  # Application title
  titlePanel("Twitter and Weather"),
  
  # Sidebar with select inputs for date, time, and city
  sidebarLayout(
    
    sidebarPanel(
      
      # Returns Capital City, State
      selectInput("city", "Select City", choices = cities),
      
      # Returns YYYY-MM-DD
      dateInput("date", "Select Date", max = Sys.Date()),
    
    # Plot it!
    mainPanel(
      
      tabsetPanel(
        
        # Plot panel
        tabPanel("Plot", plotlyOutput('mainPlot', height = "600px", width = "800px")),
        
        # Insights panel
        tabPanel("Insights", textOutput('insights')),

        # About panel
        tabPanel("About", textOutput('about'))
      )
      )
    )
  )
)
)
