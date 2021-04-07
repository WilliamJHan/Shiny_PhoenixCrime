#Target audience = city of Phoenix Police Department
#Goal of the app & presentation = raise awareness to when and where crime rates 
#are high so they can better place the officers on duty. 

library(dplyr)
library(tidyr)
library(tidyverse)
library(lubridate)
library(scales)

#Set working directory to where the data lies.
setwd("D:/NYCDSA/Project 1 (Shiny App)/Phoenix Crime")

#Bring in the data sets. These are pulled from https://www.phoenixopendata.com
crimestat_orig = read.csv("crimestat.csv", na.strings = "", stringsAsFactors = FALSE)
unemployment = read.csv("phoenix_unemployment.csv")
police = read.csv("Police_Stations.csv", stringsAsFactors = FALSE)
premise_mapping = read.csv("premise_mapping.csv", stringsAsFactors = FALSE)
zipcode = read.csv("phoenix_zip.csv")

#I don't need INC NUMBER and 100 BLOCK ADDR for my analysis. I will also remove OCCURRED.TO for this part of the analysis.
crimestat = crimestat_orig
names(crimestat) <- tolower(names(crimestat))
crimestat = crimestat %>% 
  select(., occurred.on, ucr.crime.category, zip, premise.type) %>% 
  rename(., crime.cat = ucr.crime.category)

#For this part of the analysis, I will remove wherever there is NA since there are only ~2,500 observations.
crimestat = crimestat %>% drop_na()

#Change occurred.on to time format for labeling later.
crimestat$occurred.time <- gsub(" +", " ", crimestat$occurred.on)
crimestat$occurred.time <- strptime(crimestat$occurred.on, format = "%m/%d/%Y %H:%M")

#Separating occurred.on into date and time.
crimestat = crimestat %>% 
  separate(., occurred.on, c("date","time"), sep = "  ", remove = TRUE)

crimestat = crimestat %>% 
  mutate(., date = as.Date(date, "%m/%d/%Y"))

#Add hour & day of the week.
crimestat = crimestat %>%
  mutate(., hour = as.numeric(substr(time,1,2))) %>% 
  mutate(., day = weekdays(date)) %>% 
  mutate(., year = year(date)) %>% 
  mutate(., month = month(date)) %>% 
  select(., date, year, month, time, hour, day, crime.cat, zip, premise.type, occurred.time)

#Join the unemployment rate onto crimestat. Unemployment data only goes upto 2019 September, so the time after that is set to NA.
crimestat = left_join(crimestat, unemployment %>% select(.,year, month, unemployment_rate), by = c("year", "month"))
crimestat = left_join(crimestat, premise_mapping, by = "premise.type")

#Adding month labels.
crimestat = crimestat %>% 
  mutate(., month_full = month.name[month]) %>% 
  mutate(., month_abb = month.abb[month])

#Extra fields I needed.
crimestat$day <- factor(crimestat$day, levels = unique(crimestat$day))
crimestat$day <- factor(crimestat$day, levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))
crimestat$crime.cat <- ifelse(crimestat$crime.cat == "MURDER AND NON-NEGLIGENT MANSLAUGHTER","MURDER",crimestat$crime.cat)
crimestat$Month_Yr <- format(crimestat$date, "%Y-%m")

#Export crimestat_main.csv
write.csv(crimestat, "crimestat_main.csv")

#Create zip code summary to attach to zip code geo data
crimestat_zip <- crimestat %>% 
  group_by(.,zip, year, month, month_full) %>% 
  summarise(.,freq = n())

zipcode = inner_join(zipcode, crimestat_zip, by = "zip")
write.csv(zipcode, "zipcode_main.csv")
