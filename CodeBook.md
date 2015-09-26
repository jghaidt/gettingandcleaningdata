#CodeBook for Course Project

##Introduction

The purpose of the "Getting and Cleaning Data" course project is to demonstrate the process of converting raw data from the wild into a clean and tidy dataset capable of supporting reproducible research.  The content and form of this tidy dataset are a given of the project.

## Raw Dataset

The raw data of interest comes from an experiment in wearable computing in which researchers explored the feasibility of using a smartphone (one with built-in accelerometers and gyroscopes) as a means of identifying (and presumably reporting) the physical activity of a person carrying the phone.  The reference of note for this experiment is the following: 

*Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. A Public Domain Dataset for Human Activity Recognition Using Smartphones. 21th European Symposium on Artificial Neural Networks, Computational Intelligence and Machine Learning, ESANN 2013. Bruges, Belgium 24-26 April 2013.* 

Guided by machine-learning methodology, Anguita *et al.* performed the following experiment to create a dataset of feature vectors with which one could develop, train, and test an algorithm to infer physical-activity type from accelerometer and gyroscope observations. 

1. Thirty subjects performed a sequence of six physical activities: walking (level); walking (upstairs); walking (downstairs); sitting; standing; and lying. The subjects wore a smartphone whose sensors provided time-sampled measurements of bodily motion, specifically linear acceleration (three components) and angular velocity (three components).  Subsequent visual inspection of the measurements allowed the resulting six-dimensional time series recorded for each subject to be segmented according to activity type. 
2. Each (six-dimensional) time series was filtered, windowed, and otherwise processed to yield a set of 561-element feature vectors labeled according to subject and activity.  The number of feature vectors per subject and, hence, per activity was allowed to vary. 
3. The set of feature vectors was divided according to subject into two sets:  "training" and "test".  The training set comprised 7,353 feature vectors from 21 subjects; the test set, 2,947 feature vectors from the remaining 9 subjects. 

The two sets of feature vectors are available for download as part of a .zip file at the UCI website [http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). [Note:  For this project, the source file at https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip was used.  Ostensibly the two .zip files are identical.]  The .zip file contains the following files:

1. **activity_labels.txt**:  numeric labels assigned to each of the six activities identified above;
2. **subject_labels.txt**:  numeric labels assigned to each of the thirty subjects (a virtual file, because the subjects are not identified publicly); 
3. **features.txt**:  descriptions of the 561 features in a feature vector; 
4. **X\_train.txt**:  the 7,353 feature vectors chosen for training; 
5. **subject\_train.txt**:  the 7,353 subject labels for the training vectors; 
6. **y\_train.txt**:  the 7,353 activity labels for the training vectors. 
7. **X\_test.txt**:  the 2,947 feature vectors chosen for testing;
8. **subject\_test.txt**:  the 2,947 subject labels for the testing vectors; 
9. **y\_test.txt**:  the 2,947 activity labels for the testing vectors. 

Also included in the .zip file are two files, namely **README.txt** and **features_info.txt**,  containing additional descriptive information. 

[Also included in the .zip file are several additional files in the directories **train/Inertial Signals** and **test/Inertial Signals**.  The contents of these files represent the raw data acquired by Anguita *et al.* and are irrelevant for this project.] 

Note that feature values have, by some means, been normalized to the [-1, 1] interval and, hence, are dimensionless. 

##Tidy Dataset

The requirement of the project is to produce a single datafile which captures a portion of the raw dataset and modifies the original labeling to make it more accessible way.  Accompanying the tidy dataset is this codebook, which, together with an R script (**run_analysis.R**), describes the final product in more detail and the process by which it may be re-created. 

By requirement, the tidy dataset is to address all features of the raw dataset which are labeled as means ("mean()") or standard deviations ("std()"), presumably occurring in pairs.  With this understanding, one can identify 66 such features (or 33 pairs of features) as follows, with their original names: 

