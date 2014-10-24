# Getting and Cleaning Data - Course Project
setwd("/home/nastya/Documents/Coursera/Getting_Cleaning_Data/UCI HAR Dataset")
#load training and testing set
train <- read.table("/home/nastya/Documents/Coursera/Getting_Cleaning_Data/UCI HAR Dataset/train/X_train.txt")
test <- read.table("/home/nastya/Documents/Coursera/Getting_Cleaning_Data/UCI HAR Dataset/test/X_test.txt")
# Load column names
labels <- read.table("/home/nastya/Documents/Coursera/Getting_Cleaning_Data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
#load subject ID and activity column
SubjectsTrain <- read.table("/home/nastya/Documents/Coursera/Getting_Cleaning_Data/UCI HAR Dataset/train/subject_train.txt", stringsAsFactors = FALSE)
ActivityTrain <- read.table("/home/nastya/Documents/Coursera/Getting_Cleaning_Data/UCI HAR Dataset/train/y_train.txt", stringsAsFactors = FALSE)
SubjectsTest <- read.table("/home/nastya/Documents/Coursera/Getting_Cleaning_Data/UCI HAR Dataset/test/subject_test.txt", stringsAsFactors = FALSE)
ActivityTest <- read.table("/home/nastya/Documents/Coursera/Getting_Cleaning_Data/UCI HAR Dataset/test/y_test.txt", stringsAsFactors = FALSE)
# assign column names to training set
ActivityTrainCol <- ActivityTrain$V1
SubjectIdTrain <- SubjectsTrain$V1
train[,1:563] <- cbind(SubjectIdTrain, ActivityTrain, train[,1:561]) 
colnames(train) <- c("SubjectId", "Activity", labels$V2)
head(train)
# assign column names to testing set
ActivityTestCol <- ActivityTest$V1
SubjectIdTest <- SubjectsTest$V1
test[,1:563] <- cbind(SubjectIdTest, ActivityTest, test[,1:561]) 
colnames(test) <- c("SubjectId", "Activity", labels$V2)
head(test)
# merge two datasets
mergeData <- rbind(train, test)
# search for column names containing "mean"
mean <- grepl("mean\\(\\)",labels$V2)
meanCol <- which(mean==TRUE)
meanCol2 <- meanCol+2
# select these columns from dataset
mergeDataSub1 <- mergeData[,meanCol2]
# search for column names containing "std"
std <- grepl("std",labels$V2)
stdCol <- which(std==TRUE)
stdCol2 <- stdCol+2
# select these columns from dataset
mergeDataSub2 <- mergeData[,stdCol2]
# combine two sets of columns
mergeDataSub <- cbind(mergeData[,1:2], mergeDataSub1, mergeDataSub2)
mergeDataSub$Activity <- factor(mergeDataSub$Activity, labels = c("WALKING","WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
# calculate mean values per subject per activity
tidyData<-aggregate( .~SubjectId+Activity,data=mergeDataSub, FUN = "mean")
# Write dataset as .txt
write.table(tidyData, "tidyData.txt", row.name=FALSE, quote=FALSE)
write.table(colnames(tidyData), "tidyDataCol.txt", row.name=FALSE, quote=FALSE)
