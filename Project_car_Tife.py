import pandas as pd
import numpy as np
from sklearn.preprocessing import LabelEncoder
from sklearn.model_selection import train_test_split
# Import necessary packages
# import matplotlib.pyplot as plt

data = pd.read_csv('car.data')
# Read in dataset
# data.head()
# view dataset
# CAR - Unacceptable, Acceptable, Good, Very Good

data.columns = ['Buying', 'Maint','Doors', 'Person', 'Lug_boot', 'Safety', 
                'CAR']
# name the columns of the data
data.loc['-1'] = ['vhigh', 'vhigh','2', '2', 'small', 'low', 'unacc']
# in the process of naming the columns, we lost an instance. We add the instance
# back to the data
                
# data.head()

data.isna().sum()
# Thankfully, the data contains no null/empty cell.
# data.describe()

la = LabelEncoder()
# Label Encoding is a technique that is used to convert categorical columns 
# into numerical ones so that they can be fitted by machine learning models 
# which only take numerical data. It is an important pre-processing step in a 
# machine-learning project.

# Fit label encoder and return encoded labels.

data['Buying'] = la.fit_transform(data['Buying'])
data['Maint'] = la.fit_transform(data['Maint'])
data['Lug_boot'] = la.fit_transform(data['Lug_boot'])
data['Safety'] = la.fit_transform(data['Safety'])
data['Doors'] = la.fit_transform(data['Doors'])
data['Person'] = la.fit_transform(data['Person'])
data['CAR'] = la.fit_transform(data['CAR'])
data.head()

X = data.drop('CAR', axis=1)
# This drops the last column - response variable leaving the feature variables.
y = data['CAR']
# It takes the response variable.

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
# This splits the data into test and train sets with an assigned randomness.
# The random_state in the algorithm controls the bootstrapping of the samples 
# when creating trees and getting a random subset of features to search for the
# best feature during the node splitting process when creating each tree.                                                   

# Next we import the classifier and fit the data.
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score

model = RandomForestClassifier(oob_score = True)
# In each decision tree, there is an out of bag (oob) sample which contains
# every row not included in the bootstrap training data for that decision tree,
# and a majority prediction is noted for each row. 
# So the total oob_score for the data set is the percentage of correctly 
# predicted rows from the out of bag sample.

model.fit(X_train, y_train)

test_score = model.oob_score_

prediction = model.predict(X_test)
# This returns the prediction(y) of the test sets based on the trained data.
accuracy = accuracy_score(y_test, prediction)
# How accurate is the prediction?
