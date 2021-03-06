#Course Project - Getting and Cleaning Data

##Introduction

The purpose of the "Getting and Cleaning Data" course project is to demonstrate the process of converting raw data from the wild into a clean and tidy dataset capable of supporting reproducible research. 

## Summary

The raw data of interest comes from an experiment in wearable computing which explored the feasibility of using a smartphone as a means of identifying (and presumably reporting) the physical activity of a person carrying the phone.  The reference of note for this experiment is the following: 

*Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.* 

The data generated by the experiment -- feature vectors describing a given subject performing a given activity -- were made available in a .zip file.  Includede in this .zip file are eight files relevant to the course project scattered among three different directories.  An R-script is outlined below which converts the data in these eight files into a single clean and tidy dataset of averages of prescribed features.  The product of this script is the self-documenting dataset stored in **tidyDataset.txt**. 

Detailed descriptions of the raw and tidy datasets are given in **CodeBook.md**.  The R code below, together with a number of supporting functions, is contained in **run_analysis.R**.  

##Building the Tidy Dataset

The raw data contains a number of 561-element feature vectors, each of which measures some aspect of the performance of a given activity by a given subject.  Ostensibly, the data address the performance of every one of 6 activities by every one of 30 subjects. 

The raw data support the creation of a single dataset of labeled (by activity and subject)feature vectors. The tidy dataset represents a reduced summary of this larger dataset:  first, all but 66 features are discarded; second, the reduced feature vectors are averaged over each subject-activity pair. 

The resulting matrix of means consists of 180 rows and 66 columns.  Conversion of this matrix into the desired tidy dataset requires that each row be labeled by subject and activity (requiring two additional columns) and names be provide for all 68 columns.  (Provision is made for the possibility that a given subject "skipped" a given activity; in this case, the row will contain missing-data labels.) 

The script below implements the process just described.  Given that the raw-data file **UCI NAR Dataset.zip** is stored in the current R working directory, one need only source the file **run\_analysis.R** to create the desired tidy dataset in **tidyData.txt**.  Alternatively, one may load the file **run\_analysis.R** and execute the steps below one-by-one. 

**Step 0:  Preliminaries**

Perform the following steps: 

- Establish a working directory and store the raw data file **UCI NAR Dataset.zip** in that directory;
- Run R and navigate to the working directory; and 
- Load this script and source it (or run the commands below one at a time). 

**Step 1:  Unzip the raw data file** 

Set the data directory name, in anticipation of what the routine unzip() is going to do, that is, use the name 'UCI HAR Dataset', which is now a "magic number," for a subdirectory in which it will unzip the raw datafiles. 

    dName <- "UCI HAR Dataset"

Read and unzip the data

    dName <- rawDataset(dName)

The raw data are now in the directory 'UCI HAR Dataset' and two subdirectories: 'test' and 'train'.

**Step 2:  Create a "feature catalog" of desired features** 

Set a vector of the indices of desired features (another magic number).  The numbers are the following (see CodeBook.md): 

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
    
Build a data frame of cataloging the desired features: 

    fCatalog <- featureCatalog(dName, fIndices)

The function 'featureCatalog' performs the editing of feature names described in CodeBook.md.
    
**Step 3:  Get and pre-process the 'test' and 'train' data sets**

Merge the contents of the three data files in subdirectory 'test' into a single data frame of labeled feature vectors: 

    fValuesTest <- featureValues(dName, "test", fCatalog)
        
Likewise for the subdirectory 'train':

    fValuesTrain <- featureValues(dName, "train", fCatalog) 

**Step 4:  Merge the two raw data sets** 

Merge the test and train data frames into one and then remove the former two objects: 

    fValues <- rbind(fValuesTest, fValuesTrain)
    rm(fValuesTest, fValuesTrain)

**Step 5:  Process the merged data set** 

Set the number of subjects and the number of activities (two additional magic numbers, in principle): 

    nSubjects <- 30
    nActivities <- 6

Compute means over the individual features with respect to each subject-activity pair:

    fMeans <- featureMeans(nSubjects, nActivities, fValues)

This dataframe is the desired result. 

**Step 6:  Write the output file**

Convert the data frame 'fMeans' into a CSV file named 'tidyDataset.txt':

    tidyDataset(nSubjects, fMeans, "tidyDataset.txt")
