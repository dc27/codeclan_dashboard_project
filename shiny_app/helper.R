library(tidyverse)
library(leaflet)
library(rgdal)

# load in data
life_expectancy_data <- read_csv("../data/raw_data/life_expectancy.csv")

hb_shapes <- readOGR(
  dsn ="../data/shapefiles/SG_NHS_HealthBoards_2019/",
  layer = "SG_NHS_HealthBoards_2019",
  GDAL1_integer64_policy = TRUE)

# transform shape data to plot on map
hb_shapes_ll <- spTransform(hb_shapes, CRS("+proj=longlat +datum=WGS84"))

# filter data to desired form:
# clean_names,
# date - after 2009
# all SIMD quintiles
life_expectancy_data_all_SIMD <- life_expectancy_data %>% 
  janitor::clean_names() %>% 
  mutate(date_code = as.ordered(date_code)) %>% 
  arrange(date_code) %>% 
  filter(date_code > "2006-2008") %>% 
  filter(urban_rural_classification == "All") %>% 
  filter(age == "0 years") %>% 
  filter(simd_quintiles == "All") %>% 
  # ignore CIs
  filter(measurement == "Count") %>% 
  # only interested in health boards
  filter(str_detect(feature_code, "^S0"))

create_hb_map <- function(measurement_df) {
  # measurement_df is the LE df filtered by user inputs
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