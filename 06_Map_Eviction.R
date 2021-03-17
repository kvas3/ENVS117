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
load(file = "Project_Files/Evictions_2019.RData")
load(file = "Project_Files/Evictions_SanJose_SF.RData")
load(file = "Project_Files/TractsData_SanJose.RData")
load("Project_Files/Boundary_SanJose_SF.RData")

#---------------------------------------------

# 3. Map - Animated map of evictions per month
Anim_Evic <- tm_shape(boundary_SJ) + 
  tm_polygons(col = "#D1E2F2", legend.show = FALSE) + 
  tm_shape(evictions_19) + 
  tm_dots(size = 0.1, col = "black") + 
  tm_facets(along = "M", free.coords = FALSE, as.layers = TRUE) + 
  tm_compass(position = c("left", "bottom")) + 
  tm_scale_bar(position = c("left", "bottom")) + 
  tm_layout(main.title = c("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"), main.title.size = 1.5, main.title.fontfamily = "serif", main.title.position = c("right"), title = "Evictions in San Jose, 2019", title.position = c("center", "top"), title.size = 1, title.fontface = 3, title.fontfamily = "Courier")

tmap_animation(Anim_Evic, filename = "Animated_MonthlyEvictions19.gif", delay = 100, loop = T)


#---------------------------------------------

# 4. Viz, line chart - Evictions per month
plot_evic <- ggplot() +
  stat_count(data = filter(evic_SJ, M > "2018 06"), aes(x = M, group = county), geom = "line") + 
  scale_x_discrete(labels = c("Jul '18", "Aug '18", "Sep '18", "Oct '18", "Nov '18", "Dec '18", "Jan '19", "Feb '19", "Mar'19", "Apr '19", "May '19", "Jun '19", "Jul '19", "Aug '19", "Sep '19", "Oct '19", "Nov '19", "Dec '19", "Jan '20", "Feb '20", "Mar '20", "Apr '20", "May '20", "Jun '20", "Jul '20", "Aug '20", "Sep '20", "Oct '20", "Nov '20", "Dec '20", "Jan '21")) +
  geom_vline(xintercept = c("2018 12", "2020 03"), color = "red", linetype = "dotted") +
  ggtitle("Notice Count 2018-20") + 
  labs(x = "Month", y = "") + 
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, family = "Courier"))
  
save(plot_evic, file = "Project_Maps/Plot_MontlyEvictions.RData")
