library("tidyverse")

#set working directory

#download file 
#url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

#download.file(url, destfile = "/Users/nikolasrapp/surfdrive/Coursera_Data_Science/R_programming_course/Getting_cleaning_data_assignment/data.zip", method = "curl")

#unzip file manually

#read in data
testset <- as.data.frame(read.table("X_test.txt"))
testlables <- as.data.frame(read.table("y_test.txt"))
testsubject <- as.data.frame(read.table("subject_test.txt"))
trainingset <- as.data.frame(read.table("X_train.txt"))
traininglables <- as.data.frame(read.table("y_train.txt"))
trainingsubject <- as.data.frame(read.table("subject_train.txt"))
variablenames <- as.data.frame(read.table("features.txt"))
features <- read.table("features.txt")

#rename columns
variablenames <- features[,2] #extract variablenames from features txt file
names(testset)[1:561] <- variablenames
names(testlables)[1] <- "activity.lable"
names(testsubject)[1] <- "subject"
names(trainingset)[1:561] <- variablenames
names(traininglables)[1] <- "activity.lable"
names(trainingsubject)[1] <- "subject"

#merge test dataset with lables and subject
testdat <- merge(testlables, testsubject, by = 0, sort = FALSE)
testdat <- merge(testdat, testset, by=0, sort = FALSE)
testdat[1:2] <- NULL #remove rowname columns

#merge training dataset with lables and subject
traindat <- merge(traininglables, trainingsubject, by = 0, sort = FALSE)
traindat <- merge(traindat, trainingset, by=0, sort = FALSE)
traindat[1:2] <- NULL #remove rowname columns

#merge training data with test data
dat <- rbind(traindat, testdat)

#change labes to descriptive activity names
activity.lables <- as.data.frame(read.table("activity_labels.txt"))
activities <- as.vector(activity.lables$V2) #subset activites in vector
dat$activity.lable <- as.character(dat$activity.lable) #coerce activity.lable column to character
dat$activity.lable[dat$activity.lable == 1] <- activities[1] #change lable 1 to activity
dat$activity.lable[dat$activity.lable == 2] <- activities[2] #change lable 2 to activity
dat$activity.lable[dat$activity.lable == 3] <- activities[3] #change lable 3 to activity
dat$activity.lable[dat$activity.lable == 4] <- activities[4] #change lable 4 to activity
dat$activity.lable[dat$activity.lable == 5] <- activities[5] #change lable 5 to activity
dat$activity.lable[dat$activity.lable == 6] <- activities[6] #change lable 6 to activity


#From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject
by_subject_Activity <- dat %>% group_by(subject, activity.lable)
dat2 <- summarise_all(by_subject_Activity, mean)
write.table(dat2, file = "tidydata.txt", append = FALSE, sep = "\t", dec = ".",
            row.names = TRUE, col.names = TRUE)

        
