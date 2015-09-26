# The supporting functions ...

rawDataset <- function(dName) {
        
        # Purpose:
        #    To fetch the raw dataset for this project from the wild.
       
        # Inputs: 
        #    dName - Character vector of length 1 containing the current 
        #       name of raw data .zip file (less ".zip"), also the data- 
        #       directory name. 

        # Return:
        #    Character vector of length 1 containing the revised name of the 
        #       data directory. 

        # Note: 
        #    The file structure after unzipping is as follows:

        #       <dName>/activity_labels.txt
        #       <dName>/features.txt
        #       <dName>/features_info.txt
        #       <dName>/README.txt
        #       <dName>/test/Inertial Signals/... 
        #       <dName>/test/subject_test.txt
        #       <dName>/test/X_test.txt
        #       <dName>/test/y_test.txt
        #       <dName>/train/Inertial Signals/... 
        #       <dName>/train/subject_train.txt
        #       <dName>/train/X_train.txt
        #       <dName>/train/y_train.txt

        #    All files are UNIX text files with LF line breaks.
        
        #    The contents of the two 'Inertial Signals' directories are irrelevant
        #       for this project. 

        # Unzip '<dName>.zip' file in the 'dName' directory

        unzip(paste(dName, ".zip", sep = ""))

        # Return input directory name unchanged

        return(dName)
}


featureCatalog <- function(dName, fIndices) {

        # Purpose:
        #    To create a list of desired features. 

        # Inputs:
        #    dName - Character vector of length 1 containing the name of 
        #       the data directory. 
        #    fIndices - Numeric vector of length equal to the number of desired 
        #       features

        # Return:
        #    Data frame with rows equal in number to the length of fIndices; 
        #       each row contains:
        #       1) the index of a features and 
        #       2) the name of that feature, edited.

        # Select columns

        fCat <- read.table(paste(dName, "/features.txt", sep = ""))
        colnames(fCat) <- c("index", "name")

        fCat <- fCat[fCat$index %in% fIndices, ]

        # Edit names

        fCat$name <- gsub("()", "", fCat$name, fixed = TRUE)

        fCat$name <- gsub("BodyBody", "Body", fCat$name, fixed = TRUE)
        fCat$name <- gsub("AccJerk", "Jerk", fCat$name, fixed = TRUE)

        fCat$name <- gsub("GyroJerk", "Gacc", fCat$name, fixed = TRUE)
        fCat$name <- gsub("Gyro", "Gvel", fCat$name, fixed = TRUE)

        return(fCat)
}


featureValues <- function(dName, sdName, fCatalog) {

        # Purpose: 
        #    To combine the three files -- 'X_test.txt' ['X_train.txt'], 
        #       'subject_test.txt' ['subject_train.txt'], and 'y_test.txt' 
        #       ['y_train.txt'] -- into a single data frame with subject and 
        #       activity labels and column names.

        # Inputs:
        #    dName - Character vector of length 1 containing the name of the data 
        #       directory.
        #    sdName - Character vector of lenght 1 containing the name of the 
        #       subdirectory containing raw data files. 
        #    fCatalog - Data frame created by the function 'featureCatalog'. 

        # Return:
        #    Data frame with rows equal in number to number of lines in any 
        #       of the three raw data files; each row contains: 
        #       1) A numeric vector of length equal to the number of rows in 
        #          fCatalog; 
        #       2) A numeric vector of length 1 containing an activity label; and 
        #       3) A numeric vector of length 1 containing a subject label. 

        # Note:
        #    The columns of the output data frame containing subject labels and 
        #       activity labels are converted to factors. 

        # Set directory
        
        d <- paste(dName, "/", sdName, "/", sep = "")
        
        # Initialize dataframe

        fValues <- read.table(paste(d, "X_", sdName, ".txt", sep = ""))

        # Cull unwanted columns and add column names

        fValues <- fValues[, as.numeric(as.character(fCatalog$index))]
        colnames(fValues) <- fCatalog$name

        # Add named column for activity factor

        activities <- read.table(paste(d, "y_", sdName, ".txt", sep = ""))
        fValues[, "activity"] <- as.factor(activities[, 1])

        # Add named column for subject factor

        subjects <- read.table(paste(d, "subject_", sdName, ".txt", sep = ""))
        fValues[, "subject"] <- as.factor(subjects[, 1])

        return(fValues)
}


