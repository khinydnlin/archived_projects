# Fire False Alarm Predictions (London)

#### -- Project Status: [Completed]

## Project Objective
This personal project is motivated by a persistent issue experienced by the UK's London Fire Rescue Services. [Statistics](https://www.gov.uk/government/statistics/fire-and-rescue-incident-statistics-year-ending-september-2023/fire-and-rescue-incident-statistics-england-year-ending-september-2023#:~:text=1%20show%20that%20of%20the,accounted%20for%2034%25%20of%20incidents.) released by the UK's government indicate that 42% of emergency incidents in the UK turned out to be false alarms, with the number of such incidents increasing by 6.3% compared with 5 years ago. The trend has generally been upward since 2015 apart from a slight decline during COVID-19. The financial impact of false alarms is significant, costing the UK's government approximately [£1 billion a year](https://source.thenbs.com/case-study/false-fire-alarms-continue-to-cost-the-uk/6jFXdjTXcyYL3rynNL2xDJ/7qvzyVn7VbyMdFXcLEiYPV).

This project intends to address this issue by leveraging Machine Learning to detect a false alarm before the dispatch of rescue teams. Predictive models have potential to be integrated with existing policies,which rely on call challenging method, in determining false alarms. This project specifically targets the incidents within London for the year, 2023. Therefore, while the model shows potential, its current application is limited to this specific context, timeframe and available public data.

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

The dataset is a public data which was obtained from [London Fire Brigade Incident Records](https://data.london.gov.uk/dataset/london-fire-brigade-incident-records).

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

### Machine Learning Model Development 

#### Data Cleaning

Original dataset has 39 columns in total. Not all of the available features in the dataset are suitable for our prediction model. When cleaning the data, we take the following factors into account: 

1. Data Leakage

Data leakage can occur when we include the variables that may not be available at the time of predicting. The dataset consists of some features that seem to be collected after the incident happened. These features include details of the incidents such as attendance time of the fire rescue team, number of pumps attending, etc. In total, we removed 12 features from the dataset in the initial stage.

2. Missing Data

Some features have extremely high missing values. Based on further analysis, there are two types of missing values. Some missing values are present due to the nature of the data (for example, one feature is linked to another feature, causing not-applicable missing values). For the second category of missing values, we investigated further whether we should use imputation methods to replace null values or not. If the number of missing values account for more than 60% of the data, we decide not to include them. 

3. Granularity

Although the proportion of missing values is high, the dataset has a number of detailed information. We might not need all the granular details as it can only lead to overfitting. For example, for location aspect alone, the dataset has 16 geo features - from the borough level to detailed postcodes. 

4. Features with potential predictive power

Lastly, based on desk research, the majority of false alarms tend to be initiated by AFA (automatic false alarms). The rate of false alarms also tend to be varied by the property types.

EDA

Primarily, two types of analyses were performed:

Time Series Analysis

First, we transformed the datetime column into time-series data: month, day of the week, day, hour. However, although the incidents are largely differed depending on time frame, not much difference was observed between the temporal patterns of false alarms and actual incidents. 

Location Analysis

We filtered the ones with no missing values. Among them, granular data such as reference numbers like UPRN, USRN, BoroughCode, and postcode details are also removed as they won't provide additional information to the model.We selected the features with few missing values: Borough Names, Easting and Northing (projected coordinate system).

These are the top 5 locations in London with the highest rate of false alarms:

- Central London area,
- Westminster,
- Kengsington and Chelsea,
- Hammersmith and Fulham
- Camden

This is in line with the property types where non-residential (office,schools,police station) and other residentiall (hotels,uni accomodations) have the highest false alarms rates.

#### Data Preprocessing and Feature Engineering

As the dataset does not include 'source of call' directly, we create this feature by inferring to another feature that includes detailed information of the incident such as good intent, bad intent,primary fire, secondary fire, AFA. It was straightforward to extract AFA calls from this feature but other types of incidents do not have information about the origin of call. For the purpose of this project, we assume 'non-AFA' for the remaining categories due to lack of data. However, this may not reflect the real-world scenario as actual incidents can be initiated from AFA as well. 

The target variable (false alarms) made up about 50% of the dataset. So, we did not need to address the class imbalance issues. 

#### Model Exploration

- We aim to achieve high precision rates as we do not accidentally miss the actual incidents.
- We explored four models:

- Baseline Logistic Regression
- KNN
- Gaussian Naive Bayes
- Random Forest

As KNN and Random Forest achieved the highest precision rates, we further tuned those two models to improve the model. The following is the final performance on test dataset:


| ML Models           | Precision  | Recall    | F1 Score  | Accuracy |
|---------------------|------------|-----------|-----------|----------|
|KNN                  | 0.99       | 0.80      | 0.88      | 0.89     |
|Random Forest        | 0.99       | 0.80      | 0.89      | 0.90     |


## Further Improvement and Challenges

- Data Availability - Despite the source of call being the strong predictor, the dataset lacks information of source of call for various types of incidents. Hence, our assumption may have flaws, which may introduce to data leakage. 

- Feature Engineering for geo data: the geo data can have more feature enigneering by using clustering techniques. In this project, we directly used the northing and easting data as we have broader categories such as boroughs and wards already. 

- Generalisability : As feature importance shows that source of call has the highest importance, we experimented with and without that feature to make sure the model does not rely on this feature alone. It is possible that our models achieve the extremely high precision rates given that the vast majority of False alarms come from AFA alone. This makes the model able to distinguish the classes easily. However, it is important to note that the proportion of AFA calls in false alarms may variate year by year. Therefore, to avoid overfitting, data from previous years should be trained so that the model does not assume all AFA calls are false alarms. 



