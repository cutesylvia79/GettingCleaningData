# GettingCleaningData


## Pre-requsite
1. Set working directory with setwd()
2.  Download the "tidy_feature2.csv" from repo and copy to working directory that set on step 1.
3. Ensure packages "reshape2","dplyr","data.table"
    ```{r}
      install.packages("reshape2")
      install.packages("dplyr")
      install.packages("data.table")
    ```
4. The script allows 2 option of file source. User can choose to download from internet or use working directory as file source
    . in Run_analysis.R, change code in line 10 . change variable to value 0 to download from web, value 1 to use local working directory
    . If you use to download data from web, and your machine is "mac", please comment line 21 and uncomment line 24.
    

## Tidy Data
1. Each row of data contains record of each result of per subject and activity defined as single observation.
2. Each column represent each value of test return by each feature as in X-train
3. There is no duplicate columns
4. Each columns retrieve data from data originally with heading "mean()", and "std()".
5. Assumption made that Mean and standard deviation with X, Y, Z axis is taken into consideration too.
6. Data output with Space delimited, quoted text.


## Step to run analysis
1. Prepare environment as per pre_requiste session
2. run below code
    ```{r}
      source("run_analysis.R")
    ```
3. Download will take a while, depending on the connection speed to internet
4. file "tidy_dataset.txt" will be created in working directory as defined.

## What does the R script does
1.  It will download dataset in zip format from the URL and extract data into working directory
2.  It will read text file as below into variables with read.tables
    - activity_labels.txt
    - features.txt
    - subject_test.txt in test subfolder
    - X_test.txt in test subfolder
    - y_test.txt in test subfolder
    - subject_train.txt in train subfolder
    - X_train.txt in train subfolder
    - y_train.txt in train subfolder
3.  As in Line 52, list was initiate to be prepare for better "actitvity name" as in requirement 3
4.  It will filter out and leave out those measure with mean and std (standard deviation) as in define in code line 74 onwards. - requirement 2
5.  It will also need to read an external files as in defined in pre-requiste, to give the variable as in X-test, with more meaningfull name. The detail of the variable is declared in code book.md as well -- Requirement 4
6.  All data is being "narrowed" or melted with subjectid activityid and sourcetype with "melt" function
7.  It will horizontaly being "MERGE" from test set and training set, by using rbind
8.  Data set is being "widened" or "pivot" again with dcast function to generate the tidy data set. 
9.  It will write text files out to working directory
