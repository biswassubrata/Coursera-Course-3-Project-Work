#
# Download and unzip the data file, if they are not available already
#
if (!file.exists("datafile.zip")) {
    download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "datafile.zip")
}
if (file.exists("UCI HAR Dataset")) {
    unlink("UCI HAR Dataset")
}
unzip("datafile.zip")

#
# Identify the required features
#
features <- read.csv("UCI HAR Dataset/features.txt", sep="", header=F, stringsAsFactors = FALSE)
requiredFeatures <- grep("(mean|std)\\(\\)", tolower(features[, 2]))
activities <- read.csv("UCI HAR Dataset/activity_labels.txt", header=F, sep="", stringsAsFactors = FALSE)

#
# Read and merge test data and training data
#

test <- read.csv("UCI HAR Dataset/test/X_test.txt", header=F, sep="")[requiredFeatures]
testSubjects <- read.csv("UCI HAR Dataset/test/subject_test.txt", header=F, sep="")
testActivities <- read.csv("UCI HAR Dataset/test/Y_test.txt", header=F, sep="")
test <- cbind(testSubjects, testActivities, test)

train <- read.csv("UCI HAR Dataset/train/X_train.txt", header=F, sep="")[requiredFeatures]
trainSubjects<- read.csv("UCI HAR Dataset/train/subject_train.txt", header=F, sep="")
trainActivities <- read.csv("UCI HAR Dataset/train/Y_train.txt", header=F, sep="")
train <- cbind(trainSubjects, trainActivities, train)

mergedData <- rbind(test, train)

#
# Assign meaningful column names
#

colnames(mergedData) <- c("Subjects", "Activities", features[requiredFeatures, 2])
mergedData$Activities <- activities[mergedData$Activities, 2]

#
# Create tidy data
#

tidyData <- aggregate(mergedData[3:68],
                      list(Subjects = mergedData$Subjects, Activities = mergedData$Activities),
                      mean)
write.table(tidyData, "tidyData.txt", row.names = FALSE, quote=FALSE)
