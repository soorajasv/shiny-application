library(sqldf)
library(ggplot2)
library(plotly)

server <- function(input, output, session) {
  
  data <- read.csv("E:/dataVisual/SE-R.csv",header=T)
  names(data)[1]<-paste("year")
  data$bleaching = as.numeric(sub("%", "", data$bleaching))
  
  
  
  long <- unique(data$longitude)
  lat <- unique(data$latitude)
  label <- unique(data$site)
  
  
  markers <- data.frame(lat,long,label)
  
  # Aggregate method
  markers <- aggregate(label ~ lat + long, markers, paste, collapse = "<br/>")
  
  # Markers with all of the labels
  
  # icons
  icon.pop <- awesomeIcons(icon = "users",
                           markerColor = ifelse(data$site == 'site01' | data$site == 'site02' , "blue", "red"),
                           library = "fa",
                           iconColor = "black")
  
  
 
  
  
  output$mymap <- renderLeaflet({
        leaflet() %>%
          # addProviderTiles("Stamen.TonerLite",
          #                  options = providerTileOptions(noWrap = TRUE)
          # ) %>%
      
      addTiles() %>% 
      addAwesomeMarkers(lng=markers$long, lat= markers$lat,label= markers$label, icon = icon.pop)
    })
  
  
  bluecorals = sqldf("select * from data where type = 'blue corals'")
  seapens = sqldf("select * from data where type='sea pens'")
  hardcorals = sqldf("select * from data where type='hard corals'")
  softcorals = sqldf("select * from data where type='soft corals'")
  seafans = sqldf("select * from data where type='sea fans'")
  
  
  output$coral <- renderText({ 
    paste("Bleaching of ", input$region)
  })
  
  output$phonePlot <- reactivePlot(function(){
    
    # Render a barplot
    # barplot(WorldPhones[,input$region]*1000, 
    #         main=input$region,
    #         ylab="Number of Telephones",
    #         xlab="Year")
    
    
    if (input$region == "blue corals" ) {
      finaldata = bluecorals
    }
    
    if (input$region == "sea pens") {
            finaldata = seapens
    }
    
    if (input$region == "sea fans") {
            finaldata = seafans
     }
    
    if (input$region == "soft corals") {
      finaldata = softcorals
    }
    
    if (input$region == "hard corals") {
            finaldata = hardcorals
    }
    
    
    if(input$smoother == TRUE){
      
      if(input$graphselect == "plot"){
      
      ggplot(finaldata, aes(x=year, y=bleaching)) + geom_point() + geom_smooth(aes(group = 1),
                                                                               method = "lm",
                                                                               color = "orange",
                                                                               formula = y~ poly(x, 2),
                                                                               se = FALSE) + facet_grid(site ~ .) + ylim(0,100)
      }
      
      
      else
      {
        ggplot(finaldata, aes(year, bleaching)) + geom_bar(aes(fill = type), position = "dodge", stat = "identity") +
          facet_wrap(~site)+geom_smooth()
      }
      
    } 
    else
    {
      if(input$graphselect == "plot"){
        
        ggplot(finaldata, aes(x=year, y=bleaching)) + geom_point() +  facet_grid(site ~ .) + ylim(0,100)
      }
      
      
      else
      {
        ggplot(finaldata, aes(year, bleaching)) + geom_bar(aes(fill = type), position = "dodge", stat = "identity") +
          facet_wrap(~site)
      }

      
    }
    
    
    
    
    })
  
  
  
  
  
}