library(dplyr)

shinyServer(function(input, output, session) {
  
  # Provide explicit colors for regions, so they don't get recoded when the
  # different series happen to be ordered differently from year to year.
  # http://andrewgelman.com/2014/09/11/mysterious-shiny-things/
  #, "#0099c6", "#dd4477"
  defaultColors <- c("#3366cc", "#dc3912", "#ff9900", "#109618", "#990099")
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = levels(data$Region)
   )
  
  yearData <- reactive({
    # Filter to the desired year, and put the columns
    # in the order that Google's Bubble Chart expects
    # them (name, x, y, color, size). Also sort by region
    # so that Google Charts orders and colors the regions
    # consistently.

    if(input$caseType == "All"){
      df <- data %.%
        filter(Year == input$year) %.%
        select(County, PopPerJudge, LeadtimeInMonths,
               Region, TotPendingDec) %.%
        arrange(Region)  
    }
    else if(input$caseType == "Criminal"){

      if(input$pendingType == "Beyond Guidelines"){
        df <- data %.%
          filter(Year == input$year) %.%
          select(County, PopPerJudge, CrLeadtimeInMonths,
                 Region, CrPendingBeyondGuide) %.%
          arrange(Region)          
      }
      else {
        df <- data %.%
          filter(Year == input$year) %.%
          select(County, PopPerJudge, CrLeadtimeInMonths,
                 Region, CrPendingDec) %.%
          arrange(Region) 
      }
    }
    else if(input$caseType == "Civil"){
      
      if(input$pendingType == "Beyond Guidelines"){
      df <- data %.%
        filter(Year == input$year) %.%
        select(County, PopPerJudge, CivLeadtimeInMonths,
               Region, CivPendingBeyondGuide) %.%
        arrange(Region)
      }
      else {
        df <- data %.%
          filter(Year == input$year) %.%
          select(County, PopPerJudge, CivLeadtimeInMonths,
                 Region, CivPendingDec) %.%
          arrange(Region)        
      }
    }
  })
  
  output$chart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(yearData()),
      options = list(
        title = sprintf("Ohio Common Pleas Courts Case Lead Time",input$year),
        series = series
      )
    )
  })
  
  
  output$textAvgLeadTime <- renderText({
    
    if(input$caseType == "All"){
      paste(input$year, " Case Lead Time (months): ", "Mean ", round(mean(yearData()$LeadtimeInMonths),3), ", Variance", round(var(yearData()$LeadtimeInMonths),3))
    }
    else if(input$caseType == "Criminal"){
      paste(input$year, " Criminal Case Lead Time (months): ", "Mean ", round(mean(yearData()$CrLeadtimeInMonths),3), ", Variance", round(var(yearData()$CrLeadtimeInMonths),3))
    }
    else if(input$caseType == "Civil"){
      paste(input$year, " Civil Case Lead Time (months): ", "Mean ", round(mean(yearData()$CivLeadtimeInMonths),3), ", Variance", round(var(yearData()$CivLeadtimeInMonths),3))
    }
  })
  
})