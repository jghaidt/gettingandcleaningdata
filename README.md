#Course Project - Getting and Cleaning Data

##Introduction

The purpose of the "Getting and Cleaning Data" course project is to demonstrate the process of converting raw data from the wild into a clean and tidy dataset capable of supporting reproducible research. 

## Summary

The raw data of interest comes from an experiment in wearable computing which explored the feasibility of using a smartphone as a means of identifying (and presumably reporting) the physical activity of a person carrying the phone.  The reference of note for this experiment is the following: 

*Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.* 

The output of the experiment is contained in .zip file, the contents of which include eight files in three different directories which are relevant to this project.  An R-script was developed which extracts a subset of the raw data and packages it in a single, self-contained, CSV text file. The result is a tidy data package which serves as a model for further research using this HAR dataset. 

##Building the Tidy Dataset

The raw data addresses, ostensibly, 30 subjects performing 6 activities.  Each performance of a given activity by a given subject is described by a feature vector with 561 elements.  It is known that a given subject did, in general, perform a given activity multiple times, hence the justification for averaging.  Provision is made, however, for the possibility that a given subject not only "skipped" a given activity but also skipped all activities (i.e., "disappeared"). 

The script in the file **run_analysis.R** creates the desired product automatically, given that the raw-data file **UCI NAR Dataset.zip** is stored in the current working directory.  Load R Studio, make that directory the working directory, and source the script file.  The file **tidyData.txt** will appear in the working directory after a moderate delay. 

Alternatively, one may load this file **run_analysis.R** and execute steps below one-by-one. 

**Step 0:  Preliminaries**

Perform the following steps: 

- Establish a working directory and store the raw data .zip file in that directory;
- Run R and navigate to the working directory; and 
- Load this script and source it (one run the commands below one at a time. 

**Step 1:  Unzip the raw data file** 

Set the data directory name, in anticipation of what the routine unzip() is going to do, that is, use the name 'UCI HAR Dataset', which is now a "magic number," for a subdirectory in which it will unzip the raw datafiles. 

    dName <- "UCI HAR Dataset"

Set the URL for the .zip file (another magic number):  

    URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

Read and unzip the data

    dName <- rawDataset(directoryName, URL)

The raw data are now in the data directory and two subdirectories of it: 'test' and 'train'.

**Step 2:  Create a "feature catalog" of desired features** 

Set a vector of the indices of desired features (another magic number).  The numbers are as listed above above. 

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
    424, 425, 426, 427, 428, 428, 
    503, 504, 
    516, 517, 
    529, 530, 
    542, 543 
    )
    
Build a data frame of the desired features, ala 'features.txt' less the unwanted features. 

    fCatalog <- featureCatalog(dName, fIndices)

The function 'featureCatalog' performs the editing of feature names described above.
    
**Step 3:  Get and pre-process the 'test' and 'train' data sets**

Merge the contents of the three data files in subdirectory 'test' into a single data frame, thereby labeling the feature vectors: 

    fValuesTest <- featureValues(dName, "test", fCatalog)
        
Likewise for the subdirectory 'train':

    fValuesTrain <- featureValues(dName, "train", fCatalog) 

**Step 4:  Merge the two raw data sets** 

Merge the test and train data frames into one and then remove the former two: 

    fValues <- rbind(fValuesTest, fValuesTrain)
    rm(fValuesTest, fValuesTrain)

**Step 5:  Process the merged data set** 

Set the number of subjects and the number of activities (two additional magic numbers): 

    nSubjects <- 30
    nActivities <- 6

Compute means over the individual features with respect to each subject-activity pair:

    fMeans <- featureMeans(nSubjects, nActivities, fValues)

**Step 6:  Write output file**

Write the data frame 'fMeans' as a CSV file named 'tidyDataset.txt':

    tidyDataset(nSubjects, fMeans, "tidyDataset.txt")
