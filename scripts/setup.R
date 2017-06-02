library(jsonlite)
library(rgeos)
library(rgdal)
library(httr)
library(dplyr)
library(anytime)

# Latitude & Longitude Retrieval for API Calls
# --------------------------------------------
# Code for findLatLong and findGeoData sourced from: 
# https://stackoverflow.com/posts/27868207/revisions

# Returns a data frame that contains the longitude and latitude
# for the given state and city.
# Input format: findLatLong(geog_db, "Portland", "ME")
# Ex: lon       lat       city      state
#     -70.25404 43.66186  Portland   ME
findLatLong <- function(geo_db, city, state) {
  do.call(rbind.data.frame, mapply(function(x, y) {
    geo_db %>% filter(city==x, state==y)
  }, city, state, SIMPLIFY=FALSE))
}


# Global Variables 
# Options list for states and capital cities
cities <- c("Montgomery, Alabama", "Juneau, Alaska", "Phoenix, Arizona",
            "Little Rock, Arkansas", "Sacramento, California", "Denver, Colorado",
            "Hartford, Connecticut", "Dover, Delaware", "Tallahassee, Florida",
            "Atlanta, Georgia", "Honolulu, Hawaii", "Boise, Idaho", "Springfield, Illinois",
            "Indianapolis, Indiana", "Des Moines, Iowa", "Topeka, Kansas", "Frankfort, Kentucky", 
            "Baton Rouge, Louisiana", "Augusta, Maine", "Annapolis, Maryland", "Boston, Massachusetts", 
            "Lansing, Michigan", "St. Paul, Minnesota", "Jackson, Mississippi", "Jefferson City, Missouri",
            "Helena, Montana", "Lincoln, Nebraska", "Carson City, Nevada", "Concord, New Hampshire",
            "Trenton, New Jersey", "Santa Fe, New Mexico", "Albany, New York", "Raleigh, North Carolina",
            "Bismarck, North Dakota", "Columbus, Ohio", "Oklahoma City, Oklahoma", "Salem, Oregon",  
            "Harrisburg, Pennsylvania", "Providence, Rhode Island", "Columbia, South Carolina",
            "Pierre, South Dakota", "Nashville, Tennessee", "Austin, Texas", "Salt Lake City, Utah",
            "Montpelier, Vermont", "Richmond, Virginia", "Olympia, Washington", "Charleston, West Virginia",
            "Madison, Wisconsin", "Cheyenne, Wyoming"
)

# Retrieves dataset for towns and cities in Canada/US with latitudinal and longitudinal data for API calls
geo_data <- read.csv("scripts/geo_data.csv")

city <- "Portland"
state <- "ME"
day <- "28 May 2017"

# Retrieves a data frame with weather data for the specified day with the given city and state,
# with hourly time block starting from midnight of the day requested, 
# continuing until midnight of the following day. Hourly time blocks start from the current system time.
# input format: weatherData("Portland", "ME", "28 May 2017"), multiple Date formats should work
# Ex: temperature     time
#     45.3690         2017-05-27 14:00:00
weatherData <- function(city, state, day) {
  
  # Retrieve latitude and longitude for given city and state
  lat.long.df <- geo_data %>% findLatLong(city, state)
  longitude <- lat.long.df[,1]
  latitude <- lat.long.df[,2]
  
  # Convert given Date to UNIX format
  unix.time.day <- as.numeric(as.POSIXct(anydate(day)))
  
  # Retrieve API key from key.JSON (stored in JSON for security)
  key <- fromJSON(txt = "access-keys.json")$weather$key
  
  # Convert given Date to UNIX format
  unix.time.day <- as.numeric(as.POSIXct(anydate(day)))
  
  # setting params for API  call
  base.url <- "https://api.darksky.net/forecast/"
  weather.uri <- paste0(base.url, key, "/", longitude, ",", latitude, ",", unix.time.day)
  weather.params <- list(exclude = paste0("currently", ",", "minutely", ",", "daily", ",", "flags"))

  # retrieving data from API
  weather.response <- GET(weather.uri, query = weather.params)
  weather.body <- content(weather.response, "text")
  weather.results <- fromJSON(weather.body)
  
  # retrieve location time zone to appropriately convert UNIX time
  location.timezone <- weather.results$timezone
  
  # Gets data sorted by hour
  weather.df <- weather.results$hourly$data
 
  # convert UNIX time to Dates
  weather.df$time <- anytime(weather.df$time, asUTC = TRUE)
  
  # convert temperatures from Celsius to Fahrenheit
  weather.df$temperature <- (weather.df$temperature * (9/5)) + 32
  weather.df$apparentTemperature <- (weather.df$apparentTemperature * (9/5)) + 32

  return(weather.df) 
}