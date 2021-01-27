# R Intro ADF&G
# Justin Priest
# justin.priest@alaska.gov

#####  MOTIVATING EXAMPLE 3  #####
#####       Groundfish       #####

# Difficulty: Moderate


library(tidyverse)
library(lubridate)
library(RColorBrewer) # We'll use this library later for some nice colored charts


# Read in data, then rename the columns
groundfish <- read_csv("data/OceanAK_GroundfishSpecimens_2000-2020.csv") %>% 
  rename("Lat_end" = "End Latitude Decimal Degrees",
         "Long_end" = "End Longitude Decimal Degrees",
         "G_Stat_Area" = "G Stat Area",
         "Target_Sp_Code" = "Target Species Code",
         "AvgDepth_Fthm" = "Avg Depth Fathoms",
         "Substrate" = "Substrate Type",
         "Length_mm" = "Length Millimeters",
         "Weight_kg" = "Weight Kilograms",
         "Count" = "Number of Specimens")

groundfish %>%
  filter(Species == "Sablefish",
         Age != is.na(Age), # remove unaged fish
         Year >= 2011) %>%
  ggplot(aes(x = Length_mm, y = Weight_kg, color = Age)) +
  geom_point() +
  scale_colour_gradientn(colors = rev(brewer.pal(11, "Spectral")), limits = c(1, 50)) +
  facet_wrap(~Year)


groundfish %>%
  filter(Species == "Sablefish",
         Sex == "Male" | Sex == "Female") %>%
  ggplot(aes(x=Sex, y = Length_mm, fill = Sex)) +
  geom_boxplot()




# In progress
sablefish <- groundfish %>%
  filter(Species == "Sablefish",
         Sex == "Male" | Sex == "Female") %>%
  mutate(Sex_01 = ifelse(Sex == "Male", 0, 1))

sablefish_model <- glm(Sex_01 ~ Length_mm, family = "binomial", data = sablefish)
summary(sablefish_model)

pred <- crossing(Sex_01 = c("0", "1"), Length_mm = seq(1:1000))
pred <- pred %>%
  mutate(predictedsex = exp(predict.glm(sablefish_model, pred)))

pred

