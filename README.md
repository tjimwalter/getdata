# getdata
Class assignment from Coursera's Getting and Cleaning Data course

## About this analysis
* Script name : run_analysis.R _sourcing this R file will drive the process
* Codebook    : codebook.txt describes the data and steps taken to create it
* Dependencies: the UCI dataset must be in your working directory in a subdirectory named 'data'

## What it does
 1. Downloads the data, if not present
 2. Reads and merges the test and training data
 3. Extracts the features representing mean and stdDev
 4. Applies descriptive labels to activity
 5. Averages the features by activity, by subject
 6. Outputs tidy.txt to the /data directory in csv format
