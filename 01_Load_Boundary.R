# 1. Set up
library(tidyverse)
library(tigris)
library(sf)
library(FedData)
library(tmap)
library(readxl)
library(tidygeocoder)

setwd("/Users/vasudha/Desktop/ENVS 117/Project")

# 2. Data Import and Tidy
boundary_SJ <- st_read("/Users/vasudha/Desktop/ENVS 117/Project/Altered_Data/Boundary_SJ/City_Limits.shp")
st_crs(boundary_SJ) #check crs
save(boundary_SJ, file = "Project_Files/Boundary_SanJose_SF.RData")
