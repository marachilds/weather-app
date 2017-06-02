# Temperature Line Graph
temperature <- plot_ly(data, 
                   x = ~rating,
                   y = ~get(input$y), 
                   color = ~get(input$color),
                   colors = "PuRd",
                   size = ~get(input$size),
                   type = 'scatter', 
                   mode = 'markers',
                   hoverinfo = 'text',
                   text = ~paste0('Cereal: ', cereal$cereal.name,
                                  '</br>', "Manufacturer: ", cereal$mfr),
                   position = 'dodge',
                   marker = list(colorbar = list(title = input$color)))  %>%
  layout(title = "Cereal Nutrition by Rating", 
         xaxis = x, 
         yaxis = y,
         margin = list(b = 160), 
         xaxis = list(tickangle = 45))

plotly_build(p)