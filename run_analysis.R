## prepare files for this project by downloading and unzipping if necessary.
prepareData <- function(base_dir) {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  filename <- file.path(base_dir, "HAR_Dataset.zip")
  datadir <- file.path(base_dir, "UCI HAR Dataset")
  
  ## Download and unzip the dataset if not exist
  if (!file.exists(filename)){
    message("download zipped datafile.")
    download.file(url, destfile = filename, method="curl")
  } else {
    message("zipped datafile is ready.")
  }
  
  if (!file.exists(datadir)) {
    message("unzip datafile.")
    unzip(filename, exdir = base_dir) 
  } else {
    message("data dir is ready.")   
  }
  
  return(datadir)
}

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
loadDataX <- function(datadir) {
  # Get indices of mean & stdandard deviation related measurements.
  features <- read.table(file.path(datadir, "features.txt"))
  wanted_index <- grep(".*(mean|std).*", features[, 2])
  
  X_train <- read.table(file.path(datadir, "train", "X_train.txt"))
  X_test <- read.table(file.path(datadir, "test", "X_test.txt"))
  
  # Before combining, select columns of interest.
  X_merged <- rbind(X_train[, wanted_index], X_test[, wanted_index])
  names(X_merged) <- features[wanted_index, 2]
  return (X_merged)
}

loadDataY <- function(datadir) {
  # read 4 files
  Y_train_activities <- read.table(file.path(datadir, "train", "Y_train.txt"))
  Y_test_activities <- read.table(file.path(datadir, "test", "Y_test.txt"))
  train_subjects <- read.table(file.path(datadir, "train", "subject_train.txt"))
  test_subjects <- read.table(file.path(datadir, "test", "subject_test.txt"))
  
  # combine into one
  Y_train <- cbind(train_subjects, Y_train_activities)
  Y_test <- cbind(test_subjects, Y_test_activities)
  Y_merged <- rbind(Y_train, Y_test)

  ## 3. Uses descriptive activity names to name the activities in the data set
  activity_labels = read.table(file.path(datadir, "activity_labels.txt"))
  Y_merged[, 2] = factor(Y_merged[, 2], levels = activity_labels[, 1], labels = activity_labels[, 2])
  
  # set the names of two variables.
  names(Y_merged) = c("Subject", "Activity")
  return (Y_merged)
}

## 4. Appropriately labels the data set with descriptive variable names.
getDescriptiveNames <- function(names) {
  names <- gsub("-mean", "Mean", names)
  names <- gsub("-std", "StdDev", names)
  names <- gsub("[-()]", "", names)
  names <- gsub("^f", "Frequencey", names)
  names <- gsub("^t", "Time", names)
}


## main driver for 1 to 4. of this project
datadir <- prepareData("..")
X_merged <- loadDataX(datadir)
Y_merged <- loadDataY(datadir)
names(X_merged) <- getDescriptiveNames(names(X_merged))
tidyHAR <- cbind(Y_merged, X_merged)

## 5. From the data set in step 4, creates a second, 
##    independent tidy data set with the average of each variable 
##    for each activity and each subject.
library(dplyr)
tidyMeanHAR <- ddply(tidyHAR, .(Subject, Activity), function(data) { colMeans(data[, -c(1, 2)]) })

## write to file
write.table(tidyHAR, "tidyHAR.txt", row.names = FALSE, quote = FALSE)
write.table(tidyMeanHAR, "tidyMeanHAR.txt", row.names = FALSE, quote = FALSE)
