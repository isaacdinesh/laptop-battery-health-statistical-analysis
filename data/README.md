
# Dataset

This project uses the Laptop Battery Health Prediction Dataset by Dharmendra Pandit.

**Source:** [Kaggle — Laptop Battery Health Prediction Dataset](https://www.kaggle.com/datasets/dharmendrapandit12/laptop-battery-health-dataset)

The dataset contains 1,200 observations and 11 variables describing laptop battery characteristics and operating conditions.

## Variables Used

**Target:**
- Battery Health

**Predictors:**
- Battery Age
- Cycle Count
- Daily Usage Hours
- Average Temperature

Full Charge Capacity and Design Capacity were excluded from regression modelling because Battery Health was approximately derived from their ratio, creating potential target leakage.

## Data Limitations

The dataset is synthetic and may not accurately represent real-world battery ageing and degradation processes.

Findings should therefore be interpreted as a demonstration of statistical modelling methods rather than validated predictions for real laptop batteries.

## File Location

The analysis script expects the dataset at:

`data/LaptopBatteryHealthPrediction.csv`

If the dataset is not included in this repository, download it from the original Kaggle source and place it at the path above.
