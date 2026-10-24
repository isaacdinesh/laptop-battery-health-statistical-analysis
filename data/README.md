
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

## Dataset File

The dataset is included in this repository as:

`data/LaptopBatteryHealthPrediction.csv`

This allows the R analysis scripts to run without requiring a separate dataset download.

The original dataset was created by Dharmendra Pandit and published on Kaggle:

[Original Dataset — Kaggle](https://www.kaggle.com/datasets/dharmendrapandit12/laptop-battery-health-dataset)

The dataset is synthetic and is provided for reproducibility and educational analysis. Original dataset ownership and applicable licensing terms remain with the source publisher.
