##################################
## Boluwatife Awoyemi
###################################

library(ggplot2)
library(dplyr)
library(stringr)
library(tidyr)

## This is a data from the United Nations for age-specific fertility rate of 
## women from 201 countries in the world. It has data on five-year age groups
## [15 - 49] and this data was computed in different ways and processed from 
## various sources like census, survey, etc.
##
## Reference: Chavez, I. (2022, June 12). World Fertility Data - United Nations
##            Dataset. Kaggle. Retrieved May 1, 2023, from
##            https://www.kaggle.com/datasets/ivanchvez/fertility 

###################################
## Step 1: Data organisation
###################################

## I imported the data set.
world_fertility <- read.csv("ASFR.csv", stringsAsFactors = FALSE)

## I called this data organisation because I barely did any cleaning. This data
## has 17 columns and 60,000+ rows and of those 17 columns, the last three (3) 
## columns are the only ones with missing values.


# With this next line of code, I changed all column names of the data to 
## lowercase.
names(world_fertility) <- tolower(names(world_fertility))

## Next,
## I decided on the columns I would like to keep so that I can take out the 
## columns I know I will not be using at all. 
## I settled for six columns, country, age group, year, value, data type, and 
## data source type. I chose these columns because they seem to be the best
## candidate for proper analysis and they can give good information on what the
## data actually means. In the course of this work, I use only 5 of these
## columns.
## I deleted the other 11 columns. 


## This line deletes the columns I will not be using.
world_fertility <- world_fertility %>% select(-c(2, 4, 7, 10:17)) 


## The names of some columns were ambiguous so I renamed all columns using the
## colnames() function. I thought of other ways but this method is the most
## efficient in naming multiple columns.
colnames(world_fertility) <- c("country", "age_group", "year", "value", 
                              "data_type", "source_data_type")

## Now, before further analysis, does this data still have any missing values?
unique(is.na(world_fertility))
## The columns I am working with have no missing values.


###################################
## Step 2: Function Application
###################################

## The years in this data frame are in decimals, i.e. they take into account the
## month (and day).
## My next task is to take out the decimal part of each year, put it in a new
## column "month" and convert the numbers to actual month names.


## This next line copies the decimal part of each year and places this in the 
## equivalent year position of a new column I named "month". This line means 
## integer-divide year by 1 and return the remainder. This is why it accurately
## returns and places the decimals in the new column and returns 0 for whole 
## number years. My initial attempt was that I used str_extract() but it copied
## the entire year whenever a year was a whole number. That would require extra 
## steps. 
world_fertility$month <- world_fertility$year %% 1

## After making the "month" column, I fixed the year column by taking out the 
## decimals. The floor() function does this accurately by returning the actual 
## integer years. 
world_fertility$year <- floor(world_fertility$year)

## This is an alternative for the preceding line of code.
## world_fertility$year <- str_extract(world_fertility$year, "[0-9]+")


## Next, I convert the months to actual months. 
## I started by writing a function "decimalToMonth(). This function accepts one
## input argument-a numeric vector of length 1, converts the vector to month
## with a simple calculation, assigns the answer to a month name and returns the
## month name.

## decimalToMonth: Converts decimals to months. 
##                
##    Args:
##      x = a numeric vector of length 1.
##      
##    Returns:
##      a character vector of any of the 12 months. 

decimalToMonth <- function(month) {
  ## Function requires one input argument.
  
  month <- month * 12
  ## Since month is a decimal formerly associated with a year, we only need to 
  ## multiply by 12 to convert to month. That is (0.xxx year/1 year) * 12 months.
  
  month_name <- c("January", "February", "March", "April", "May", "June", "July",
                  "August", "September", "October", "November", "December")
  ## This makes a vector of month names for easy allocation.
  if (0 <= month && month <= 1) {
    ## I worked it out on paper and arrived at how to allocate the values. 
    ## The line above means that if the calculated month is between 0 and 1, 
    return(month_name[1])
    ## the month is January. 
  }
  if (month > 11) {
    ## Similarly, if the month is greater than 11
    return(month_name[12])
    ## the month is December. Clearly, since 0 is for January, December stops 
    ## once the month hits 12 which is already labeled as 0.
  }
  for (i in 1:(length(month_name) - 2)) {
    ## The for loop takes care of every month left. We already handled the case
    ## with January and December, only 10 months left. So, the for loop says for
    ## any number i between 1 and 10 (inclusive),
  if (i < month && month <= i + 1) {
    ## if the month value is greater than this number i or less than or equal to
    ## the next number i + 1,  
    return(month_name[i + 1])
    ## return the month in the position of the i + 1.
  }
  }
}

## Then, I applied the function to the entire month column in the world 
## fertility data set.
world_fertility$month <- sapply(world_fertility$month, decimalToMonth)


## I wrote these commented lines to confirm the presence of 12 months with no 
## missing value.

