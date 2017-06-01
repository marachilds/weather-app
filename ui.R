# Read in libraries
library(shiny)
library(plotly)

# Read in source scripts
source('scripts/setup.R')

# Create Shiny UI
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Twitter and Weather"),
  
  # Sidebar with select inputs for date, time, and city
  sidebarLayout(
    
    sidebarPanel(
      
      # Returns Capital City, State
      selectInput("city", "Select City", choices = cities),
      
      # Returns YYYY-MM-DD
      dateInput("start.date", "Select Date", max = Sys.Date()),
      
      # Returns YYYY-MM-DD
      dateInput("end.date", "Select End Date", min = min.end, max = max.end, value = max.end),
      
      # Returns 1 (Tweets) or 2 (Weather) or 3 (Both)
      radioButtons("radio", label = "Charts to Display",
                   choices = list("Tweets" = 1, "Weather" = 2, "Both" = 3), 
                   selected = 2)),
    
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