featureMeans <- function(nSubjects, nActivities, fValues) {

        # Purpose:
        #    To compute means of each feature for each subject-activity pair. 

        # Inputs:
        #    nSubjects - Numeric vector of length 1 containing number of subjects.
        #    nActivities - Numeric vector of length 1 containing number of activities.
        #    fCatalog - Data frame created by 'featureCatalog'.
        #    fValues - Data frame created by 'featureValues'. 

        # Return:
        #    Data frame with rows equal in number to the product of the number of 
        #       subjects and the number of activities; each row contains: 
        #       1) a numberic vector of length equal to the lenght of a row of 
        #          fValues less 2; 
        #       2) A numeric vector of length 1 containing an activity label; and 
        #       3) A numeric vector of length 1 containing a subject label. 

        # Note:
        #    The columns of the output data frame containing subject labels and 
        #       activity labels are factors. 

        # Initialize data frame 'fMeans' (to be returned) 

        nV <- length(fValues[1, ])

        fMeans <- data.frame(matrix(nrow = 0, ncol = nV))
        colnames(fMeans) <- colnames(fValues)

        # Build data-frame template to store means for a given subject

        fM0 <- data.frame(matrix(nrow = nActivities, ncol = nV))
        rownames(fM0) <- 1:nActivities
        colnames(fM0) <- colnames(fMeans)
        fM0[, 1:(nV-2)] <- rep(NA, (nV - 2)*nActivities)  # Initialize with NA
        fM0[, "activity"] <- 1:nActivities

        # Loop through subject-activity pairs

        for (s in 1:nSubjects) {

                # Focus on data for subject s

                fVs <- fValues[fValues$subject == s, ]

                # Build data frame of means for subject s

                fM <- fM0
                fM[, "subject"] <- rep(s, nActivities)
                for (a in 1:nActivities) {
                        fVsa <- fVs[fVs$activity == a, ]
                        if (nrow(fVsa) > 0) {  # Replace NAs
                                fM[a, 1:(nV-2)] <- 
                                        apply(fVsa[, 1:(nV-2)], 2, mean)
                        }
                }

                # Add result to data frame of means for all subjects

                fMeans <- rbind(fMeans, fM)
        }

        return(fMeans)
}


activityNames <- function(dName) {

        # Purpose:
        #    To acquire the activity names.

        # Inputs:
        #    dName - Character vector of length 1 containing the name of the data 
        #       directory. 

        # Return:
        #    Character vector of length equal to the number of lines in the 
        #       'activity_labels.txt' file and containing the activity names.

        df <- read.table(paste(dName, "/activity_labels.txt", sep = ""))
        aNames <- as.character(df[,2])

        return(aNames)
}


subjectNames <- function(nSubjects) {

        # Purpose:
        #    To acquire subject names.

        # Inputs:
        #    nSubjects - Numeric vector of length 1 specifying the number of subjects.

        # Return:
        #    Character vector of length equal to nSubject and containing 
        #       the subject names. 
        
        # Note:
        #    In this project, true subject names are unknown and subject names are 
        #    subject indices coerced to character vectors of length 1. 

        sNames <- as.character(c(1:nSubjects))

        return(sNames)
}


tidyDataset <- function(nSubjects, fMeans, fName) {
        
        # Purpose: 
        #    To output the data frame of feature means labelled by subject 
        #       and activity.
        
        # Input:
        #    nSubjects - Number of subjects (a proxy for a file containing a list 
        #       of subject names).
        #    fMeans - Data frame created by the function 'featureMeans'. 
        #    fName - Character vector of length 1 containing the name of the 
        #       output file (located in working directory)

        # Return:
        #    Nothing. 

        # Output:
        #    Text file containing the contents of the input data frame reformatted 
        #       with subject and activity names. 

        # Extract feature values

        nVars <- length(fMeans[1, ])
        fM <- fMeans[, 1:(nVars-2)]

        # Reformat activity column

        aNames <- activityNames(dName)
        fM <- cbind(aNames[fMeans$activity], fM)
        colnames(fM)[1] <- "activity"

        # Reformat subject column 

        sNames <- subjectNames(nSubjects)
        fM <- cbind(sNames[fMeans$subject], fM)
        colnames(fM)[1] <- "subject"

        # Output data frame as CSV text file

        write.table(fM, file = fName, sep = ',', row.names = FALSE)
}


# The main script ...

# Step 0:  Preliminaries

# 1) Establish a working directory and store the raw data .zip file in that directory. 

# 2) Run R and navigate to the working directory. 

# 3) Load this script and source it. 


# Step 1:  Unzip raw data file 

# Set data directory name (a magic number for this project) which will be a 
#    subdirectory of working directory 

dName <- "UCI HAR Dataset"

# Read and unzip data

dName <- rawDataset(dName)


# Step 2:  Create a "feature catalog" of desired features. 

# Set indices of desired features (a magic number for this project):  the 
#    indices of every pair of features which relate to the same underlying 
#    measurement and which contain "mean()" and "std()" in their respective names. 

fIndices <- c(
          1,   2,   3,   4,   5,   6, 
         41,  42,  43,  44,  45,  46, 
         81,  82,  83,  84,  85,  86, 
        121, 122, 123, 124, 125, 126, 
        161, 162, 163, 164, 165, 166, 
        201, 202, 
        214, 215, 
        227, 228, 
        240, 241, 
        253, 254, 
        266, 267, 268, 269, 270, 271, 
        345, 346, 347, 348, 349, 350, 
        424, 425, 426, 427, 428, 429, 
        503, 504, 
        516, 517, 
        529, 530, 
        542, 543 
        )

# Build feature catalog

fCatalog <- featureCatalog(dName, fIndices)


# Step 3:  Get and preprocess the test and train data sets

# 'test' raw data sets

fValuesTest <- featureValues(dName, "test", fCatalog)

# 'train' raw data sets

fValuesTrain <- featureValues(dName, "train", fCatalog) 


# Step 4:  Merge the two raw data sets. 

fValues <- rbind(fValuesTest, fValuesTrain)

rm(fValuesTest, fValuesTrain)


# Step 5:  Process the merged data set 

# Set number of subjects and number of activities (two magic numbers) 

nSubjects <- 30
nActivities <- 6

fMeans <- featureMeans(nSubjects, nActivities, fValues)


# Step 6:  Write output file

tidyDataset(nSubjects, fMeans, "tidyDataset.txt")
