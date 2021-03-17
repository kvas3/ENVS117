# 1. Set up and load packages
library(tidyverse)
library(tigris)
library(sf)
library(FedData)
library(tmap)
library(readxl)
library(tidygeocoder)

setwd("/Users/vasudha/Desktop/ENVS 117/Project")


# 2. Data import and Tidy
evic_SJ <- read_excel("Altered_Data/Evictions_SanJose.xlsx")

evic_SJ$`Street Type` <- replace_na(evic_SJ$`Street Type`, "")
evic_SJ$`Zip Code` <- replace_na(evic_SJ$`Zip Code`, "")

evic_SJ <- evic_SJ %>% 
  distinct(.keep_all = TRUE) %>%
  unite(Street, `Street Number`, `Street Name`, `Street Type`, remove = TRUE, na.rm = FALSE,  sep = " ") %>%
  select(1, 3, 5, 6) %>%
  rename(date_served = `Date Served`, date_rcd = `Date Received`) %>%
  drop_na(Street, date_rcd) %>% 
  arrange(date_rcd) %>%
  as.data.frame()

evic_SJ$county <- "Santa Clara County"
evic_SJ$state <- "CA"
evic_SJ$country <- "United States"

# 3. Geocoding
geo_evic_SJ <- evic_SJ %>% distinct() #create copy with distinct addresses
geo_evic_SJ <- geocode(.tbl = geo_evic_SJ, street = Street, county = county, state = state, country = country, postalcode = `Zip Code`, method = "cascade", cascade_order = c("osm", "census"), verbose = TRUE) #to geocode distinct addresses only

evic_SJ <- left_join(evic_SJ, geo_evic_SJ, remove = FALSE) #join address matches
evic_SJ <- drop_na(evic_SJ, lat)

save(geo_evic_SJ, file = "Project_Files/Evictions_Geocoded.RData")

# 4. Convert to SF object
evic_SJ <- st_as_sf(evic_SJ, coords = c("long", "lat"), crs = 4326)
evic_SJ <- st_transform(evic_SJ, crs = 2227) #project to CA state plane zone 3

# 5. Date formatting and Filter 2019; save
evic_SJ$date_rcd <- as.Date(evic_SJ$date_rcd)
evic_SJ$Y <- format(as.Date(evic_SJ$date_rcd), "%Y")
evic_SJ$M <- format(as.Date(evic_SJ$date_rcd), "%Y %m")

evictions_19 <- evic_SJ %>% filter(Y == 2019) 
evictions_19 <- st_intersection(evictions_19, boundary_SJ) #reduce to city boundaries

evictions_19$m <- evictions_19$M #save month numbers in another column
evictions_19$M <- revalue(evictions_19$M, c(`01` = "Jan", `02` = "Feb", `03` = "Mar", `04` = "Apr", `05` = "May", `06` = "Jun", `07` = "Jul", `08` = "Aug", `09` = "Sep", `10` = "Oct", `11` = "Nov", `12` = "Dec")) %>%
  ordered(levels = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"))

save(evic_SJ, file = "Project_Files/Evictions_SanJose_SF.RData")
save(evictions_19, file = "Project_Files/Evictions_2019.RData")
#=====================================================================
