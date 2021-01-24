# R Intro ADF&G
# Justin Priest
# justin.priest@alaska.gov

#####      SCRIPT 2      #####
##### PROGRAMMING BASICS #####


## Basic Programming ##
# As we saw in the previous script, we can set things using an equals sign or the arrow

x1 = c(10, 8, 10, 12)
x1
x2 <- c(10, 8, 10, 12)
x2
# They're the same! For now though, set variables and everything using the left arrow


## Simple Math ##
# We can calculate simple math of our items
mean(x1)
median(x1)
log(x1)
sqrt(x1)
sum(x1)
# Notice how R is "vectorized". This just means that in a vector, it performs the action
#  on all of the individual items inside it. sum() and mean() work on the whole vector


## Subsetting & Dataframes ##
# As we saw before, brackets subset data
x3 <- c(2,4,6,8,10)
x3[5]


myfirstdf <- data.frame(sex = c("Male", "Male", "Female", "Female"), 
                        species = c("coho", "coho", "pcod", "herring"),
                        length = c(110, 112, 90, 82), 
                        weight = c(3, 3.4, 2.4, 2.1),
                        age = c(2, 2, 1, 1))
myfirstdf
# Now look in the "Environment" Pane in the top right. You should see 'myfirstdf' up there
# Click on myfirstdf and it will open in a new tab! The same thing in code is:
View(myfirstdf)
# You can sort or filter it here without changing anything


## Object Types ##
str(myfirstdf)



## Learning about a function ##
# Type a question mark before the function or search in 'Help' in the right bottom pane
?seq()







## Things that fail ##
c("one", "two", "three", five) # Why did this fail? It's looking for an object named five
c(1,2,3,4,5)) # An out of place parenthesis stops the code

data.frame(variable1 = c(1, 2, 3, 4, 5), variable2 = c(A, B, C, D, E))
data.frame(variable1 = c(1, 2, 3, 4, 5), variable2 = c("A", "B", "C", "D", "E", "F"))
# The above items fail because 1) variable2 calls object A, object B, etc and those don't exist
# and 2) because there are uneven columns 




## SAFETY TOOLS ##
# You should know how to stop things. 
# Two common issues are slow running code (e.g., complex model), or incomplete code.

# Slow code:
# Don't even try to read the following code. Run it and it will take forever.
# Just use this to practice getting out of a long running command. 
# Look for a tiny stop sign in the top right of the console
for(i in 1:10000){
  .z <- rnorm(5, i, 2)
  print(summary(lm(.z ~1)))
}

# Incomplete code
# Look at the below line. It's missing the closing parenthesis. 
# If you click run, it will try to run but fail. Note the "+" in the console.
# To escape this, click in the console, then press escape

c(1, 2, 3

  