# Cleaning Assignment

[run_analysis.R](https://github.com/TheRiver/cleaning-assignment/blob/master/run_analysis.R)
is an R script that will take the spatial data obtained from a smartphone (see the code 
book for more information on this data), clean and summarise the data as a collection
of means grouped by the subject the data was collected from, as well as the activity
that subject was performing at the time.

## Files distributed with this assignment

1. *README.md*, which is this file, and describes how to run the code, as well
    as what the other files in the project are.
1. *CodeBook.md*, which describes the data. 
1. *run_analysis.R*, a script which reads in the data, cleans it, and outputs
    the clean data.

## The data
The data, and how to obtain it, is described in 
the [CodeBook.md](https://github.com/TheRiver/cleaning-assignment/blob/master/CodeBook.md). 

## Running the code

*run_analysis.R* depends on [plyr](http://cran.r-project.org/web/packages/plyr/index.html). 
Plyr can be installed using the following command:
    
    install.package('plyr')

*run_analysis.R* should be run using R version 3.1.0 or above. It should be run
in the directory containing the data using the following command:

    source('path/to/run_analysis.R')
    
It will output a file called *description.txt* in that directory called. This
file will list the means of all the measurement variables grouped by subject and activity.



