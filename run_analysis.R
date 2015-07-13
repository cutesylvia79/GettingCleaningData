
library(reshape2)
library(data.table)
library(dplyr)

##setwd("C:/Users/sylvia.seow/sylviadatascience/sylviadatascience/r")

## download file "tidy_feature.csv" from my github, and save it into working directory

use_local <- 1
## use_local <-0  ##is for download data from internet link
## use_local <-1  ##for using folder/files as in working directory

if (use_local ==0)
{
  ## download file for link, and save into working directory
  ## rename as dataset.zip
  
  ## download script for windows
  message("Downloading data....")
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="Dataset.zip")
  
  ## download script for mac
  #download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="Dataset.zip",method="curl")
  
  ## extract the zip file into local directory
  message("unzipping files....")
  unzip("Dataset.zip")

}


message("Preparing dataset....")
activity_label_raw <- read.table("UCI HAR Dataset/activity_labels.txt", sep="")
feature_raw <- read.table("UCI HAR Dataset/features.txt", sep="")
feature_add <- read.csv("tidy_feature2.csv")


## load test data
message("Loading Test data....")
subject_test_raw <- read.table("UCI HAR Dataset/test/subject_test.txt", sep="")
y_test_raw <- read.table("UCI HAR Dataset/test/y_test.txt", sep="")
x_test_data_raw <-read.table("UCI HAR Dataset/test/X_test.txt", sep="")

## load train data
message("Loading training data....")
subject_train_raw <- read.table("UCI HAR Dataset/train/subject_train.txt", sep="")
y_train_raw <- read.table("UCI HAR Dataset/train/y_train.txt", sep="")
x_train_data_raw <-read.table("UCI HAR Dataset/train/X_train.txt", sep="")


names(activity_label_raw) <- c("activity_id","activity_name")
## adding meaning variable to Activity /Name
## step3
##Uses descriptive activity names to name the activities in the data set
activity_label_raw$Activity_Label <- c("Walking","Walking Upstairs","Walking Downstairs","Sitting", "Standing", "Laying")

## renaming all column header for each dataset
names(feature_raw) <- c("feature_id","feature_name")
names(subject_test_raw) <- c("student_id")
names(y_test_raw) <- c("activity_id")
names(subject_train_raw) <- c("student_id")
names(y_train_raw) <- c("activity_id")

## renaming the x column name without "V"

##names(x_test_data_raw) <- c(as.character(1:561))
##names(x_train_data_raw) <- c(as.character(1:561))
names(x_test_data_raw) <- feature_raw[,2]
names(x_train_data_raw) <- feature_raw[,2]


## step4 filter data
X_test_mean_std  = x_test_data_raw[,grep("mean|std", colnames(x_test_data_raw))]
X_test_mean_std  = X_test_mean_std[,-grep("Freq", colnames(X_test_mean_std))]
X_train_mean_std  = x_train_data_raw[,grep("mean|std", colnames(x_train_data_raw))]
X_train_mean_std  = X_train_mean_std[,-grep("Freq", colnames(X_train_mean_std))]


## Combine data and prepare for test data set
message("Melting testing data by variable (converting columns to rows)....")
subject_test_raw$dataset_source <- "test"
X_test_mean_std <- cbind(subject_test_raw, y_test_raw, X_test_mean_std)
test_data_melt <- melt(X_test_mean_std, id=c("student_id","dataset_source","activity_id"))
colnames(test_data_melt) <- c("subject_id","dataset_source","activity_id","variable_name", "value_data")
## merge data with matching labels for feature / activity
test_data_merge <- merge(test_data_melt, feature_add, by.x="variable_name",by.y="variable_name",all=FALSE)
test_data_merge <- merge(test_data_merge, activity_label_raw, by.x="activity_id",by.y="activity_id",all=FALSE)


##combine data and prepare for training data set
subject_train_raw$dataset_source <- "train"

message("Melting training data by variable (converting columns to rows)....")
X_train_mean_std <- cbind(subject_train_raw, y_train_raw, X_train_mean_std)
train_data_melt <- melt(X_train_mean_std, id=c("student_id","dataset_source","activity_id"))
colnames(train_data_melt) <- c("subject_id","dataset_source","activity_id","variable_name", "value_data")

##Appropriately labels the data set with descriptive variable names. 
message("Merging testing and training data...")
train_data_merge <- merge(train_data_melt, feature_add, by.x="variable_name",by.y="variable_name",all=FALSE)
train_data_merge <- merge(train_data_merge, activity_label_raw, by.x="activity_id",by.y="activity_id",all=FALSE)

## merge data from test data and training data
## step 1
all_data_set =rbind(test_data_merge, train_data_merge)
all_data_set1 <- all_data_set[,c("subject_id","Activity_Label","Variable_Label","value_data")]

## widen the tables by pivoting Feature Names
message("Widening data for merged data (converting rows to columns)..")
tidy_data <- dcast(all_data_set1, subject_id + Activity_Label ~ Variable_Label, mean)

## write out the table to working directory again
##step 5
message("Exporting tidy data set to file...")
write.table(tidy_data,file="tidy_dataset.txt", row.names=FALSE)
message("tidy_dataset.txt is saved in working directory")



