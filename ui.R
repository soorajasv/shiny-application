
library(shiny)
library(leaflet)


r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fluidPage( 
includeCSS("style.css"),

  leafletOutput("mymap"),
  p(),
  h1(class = "white","INTERACTIVE VISUALISATION"),
 
  
 
  
  # Give the page a title
  titlePanel(h3(class = "white","Coral type")),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("region", "Region:", 
                  choices=unique(data$type)),
      
      radioButtons("graphselect","Select your visual", c("bar graph" = "bar", "plot graph" = "plot"), inline=T),
      
      checkboxInput("smoother", "Do you want to see the trend?", FALSE),
      verbatimTextOutput("value")
    ,
      
      hr(),
      helpText("Choose any coral type to see the stats")
    ),
    
    
    
    # Create a spot for the barplot
    mainPanel(
      h4(textOutput("coral")),
      plotOutput("phonePlot")  
    )
    
  )
  
  
  
)


