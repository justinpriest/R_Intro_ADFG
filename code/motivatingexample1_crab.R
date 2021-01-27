# R Intro ADF&G
# Justin Priest
# justin.priest@alaska.gov

#####  MOTIVATING EXAMPLE 1  #####
#####      Crab Mapping      #####

# Difficulty: Moderate & High


library(tidyverse)
library(lubridate)
library(leaflet)
library(leaflet.extras)

crabsurvey <- read_csv("data/OceanAK_CrabSurvey_2018-2019.csv") %>%
  filter(Species == "Bairdi tanner crab", Year == 2019) %>%
  rename("Latitude" = "Latitude Decimal Degrees",
         "Longitude" = "Longitude Decimal Degrees",
         "Count" = "Number Of Specimens") 



crabsurvey_specimens <- read_csv("data/OceanAK_CrabSurvey_2018-2020_Specimens.csv") %>%
  filter(Species == "Bairdi tanner crab") %>%
  rename("Latitude" = "Latitude Decimal Degrees",
         "Longitude" = "Longitude Decimal Degrees",
         "Count" = "Number Of Specimens",
         "Width" = "Width Millimeters",
         "Chela" = "Chela Height Millimeters",
         "SurveyStartDate" = "Trip Start Date") %>%
  mutate(SurveyStartDate = ymd(as.POSIXct(SurveyStartDate, format = "%m/%d/%Y", tz = "US/Alaska")),
         SurveyMonth = month(SurveyStartDate))


summary(lm(Chela ~ Width + SurveyMonth, data = crabsurvey_specimens))


crabsurvey_specimens %>%
  filter(Chela != 1, Chela < 60) %>%
  ggplot(aes(x = Width, y = Chela)) +
  geom_point(alpha = 0.5) + geom_smooth() +
  facet_grid(SurveyMonth~Year) +
  theme_minimal()


# Is there a difference in mean crab size between 3 locations?
crab_sub <- crabsurvey_specimens %>%
  filter(Location == "St. James Bay" | Location == "Holkham Bay" | Location == "Excursion Inlet")

summary(aov(Width ~ Location, data=crab_sub))
TukeyHSD(aov(Width ~ Location, data=crab_sub))

crab_sub %>% group_by(Location) %>%
  summarise(meanwidth = mean(Width, na.rm = TRUE),
            SD_width = sd(Width, na.rm =TRUE))
# Answer, yes! St James crab are significantly larger. Holkham & Excursion crab are not signif different




#######################
###### MAPPING ########

# Difficulty: Very high

# Simple mapping
leaflet(crabsurvey) %>% addTiles() %>% 
  #addProviderTiles(providers$Esri.WorldImagery) %>%
  setView(-134, 57, 8) %>%
  addHeatmap(lng = ~Longitude, lat = ~Latitude, intensity = ~Count,
           minOpacity = 0.05, max = 1, radius = 15, blur = 20)

# Other good basemaps: Esri.WorldImagery, CartoDB.PositronNoLabels, 
# Esri.OceanBasemap, GeoportailFrance.orthos


# Complex mapping
library(KernSmooth)
library(sp)

kde_1 <- bkde2D(cbind(crabsurvey$Longitude, crabsurvey$Latitude),
                bandwidth=c(.0045, .0068), gridsize = c(1000,1000))
CL <- contourLines(kde_1$x1 , kde_1$x2 , kde_1$fhat)

LEVS <- as.factor(sapply(CL, `[[`, "level"))
NLEV <- length(levels(LEVS))

## CONVERT CONTOUR LINES TO POLYGONS
pgons <- lapply(1:length(CL), function(i)
  Polygons(list(Polygon(cbind(CL[[i]]$x, CL[[i]]$y))), ID=i))
spgons = SpatialPolygons(pgons)

leaflet(spgons) %>% addTiles() %>% 
  addPolygons(color = heat.colors(NLEV, NULL)[LEVS])
# From:
# https://gis.stackexchange.com/questions/168886/r-how-to-build-heatmap-with-the-leaflet-package









