
# ============================================================
# Laptop Battery Health Statistical Analysis
# Part 2: Statistical Modelling and Evaluation
# ============================================================

# 1. Load dataset ------------------------------------------------

data_path <- "data/LaptopBatteryHealthPrediction.csv"

if (!file.exists(data_path)) {
  stop("Dataset not found. Run this script from the project root folder.")
}

dat <- read.csv(data_path)

dir.create("figures", showWarnings = FALSE)
dir.create("results", showWarnings = FALSE)

if (!requireNamespace("car", quietly = TRUE)) {
  stop("Please install the car package: install.packages('car')")
}

# 2. Pearson correlation hypothesis tests -----------------------

predictors <- c(
  "Battery.Age",
  "Cycle.Count",
  "Daily.Usage.Hours",
  "Average.Temperature"
)

correlation_tests <- lapply(predictors, function(variable) {
  cor.test(
    dat$Battery.Health,
    dat[[variable]],
    method = "pearson"
  )
})

correlation_results <- data.frame(
  Predictor = predictors,
  Correlation = sapply(correlation_tests, function(x) unname(x$estimate)),
  CI_Lower = sapply(correlation_tests, function(x) x$conf.int[1]),
  CI_Upper = sapply(correlation_tests, function(x) x$conf.int[2]),
  P_Value = sapply(correlation_tests, function(x) x$p.value)
)

cat("\nPearson correlation results:\n")
print(correlation_results)

write.csv(
  correlation_results,
  "results/correlation_results.csv",
  row.names = FALSE
)

# 3. Fit regression models using the full dataset ----------------

model_full <- lm(
  Battery.Health ~ Battery.Age + Cycle.Count +
    Daily.Usage.Hours + Average.Temperature,
  data = dat
)

model_age_cycle <- lm(
  Battery.Health ~ Battery.Age + Cycle.Count,
  data = dat
)

model_cycle <- lm(
  Battery.Health ~ Cycle.Count,
  data = dat
)

model_age <- lm(
  Battery.Health ~ Battery.Age,
  data = dat
)

models <- list(
  Full = model_full,
  Age_Cycle = model_age_cycle,
  Cycle_Only = model_cycle,
  Age_Only = model_age
)

cat("\nFull regression model summary:\n")
print(summary(model_full))

# 4. Export regression coefficients ------------------------------

coefficient_matrix <- summary(model_full)$coefficients

regression_coefficients <- data.frame(
  Predictor = rownames(coefficient_matrix),
  Estimate = coefficient_matrix[, "Estimate"],
  Std_Error = coefficient_matrix[, "Std. Error"],
  T_Value = coefficient_matrix[, "t value"],
  P_Value = coefficient_matrix[, "Pr(>|t|)"],
  row.names = NULL
)

write.csv(
  regression_coefficients,
  "results/regression_coefficients.csv",
  row.names = FALSE
)

# 5. Multicollinearity assessment --------------------------------

full_vif <- car::vif(model_full)
age_cycle_vif <- car::vif(model_age_cycle)

cat("\nFull model VIF:\n")
print(full_vif)

cat("\nAge + Cycle model VIF:\n")
print(age_cycle_vif)

capture.output(
  full_vif,
  file = "results/full_model_vif.txt"
)

capture.output(
  age_cycle_vif,
  file = "results/age_cycle_model_vif.txt"
)

# 6. Regression diagnostics -------------------------------------

png(
  "figures/full_model_diagnostics.png",
  width = 1600,
  height = 1200,
  res = 150
)

par(mfrow = c(2, 2))
plot(model_full)
dev.off()

png(
  "figures/age_cycle_model_diagnostics.png",
  width = 1600,
  height = 1200,
  res = 150
)

par(mfrow = c(2, 2))
plot(model_age_cycle)
dev.off()

# 7. Compare full-data model fit ---------------------------------

model_names <- names(models)

model_fit_results <- data.frame(
  Model = model_names,
  Adjusted_R2 = sapply(
    models,
    function(model) summary(model)$adj.r.squared
  ),
  AIC = sapply(models, AIC),
  BIC = sapply(models, BIC),
  row.names = NULL
)

cat("\nModel fit comparison:\n")
print(model_fit_results)

# 8. Training and testing split ---------------------------------

set.seed(123)

train_index <- sample(
  seq_len(nrow(dat)),
  size = 0.8 * nrow(dat)
)

train <- dat[train_index, ]
test <- dat[-train_index, ]

cat("\nTraining observations:", nrow(train), "\n")
cat("Testing observations:", nrow(test), "\n")

# 9. Fit models on training data ---------------------------------

train_models <- lapply(
  models,
  function(model) {
    lm(formula(model), data = train)
  }
)

# 10. Predict battery health ------------------------------------

predictions <- lapply(
  train_models,
  function(model) {
    predict(model, newdata = test)
  }
)

# 11. Calculate prediction errors --------------------------------

RMSE <- function(actual, predicted) {
  sqrt(mean((actual - predicted)^2))
}

MAE <- function(actual, predicted) {
  mean(abs(actual - predicted))
}

prediction_results <- data.frame(
  Model = names(predictions),
  Test_RMSE = sapply(
    predictions,
    function(pred) RMSE(test$Battery.Health, pred)
  ),
  Test_MAE = sapply(
    predictions,
    function(pred) MAE(test$Battery.Health, pred)
  ),
  row.names = NULL
)

# 12. Combine model comparison results ---------------------------

model_comparison <- merge(
  model_fit_results,
  prediction_results,
  by = "Model",
  sort = FALSE
)

model_comparison <- model_comparison[
  match(model_names, model_comparison$Model),
]

rownames(model_comparison) <- NULL

cat("\nFinal model comparison:\n")
print(model_comparison)

write.csv(
  model_comparison,
  "results/model_comparison.csv",
  row.names = FALSE
)

# 13. Save full regression summary -------------------------------

capture.output(
  summary(model_full),
  file = "results/full_model_summary.txt"
)

# 14. Save R session information ---------------------------------

capture.output(
  sessionInfo(),
  file = "results/session_info.txt"
)

cat("\nStatistical modelling completed successfully.\n")

