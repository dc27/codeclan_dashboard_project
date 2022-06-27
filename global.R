library(tidyverse)
library(leaflet)
library(rgdal)
library(shiny)
library(shinyWidgets)
library(rmapshaper)
library(sp)
library(sf)
library(shinydashboard)
library(here)

#Source in cleaning scripts for data sets
#source("/cleaning_scripts/cleaning_life_satisfaction_script.R")

# load in data
life_expectancy_data <- read_csv("data/clean_data/life_expectancy_clean.csv")

life_satisfaction <- read_csv("data/clean_data/life_satisfaction_clean.csv")

alcohol <- read.csv(here("data/clean_data/alcohol_hospital_area.csv"))

drugs <- read.csv(here("data/clean_data/drug_hospital_area.csv"))

scotland_smoking_data <- read_csv("data/clean_data/clean_smoking.csv")


hb_shapes <- readOGR(
  dsn ="data/simpler_shapefiles/NHS_HealthBoards_2019/",
  layer = "NHS_HealthBoards_2019",
  GDAL1_integer64_policy = TRUE)

# crs <- CRS("+proj=longlat +datum=WGS84")
# 
# # transform shape data to plot on map
# hb_shapes_ll <- hb_shapes %>% 
#   rgeos::gSimplify(tol=25, topologyPreserve=TRUE) %>% 
#   spTransform(crs)
# 
# hb_shapes@polygons <- hb_shapes_ll@polygons