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

prgmsg <- read_csv('../prgms.csv')

programlist <- as.list(prgmsg %>% select(starts_with("program_percentage.")) %>% colnames())
programlist <- programlist[-39]



# public <- inst_data3gla %>% filter(ownership == 1)
# private_non_profit <- inst_data3gla %>% filter(ownership ==2)


states <- geojsonio::geojson_read("https://rstudio.github.io/leaflet/json/us-states.geojson", what = "sp")
