setwd("C:\\Users\\ierul_000\\Downloads\\")

library(caret)
library(randomForest)
library(corrplot)

set.seed(5423)


training <- read.csv("pml-training.csv",na.strings= c("NA",""," ","#DIV/0!"))

training   <-training[,-c(1:7)]

training <- training[,which(apply(training, 2, function(x) {sum(is.na(x))}) == 0)]

train <- createDataPartition(y = training$classe, p = 0.6, list = FALSE)
xtrain <- training[train, ]
xtest <- training[-train, ]


correlationMatrix <- cor(xtrain[, -length(xtrain)])
corrplot(correlationMatrix, order = "hclust", addrect = 3, method = "circle" , type = "lower", tl.cex = 0.8 ,  tl.col = rgb(0, 0, 0))


model <- randomForest(classe ~ ., data = xtrain)

CrossVal <- predict(model, xtest)
confusionMatrix(xtest$classe, CrossVal)




testing <- read.csv("pml-testing.csv",na.strings= c("NA",""," ","#DIV/0!"))
testing    <-testing[,-c(1:7)]

datatest <- testing[,which(apply(testing, 2, function(x) {sum(is.na(x))}) == 0)]



prediction <- predict(model, datatest)
prediction

pml_write_files = function(x){
  n = length(x)
  for(i in 1:n){
    filename = paste0("problem_id_",i,".txt")
    write.table(x[i],file=filename,quote=FALSE,row.names=FALSE,col.names=FALSE)
  }
}

pml_write_files(prediction)








