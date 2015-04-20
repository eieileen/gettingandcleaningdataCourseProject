## Begin by downloading and unzipping the file in the link below
## in your working directory.
## https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## Then perform the analysis as follows.

## Set working directory to the data folder.
setwd("./UCI HAR Dataset")

## Read the data into R.

testset <- read.table('test/X_test.txt')
testlabels <- read.table('test/y_test.txt')
testsubject <- read.table('test/subject_test.txt')
trainingset <- read.table('train/X_train.txt')
traininglabels <- read.table('train/y_train.txt')
trainingsubject <- read.table('train/subject_train.txt')
features <- read.table('features.txt')

## Download (if needed) and load dplyr package.

if(require("dplyr")){
        print("dplyr is loaded correctly")
} else {
        print("trying to install dplyr")
        install.packages("dplyr")
        if(require(dplyr)){
                print("dplyr installed and loaded")
        } else {
                stop("could not install dplyr")
        }
}
library(dplyr)

## Add a key to make it easier to add the labels/subjects to the sets.

testlabels$key <- 1:2947
testset$key <-1:2947
testsubject$key <-1:2947
traininglabels$key <- 1:7352
trainingset$key <- 1:7352
trainingsubject$key <- 1:7352

## Create complete test and training data.

test <- merge(testsubject, 
              merge(testlabels, testset, by="key"), by = "key")
training <- merge(trainingsubject,
                  merge(traininglabels, trainingset, by = "key"), by = "key")

## Merge the two data sets together, sort by subject, and reset the key.

data <- rbind(training,test)
data <- arrange(data,V1)
data$key <- 1:nrow(data)

## Label using the features and update to use valid R names with no periods.

features$V2 <- as.character(features$V2)
names(data) <- c(c("key","subject","activity"), features$V2)
valid_column_names <- make.names(names=names(data), unique=TRUE, allow_ = TRUE)
names(data) <- valid_column_names
names(data) <- gsub("\\.","",names(data))

## Find only the mean and standard deviation columns and select them.

check <- data.frame(grep("mean|std",names(data)),
                    grep("mean|std",names(data),value = TRUE))
names(check) <- c("colno","colname")
check <- subset(check,!grepl("meanF",check$colname))
tidy <- select(data,check$colno)
tidy <- cbind(cbind(data$subject,cbind(data$activity,tidy)))
colnames(tidy)[1] <- "subject"
colnames(tidy)[2] <- "activity"

## Update the activities with descriptive activity names.

tidy$activity[tidy$activity == 1] <- "WALKING"
tidy$activity[tidy$activity == 2] <- "WALKING_UPSTAIRS"
tidy$activity[tidy$activity == 3] <- "WALKING_DOWNSTAIRS"
tidy$activity[tidy$activity == 4] <- "SITTING"
tidy$activity[tidy$activity == 5] <- "STANDING"
tidy$activity[tidy$activity == 6] <- "LAYING"
tidy$activity <-as.factor(tidy$activity)

## Now create the summary data set requested.

summary <- tidy %>% 
        group_by(subject, activity) %>% 
        summarise_each(funs(mean))
write.table(summary,
            file = "human_activity_recognition_using_smartphones_data.txt",
            row.names = FALSE)
