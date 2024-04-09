# Impact Analysis of Cost-Containment Measures in Healthcare Expenditures

#### -- Project Status: [In-progress]

## Project Objective
This project was carried out as an attempt to solve the [2022 data challenge from ACIC](https://acic2022.mathematica.org/). The goal of the analysis was to evaluate the nuanced impacts of policy interventions that aim to lower Medicare expenditure by using causal inference methods. In this project, Differences-in-Differences(DiD) method was explored - the primary indicator is the rate of increased expenditure of treatement group should be lower than that of control group.

### Skills Used
* Data Analysis
* Difference-in-Differences Method (DiD method)

### Technologies
* R (plm package)

## Getting Started

1. Clone this repo (for help see this [tutorial](https://help.github.com/articles/cloning-a-repository/)).
2. Raw Data is available [here](https://github.com/khinydnlin/portfolio/blob/main/Car%20Auction%20Price%20Predictions%20(Myanmar)/dataset.csv) within this repo.   
3. Data processing and modelling scripts are documented in a [Jupyter notebook](https://github.com/khinydnlin/portfolio/blob/main/Car%20Auction%20Price%20Predictions%20(Myanmar)/Car%20Auction%20Price%20Predictions.ipynb)
4. The project findings and other details can be found below:

## Project Description

### Data Sources

The data challenge consists of two tracks: patient-level track 1 (1.2 million records per dataset) and practice-level (aggregated data - 1.7 million records in total) track 1. For this project, 1,500 (3 datasets) samples were randomly extracted from Track 2 datasets to demonstrate the impact analysis.

![image](https://github.com/khinydnlin/portfolio/assets/145341635/8b5b7e4a-6e56-4eb8-aceb-9e72e57ea459)

### Impact Analysis

#### Data Preprocessing

Since the participants in the program were self-selected (not randomly assigned), we have to choose a method that is compatible with this situation. A DiD method is a widely used quasi-experimental method for experiments where randomized controlled trials are not feasible due to practicality and ethical issues. However, DiD method relies on one key assumption - parellel trend observations: unobserved differences between the control and treatment groups are the same over the time in the absence of intervention.

1. Firstly, we checked if the dataset is in line with this assumption:

![image](https://github.com/khinydnlin/portfolio/assets/145341635/c474e68f-a31e-44e7-801f-80cb85311697)

Based on visual check, the trends appear to have a similar slope without significant divergences. The treatement group tends to have slighlty higher expenditure compared to control groups. Moreover, the costs had risen during four years for both groups. Therefore, to guague the actual impacts, the slower rate of increased costs for treatement compared to control group could be an indicator of impact.

2. We transformed the dataset into panel data in order to run a DiD regression.

**Outcome (Y) = &beta;<sub>0</sub> + &beta;<sub>1</sub> Time Period + &beta;<sub>2</sub> Treated + &beta;<sub>3</sub> (Time Period * Treated) + Error terms**

| Key Variables    | Data Description                              | 
|------------------|-----------------------------------------------|
| post (Time)      | 1 = Post-intervention , 0 = Pre-intervention  | 
| Z (Treated)      | 1 = Treatement        , 0 = Control           | 
| Y (Expenditure)  | Continuous Data                               | 

3. We use log-transformation to handle Y due to skewed distribution. 

![image](https://github.com/khinydnlin/portfolio/assets/145341635/066a75b0-df0d-48d8-880d-83062d32a691)

#### Findings

(![R outputs](https://github.com/khinydnlin/portfolio/assets/145341635/a752c00d-91c5-42fd-b664-58cc4c54499e)


#### Model Exploration

- As a baseline model, a Linear Regression model was chosen for comparison purposes. Since a non-linearity was also detected, a Random Forest model was explored to uncover complex patterns.

- As a primary metric, the goal was to achieve a low Mean Absolute Error (MAE) value of 1,000 - 2,000 USD, which was equivalent to 15 - 30 lakhs MMK at the time.

- For Linear regression, it was found that the model comformed to primary assumptions: linearity, indepedence of residuals (with Durbin Watson test score between 1.5 and 2.5), improved normality after log transformation, and homosdeasticity with randomly scattered residuals. However, some multicollinearity issues were also identified. So, Ridge and Lasso regularisation were explored. Prior to conducting regularisation, it was ensured that the training data and test data were standardised properly.

**Cross-validation Results**

| ML Models        | R2    | MAE (USD) |
|------------------|-------|-----------|
| Linear Regression| 0.829 | 2,520     | 
| Ridge Regression | 0.834 | 2,363     |
| Lasso Regression | 0.749 | 2,714     |
| Random Forest    | 0.892 | 1,624     |

Due to the lowest MAE scores of Random Forest, the Random Forest model was selected as final model to fit on the test data.

The final score on test set is R2 - 0.834, MAE - 1,921

## Challenges and Further Model Improvement

- Heterogenous impacts: The nature of this intervention tends to introduce uneven impacts across different subgroups: for example, certain cohorts may result in increased expenditure while other cohorts may lead to lowered expenditures. Therefore, as a next step, subgroup analysis would be suitable to uncover the nuanced impacts as overall impact figure cannot capture these subtle differences across cohorts.


