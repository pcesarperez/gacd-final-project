## run_analysis.R
## Coursera "Getting and Cleaning Data" course project script.
## The goal of this script is to create a tidy data set from a series of files containing data about an experiment with accelerometers.
## See http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
## Refer to `CodeBook.md` and `README.md` for further information.


## Constants.
## ----------------------------------------------------------------------------
MAIN_DATASET_FOLDER <- "UCI HAR Dataset"
TEST_DATASET_NAME <- "test"
TRAIN_DATASET_NAME <- "train"
SUBJECTS_RAW_DATA <- "subject_"
ACTIVITIES_RAW_DATA <- "y_"
FEATURES_RAW_DATA <- "x_"
FEATURE_NAMES <- "features.txt"
ACTIVITY_LABELS <- "activity_labels.txt"
MEAN_FEATURE_SNIPPET <- "mean\\(\\)"
STD_FEATURE_SNIPPET <- "std\\(\\)"
SUBJECT_COL_NAME <- "subject"
SUBJECT_ID_COL_NAME <- "subject.id"
ACTIVITY_COL_NAME <- "activity"
OFFENDING_CHARS_REGEXP <- "[\\(\\),-]"
OFFENDING_CHARS_REPLACEMENT <- "."
FEATURE_ID_COL_NAME <- "feature.id"
FEATURE_NAME_COL_NAME <- "feature.name"
ACTIVITY_ID_COL_NAME <- "activity.id"
ACTIVITY_LABEL_COL_NAME <- "activity.label"


## Helper functions.
## ----------------------------------------------------------------------------

## Creates a data folder to hold the results of the data cleaning.
##
## @param dataFolder Path of the data folder to create. If none specified, DATA_FOLDER is used.
createDataFolder <- function (dataFolder=DATA_FOLDER) {
	if (!file.exists (DATA_FOLDER)) {
		dir.create (DATA_FOLDER)
	}
}


## Gets the path to the `subject_test.txt` file.
## The file contains information about the subjects of the test data set.
## Each subject is identified by a number in the range 1..30.
##
## @return The path to the file containing information about the subjects of the test data set.
getTestSubjectsPath <- function ( ) {
	return (paste (MAIN_DATASET_FOLDER,
				   "/",
				   TEST_DATASET_NAME,
				   "/",
				   SUBJECTS_RAW_DATA,
				   TEST_DATASET_NAME,
				   ".txt",
				   sep=""))
}


## Gets the path to the `subject_train.txt` file.
## The file contains information about the subjects of the train data set.
## Each subject is identified by a number in the range 1..30.
##
## @return The path to the file containing information about the subjects of the train data set.
getTrainSubjectsPath <- function ( ) {
	return (paste (MAIN_DATASET_FOLDER,
				   "/",
				   TRAIN_DATASET_NAME,
				   "/",
				   SUBJECTS_RAW_DATA,
				   TRAIN_DATASET_NAME,
				   ".txt",
				   sep=""))
}


## Gets the path to the `y_test.txt` file.
## The file contains information about the activities of the test data set.
## Each activity is identified by a number in the range 1..6.
##
## @return The path to the file containing information about the activities of the test data set.
getTestActivitiesPath <- function ( ) {
	return (paste (MAIN_DATASET_FOLDER,
				   "/",
				   TEST_DATASET_NAME,
				   "/",
				   ACTIVITIES_RAW_DATA,
				   TEST_DATASET_NAME,
				   ".txt",
				   sep=""))
}


## Gets the path to the `y_train.txt` file.
## The file contains information about the activities of the train data set.
## Each activity is identified by a number in the range 1..6.
##
## @return The path to the file containing information about the activities of the train data set.
getTrainActivitiesPath <- function ( ) {
	return (paste (MAIN_DATASET_FOLDER,
				   "/",
				   TRAIN_DATASET_NAME,
				   "/",
				   ACTIVITIES_RAW_DATA,
				   TRAIN_DATASET_NAME,
				   ".txt",
				   sep=""))
}


