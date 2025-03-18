library(tidyverse)
library(leaflet)
library(shiny)
library(shinyWidgets)
library(sf)
library(shinydashboard)
library(here)

#Source in cleaning scripts for data sets
#source("/cleaning_scripts/cleaning_life_satisfaction_script.R")

# load in data
life_expectancy_data <- read_csv("data/clean_data/life_expectancy_clean.csv")

life_satisfaction <- read_csv("data/clean_data/life_satisfaction_clean.csv")

alcohol <- read_csv(here("data/clean_data/alcohol_hospital_area.csv"))

drugs <- read_csv(here("data/clean_data/drug_hospital_area.csv"))

scotland_smoking_data <- read_csv("data/clean_data/clean_smoking.csv")


hb_shapes <- sf::st_read(
  dsn ="data/simpler_shapefiles/NHS_HealthBoards_2019/",
  layer = "NHS_HealthBoards_2019",
  crs = "(+proj=tmerc +lat_0=49 +lon_0=-2 +k=0.9996012717 +x_0=400000 +y_0=-100000 +ellps=airy +units=m +no_defs"
  )


theme_set(theme_bw(base_size = 20))