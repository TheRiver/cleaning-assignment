# Cleaning Assignment Codebook

The original data was obtained on Sunday, October 26th, 06:52 SAST, via the 
following link:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
        
This data is made available to us via the work of Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. You can read more about this work here:

- Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. *Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine*. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012
    
Additional information about can be found at the [authors' website](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones).


## Raw Data
The initial data was provided in a *testing* and *training* data set. This data was
annotated with the ID of the subject from which the
measurements were taken (provided in the relavent subject testing file, described
in the raw data set), as well as with a description of the activity being performed
at the time. We have used the original subject IDs (an integer from 1 to 30) and
the original descriptive activity labels:

1. WALKING
1. WALKING_UPSTAIRS
1. WALKING_DOWNSTAIRS
1. SITTING
1. STANDING
1. LAYING

All measurement variables are named using the feature names given in the
*features.txt* file of the raw data set, with the exception that punctuation
has been replaced by a period / full-stop. For example, the variable

    tBodyAcc-mean()-X
    
has been named

    tBodyAcc.mean...X

## Processing steps

The testing and training data were combined in to one merged data set. Since 
they all shared the same variables, this was trivially done by appending the 
training and testing data together.
    
We have kept only the variables that have been directly calculated from the mean
and standard deviation values. These were identified from the *features.txt* 
as those using the *mean()* and *std()* values. 

We then calculated the mean of all of these variables, grouped by subject and 
activity. These are outputed by the run_analysis.R script in the descriptive.txt
file. 

