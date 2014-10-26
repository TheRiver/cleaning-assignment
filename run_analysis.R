# Copyright (c) 2014 Rudy Neeser
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#     
#     The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

library(plyr)

# This function reads the training and testing data sets and returns
# them in a merged data set, annotated with the subject and activity.
#
# It defaults to looking in the current working directory for the data,
# but this can be modified by passing an appropriate directory as argument.
read_merged_data <- function(dir = '.') {    
    activities <- read_activities(file.path(dir, 'activity_labels.txt'))  
    variable_names <- read_variable_names(file.path(dir, 'features.txt'))
    test_data <- read_data_set(activities, variable_names, file.path(dir, 'test'), 'test')
    training_data <- read_data_set(activities, variable_names, file.path(dir, 'train'), 'train')
    
    rbind(test_data, training_data)
}

# This function takes the merged data frame returned 
# from *read_merged_data* and returns the cleaned data frame 
# of mean values.
calculate_descriptive_data <- function(data) {
    data <- ddply(data, .(subject,activity),colwise(mean))
    names <- colnames(data)
    colnames(data) <- c(names[1:2], unlist(lapply(names[3:length(names)], function(s) paste("mean.of.", s, sep=''))))
    
    data    
}

# Read a mapping of activity codes to activity labels from the data    
read_activities <- function(file = './activity_labels.txt') {
    read.table(file, col.names = c("id", "activity"))
}

# Reads the variable names
read_variable_names <- function(file = './features.txt') {
    read.table(file, col.names = c("id", "variables"))
}

# Returns the indexes of the variables that use the mean. This is
# calculated by performing a substring operation.
# 
# The argument is the data frame of variable names returned from 
# *read_variable_names*
variables_with_mean <- function(variables) {
    which(as.logical(sapply(variables$variable, function(d) grep("mean()", d, fixed=T))))
}

# Returns the indexes of the variables that use the standard deviation. 
# This is by calculated using a substring operation.
# 
# The argument is the data frame of variable names returned from 
# *read_variable_names*
variables_with_std <- function(variables) {
    which(as.logical(sapply(variables$variable, function(d) grep("std()", d, fixed=T))))
}

# Returns the indexes of the variables that should be kept. These are those
# that use the mean or the standard deviation.
# 
# The argument is the data frame of variable names returned from 
# *read_variable_names*
variables_to_keep <- function(variables) {
    sort(c(variables_with_mean(variables), variables_with_std(variables)))
}

# This reads a specific data set, either the testing or the training data set.
# It then adds the subject and activity information to this set, and subsets
# it to use only those variables that are calculated from the mean or the 
# standard deviation.
#
# Parameters:
# - activities: a data frame of activity names, as returned by *read_activities*.
# - variable_names: a data frame of variable names returned from 
#                   *read_variable_names*
# - dir: A directory containing the data set
# - type: A string, either 'test' or 'train', depending on whether this should read
#         the testing or training data.
read_data_set <- function(activities, variable_names, dir = './test', type="test") {
    if (!file.exists(dir)) stop(paste("Unable to access the", dir, "directory"));
    
    x_data <- read.table(file.path(dir, paste('X_', type, '.txt', sep='')), col.names = variable_names$variables)
    # Subset to keep columns with means and std deviations
    x_data <- x_data[,variables_to_keep(variable_names)]
    y_data <- read.table(file.path(dir, paste('y_', type, '.txt', sep='')))
    subjects <- read.table(file.path(dir, paste('subject_', type, '.txt', sep='')))
    
    cbind(subject = subjects[1,], activity = activities[y_data[,1], 2], x_data)
}

# Here we read the merged data, calculate the descriptive data
# and then output this to descriptive.txt
data <- read_merged_data()
descriptive <- calculate_descriptive_data(data)
write.table(descriptive, file = 'descriptive.txt', row.names=F)