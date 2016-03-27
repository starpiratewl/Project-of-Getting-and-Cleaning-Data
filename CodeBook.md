## This CodeBook.md record the whole process of achieving goals of the class project

#######################################################################################################################
## 1. Merge the training and the test sets to create one data set.
#######################################################################################################################

Tips1. download the zip files. Use the download.file() function to get the zip files. Usually I unzip the files use Winrar software, but R do provide a function to make it much easy in the command line. That is unzip() funcion

Tips2. Get to know all the data containing in the files to decide which should be used for further analysis.Fortunately, we have the instructions on this.The files contained in the folder are:
    - 'README.txt': the introductio of the dataset
    - 'features_info.txt': Shows information about the variables used on the feature vector.
    - 'features.txt': List of all features.
    - 'activity_labels.txt': Links the class labels with their activity name.
    - 'train/X_train.txt': Training set.
    - 'train/y_train.txt': Training labels.
    - 'test/X_test.txt': Test set.
    - 'test/y_test.txt': Test labels.
    - 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range        is from 1 to 30. 
    - 'train/Inertial Signals/total_acc_x_train.txt': The acceleration signal from the smartphone accelerometer X axis in            standard gravity units 'g'. Every row shows a 128 element vector. The same description applies for the 'total_acc_x_train       .txt' and 'total_acc_z_train.txt' files for the Y and Z axis. 
    - 'train/Inertial Signals/body_acc_x_train.txt': The body acceleration signal obtained by subtracting the gravity from the       total acceleration. 
    - 'train/Inertial Signals/body_gyro_x_train.txt': The angular velocity vector measured by the gyroscope for each window          sample. The units are radians/second. 

Tips3. because the overall data is generated from 30 volunteers and the 30 is divided into two groups, 21 in train group and 9 in test group , so we have to combined the two gruops to unify them in an overall dataset. I use cbind to join the voluteer index and other to dataset, use rbind to join the tow big groups (test and train)

Variables:
train_x : data of train group
train_y : activity index of train group
train_subject : voluteer index of train group
test_x :  data of test group
test_y : activity index of test group
test_subject : voluteer index of test group
traindata : join the test_subject, test_y, test_x. what actually do here is adding two columns to the main dataset train_x , one is volunteer and one the activity
testdata : the same as traindata
overall_data <- rbind(traindata, testdata)



#######################################################################################################################
## 2. Extract only the measurements on the mean and standard deviation for each measurement. 
#######################################################################################################################

Tips1. featurenames are imported from the features.txt file,but there are many kinds of them, here we are only interested in the mean and standard deviation knids. so here I use the regular expression to find the indice of them and subset the overall dataset use the indice. 

Tips2. A little interesting here is we subset the overall dataset via columns because the featurename are variable names. And after subsetting the overall dataset, we have to properly name the variables using the featurenames imported.

Variables:
featureName : character list importing form features.txt file
featureIndex : the indice generated by performig regular expression
finalData : use the indice to subsetting the overall_dataset


#######################################################################################################################
## 3. Uses descriptive activity names to name the activities in the data set
#######################################################################################################################

Tips1. This part is relatively simple because what I do here is only read the activitynames from the file and use the factor fcuntion to translate the activity variable from the numbers to the meaningful labels.

Variables:
activityName: character list importing form activity_labels.txt file
finalData$activity: factors translating the original numbers to labels representing different activities(6 kinds)



#######################################################################################################################
## 4. Appropriately labels the data set with descriptive variable names.
#######################################################################################################################

Tips1. After the manipulation before, we have the dataset almostly but the variable names are still in the original state,such as  tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tBodyAcc-std()-X tBodyAcc-std()-Y tBodyAcc-std()-Z. That is not easy for reading. So Here I use regular expression to trim the variable names to make it descriptive.

Tips2.  gsub("\\()", "", names(finalData))  ---- remove the "()"
        gsub("^t", "time", names(finalData)) ---- replace "t" with "time"
        gsub("^f", "frequence", names(finalData)) ---- replace "f" with "frequence"
        gsub("-mean", "Mean", names(finalData))  ----replace "-mean" with "Mean"
        gsub("-std", "Std", names(finalData)) ----replace "-std" with "Std"

Variables:
no variables created here



#######################################################################################################################
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#######################################################################################################################

Tips1. use plyr package to group the dataset by activity and subject and calculate the mean of all the variables


Variables:
groupData: generate the final dataset for writting files