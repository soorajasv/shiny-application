
data <- read.csv("E:/dataVisual/SE-R.csv",header=T)

install.packages("sqldf")
library(sqldf)


# Make sample dataframe
long <- unique(data$longitude)
lat <- unique(data$latitude)
label <- unique(data$site)
  
  # c("site1","site2","site3","site4","site5","site6","site7","site8")

markers <- data.frame(lat,long,label)

# Aggregate method
  markers <- aggregate(label ~ lat + long, markers, paste, collapse = "<br/>")

  
  
  
  #text code

  icon.pop <- awesomeIcons(icon = "users",
                           markerColor = ifelse(data$site == 'site01' | data$site == 'site02' , "blue", "red"),
                           library = "fa",
                           iconColor = "black")
  
  
  
  
  #test code  
  
  
  
  
# Markers with all of the labels
leaflet() %>%
  addTiles() %>%  
  addAwesomeMarkers(lng=markers$long, lat= markers$lat,label= markers$label,icon = icon.pop
  )

View(data)
View(label)

library(leaflet)



leaflet(data = data) %>% addTiles() %>%
  addMarkers(
    ~longitude, 
    ~latitude, 
    popup = ~as.character(site),
    clusterOptions = markerClusterOptions()
  )




x = gsub(" ", "", "hard corals", fixed = TRUE)










