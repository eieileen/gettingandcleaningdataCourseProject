# Getting and Cleaning Data
## Course Project

The goal of this project was to create a tidy data set in R from the data from the link below.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Data set] (https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

These are data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

This repository contains:
* run_analysis.R - an R script detailing the steps to create the tidy data set
* code_book.txt - the code book for run_analysis.R

The R script assumes that the data set has been downloaded into your working directory. From there, it takes the following steps to create the tidy data set:
* Sets the working directory to the UCI HAR Dataset folder
* Reads the data into R
* Downloads (if needed) and loads dplyr package
* Adds a key to make it easier to add the labels/subjects to the data frames
* Merges the test and training data into one data frame each
* Merge the two data frames together, sorts the result by subject, and resets the key
* Labels the columns using the features and updates to use valid R names with no periods
* Finds only the mean and standard deviation columns and selects them
* Updates the activities with descriptive activity names
* Creates the summary data set as requested
