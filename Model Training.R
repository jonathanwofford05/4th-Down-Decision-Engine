# Model Training
df <- read_rds("data/processed/fourth_down_data.rds")

set.seed(42)
index <- createDataPartition(df$success, p = .8, list = FALSE)
train <- df[index, ]
test  <- df[-index, ]

dtrain <- xgb.DMatrix(as.matrix(train[,-1]), label = train$success)
dtest  <- xgb.DMatrix(as.matrix(test[,-1]), label = test$success)

xgb_model <- xgboost(
  data = dtrain,
  max.depth = 5,
  eta = 0.1,
  nrounds = 200,
  subsample = 0.9,
  colsample_bytree = 0.9,
  objective = "binary:logistic",
  eval_metric = "auc",
  verbose = 0
)

saveRDS(xgb_model, "outputs/conversion_model.rds")

library(pROC)

pred_probs <- predict(xgb_model, dtest)
roc_obj <- roc(test$success, pred_probs)

print(auc(roc_obj))

plot(roc_obj, main = paste("ROC Curve - AUC:", round(auc(roc_obj),3)))

importance <- xgb.importance(model = xgb_model)
print(importance)

xgb.plot.importance(importance_matrix = importance, top_n = 10)

