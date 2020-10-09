# R Intro ADF&G
# Justin Priest
# justin.priest@alaska.gov

#####     SCRIPT 5    ####
##### GGPLOT2 CHARTS #####

library(tidyverse)

# Plotting can be done in Base R though most users find it much easier to plot in ggplot2


cohoescapement <- read_csv("data/SEAK_Coho_Escapement_1972-2019.csv")
View(cohoescapement)

# The first thing to know about ggplot is the aes() argument within ggplot()
# aes() is simply where we set the aesthetics such as which column is:
# - x axis   - y axis   - rouping variable   - line/point color   - the bar/area fill color

# The other basic part of ggplot is that different chart elements (types) are set by "geom_xxxx"
# To set a line chart, use geom_line(), a bar chart is geom_col(), scatterplot points geom_point()

# Different from other R code is that lines of ggplot code are separated by a +


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


cohoescapement_sub %>%
  ggplot(aes(x = Year, y = Escapement_Count, group = River, color = River)) +
  geom_line(size = 1) +
  labs(y = "Escapement") +
  theme_minimal() +
  theme(legend.position = c(0.3, 0.8))


