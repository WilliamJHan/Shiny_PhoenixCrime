shinyUI(
    fluidPage(
        navbarPage(
            title = "Phoenix Crime Frequency Analysis",
            theme = shinytheme("journal"),
            id = "main",
            tabPanel(
                title = "Overview",
                icon = icon("glasses"),
                fluid = TRUE,
                #This puts the tabs to be right-aligned
                shinyjs::useShinyjs(),
                h2("Crime Frequency in Phoenix\n"),
                h4("Total number of crimes by year & month limited to city of Phoenix, not the entire valley."),
                hr(), br(),
                fluidRow(
                    column(width = 9, plotOutput("overviewPlot1", height = 450)),
                    column(width = 3, valueBox(prettyNum(65109,big.mark = ","), "Avg. Number of Crimes per Year", icon = icon("balance-scale"))),
                    column(width = 3, valueBox(prettyNum(1733630,big.mark = ","), "Population of Phoenix (2021)", icon = icon("users"))),
                    column(width = 3, valueBox(prettyNum(3000,big.mark = ","), "Number of Officers", icon = icon("user")))
                    )
                ),
            navbarMenu(title = "By Factor",
                       icon = icon("chart-bar"),
                       tabPanel(title = "Zip Code", fluid = TRUE,
                                sidebarLayout(
                                    sidebarPanel(
                                        h2("View by Zip Code"),
                                        titlePanel("Desired Year and Month"),
                                        helpText("2015 & 2021 not shown as data is incomplete in those years."),
                                        fluidRow(column(3,
                                                        radioButtons(
                                                            "yearChoice_zip",
                                                            label = "Year(s):",
                                                            choices = c("2016" = 2016, "2017" = 2017, "2018" = 2018, "2019" = 2019, "2020" = 2020),
                                                            selected = 2016
                                                            )
                                                        ),
                                                 column(6,
                                                        offset = 2,
                                                        checkboxGroupInput(
                                                            "monthChoice_zip",
                                                            label = "Month(s):",
                                                            choices = c("January" = "January", "February" = "February", "March" = "March", "April" = "April", "May" = "May", "June" = "June", "July" = "July", "August" = "August", "September" = "September", "October" = "October", "November" = "November", "December" = "December"),
                                                            selected = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
                                                            )
                                                        )
                                                 )
                                        ),
                                    mainPanel(
                                        fluidRow(
                                            column(6, plotOutput("zipPlot1")),
                                            column(6, leafletOutput("zipPlot2"))                                            
                                            ),
                                        fluidRow(
                                            column(12, plotOutput("zipPlot3"))
                                            )

                                        )
                                    )
                                ),
                       tabPanel(title = "Crime Category", fluid = TRUE,
                                sidebarLayout(
                                    sidebarPanel(
                                        h2("View by Crime Category"),
                                        titlePanel("Desired Year and Month"),
                                        helpText("2015 & 2021 not shown as data is incomplete in those years."),
                                        fluidRow(column(3,
                                                        radioButtons(
                                                            "yearChoice_cat",
                                                            label = "Year(s):",
                                                            choices = c("2016" = 2016, "2017" = 2017, "2018" = 2018, "2019" = 2019, "2020" = 2020),
                                                            selected = 2016
                                                            )
                                                        ),
                                                 column(6,
                                                        offset = 2,
                                                        checkboxGroupInput(
                                                            "monthChoice_cat",
                                                            label = "Month(s):",
                                                            choices = c("January" = "January", "February" = "February", "March" = "March", "April" = "April", "May" = "May", "June" = "June", "July" = "July", "August" = "August", "September" = "September", "October" = "October", "November" = "November", "December" = "December"),
                                                            selected = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
                                                            )
                                                        )
                                                 )
                                        ),
                                    mainPanel(
                                        fluidRow(
                                            column(6, plotOutput("categoryPlot1")),
                                            column(6, plotOutput("categoryPlot2"))
                                            ),
                                        fluidRow(
                                            column(12, plotOutput("categoryPlot3"))
                                            )
                                        )
                                    )
                                ),
                       tabPanel(title = "Premise Type", fluid = TRUE,
                                sidebarLayout(
                                    sidebarPanel(
                                        h2("View by Premise Type"),
                                        titlePanel("Desired Year and Month"),
                                        helpText("2015 & 2021 not shown as data is incomplete in those years."),
                                        fluidRow(column(3,
                                                        radioButtons(
                                                            "yearChoice_prem",
                                                            label = "Year(s):",
                                                            choices = c("2016" = 2016, "2017" = 2017, "2018" = 2018, "2019" = 2019, "2020" = 2020),
                                                            selected = 2016
                                                            )
                                                        ),
                                                 column(6,
                                                        offset = 2,
                                                        checkboxGroupInput(
                                                            "monthChoice_prem",
                                                            label = "Month(s):",
                                                            choices = c("January" = "January", "February" = "February", "March" = "March", "April" = "April", "May" = "May", "June" = "June", "July" = "July", "August" = "August", "September" = "September", "October" = "October", "November" = "November", "December" = "December"),
                                                            selected = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
                                                            )
                                                        )
                                                 )
                                        ),
                                    mainPanel(
                                        fluidRow(
                                            column(6, plotOutput("premisePlot1")),
                                            column(6, sankeyNetworkOutput("premisePlot2", height = 420))
                                            ),
                                        fluidRow(
                                            column(12, plotOutput("premisePlot3"))
                                            )
                                        )
                                    )
                                ),
                       tabPanel(title = "Crime Duration", fluid = TRUE,
                                sidebarLayout(
                                    sidebarPanel(
                                        h2("View by Crime Duration"),
                                        titlePanel("Desired Year and Month"),
                                        helpText("2015 & 2021 not shown as data is incomplete in those years."),
                                        fluidRow(column(3,
                                                        radioButtons(
                                                            "yearChoice_duration",
                                                            label = "Year(s):",
                                                            choices = c("2016" = 2016, "2017" = 2017, "2018" = 2018, "2019" = 2019, "2020" = 2020),
                                                            selected = 2016
                                                            )
                                                        ),
                                                 column(6,
                                                        offset = 2,
                                                        checkboxGroupInput(
                                                            "monthChoice_duration",
                                                            label = "Month(s):",
                                                            choices = c("January" = "January", "February" = "February", "March" = "March", "April" = "April", "May" = "May", "June" = "June", "July" = "July", "August" = "August", "September" = "September", "October" = "October", "November" = "November", "December" = "December"),
                                                            selected = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
                                                            )
                                                        )
                                                 )
                                        ),
                                    mainPanel(
                                        fluidRow(
                                            column(6, plotOutput("durationPlot1")),
                                            column(6, plotOutput("durationPlot2"))
                                            ),
                                        fluidRow(
                                            column(12, plotOutput("durationPlot3"))
                                            )
                                        )
                                    )
                                )
                       ),
            tabPanel(
                title = "Interesting Facts",
                icon = icon("clipboard"),
                fluidRow(column(width = 4, plotOutput("factorPlot1")),
                         column(width = 7, plotOutput("factorPlot2"))),
                fluidRow(column(width = 12, plotOutput("factorPlot3")))
            ),
            navbarMenu(title = "Data",
                       icon = icon("database"),
                       tabPanel(title = "Crime Stats", DT::dataTableOutput("crimestat_orig")),
                       tabPanel(title = "Zip Code", DT::dataTableOutput("zipcode_orig")),
                       tabPanel(title = "Police Station", DT::dataTableOutput("police_orig")),
                       tabPanel(title = "Moon Phase", DT::dataTableOutput("moonphase_orig")),
                       tabPanel(title = "Population", DT::dataTableOutput("population_orig")),
                       tabPanel(title = "Premise Mapping", DT::dataTableOutput("premisemapping_orig"))
                       ),
            tabPanel(
                title = "About",
                icon = icon("address-book"),
                fluidRow(
                    column(8,
                           HTML('<img src = "Will_Han.jpg", height = "150px">'),
                           h3(p("William Jeongwoo Han")),
                           h5(p("william.jeongwoo.han@gmail.com")),
                           hr(),
                           h4(p("About the Author")),
                           h5(p("I am currently an Associate of Society of Actuaries (ASA) working in Medicaid Consulting and a NYC Data Science Academy student. I graduated from University of Southern California (USC) in '17 with a Bachelor's degree in Applied and Computation Mathematics. I am very interested in pulling actionable insights from complex dataset and love traveling.")),
                           br(),
                           h4(p("About the Project")),
                           h5(p("This project is intended to provide more insight into frequencies of various crimes in Phoenix, AZ based on zip code, crime category, premise type, etc. It will help the police place the officers on duty more efficiently (although there are many more factors to reduce serious crime in the city than from the data). Prospective home buyers will also be able to use this to get some insights on crime rate in the vacinity of properties of interest.\n")),
                           h5(p("I hope you find the project interesting and/or useful. Any comments or questions are welcome at william.jeongwoo.han@gmail.com\n")),
                           h5(p("The source code for this Shiny app is available on ", a("github", href = "https://github.com/WilliamJHan/Shiny_PhoenixCrime"),".")),
                           br(),
                           h4(p("Sources\n")),
                           h5(p("Crime stat & police station data from: ", a("City of Phoenix Open Data", href = "https://www.phoenixopendata.com/dataset"))),
                           h5(p("Phoenix zip code data from: ", a("Phoenix areaConnect", href = "https://phoenix.areaconnect.com/zip2.htm"))),
                           h5(p("Moon phase calendar data from: ", a("Vertex42", href = "https://www.vertex42.com/calendars/moon-phase-calendar.html"))),
                           h5(p("Population by Zip code data from: ", a("Zipatlas", href = "http://zipatlas.com/us/az/phoenix/zip-code-comparison/population-density.htm"))),
                           h5(p("Weather data from: ", a("National Weather Service Forecast Office", href = "https://w2.weather.gov/climate/xmacis.php?wfo=psr"))),
                           br(),
                           h5("Built with",
                              img(src = "https://www.rstudio.com/wp-content/uploads/2014/04/shiny.png", height = "20px"),
                              "by",
                              img(src = "https://www.rstudio.com/wp-content/uploads/2014/07/RStudio-Logo-Blue-Gray.png", height = "20px"),
                              ".")
                    )
                )
            )
        )
    )
)

