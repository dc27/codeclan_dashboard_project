library(tidyverse)
library(leaflet)
library(rgdal)
library(shiny)
library(rmapshaper)
library(sp)
library(sf)
library(shinydashboard)

# load in data
life_expectancy_data <- read_csv("../data/clean_data/life_expectancy_clean.csv")

hb_shapes <- readOGR(
  dsn ="../data/shapefiles/SG_NHS_HealthBoards_2019/",
  layer = "SG_NHS_HealthBoards_2019",
  GDAL1_integer64_policy = TRUE)

crs <- CRS("+proj=longlat +datum=WGS84")

# transform shape data to plot on map
hb_shapes_ll <- hb_shapes %>% 
  rgeos::gSimplify(tol=25, topologyPreserve=TRUE) %>% 
  spTransform(crs)

hb_shapes@polygons <- hb_shapes_ll@polygons
