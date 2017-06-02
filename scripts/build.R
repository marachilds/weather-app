# Read in scripts
source('scripts/setup.R')
source('ui.R')

location <- str_split_fixed(input$city, ", ", 2)
my.data <- weatherData(location$1, location$2, input$date)

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
                                  '</br>', "Temperature ", my.data$temperature)) %>%
   layout(title = "Title Here", 
          xaxis = x, 
          yaxis = y
          )

trace.wind <- thePlot %>% add_trace(y = ~windSpeed, name = 'Wind Speed', mode = 'lines+markers')

trace.cloud <- thePlot %>% add_trace(y = ~cloudCover, name = 'Cloud Coverage', mode = 'lines+markers')

trace.both <- trace.wind %>% add_trace(y = ~cloudCover, name = 'Cloud Coverage', mode = 'lines+markers')

thePlot <- thePlot %>% add_trace(y = ~windSpeed, name = 'Wind Speed', mode = 'lines+markers')
thePlot <- thePlot %>% add_trace(y = ~cloudCover, name = 'Cloud Coverage', mode = 'lines+markers')
