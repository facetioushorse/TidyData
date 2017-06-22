library(reshape2)

# ---- LOAD ALL DATA ----

# load activity labels and feature names
setwd("./UCI HAR Dataset")
activity_labels <- read.table("activity_labels.txt")
features <- read.table("features.txt")

# load the training set
setwd("train")
subject_train <- read.table("subject_train.txt")
X_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")

# load the test set
setwd("../test/")
subject_test <- read.table("subject_test.txt")
X_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")


# ---- COMBINE TEST AND TRAINING DATASETS, NAME COLUMNS ----

# combine subject into single column data.frame 
subject_combined <- rbind(subject_test, subject_train)
# name the column "subject"
colnames(subject_combined) <- c("subject")

# combine test and training activity labels into single column data.frame
y_combined <- rbind(y_test, y_train)
# name the column "activity"
colnames(y_combined) <- c("activity")

# combine test and training sets into a single data.frame
X_combined_prelim <- rbind(X_test, X_train)
# name the columns using the information in features, column "V2"
colnames(X_combined_prelim) <- features[ , "V2"]


# ---- EXTRACT MEASUREMENTS OF MEAN AND STANDARD DEVIATION ONLY ----
X_combined_mean <- X_combined_prelim[,grep("mean", names(X_combined_prelim))]
X_combined_std <- X_combined_prelim[,grep("std", names(X_combined_prelim))]
X_combined <- cbind(X_combined_mean, X_combined_std)

# combine all three sets of data (subject, activity label, and desired data) into one data.frame
combined_data <- cbind(subject_combined, y_combined, X_combined)


# ---- USE DESCRIPTIVE ACTIVITY NAMES ----

# replace activity label integers with descriptive terms, as provided in activity_labels variable
combined_data$activity[combined_data$activity == 1] <- "WALKING"
combined_data$activity[combined_data$activity == 2] <- "WALKING_UPSTAIRS"
combined_data$activity[combined_data$activity == 3] <- "WALKING_DOWNSTAIRS"
combined_data$activity[combined_data$activity == 4] <- "SITTING"
combined_data$activity[combined_data$activity == 5] <- "STANDING"
combined_data$activity[combined_data$activity == 6] <- "LAYING"


# ---- USE DESCRIPTIVE VARIABLE NAMES ----

column_names <- colnames(combined_data)
for (i in 1:length(column_names)) 
{
    column_names[i] = gsub("\\()","",column_names[i])  #remove any ()
    column_names[i] = gsub("^(t)","Time ",column_names[i])  #starts with t, replace with Time
    column_names[i] = gsub("^(f)","Frequency ",column_names[i])  #starts with f, replace with Frequency
    column_names[i] = gsub("([Gg]ravity)","Gravity ",column_names[i])  #add space after Gravity
    column_names[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body ",column_names[i])  #remove duplicates and add space after Body

    column_names[i] = gsub("-std"," Standard Deviation",column_names[i])
    column_names[i] = gsub("-mean"," Mean",column_names[i])
    column_names[i] = gsub("[Mm]eanFreq"," Mean Frequency",column_names[i])

    #column_names[i] = gsub("[Gg]yro","Gyro",column_names[i])
    column_names[i] = gsub("[Gg]yroJerk","Gyro Jerk",column_names[i])
    column_names[i] = gsub("Acc","Acceleration",column_names[i])
    column_names[i] = gsub("AccelerationJerk","Acceleration Jerk",column_names[i])
    column_names[i] = gsub("AccelerationMag","Acceleration Magnitude",column_names[i])

    column_names[i] = gsub("JerkMag","Jerk Magnitude",column_names[i])
    column_names[i] = gsub("GyroMag","Gyro Magnitude",column_names[i])
};

colnames(combined_data) <- column_names


# ---- CREATE SECOND DATASET ----

# melt data - with subject and activity as variable names
combined_data_melted <- melt(combined_data, id = c("subject", "activity"))

# now cast data from long format to wide format
# use mean function to get mean of each combintion of subject and activity
combined_data_mean <- dcast(combined_data_melted, subject + activity ~ variable, fun.aggregate = mean)

# save tidy dataset to main working directory
write.table(combined_data_mean, "../../tidy_data.txt",row.names=FALSE)