## Gets the path to the `x_test.txt` file.
## The file contains information about the observations (features) of the test data set.
##
## @return The path to the file containing information about the observations (features) of the test data set.
getTestFeaturesPath <- function ( ) {
	return (paste (MAIN_DATASET_FOLDER,
				   "/",
				   TEST_DATASET_NAME,
				   "/",
				   FEATURES_RAW_DATA,
				   TEST_DATASET_NAME,
				   ".txt",
				   sep=""))
}


## Gets the path to the `x_train.txt` file.
## The file contains information about the observations (features) of the train data set.
##
## @return The path to the file containing information about the observations (features) of the train data set.
getTrainFeaturesPath <- function ( ) {
	return (paste (MAIN_DATASET_FOLDER,
				   "/",
				   TRAIN_DATASET_NAME,
				   "/",
				   FEATURES_RAW_DATA,
				   TRAIN_DATASET_NAME,
				   ".txt",
				   sep=""))
}


## Gets the path to the `features.txt` file.
## The file contains the mnemonic name of the observations (features) in both the test and train data sets.
##
## @return The path to the file containing the mnemonic names of the observations (features) in the experiment.
getFeatureNamesPath <- function ( ) {
	return (paste (MAIN_DATASET_FOLDER,
				   "/",
				   FEATURE_NAMES,
				   sep=""))
}


## Gets the feature names related to mean and standard deviation.
##
## @param featureNames A character vector containing the name of each feature.
## @return A character vector with the feature names related to mean and standard deviation.
filterFeatureNamesByMeanAndStd <- function (featureNames) {
	regex <- paste (MEAN_FEATURE_SNIPPET, "|", STD_FEATURE_SNIPPET, sep="")
	filteredFeatureNames <- featureNames [grepl (regex, featureNames)]

	return (filteredFeatureNames)
}


## Convert a character vector of feature names into valid column names.
## In this context, the "(", ")", "," and "-" characters are replaced by ".".
##
## @param featureNames A character vector contaning the name of each feature.
## @return A character vector with the feature names with the offending characters replaced by a dot.
replaceOffendingCharacters <- function (featureNames) {
	return (gsub (OFFENDING_CHARS_REGEXP, OFFENDING_CHARS_REPLACEMENT, featureNames))
}


## Gets the path to the `activity_labels.txt` file.
## The file contains the labels of the activities performed in the experiment.
##
## @return The path to the file containing the labels of the activities performed in the experiment.
getActivityLabelsPath <- function ( ) {
	return (paste (MAIN_DATASET_FOLDER,
				   "/",
				   ACTIVITY_LABELS,
				   sep=""))
}


## Analysis functions.
## ----------------------------------------------------------------------------

## Gets the feature names for the analysis.
##
## @return A character vector with the feature names for the analysis.
getFeatureNames <- function ( ) {
	featureNames <- read.table (getFeatureNamesPath ( ), col.names=c (FEATURE_ID_COL_NAME, FEATURE_NAME_COL_NAME))
	
	return (as.character (featureNames [, FEATURE_NAME_COL_NAME]))
}


## Gets the activity labels of each activity performed in the experiment.
## Each activity has an index used in both the test and train data sets.
##
## @return A data table containing the index of each activity and its label.
getActivityLabels <- function ( ) {
	activityLabels <- read.table (getActivityLabelsPath ( ),
								  col.names=c (ACTIVITY_ID_COL_NAME, ACTIVITY_LABEL_COL_NAME),
								  stringsAsFactors=FALSE)

	return (data.table (activityLabels))
}


## Load the test data set, returning a data table with three data files clipped together.
## The data files are:
##
## * `subject_test.txt`: Identifies the subject of each observation.
## * `y_test.txt`: Identifies the activity of each observation.
## * `x_test.txt`: Observations for each subject performing a certain activity.
##
## @param featureNames A vector with the feature names for the analysis.
## @return A data table with the data of the three files clipped together.
loadTestDataSet <- function (featureNames) {
	subjects <- read.table (getTestSubjectsPath ( ), col.names=SUBJECT_COL_NAME)
	activities <- read.table (getTestActivitiesPath ( ), col.names=ACTIVITY_COL_NAME)
	features <- read.table (getTestFeaturesPath ( ), col.names=featureNames)

	return (cbind (subjects, activities, features))
}


