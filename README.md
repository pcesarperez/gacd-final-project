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

The main analysis script is a function named `runAnalysis ( )`. This function reads certain data files of the experiment and returns a list with two tidy data sets:

* `data`: A tidy data set with mean and standard deviation variables along with activity names and subject ids.
* `averageData`: A tidy data set with the mean of each feature for each (subject id/activity label) pair.

The files read by the function are:

* `subject_test.txt`: Ids of the subjects involved in the "test" sub-experiment.
* `x_test.txt`: Observations (features) of the "test" sub-experiment.
* `y_test.txt`: Activities of the "test" sub-experiment.
* `subject_train.txt`: Ids of the subjects involved in the "train" sub-experiment.
* `x_train.txt`: Observations (features) of the "train" sub-experiment.
* `y_train.txt`: Activities of the "train" sub-experiment.

These are the steps involved to perform the analysis:

###Loading of the feature names

The feature names are loaded into a character vector using the `getFeatureNames ( )` function.

This function reads the `features.txt` file and gets the mnemonic name of each feature. These names are not adjusted. The result will be used to load the "test" and "train" data sets with proper names.

###Loading of the activity labels

The activity labels are loaded into a data frame using the `getActivityLabels ( )` function.

This function reads the `activity_labels.txt` file and gets the mapping between activity ids, present in the data files, and the activity labels. The result will be used to replace the activity ids in the tidy data set for their corresponding activity names.

###Loading of the "test" data set

This function, called `loadTestDataSet ( )`, reads the files of the "test" data set and clip them together (through the `cbind ( )` function) to obtain a data set structured as follows:

* `subject`: Column holding the subject id of each observation.
* `activity`: Column holding the activity id of each observation.
* 561 additional columns, one for each feature observed.

The function uses a character vector with the names of the features, as they were obtained through `getFeatureNames ( )` function.

###Loading of the "train" data set

This function, called `loadTrainDataSet ( )`, reads the files of the "train" data set and clip them together (through the `cbind ( )` function) to obtain a data set structured as follows:

* `subject`: Column holding the subject id of each observation.
* `activity`: Column holding the activity id of each observation.
* 561 additional columns, one for each feature observed.

The function uses a character vector with the names of the features, as they were obtained through `getFeatureNames ( )` function.

###Merge of the "test" and "train" data sets

With the two data sets corresponding to the "test" and "train" sub-experiments loaded, the function `mergeDataSets ( )` justs performs a `rbind ( )` of them to get a general data set with the same structure of the partial data sets, containing observations for all the subjects.

###Filtering of the mean and standard deviation columns

To filter out the columns not related to mean and standar deviation, we have used two helper functions (`replaceOffendingCharacters ( )` and `filterFeatureNamesByMeanAndStd ( )`). Using these two functions, we can obtain a character vector with the feature names corresponding to the required measures, without forbidden characters in column names, as follows:

    filteredFeatureNames <- replaceOffendingCharacters (filterFeatureNamesByMeanAndStd (featureNames))

###Replacing the activity ids by their names

###Assigning descriptive variable names

###Obtaining a data set grouped by subject id and activity label

##Constants

##Auxiliary functions

##Analysis functions
