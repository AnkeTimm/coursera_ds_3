# loading used packages

library(dplyr)


# download and opening data set

file <- 'getting_and_cleaning_data-assignment'
url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'

download.file(url, file, method = 'curl')

unzip(file)


# reading in data to R

feature <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","values"))
activity <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("id", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = feature$values)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "id")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = feature$values)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "id")


# Merges the training and the test sets to create one data set.

x <- rbind(x_train, x_test) # values
y <- rbind(y_train, y_test) # activity

subject <- rbind(subject_train, subject_test) # person

merged <- cbind(subject, y, x)


# Extracts only the measurements on the mean and standard deviation for each measurement. 

merged_selected <- merged %>% select(subject, id, contains('mean'), contains('std'))


# Uses descriptive activity names to name the activities in the data set

merged_selected$id <- activity[merged_selected$id, 2]


# subject to factor

merged_selected$subject <- as.factor(merged_selected$subject)


# Appropriately labels the data set with descriptive variable names. 

names(merged_selected)[2] = 'activity'

present <- list('^t', 'Acc', 'Body', '.mean', 'Gravity', 'Jerk', 
                'Gyro', 'Mag', '^f', 'Freq', '.std', 'BodyBody')

target <- list('time', 'Accelerometer', 'Body', '_mean', 'Gravity', 'Jerk', 
               'Gyroscope', 'Magnitude', 'frequency', 'Frequency', '_std', 'Body')

i <- 1

for (i in 1:length(present)) {
  names(merged_selected) <- gsub(present[[i]], target[[i]], names(merged_selected))
  i+1
}


# From the data set in step 4, creates a second, independent tidy data set with 
# the average of each variable for each activity and each subject.

second_dataset <- merged_selected %>%
  group_by(activity, subject) %>%
  summarise_all(mean)
