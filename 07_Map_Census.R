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

# 2. Data import
load("Project_Files/TractsData_SanJose.RData")
tracts_SJ$Black_Pct <- round(tracts_SJ$Black_Pct*100, 2)
tracts_SJ$Hispanic_Pct <- round(tracts_SJ$Hispanic * 100, 2)
tracts_SJ$Children_Pct <- round(tracts_SJ$Children_Pct * 100, 2) #format pct cols


# 3. Map - Race
tmap_mode("view")
Map_Black <- tm_shape(tracts_SJ) + 
  tm_fill(col = "Black_Pct", palette = "YlGnBu", style = "quantile", n = 4, group = "% Black Population", id = "Black_Pct", popup.vars = c("Black_Pct", "Eviction_Count", "GEOID"), legend.format = list(digits = 1), title = "% Black Population") + 
  tm_bubbles(size = "Eviction_Count", col = "red", alpha = 0.8, size.lim = c(36, 1017), group = "Evictions in 2019", id = "Eviction_Count", popup.vars = c("Black_Pct", "Eviction_Count", "GEOID")) + 
  tm_basemap("CartoDB.DarkMatter")

mean(tracts_SJ$Eviction_Count[tracts_SJ$Black_Pct > 4.7]) #mean eviction in highest quantile
mean(tracts_SJ$Eviction_Count[tracts_SJ$Black_Pct < 0.9]) #mean eviction in lowest quantile

Map_Hisp <- tm_shape(tracts_SJ) + 
  tm_fill(col = "Hispanic_Pct", palette = "YlGnBu", style = "quantile", n = 4, group = "% Hispanic Population", id = "Hispanic_Pct", popup.vars = c("Hispanic_Pct", "Eviction_Count", "GEOID"), legend.format = list(digits = 1), title = "% Hispanic Population") + 
  tm_bubbles(size = "Eviction_Count", col = "red", alpha = 0.8, size.lim = c(36, 1018),  group = "Evictions in 2019", id = "Eviction_Count", popup.vars = c("Hispanic_Pct", "Eviction_Count", "GEOID")) + 
  tm_basemap("CartoDB.DarkMatter")

save(Map_Black, file = "Project_Maps/Map_Black.RData")
save(Map_Hisp, file = "Project_Maps/Map_Hisp.RData")


# 4. Map - Children
Map_Child <- tm_shape(tracts_SJ) + 
  tm_fill(col = "Children_Pct", palette = "YlOrBr", style = "quantile", n = 4, group = "% of Households w/ Children", id = "Children_Pct", popup.vars = c("Children_Pct", "Eviction_Count", "GEOID"), legend.format = list(digits = 1), title = "% Households w/ Children") + 
  tm_bubbles(size = "Eviction_Count", col = "blue", alpha = 0.8, size.lim = c(36, 1018), group = "Evictions in 2019", id = "Eviction_Count", popup.vars = c("Children_Pct", "Eviction_Count", "GEOID")) + 
  tm_basemap("CartoDB.DarkMatter")

save(Map_Child, file = "Project_Maps/Map_Child.RData")

