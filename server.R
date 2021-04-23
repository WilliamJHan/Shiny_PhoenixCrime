shinyServer(function(input, output) {

    #To put the tabs on the right side
    shinyjs::addClass(id = "main", class = "navbar-right")

    #Create overview graph
    output$overviewPlot1 <- renderPlot({
        crimestat %>% 
            filter(.,zip %in% input$zipChoice_overview, crime.cat %in% input$CatChoice_overview, premise %in% input$PremChoice_overview) %>% 
            group_by(.,Month_Yr) %>%
            summarise(., freq = n()) %>% 
            ggplot() +
            geom_smooth(aes(x = Month_Yr, y = freq, group = 1), size = 1.2, span = 0.2, se = F) +
            scale_x_discrete(breaks = c("2016-01", "2016-07", "2017-01", "2017-07", "2018-01", "2018-07", "2019-01", "2019-07", "2020-01", "2020-07", "2021-01")) +
            scale_y_continuous(labels = comma) +
            labs(x = "Year-Month", y = "Number of Crimes") +
            theme_light()
    })
    
    #Create info box for overview tab
    output$infobox1 <- renderInfoBox({
        infoBox(
            "Crime", value = prettyNum(65109,big.mark = ","), icon = icon("balance-scale"), color = "red", fill = TRUE
        )
    })
    
    #Create horizontal bar plot for zip code ranking
    output$zipPlot1 <- renderPlot({
        crimestat %>%
            filter(.,year %in% input$yearChoice_zip, month_full %in% input$monthChoice_zip) %>%
            group_by(.,zip) %>%
            summarise(.,freq = n()) %>%
            top_n(10) %>% 
            ggplot() +
            geom_bar(aes(x = reorder(zip,freq), y = freq), stat = "identity", fill = "orangered4") +
            coord_flip() +
            ggtitle("Number of Crimes by Top 10 Zip Codes") +
            labs(y = "Number of Crimes") +
            scale_y_continuous(labels = comma) +
            theme(axis.title.y = element_blank(),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.border = element_blank(),
                  panel.background = element_blank(),
                  axis.ticks.x = element_blank(),
                  axis.ticks.y = element_blank(),
                  plot.title = element_text(size=18))
    })
    
    #Create leaflet map for zip code mapping
    output$zipPlot2 <- renderLeaflet({
        leaflet(zipcode %>%
                    filter(.,year %in% input$yearChoice_zip, month_full %in% input$monthChoice_zip) %>%
                    group_by(.,zip, longitude, latitude) %>%
                    summarise(.,sum_freq = sum(freq))) %>%
            setView(lng = -112.074036, lat = 33.478376, zoom = 10) %>%
            addProviderTiles(providers$CartoDB.Positron) %>%
            addCircles(lng = ~longitude, lat = ~latitude, weight = 1, radius = ~sum_freq/(length(input$yearChoice_zip)*length(input$monthChoice_zip)/6.5),
                       label = ~as.character(zip), labelOptions(noHide = T, textOnly = T)) %>%
            addCircles(data = police, lng = ~longitude, lat = ~latitude, radius = 300,
                       color= "red", stroke = F, fillOpacity = 1, label = ~PlaceName, labelOptions(noHide = T, textOnly = T)) %>%
            addLegendCustom(.,colors = c("blue","red"), labels = c("crime frequency", "police station"),sizes = c(10, 10),
                            shapes = c("circle","circle"), borders = c("blue","red"))
    })
    
    #Create plotly graph 
    output$zipPlot3 <- renderPlotly({
        crimestat_population %>% 
            filter(.,year %in% input$yearChoice_zip, month_full %in% input$monthChoice_zip) %>%
            group_by(.,zip, population_per_sqmile) %>%
            summarise(.,freq = sum(freq)) %>%
            ggplot() +
            geom_point(aes(x = population_per_sqmile, y = freq/population_per_sqmile, name = zip)) + 
            geom_smooth(aes(x = population_per_sqmile, y = freq/population_per_sqmile)) +
            scale_x_continuous(labels = comma) +
            scale_y_continuous(labels = comma) +
            ggtitle("Population Density vs. Crime Frequency") +
            labs(x = "Population per Square Mile", y = "Number of Crimes per capita") +
            theme_light() +
            theme(legend.position = "none",
                  plot.title = element_text(size=18))
    })
    
    #Create horizontal bar plot for crime category
    output$categoryPlot1 <- renderPlot({
        crimestat %>%
            filter(.,year %in% input$yearChoice_cat, month_full %in% input$monthChoice_cat, zip %in% input$zipChoice_cat) %>%
            group_by(.,crime.cat) %>%
            summarise(.,freq = n()) %>%
            ggplot() +
            geom_bar(aes(x = reorder(crime.cat,freq), y = freq), stat = "identity", fill = "orangered4") +
            coord_flip() +
            ggtitle("Number of Crimes by Category") +
            labs(y = "Number of Crimes") +
            scale_y_continuous(labels = comma) +
            theme(axis.title.y = element_blank(),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.border = element_blank(),
                  panel.background = element_blank(),
                  axis.ticks.x = element_blank(),
                  axis.ticks.y = element_blank(),
                  plot.title = element_text(size=16))
    })
    
    #Create bar plot for crime category
    output$categoryPlot2 <- renderPlot({
        crimestat %>%
            filter(.,year %in% input$yearChoice_cat, month_full %in% input$monthChoice_cat, zip %in% input$zipChoice_cat) %>%
            group_by(.,day, crime.cat) %>%
            summarise(.,freq = n()) %>%
            ggplot() +
            geom_bar(aes(x = day, y = freq, fill = crime.cat), stat = "identity") +
            ggtitle("Number of Crimes by Day of Week") +
            scale_fill_brewer(palette = "YlOrRd") +
            scale_y_continuous(labels = comma) +
            theme(axis.title.x = element_blank(),
                  axis.title.y = element_blank(),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.border = element_blank(),
                  panel.background = element_blank(),
                  axis.ticks.x = element_blank(),
                  axis.ticks.y = element_blank(),
                  plot.title = element_text(size=18))
    })
    
    #Create line graph by crime category
    output$categoryPlot3 <- renderPlot({
        crimestat %>%
            filter(.,year %in% input$yearChoice_cat, month_full %in% input$monthChoice_cat, zip %in% input$zipChoice_cat, time != "00:00") %>%
            group_by(.,hour, crime.cat) %>%
            summarise(.,freq = n()) %>%
            ggplot() +
            geom_line(aes(x = hour, y = freq, group = crime.cat, color = crime.cat), size = 1.2) +
            scale_color_brewer(palette = "Paired") +
            scale_x_continuous(breaks = seq(0,24,6), expand = c(0,0)) +
            scale_y_continuous(labels = comma, expand = c(0,0)) +
            ggtitle("Number of Crimes by Hour and Category") +
            labs(x = "Hour (24 hour format)", y = "Number of Crimes") +
            theme_light() +
            theme(plot.title = element_text(size=18))
    })

    #Create sankey graph
    output$premisePlot1 <- renderSankeyNetwork({
        sankeyNetwork(Links = crimestat_links,
                      Nodes = crimestat_nodes,
                      Source = "IDsource",
                      Target = "IDtarget",
                      Value = "freq",
                      NodeID = "name",
                      fontSize = 10,
                      height = 300)
    })
        
    #Create bar graph by day of week for different premise types
    output$premisePlot2 <- renderPlot({
        crimestat %>%
            filter(.,year %in% input$yearChoice_prem, month_full %in% input$monthChoice_prem, zip %in% input$zipChoice_prem) %>%
            group_by(.,day, premise) %>%
            summarise(.,freq = n()) %>%
            ggplot() +
            geom_bar(aes(x = day, y = freq, fill = premise), stat = "identity") +
            ggtitle("Number of Crimes by Day of Week") +
            scale_fill_brewer(palette = "Spectral") +
            scale_y_continuous(labels = comma) +
            theme(axis.title.x = element_blank(),
                  axis.title.y = element_blank(),
                  panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.border = element_blank(),
                  panel.background = element_blank(),
                  axis.ticks.x = element_blank(),
                  axis.ticks.y = element_blank(),
                  plot.title = element_text(size=18))
    })
    
    #Create line chart with different premise
    output$premisePlot3 <- renderPlot({
        crimestat %>%
            filter(.,year %in% input$yearChoice_prem, month_full %in% input$monthChoice_prem, zip %in% input$zipChoice_prem, time != "00:00") %>%
            group_by(.,hour, premise) %>%
            summarise(.,freq = n()) %>%
            ggplot() +
            geom_line(aes(x = hour, y = freq, group = premise, color = premise), size = 1.2) +
            scale_color_brewer(palette = "Paired") +
            scale_x_continuous(breaks = seq(0,24,6), expand = c(0,0)) +
            scale_y_continuous(labels = comma, expand = c(0,0)) +
            ggtitle("Number of Crimes by Hour and Premise") +
            labs(x = "Hour (24 hour format)", y = "Number of Crimes") +
            theme_light() +
            theme(plot.title = element_text(size=18))
    })
    
    #Duration box plot by crime category
    output$durationPlot1 <- renderPlot({
        duration %>% 
            select(., year, month_full, crime.cat, timediff_hrs) %>% 
            filter(., year %in% input$yearChoice_duration, month_full %in% input$monthChoice_duration, crime.cat %in% input$timediff_cat, timediff_hrs > 0) %>%  
            ggplot() +
            geom_histogram(aes(x = timediff_hrs)) +
            scale_x_log10() +
            theme(legend.position = "none",
                  plot.title = element_text(size=18)) +
            ggtitle("Crime Duration by Crime Category") +
            labs(x = "Crime Duration by Hours", y = "Number of Crimes")
    })
    
    #Duration box plot by premise
    output$durationPlot2 <- renderPlot({
        duration %>% 
            select(., year, month_full, premise, timediff_hrs) %>% 
            filter(., year %in% input$yearChoice_duration, month_full %in% input$monthChoice_duration, premise %in% input$timediff_prem, timediff_hrs > 0) %>%  
            ggplot() +
            geom_histogram(aes(x = timediff_hrs)) +
            scale_x_log10() +
            theme(legend.position = "none",
                  plot.title = element_text(size=18)) +
            ggtitle("Crime Duration by Premise") +
            labs(x = "Crime Duration by Hours", y = "Number of Crimes")
    })
    
    #Moon phase bar chart
    output$factorPlot1 <- renderPlot({
        moonphase %>% 
            filter(.,year %in% c(2017, 2018, 2019, 2020)) %>% 
            group_by(.,year, Moon_Phase) %>% 
            summarise(.,freq = n()) %>% 
            ggplot() +
            geom_bar(aes(x = Moon_Phase, y = freq, fill = year), stat = "identity") +
            ggtitle("Number of Crimes by Moon Phase") +
            scale_fill_brewer(palette = "YlOrRd") +
            scale_y_continuous(labels = comma) +
            labs(x = "Moon Phase", y = "Number of Crimes") +
            theme(panel.grid.major = element_blank(),
                  panel.grid.minor = element_blank(),
                  panel.border = element_blank(),
                  panel.background = element_blank(),
                  axis.ticks.x = element_blank(),
                  axis.ticks.y = element_blank(),
                  plot.title = element_text(size=18))
    })
    
    #Temperature vs. crime freq scatterplot
    output$factorPlot2 <- renderPlot({
        crimestat_weather %>% 
            ggplot() +
            geom_point(aes(x = temperature, y = freq, size = 1.2)) +
            geom_smooth(aes(x = temperature, y = freq), method = "lm") +
            scale_x_continuous(labels = comma) +
            scale_y_continuous(labels = comma) +
            ggtitle("Average Temperature by Year-Month vs. Crime Frequency") +
            labs(x = "Average Temperature by Year-Month", y = "Number of Crimes") +
            theme_light() +
            theme(legend.position = "none",
                  plot.title = element_text(size=18))
    })
    
    #unemployment vs. number of crimes line chart comparison
    output$factorPlot3 <- renderPlot({
        crimestat %>% 
            group_by(.,Month_Yr) %>% 
            summarise(.,freq = n(), unemp_rate = first(unemployment_rate)*1000) %>% 
            ggplot() +
            geom_line(aes(x = Month_Yr, y = freq, group = 1, color = "Number of Crimes"), size = 1.2) +
            geom_line(aes(x = Month_Yr, y = unemp_rate, group = 1, color = "Unemployment Rate"), size = 1.2) +
            labs(color = "") +
            scale_color_manual(values = c("Number of Crimes" = "orange", "Unemployment Rate" = "blue")) +
            scale_x_discrete(breaks = c("2016-01", "2016-07", "2017-01", "2017-07", "2018-01", "2018-07", "2019-01", "2019-07", "2020-01", "2020-07", "2021-01")) +
            scale_y_continuous(
                name = "Number of Crimes",
                labels = comma,
                sec.axis = sec_axis(~./1000, name="Unemployment Rate (%)")
            ) +
            ggtitle("Number of Crimes vs. Unemployment Rate") +
            theme_light() +
            theme(legend.position = c(0.85,0.2),
                  plot.title = element_text(size=18))
    })
    
    #Data tables
    
    output$crimestat_orig <- DT::renderDataTable({
        datatable(crimestat_orig, rownames = F)
    })
    
    output$zipcode_orig <- DT::renderDataTable({
        datatable(zipcode_orig, rownames = F)
    })
    
    output$police_orig <- DT::renderDataTable({
        datatable(police, rownames = F)
    })
    
    output$moonphase_orig <- DT::renderDataTable({
        datatable(moonphase_orig, rownames = F)
    })
    
    output$population_orig <- DT::renderDataTable({
        datatable(population_orig, rownames = F)
    })
    
    output$premisemapping_orig <- DT::renderDataTable({
        datatable(premise_mapping, rownames = F)
    })
    
})
