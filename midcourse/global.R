library(shiny)
library(shinythemes)
library(tidyverse)
library(highcharter)
library(leaflet)
library(sf)


inst_data <- read_csv("../inst_data.csv")

inst_data2gl <- read_csv('../inst_data2.csv')

inst_data2glsf <- inst_data2gl %>% 
  mutate(geom = gsub(geometry,pattern="(\\))|(\\()|c",replacement = ""))%>%
  separate(geom, into = c("lat", "lon"), sep=",") %>%
  st_as_sf(., coords=c("lat","lon"),crs=4326)

states <- geojsonio::geojson_read("https://rstudio.github.io/leaflet/json/us-states.geojson", what = "sp")
