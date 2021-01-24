# R Intro ADF&G
# Justin Priest
# justin.priest@alaska.gov

#####  MOTIVATING EXAMPLE 1  #####
#####       Pink Ratio       #####

# Difficulty: Moderate

library(tidyverse)
library(lubridate)



pinkratio <- read_csv("data/OceanAK_PinkSalmonRatio_2000-2020.csv") %>% 
  rename("PercentMales" = "Percent Males",
         "SampleSize" = "Sample Size",
         "StatWeek" = "Stat Week",
         "CatchDate" = "Catch Date",
         "FishWeight_lbs" = "Fish Weight Pounds",
         "NumberFishWeighed" = "Number of Fish Weighed") %>%
  mutate(CatchDate = ymd(as.POSIXct(CatchDate, format = "%m/%d/%Y", tz = "US/Alaska")),
         CatchMonth = month(CatchDate),
         PercentMales_01 = PercentMales / 100) %>%
  filter(StatWeek < 40)
pinkratio


pinkratio %>%
  ggplot(aes(x=StatWeek, y=PercentMales)) +
  geom_point(alpha = 0.5) + 
  #gghighlight::gghighlight(Year == 2019) +
  geom_smooth(formula = y ~ exp(x / (1 - x)), method = "lm") +
  geom_point(data = pinkratio %>% filter(Year == 2020), color = "orange")



summary(glm(PercentMales_01 ~ StatWeek + Year, family = "binomial", data = pinkratio))


pinkratio %>%
  ggplot(aes(x=as.factor(District), y=PercentMales, fill = as.factor(District))) +
  geom_boxplot()



1 / (1 + exp(-1*(x-0.5)) )
100 / (1 + exp(-10*(x-30)) ))





