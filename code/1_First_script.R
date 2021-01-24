# R Intro ADF&G
# Justin Priest
# justin.priest@alaska.gov

##### SCRIPT 1 ####
##### ABOUT R #####



# Welcome to R! 
# First off, you should know that a hashtag/pound sign means that every thing to the 
#  right of it is *not* code. R ignores this but we can leave notes to ourselves!


# You are reading this script in the "editor" pane of RStudio
# If you have the default setup, below this is the "console"
# This whole document in the editor is a "script" and can be edited and saved


# R works by running functions which are a specific evaluation of data
# A package is just a group of new functions that you can load in
# You can evaluate your function to save it as an "object", most commonly a variable


# Let's try that now! Evaluate the following lines by clicking "Run" to upper right
# Or you can type ctrl+Enter (CMD+Enter)
myvariable = 1 
myvariable
# Note that this printed to your console AND it's saved in your "Environment" 
# Look at the pane in the upper right and you'll see "myvariable" there


# There are more complicated objects. Let's make a vector by using the function c()
# Everything that we put inside the brackets will be separated by commas
# c is the concatenate function in R and squishes everything together
myvector = c(1, 3, 5, 7, 9)
myvector
c(2, 4, 6)   # Note that this prints to the console but doesn't save
mynewvector = c("Adult", "Juvenile", "Adult", "Adult")
mynewvector
# Now let's make a "factor" which is a categorical grouping
factor(c("Male", "Female", "Female"))

# Most commonly we'll use dataframes which are kind of like a bunch of vectors together
mydf = data.frame(col_name1 = c("Male", "Female", "Female"), col_name2 = c(130, 115, 120))   
mydf
# It's OK to break to the next line. On the line above, press enter after a comma
# Line breaks MUST be after a comma or something equivalent
# Also, look to the "Environment" pane, click on "mydf" over there. Very cool huh
# I think of dataframes like a spreadsheet with columns and rows.

# But note that things need to be of equal lengths. Watch for the error message 
data.frame(new1 = myvector, new2 = mynewvector)
# myvector was 5 "units" long while mynewvector was 4 units long. 
# R doesn't let you make a mistake

# So far we've only set things using an equals sign. More commonly we use an arrow "<-"
# You can't use <- inside a function ever, so that's why we keep these separate 
myvector <- c(2, 4, 5, 8, 10)
myvector 
# Note that we've overwritten "myvector" now. This can be dangerous. 
# As such, it's considered poor practice to reuse variables, always make a new one

# Have you noticed so far that R is case sensitive? 
# What do you think will happen next? Make your predictions, then run the next 2 lines:
Myvector
Factor(c("Male", "Female", "Female"))

# Note that our script is sequential, but it doesn't *have* to be. 
# If you went above and changed myvector to Myvector, it would run. 
# You could also save variables in the console (BUT DON'T DO THIS)



# Now let's subset a part of a vector. Square brackets tell us to take a certain element
# For our vector, if we want the 4th element of it, we'd do the following:
myvector[4]

# What about for our dataframe? What do you predict will happen?
mydf[4]
# Because we have rows AND columns, there is no single 4th element
# We can specify by mydf[rownumber, columnnumber]
mydf[1,2]
mydf[,2]
# This shows the whole column
# For dataframes, an easier way to specify this is using $
mydf$col_name1


# Grammar to note for later: 
# - We use double equals "==" to check for equivalency (not the same as setting equal to, "=")
# - The exclamation point "!" means "not", ampersand "&" means "and", bar "|" means "or"

# To inspect the structure of a dataframe use str()
str(mydf)
# This is very useful to make sure that we've set the column types correctly
# Sometimes to clean things up we use rm() to remove an object
rm(myvector)
# Bye bye myvector. So long and thanks for all the fish



# This code randomizes the order of the items we tell it:
sample(c("Nathan", "Steve", "Julie", "Andy", "Jason", "Tessa", "Whitney", 
         "Willa", "Jake W", "Jake M", "Chris", "Cathy"))