## Load the train data set, returning a data table with three data files clipped together.
## The data files are:
##
## * `subject_train.txt`: Identifies the subject of each observation.
## * `y_train.txt`: Identifies the activity of each observation.
## * `x_train.txt`: Observations for each subject performing a certain activity.
##
## @param featureNames A vector with the feature names for the analysis.
## @return A data table with the data of the three files clipped together.
loadTrainDataSet <- function (featureNames) {
	subjects <- read.table (getTrainSubjectsPath ( ), col.names=SUBJECT_COL_NAME)
	activities <- read.table (getTrainActivitiesPath ( ), col.names=ACTIVITY_COL_NAME)
	features <- read.table (getTrainFeaturesPath ( ), col.names=featureNames)
	
	return (cbind (subjects, activities, features))
}


## Merges the test and train data sets.
## The subjects of each data set are different, so we have to join the data tables together.
##
## @param test Test data set.
## @param train Train data set.
## @return A data set combining the test and train data sets.
mergeDataSets <- function (test, train) {
	return (rbind (test, train))
}


## Extracts the measurements on the mean and standard deviation for each observation.
## That means removing the columns not related to these two measures.
##
## @param data A data set with the combination of the test and train data sets.
## @param filteredFeatureNames A character vector containing the feature names related to mean and standard deviation.
## @return A data set with all columns removed, except subject, activity and mean/standard deviation related columns.
extractMeanStdMeasurements <- function (data, filteredFeatureNames) {
	return (data [, c (SUBJECT_COL_NAME, ACTIVITY_COL_NAME, filteredFeatureNames)])
}


## Replaces the activity ids in the data set for their labels.
##
## @param data A data set with the combination of the test and train data sets.
## @param activityLabels A data table with the correspondence between the activity ids and their labels.
## @param filteredFeatureNames A character vector containing the the feature names related to mean and standard deviation.
## @return A data set with the values in the column "activity" replaced by proper labels.
replaceActivityIdByLabel <- function (data, activityLabels, filteredFeatureNames) {
	# 1. Adds a new columns with the activity label of each observation.
	labeledData <- (merge (data,
						   activityLabels,
						   by.x=ACTIVITY_COL_NAME,
						   by.y=ACTIVITY_ID_COL_NAME,
						   all=TRUE,
						   sort=FALSE))

	# 2. Removes the column with the activity ids.
	labeledData [ACTIVITY_COL_NAME] <- NULL

	# 3. Reorders the columns to put the activity label next to the subject id.
	labeledData <-  labeledData [c (SUBJECT_COL_NAME, ACTIVITY_LABEL_COL_NAME, filteredFeatureNames)]

	# 4. Gets the data set with the activity labels.
	return (labeledData)
}


