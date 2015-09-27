#
# Getting and Cleaning Data - Assignment 
#
# 0. Download and extract the raw data
# 1. Read an merge the training and the test sets into one data set.
# 2. Extract only the measurements on the mean and standard deviation 
#    for each measurement. 
# 3. Use descriptive activity names for the activities in the data set
# 4. Appropriately label the data set with descriptive variable names. 
# 5. From the data set in step 4, create a second, independent tidy 
#    data set with average of each variable for each activity and subject.
#
# This script is organized in 2 sections:
#    * The first section is functions that do the work above
#    * The bottom section is a driver. Sourcing the file executes the driver
#
##########################################################################
require(plyr)
#
# Download specific file URL into a 'data' directory 
# Create directory if needed
##########################################################################
DownloadRawData <- function(furl){
  if (!file.exists("data")){
    dir.create("data")
  }

  fileToCreate <- "./data/UCI.zip"
  if (!file.exists(fileToCreate)){
    dataURL <- furl
    download.file(dataURL, fileToCreate, method="curl")
    dateDownloaded <- date()
    
    unzip(fileToCreate, exdir="./data")
  }
  if (!file.exists(fileToCreate)){
    return(FALSE)
  }
  
  return()
}

#
# read and merge the data sets (test & training)
# 1. read the feature names
# 2. read the test data sets
# 3. assign feature names to datasets
# 4. cbind the test data sets
# 5. repeat 2-4 for training data
# 6. rbind the training and test dataframes
#
##########################################################################
ReadAndMerge <- function(){
  #  Read feature names
  #
  dname     <- "./data/UCI HAR Dataset/"
  xFeatures <- read.table(paste(dname, "features.txt", sep=""), 
                          sep="", stringsAsFactors=FALSE)
  #  Read test data
  #
  dname     <- "./data/UCI HAR Dataset/test/"
  subjectID <- read.table(paste(dname, "subject_test.txt", sep=""), sep="")
  xDF       <- read.table(paste(dname, "X_test.txt",       sep=""), sep="")
  activity  <- read.table(paste(dname, "y_test.txt",       sep=""), sep="")
  
  #  assign feature names & bind the datasets
  #
  names(subjectID)[1] <- "subjectID"
  names(xDF)          <- xFeatures$V2
  names(activity)[1]  <- "activity"
  testDF              <- cbind(subjectID, activity, xDF)
  
  #  Read training data
  #
  dname     <- "./data/UCI HAR Dataset/train/"
  subjectID <- read.table(paste(dname, "subject_train.txt", sep=""), sep="")
  xDF       <- read.table(paste(dname, "X_train.txt",       sep=""), sep="")
  activity  <- read.table(paste(dname, "y_train.txt",       sep=""), sep="")
  
  #  assign feature names & bind the datasets
  #
  names(subjectID)[1] <- "subjectID"
  names(xDF)          <- xFeatures$V2
  names(activity)[1]  <- "activity"
  trainingDF          <- cbind(subjectID, activity, xDF)
  
  #  combine the test & training dataframes
  #
  df <- rbind(testDF, trainingDF)
  return(df)
}

#
# Extract columns containing mean and standard deviation 
# 
##########################################################################
ExtractMeanStd <- function(mdf){

  meanCols   <- grepl("mean", names(mdf), ignore.case=TRUE)
  stdCols    <- grepl("std",  names(mdf), ignore.case=TRUE)
  keepset    <- meanCols | stdCols
  keepset[1] <- TRUE                # keep subjectID
  keepset[2] <- TRUE                # keep activity
  edf        <- mdf[, keepset]      # extract <- merged - (keepset==TRUE)
  
  return(edf)
}

#
# Map the integer 'activity' to a more descriptive factor, such that:
#   1 - WALKING
#   2 - WALKING_UPSTAIRS
#   3 - WALKING_DOWNSTAIRS
#   4 - SITTING
#   5 - STANDING
#   6 - LAYING
# 
#  Use the mapping coded in: activity_labels.txt
#
##########################################################################
ApplyLabelsToActivity <- function(activity) {
  dname     <- "./data/UCI HAR Dataset/"
  labelDF   <- read.table(paste(dname, "activity_labels.txt", sep=""), 
                          sep="", stringsAsFactors=FALSE)
  newLabels <- as.vector(labelDF$V2)
  
  factivity <- cut( activity, 
                    breaks=length(newLabels), 
                    newLabels)
  
  return(factivity)  
}

# 
# Average each feature by activity, by subject
# first 2 columns are used for grouping
# Column3:END are averaged. NA's are omitted
#
##########################################################################
SummarizeData <- function(edf) {
  
  MyMean <- function(X){ return(colMeans(X[3:length(X)], na.rm=TRUE)) }
  
  sdf <- ddply(.data=edf, .(subjectID, activity), .fun=MyMean)
}
  
#
#    D R I V E R
# 
# 1. Download the data
# 2. Read and merge the test and training data
# 3. Extract the features representing mena and stdDev
# 4. Apply descriptive labels to activity
# 5. Average the features by activity, by subject
# 6. Output the tidy dataset
#
##########################################################################
furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
DownloadRawData(furl)

mdf          <- ReadAndMerge()                      # mergeDF
edf          <- ExtractMeanStd(mdf)                 # extractDF
edf$activity <- ApplyLabelsToActivity(edf$activity) # activity factor
sdf          <- SummarizeData(edf)                  # summaryDF
write.table(sdf, file="./data/tidy.txt", row.names=FALSE, sep=",")


