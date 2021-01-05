# R Intro ADF&G
# Justin Priest
# justin.priest@alaska.gov

#####        SCRIPT 3        #####
##### WORKING WITH YOUR DATA #####


## DIRECTORIES ##
# The working directory is the folder where R starts looking for files (once you tell it)
# Note that if you're using an RProject, your directory is set automatically

getwd() # Show which working directory we're in
setwd("C:/Users/username/Desktop") # Use this to set your working directory (if needed) changing to correct folder
# Note that R uses a forward slash instead of the backslash you might be used to 
# If you want to use a backslash, add two of them together
# "C:/Users/username" becomes "C:\\Users\\username"

# We won't cover it today but I *highly* recommend using package "here" to find your files
# Never, ever just paste data into R if you want to reproduce it! (Fine for short-term analysis)



## PACKAGES ##
# A package is just a group of functions/commands added together to add more usefulness
# With no extra packages loaded, R has a lot of usefulness but MANY more features are available

# For example, let's say that you want to perform non-linear modeling. Base R doesn't have this!
# So you research other packages for this and find that "mgcv" has the commands you want
# Once you install "mgcv", you can load it anytime you have a script. 
# Next, you'll load "mgcv". Now you can use gam() to fit a generalized additive model

# Remember, you install a package once. You load a package every time you restart R. 

# By convention, we add packages to the top of a script. 
# This makes your script more readable & others can see if they have all required packages 


# If you don't yet have a package, you can install it by running
install.packages("NewPackageName") # Replace NewPackageName with whichever package you want
# Once you install a package, you don't need to do this again (until you update R)
# After a package is installed, to use it, we need to call it every time we open R and want to use it
# To load the library, use:
library(NewPackageName)

# Notice that there are quotes around the package name for installing, but not required for library()

# To call a specific function from a specific package, use two colons: packagename::function()
# Why would you do this? Maybe the exact same function name is used in two different packages. 
# For this reason, only load the packages you need
# The most common use of this is the command "select" from dplyr. 






## DATA STRUCTURE ##

exampledf <- data.frame(sex = c("Male", "Male", "Female", "Male", "Female", "Female", "Male", "Male", "Female"), 
                        length = c(110, 112, 90, 89, 107, 104, 98, 102, 92), 
                        weight = c(3, 3.4, 2.4, 2.5, 3.0, 2.9, 2.8, 2.8, 2.3),
                        age = c(2, 2, 1, 1, 2, 2, 2, 2, 1),
                        statarea = c(115, 115, 101, 115, 115, 101, 115, 115, 101))

exampledf
head(exampledf) # head() is a good way to see the data
head(exampledf, n=5) 
# by adding a comma, we can use an "argument" to head(), changing the default rows shown
?head

# It is also extremely helpful to know the structure of the dataframe
str(exampledf)
# We see that the sex column is a character and all others are numerical
# The "character" type is for comment strings. We will want to change this to be a "factor". 
# A factor is just a type of categorical variable (unordered)
# You might also notice that statarea probably should *not* be a numerical quantity as well
# So let's change statarea and sex to both be factors

exampledf$sex <- as.factor(exampledf$sex)
exampledf$statarea <- as.factor(exampledf$statarea)

str(exampledf)

# Now our data is organized with two categorical variables (sex, statarea) and
# three numerical variables(length, weight, age). Age could be also be a
# category, depending on analysis

# View the data again
exampledf
# We can see that each row is a specific individual fish and applies to only one observation
# This is an example of tidy data and will make analysis easier later
# To the extent possible, try to avoid using tabled or summarized data. 



## DATA TYPES ##
# It is *very* helpful to understand the different types of your data.
# This is something that we're all aware of, but don't often think about explicitly. 
# In general, most data are one of three types of variables: categorical, continuous, or discrete
# Categorical data are a non-numerical category (e.g., species, color, river)
# Continuous data are an number that isn't a count or only integers (e.g., length, time)
# Discrete data are like a hybrid: numbers that can't be split (e.g., count of fish)



## SUMMARIES! ##
# Real quickly, let's just do some quick assessment of our example dataset
summary(exampledf)
plot(exampledf$length, exampledf$weight)
plot(exampledf$age, exampledf$weight)
plot(exampledf$sex, exampledf$weight)
plot(exampledf$statarea, exampledf$weight)
hist(exampledf$length, main = "Histogram of fish lengths")

example_model <- lm(weight ~ length, data = exampledf)
summary(example_model)

# Pretty neat and quick! Now, let's try this with something that is more applicable to us: REAL DATA!


## DATA IMPORT ##

library(tidyverse)

groundfish <- read_csv("data/OceanAK_GroundfishSpecimens_2000-2020.csv") # Read in file from folder "data"
groundfish <- rename(groundfish,"length_mm" = "Length Millimeters", "weight_kg" = "Weight Kilograms") 
groundfish <- dplyr::select(groundfish, Year, Species, Sex, Age, length_mm, weight_kg) 
groundfish <- filter(groundfish, Species == "Sablefish")
groundfish
# These lines do the following:
# Read in file from folder "data", rename two columns, 
# Select just a few columns dropping others, and filter to only include sablefish
# Note that functions "read_csv", "rename", "select", and "filter" are all from the tidyverse
hist(groundfish$length_mm)
plot(groundfish$length_mm, groundfish$weight_kg)
plot(groundfish$Age, groundfish$length_mm)
plot(groundfish$Sex, groundfish$length_mm) # Why doesn't this line of code work??
plot(as.factor(groundfish$Sex), groundfish$length_mm)

plot(log(groundfish$length_mm), log(groundfish$weight_kg))

summary(lm(log(length_mm) ~ log(weight_kg), data = groundfish))



## BONUS: FUNCTIONS ##
# To understand packages, it might be helpful to see how to set your own function. 
# The below function is something we make and we call it "addtwonumbers"
# A package is just a collection of new functions to give us new usability
addtwonumbers <- function(x1, x2){
  x1 + x2
}
addtwonumbers(5, 12)
