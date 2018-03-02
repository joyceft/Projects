library(shiny)
library(leaflet)

load("../CleanTrain.Rdata")

shinyUI(bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE,
                draggable = TRUE, top = 60, left = 20, right = "auto", bottom = "auto",
                width = 600, height = "auto",
                selectInput("rid", "RegionID", sort(unique(train$region_neighbor))),
                plotOutput("hist", height = 200),
                plotOutput("regplot", height = 200),
                plotOutput("missmap", height = 400)
  )
)
)

# https://rstudio.github.io/leaflet/shiny.html leaflet with shiny
# https://shiny.rstudio.com/tutorial/written-tutorial/lesson1/ shiny tutorial