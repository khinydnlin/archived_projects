# Fire False Alarm Predictions (London)

#### -- Project Status: [Completed]

## Project Objective
This personal project is motivated by a persistent issue experienced by the UK's London Fire Rescue Services. [Statistics](https://www.gov.uk/government/statistics/fire-and-rescue-incident-statistics-year-ending-september-2023/fire-and-rescue-incident-statistics-england-year-ending-september-2023#:~:text=1%20show%20that%20of%20the,accounted%20for%2034%25%20of%20incidents.) released by the UK's government indicate that 42% of emergency incidents in the UK turned out to be false alarms, with the number of such incidents increasing by 6.3% compared with 5 years ago. The trend has generally been upward since 2015 apart from a slight decline during COVID-19. The financial impact of false alarms is significant, costing the UK's government approximately [£1 billion a year](https://source.thenbs.com/case-study/false-fire-alarms-continue-to-cost-the-uk/6jFXdjTXcyYL3rynNL2xDJ/7qvzyVn7VbyMdFXcLEiYPV). Unsurprisingly, the majority of false alarms originate from AFA (automatic fire alarms) although there has been a slight decline in AFA-initiated false alarms.

This project intends to address this issue by leveraging Machine Learning to detect a false alarm before the dispatch of rescue teams. Predictive models have potential to be integrated with existing policies,which rely on call challenging method, in determining false alarms. This project specifically targets the incidents within London for the year, 2023. Hence, while the model shows potential, its current application is limited to this specific context, timeframe and available public data.

### Skills Used
* Time Series and Location Analysis
* Logistic Regression
* KNN Classification Model
* Gaussian Naive Bayes Classification Model
* Random Forest

### Technologies
* Python 

## Getting Started

1. Clone this repo (for help see this [tutorial](https://help.github.com/articles/cloning-a-repository/)).
2. Raw Data is available [here](https://github.com/khinydnlin/portfolio/blob/main/Car%20Auction%20Price%20Predictions%20(Myanmar)/dataset.csv) within this repo.   
3. Data processing and modelling scripts are documented in a [Jupyter notebook](https://github.com/khinydnlin/portfolio/blob/main/Car%20Auction%20Price%20Predictions%20(Myanmar)/Car%20Auction%20Price%20Predictions.ipynb)
4. The project findings and other details can be found below:

## Project Description

### Data Sources

The data was manually collected from the major car brokers in the market because of the lack of public data on resale prices. The following featuers were collected:

| Data                  |
| ----------------------|
| car brand             |
| car make              |
| engine power          | 
| mileage in km         |  
| colour                |
| steering position     |
| transimission type    |
| fuel type             |
| car body type         |
| price in MMK          |
| price in USD          |
*Note: 1 USD - 1,400 Myanmar Kyats (MMK) exchange rate was used

### Machine Learning Model Development 

#### Insights from Exploratory Data Analysis

- Toyota is likely to dominate the car market which aligns with general observations of Toyota having the largest market share in the country.
- In terms of prices, there is a significant variation based on car brands and car models, with the Toyota brand exhitbiting the highest car price.
- Specifically, Toyota Alphard, Toyota Crown, Toyota Klugers had the highest resale prices after Nissan Quashqai make (this model was not representative due to having considerably smaller samples).
- Black cars tend to have higher resale value compared to other colours.
- SUV body types cars are more likely to have the highest resale prices,followed by vans and sedans.
- Although it was expected that the prices would be determined by age and mileage, correlation results suggest that the resale values have weak direct relationships with these features. Interesingly, data visualization suggests that age seems to be a secondary influential factor after the car brand and model. This indicates the potential non-linear relationship between the car prices and available features.
  

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

## Learning Points and Challenges

- Data Availability : The dataset comprises only 500 data points, which is insufficient to cover all car models. This limitation constrains the model's ability to generalize across the full spectrum of vehicles.

- Performance Gap: There is a model performance gap (6%) between the test set and the training set. Despite efforts in parameter tuning to reduce overfitting, this gap persisted, likely due to the small sample size and imbalanced class distribution among car models. Given that Toyota models constitute the majority of the dataset, the model may struggle to generalize effectively to less represented or unseen models.



