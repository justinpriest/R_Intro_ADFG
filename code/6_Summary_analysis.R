# R Intro ADF&G
# Justin Priest
# justin.priest@alaska.gov

#####      SCRIPT 6    ####
#####  BASIC ANALYSIS  #####

library(tidyverse)
library(lubridate)




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
         SurveyMonth = month(SurveyStartDate),
         dayofyear = yday(SurveyStartDate)) %>% # This creates the day of the year
  dplyr::select(Year, SurveyStartDate, dayofyear, SurveyMonth, Location, Sex, Width, Chela, Count)

tannercrab


# First summarize some of the variables

# table() makes a 1 (rows) or 2 way (rows x columns) table of counts
table(tannercrab$Width)
table(tannercrab$Chela)
table(tannercrab$Location)

table(tannercrab$Year, tannercrab$Location)
table(tannercrab$Location, tannercrab$Width)

# summary() makes a quartile summary of the range of the variable
summary(tannercrab$Width)
summary(tannercrab$Chela)



# Next, let's do some exploratory visualizations
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
  filter(between(Chela, 8, 60)) %>% # exclude obvious outliers
  ggplot(aes(x=Width, y=Chela)) +
  geom_point()


# Simple statistics
# We'll use group_by() and summarize() which is kind of similar to a pivot table
# Does Width vary by Year
tannercrab %>%
  group_by(Year) %>%
  summarise(meanwidth = mean(Width, na.rm = TRUE),  # Take mean
            sewidth = sd(Width, na.rm = TRUE),      # Take standard deviation
            samples = length(Width))                # Number of samples

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
# In this case, length() counts how long the vector "Width" is

# 
summary(lm(Width ~ Year, data = tannercrab))
summary(lm(Width ~ as.factor(Year), data = tannercrab))
summary(aov(Width ~ as.factor(Year), data = tannercrab))



summary(lm(Chela ~ Width, data = tannercrab  %>%
             filter(between(Chela, 8, 60)))) # Ignoring curvature


chelawidthmodel <- lm(Chela ~ Width, data = tannercrab  %>%
                        filter(between(Chela, 8, 60))) # Ignoring curvature

predict(chelawidthmodel, newdata = data.frame(Width = 100), se.fit = TRUE)



newdf <- data.frame(Width = seq(from = 90, to = 180, by =1))
newdf$predictedchela <- predict(chelawidthmodel, newdata = newdf)
newdf







tcrabsub <- tannercrab %>%
  mutate(sexcode = ifelse(Sex == "Female", 0, 1))



sexbinom <- glm(sexcode ~ Width, data = tcrabsub, family = "binomial")
summary(sexbinom)



preddf <- data.frame(Width = seq(from = 0, to = 180, by =1))
preddf$predval <- predict(sexbinom, newdata = preddf, "response")
preddf


ggplot(data = preddf, aes(x = Width, y = predval)) +
  geom_line() + 
  geom_point() +
  geom_point(data = tcrabsub, aes(x = Width, y = sexcode), color = "red", shape = 3)

# Note 11/24. Rhea says to use comm caught lingcod male vs female








