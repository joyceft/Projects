library(rgeos)
library(sp)
library(rgdal)
library(ggplot2)
library(Amelia)

# load train data
load("../CleanTrain.Rdata")
load("../cv_mse.Rdata")
source("../regionlm.R")

# extra geo_data
# https://www.zillow.com/howto/api/neighborhood-boundaries.htm

# load ca.map
ca.map <- readOGR("../ZillowNeighborhoods-CA.shp",
                  layer = "ZillowNeighborhoods-CA")


# generate featrures for visualization
ca.neighbor.id = unique(ca.map$RegionID)

neighbor.logerror.mean = by(train, train$region_neighbor, function(x){return(mean(x$logerror))})
neighbor.logerror.sd = by(train, train$region_neighbor, function(x){return(sd(x$logerror))})
neighbor.logerror.median = by(train, train$region_neighbor, function(x){return(median(x$logerror))})
neighbor.count = by(train, train$region_neighbor, function(x){return(dim(x)[1])})
neighbor.r2 = as.vector(sapply(cv.mse,
                               FUN = function(x){ifelse(typeof(x)=="list",
                                                         x$glmnet.fit$dev.ratio[which(x$glmnet.fit$lambda == x$lambda.min)], NA)}))
# https://www.rdocumentation.org/packages/glmnet/versions/2.0-10/topics/glmnet

names(neighbor.r2) = names(cv.mse)
neighbor.mse = as.numeric(neighbor.r2[names(neighbor.count)])

# map is not complete
rdif = setdiff(unique(train$region_neighbor), ca.neighbor.id)
missing.map = train[which(train$region_neighbor %in% rdif), ]
data=missing.map[sample(nrow(missing.map), 5000), ]
region37835 = train[which(train$region_neighbor == "37835"), ] # for verify


neighbor.logerror = data.frame(RegionID = names(neighbor.logerror.mean),
                               ave_logerror = as.vector(neighbor.logerror.mean),
                               median_logerror = as.vector(neighbor.logerror.median),
                               sd_logerror = as.vector(neighbor.logerror.sd),
                               num = as.vector(neighbor.count))

ca.map = merge(ca.map, neighbor.logerror, by ="RegionID", all.y=T)

bins <- quantile(train$logerror, seq(0,1,length.out = 10))
bins2 <- quantile(ca.map$sd_logerror, seq(0,1,length.out = 10)^0.1, na.rm = T)

pal <- colorBin("YlOrRd", domain = ca.map$median_logerror, bins = bins)
pal2 <- colorBin("BrBG", domain = ca.map$sd_logerror, bins = bins2)

shinyServer(
  function(input, output) {
    region <- reactive({
      reg = train[which(train$region_neighbor == input$rid), ]
    })

    output$hist <- renderPlot({
      ggplot(region(), aes(x=logerror)) + 
        geom_histogram(aes(y=..density..),      # Histogram with density instead of count on y-axis
                       binwidth=.1,
                       colour="black", fill="white") +
        geom_density(alpha=.2, fill="#FF6666") 
    })
    
    output$missmap <- renderPlot({
      missmap(region())
    })
    
    output$regplot <- renderPlot({
      plot(region.lm(region()))
    })
    
    output$map <- renderLeaflet({
      labels <- sprintf(
        "<strong>%s %s</strong><br/>meidan: %.4f<br/>sd: %.4f<br/>num: %d",
        ca.map$Name, ca.map$RegionID,
        ca.map$median_logerror,
        ca.map$sd_logerror, ca.map$num
      ) %>% lapply(htmltools::HTML)
      
      map <- leaflet(ca.map) 
      map <- setView(map = map, -118, 33.9, 8)
      map <- addTiles(map)
      
      # polygons on number of houses
      map <- addPolygons(map,
                         fillColor = ~pal2(sd_logerror),
                         weight = 2,
                         opacity = 0.8,
                         color = "white",
                         dashArray = "3",
                         fillOpacity = 0.5,
                         highlight = highlightOptions(
                           weight = 5,
                           color = "#666",
                           dashArray = "",
                           fillOpacity = 0.5,
                           bringToFront = TRUE),
                         label = labels,
                         labelOptions = labelOptions(
                           style = list("font-weight" = "normal", padding = "3px 8px"),
                           textsize = "15px",
                           direction = "auto"),
                         group = "sd_logerror") %>%
        addLegend(pal = pal2,
                  values = ~num,
                  opacity = 0.7, title = NULL,
                  position = "bottomright")
      
      # polygons on median_logerror
      map <- addPolygons(map,
                         group = "median_logerror",
                         fillColor = ~pal(median_logerror),
                         weight = 2,
                         opacity = 0.5,
                         color = "white",
                         dashArray = "3",
                         fillOpacity = 0.5,
                         highlight = highlightOptions(
                           weight = 5,
                           color = "#666",
                           dashArray = "",
                           fillOpacity = 0.5,
                           bringToFront = TRUE),
                         label = labels,
                         labelOptions = labelOptions(
                           style = list("font-weight" = "normal", padding = "3px 8px"),
                           textsize = "15px",
                           direction = "auto")) %>%
        addLegend(pal = pal,
                  values = ~median_logerror,
                  opacity = 0.7, title = NULL,
                  position = "bottomright")
      
      map <- addCircleMarkers(map = map,
                              data = region(),
                              lng = ~longitude/10e5,
                              lat=~latitude/10e5,
                              radius = 8,
                              color = "blue",
                              fillOpacity = 0.8,
                              stroke = FALSE)
      
      map <- addLayersControl( map,
                               overlayGroups = c("sd_logerror", "median_logerror"),
                               options = layersControlOptions(collapsed = FALSE))
      map
    })
  }
)