##Downloads the file and unzips it
if(!file.exists("./data")){dir.create("./data")}
#Here are the data for the project:
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

## Reads train and test datasets, feature vectors and activity labels
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table('./data/UCI HAR Dataset/features.txt')

activitylabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

## Assigns column names to train and test datasets
colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"
colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"
colnames(activitylabels) <- c('activityId','activityType')

## Merges the train and test data
train <- cbind(y_train, subject_train, x_train)
test <- cbind(y_test, subject_test, x_test)
finaldataset <- rbind(train, test)
finalcols <- colnames(finaldataset)

## Identify columns with ID, mean or std from the dataset and subsetting these columns from the dataset
ms <- (grepl("activityId" , finalcols) | 
                   grepl("subjectId" , finalcols) | 
                   grepl("mean.." , finalcols) | 
                   grepl("std.." , finalcols))
setms <- finaldataset[ , ms== TRUE]

## Provides descriptive activity names for each of the activities in the dataset
setactivitynames <- merge(setms, activitylabels,
                              by='activityId',
                              all.x=TRUE)

## Writes a tidy dataset with average values of each variable for each activity and each subject
tidyset <- aggregate(. ~subjectId + activityId, setactivitynames, mean)
tidyset <- tidyset[order(tidyset$subjectId, tidyset$activityId),]
write.table(tidyset, "tidyset.txt", row.name=FALSE)
