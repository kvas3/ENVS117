# 1. Set up
library(tidyverse)
library(tigris)
library(sf)
library(FedData)
library(tmap)
library(readxl)
library(tidygeocoder)

setwd("/Users/vasudha/Desktop/ENVS 117/Project")

# 2. Synthesizing data to 1 dataset -- tracts
load("Project_Files/Dem_Race_SanJose_SF.RData") #black pct data
load("Project_Files/Dem_Hispanic_SanJose_SF.RData") #hispanic pct data
load("Project_Files/Dem_Children_SanJose_SF.RData") #children pct data
load("Project_Files/Dem_Tenure_SanJose_SF.RData") #renter pct
load("Project_Files/Dem_Tenure_SanJose_DF.RData") #multifamily units
load("Project_Files/Displacement_Typologies_SJ.RData") #displacement type
load("Project_Files/Evictions_2019.RData") #evictions 2019

hispanic_SJ <- as.data.frame(hispanic_SJ)
children_SJ <- as.data.frame(children_SJ)
tenure_SJ <- as.data.frame(tenure_SJ)
displacement_SJ <- as.data.frame(displacement_SJ)


tracts_SJ <- left_join(race_SJ, units_SJ, by = "GEOID") %>% 
  left_join(hispanic_SJ, by = "GEOID") %>% 
  left_join(children_SJ, by = "GEOID") %>%
  left_join(tenure_SJ, by = "GEOID") %>%
  left_join(units_SJ, by = "GEOID") %>% 
  left_join(displacement_SJ, by = "GEOID") %>% 
  left_join(rentburden_SJ, by = "GEOID") %>%
  select(GEOID, Total.x, White, Black_Pct, Hispanic_Pct, Children_Pct, Renter_Pct, Units_Pct.x, RentBurden_Pct, Typology) %>%
  rename(Units_Pct = "Units_Pct.x") #join tract characteristisc in 1 df

# 3. Add eviction count to each tract
tract_evictions <- st_join(tracts_SJ, evictions_19)
evictions_count <- plyr::count(tract_evictions, "GEOID")
zero <- which(is.element(evictions_count$GEOID, tract_evictions$GEOID[which(is.na(tract_evictions$geo_method))])) #check which tracts match tracts w/ 0 evictions
evictions_count$freq <- replace(evictions_count$freq, zero, 0) #replace w/ 0s

tracts_SJ <- left_join(tracts_SJ, evictions_count, by = "GEOID") %>%
  rename(Eviction_Count = "freq")

# 4. Save data
save(tracts_SJ, file = "Project_Files/TractsData_SanJose.RData")
