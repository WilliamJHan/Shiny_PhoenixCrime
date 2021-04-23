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
                fluidRow(column(3,
                                pickerInput(
                                  "zipChoice_overview",
                                  label = "Zip Code(s):",
                                  choices = unique(crimestat$zip),
                                  selected = unique(crimestat$zip),
                                  options = list('actions-box' = TRUE),
                                  multiple = T
                                  )
                                ),
                          column(3,
                                 pickerInput(
                                   "CatChoice_overview",
                                   label = "Crime Category(-ies):",
                                   choices = unique(crimestat$crime.cat),
                                   selected = unique(crimestat$crime.cat),
                                   options = list('actions-box' = TRUE),
                                   multiple = T
                                   )
                                 ),
                           column(3,
                                  pickerInput(
                                    "PremChoice_overview",
                                    label = "Premise Type(s):",
                                    choices = unique(crimestat$premise),
                                    selected = unique(crimestat$premise),
                                    options = list('actions-box' = TRUE),
                                    multiple = T
                                    )
                                  )
                        ),
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
                                        h3("Desired Year and Month:"),
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
                                            column(12, plotlyOutput("zipPlot3"))
                                            )

                                        )
                                    )
                                ),
                       tabPanel(title = "Crime Category", fluid = TRUE,
                                sidebarLayout(
                                    sidebarPanel(
                                        h2("View by Crime Category"),
                                        h3("Desired Year, Month, and Zip:"),
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
                                                 ),
                                        fluidRow(
                                          column(12,
                                                 pickerInput("zipChoice_cat",
                                                             label = "Zip Code(s):",
                                                             choices = unique(crimestat_population$zip),
                                                             selected = unique(crimestat_population$zip),
                                                             options = list('actions-box' = TRUE),
                                                             multiple = T
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
                                        h3("Desired Year, Month, and Zip:"),
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
                                                 ),
                                        fluidRow(column(12,
                                                        pickerInput(
                                                             "zipChoice_prem",
                                                             label = "Zip Code(s):",
                                                             choices = unique(crimestat_population$zip),
                                                             selected = unique(crimestat_population$zip),
                                                             options = list('actions-box' = TRUE),
                                                             multiple = T
                                                             )
                                                        )
                                                 ),
                                        fluidRow(column(12, h5("*Note that SankeyNetwork graph will not update with the toggles above.")))
                                        ),
                                    mainPanel(
                                        fluidRow(
                                            column(6, sankeyNetworkOutput("premisePlot1", height = 420)),
                                            column(6, plotOutput("premisePlot2"))
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
                                        h3("Desired Year, Month, Category, and Premise:"),
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
                                                 ),
                                        fluidRow(
                                          column(12,
                                                 selectInput("timediff_cat",
                                                             label = "Select a crime category:",
                                                             choices = unique(duration$crime.cat),
                                                             selected = "LARCENY-THEFT"
                                                             )
                                                 )
                                          ),
                                        fluidRow(
                                          column(12,
                                                 selectInput("timediff_prem",
                                                             label = "Select a premise:",
                                                             choices = unique(duration$premise),
                                                             selected = "House"
                                                             )
                                                 )
                                          )
                                        ),
                                    mainPanel(
                                        fluidRow(
                                            column(12, plotOutput("durationPlot1"))
                                            ),
                                        fluidRow(
                                            column(12, plotOutput("durationPlot2"))
                                            )
                                        )
                                    )
                                )
                       ),
            tabPanel(
                title = "Interesting Facts",
                icon = icon("clipboard"),
                fluidRow(column(width = 3, 
                                h2(p("Interesting Facts")),
                                h4(p("A couple of other interesting factors (moon phase, average temperature, and unemployment rate) were tested to see if there were any relationships to the crime frequency.")),
                                h4(p("Moon phase data just takes the exact dates of the moon phases, not the dates that surround them. Not much correlation was observed.")),
                                h4(p("Average temperature by number of crimes shows how the number of crimes trends downward as temperature increases.")),
                                h4(p("Unemployment rate by number of crimes was interesting as unemployment rate decreased, the crime rate increased, which is counter intuitive."))),
                         column(width = 4, plotOutput("factorPlot1")),
                         column(width = 5, plotOutput("factorPlot2"))),
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
                           h5(p("I am currently an Associate of Society of Actuaries (ASA) working in Medicaid Consulting and a NYC Data Science Academy student. I graduated from University of Southern California (USC) in '17 with a Bachelor's degree in Applied and Computation Mathematics. I am very interested in pulling actionable insights from complex datasets and love traveling.")),
                           br(),
                           h4(p("About the Project")),
                           h5(p("This project is intended to provide more insight into frequencies of various crimes in Phoenix, AZ based on zip code, crime category, premise type, etc. It will help the police place the officers on duty more efficiently (although there are many more factors to reduce serious crime in the city than from the data). Prospective home buyers will also be able to use this to get some insights on crime rate in the vacinity of properties of interest.\n")),
                           h5(p("I hope you find the project interesting and/or useful. If you have any comments or questions, please reach out to me via william.jeongwoo.han@gmail.com or", a("LinkedIn", href = "https://www.linkedin.com/in/williamjeongwoohan/"), ".\n")),
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

