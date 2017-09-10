# Course Project of 'Getting and Cleaning Data'
This is the course project for "3. Getting and Cleaning Data" in Coursera Data Science Specialization.
The R script, "run_analysis.R", reads data (and metadata) from several files and transforms into a tidy dataset.
Details are as follows.

1. Download the files (csv, information txt, etc) for HAR (Human Activity Recognition) Using Smartphones Data Set of archive.ics.uci.edu.
2. Select variables of interest (i.e., mean and std variables) using the feature information.
3. Read train/test data files, and combine into a single dataset in a row wise manner.
4. Read subject/activity data files and combine into one.
5. Merge all measurements and activity/subject data into one dataframe.
6. Change variable names into descriptive ones.
   - The result file name of this tidy dataset is 'tidyHAR.txt'
7. From the data set in the above, generate another tidy dataset that contains mean values of each measurements for each subject/activity. 
   - The result file name is `tidyMeanHAR.txt'
