# library(sf)
library(maps)
library(mapproj)
library(viridisLite)
library(ggplot2)
library(tidyverse)
library(plotly)
# library(giscoR)
# library(dplyr)
# library(stringr)
# library(tidyr)
# library(lubridate)
# library(reshape2)

# US_Geom_data <- read.csv("US_GeoCode.csv")

##### 1. Data import
US_Geom_data2 <- map_data("state")
US_Temp_data <- read.csv("Climate Data.csv")

##### 2. Data manipulation/tidying
US_Temp_data$Name <- tolower(US_Temp_data$Name)
  
US_MapTemp2 <- merge(US_Geom_data2, US_Temp_data, by.x = "region", by.y = "Name", 
                    sort = FALSE)

US_MapTemp2 <- US_MapTemp2[order(US_MapTemp2$order), ]

US_MapTemp2 <- subset(US_MapTemp2, select = -c(6:10)) %>% 
  rename("avg_temp" = "X1901.2000.Mean")

US_MapTemp2$region <- toupper(US_MapTemp2$region)

##### 3. Static Map

plot <- ggplot(US_MapTemp2, 
               aes(x = long, 
                   y = lat)) +
  geom_polygon(aes(fill = avg_temp,  
                   group = group), 
               color = "white", 
               linewidth = 0.1) +
  coord_map() +
  scale_fill_viridis_c(option = "E", 
                       name = "Mean Temp (F)") +
  labs(title = "US Average Temperature (1901 - 2000)") +
  theme(axis.title.x = element_blank(), 
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5),
        panel.grid = element_blank(),
        legend.position = "bottom",
        legend.direction = "horizontal")

# ggsave("US Avg Temp.png", plot, width = 6, height = 4)

##### 3. Interactive Map with Plotly

viz <- ggplot(US_MapTemp2, 
              aes(x = long, 
                  y = lat, 
                  text = region)) +
  geom_polygon(aes(fill = avg_temp,  
                   group = group), 
               color = "white", 
               linewidth = 0.1) +
  coord_map() +
  scale_fill_viridis_c(option = "E", 
                       name = "Mean Temp (F)") +
  labs(title = "US Average Temperature (1901 - 2000)", 
       fill = "Mean Temp (F)") +
  theme(axis.title.x = element_blank(), 
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank(),
        axis.ticks = element_blank(),
        plot.title = element_text(hjust = 0.5),
        panel.grid = element_blank())
  

ggplotly(viz, text = "region")





