library(rgdal)

hb_shapes <- readOGR(
  dsn ="data/shapefiles/SG_NHS_HealthBoards_2019/",
  layer = "SG_NHS_HealthBoards_2019",
  GDAL1_integer64_policy = TRUE)

crs <- CRS("+proj=longlat +datum=WGS84")

# transform shape data to plot on map
hb_shapes_ll <- hb_shapes %>% 
  rgeos::gSimplify(tol=25, topologyPreserve=TRUE) %>% 
  spTransform(crs)

hb_shapes@polygons <- hb_shapes_ll@polygons

writeOGR(
  obj = hb_shapes,
  dsn = "data/simpler_shapefiles/NHS_HealthBoards_2019/",
  layer = "NHS_HealthBoards_2019",
  driver = "ESRI Shapefile",
  overwrite_layer = TRUE)