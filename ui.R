library(shiny)
library(datasets)
# Use AirPassengers dataset from the R datasets
data(AirPassengers)

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(theme = "bootstrap.css",    
    
    # Give the page a title
    titlePanel(h1("Visual Exploration of the AirPassengers Dataset", align = "center")), br(),br(),
    
    # Generate a row with a sidebar
    fluidRow(column(11,
      sidebarLayout(      
        
        # Define the sidebar with one input
        sidebarPanel(
          selectInput("plottype", "Select plot:", 
                      choices=c("histogram","boxplot","trend", "seasonal","forecast")),
          conditionalPanel(
            condition = "input.plottype == 'histogram'",
              sliderInput("breakCount", "Break Count", min=1, max=60, value=15)
          ) 
        ),
      
      # Create a spot for the barplot
      mainPanel(div(
        plotOutput("typePlot") 
      )))),
      column(11, h3('AirPassangers Dataset', align = 'center')),  
    column(11, dataTableOutput('table')))
  )
)