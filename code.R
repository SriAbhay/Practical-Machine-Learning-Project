library(corrplot)
library(rpart)
library(e1071)

library(randomForest)
library(rpart.plot)


trainlink <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
testlink <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
train_set <- read.csv(url(trainlink), na.strings=c("NA","#DIV/0!",""))
test_set<- read.csv(url(testlink), na.strings=c("NA","#DIV/0!",""))

summary(train_set)
names(train_set)
#Remove unwanted variables (columns 1-7)
train_set <- train_set[,-c(1:7)]
test_set <- test_set[,-c(1:7)]
train_set$classe <- factor(train_set$classe)

#Select non NAs

nonNA <- sapply(train_set, function(x)all(!is.na(x)))
train_set <- train_set[,nonNA]
test_set <- test_set[,nonNA]

#Split the given training set into training and testing

TrSel = createDataPartition(y=train_set$classe, p=0.6, list=FALSE)
train = train_set[TrSel,]
test= train_set[-TrSel,]

#Random Forest

controlRf <- trainControl(method="cv", 5)
makeRF = train(classe ~ ., method = "rf", data=train,rControl=controlRf, ntree=16)
pred <- predict(makeRF, test)
#print(confusionMatrix(pred, test$classe))

#accuracy <- postResample(pred, test$classe)

#Run prediction using the given test set

completeTest <- predict(makeRF, test_set)
print(completeTest)

TD <- train_set[, sapply(train_set, is.numeric)]

corrPlot <- cor(TD[, -length(names(TD))])
corrplot(corrPlot, method="color")

Tree <- rpart(classe ~ ., data=train, method="class")
prp(Tree) 