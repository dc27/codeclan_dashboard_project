library(tidyverse)
library(leaflet)
library(rgdal)

# load in data
life_expectancy_data <- read_csv("../data/clean_data/life_expectancy_clean.csv")

hb_shapes <- readOGR(
  dsn ="../data/shapefiles/SG_NHS_HealthBoards_2019/",
  layer = "SG_NHS_HealthBoards_2019",
  GDAL1_integer64_policy = TRUE)

# transform shape data to plot on map
hb_shapes_ll <- spTransform(hb_shapes, CRS("+proj=longlat +datum=WGS84"))


# all SIMD quintiles
life_expectancy_data_all_SIMD <- life_expectancy_data %>% 
  filter(simd_quintiles == "All") %>% 
  # ignore CIs
  filter(measurement == "Count") %>% 
  # only interested in health boards
  filter(str_detect(feature_code, "^S0"))

create_hb_map <- function(measurement_df) {
  # measurement_df is calculated in the server - determined by user inputs
  # bind to shape data
  hb_shapes_ll@data <- hb_shapes_ll@data %>% 
    cbind(measurement_df)
  
  # pretty labels
  labels <- sprintf("<strong>%s</strong><br/>%g",
                    hb_shapes_ll$HBName, hb_shapes_ll$value) %>%
    lapply(htmltools::HTML)
  
  # plot
  leaflet(options = leafletOptions(minZoom = 6)) %>%
    setView(lng = -5, lat = 57.35, zoom = 6) %>%
    # restrict view to around Scotland
    setMaxBounds(lng1 = -1,
                 lat1 = 50,
                 lng2 = -9,
                 lat2 = 64) %>% 
    # load in basemap
    addProviderTiles(providers$CartoDB.PositronNoLabels) %>% 
    # add Health Board polygons, colour based on LE, highlight on hover
    addPolygons(data = hb_shapes_ll, color = "white",
                fillColor = ~colorQuantile(
                  "YlOrRd", -hb_shapes_ll$value
                ) (-hb_shapes_ll$value),
                weight = 1, fillOpacity = 0.9, label = labels,
                highlightOptions = highlightOptions(
                  color = "white", weight = 2,
                  opacity = 0.9, bringToFront = TRUE))
}