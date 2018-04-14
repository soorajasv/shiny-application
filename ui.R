
library(shiny)
library(leaflet)
library(shinyjs)


r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

ui <- fluidPage( 
  includeCSS("style.css"),
  shinyjs::useShinyjs(),

  leafletOutput("mymap"),
  p(),
  h1(class = "white",align="center","INTERACTIVE VISUALISATION"),
 
  
 
  
  # Give the page a title
  titlePanel(h3(class = "white","Coral type")),
  
  # Generate a row with a sidebar
  sidebarLayout(      
    
    # Define the sidebar with one input
    sidebarPanel(
      selectInput("region", "Choose any coral type to see the stats", 
                  choices=unique(data$type)),
      
      radioButtons("graphselect","Select your visual", c("bar graph" = "bar", "plot graph" = "plot"), inline=T),
      
      checkboxInput("smoother", "Do you want to see the trend?", FALSE),
      verbatimTextOutput("value"),
      hr(),
      h2(checkboxInput("whole", "Do you want to see a whole picture?", FALSE))
      
  
    ),
    
    
    
    # Create a spot for the barplot
    mainPanel(
      h4(textOutput("coral")),
      plotOutput("phonePlot")  
    )
    
  )
  
  
  
)


