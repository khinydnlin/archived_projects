# False Fire Alarms Detection Using Classification Alogrithms

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
2. Raw Data is available [here](https://github.com/khinydnlin/portfolio/blob/main/False%20Fire%20Alarms%20Detection%20(London%20Fire%20Brigade)/dataset.zip) within this repo.   
3. Data processing and modelling scripts are documented in a [Google Colab Notebook](https://github.com/khinydnlin/portfolio/blob/main/False%20Fire%20Alarms%20Detection%20(London%20Fire%20Brigade)/%20False%20Fire%20Alarms%20Detection.ipynb). Click on the **Google Colab** icon at the top of the notebook to view the entire document.
4. The project findings and other details can be found below:

## Project Description

### Data Sources

The dataset is a public data which was obtained from [London Fire Brigade Incident Records](https://data.london.gov.uk/dataset/london-fire-brigade-incident-records).

### Machine Learning Model Development 

#### Data Cleaning

The original dataset comprises 39 columns in total. However, not all features are suitable for our prediction model. When cleaning the data, we considered the following factors:

- Data Leakage
Data leakage can occur if we include variables that may not be available at the prediction time. The dataset contains some features collected after the incident, such as the fire rescue team's attendance time and the number of pumps attending. As such, we removed 12 features from the dataset to prevent data leakage.

- Missing Data
We observed that some features have extremely high rates of missing values. Upon further analysis, we identified two types of missing values. Some are due to the data's nature (e.g., one feature is linked to another, causing not-applicable values). For the second category, we evaluated whether to use imputation methods. We decided not to include features with more than 60% missing values.

- Granularity
Despite the high proportion of missing values, the dataset contains detailed information. However, not all granular details are necessary, as they can lead to overfitting. For instance, the dataset includes 16 geographical features, from borough level to detailed postcodes, which may not all be relevant.

- Features with Potential Predictive Power
Desk research indicated that the majority of false alarms are initiated by automatic false alarms (AFA), with rates varying by property type.

#### Exploratory Data Analysis (EDA)
We performed two primary types of analyses:

- Time Series Analysis: We transformed the datetime column into time-series formats (month, day of the week, day, hour) to conduct a time series analysis. Although incidents vary over time, there was no significant difference in temporal patterns between false alarms and actual incidents.

- Location Analysis: We focused on features with few missing values and removed granular data such as location reference numbers (UPRN, USRN, BoroughCode, postcode). We retained features like Borough Names and Easting and Northing coordinates.

- The top locations with highest false alarm rates are City of London, Westminster, Kensington and Chelsea, Hammersmith and Fulham, and Camden. This is aligned with the finding that non-residential properties like offices, schools, and hotels, which have higher false alarm rates compared to private residential areas since such neighborhoods are considered central areas with public properties. Out of all the False Alarms, 79% of them are originated from AFA. The remaining ones are assumed to be initiated by humans.

#### Data Preprocessing and Feature Engineering
Given the fact the majority of false alarms come from AFA, source of call/incident seem to have a high influence on the false alarm. However, the dataset does not have an explicit column that shows the source of call. Therefore, we created a new feature called 'source  of call' using an assumption that the incidents that are not explicity categorised/mentioned as AFA belong to non-AFA. However, this assumption may have pitfalls as for actual incidents, the dataset does not have information on whether it was originated from AFA or humans.

The target variable (false alarms) constituted about 50% of the dataset, so class imbalance was not an issue.

#### Model Exploration and Selection
We aimed for high precision rates to minimize missing actual incidents. We explored four models: Baseline Logistic Regression, KNN, Gaussian Naive Bayes, and Random Forest. KNN and Random Forest showed the highest precision, which we then tuned for improved performance. The final test dataset performance is as follows:

| ML Models           | Precision  | Recall    | F1 Score  | Accuracy |
|---------------------|------------|-----------|-----------|----------|
|KNN                  | 0.99       | 0.80      | 0.88      | 0.89     |
|Random Forest        | 0.99       | 0.80      | 0.89      | 0.90     |

Confusion Matrix

![image](https://github.com/khinydnlin/portfolio/assets/145341635/aa87f862-ecd9-40ca-a530-2c322dbf2f62)

### Further Improvement and Challenges

Data availability remains a challenge, particularly the lack of 'source of call' information for actual incidents despite it being the major predictor. This limitation could introduce biased in our model because of the assumption used in feature engineering. Moreover, geo data could benefit from further feature engineering, such as creating new features that could indicate the likelihood of false alarms.

Regarding generalisability, the 'source of call' showed high importance. We tested models with and without this feature to ensure reliance isn't on this feature alone. Given that most false alarms stem from AFA, the models could easily distinguish classes, potentially leading to overfitting. To mitigate this, we recommend training on data from previous years to accommodate the variability in AFA call proportions as false alarms.



