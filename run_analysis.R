setwd("D:\\wangliang\\coursera\\Course3\\week4")

#######################################################################################################################
## 1. Merge the training and the test sets to create one data set.
#######################################################################################################################

## step 1: downloading files
if(!file.exists("./data")) dir.create("./data")
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./data/raw_data.zip")

## step 2: unzip data
listZip <- unzip("./data/raw_data.zip", exdir = "./data")

## step 3: load data into R
train_x <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
test_x <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

## step 4: merge train and test data
traindata <- cbind(train_subject, train_y, train_x)
testdata <- cbind(test_subject, test_y, test_x)
overall_data <- rbind(traindata, testdata)

#######################################################################################################################
## 2. Extract only the measurements on the mean and standard deviation for each measurement. 
#######################################################################################################################

## step 1: load feature name into R
featureName <- read.table("./data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]

## step 2:  extract mean and standard deviation of each measurements
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
finalData <- overall_data[, c(1, 2, featureIndex+2)]
colnames(finalData) <- c("subject", "activity", featureName[featureIndex])

#######################################################################################################################
## 3. Uses descriptive activity names to name the activities in the data set
#######################################################################################################################


## step 1: load activity data into R
activityName <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

## step 2: replace 1 to 6 with activity names
finalData$activity <- factor(finalData$activity, levels = activityName[,1], labels = activityName[,2])

#######################################################################################################################
## 4. Appropriately labels the data set with descriptive variable names.
#######################################################################################################################

names(finalData) <- gsub("\\()", "", names(finalData))
names(finalData) <- gsub("^t", "time", names(finalData))
names(finalData) <- gsub("^f", "frequence", names(finalData))
names(finalData) <- gsub("-mean", "Mean", names(finalData))
names(finalData) <- gsub("-std", "Std", names(finalData))

#######################################################################################################################
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#######################################################################################################################

library(dplyr)
groupData <- finalData %>%
        group_by(subject, activity) %>%
        summarise_each(funs(mean))

write.table(groupData, "./Getting_and_Cleaning_data_Project/MeanData.txt", row.names = FALSE)
