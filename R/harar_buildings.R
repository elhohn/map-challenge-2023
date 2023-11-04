# Install and load the required packages
#ee_install()
library(rgee)
library(leaflet)
library(ggplot2)
library(dplyr)

# Authenticate with Google Earth Engine
ee_Initialize()


To use a shapefile for filtering the Open Buildings data and creating a map for the "Abadir" region, you can follow these steps:
  
  Download and unzip the shapefile from the given link.
Load the shapefile using the sf package.
Filter the shapefile to only include the "Abadir" polygon.
Use the filtered shapefile's geometry to filter the Open Buildings data.
Create a simple map of the building footprints in the "Abadir" region using ggplot2.
Here's the R code to achieve this:
  
  R
Copy code
# Install and load the required packages
library(rgee)
library(leaflet)
library(ggplot2)
library(dplyr)
library(sf)

# Authenticate with Google Earth Engine
ee_Initialize()

# Specify the URL of the downloaded shapefile
shapefile_url <- "https://data.humdata.org/dataset/cb58fa1f-687d-4cac-81a7-655ab1efb2d0/resource/63c4a9af-53a7-455b-a4d2-adcc22b48d28/download/eth_adm_csa_bofedb_2021_shp.zip"

# create a new directory under tempdir
dir.create(dir1 <- file.path(tempdir(), "tempdir"))

#If needed later on, you can delete this temporary directory 
unlink(dir1, recursive = T)

#And test that it no longer exists
dir.exists(dir1)




# Unzip the shapefile and load it using the sf package

shapefile <- st_read("")

# Filter the shapefile to only include the "Abadir" polygon
shapefile_filtered <- shapefile %>%
  filter(ADM3_EN == "Abadir")

# Use the 'earthengine' package to filter and download the Open Buildings dataset
building_collection <- ee$FeatureCollection("GOOGLE/Research/open-buildings/v3/polygons")
building_collection_filtered <- building_collection$filter(
  ee$Filter$stringContains("name", city_name)
)

# Convert the Earth Engine collection to an R spatial object
building_sf <- ee_as_sf(building_collection_filtered)

# Create a ggplot2 map of building footprints
ggplot() +
  geom_sf(data = building_sf, color = "blue", fill = "lightblue") +
  coord_sf() +
  theme_minimal()