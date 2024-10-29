#Library
library(sf)
library(tidyverse)
library(tmap)
library(dplyr)
library(here)

#read file
worldmap <- st_read(here("prac4_data", "World_Countries_Generalized.shp"))
HDRdata <- read_csv(here("prac4_data", "HDR23-24_Composite_indices_complete_time_series.csv"))

GII <-HDRdata %>%
  mutate(Difference = gii_2019 - gii_2010)%>%
  select(country, Difference)

slice_head(GII, n=5)
#join data
world <- worldmap %>% 
  merge(., GII, by.x="COUNTRY", by.y="country")

library(tmap)
library(tmaptools)
tmap_mode("plot")
tm_shape(world) + 
  tm_polygons("Difference", palette = "Reds"  , n=3) +
  tm_layout(legend.outside = TRUE)
