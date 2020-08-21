# R Intro ADF&G
# Justin Priest
# justin.priest@alaska.gov

#####      SCRIPT 2      ####
##### PROGRAMMING BASICS #####





# Things that fail:
c(1,2,3,4, five) # Why did this fail?
























# SAFETY TOOLS
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

  