
# Dataset

This project uses the **Laptop Battery Health Prediction Dataset** by Dharmendra Pandit.

**Source:** [Kaggle — Laptop Battery Health Prediction Dataset](https://www.kaggle.com/datasets/dharmendrapandit12/laptop-battery-health-dataset)

**Dataset licence:** MIT (as listed on Kaggle)

## Dataset Description

The dataset contains 1,200 observations and 11 variables describing laptop battery characteristics and operating conditions.

### Variables Used

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

The dataset is included in this repository at:

`data/LaptopBatteryHealthPrediction.csv`

The R scripts load the CSV directly from this location, allowing the analyses to be reproduced without separately downloading the dataset.

## Attribution and Licensing

The dataset was published by Dharmendra Pandit on Kaggle under the MIT licence.

The original dataset source is acknowledged above. Any original copyright and licence notice accompanying the dataset should be retained when redistributing it.

The dataset's licence applies to the dataset and does not imply that the entire analysis repository is MIT-licensed.