1. 1 tBodyAcc-mean()-X
2. 2 tBodyAcc-mean()-Y
3. 3 tBodyAcc-mean()-Z
4. 4 tBodyAcc-std()-X
5. 5 tBodyAcc-std()-Y
6. 6 tBodyAcc-std()-Z
7. 41 tGravityAcc-mean()-X
8. 42 tGravityAcc-mean()-Y
9. 43 tGravityAcc-mean()-Z
10. 44 tGravityAcc-std()-X
11. 45 tGravityAcc-std()-Y
12. 46 tGravityAcc-std()-Z
13. 81 tBodyAccJerk-mean()-X
14. 82 tBodyAccJerk-mean()-Y
15. 83 tBodyAccJerk-mean()-Z
16. 84 tBodyAccJerk-std()-X
17. 85 tBodyAccJerk-std()-Y
18. 86 tBodyAccJerk-std()-Z
19. 121 tBodyGyro-mean()-X
20. 122 tBodyGyro-mean()-Y
21. 123 tBodyGyro-mean()-Z
22. 124 tBodyGyro-std()-X
23. 125 tBodyGyro-std()-Y
24. 126 tBodyGyro-std()-Z
25. 161 tBodyGyroJerk-mean()-X
26. 162 tBodyGyroJerk-mean()-Y
27. 163 tBodyGyroJerk-mean()-Z
28. 164 tBodyGyroJerk-std()-X
29. 165 tBodyGyroJerk-std()-Y
30. 166 tBodyGyroJerk-std()-Z
31. 201 tBodyAccMag-mean()
32. 202 tBodyAccMag-std()
33. 214 tGravityAccMag-mean()
34. 215 tGravityAccMag-std()
35. 227 tBodyAccJerkMag-mean()
36. 228 tBodyAccJerkMag-std()
37. 240 tBodyGyroMag-mean()
38. 241 tBodyGyroMag-std()
39. 253 tBodyGyroJerkMag-mean()
40. 254 tBodyGyroJerkMag-std()
41. 266 fBodyAcc-mean()-X
42. 267 fBodyAcc-mean()-Y
43. 268 fBodyAcc-mean()-Z
44. 269 fBodyAcc-std()-X
45. 270 fBodyAcc-std()-Y
46. 271 fBodyAcc-std()-Z
47. 345 fBodyAccJerk-mean()-X
48. 346 fBodyAccJerk-mean()-Y
49. 347 fBodyAccJerk-mean()-Z
50. 348 fBodyAccJerk-std()-X
51. 349 fBodyAccJerk-std()-Y
52. 350 fBodyAccJerk-std()-Z
53. 424 fBodyGyro-mean()-X
54. 425 fBodyGyro-mean()-Y
55. 426 fBodyGyro-mean()-Z
56. 427 fBodyGyro-std()-X
57. 428 fBodyGyro-std()-Y
58. 429 fBodyGyro-std()-Z
59. 503 fBodyAccMag-mean()
60. 504 fBodyAccMag-std()
61. 516 fBodyBodyAccJerkMag-mean()
62. 517 fBodyBodyAccJerkMag-std()
63. 529 fBodyBodyGyroMag-mean()
64. 530 fBodyBodyGyroMag-std()
65. 542 fBodyBodyGyroJerkMag-mean()
66. 543 fBodyBodyGyroJerkMag-std()

The number accompanying each measurement refers to its place, or index, in a 561-element feature vector.  

These feature names are to be interpreted according to the following associations and dimensions: 

- t - time-domain
- f - frequency domain
- Body - bandpass-filtered signal (0.3 to 20.0 Hz)
- Gravity - lowpass-filtered signal (0.0 to 0.3 Hz)
- Acc - linear acceleration (dimensionless)
- Gyro - angular velocity (dimensionless)
- AccJerk - linear jerk (time derivative of acceleration) (dimensionless)
- GyroJerk - angular acceleration (dimensionless)
- Mag - magnitude of vector (dimensionless)
- X, Y, Z - Cartesian axes

