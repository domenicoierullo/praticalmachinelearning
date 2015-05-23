---
title: "Final Project - Practical Machine Learning"
author: "Domenico Ierullo"
date: "2015-05-18"
output:
html_document:
    toc: true
    theme: united
---

# Abstract

Using special devices for activity tracking and fitness monitoring, it's possible collect a large amount of data about Human Activity Recognition (HAR).

The aim of this project is to analyze a set of data obtained from http://groupware.les.inf.puc-rio.br/har; these datasets represent readings of accelerometers places on the belt, forearm, arm, and dumbell of 6 participants. 

They were asked to perform barbell lifts Correctly and incorrectly in 5 different ways.

The datasets was used to predict how well they were doing the exercise in terms of the classification in the data.


### Libraries

Load libraries

```{r }
library(caret)
library(corrplot)
library(randomForest)
```

Set work directory and seed

```{r }
setwd("C:\\Users\\ierul_000\\Downloads\\")
set.seed(5423)
```

### Load and clean trainig dataset

Load training dataset and replace the missing or null values with the symbol NA:

```{r}
training <- read.csv("C:\\Users\\ierul_000\\Downloads\\pml-training.csv",na.strings= c("NA",""," ","#DIV/0!"))
```

Remove the first seven columns (identifiers) and clean the data by deleting columns with NA values:

```{r }
training   <-training[,-c(1:7)]

training <- training[,which(apply(training, 2, function(x) {sum(is.na(x))}) == 0)]

```

### Create model

The dataset was split in a 60:40 ratio in order to use data for training, cross validation and testing

```{r }
train <- createDataPartition(y = training$classe, p = 0.6, list = FALSE)
xtrain <- training[train, ]
xtest <- training[-train, ]

```


For this classification problem, random forest model was selected, after observing the correlation matrix to know variables relationship with each other

```{r }
correlationMatrix <- cor(xtrain[, -length(xtrain)])
corrplot(correlationMatrix, order = "hclust", addrect = 3, method = "circle" , type = "lower", tl.cex = 0.8 ,  tl.col = rgb(0, 0, 0))
```

The plot shows that there is not a high collerazione between predictors,so there is no need for a further analysis to reduce the number of predictors, so you do not have a overfitttng.


After this analisys we build the model, 

```{r }
model <- randomForest(classe ~ ., data = xtrain)
model
```

The model summary show OOB estimate of  error rate is 0.66%, acceptable rate. 


Using the 40% remaining data, make a crossvalidation for the model and show the confusion matrix to know prediction accuracy


```{r }
CrossVal <- predict(model, xtest)
confusionMatrix(xtest$classe, CrossVal)
```

The accuracy result was 99,45% and confirm random forest model is good for this classification problem.


### Make predicition

Load testing dataset and replace the missing or null values with the symbol NA:


```{r }
testing <- read.csv("C:\\Users\\ierul_000\\Downloads\\pml-testing.csv",na.strings= c("NA",""," ","#DIV/0!"))
testing    <-testing[,-c(1:7)]
datatest <- testing[,which(apply(testing, 2, function(x) {sum(is.na(x))}) == 0)]

```

Predict dataset classes

```{r }
prediction <- predict(model, datatest)
prediction
```












