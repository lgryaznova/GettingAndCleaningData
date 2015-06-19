
require(plyr)


##### STEP 1 ###############

## get variable names from features.txt
varnames <- read.table("./UCI HAR Dataset/features.txt", header = FALSE)
varnames <- varnames[, 2]

## read X_train.txt and X_test.txt
train <- read.table("./UCI HAR Dataset/train/X_train.txt", 
                    header = FALSE, col.names = varnames)
test <- read.table("./UCI HAR Dataset/test/X_test.txt", 
                   header = FALSE, col.names = varnames)

## merge data sets
merged <- merge(train, test, all = TRUE, sort = FALSE)


##### STEP 2 ###############

## subset the data set to have only mean and std values
indices <- sort(c(grep("mean()", varnames, fixed = TRUE), 
                  grep("std()", varnames, fixed = TRUE)))
merged <- merged[, indices]


##### STEP 3 ###############

## read subject labels for both original data sets, join these vectors 
## and add subject column to the merged data frame
train_subj <- read.table("./UCI HAR Dataset/train/subject_train.txt", 
                         header = FALSE)
test_subj <- read.table("./UCI HAR Dataset/test/subject_test.txt", 
                        header = FALSE)
merged$Subject <- c(train_subj[, 1], test_subj[, 1])

## add activity column to the merged data frame:
## read the table linking numeric activity labels to their wordings
act_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", 
                         header = FALSE)
## read numeric activity labels for both original data sets 
train_activities <- read.table("./UCI HAR Dataset/train/y_train.txt", 
                               header = FALSE)
test_activities <- read.table("./UCI HAR Dataset/test/y_test.txt", 
                              header = FALSE)
## substitutes numeric labels with character ones and add the result
## as a column Activity to the merged data frame
merged$Activity <- sapply(c(train_activities[,1], test_activities[,1]), 
                        function(x) {act_labels[x,2]})


##### STEP 4 ###############

## clean column names
names(merged) <- gsub("[.]", "", names(merged))
names(merged) <- gsub("BodyBody", "Body", names(merged))


##### STEP 5 ###############

## create an independent tidy data set with the average of each 
## variable for each activity and each subject
tidyData <- ddply(merged, .(Subject, Activity), 
                  function(x) colMeans(x[, 1:66]))

## write the new tidy data set to a file
write.table(tidyData, file = "./tidydata.txt", 
            row.name = FALSE)

print("The script finished its work.")
print("The output is stored in tidydata.txt file in your working directory.")