Thus, e.g., fBodyAccJerk-mean()-X is the normalized mean of the x-component of the body jerk signal in the frequency domain. 

Candidate simplifications to this naming scheme are obvious: 

- Eliminate the "()";
- Substitute "Body" for "BodyBody";
- Substitute "Jerk" for "AccJerk";
- Substitute "Gvel" (angular velocity) for "Gyro"; 
- Substitute "Gacc" (angular acceleration) for "GyroJerk".

With these modifications, one obtains the following feature catalog: 

1. 1 tBodyAcc-mean-X
2. 2 tBodyAcc-mean-Y
3. 3 tBodyAcc-mean-Z
4. 4 tBodyAcc-std-X
5. 5 tBodyAcc-std-Y
6. 6 tBodyAcc-std-Z
7. 41 tGravityAcc-mean-X
8. 42 tGravityAcc-mean-Y
9. 43 tGravityAcc-mean-Z
10. 44 tGravityAcc-std-X
11. 45 tGravityAcc-std-Y
12. 46 tGravityAcc-std-Z
13. 81 tBodyJerk-mean-X
14. 82 tBodyJerk-mean-Y
15. 83 tBodyJerk-mean-Z
16. 84 tBodyJerk-std-X
17. 85 tBodyJerk-std-Y
18. 86 tBodyJerk-std-Z
19. 121 tBodyGvel-mean-X
20. 122 tBodyGvel-mean-Y
21. 123 tBodyGvel-mean-Z
22. 124 tBodyGvel-std-X
23. 125 tBodyGvel-std-Y
24. 126 tBodyGvel-std-Z
25. 161 tBodyGvel-mean-X
26. 162 tBodyGacc-mean-Y
27. 163 tBodyGacc-mean-Z
28. 164 tBodyGacc-std-X
29. 165 tBodyGacc-std-Y
30. 166 tBodyGacc-std-Z
31. 201 tBodyAccMag-mean
32. 202 tBodyAccMag-std
33. 214 tGravityAccMag-mean
34. 215 tGravityAccMag-std
35. 227 tBodyJerkMag-mean
36. 228 tBodyJerkMag-std
37. 240 tBodyGvelMag-mean
38. 241 tBodyGvelMag-std
39. 253 tBodyGaccMag-mean
40. 254 tBodyGaccMag-std
41. 266 fBodyAcc-mean-X
42. 267 fBodyAcc-mean-Y
43. 268 fBodyAcc-mean-Z
44. 269 fBodyAcc-std-X
45. 270 fBodyAcc-std-Y
46. 271 fBodyAcc-std-Z
47. 345 fBodyJerk-mean-X
48. 346 fBodyJerk-mean-Y
49. 347 fBodyJerk-mean-Z
50. 348 fBodyJerk-std-X
51. 349 fBodyJerk-std-Y
52. 350 fBodyJerk-std-Z
53. 424 fBodyGvel-mean-X
54. 425 fBodyGvel-mean-Y
55. 426 fBodyGvel-mean-Z
56. 427 fBodyGvel-std-X
57. 428 fBodyGvel-std-Y
58. 429 fBodyGvel-std-Z
59. 503 fBodyAccMag-mean
60. 504 fBodyAccMag-std
61. 516 fBodyJerkMag-mean
62. 517 fBodyJerkMag-std
63. 529 fBodyGvelMag-mean
64. 530 fBodyGvelMag-std
65. 542 fBodyGaccMag-mean
66. 543 fBodyGaccMag-std

These feature names are somewhat tidier but still traceble to the original. 

The tidy dataset is as a CSV text file: **tidyDataset.txt**.  It consists of 66 features for each of 6 activities for each of 30 subjects with labels for all columns and includes names for the activities and the subjects. 


