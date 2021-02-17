## load the required packages 
library(dplyr)

## download the required file & unzipping 
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if(!file.exists("project.zip")){
  download.file(URL, destfile = "project.zip")
}

if(!file.exists("UCI HAR Dataset")){
  unzip("project.zip")
  
}

## reading the required text files
column_names <- read.table("UCI HAR Dataset\\features.txt")
x_test <- read.table("UCI HAR Dataset\\test\\X_test.txt",col.names = column_names$V2)
y_test <- read.table("UCI HAR Dataset\\test\\y_test.txt", col.names = "id")
x_train <- read.table("UCI HAR Dataset\\train\\X_train.txt", col.names = column_names$V2)
y_train <- read.table("UCI HAR Dataset\\train\\y_train.txt", col.names = "id")
activity_labels <- read.table("UCI HAR Dataset\\activity_labels.txt", col.names = c("id","activity")) 
subject_testt <- read.table("UCI HAR Dataset\\test\\subject_test.txt", col.names = "subject")
subject_trainn <- read.table("UCI HAR Dataset\\train\\subject_train.txt", col.names = "subject")

## binding columns to compose the test and train datasets
bound_test <- bind_cols(subject_testt, y_test,x_test)
bound_train <- bind_cols(subject_trainn, y_train, x_train)

## binding rows between test and train datasets to form the bound dataset
bound_data <- bind_rows(bound_test, bound_train)

##using descriptive activity labels 
bound_data$id <- activity_labels[bound_data$id,2]
bound_data <- rename(bound_data, "activity"="id")
str(bound_data)

## selecting mean & std data
mean_std <- select(bound_data, matches("subject|activity|mean|std"))

## using descriptive variable names
colnames(mean_std)
colnames(mean_std) <- sub(pattern="^f", replacement = "frequency", colnames(mean_std)) 
colnames(mean_std) <- sub(pattern="^t", replacement = "time",colnames(mean_std))
colnames(mean_std) <- sub(pattern = "-", replacement = ".", colnames(mean_std))
colnames(mean_std) <- sub(pattern ="Body", replacement = ".Body.", colnames(mean_std))  
colnames(mean_std) <- sub(pattern = "Acc", replacement = "accelorometer", colnames(mean_std))  
colnames(mean_std) <- sub(pattern="Body.Body", replacement = "Body.", colnames(mean_std))  
colnames(mean_std) <- sub(pattern="Gyro", replacement = "Gyroscope", colnames(mean_std))  
colnames(mean_std) <- sub(pattern="Mag",replacement = ".Magnitude", colnames(mean_std)) 
colnames(mean_std) <- sub(pattern="[Gg]ravity",replacement = ".gravity.", colnames(mean_std)) 
colnames(mean_std) <- sub(pattern= "\\..gravity", replacement = ".gravity", colnames(mean_std))

colnames(mean_std)
##grouping the data by subject and creating independent tidy data set with the average of each variable for each activity and each subject
tidy_data <- mean_std %>% group_by(subject,activity) %>% summarize_each(mean)
tidy_data

