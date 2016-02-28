#run_analysis.R does the following.
#
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement.
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names.
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Merges the training and the test sets to create one data set.

#required packages

library(data.table)
library(reshape2)

URL<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(URL,destfile = "project.zip") #testet on Windows, may be different for Mac

#unpack, may be diffrent for different operating systems.

#check list of directories
list.files(recursive = TRUE)

#load data for test and train and prepare them for marging

test_x<-read.table("UCI HAR Dataset/test/X_test.txt")
test_y<-read.table("UCI HAR Dataset/test/y_test.txt")
test_subject<-read.table("UCI HAR Dataset/test/subject_test.txt")

train_x<-read.table("UCI HAR Dataset/train/X_train.txt")
train_y<-read.table("UCI HAR Dataset/train/y_train.txt")
train_subject<-read.table("UCI HAR Dataset/train/subject_train.txt" )

#Read features

features<-read.table("UCI HAR Dataset/features.txt")
features<-features$V2

#Set up appropriate column names

names(test_x)=features
names(train_x)=features

#Select these features, for which the mean and standard deviation is availlible.

select_features <- grepl("mean|std", features)

#select these columns for which the mean and standard deviation is availlible.

test_x=test_x[,select_features]
train_x=train_x[,select_features]

#Read activity table

activity_labels<-read.table("UCI HAR Dataset/activity_labels.txt")
activity_labels<-activity_labels$V2

#Set up activity labels and rename columns

test_y[,2] = activity_labels[test_y[,1]]
train_y[,2] = activity_labels[train_y[,1]]
names(test_y) = c("Activity_ID", "Activity_Label")
names(train_y) = c("Activity_ID", "Activity_Label")

names(train_subject) = "subject"
names(test_subject) = "subject"

#Bind x and y data for test and train

test_set<- cbind(as.data.table(test_subject), test_x, test_y)
train_set<-cbind(as.data.table(train_subject), train_x, train_y)

# Merge test and train data
full_set = rbind(test_set, train_set)

#reshaping data

tidy<-melt(full_set,id=c("subject", "Activity_ID", "Activity_Label"),measure.vars = c(colnames(full_set)[2:80]))

# saving tidy data

write.table(tidy, file="./tidy.txt", row.names=FALSE)

#write.csv(tidy, "tidy.csv", row.names=FALSE)

