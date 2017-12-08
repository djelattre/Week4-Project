#----------------------------------------------------------
# Variables used
#----------------------------------------------------------

mywd : define the working directory
data.directorate : contains the name of the output folder
url : url for dl the data
zip.filename : name of the zipfile to dl
features_table : contains data of the file feaures.txt
features_name : vector that contains names of the variables
train_x : contains data of the file X_train.txt
train_subject : contains data of the file subject_train.txt
train_y : contains data of the file Y_train.txt
train_full : merge of the 3 previous var.
test_x : contains data of the file X_test.txt
test_subject : contains data of the file subject_test.txt
test_y : contains data of the file Y_test.txt
test_full : merge of the 3 previous var.
data : merge of train_full and test_full
mean_and_std_col : contains the variables names matching with mean or std or subject or activity
dataset : subset of data with the columns that are matching with the mean_and_std_col variable
activity_table : contains the activity labels
i : used for a for loop incrementation
dataset_names : contains the columns names of dataset
tiny_dataset : used to generate the output file, calculate the mean of each variable of a dataset, group by a subject id and an activity label


#----------------------------------------------------------
# Files used
#----------------------------------------------------------

'features_info.txt': Shows information about the variables used on the feature vector.
'features.txt': List of all features.
'activity_labels.txt': Links the class labels with their activity name.
'train/X_train.txt': Training set.
'train/y_train.txt': Training labels.
test/X_test.txt': Test set.
'test/y_test.txt': Test labels.

