# all SIMD quintiles
life_expectancy_data_all_SIMD <- life_expectancy_data %>% 
  filter(simd_quintiles == "All") %>% 
  # ignore CIs
  filter(measurement == "Count") %>% 
  # only interested in health boards
  filter(str_detect(feature_code, "^S0")) %>% 
  arrange(feature_code)

create_hb_map <- function(measurement_df, sex) {
  # measurement_df is calculated in the server - determined by user inputs
  # bind to shape data
  
  hb_shapes <- hb_shapes %>% 
    left_join(measurement_df, by = c("HBCode" = "feature_code"))
  
 
  # pretty labels
  labels <- sprintf("<strong>%s</strong><br/>%g years",
                    hb_shapes$HBName, hb_shapes$value) %>%
    lapply(htmltools::HTML)
  
  if (sex() == "Male") {
    colour_age_range = c(70,84)
  }
  else if(sex() == "Female") {
    colour_age_range = c(74,88)
  }
  
  
  pal <- colorNumeric(
    palette = "Purples",
    domain = colour_age_range,
    reverse = TRUE
  )
  

    
    
  leaflet(hb_shapes, options = leafletOptions(minZoom = 6)) %>%
    setView(lng = -4, lat = 57.5, zoom = 6) %>%
    # restrict view to around Scotland
    setMaxBounds(lng1 = -1,
                 lat1 = 54,
                 lng2 = -9,
                 lat2 = 63) %>% 
    addProviderTiles(providers$CartoDB.PositronNoLabels) %>% 
    addPolygons(fillOpacity = 1, weight = 0.5,
                color = "white",
                fillColor = ~pal(value),
                label = labels,
                highlightOptions = highlightOptions(
                  color = "white", weight = 1,
                  opacity = 0.9, bringToFront = TRUE)) %>%
    addLegend("bottomright", pal = pal, values = ~value,
              title = "Life Expectancy<br>(Years)",
              opacity = 1
    )
  
}