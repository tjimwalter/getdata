# Codebook for tidy.txt

## Format
* Comma separated values


## Overview
* tidy.txt is a summary of this datasource: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* You can read about the original data here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
* The original dataset includes these important files
  * features.txt: column names for measured features in the 'X' file
  * activity_labels.txt: descriptions corresponding to numeric activity IDs in the 'y' file
  * subject_test.txt: numeric IDs for the subjects. There are 30 subjects in all
  * X_test.txt: the measures (this is the real data)
  * y_test.txt: the numeric activies. There are 6 activities. This is a categorical response variable
  * There is a training data set corresponding to each test data set
* The subject, X and y files each have one observation per row.
* The subject file is a single column: subjectID 
* The X columns are named from the features.txt file - they are movements in 3d space
* The y file is a single column: activity
* In general the subject and y file provide context to the X file


## Explaning the transformation
1. cbind the subject, X and y files for training and test. This gives you the subject, the activity they were performing and measures associated
2. rbind the training and test datasets
3. The features.txt labels were used as column names for the X columns
4. Removed measures not related to mean or stdev (note, some means are weighted and they were retained)
5. Recoded the activities numeric ID as a factor using the activty_labels.txt 
6. Created a single row for each subject/activity and calculated mean on each measure column (na.omit=TRUE)
NB: there where 299 rows with NAs from 10299 rows overall

## Layout & organization                                                   
* 180 rows (one for each subject/activity combination: 30x6)
* 88 columns: (subjectID, activity, 86 feature measures)



