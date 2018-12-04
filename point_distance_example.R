#Alejandro Gomez Pazo
#University of Santiago de Compostela
#Email: a.gomez@usc.es

#Code
#Packages for execute the script.
library(rgdal)
library(sf)

#File .csv with ID and points coordinates in UTM.
points <- read.csv("D:/script_R/point_distance_example/point_data.csv")

#Calculate the distance between points. You can add Z value as one part of the formula.
distances <- cbind.data.frame((sqrt((points$x_2-points$x_1)^2+(points$y_2-points$y_1)^2)) + (sqrt((points$x_3-points$x_2)^2+(points$y_3-points$y_2)^2)))
names(distances) <- "Lenght"
points_dis <- cbind.data.frame(points, distances)

#Vector with the three points.
begin.coord <- data.frame(lon=points$x_1, lat=points$y_1)
center.coord <- data.frame(lon=points$x_2, lat=points$y_2)
end.coord <- data.frame(lon=points$x_3, lat=points$y_3)

# Create list of simple feature geometries
l_sf <- vector("list", nrow(begin.coord))
for (i in seq_along(l_sf)){
  l_sf[[i]] <- st_linestring(as.matrix(rbind(begin.coord[i, ], center.coord[i,], end.coord[i,])))
}
# Create simple feature geometry list column. Adapt EPSG code to your study zone.
l_sfc1 <- st_sfc(l_sf, crs = "+init=epsg:25829")
l_sfc2 <- st_sf(data.frame(points_dis$ID, points_dis$Lenght, geom = l_sfc1))

# Convert to `sp` object. Shapefile ESRI format.
st_write(l_sfc2, "D:/script_R/point_distance_example/lines_points.shp")
