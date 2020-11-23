# R Intro ADF&G
# Justin Priest
# justin.priest@alaska.gov

#####     SCRIPT 5    ####
##### GGPLOT2 CHARTS #####

library(tidyverse)
library(lubridate)

# For the ggplot exercises we'll be using two datasets: 
#   - pink salmon sex ratio and 
#   - coho salmon escapement over time

# First read in the data, clean it up minorly, and view it
pinksalmonratio <- read_csv("data/OceanAK_PinkSalmonRatio_2000-2020.csv") %>%
  rename("statweek" = "Stat Week",
         "percentmales" = "Percent Males") 
pinksalmonratio

cohoescapement <- read_csv("data/SEAK_Coho_Escapement_1972-2019.csv")
View(cohoescapement)


# Basic plotting in R is done using plot()
plot(percentmales ~ statweek, data = pinksalmonratio %>% filter(statweek <40))
# Plotting can be done in base R though most users find it much easier to plot in ggplot2
# We will now ignore just using plot() but it's very useful for a very quick chart!


# The first thing to know about ggplot is the aes() argument within ggplot()
# aes() is simply where we set the aesthetics such as which column is:
# - x axis   - y axis   - grouping variable   - line/point color   - the bar/area fill color

# The other basic part of ggplot is that different chart elements (types) are set by "geom_xxxx"
# To set a line chart, use geom_line(), a bar chart is geom_col(), scatterplot points geom_point()

# Different from other R code is that lines of ggplot code are separated by a +


###########################
#### 1 - GGPLOT BASICS ####
cohoescapement %>%
  ggplot(aes(x = Year, y = Escapement_Count, group = River)) +
  geom_line()

cohoescapement %>%
  ggplot(aes(x = Year, y = Escapement_Count, fill = River)) +
  geom_col()

cohoescapement %>%
  ggplot(aes(x = Year, y = Escapement_Count, color = River)) +
  geom_point()

# Note the Warning message in your console. It is telling us that there are NAs that are skipped

# We can also change the y-axis to easily accommodate a log scale
cohoescapement %>%
  ggplot(aes(x = Year, y = Escapement_Count, group = River, color = River)) +
  geom_line() +
  scale_y_log10()



# For the following charts, let's just focus on a few systems
cohoescapement_sub <- cohoescapement %>%
  filter(River == "Auke Creek" | River == "Hugh Smith Lake" | River == "Montana Creek")

# As a review the above is the same as: 
cohoescapement_sub <- cohoescapement %>%
  filter(River %in% c("Auke Creek", "Hugh Smith Lake", "Montana Creek"))



# We can also save our chart as an object. 
# I *usually* don't do this, but here it will make it more clear as we add items one by one
# We will want to make a line chart, with different lines and colors for each river
cohochart <- cohoescapement_sub %>%
  ggplot(aes(x = Year, y = Escapement_Count, group = River, color = River)) +
  geom_line(size = 1)
cohochart

# Note that we aren't just limited to one geom. Some geoms are compatible with each other!
cohochart + geom_point() # For this exercise, we won't save it and we'll just use lines



##########################
#### 2 - MODIFY THEME ####

# Now we'll add two things: first we'll adjust the y-axis title and then we'll change the theme
# Themes are like they sound: a default selection of design choices for us
# start typing "theme_" and look at the auto-complete suggestions, then try out a few! theme_bw() is nice 
cohochart <- cohochart +
  labs(x = "", y = "Escapement", title = "Escapement Over Time") + # labs is short for labels; change x, y, and title here
  theme_minimal() 
cohochart

# The main theme() is where the chart settings are saved. 
# To change the defaults on these, I almost always have to google what to do
cohochart <- cohochart + 
  theme(legend.position = c(0.3, 0.8),  # This setting adjusts the legend to be inside the chart at x=0.3 and y=0.8
        legend.title = element_blank()) # We also can remove the legend title
cohochart



#####################################
#### 3 - SCALES: CHANGE ELEMENTS ####

