# Read in libraries
library(shiny)
library(plotly)
library(shinythemes)

# Read in source scripts
#source('scripts/setup.R')
#source('scripts/analysis.R')

# Create Shiny UI
shinyUI(fluidPage(theme = shinytheme("superhero"),
  
  # Application title
  titlePanel("What's the Temperature?"),
  
  # Sidebar with select inputs for date, time, and city
  sidebarLayout(
    
    sidebarPanel(
      
      # Returns Capital City, State
      selectInput("city", "Select City", choices = cities),
      
      # Returns YYYY-MM-DD
      dateInput("date", "Select Date", max = Sys.Date()),
      
      # Returns "1" "2" and/or "3"
      checkboxGroupInput("plots", "Select Data", choices = plots)
      
    ),
    
    # Plot it!
    mainPanel(
      
      tabsetPanel(
        
        # Plot panel
        tabPanel("Plot", plotlyOutput('mainPlot', height = "600px", width = "800px"))
        #,
        
        # Insights panel
        #tabPanel("Insights", textOutput('insights')),

        # About panel
        #tabPanel("About", textOutput('about'))
      )
      )
    )
  )
)
