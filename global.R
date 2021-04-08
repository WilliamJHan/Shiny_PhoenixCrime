library(dplyr)
library(tidyr)
library(tidyverse)
library(lubridate)
library(scales)
library(shiny)
library(leaflet)
library(wordcloud)
library(shinydashboard)
library(ggplot2)
library(hrbrthemes)
library(plotly)
library(networkD3)
library(DT)
library(shinythemes)
library(wordcloud)

crimestat = read.csv("data/crimestat_main.csv")
zipcode = read.csv("data/zipcode_main.csv")
police = read.csv("data/Police_Stations.csv")
moonphase = read.csv("data/moonphase_main.csv")
population = read.csv("data/population_by_zip.csv")
weather = read.csv("data/phoenix_weather.csv")
duration = read.csv("data/duration_main.csv")
premise_mapping = read.csv("data/premise_mapping.csv", stringsAsFactors = FALSE)

crimestat_orig = read.csv("data/crimestat.csv")
zipcode_orig = read.csv("data/phoenix_zip.csv")
moonphase_orig = read.csv("data/moon-phase.csv")
population_orig = read.csv("data/population_by_zip.csv")
weather_orig = read.csv("data/phoenix_weather.csv")
duration_orig = read.csv("data/duration_main.csv")

#Prepping for Zip Code leaflet map
addLegendCustom <- function(map, colors, labels, sizes, shapes, borders, opacity = 0.5){
  
  make_shapes <- function(colors, sizes, borders, shapes) {
    shapes <- gsub("circle", "50%", shapes)
    shapes <- gsub("square", "0%", shapes)
    paste0(colors, "; width:", sizes, "px; height:", sizes, "px; border:3px solid ", borders, "; border-radius:", shapes)
  }
  make_labels <- function(sizes, labels) {
    paste0("<div style='display: inline-block;height: ", 
           sizes, "px;margin-top: 4px;line-height: ", 
           sizes, "px;'>", labels, "</div>")
  }
  
  legend_colors <- make_shapes(colors, sizes, borders, shapes)
  legend_labels <- make_labels(sizes, labels)
  
  return(addLegend(map, position = "bottomright", colors = legend_colors, labels = legend_labels, opacity = opacity))
}

#Prepping for Sankey
crimestat_links <- crimestat %>%
  filter(.,year %in% c(2016, 2017, 2018, 2019, 2020)) %>%
  group_by(.,premise,year) %>%
  summarise(.,freq = n())

crimestat_nodes <- data.frame(
  name = c(as.character(crimestat_links$premise),
           as.character(crimestat_links$year)) %>% unique()
)

crimestat_links$IDsource <- match(crimestat_links$premise, crimestat_nodes$name) - 1
crimestat_links$IDtarget <- match(crimestat_links$year, crimestat_nodes$name) - 1

#Prepping for moon phase graph.
moonphase$year = as.character(moonphase$year)

#Prepping for population 
crimestat_population = crimestat %>% 
  group_by(.,year, month_full, zip) %>%
  summarise(., freq = n())

population$Population = as.numeric(gsub(",","",population$Population))
population$population_per_sqmile = as.numeric(gsub(",","",population$population_per_sqmile))

crimestat_population = inner_join(crimestat_population, population, by = "zip")

#Reorder days of week.
crimestat$day <- factor(crimestat$day, levels = unique(crimestat$day))
crimestat$day <- factor(crimestat$day, levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))
duration$day <- factor(duration$day, levels = unique(duration$day))
duration$day <- factor(duration$day, levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))

#Rearrange weather data
weather = weather %>% 
  gather(key = month, value = temperature, January:December, na.rm = TRUE)

crimestat_weather = crimestat %>% 
  group_by(.,year, month_full) %>% 
  summarise(., freq = n())

crimestat_weather = left_join(crimestat_weather, weather, by = c("year" = "Year", "month_full" = "month"))
crimestat_weather$temperature = as.numeric(crimestat_weather$temperature)
