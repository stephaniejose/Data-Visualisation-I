#12/03/2024
#Workshop 8
#Data visualisation I

#geoms - the geometic objects that display our data e.g. geom_point
#geoms have features which are called aesthetics. The features are their position along the x- and y-axis, their shape, size and colour 

install.packages("palmerpenguins")
install.packages("tidyverse")

library(palmerpenguins)
library(tidyverse)
library(dplyr)

#Have a look at the penguins dataframe
#Th dataframe has a number of different measurements for three penguin species across three different islands 
View(penguins)

ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g))

#There seems to be a correlation, but there is also what looks like a cluster that is shifted towards the bottom right of the graph
#Could those be species differences?
#Check by mapping species to the aesthetic colour of geom_point 
ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g, colour = species))

#Does the cluster also correlate with the island the penguins are from? 
ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g, colour = island))

#We can add additional layers to our plot by specifying additional geoms
ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_smooth(mapping = aes(x = bill_length_mm, y = body_mass_g)) #adds a trend line over an existing plot

#We can improve the code above
#We don't have to repeat the mapping of variables if we use the same ones in different layers 
#We can pass to ggplot() which means that they will b inherited by the geoms that follow:
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point() +
  geom_smooth()

#The data falls into three species clusters so it is hard to distinguish them
#Map the species to 'colour'
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species)) +
  geom_smooth()

#The curve is going across all three species
#This is because mappings are only inherited from ggplot(), not between geoms 


#Copy and fix the code above, so that each species has its own fitted curve
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species)) +
  geom_smooth(mapping = aes(colour = species))

#You can now assign the plot to a variable and other layers later
pengu_plot <-
  ggplot(data = penguins,
         mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(aes(colour = species)) +
  geom_smooth(aes(colour = species))

#We can add layers to our plot
pengu_plot +
  geom_smooth()

#Write code to produce the following plot in order to get a linear model

?geom_smooth
?geom_point

linear_penguin_model <- ggplot(data = penguins,
                               mapping = aes(x = bill_length_mm,
                                             y = bill_depth_mm)) +
  geom_point(aes(colour = species, shape = species)) + #shape = species makes the shapes 
  geom_smooth(aes(colour = species),
              method = lm, #'lm' changes the lines to linear
              se = FALSE) #se = false removes the grey outline (confidence intervals)

linear_penguin_model

#[3] SAVING PLOTS

#We can save our plots to a file using 'ggsave'
#We can either give ggsave a plot variable:
ggsave(filename = "penguin_plot_1.png", plot = pengu_plot)

#Or if we don't pass it a variable it will save the last plot we printed to the screen:
pengu_plot +
  geom_smooth()

ggsave("penguin_plot_2.png")

#Look at the documentation for ggsave; save your latest plot with the linear model lines as 200mm x 300mm png
#smallest value is the height and larger value is the width
ggsave(filename = "linear_penguin_plot.png",
       plot = linear_penguin_model,
       width = 300,
       height = 200,
       units = c('mm'))

?ggsave

#[4] Continuous versus categorical variables
#Which geom we need to use depends on the type of variable we'd like to map to the x- and y- coordinates 
#E.g. if we would like to investigate body_mass for each species, we can use box plots
ggplot(data = penguins,
       mapping = aes(x = species, y = body_mass_g)) +
  geom_boxplot(mapping = aes(colour = species))
#mapping species to colour in geom_boxplot() only changes the colour of the lines

#Change the code, so that it fills the boxes with colour instead of the lines
ggplot(data = penguins,
       mapping = aes(x = species, y = body_mass_g, fill = species)) + #fill = species makes the boxes have a colour as well as the outline
  geom_boxplot()#the default line is black so there is no need to include "colour = species"

#We often want to determine the order in which we display our data. This is where factors come in handy 
#Categorical variables that have a defined and known set of values, for example the three species in penguins, can be defined as factors
#Factors have levels which are essentially rank positions for each unique value 
#by default, levels are in alphanumericala order, that's why three species appear in alphabetical order in the above plot

#Look at penguins using both head() and str(). Where can you see which variables are factors? What additional information does str() show you?

head(penguins)
str(penguins)
#the factors are 'species', 'island' and 'sex'
#it shows there are 3 levels for both species and island and there are 2 levels for sex 

#Here is an example where alphabetical order would be annoying
df_days <-
  data.frame(day = c("Mon", "Tues", "Wed", "Thu"),
             counts = c(3, 8, 10, 5))
df_days$day <- as.factor(df_days$day)
str(df_days)

ggplot(data = df_days, mapping = aes(x = day, y = counts)) +
  geom_col()
#the order it shows in the plot is 'Mon' 'Thu' 'Tues' and 'Wed'

#We can correct the above by changing it to a factor:
df_days$day <- factor(df_days$day, levels = c("Mon", "Tues", "Wed", "Thu")) #it is already a factor so there is no need to use 'as.factor()'
str(df_days)

ggplot(data = df_days, mapping = aes(x = day, y = counts)) +
  geom_col()

#Write the code to reproduce this plot. You'll have to use the data visualisation cheat sheet to find the correct geom

penguins$species <- factor(penguins$species,
                           levels = c('Chinstrap', 'Gentoo', 'Adelie'))
str(penguins)

ggplot(data = penguins, mapping = aes(x = species,
                                      y = body_mass_g, fill = island)) + #the legend is filled with the 'island' 
  geom_violin() 

#[5] Statistical transformations
#Our dataframe does not contain the median, 25th percentile, 75th percentile, etc for body_mass_g, but the geom calculates that 

#Here is an example
ggplot(data = penguins) +
  geom_bar(mapping = aes(x = species)) +
  coord_flip() 

#Our dataframe does not contain the counts of penguins for each species
#geom_bar() calculates those

#Have a look at the documentation for geom_bar. What is the difference between geom_bar() and geom_col()? Also, what does coord_flip() do?

#geom_bar() makes the height of the bar proportional to number of cases in the group i.e. counts how many there are 
#geom_col() this takes two variables from the data instead of just one and compares them 

#coord_flip() converts the display of y conditional on x, to x conditional on y

#Have a look at the plots. What is the difference? Can you find the geom to reproduce these plots and the geom argument to switch between the two?
#Bonus credit: The bars are slightly transparent. Can you find the argument to change transparency?

#They changed the intervals in the y-axis nad this creates more overlap in the RHS graph
#'alpha=' changes the transparency, 0 being transparent and '1' is opaque
#geom_histogram is used. The RHS is stacked and shows where the values overlap from the LHS
#THe LHS is identity and the RHS is stacked 

#[6] Plotting only a subset of your data: filter()
#In order to look at a subset of data filter() is used. For example you may want to look at penguins of two of the species only. 
penguins %>% filter(!species == "Chinstrap") %>%
  ggplot(mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species, shape = island))
#in the above code we used a miix of pipe ( %>% ) and '+', these can get commonly mixed up 
#we also don't need to tell ggplot() which data to use because we have piped the dataset into ggplot() already 
#filter() is extremely useful together with the function is.na() to get rid of pesky NA's

#Use is.na(sex) with filter() to reproduce the plot below, so that it only contains penguins where sex is known 
penguins$species <- factor(penguins$species,
                           levels = c('Adelie','Chinstrap','Gentoo'))
str(penguins)

penguins %>% 
  #filter(!is.na(sex)) %>% 
  ggplot(mapping = aes(x = species, y = body_mass_g, fill = sex)) +
  geom_violin()

filter_penguins