# Now we'll learn about a new ggplot element "scale_"
# The scale is where you can control the default values for each aesthetic 
# For example, do you want specific breaks along the y axis? Should a thousands comma be present?
# Do you want a different color scheme?
cohochart <- cohochart +
  scale_color_manual(values = c("black", "cornflowerblue", "darkgray")) +
  scale_y_continuous(breaks = c(500, 1000, 1500, 2000, 2500, 3000, 3500, 4000), labels = scales::comma) +
  scale_x_continuous(limits = c(1980, 2020)) # Careful with limits though! It REMOVES data outside your specs
cohochart



###############################
#### 4 - OTHER CHART TYPES ####

# Points w/ linear model
cohoescapement_sub %>%
  ggplot(aes(x = Year, y = Escapement_Count, group = River, color = River)) +
  geom_point() +
  geom_smooth(method = "lm")


# Columns
cohoescapement_sub %>%
  ggplot(aes(x = Year, y = Escapement_Count, group = River, color = River)) +
  geom_col()
# What just happened here? Well it turns out that there are multiple things to color
# "color" refers to points and lines. What we want is "fill"

cohoescapement_sub %>%
  ggplot(aes(x = Year, y = Escapement_Count, group = River, fill = River)) +
  geom_col()

# Or if we wanted, we could show the columns plotted side by side (but this is a poor visualization of this!)
cohoescapement_sub %>%
  ggplot(aes(x = Year, y = Escapement_Count, group = River, fill = River)) +
  geom_col(position = "dodge") #position = "dodge" makes the columns side by side

# What about putting a non-number as the x-axis?
cohoescapement_sub %>%
  ggplot(aes(x = River, y = Escapement_Count, fill = River)) +
  geom_boxplot()



######################
#### 5 - Faceting ####

# Remember the pink salmon sex ratio dataset?
pinksalmonratio

ggplot(pinksalmonratio, aes(x=statweek, y = percentmales, color = Year)) +
  geom_point() +
  scale_x_continuous(limits = c(25, 38))



ggplot(pinksalmonratio, aes(x=statweek, y = percentmales, color = District)) +
  geom_point() +
  scale_x_continuous(limits = c(25, 38)) + 
  facet_wrap(~Year)







## Finally, let's use a completely different dataset 

hughsmithesc <- read_csv("data/SEAK_Coho_HughSmithDailyEscapement_1982-2019.csv") %>% #read data
  rename("obsdate" = "Obs Date",                                      # rename variables
         "count_type" = "Weir Count Type") %>%
  mutate(obsdate = ymd(as.POSIXct(obsdate, format = "%m/%d/%Y", tz = "US/Alaska")), # create a date object
         stddate = as.Date(paste0(day(obsdate), "/", month(obsdate), "/", 2020), #combine the day/month/year 
                           format = "%d/%m/%Y", tz = "US/Alaska")) %>% 
  filter(Maturity == "Adult", # there weren't any jacks but good to stay safe! 
         stddate > as.Date("8/1/2020", format = "%m/%d/%Y")) %>%  # Remove early season
  dplyr::select(Year, obsdate, stddate, everything()) %>% # Reorder the columns for ease of reading
  group_by(Year) %>%                    # We haven't discussed group_by() yet
  mutate(cummcount = cumsum(Count)) # This gets us a cumulative sum by year
hughsmithesc  # View dataframe. Check data types


hughsmithesc %>%
  ggplot(aes(x=stddate, y = cummcount, group = Year)) +
  geom_line(color = "darkgray", size = 1.25) + 
  geom_line(data = . %>% filter(Year == 2019), color = "red1", size = 1.25) +
  theme_minimal()
# This made a line plot with each year a different line. 
# Then we added a line geom with only one year (2019) on top, and made it red


hughsmithesc %>%
  ggplot(aes(x=stddate, y = cummcount)) +
  geom_line(size = 1.25) + 
  theme_minimal() +
  facet_wrap(~Year)
