## Assigns descriptive variable names to the data set.
## A descriptive name is made of strings concatenated with a dot (".") character.
## For example, "tBodyAcc.std...X" is replaced with "time.body.acceleration.std.x".
## The general conversion rules are:
##
## * All feature names will be in lowercase.
## * The individual parts of the feature will be separated by a dot (".").
## * "t", at the beginning of the name, is replaced by "time".
## * "f", at the beginning of the name, is replaced by "frequency".
## * "Acc" is replaced by "accelerometer".
## * "Gyro" is replaced by "gyroscope".
## * "Jerk" is replaced by "shake".
## * "Mag" is replaced by "magnitude".
## * "std" remains the same.
## * "mean" remains the same.
## * "Body" is replaced by "body".
##
## @param data A data set with the combination of the test and train data sets.
## @return The data set with descriptive variable names.
assignDescriptiveVariableNames <- function (data) {
	# The subject column is a direct change.
	colnames (data) [1] <- SUBJECT_ID_COL_NAME

	# "t" => "time."
	colnames (data) <- gsub ("^t", "time.", colnames (data))

	# "Body" => "body."
	colnames (data) <- gsub ("Body", "body.", colnames (data))

	# "Acc" => "acceleration."
	colnames (data) <- gsub ("Acc", "acceleration.", colnames (data))

	# "Gyro" => "gyroscope."
	colnames (data) <- gsub ("Gyro", "gyroscope.", colnames (data))

	# "Jerk" => "shake."
	colnames (data) <- gsub ("Jerk", "shake.", colnames (data))

	# "Mag" => "magnitude."
	colnames (data) <- gsub ("Mag", "magnitude.", colnames (data))

	# "Gravity" => "gravity."
	colnames (data) <- gsub ("Gravity", "gravity.", colnames (data))

	# "f" => "frequency."
	colnames (data) <- gsub ("^f", "frequency.", colnames (data))

	# "X" => "x"
	colnames (data) <- gsub ("X", "x", colnames (data))

	# "Y" => "y"
	colnames (data) <- gsub ("Y", "y", colnames (data))

	# "Z" => "z"
	colnames (data) <- gsub ("Z", "z", colnames (data))

	# Gets rid of the extra dots.
	colnames (data) <- gsub ("\\.+", ".", colnames (data))

	# Gets rid the final dot, if any.
	colnames (data) <- gsub ("\\.$", "", colnames (data))

	return (data)
}


## Gets a tidy data set with the mean of each variable grouped by subject id and activity label.
## See: http://stackoverflow.com/questions/10787640/ddply-summarize-for-repeating-same-statistical-function-across-large-number-of
##
## @param data A data set with the combination of the test and train data sets.
## @return A tidy data set with the mean of each variable grouped by subject id and activity label.
getAverageDataBySubjectAndActivity <- function (data) {
	return (ddply (data, c (SUBJECT_ID_COL_NAME, ACTIVITY_LABEL_COL_NAME), numcolwise (mean)))
}


## Main function.
## ----------------------------------------------------------------------------

## Performs the analysis of the test and train sets to get two tidy data set.
## The data sets are:
##
## * `data`: A tidy data set with mean and standard deviation variables along with activity names and subject ids.
## * `averageData`: A tidy data set with the mean of each feature for each (subject id/activity label) pair.
##
## @return A list with two tidy data sets (data and averageData).
runAnalysis <- function ( ) {
	library (plyr)
	cat ("Running analysis to create the tidy data set...\n")

	cat ("  Loading feature names...")
	featureNames <- getFeatureNames ( )
	cat (" Done.\n")

	cat ("  Loading activity labels...")
	activityLabels <- getActivityLabels ( )
	cat (" Done.\n")

	cat ("  Loading test data set...")
	test <- loadTestDataSet (featureNames)
	cat (" Done.\n")

	cat ("  Loading train data set...")
	train <- loadTrainDataSet (featureNames)
	cat (" Done.\n")

	cat ("  Merging the test and train data sets...")
	data <- mergeDataSets (test, train)
	cat (" Done.\n")

	cat ("  Extracting mean and standard deviation related features...")
	filteredFeatureNames <- replaceOffendingCharacters (filterFeatureNamesByMeanAndStd (featureNames))
	data <- extractMeanStdMeasurements (data, filteredFeatureNames)
	cat (" Done.\n")

	cat ("  Replacing the activity ids by their corresponding labels...")
	data <- replaceActivityIdByLabel (data, activityLabels, filteredFeatureNames)
	cat (" Done.\n")

	cat ("  Assigning descriptive variable names...")
	data <- assignDescriptiveVariableNames (data)
	cat (" Done.\n")

	cat ("  Obtaining a tidy data set with the average of each variable for each activity and each subject...")
	averageData <- getAverageDataBySubjectAndActivity (data)
	cat (" Done.\n")

	cat ("Analysis finished.\n")

	return (list ("data"=data, "averageData"=averageData))
}