## unique(world_fertility$month)
## unique(is.na(world_fertility$month))

###################################
## Step 3: Plot and Analysis.
###################################

## In this data set, the value is the Age-Specific Fertility Rate (ASFR) and this 
## is the annual number of births by women of the specified age group per 1,000
## women in that age group.
##
## Task 1:
## I plan to make a figure of the average age-specific fertility rate of all 
## age-groups across all years based on recent births.

## I will be making a line plot with x(year), y(value), and color(age_group).


## I made a new data frame with a name sequence age specific fertility rate 
## reported as recent births.
## I grouped by age_group and year, arranged the year in ascending order (not so
## necessary), subset these classes of data that are data type "Recent births",
## and used the summarise_at function to average the values of each year so that
## the average value of a year across all countries is reported for each age_group.
## This is why the data frame contains 434 rows because there are 7 age groups 
## and 62 unique years in the recent births report. 
agespecificfr_RB <- world_fertility %>% group_by(age_group, year) %>% 
  arrange(year) %>% subset(data_type == "Recent births") %>% 
  summarise_at(vars(value), list(value = mean))

## I defined the axes that I used for both plots in this work.
## Without the breaks, the x-axis returns four x ticks. I wanted to see more year
## labels so I defined the breaks along with the axis labels.
axes <- list(
  scale_x_continuous("Year", breaks = c(1950, 
                                1960, 1970, 1980, 1990, 2000, 2010, 2020)), 
  scale_y_continuous("Average Births Per 1000 Women")
)

## I also defined the plot styles I use for the two plots I have in this work.
## With the theme() function, I made my plot title a centered (using hjust), bold
## and italicized red text and I also made my x and y axis labels bold.
plot_style <- theme(plot.title = element_text(color = "red",
    face = "bold.italic", hjust = 0.5), axis.title.x = element_text(face = "bold"), 
    axis.title.y = element_text(color = "black",
    face = "bold"))

## In my ggplot call, I used the newly created data frame to plot my year on the
## x axis and fertility rates on the y axis using the line plot. I gave my plot 
## a title and then applied my plot style and axes.
ggplot(agespecificfr_RB, aes(year, value, color = age_group)) + geom_line() +
  ggtitle("Fertility Rates of Different Age Groups") + 
  labs(color = "Age Group") + axes + plot_style

## What does the figure tell me?
## Over the years, the fertility rate of all the years decline. 
## As expected, due to the natural wiring of women, the 40-49 age group
## stay cycling in the lowest fertility rate region. 
## Women within 20-34 years give birth to the most children and they cycle and
## decline together within each others' space. Though, it looks like the 25-29 
## age group is in the lead almost till 2020 compared to all the age groups with 
## 20-24 being a close runner up.


## Task 2:
## I want to know the top 5 countries with the lowest ASFR reported in any year.
## Therefore I made a data frame that took the country column, checked for the
## smallest fertility rate reported by country and their corresponding year.
## After this, I arranged the values in ascending order.
bycountry_ASFR <- world_fertility %>% group_by(country) %>% summarize(value = 
  min(value), country = country[which.min(value)], year = 
    year[which.min(value)]) %>% arrange(value)

## Then, I grabbed the top 5 countries because these are the countries that 
## clearly report the least fertility rate in any year. Since the first 19 rows 
## report 0 fertility rate, the definition of my top5 countries becomes 
## literal, the top 5 rows of the data frame with countries that reported the 
## lowest fertility rate in any year. 
lowest5_country <- head(bycountry_ASFR$country, 5)                                                       

## Using a line plot, I want to answer the question: 
## How did the ASFR of these countries change over the years?

## To answer the question, I made a data frame that takes the country and year 
## columns while grouping by country, I subset by matching all of these 5 
## countries appearance in the world fertility data, I arranged the years in 
## ascending order (again, unnecessary), and I found the average births per 1000
## women in each year.
lowest5_country_ASFR <- world_fertility %>% group_by(country, year) %>% 
  subset(country %in% lowest5_country)  %>% arrange(year) %>% 
  summarise_at(vars(value), list(value = mean))

## In my ggplot call, I used the new data frame to plot my year on the
## x axis and fertility rates on the y axis with lines like the previous plot.
## I gave the plot a title and then applied my plot style and axes.
ggplot(lowest5_country_ASFR, aes(year, value, color = country)) + geom_line() +
  ggtitle("Fertility Rates for Specific Countries") + labs(color = "Country") +
  axes + plot_style

## What does the figure tell me?
## Albania starts with the highest average rate in 1950 and plunges very fast. 
## Aruba has no rate reported after year 2000 even though it is the country that
## seemed to show a bit of a stable behavior alongside Barbados. Barbados also
## stops having a report sometime between 2020 and 2005 after seeing a slight 
## increase in average fertility rate.
## The other countries stop having reports sometime between 2015 and 2020.
## Altogether, the average rate of all these countries mostly declined with each 
## passing year.
