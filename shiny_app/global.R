library(tidyverse)
library(leaflet)
library(rgdal)
library(shiny)

# load in data
life_expectancy_data <- read_csv("../data/clean_data/life_expectancy_clean.csv")

hb_shapes <- readOGR(
  dsn ="../data/shapefiles/SG_NHS_HealthBoards_2019/",
  layer = "SG_NHS_HealthBoards_2019",
  GDAL1_integer64_policy = TRUE)

# transform shape data to plot on map
hb_shapes_ll <- spTransform(hb_shapes, CRS("+proj=longlat +datum=WGS84"))