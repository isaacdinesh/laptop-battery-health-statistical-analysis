
# Laptop Battery Health Statistical Analysis
# Statistical Methods for Data Science
#
# Run from the repository root directory.
# Dataset: data/LaptopBatteryHealthPrediction.csv

# --------------------------------------------------
# 1. Setup and data import
# --------------------------------------------------

if (!requireNamespace("car", quietly = TRUE)) {
  stop("Install the required package first: install.packages('car')")
}

library(car)

dir.create("results", showWarnings = FALSE, recursive = TRUE)

dat <- read.csv("data/LaptopBatteryHealthPrediction.csv")

# Dataset structure and quality checks
print(dim(dat))
str(dat)
print(colSums(is.na(dat)))
print(sum(duplicated(dat)))

# --------------------------------------------------
# 2. Pearson correlation hypothesis tests
# --------------------------------------------------

predictors <- c(
  "Battery.Age",
  "Cycle.Count",
  "Daily.Usage.Hours",
  "Average.Temperature"
)

correlation_results <- lapply(predictors, function(variable) {
  test <- cor.test(
    dat$Battery.Health,
    dat[[variable]],
    method = "pearson"
  )

  data.frame(
    Predictor = variable,
    Correlation = unname(test$estimate),
    CI_Lower = test$conf.int[1],
    CI_Upper = test$conf.int[2],
    P_Value = test$p.value
  )
})

correlation_results <- do.call(rbind, correlation_results)

print(correlation_results)

write.csv(
  correlation_results,
  "results/correlation_results.csv",
  row.names = FALSE
)

# --------------------------------------------------
# 3. Full multiple linear regression
# --------------------------------------------------

model_full <- lm(
  Battery.Health ~ Battery.Age +
    Cycle.Count +
    Daily.Usage.Hours +
    Average.Temperature,
  data = dat
)

print(summary(model_full))

# --------------------------------------------------
# 4. Multicollinearity and diagnostics
# --------------------------------------------------

print(vif(model_full))

capture.output(
  summary(model_full),
  file = "results/full_model_summary.txt"
)

capture.output(
  vif(model_full),
  file = "results/full_model_vif.txt"
)

png(
  "results/full_model_diagnostics.png",
  width = 1600,
  height = 1200,
  res = 150
)

par(mfrow = c(2, 2))
plot(model_full)
dev.off()

# --------------------------------------------------
# 5. Reduced regression models
# --------------------------------------------------

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
  "Full" = model_full,
  "Age + Cycle" = model_age_cycle,
  "Cycle Only" = model_cycle,
  "Age Only" = model_age
)

print(vif(model_age_cycle))

# --------------------------------------------------
# 6. Model comparison
# --------------------------------------------------

model_comparison <- data.frame(
  Model = names(models),
  Adjusted_R2 = sapply(
    models,
    function(model) summary(model)$adj.r.squared
  ),
  AIC = sapply(models, AIC),
  BIC = sapply(models, BIC),
  row.names = NULL
)

print(model_comparison)

# --------------------------------------------------
# 7. Train-test split
# --------------------------------------------------

set.seed(123)

train_index <- sample(
  seq_len(nrow(dat)),
  size = 0.8 * nrow(dat)
)

train <- dat[train_index, ]
test <- dat[-train_index, ]

cat("Training observations:", nrow(train), "\n")
cat("Testing observations:", nrow(test), "\n")

# --------------------------------------------------
# 8. Fit models on training data
# --------------------------------------------------

train_models <- list(
  "Full" = lm(
    Battery.Health ~ Battery.Age +
      Cycle.Count +
      Daily.Usage.Hours +
      Average.Temperature,
    data = train
  ),
  "Age + Cycle" = lm(
    Battery.Health ~ Battery.Age + Cycle.Count,
    data = train
  ),
  "Cycle Only" = lm(
    Battery.Health ~ Cycle.Count,
    data = train
  ),
  "Age Only" = lm(
    Battery.Health ~ Battery.Age,
    data = train
  )
)

# --------------------------------------------------
# 9. Predictive performance
# --------------------------------------------------

RMSE <- function(actual, predicted) {
  sqrt(mean((actual - predicted)^2))
}

MAE <- function(actual, predicted) {
  mean(abs(actual - predicted))
}

test_results <- do.call(
  rbind,
  lapply(names(train_models), function(name) {
    predictions <- predict(
      train_models[[name]],
      newdata = test
    )

    data.frame(
      Model = name,
      RMSE = RMSE(test$Battery.Health, predictions),
      MAE = MAE(test$Battery.Health, predictions)
    )
  })
)

rownames(test_results) <- NULL

# Combine full-data fit metrics with holdout errors
model_comparison <- merge(
  model_comparison,
  test_results,
  by = "Model",
  sort = FALSE
)

model_comparison <- model_comparison[
  match(names(models), model_comparison$Model),
]

rownames(model_comparison) <- NULL

print(model_comparison)

write.csv(
  model_comparison,
  "results/model_comparison.csv",
  row.names = FALSE
)

# --------------------------------------------------
# 10. Session information
# --------------------------------------------------

capture.output(
  sessionInfo(),
  file = "results/session_info.txt"
)

cat("\nAnalysis completed. Outputs saved in results/.\n")
