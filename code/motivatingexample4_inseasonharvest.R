# R Intro ADF&G
# Justin Priest
# justin.priest@alaska.gov

#####  MOTIVATING EXAMPLE 4  #####
#####    Inseason Harvest    #####

# Difficulty: Easy/Moderate

library(tidyverse)
library(lubridate)


# The following few lines are an example of a custom function. 
# Don't pay too much attention to what this function does; it just makes a Stat week from a date 
statweek <- function(x) {
  as.numeric(format(as.Date(x), "%U")) - as.numeric(format(as.Date(cut(x, "year")), "%U")) + 1
}


# Read in data, then rename the columns, then fix/create columns, then filter it
inseasonharvest <- read_csv("data/OceanAK_InseasonSalmonHarvest_2015-2020.csv") %>% 
  rename("Opening" = "Opening Name",
         "S_Fishery" = "S Fishery",
         "OpeningDate" = "Opening Date",
         "Closing Date" = "Closing Date",
         "ChumCatch" = "Chum") %>%
  mutate(OpeningDate = ymd(as.POSIXct(OpeningDate, format = "%m/%d/%Y", tz = "US/Alaska")),
         OpeningMonth = month(OpeningDate), 
         StatWeek = statweek(OpeningDate)) %>% # This uses the custom statweek function
  filter(District <= 116, between(StatWeek, 20, 40))



inseasonharvest %>%
  group_by(Year, StatWeek, District) %>%
  summarise(ChumCatch = sum(ChumCatch)) %>% 
  ggplot(aes(x = StatWeek, y = ChumCatch, color = as.factor(Year))) +
  geom_line() +
  facet_wrap(~District, scales = "free_y")



