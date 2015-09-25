# More info:
#   https://github.com/jcheng5/googleCharts
# Install:
#   devtools::install_github("jcheng5/googleCharts")
library(googleCharts)

# Use global max/min for axes so the view window stays
# constant as the user moves between years
xlim <- list(
  min = min(data$PopPerJudge) - 1000,
  max = max(data$PopPerJudge) + 1000
)
ylim <- list(
  min = min(data$CrLeadtimeInMonths),
  max = max(data$LeadtimeInMonths)+1
)
shinyUI(fluidPage(
  # This line loads the Google Charts JS library
  googleChartsInit(),
  
  # Use the Google webfont "Source Sans Pro"
  tags$link(
    href=paste0("http://fonts.googleapis.com/css?",
                "family=Source+Sans+Pro:300,600,300italic"),
    rel="stylesheet", type="text/css"),
  tags$style(type="text/css",
             "body {font-family: 'Source Sans Pro'}"
  ),
  
  h2("Ohio Courts Statvocate"),
  h5("Instructions: Use controls below to interact with chart.  Hover on bubble to see County Court details, bubble size denotes Pending Cases."),
  h3("Courts of Common Pleas, General Division"),
  h4(textOutput("textAvgLeadTime")),
  
  
  googleBubbleChart("chart",
                    width="100%", height = "475px",
                    # Set the default options for this chart; they can be
                    # overridden in server.R on a per-update basis. See
                    # https://developers.google.com/chart/interactive/docs/gallery/bubblechart
                    # for option documentation.
                    options = list(
                      fontName = "Source Sans Pro",
                      fontSize = 13,
                      # Set axis labels and ranges
                      hAxis = list(
                        title = "County Population Per Judge",
                        viewWindow = xlim
                      ),
                      vAxis = list(
                        title = "Case Lead Time (months)",
                        viewWindow = ylim
                      ),
                      # The default padding is a little too spaced out
                      chartArea = list(
                        top = 50, left = 75,
                        height = "75%", width = "75%"
                      ),
                      # Allow pan/zoom
                      explorer = list(),
                      # Set bubble visual props
                      bubble = list(
                        opacity = 0.4, stroke = "none",
                        # Hide bubble label
                        textStyle = list(
                          color = "none"
                        )
                      ),
                      # Set fonts
                      titleTextStyle = list(
                        fontSize = 16
                      ),
                      tooltip = list(
                        textStyle = list(
                          fontSize = 12
                        )
                      )
                    )
  ),
  fluidRow(
    shiny::column(4,
                  sliderInput("year", "Slide/Animate Year",
                              min = min(data$Year), max = max(data$Year),
                              value = min(data$Year), step = 1, animate = TRUE)),
    shiny::column(4,
                  selectInput(inputId = "caseType", label = "Select Case Type:", choices=c("All","Criminal","Civil"), selected="All")
    ),
    #display only if caseType is not 'All'
    shiny::column(4,
          conditionalPanel(condition = "input.caseType !== 'All'",
                  selectInput(inputId = "pendingType", label = "Select Pending Type:", choices=c("All","Beyond Guidelines"), selected="All")
          )
    )
  ),

  tags$body("By: "),
  tags$a(href="mailto:ojusnaik@hotmail.com", "Ojustwin Naik <ojusnaik@hotmail.com>"),
  br(),
  tags$body("Data Sources: "),
  tags$a(href="http://www.supremecourt.ohio.gov/JCS/casemng/statisticalReporting/","Supreme Court of Ohio Statistical Reporting for Case Statistics"),
  br(),
  tags$body("Visualization based on: "),
  tags$a(href="https://github.com/jcheng5/googleCharts", "Google Charts by Joe Cheng")

))
