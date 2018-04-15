library(sqldf)
library(ggplot2)
library(plotly)
library(leaflet)

server <- function(input, output, session) {

  mydata <- read.csv("SE-R.csv",header=T)
  names(mydata)[1]<-paste("year")
  mydata$bleaching = as.numeric(sub("%", "", mydata$bleaching))
  
  #loading data frames for mapping
  
  long <- unique(mydata$longitude)
  lat <- unique(mydata$latitude)
  label <- unique(mydata$site)
  
  
  markers <- data.frame(lat,long,label)
  
  # Aggregate method for making labels
  markers <- aggregate(label ~ lat + long, markers, paste, collapse = "<br/>")

  
  # icons
   icons <- awesomeIcons(
    icon = 'close',
    iconColor = 'black',
    library = 'ion',
    markerColor = 'red'
  )
  
  #Add map to the UI element 
  output$mymap <- renderLeaflet({
        leaflet() %>%
          # addProviderTiles("Stamen.TonerLite",
          #                  options = providerTileOptions(noWrap = TRUE)
          # ) %>%
      
      addTiles() %>% 
      addAwesomeMarkers(lng=markers$long, lat= markers$lat,label= markers$label, icon = icons)
    })
  
  #Assign seperate datasets to each coral to visualize data easily
  bluecorals = sqldf("select * from mydata where type = 'blue corals'")
  seapens = sqldf("select * from mydata where type='sea pens'")
  hardcorals = sqldf("select * from mydata where type='hard corals'")
  softcorals = sqldf("select * from mydata where type='soft corals'")
  seafans = sqldf("select * from mydata where type='sea fans'")
  
  
 
  # Add required graph based on the user selection to the UI element
  output$graph <- reactivePlot(function(){
    
  #Logical condition to assign graph required from based on drop downlist selection
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
  
    # Sorting the sites according to the latitude
    finaldata$site_order = factor(finaldata$site, levels=c('site06','site01','site05','site02','site08','site03','site07','site04'))
    mydata$site_order = factor(mydata$site, levels=c('site06','site01','site05','site02','site08','site03','site07','site04'))
    
    
    if(input$whole == TRUE){
      
      #If user click whole graph option ,there is no need of having dropdown(Thats why I am disabling the dropdownlist)
      shinyjs::disable("region")
      shinyjs::disable("graphselect")
      
      output$coral <- renderText({ 
        paste("Coral Bleaching ")
      })
      
      #Imclude geom_smooth for the graphs if user wants to see the trend 
      if(input$smoother == TRUE)
      {
        ggplot(mydata, aes(year, bleaching)) + geom_bar(aes(fill = type), position = "dodge", stat = "identity") +
          facet_wrap(~site_order)+geom_smooth()
      }
      else
      {
        ggplot(mydata, aes(year, bleaching)) + geom_bar(aes(fill = type), position = "dodge", stat = "identity") +
          facet_wrap(~site_order)
      }
      
    }
    
    else
    {
      
      shinyjs::enable("region")
      shinyjs::enable("graphselect")
      
      #Changing the selected coral type dynamically
      output$coral <- renderText({ 
        paste("Bleaching of ", input$region)
      })
      
    #If user selects trend, this below code gives plot graph  
    if(input$smoother == TRUE){
      if(input$graphselect == "plot"){
      
      ggplot(finaldata, aes(x=year, y=bleaching)) + geom_point() + geom_smooth(aes(group = 1),
                                                                               method = "lm",
                                                                               color = "red",
                                                                               formula = y~ poly(x, 2),
                                                                               se = FALSE) + facet_grid(site_order ~ .) + ylim(0,100)


       }
      
      
      else
      {
        ggplot(finaldata, aes(year, bleaching)) + geom_bar(aes(fill = type),color = "red", position = "dodge", stat = "identity") +
          facet_wrap(~site_order)+geom_smooth()
      }
      
    } 
    else
    {
      if(input$graphselect == "plot"){
        
        ggplot(finaldata, aes(x=year, y=bleaching)) + geom_point() +  facet_grid(site_order ~ .) + ylim(0,100)
      }
      
      
      else
      {
        ggplot(finaldata, aes(year, bleaching)) + geom_bar(aes(fill = type), position = "dodge", stat = "identity") +
          facet_wrap(~site_order)
      }
    }
    }
    })
  
  
  
  
  
}