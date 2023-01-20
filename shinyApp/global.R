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
library(labelled)



inst_data3gl <- read_rds('../inst_data3.rds')

inst_data3gla <- inst_data3gl %>% select(id, name, city, state, year, size, degrees_awarded.predominant,  predomdegawrd, degrees_awarded.highest, title_iv.female.withdrawn_by.2yrs, title_iv.female.still_enrolled_by.2yrs, title_iv.male.withdrawn_by.2yrs,title_iv.male.still_enrolled_by.2yrs, year, ownership, region_id, region, latt, longg, geometry, state_fips, state_fips2, enrollment.all)

# colors <- c("red", "yellow", "blue")
# own_fac <- c("1", "2", "3")
# inst_tmp <- inst_data3gla %>% 
#   mutate(ownership_color = as.character(ownership)) %>% 
#   set_value_labels(ownership_color = setNames(colors, own_fac))
                                         

prgmsg <- read_csv('../prgms.csv')

programlist <- as.list(prgmsg %>% select(starts_with("program_percentage.")) %>% colnames())
programlist <- programlist[-39]

#state_pop <- read_csv('../state_pop.csv')
states_merged <- read_rds('../states_merged.rds')
by_state_summary_b <- read_csv('../by_state_summary.csv')
states_merged_cap <- read_rds('../states_merged_cap.rds')

# public <- inst_data3gla %>% filter(ownership == 1)
# private_non_profit <- inst_data3gla %>% filter(ownership ==2)


states <- geojsonio::geojson_read("https://rstudio.github.io/leaflet/json/us-states.geojson", what = "sp")
