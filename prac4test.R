#Library
library(sf)
library(tidyverse)
library(tmap)
library(dplyr)
library(here)
library(countrycode)

#read file
worldmap <- st_read("prac4_data/World_Countries_Generalized.shp")
HDRdata <- read_csv("prac4_data/HDR23-24_Composite_indices_complete_time_series.csv", locale = locale(encoding = "latin1"))

GII <-HDRdata %>%
  mutate(Difference = gii_2019 - gii_2010)%>%
  filter(!str_detect(iso3, "^ZZ.*")) %>%
  mutate(iso2c = countrycode(iso3, "iso3c", "iso2c")) %>%
  select(iso2c, Difference)

slice_head(GII, n=5)
#join data
world <- worldmap %>% 
  merge(., GII, by.x="ISO", by.y="iso2c")

library(tmap)
library(tmaptools)
tmap_mode("view")
tm_shape(world) + 
  tm_polygons("Difference", palette = "-RdBu", midpoint=-0.1, n=5) +
  tm_layout(legend.outside = TRUE)
