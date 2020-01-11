# load the dataset
# https://www.kaggle.com/pavansubhasht/ibm-hr-analytics-attrition-dataset
attrition <-
  read.csv(
    "WA_Fn-UseC_-HR-Employee-Attrition.csv",
    header = TRUE,
    stringsAsFactors = FALSE
  )

# remove because all values are the same ("yes"). no new information
attrition$Over18 <- NULL
attrition$Attrition <- factor(attrition$Attrition)

#%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% caret
library(caret)

set.seed(123)
trainIndex <- createDataPartition(attrition$Attrition,
                                  p = 0.8, # training contains 80% of data
                                  list = FALSE)
dfTrain <- attrition[ trainIndex,]
dfTest  <- attrition[-trainIndex,]

control <- trainControl(method = "cv",
                        number = 10,
                        classProbs = TRUE,
                        summaryFunction = twoClassSummary)

model_glm <- train(Attrition ~ MonthlyIncome + Gender + JobSatisfaction + YearsAtCompany,
                   data = dfTrain,
                   method = "glm",
                   family = "binomial",
                   trControl = control)
# summary(model_glm)
# TODO: out-of-sample tests / compare to other models

saveRDS(model_glm, "model_glm.Rds")
