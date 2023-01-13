library(shiny)
library(shinythemes)
library(tidyverse)
library(htmltools)
library(leaflet)
library(sf)
library(DT)
library(plotly)
library(shinycssloaders)
library(rmapshaper)




inst_data3gl <- read_rds('../inst_data3.rds')
inst_data3gla <- inst_data3gl %>% select(id, name, city, state, degrees_awarded.predominant_recoded, degrees_awarded.predominant_recoded, predomdegawrd, degrees_awarded.highest, title_iv.female.withdrawn_by.2yrs, title_iv.female.still_enrolled_by.2yrs, title_iv.male.withdrawn_by.2yrs,title_iv.male.still_enrolled_by.2yrs, year, ownership, region_id, region, latt, longg, geometry, state_fips, state_fips2, enrollment.all)

public <- inst_data3gla %>% filter(ownership == 1)
private_non_profit <- inst_data3gla %>% filter(ownership ==2)

#inst_data3sf <- inst_data3gl
  # mutate(geom = gsub(geometry,pattern="(\\))|(\\()|c",replacement = ""))%>%
  # separate(geom, into = c("lat", "lon"), sep=",") %>%
  
  #st_as_sf(., coords=c("lat","lon"),crs=4326)

states <- geojsonio::geojson_read("https://rstudio.github.io/leaflet/json/us-states.geojson", what = "sp")
