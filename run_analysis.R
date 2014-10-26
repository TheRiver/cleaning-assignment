read_merged_data <- function(dir = '.') {
    file_name <- file.path(dir, 'activity_labels.txt')
    
    activities <- read_activities(file_name)  
    test_data <- read_data_set(activities, file.path(dir, 'test'), 'test')
    training_data <- read_data_set(activities, file.path(dir, 'train'), 'train')
    
    rbind(test_data, training_data)
}

# Read a mapping of activity codes to activity labels from the data    
read_activities <- function(file = './activity_labels.txt') {
    read.table(file, col.names = c("id", "activity"))
}


read_data_set <- function(activities, dir = './test', type="test") {
    if (!file.exists(dir)) stop(paste("Unable to access the", dir, "directory"));
    
    x_data <- read.table(file.path(dir, paste('X_', type, '.txt', sep='')))
    y_data <- read.table(file.path(dir, paste('y_', type, '.txt', sep='')))
    subjects <- read.table(file.path(dir, paste('subject_', type, '.txt', sep='')))
    
    x_data$subject <- subjects[1,]
    x_data$activity <- activities[y_data[,1], 2]
    
    x_data
}