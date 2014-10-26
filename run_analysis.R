library(plyr)

read_merged_data <- function(dir = '.') {    
    activities <- read_activities(file.path(dir, 'activity_labels.txt'))  
    variable_names <- read_variable_names(file.path(dir, 'features.txt'))
    test_data <- read_data_set(activities, variable_names, file.path(dir, 'test'), 'test')
    training_data <- read_data_set(activities, variable_names, file.path(dir, 'train'), 'train')
    
    rbind(test_data, training_data)
}

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

read_variable_names <- function(file = './features.txt') {
    read.table(file, col.names = c("id", "variables"))
}

variables_with_mean <- function(variables) {
    which(as.logical(sapply(variables$variable, function(d) grep("mean()", d, fixed=T))))
}

variables_with_std <- function(variables) {
    which(as.logical(sapply(variables$variable, function(d) grep("std()", d, fixed=T))))
}

variables_to_keep <- function(variables) {
    sort(c(variables_with_mean(variables), variables_with_std(variables)))
}


read_data_set <- function(activities, variable_names, dir = './test', type="test") {
    if (!file.exists(dir)) stop(paste("Unable to access the", dir, "directory"));
    
    x_data <- read.table(file.path(dir, paste('X_', type, '.txt', sep='')), col.names = variable_names$variables)
    # Subset to keep columns with means and std deviations
    x_data <- x_data[,variables_to_keep(variable_names)]
    y_data <- read.table(file.path(dir, paste('y_', type, '.txt', sep='')))
    subjects <- read.table(file.path(dir, paste('subject_', type, '.txt', sep='')))
    
    cbind(subject = subjects[1,], activity = activities[y_data[,1], 2], x_data)
}

data <- read_merged_data()
descriptive <- calculate_descriptive_data(data)
write.table(descriptive, file = 'descriptive.txt', row.names=F)