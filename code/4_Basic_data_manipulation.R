# R Intro ADF&G
# Justin Priest
# justin.priest@alaska.gov

#####         SCRIPT 4        #####
##### BASIC DATA MANIPULATION #####

library(tidyverse)


# This section will rely heavily on using the package "dplyr" 
# You can do everything that we'll cover using just base R but it's often more cumbersome
# We'll cover more about dplyr and the tidyverse later


## WHY MODIFY DATA IN R ##

# When first starting out, it is very tempting to fix everything in Excel, then import it in R
# This is certainly acceptable when you're new and gets you to start analysis earlier. 
# However, it makes things longer if you'll ever have to add new data and re-do all the same changes
# For example, if data always comes out of OceanAK in a certain format and with different column names
# If you wanted to re-perform analysis when more data is available, doing these changes in R can save time



## THE PIPE ##
# One shortcut that comes with dplyr is the pipe operator. This is written as %>%
# The pipe passes the results of the object/function on the left to the function on the right
# This sounds complicated but makes code much more readable, and less repetitive

# Here's our code from before, in Base R
groundfish <- read_csv("data/OceanAK_GroundfishSpecimens_2000-2020.csv") # Read in file from folder "data"
groundfish <- rename(groundfish,"length_mm" = "Length Millimeters", 
                     "weight_kg" = "Weight Kilograms") 
groundfish <- dplyr::select(groundfish, Year, Species, Sex, Age, length_mm, weight_kg) 
groundfish <- filter(groundfish, Species == "Sablefish")

# Here's the same results but with the pipe
groundfish <- read_csv("data/OceanAK_GroundfishSpecimens_2000-2020.csv") %>% # Read in file from folder "data"
  rename("length_mm" = "Length Millimeters", 
         "weight_kg" = "Weight Kilograms") %>%
  dplyr::select(Year, Species, Sex, Age, length_mm, weight_kg) %>%
  filter(Species == "Sablefish")




# Notice how many more fewer times we had to write "groundfish"
# Another advantage is that all code is evaluated at once without running risk of lines being out of order

# When writing your own pipes, I HIGHLY recommend writing them line by line, one at a time. 
# This will let you know immediately which line isn't working

# One common mistake when first starting out is trying to pipe just one column. 
# The following will not work:
groundfish$Species %>% filter(Species == "Sablefish")



## KEEPING AND RENAMING COLUMNS  ##
# Often the first thing to do is to rename columns to be something more memorable and/or usable
# Use function rename() for this.
groundfish %>% rename("Species_common" = "Species")

# Another useful function allows you to keep or drop columns, using select()
# Because of a very rare (but highly frustrating) interaction, I always use dplyr::select()
groundfish %>% dplyr::select(Species, Age, length_mm) # Keep only the columns listed
groundfish %>% dplyr::select(-weight_kg) # Drop the columns listed, keep everything else



## FILTERING ##
# To remove extraneous data, we use the dplyr function filter() 
# We can use operators to keep (==), or remove (!=) rows that meet the conditions we set
groundfish %>% filter(Sex == "Female") # Single criteria
groundfish %>% filter(Sex == "Female", Age != 2, length_mm >= 200) # Multiple criteria
# The above row keeps groundfish data for only female fish that are not age 2, and greater than or equal to 200 mm


# One common issue is dealing with NAs
# Because an NA is essentially an unknown, we can't set a filter to be equal to an NA
# Here's an example: the sex of fish 1 and fish 2 is both unknown. 
# Is the sex of fish 1 equal to that of fish 2? It's unknown! 
# Therefore checking if something is equal to NA will always return an NA. 
# To get around this, we use the function is.na()

problemfish <- groundfish %>% filter(is.na(length_mm)) # Show rows where length is unknown
groundfish <- groundfish %>% filter(!is.na(length_mm)) # Remove rows where length is unknown


# We can also filter to a list of specified items using the shortcut "%in%"
# This helps keep your code much more readable if you have a long filter list!
keepyears <- c(2000, 2001, 2006, 2018)
keepyears
groundfish %>% filter(Year %in% keepyears)



## ADD A NEW COLUMN ## 
# We can also add new columns using mutate()
groundfish <- groundfish %>% mutate(weight_lb = weight_kg * 2.2) # Convert weight to pounds
groundfish

groundfish <- groundfish %>% mutate(comments = "Sample is good") # This makes the same comment in every row
groundfish

groundfish %>% mutate(grams_per_mm = (weight_kg * 1000) / length_mm)



# A slightly more complex approach can be to use an if else statement to conditionally set a value
groundfish <- groundfish %>% 
  mutate(biggie_smalls = ifelse(length_mm >= 600, "Big fish", "Small fish"))
groundfish
# This nested if statement checks if a fish is greater than or equal to 700 mm.
# If it is then it calls them "Big fish", otherwise they are "small fish"


# ifelse about NAs
# What about if we wanted to make a comment about whether the fish was aged?
groundfish <- groundfish %>% 
  mutate(comments = ifelse(is.na(Age), "Not aged", "Sample is good"))
View(groundfish)




## REPLACE A VALUE ##
# Commonly, we'll need to replace a character value with something else

groundfish %>% 
  mutate(biggie_smalls = recode(biggie_smalls, "Small fish" = "small and medium sized"))
groundfish %>% mutate(Sex = recode(Sex, "Female" = "F", "Male" = "M"))
groundfish

# Less commonly, previous biologists might have been slackers and used a blank to mean a zero
# That isn't true for this database (way to go Team Groundfish!). 
# But for the sake of learning, we'll cover it
# Function "replace_na()" from library "tidyr" has a function made just for this

groundfish_altered <- groundfish %>% mutate(Age = replace_na(Age, 0))
groundfish_altered

mean(groundfish$Age, na.rm = TRUE)
mean(groundfish_altered$Age, na.rm = TRUE)


## OTHER USEFUL FUNCTIONS ## 

distinct()
# Useful by itself for listing unique values of a variable
# E.g., in a column of vessel names, list all vessel names
# Won't go through this now, but can check this out later



#### EXPORTING ####
# While typically we want to just keep everything *in* R and only work on here, 
# often its worthwhile to export the data.

# The easiest way to do this is to use the function write.csv()
#write.csv(groundfish, file = "data/sablefishexport.csv")
