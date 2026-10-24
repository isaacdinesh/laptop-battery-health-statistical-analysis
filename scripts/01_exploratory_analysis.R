
# ============================================================
# Laptop Battery Health Statistical Analysis
# Part 1: Exploratory Data Analysis
# ============================================================

# 1. Load dataset ------------------------------------------------

data_path <- "data/LaptopBatteryHealthPrediction.csv"

if (!file.exists(data_path)) {
  stop("Dataset not found. Run this script from the project root folder.")
}

dat <- read.csv(data_path)

# 2. Data overview and quality checks ---------------------------

cat("Dataset dimensions:\n")
print(dim(dat))

cat("\nDataset structure:\n")
str(dat)

cat("\nMissing values by variable:\n")
print(colSums(is.na(dat)))

cat("\nDuplicate records:\n")
print(sum(duplicated(dat)))

cat("\nSummary statistics:\n")
print(summary(dat))

# 3. Descriptive statistics -------------------------------------

selected_vars <- c(
  "Battery.Health",
  "Battery.Age",
  "Cycle.Count",
  "Daily.Usage.Hours",
  "Average.Temperature"
)

descriptive_stats <- data.frame(
  Variable = selected_vars,
  Mean = sapply(dat[selected_vars], mean),
  SD = sapply(dat[selected_vars], sd),
  Minimum = sapply(dat[selected_vars], min),
  Maximum = sapply(dat[selected_vars], max),
  row.names = NULL
)

print(round(descriptive_stats[-1], 3))
print(descriptive_stats)

# 4. Correlation analysis ---------------------------------------

correlation_vars <- c(
  "Battery.Health",
  "Battery.Age",
  "Daily.Usage.Hours",
  "Cycle.Count",
  "CPU.Usage",
  "GPU.Usage",
  "Power.Consumption",
  "Average.Temperature"
)

correlation_matrix <- cor(dat[correlation_vars])

cat("\nCorrelation matrix:\n")
print(round(correlation_matrix, 3))

# 5. Create output folders --------------------------------------

dir.create("figures", showWarnings = FALSE)
dir.create("results", showWarnings = FALSE)

# 6. Correlation heatmap ----------------------------------------

if (!requireNamespace("corrplot", quietly = TRUE)) {
  stop("Please install the corrplot package: install.packages('corrplot')")
}

png(
  "figures/correlation_heatmap.png",
  width = 1600,
  height = 1200,
  res = 150
)

corrplot::corrplot(
  correlation_matrix,
  method = "color",
  type = "upper",
  order = "hclust",
  addCoef.col = "black",
  tl.col = "black",
  tl.srt = 45,
  number.cex = 0.7
)

dev.off()

# 7. Battery health distribution --------------------------------

png("figures/battery_health_distribution.png",
    width = 1200, height = 900, res = 150)

hist(
  dat$Battery.Health,
  col = "grey",
  border = "black",
  main = "Distribution of Battery Health",
  xlab = "Battery Health (%)"
)

dev.off()

# 8. Battery age vs battery health -------------------------------

png("figures/battery_age_boxplot.png",
    width = 1200, height = 900, res = 150)

boxplot(
  Battery.Health ~ Battery.Age,
  data = dat,
  xlab = "Battery Age (Years)",
  ylab = "Battery Health (%)",
  main = "Battery Health by Battery Age"
)

dev.off()

# 9. Cycle count vs battery health -------------------------------

png("figures/cycle_count_vs_battery_health.png",
    width = 1200, height = 900, res = 150)

plot(
  dat$Cycle.Count,
  dat$Battery.Health,
  xlab = "Cycle Count",
  ylab = "Battery Health (%)",
  main = "Cycle Count vs Battery Health",
  pch = 16,
  col = adjustcolor("black", alpha.f = 0.4)
)

dev.off()

# 10. Temperature vs battery health ------------------------------

png("figures/temperature_vs_battery_health.png",
    width = 1200, height = 900, res = 150)

plot(
  dat$Average.Temperature,
  dat$Battery.Health,
  xlab = "Average Temperature",
  ylab = "Battery Health (%)",
  main = "Temperature vs Battery Health",
  pch = 16,
  col = adjustcolor("black", alpha.f = 0.4)
)

dev.off()

# 11. Export descriptive results --------------------------------

write.csv(
  descriptive_stats,
  "results/descriptive_statistics.csv",
  row.names = FALSE
)

write.csv(
  correlation_matrix,
  "results/correlation_matrix.csv"
)

cat("\nExploratory analysis completed successfully.\n")

