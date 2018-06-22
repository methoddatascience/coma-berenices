
###  Reading in the training dataset - I only use one file for my model
setwd("C:/Tommy/Kaggle/HomeCredit")
application_train = read.csv("application_train.csv", stringsAsFactors = FALSE)

###I want TARGET to be a factor
#application_train$TARGET <- as.factor(application_train$TARGET)

###Only use clean columns
data <- application_train[c(2:21)]
summary(data)
#Note - TARGET has an incidence rate of .0807 - just over 8% of the records are 1

## Logic here for splitting dataset to train and validate
## I was using a small percentage of the data - I do this in the early stages to deal with memory issue
#Not sure if this is randome - but not an issue - I just use the whole dataset
indexes = sample(1:nrow(data), size=0.2*nrow(data))
#test = data[indexes,]
#dim(test)
#train = application_train[-indexes,]

# Look at a logistic regression using all the remaining columns to see what is significant
model <- glm(TARGET~., data=data, family="binomial")
summary(model)



# estimate variable importance

library(caret)
importance <- data.frame(varImp(model, scale=TRUE))
importance


#No formulaic approach - I just looked at the statistically significant variables with the highest importance
# Use those variables to calculate a confusion matrix
#Use 8.07% as cutoff - this is population average



model2 <- glm(TARGET~ CODE_GENDER + AMT_CREDIT + AMT_GOODS_PRICE + DAYS_EMPLOYED, data=data, family="binomial")
summary(model2)
prediction <- predict(model2, data, type = "response")
summary(prediction)



confusion <- table(data$TARGET, prediction >= 0.0807)
confusion


##Now make predictions on the testing dataset

application_test = read.csv("application_test.csv", stringsAsFactors = FALSE)

prediction <- predict(model2, application_test, type = "response")
summary(prediction)


submission <- cbind(application_test, prediction)
submission<- submission[c(1,122)]

submission$TARGET <- ifelse(submission$prediction>0.0823,1,0)

submission<- submission[c(1,3)]

write.csv(submission,file = "submission.csv", row.names = FALSE)


