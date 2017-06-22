# TidyData
Coursera, Getting and Cleaning Data, Final Project

Library required to run the script: reshape2

The R script, run_analysis.R, does the following:

1. Loads all data, assuming the UCI HAR Dataset has already been downloaded and unzipped on your local machine.
  a. Loads activity label and feature name files
  b. Loads the training set files
  c. Loads the test set files
  
2. Combines test and training sets together.
  a. Subjects are combined into a single column data.frame using row bind function
  b. Activity labels are combined into a single column data.frame using row bind function
  c. Test and training sets are combined into a single data.frame using row bind function
  d. Column names are set
  
3. Subject, activity, and measurements of mean and standard deviation are extracted. Note: I left the frequency mean on purpose, as it is a mean value of one of the measurements.

4. The activity column is converted from an integer value to a string based on the activity labels.

5. The variable names describing the measurements are modified to be human readable.

6. The second, and final, tidy dataset is created, which contains the average value of each measurement for each subject/activity combination.

7. The tidy data is saved in the local working directory as "tidy_data.txt"
