# Read in scripts
source('scripts/setup.R')

# Temperature Line Graph
thePlot <- plot_ly(weather.df, 
                   x = ~time,
                   y = ~temperature, 
                   colors = "PuRd",
                   type = 'scatter', 
                   mode = 'markers',
                   hoverinfo = 'text',
                   text = ~paste0('Cereal: ', cereal$cereal.name,
                                  '</br>', "Manufacturer: ", cereal$mfr),
                   marker = list(colorbar = list(title = input$color)))  %>%
  layout(title = "Title Here", 
         xaxis = x, 
         yaxis = y
         )

plotly_build(p)