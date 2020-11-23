# R Intro ADF&G
# Justin Priest
# justin.priest@alaska.gov

#####     SCRIPT 6    ####
##### BASIC ANALYSIS #####

library(tidyverse)





tannercrab <- read_csv("data/OceanAK_CrabSurvey_2018-2020_Specimens.csv") %>%
  filter(Species == "Bairdi tanner crab",
         !is.na(Sex)) %>% # We're removing these but note that it might be an assumption
  rename("potnum" = "Pot No",
         "Latitude" = "Latitude Decimal Degrees",
         "Longitude" = "Longitude Decimal Degrees",
         "Count" = "Number Of Specimens",
         "Width" = "Width Millimeters",
         "Chela" = "Chela Height Millimeters",
         "SurveyStartDate" = "Trip Start Date") %>%
  mutate(SurveyStartDate = ymd(as.POSIXct(SurveyStartDate, format = "%m/%d/%Y", tz = "US/Alaska")),
         SurveyMonth = month(SurveyStartDate)) %>%
  dplyr::select(Year, SurveyStartDate, SurveyMonth, Location, Sex, Width, Chela, Count)

tannercrab


# First let's do some exploratory visualizations

tannercrab %>%
  ggplot(aes(x=Location, y=Width)) +
  geom_boxplot()

tannercrab %>%
  ggplot(aes(x=Sex, y=Width)) +
  geom_boxplot()

tannercrab %>%
  ggplot(aes(x=as.factor(Year), y=Width)) +
  geom_boxplot()

tannercrab %>%
  filter(between(Chela, 8, 60)) %>%
  ggplot(aes(x=Width, y=Chela)) +
  geom_point()


# Simple statistics
# We'll use group_by() and summarize() which is kind of similar to a pivot table
# Does Width vary by Year
tannercrab %>%
  group_by(Year) %>%
  summarise(meanwidth = mean(Width, na.rm = TRUE),
            sewidth = sd(Width, na.rm = TRUE), 
            samples = length(Width))

# Does Width vary by Location
tannercrab %>%
  group_by(Location) %>%
  summarise(meanwidth = mean(Width, na.rm = TRUE),
            sewidth = sd(Width, na.rm = TRUE), 
            samples = length(Width))

# Does Width vary by Sex
tannercrab %>%
  group_by(Sex) %>%
  summarise(meanwidth = mean(Width, na.rm = TRUE),
            sewidth = sd(Width, na.rm = TRUE), 
            samples = length(Width)) 
# sd() is the standard deviation 
# length() is the function for counting how long something is, 
# In this case, length() counts how long the vector "Width is

# 
summary(lm(Width ~ Year, data = tannercrab))
summary(lm(Width ~ as.factor(Year), data = tannercrab))
summary(aov(Width ~ as.factor(Year), data = tannercrab))











