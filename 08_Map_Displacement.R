# 1. Set up
library(tidyverse)
library(tigris)
library(sf)
library(FedData)
library(tmap)
library(readxl)
library(tidygeocoder)

setwd("/Users/vasudha/Desktop/ENVS 117/Project")

# 2. Data Import
load(file = "Project_Files/TractsData_SanJose.RData")

#---------------------------------------------

# 3. Map - Displacement typologies 
Map_Displ <- tm_shape(tracts_SJ) + 
  tm_polygons(col = "Typology", palette = "viridis", alpha = 0.8, group = "Displacement Typology", id = "Typology", popup.vars = c("Typology", "Eviction_Count", "GEOID")) +
  tm_bubbles(size = "Eviction_Count", col = "red", alpha = 0.8, group = "Evictions in 2019", id =  "Eviction_Count", popup.vars = c("Typology", "Eviction_Count", "GEOID"), size.lim = c(36, 1018)) +
  tm_basemap("CartoDB.DarkMatter")

save(Map_Displ, file = "Project_Maps/Map_Displ.RData")

#---------------------------------------------

# 4. Viz, waffle - Number of tracts of each Typology
Tbl_Displ <- as.data.frame(summary(tracts_SJ$Typology)) #number of tracts of each category
Tbl_Displ$Typology <- rownames(Tbl_Displ)
Tbl_Displ <- Tbl_Displ[c(2,1)] %>% arrange(desc(summary(tracts_SJ$Typology)))
colnames(Tbl_Displ)[2] <- "Number of Tracts" #formatting
Tbl_Displ <- as.data.frame(Tbl_Displ)
names(Tbl_Displ$`Number of Tracts`) <- Tbl_Displ$Typology

save(Tbl_Displ, file = "Project_Maps/Tbl_Displ.RData") #save file

displ <- Tbl_Displ$`Number of Tracts`
names(displ) <- Tbl_Displ$Typology

viz_displ <- waffle::waffle(parts = displ, colors = viridis(6), size = 0.5, xlab = "1 Square = 1 Tract", legend_pos = "bottom") #visualize

save(viz_displ, file = "Project_Maps/viz.displ.RData")

#---------------------------------------------

# 5. Viz, bar - Avg evictions per tract, by typology
load(file = "Project_Files/TractsData_SanJose.RData")
levels(tracts_SJ$Typology) <- str_wrap(levels(tracts_SJ$Typology), width=13) #wrap axis ticks
tracts_SJ$Typology <- fct_reorder(tracts_SJ$Typology, tracts_SJ$Eviction_Count, mean, na.rm=TRUE) #reorder in order of mean

Plot_Displ <- ggplot(data = filter(tracts_SJ, Typology != "No Data"), aes(x = Typology, y = Eviction_Count)) +
  stat_summary(fun.data = "mean_sdl", geom = "bar", aes(fill = Typology)) +
  scale_fill_manual(values = c("#440154FF", "#414487FF", "#2A788EFF", "#22A884FF", "#7AD151FF")) +
  theme_classic() +
  labs(title = "Average Notices per Tract by Gentrification Typology", y = "", x = "Typology") +
  theme(plot.title = element_text(hjust = 0.5, family = "Courier"))

save(Plot_Displ, file = "Project_Maps/Plot_Displ.RData")

#---------------------------------------------
  