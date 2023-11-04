#ee_install()
library(rgee)
library(ggplot2)
library(dplyr)
library(sf)
library(ggthemes)
library(ggtext)
library(rcartocolor)

# Authenticate with Google Earth Engine
ee_Initialize()

# Download Ethiopian admin boundaries here: https://data.humdata.org/dataset/cb58fa1f-687d-4cac-81a7-655ab1efb2d0/resource/63c4a9af-53a7-455b-a4d2-adcc22b48d28/download/eth_adm_csa_bofedb_2021_shp.zip
# Unzip and store in "data" directory
admin_boundaries <- st_read("data/eth_admbnda_adm3_csa_bofedb_2021.shp")
harar <- admin_boundaries %>%
  filter(ADM3_EN == "Abadir")

# check it out
plot(harar$geometry)

# convert to ee.Geometry
harar_ee <- sf_as_ee(harar$geometry)

# Download and filter the Open Buildings dataset
building_collection <- ee$FeatureCollection("GOOGLE/Research/open-buildings/v3/polygons")
harar_buildings <- building_collection$filterBounds(harar_ee)

# Convert the Earth Engine collection to an R spatial object
building_sf <- ee_as_sf(harar_buildings, maxFeatures = 65000)

# Create a ggplot2 map of building footprints
main_map <- ggplot() +
  geom_sf(data = building_sf, color = "transparent", aes(fill = confidence)) +
  coord_sf() +
  theme_solid(fill = '#000c05') +
  labs(
    title = " Building footprints in\nHarar, Ethiopia  ",
    subtitle = sprintf("\u1260\u1210\u1228\u122D \u12A2\u1275\u12EE\u1335\u12EB\n\u12E8\u12A5\u130D\u122D \u12A0\u123B\u123B \u1218\u1308\u1295\u1263\u1275")
    ) +
  theme(
    plot.title = element_text(
      hjust = .75,
      vjust = -28,
      color = '#fcde9c',
      size = 13,
      family = 'Agbalumo'#,
      #face = 'bold'
      ),
    plot.subtitle = element_text(
      hjust = .74,
      vjust = -25,
      color = '#fcde9c',
      size = 13,
      family = 'Noto Serif Ethiopic'#,
      #face = 'bold'
    ),
    plot.title.position = 'plot',
    legend.direction = 'horizontal',
    legend.position = c(.18, .15),
    legend.title = element_text(
      color = '#f3e79b',
      size = 6,
      family = 'Roboto Condensed'
    ),
    plot.margin = unit(c(0,0,0,0), "cm")
    ) +
  scale_fill_carto_c(
    palette = 'SunsetDark',
    name = "Model confidence score",
    guide = guide_colorsteps(
      title.position = 'top',
      title.hjust = 0.5,
      barheight = unit(0.15, "lines")
    )
  )

ggsave(filename = 'harar_buildings.tiff', plot = main_map, width = 8, height = 6, device='tiff', dpi=700)

  

