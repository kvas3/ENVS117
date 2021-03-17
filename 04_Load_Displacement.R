# 1. Set up
library(tidyverse)
library(tigris)
library(sf)
library(FedData)
library(tmap)
library(readxl)
library(tidygeocoder)
library(plyr)

setwd("/Users/vasudha/Desktop/ENVS 117/Project")

# 2. Data Import and Project
displacement_SJ <- st_read("Source_Data/sanfrancisco.gpkg")
displacement_SJ <- st_transform(displacement_SJ, crs = 2227)
displacement_SJ <- st_intersection(displacement_SJ, boundary_SJ)

# 3. Tidy
displacement_SJ$Typology <- displacement_SJ$Typology %>%
  revalue(c(`Early/Ongoing Gentrification` = "Ongoing", `Low-Income/Susceptible to Displacement` = "At Risk", `Stable Moderate/Mixed Income` = "Stable", `Stable/Advanced Exclusive` =  "Advanced", `Unavailable or Unreliable Data` = "No Data", `At Risk of Becoming Exclusive` = "At Risk", `Becoming Exclusive` = "Ongoing", `Advanced Gentrification` = "Advanced")) %>% #collapse cats
  ordered(levels = c("At Risk", "Ongoing", "Advanced", "Stable", "High Student Population", "No Data")) #add levels

displacement_SJ$GEOID <- as.character(displacement_SJ$GEOID)
displacement_SJ$GEOID <- paste("0", displacement_SJ$GEOID, sep = "") #fix geoid field formatting

save(displacement_SJ, file = "Project_Files/Displacement_Typologies_SJ.RData")

displacement_tbl <- as.data.frame(summary(displacement_SJ$Typology))
colnames(displacement_tbl) <- "Number of Tracts"
save(displacement_tbl, file = "Project_Files/Displacement_Table.RData")

#--------------

