# 1. Set up
library(tidyverse)
library(tigris)
library(sf)
library(FedData)
library(tmap)
library(readxl)
library(tidygeocoder)
library(tidycensus)

setwd("/Users/vasudha/Desktop/ENVS 117/Project")

#-------------------------------------

# 2. Load and Process Census data: Race
race_SJ <- get_acs(geography = "tract", year = 2019, table = "B02001", state = "CA", county = "Santa Clara", output = "wide", geometry = TRUE, cache_table = TRUE) %>%
  rename(Total = B02001_001E, White = B02001_002E, Black = B02001_003E, Asian = B02001_005E) %>%
  select(GEOID, Total, White, Black, Asian) %>%
  mutate(Black_Pct = Black/Total)

hispanic_SJ <- get_acs(geography = "tract", year = 2019, table = "B03003", state = "CA", county = "Santa Clara", output = "wide", geometry = TRUE, cache_table = TRUE) %>%
  rename(Total = B03003_001E, Hispanic = B03003_003E) %>%
  select(GEOID, Total, Hispanic) %>%
  mutate(Hispanic_Pct = Hispanic/Total)

race_SJ <- st_transform(race_SJ, crs = 2227) 
hispanic_SJ <- st_transform(hispanic_SJ, crs = 2227) #project to CA state plane 3

race_SJ <- st_intersection(race_SJ, boundary_SJ)
hispanic_SJ <- st_intersection(hispanic_SJ, boundary_SJ) #reduce county-wide data to SJ only

#-------------------------------------

# 3. Load and Process Census data: Children
children_SJ <- get_acs(geography = "tract", year = 2019, table = "B23007", state = "CA", county = "Santa Clara", output = "wide", geometry = TRUE, cache_table = TRUE) %>%
  rename(Total = B23007_001E, Children = B23007_002E) %>%
  select(GEOID, Total, Children) %>%
  mutate(Children_Pct = Children/Total)

children_SJ <- st_transform(children_SJ, crs = 2227) #project to CA state plane 3
children_SJ <- st_intersection(children_SJ, boundary_SJ) #reduce county-wide data to SJ only

#-------------------------------------

# 4.  Load and Process Census data: Tenure
tenure_SJ <- get_acs(geography = "tract", year = 2019, table = "B25003", state = "CA", county = "Santa Clara", output = "wide", geometry = TRUE, cache_table = TRUE) %>%
  rename(Total = B25003_001E, Renter = B25003_003E) %>%
  select(GEOID, Total, Renter) %>%
  mutate(Renter_Pct = Renter/Total)

tenure_SJ <- st_transform(tenure_SJ, crs = 2227) #project to CA state plane 3
tenure_SJ <- st_intersection(tenure_SJ, boundary_SJ) #reduce county-wide data to SJ only

#-------------------------------------

# 5. Load and Process Census Data: Multifamily/Multiunit dwellings

units_SJ <- get_acs(geography = "tract", year = 2019, table = "B25032", state = "CA", county = "Santa Clara", output = "wide", cache_table = TRUE) %>% 
  mutate(Units_Pct = (B25032_005E+B25032_006E+B25032_007E+B25032_008E+B25032_009E+B25032_010E+B25032_016E+B25032_017E+B25032_018E+B25032_019E+B25032_020E+B25032_021E)/B25032_001E) %>%
  select(GEOID, Units_Pct)

#-------------------------------------

# 6. Save processed data
save(race_SJ, file = "Project_Files/Dem_Race_SanJose_SF.RData")
save(hispanic_SJ, file = "Project_Files/Dem_Hispanic_SanJose_SF.RData")
save(children_SJ, file = "Project_Files/Dem_Children_SanJose_SF.RData")
save(tenure_SJ, file = "Project_Files/Dem_Tenure_SanJose_SF.RData")
save(units_SJ, file = "Project_Files/Dem_Tenure_SanJose_DF.RData")
