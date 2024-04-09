# Impact Analysis of Cost-Containment Measures in Healthcare Expenditures

#### -- Project Status: [In-progress]

## Project Objective
This project was carried out as an attempt to solve the [2022 data challenge from ACIC](https://acic2022.mathematica.org/). The goal of the analysis was to evaluate the nuanced impacts of policy interventions that aim to lower Medicare expenditure by using causal inference methods.

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

Since the participants in the program were self-selected (not randomly assigned), we have to choose a method that is compatible with this situation. A DiD method is a widely used quasi-experimental method for experiments where randomized controlled trials are not feasible due to practicality and ethical issues. However, DiD method relies on one key assumption - parellel trend observations: unobserved differences between the control and treatment groups are the same over the time in the absence of intervention.Therefore, firstly, we checked if the dataset is in line with this assumption:

![image](https://github.com/khinydnlin/portfolio/assets/145341635/c474e68f-a31e-44e7-801f-80cb85311697)

Based on visual check, the trends appear to have a similar slope without significant divergences. 

Secondly, we transformed the dataset into panel data in order to run a DiD regression.

**Outcome (Y) = &beta;<sub>0</sub> + &beta;<sub>1</sub> Time Period + &beta;<sub>2</sub> Treated + &beta;<sub>3</sub> (Time Period * Treated) + Error terms**

Data distribution

![image](https://github.com/khinydnlin/portfolio/assets/145341635/066a75b0-df0d-48d8-880d-83062d32a691)

  

#### Feature Engineering

- The data are right skewed. Hence, a log transformation was used to achieve a normal distribution.
- To reduce the dimensionality of the features, the car brands were regrouped into three groups: high-end brands (Toyota) , mid-range brands (Honda, Nissan and Mitsubishi), and Low-end brands (Suzuki and Daihatsu). Note that this grouping was determined based on the price distributions in the dataset.
- Similarly, I also regrouped the colours into two groups: black and others, as the black colour seems to be the main differentiator. I also combined the 'semi-auto' and 'manual' into one group.

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

- Data Availability : The dataset comprises only 500 data points, which is insufficient to cover all car models. This limitation constrains the model's ability to generalize across the full spectrum of vehicles.

- Overfitting issues: There is a model performance gap (6%) between the test set and the training set. Despite efforts in parameter tuning to reduce overfitting, this gap persisted, likely due to the small sample size and imbalanced class distribution among car models. Given that Toyota models constitute the majority of the dataset, the model may struggle to generalize effectively to less represented or unseen models.



