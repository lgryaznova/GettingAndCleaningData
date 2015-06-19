# Getting and Cleaning Data Course Project


## Introduction

The script **run_analysis.R** deals with two given data sets and does the following:

* Merges the training and the test sets to create one data set.
* Extracts only the measurements on the mean and standard deviation for each measurement.
* Uses descriptive activity names to name the activities in the data set.
* Appropriately labels the data set with descriptive variable names.
* From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The output of the script is written to the file called **'tidydata.txt'** located in the working directory.

The repo also includes **CodeBook.md** which describes the meaning of each column in the tidy data set produced by the script.

The data for the project can be downloaded here:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 


## Important Notice

The data should be **downloaded and unzipped** to the working directory in advance maintaining the inner structure of the archive. The script expects to find the data in the 'UCI HAR Dataset' folder (which has 'test' and 'train' subfolders) in your working directory.

The script needs **plyr** package. If the package is not installed, run the following code in R console to obtain it:
```{r}
install.packages("plyr")
```

**To run the script** source it to the console using
```{r}
source('run_analysis.R')
```
When the script finishes its work, the message will be displayed and your working directory will contain the file 'tidydata.txt' with the script's output.


## Data Processing

The following files from the original dataset are used by the script:

* 'features_info.txt': Shows information about the variables used on the feature vector.
* 'features.txt': List of all features.
* 'activity_labels.txt': Links the class labels with their activity name.
* 'train/X_train.txt': Training set.
* 'train/y_train.txt': Training labels.
* 'test/X_test.txt': Test set.
* 'test/y_test.txt': Test labels.
* 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.
* 'test/subject_test.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30.

### Step 1

The script loads variable names from 'features.txt' into `varnames`. Then the script reads in both training and test data sets into `train` and `test` variables respectively using `varnames` as column names of those data frames.

Both data frames are merged into `merged` maintaining the order of rows (`train` rows go first, `test` rows are added at the bottom).

### Step 2

Since only the measurements on the mean and standard deviation for each measurement are needed, the script must subset the dataset and remove unnecessary columns. 'features_info.txt' informs that variable names for mean and standard deviation values contain 'mean()' and 'std()' respectively. 

Therefore the script searches for the variables containing corresponding chunks of letters and symbols in the `varnames` vector, and it stores their indices in `indices`. Then the script subsets the `merged` data frame leaving only the requested columns (marked by `indices`).

### Step 3

The script adds two columns `Subject` and `Activity` to the `merged` data frame.

`Subject` represents persons who performed the activity for each window sample. Its range is from 1 to 30. These labels are found in 'train/subject_train.txt' for the training set and the respective file in the 'test' subfolder for the test set.

The script reads the labels from the files into `train_subj` and `test_subj`, combine them together in the specified order (training labels go first, test ones go second), and add them as the `Subject` column to the `merged` data frame.

`Activity` represents types of the performed activity which can be one of the following: WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING. Numeric representation (1 to 6) of these labels for each row of each original data set can be found in 'train/y_train.txt' for the training set and the respective file in the 'test' subfolder for the test set.

A table linking numeric activity labels to their six character names is stored in 'activity_labels.txt'.
The script reads this table into `act_labels`.

Next, the script reads activity labels for both original data sets from the respective files into `train_activities` and `test_activities`. Then it combines the output into a single vector, loops over this vector to apply a function which substitutes numeric labels with character ones based on the `act_labels` table, and adds the result as `Activity` column to the `merged` data frame.

### Step 4

The script cleans the data frame column names by removing unnecessary symbols and typos. However, the column names remain quite concise as making them too long (e.g. using complete words only) results in lower readability of the data frame. For complete explanation of each column name please read CodeBook.md.

### Step 5

The script creates an independent tidy data set with the average of each variable for each activity and each subjectfrom the `merged` data set. `ddply` function from `plyr` package is used here. The new data set is stored in `tidyData` data frame and is written to the file 'tidydata.txt' in the working directory (NOT inside the 'UCI HAR Dataset' folder).



