library(jsonlite)
library(rgeos)
library(rgdal)
library(httr)
library(plyr)
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
cities <- c("Montgomery, AL", "Juneau, AK", "Phoenix, AZ",
            "Little Rock, AR", "Sacramento, CA", "Denver, CO",
            "Hartford, CT", "Dover, DE", "Tallahassee, FL",
            "Atlanta, GA", "Honolulu, HI", "Boise, ID", "Springfield, IL",
            "Indianapolis, IN", "Des Moines, IA", "Topeka, KS", "Frankfort, KY", 
            "Baton Rouge, LA", "Augusta, ME", "Annapolis, MD", "Boston, MA", 
            "Lansing, MI", "St. Paul, MN", "Jackson, MS", "Jefferson City, MO",
            "Helena, MT", "Lincoln, NE", "Carson City, NV", "Concord, NH",
            "Trenton, NJ", "Santa Fe, NM", "Albany, NY", "Raleigh, NC",
            "Bismarck, ND", "Columbus, OH", "Oklahoma City, OK", "Salem, OR",  
            "Harrisburg, PA", "Providence, RI", "Columbia, SC",
            "Pierre, SD", "Nashville, TN", "Austin, TX", "Salt Lake City, UT",
            "Montpelier, VT", "Richmond, VA", "Olympia, WA", "Charleston, WV",
            "Madison, WI", "Cheyenne, WY"
)

# Plot list
plots <- c("Wind speed", "Cloud coverage")

# Retrieves dataset for towns and cities in Canada/US with latitudinal and longitudinal data for API calls
geo_data <- read.csv("scripts/geo_data.csv")

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
  # key <- "f2816b4bb0266a96e77991a187b35d9c"
    # fromJSON(txt = "access-keys.json")$weather$key
  
  # Convert given Date to UNIX format
  unix.time.day <- as.numeric(as.POSIXct(anydate(day)))
  
  # setting params for API  call
  base.url <- "https://api.darksky.net/forecast/"
  weather.uri <- paste0(base.url, "f2816b4bb0266a96e77991a187b35d9c", "/", latitude, ",", longitude, ",", unix.time.day)
  weather.params <- list(exclude = paste0("currently", ",", "minutely", ",", "daily", ",", "flags"))

  # retrieving data from API
  weather.response <- GET(weather.uri, query = weather.params)
  weather.body <- content(weather.response, "text")
  weather.results <- fromJSON(weather.body)
  
  # retrieve location time zone to appropriately convert UNIX time
  location.timezone <- weather.results$timezone
  
  # Gets data sorted by hour
  weather.df <- weather.results$hourly$data
  weather.df <- ldply(weather.df, data.frame)
  
  # convert UNIX time to Dates
  num.time <- as.numeric(weather.df$time)
  weather.df$time <- anytime(num.time, tz = location.timezone, asUTC = FALSE)

  # separate date and time
  weather.df$time.only <- format(as.POSIXct(weather.df$time) , format = "%H:%M:%S")
  
  # scale up cloud cover
  weather.df$cloudCover <- weather.df$cloudCover * 100
 
  return(weather.df) 
}
