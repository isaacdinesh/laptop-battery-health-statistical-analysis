
# Laptop Battery Health Statistical Analysis

Statistical analysis and regression modelling of laptop battery health using R, with a focus on hypothesis testing, regression diagnostics, model comparison and predictive validation.

## Project Overview

This project investigates the relationships between laptop battery health and four characteristics: Battery Age, Cycle Count, Daily Usage Hours and Average Temperature.

Using a publicly available synthetic dataset, Pearson correlation analysis and multiple linear regression were applied to examine statistical associations and evaluate the predictive performance of alternative regression models.

The objective was to determine whether a simpler regression model could achieve comparable predictive accuracy while reducing unnecessary complexity.

## Dataset

**Source:** [Laptop Battery Health Prediction Dataset — Kaggle](https://www.kaggle.com/datasets/dharmendrapandit12/laptop-battery-health-dataset)

The dataset contains:
- **1,200 observations**
- **11 variables**
- No missing values or duplicate records

**Target variable:** Battery Health (%)

**Selected predictors:**
- Battery Age
- Cycle Count
- Daily Usage Hours
- Average Temperature

Full Charge Capacity and Design Capacity were excluded from modelling because preliminary analysis suggested that Battery Health was approximately derived from their ratio, introducing potential target leakage.

## Methodology

1. Import the dataset and examine its structure and data quality.
2. Explore variable distributions and relationships.
3. Perform Pearson correlation hypothesis tests.
4. Fit a multiple linear regression model using four predictors.
5. Assess multicollinearity using Variance Inflation Factors (VIF).
6. Examine regression diagnostic plots.
7. Compare full and reduced regression models using adjusted R², AIC and BIC.
8. Evaluate predictive performance using an 80/20 train-test split, RMSE and MAE.

## Correlation Analysis

| Predictor | Pearson r | p-value |
|---|---:|---:|
| Battery Age | -0.901 | <0.001 |
| Cycle Count | -0.921 | <0.001 |
| Daily Usage Hours | -0.084 | 0.003 |
| Average Temperature | -0.041 | 0.154 |

Battery Age and Cycle Count demonstrated strong negative correlations with Battery Health.

Daily Usage Hours showed a statistically significant but very weak relationship, highlighting the difference between statistical significance and practical importance.

Average Temperature was not significantly correlated with Battery Health in this dataset.

## Regression Modelling

The initial multiple linear regression model included all four selected predictors.

The model explained approximately **85.6% of the variation in Battery Health** (R² = 0.8558).

However, Battery Age and Cycle Count exhibited substantial multicollinearity (VIF ≈ 10.72), limiting the reliability of their individual coefficient interpretations.

Residual diagnostics also suggested heteroscedasticity and deviations from normality in the distribution tails.

## Model Performance

Four regression models were evaluated using an 80/20 train-test split.

| Model | Adjusted R² | Test RMSE | Test MAE |
|---|---:|---:|---:|
| Full Model | 0.8554 | 3.750 | 2.953 |
| **Age + Cycle** | **0.8547** | **3.734** | **2.923** |
| Cycle Only | 0.8490 | 3.787 | 2.944 |
| Age Only | 0.8111 | 4.341 | 3.416 |

RMSE and MAE are measured in battery-health percentage points. Adjusted R² values were calculated using the full dataset, while test errors were obtained from models trained on the 80% training subset.

The Age + Cycle model achieved the lowest test errors, marginally outperforming the full model.

The Cycle-only model achieved comparable predictive performance using a single predictor, avoiding the multicollinearity between Battery Age and Cycle Count.

## Key Findings

- Battery Age and Cycle Count were the strongest predictors associated with Battery Health.
- Daily Usage Hours and Average Temperature provided little additional predictive value.
- The full model achieved strong explanatory performance, but diagnostic issues limited coefficient interpretation.
- Reduced regression models achieved similar predictive accuracy with fewer variables.
- Model selection involved balancing predictive performance, model simplicity, interpretability and statistical assumptions.

## Limitations

- The dataset is synthetic and may not reflect actual laptop battery degradation patterns.
- Battery Health is bounded between 0% and 100%, while ordinary linear regression does not enforce these limits.
- Residual diagnostics indicated potential heteroscedasticity and departures from normality.
- Battery Age and Cycle Count exhibited substantial multicollinearity.
- Predictive performance was assessed using a single random train-test split rather than repeated cross-validation.
- Statistical associations should not be interpreted as causal relationships.

Consequently, the results demonstrate statistical modelling techniques rather than a validated real-world battery-health prediction system.

## Tools and Technologies

R, RStudio, Pearson Correlation, Multiple Linear Regression, Variance Inflation Factor, AIC, BIC, RMSE and MAE.

## Data Source and References

- [Laptop Battery Health Prediction Dataset — Kaggle](https://www.kaggle.com/datasets/dharmendrapandit12/laptop-battery-health-dataset)
- Vetter et al. (2005). [Ageing mechanisms in lithium-ion batteries](https://doi.org/10.1016/j.jpowsour.2005.01.006)
- Tredennick et al. (2021). [A practical guide to selecting models for exploration, inference, and prediction in ecology](https://doi.org/10.1002/ecy.3336)

## Project Context

Developed as part of the Statistical Methods for Data Science module in a Master of Data Science programme.
