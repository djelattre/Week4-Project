###########################################################
# Init.
###########################################################

#----------------------------------------------------------
# Init. working directory
#----------------------------------------------------------

mywd<-"H:/My Documents/Coursera/Data Science/3-Getting and Cleaning Data"
setwd(mywd)

#----------------------------------------------------------
# Load library
#----------------------------------------------------------

library(dplyr)

#----------------------------------------------------------
# Download data and prepare the working env.
#----------------------------------------------------------

#init. variables
data.directorate<-"Week4-Project"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zip.filename<-"getdata_projectfiles_UCI HAR Dataset.zip"

#if not already downloaded, download and unzip the file
if (!file.exists(data.directorate)) {
    dir.create(data.directorate)
	download.file(url, paste(data.directorate, zip.filename, sep="/"))
	unzip(paste(data.directorate, zip.filename, sep="/"), exdir=data.directorate)
}

#Delete extra var.
rm(url,zip.filename)

###########################################################
# Script
###########################################################

#----------------------------------------------------------
# 1. Merges the training and the test sets to create one data set.
#----------------------------------------------------------

#Load features data
features_table <- read.table("Week4-Project/UCI HAR Dataset/features.txt")
features_name <- as.vector(features_table[,2])

#Load train data
train_x <- tbl_df(read.table("Week4-Project/UCI HAR Dataset/train/X_train.txt", nrows=7352, comment.char="", col.names=features_name))
train_subject <- tbl_df(read.table("Week4-Project/UCI HAR Dataset/train/subject_train.txt", col.names=c("subject")))
train_y <- tbl_df(read.table("Week4-Project/UCI HAR Dataset/train/Y_train.txt", col.names=c("activity")))
#Merge train data
train_full <- tbl_df(cbind(train_x, train_subject, train_y))
#Delete extra var.
rm(train_x, train_subject, train_y)

#Load test data
test_x <- tbl_df(read.table("Week4-Project/UCI HAR Dataset/test/X_test.txt", nrows=2947, comment.char="", col.names=features_name))
test_subject <- tbl_df(read.table("Week4-Project/UCI HAR Dataset/test/subject_test.txt", col.names=c("subject")))
test_y <- tbl_df(read.table("Week4-Project/UCI HAR Dataset/test/Y_test.txt", col.names=c("activity")))
#Merge test data
test_full <- tbl_df(cbind(test_x, test_subject, test_y))
#Delete extra var.
rm(test_x, test_subject, test_y)

#Merge
data <- rbind(train_full,test_full)

#Delete extra var.
rm(train_full,test_full,features_table,features_name)

#----------------------------------------------------------
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#----------------------------------------------------------

#Look for "mean" and "std" in column names of main data set (data)
mean_and_std_col <- grep(".*mean.*|.*std.*", tolower(names(data)))
mean_and_std_col <- c(562,563,mean_and_std_col) #add columns subject and activity

#Create the second dataset 
dataset <- data[,mean_and_std_col]

#Delete extra var.
rm(mean_and_std_col)

#----------------------------------------------------------
#3.Uses descriptive activity names to name the activities in the data set
#----------------------------------------------------------

#Load activity data
activity_table <- read.table("Week4-Project/UCI HAR Dataset/activity_labels.txt")

#for i = 1 to number of rows of var. activity_table, replace activity number by activity label
for (i in 1:nrow(activity_table)) {
    dataset$activity[dataset$activity == activity_table[i, 1]] <- as.character(activity_table[i, 2])
}

#Delete extra var.
rm(i,activity_table)

#----------------------------------------------------------
#4.Appropriately labels the data set with descriptive variable names. 
#----------------------------------------------------------

#Get dataset names
dataset_names <- names(dataset)

#Make names readable
dataset_names <- gsub("Acc", "Accelerometer", dataset_names)
dataset_names <- gsub("Gyro", "Gyroscope", dataset_names)
dataset_names <- gsub("BodyBody", "Body", dataset_names)
dataset_names <- gsub("Mag", "Magnitude", dataset_names)
dataset_names <- gsub("^t", "Time", dataset_names)
dataset_names <- gsub("^f", "Frequency", dataset_names)
dataset_names <- gsub("tBody", "TimeBody", dataset_names)
dataset_names <- gsub("[Mn]ean()", "Mean", dataset_names, ignore.case = TRUE)
dataset_names <- gsub("[Ss]td()", "STD", dataset_names, ignore.case = TRUE)
dataset_names <- gsub("[Ff]req()", "Frequency", dataset_names, ignore.case = TRUE)
dataset_names <- gsub("angle", "Angle", dataset_names)
dataset_names <- gsub("gravity", "Gravity", dataset_names)
dataset_names <- gsub("subject", "Subject", dataset_names)
dataset_names <- gsub("activity", "Activity", dataset_names)
dataset_names <- gsub("\\.\\.", "()", dataset_names)
dataset_names <- gsub("\\.\\.\\.", "()", dataset_names)
dataset_names <- gsub("\\.$", "()", dataset_names)

#Assign clean names in dataset
names(dataset) <- dataset_names

#Delete extra var.
rm(dataset_names)

#----------------------------------------------------------
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#----------------------------------------------------------

#Group by Subject then Activity and calculate the mean for all columns
tiny_dataset <- group_by(dataset, Subject,Activity) %>%
summarise_all(funs(mean))

# Save the data into the file
write.table(tiny_dataset, file="tiny_dataset.txt", row.name=FALSE)
