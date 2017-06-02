# Read in scripts
source('scripts/setup.R')

# Temperature Line Graph
thePlot <- plot_ly(my.data, 
                   x = ~time,
                   y = ~temperature, 
                   colors = "PuRd",
                   type = 'scatter', 
                   mode = 'lines+markers',
                   hoverinfo = 'text',
                   text = ~paste0('Location: ', ~get(input$city),
                                  '</br>', "Time: ", my.data$time.only,
                                  '</br>', "Temperature ", my.data$temperature),
                   marker = list(colorbar = list(title = input$color)))  %>%
  layout(title = "Title Here", 
         xaxis = x, 
         yaxis = y
         )

trace.wind <- "%>% add_trace(y = ~windSpeed, name = 'Wind Speed', mode = 'lines+markers')"

trace.cloud <- "%>% add_trace(y = ~cloudCover, name = 'Cloud Coverage', mode = 'lines+markers')"