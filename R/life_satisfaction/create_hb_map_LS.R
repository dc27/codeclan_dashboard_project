create_hb_map_LS <- function(measurement_df, sex) {
  # measurement_df is calculated in the server - determined by user inputs
  # bind to shape data
  hb_shapes <- hb_shapes %>% 
    left_join(measurement_df, by = c("HBCode" = "feature_code"))
  
  # pretty labels
  labels <- sprintf("<strong>%s</strong><br/>%g&#37",
                    hb_shapes$HBName, hb_shapes$value) %>%
    lapply(htmltools::HTML)
  
  # plot
  
  pal <- colorNumeric(
    palette = "Greens",
    domain = hb_shapes$value,
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
              title = "Life Satisfaction<br>(% adults at or above mode)",
              opacity = 1
    )
  
  
  
  
  # leaflet(options = leafletOptions(minZoom = 6)) %>%
  #   setView(lng = -5, lat = 57.35, zoom = 6) %>%
  #   # restrict view to around Scotland
  #   setMaxBounds(lng1 = -1,
  #                lat1 = 50,
  #                lng2 = -9,
  #                lat2 = 64) %>% 
  #   # load in basemap
  #   addProviderTiles(providers$CartoDB.PositronNoLabels) %>% 
  #   # add Health Board polygons, colour based on LE, highlight on hover
  #   addPolygons(data = hb_shapes, color = "white",
  #               fillColor = ~colorQuantile(
  #                 "GnBu", (-hb_shapes$value))
  #               (-hb_shapes$value),
  #               weight = 0.5, fillOpacity = 0.9, label = labels,
  #               highlightOptions = highlightOptions(
  #                 color = "white", weight = 2,
  #                 opacity = 0.9, bringToFront = TRUE))
}