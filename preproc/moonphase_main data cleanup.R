moonphase = read.csv("moon-phase.csv",stringsAsFactors = F)

moonphase$UTC_7 <- strptime(moonphase$UTC_7, format = "%m/%d/%y %H:%M")

moonphase = moonphase %>% 
  separate(., UTC_7, c("date", "time"), sep = " ", remove = TRUE)

moonphase = moonphase %>% 
  select(.,Moon_Phase,date)

moonphase$date_format = as.Date(moonphase$date)

moonphase = left_join(crimestat, moonphase, by = "date")

moonphase = moonphase %>% select(.,year, date, Moon_Phase)

moonphase = moonphase %>% drop_na()

moonphase$year = as.character(moonphase$year)

write.csv(moonphase, "moonphase_main.csv")

