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

crimestat_duration = crimestat_orig
names(crimestat_duration) <- tolower(names(crimestat_duration))
crimestat_duration = crimestat_duration %>% 
  select(., occurred.on, occurred.to, ucr.crime.category, zip, premise.type) %>% 
  rename(., crime.cat = ucr.crime.category)

#For this part of the analysis, I will remove wherever there is NA since there are only ~2,500 observations.
crimestat_duration = crimestat_duration %>% drop_na()

#Change occurred.on to time format for labeling later.
crimestat_duration$occurred.time <- gsub(" +", " ", crimestat_duration$occurred.on)
crimestat_duration$occurred.time <- strptime(crimestat_duration$occurred.on, format = "%m/%d/%Y %H:%M")

#Separating occurred.on into date and time.
crimestat_duration$occurred.on.dup = crimestat_duration$occurred.on
crimestat_duration = crimestat_duration %>% 
  separate(., occurred.on, c("date","time"), sep = "  ", remove = TRUE)
crimestat_duration$occurred.on = crimestat_duration$occurred.on.dup

crimestat_duration = crimestat_duration %>% 
  mutate(., date = as.Date(date, "%m/%d/%Y"))

#Add hour & day of the week.
crimestat_duration = crimestat_duration %>%
  mutate(., hour = as.numeric(substr(time,1,2))) %>% 
  mutate(., day = weekdays(date)) %>% 
  mutate(., year = year(date)) %>% 
  mutate(., month = month(date)) %>% 
  select(., date, year, month, time, hour, day, crime.cat, zip, premise.type, occurred.time, occurred.on, occurred.to)

crimestat_duration = left_join(crimestat_duration, premise_mapping, by = "premise.type")

#Adding month labels.
crimestat_duration = crimestat_duration %>% 
  mutate(., month_full = month.name[month]) %>% 
  mutate(., month_abb = month.abb[month])

#Extra fields I needed.
crimestat_duration$day <- factor(crimestat_duration$day, levels = unique(crimestat_duration$day))
crimestat_duration$day <- factor(crimestat_duration$day, levels = c("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"))
crimestat_duration$crime.cat <- ifelse(crimestat_duration$crime.cat == "MURDER AND NON-NEGLIGENT MANSLAUGHTER","MURDER",crimestat_duration$crime.cat)
crimestat_duration$Month_Yr <- format(crimestat_duration$date, "%Y-%m")

crimestat_duration$occurred.on <- strptime(crimestat_duration$occurred.on, format = "%m/%d/%Y %H:%M")
crimestat_duration$occurred.to <- strptime(crimestat_duration$occurred.to, format = "%m/%d/%Y %H:%M")

crimestat_duration$timediff <- difftime(crimestat_duration$occurred.to,crimestat_duration$occurred.on,units = "hours")
crimestat_duration$timediff_hrs <- as.numeric(difftime(crimestat_duration$occurred.to,crimestat_duration$occurred.on,units = "hours"))

write.csv(crimestat_duration, "duration_main.csv")
