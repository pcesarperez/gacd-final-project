#README.md

##Introduction

This is the "readme" file corresponding to the final project in the course "Getting and Cleaning Data" (https://www.coursera.org/course/getdata).

Extracted from the project instructions:

> The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called `CodeBook.md`. You should also include a `README.md` in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

> One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

> http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

> Here are the data for the project: 

> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

> You should create one R script called `run_analysis.R` that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set.
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Sorting out the functions

There are 21 functions in the script `run_analysis.R`. However, these functions are divided into three categories:

1. **Auxiliary functions**: Functions to get items not directly related to the analysis, but useful to split the design into small and concise parts (for example, functions to get the path names for the files containing actual data).
2. **Analysis functions**: Functions to perform each step of the analysis process. These functions are called from within the `runAnalysis ( )` function.
3. **Main analysis script**: This is the `runAnalysis ( )` function. The function itself is a step-by-step self-explanatory process to get the required tidy data sets.

We will show the functions in reverse order, to go from the general and most important function (`runAnalysis ( )`) to the auxiliary functions, in order to get a good sense of the path taken to get the data sets.

##Main analysis script

##Constants

##Auxiliary functions

##Analysis functions
