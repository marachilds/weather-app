library(dplyr)

source("scripts/setup.r")

# How does wind speed and cloud coverage affect temp?
# 
# what affects it in a positive way
# what affects it in a negetive way
# 
analysis <- function(date, city, state) {
  
  # getting data
  data <- weatherData("Sacramento", "CA", "25 May 2017")
  
  # highest temperature value
  highest.temp <- summarize(data, highest = max(temperature))
  
  # wind speed value for highest temperature
  high.temp.wind.speed <- filter(data, temperature == highest.temp) %>% select(windSpeed)
  
  # cloud coverage value for highest temperature
  high.temp.cloud.coverage <- filter(data, temperature == highest.temp) %>% select(cloudCover)
  
  # average wind speed
  ave.wind.speed <- summarize(data, ave = mean(windSpeed))
  
  # average cloud coverage
  ave.cloud.coverage <- summarize(data, ave = mean(cloudCover))
  
  # average temperature
  ave.temp <- summarize(data, ave = mean(temperature))
  
  # returning if the sent var1 values is above or below the average of that variable
  aboveBelow <- function(var1, mean) {
    if(var1 > mean) {
      return(paste("above average"))
    } else {
      return(paste("below average"))
    }
  }
  
  # Getting correlation between temperature and wind speed and cloud coverage
  test.cor.data <- data %>% select(temperature, windSpeed, cloudCover)
  correlation <- cor(test.cor.data)[,1]
  ws.progress <- ""
  cc.progress <- ""
  
  # Checking for correlation between wind speed and temperature
  if(correlation[,2] > 0.5) {
    ws.progress <- "Wind speed and temperature have a strong positive correlation. "
  } else if (correlation[,2] < -0.5) {
    ws.progress <- "Wind speed and temperature have a strong inverse correlation. "
  } else {
    ws.progress <- "Not a strong correlation between wind speed and temperature. "
  }
  
  # Checking for correlation between wind speed and temperature
  if(correlation[,3] > 0.5) {
    cc.progress <- "Cloud coverage and temperature have a strong positive correlation."
  } else if (correlation[,3] < -0.5) {
    cc.progress <- "Cloud coverage and temperature have a strong inverse correlation."
  } else {
    cc.progress <- "Not a strong correlation between cloud coverage and temperature."
  }
  
  # combining the actual analysis
  results <- paste0("On ", date, ", in the city of ", city, ", ", state, " the highest temperature reached was ", highest.temp, " Farenheiegt. The wind
                    speed was around ", high.temp.wind.speed., " mph and cloud coverage was about ", high.temp.cloud.coverage, ". This wind speed is ",
                    aboveBelow(high.temp.wind.speed, ave.wind.speed), " and the cloud coverage is ", aboveBelow(high.temp.cloud.coverage, ave.cloud.coverage),
                    ". The average temperature was around ", ave.temp, ", the average cloud coverage was around ", ave.cloud.coverage,
                    " and the wind speed was around ", ave.wind.speed, ". ", ws.progress, cc.progress)
  return(results)
}