# Project Name
Car Auction Price Predictions in Myanmar

#### -- Project Status: [Completed]

## Project Objective
This project was carried out as part of freelance contract for one of the automotive players in Myanmar back in 2019. Until recently, due to import restrictions, Myanmar's automotive market was primarily domiated by used cars. As a result, the market lacked a proper market mechanism as the transactions were mainly handled by unofficial car brokers. The objective of the project was to understand the factors influencing the second-hand car prices and to estimate the car prices based on their attribtues. The end goal was to develop a data-driven fair pricing mechanism for an automotive platform.

### Skills Used
* Data Collection
* Linear Regression
* Regularised Linear Regression (Lasso, Ridge)
* Random Forest

### Technologies
* Python 

## Project Description
Data Sources

The data was manually collected from the major car brokers in the market because of the lack of public data on the sold prices. The following featuers were collected:

year of car model
car brand
car make
engine power
mileage in km
colour
steering position
transimission type
fuel type
car body type
price in MMK
price in USD
Note: 1 USD - 1,400 Myanmar Kyats (MMK) exchange rate was used

Insights 

- Toyota is likely to dominate the car market which aligns with general observations of Toyota having the largest market share in the country.
- In terms of prices, there is a significant variation based on car brands and car models, with the Toyota brand exhitbiting the highest car price.
- Specifically, Toyota Alphard, Toyota Crown, Toyota Klugers had the highest resale prices after Nissan Quashqai make (this model was not representative due to having considerably smaller samples).
- Black cars tend to have higher resale value compared to other colours.
- SUV body types cars are more likely to have the highest resale prices,followed by vans and sedans.
- Although it was expected that the prices would be determined by age and mileage, correlation results suggest that the resale values have weak direct relationships with these features. Interesingly, data visualization suggests that age seems to be a secondary influential factor after the car brand and model. This indicates the potential non-linear relationship between the car prices and available features.
  
Feature Engineering

- The data are right skewed. Hence, a log transformation was used to achieve a normal distribution.
- To reduce the dimensionality of the features, the car brands were regrouped into three groups: high-end brands (Toyota) , mid-range brands (Honda, Nissan and Mitsubishi), and Low-end brands (Suzuki and Daihatsu). Note that this grouping was determined based on the price distributions in the dataset.
- Similarly, I also regrouped the colours into two groups: black and others, as the black colour seems to be the main differentiator. I also combined the 'semi-auto' and 'manual' into one group.

Machine Learning Model Development

- As a baseline model, a Linear Regression model was chosen for comparison purposes. Since a non-linearity was also detected, a Random Forest model was explored to uncover complex patterns.

- As a primary metric, the goal was to achieve a low Mean Absolute Error (MAE) value of 1,000 - 2,000 USD, which was equivalent to 15 - 30 lakhs MMK at the time.

- For Linear regression, it was found that the model comformed to primary assumptions: linearity, indepedence of residuals (with Durbin Watson test score between 1.5 and 2.5), improved normality after log transformation, and homosdeasticity with randomly scattered residuals. However, some multicollinearity issues were also identified. So, Ridge and Lasso regularisation were explored. Prior to conducting regularisation, it was ensured that the training data and test data were standardised properly.

Cross-validation results

| ML Models        | R2    | MAE  |
|------------------|-------|------|
| Linear Regression| 0.829 | 2,520|
| Ridge Regression | 0.834 | 2,363|
| Lasso Regression | 0.749 | 2,714|
| Random Forest    | 0.892 | 1,624|

Due to the lowest MAE scores of Random Forest, the Random Forest model was selected as final model to fit on the test data.

The final score on test set is R2 - 0.834, MAE - 1,921

Learning Points and Challenges

- Lack of public data - the dataset only has 500 data points. Therefore, it did not cover all the models.
- There is some gap (6%) between test set performance and training set performance. Despite after parameter tuning, the gap did not reduce. This is possibly due to small sample size with imbalanced classes for car models. Since the majority of the dataset is made up of Toyota models, the model may struggle to generalise well on unseen models/data.

## Getting Started

1. Clone this repo (for help see this [tutorial](https://help.github.com/articles/cloning-a-repository/)).
2. Raw Data is available [here] within this repo.    
3. Data processing/transformation scripts are being kept [here].
