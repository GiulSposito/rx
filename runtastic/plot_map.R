# Plot activities as small multiples

# Load packages
library(ggplot)
library(tidyverse)

# Read in pre-processed data
data <- readRDS("./data/gpx_processed.rds")

# Specify lat / lon window
lon_min <- min(data$lon)
lon_max <- max(data$lon)
lat_min <- min(data$lat)
lat_max <- max(data$lat)

# Create plot
p <- ggplot(data) +
  geom_path(aes(lon, lat, group = id),
            alpha = 0.3, size = 0.3, lineend = "round") +
  theme_void()

p

# Save plot
ggsave("./map001.png", p, width = 30, height = 15, units = "cm", dpi = 600)

