# Predicting Customer Inquiry Volumes on Facebook Messenger in a Contact Centre Channel by Incorporating Digital Advertising Data: An ARIMA Time Series Forecasting

#### -- Project: Dissertation 
Note: due to data confidentiality, the raw data is not provided for this project.

## Abstract
In the rapidly evolving business environment, contact centres are becoming essential hubs for customer interactions. Accurate demand forecasting of contact centres is key to enhancing both operational efficiency and customer experience. This research distinguishes itself from existing studies by focusing on two innovative aspects: the utilisation of chat inquiry demands within the Facebook Messenger channel and the incorporation of digital advertising metrics as external predictive factors in demand forecasting. A comprehensive case study was conducted on a well known organisation in Myanmar, utilising one year's worth of daily inquiry data to construct a forecasting model based on the Autoregressive Moving Average (ARIMA) method. This case study addresses two central research questions: the application of time series forecasting to forecast inquiry demands with an aim to optimise resource allocation and to improve response times, and the influence of digital advertising metrics on the inquiry demands as well as the forecasting performance. By integrating factors such as digital advertising expenditure and the number of unique digital campaigns, the forecasting model achieves a 10.236 % MAPE, marking a 4 % improvement in accuracy compared to the model without these factors (10.623 % MAPE). While the findings substantiate these digital advertising factors as valid predictors of inquiry volumes, the operational impact of this enhancement on the case organisation is relatively modest. However, this impact can be contextually significant based on operational scale and strategic directions. Additionally, this study also explores how variations in contact centre channels can influence demand forecasting process in dynamic multi-channel contact centres.

### Skills Used
* Time Series Analysis
* ARIMA Time Series Forecasting

### Technologies
* R (Forecast package)

## Getting Started

1. Clone this repo (for help see this [tutorial](https://help.github.com/articles/cloning-a-repository/)).
2. Raw Data is available within this repo. Get dataset 1 [here](https://github.com/khinydnlin/portfolio/blob/main/Impact%20Analysis_ACIC%20challenge/acic_data.csv) and year_data [here](https://github.com/khinydnlin/portfolio/blob/main/Impact%20Analysis_ACIC%20challenge/acic_year.csv). Two files need to be merged by id.practice in order to run analysis.
3. Data processing and modelling scripts are available [here](https://github.com/khinydnlin/portfolio/blob/main/Impact%20Analysis_ACIC%20challenge/DiD_analysis_scripts.R)
4. The project findings and other details can be found below:

## Project Description

### Research Questions
- How can time series forecasting methods be applied to predict inquiry demands in a Messenger channel for optimising resource allocation and improving response times in the contact centre? 
- How does the integration of digital advertising metrics affect the forecasting performance of inquiry demands for the Messenger channel? 

### Findings

#### - Research Question 1
The time series analysis has yielded valuable insights into demand patterns that are essential for resource planning in the contact centre. The visual analysis highlights the influence of local extended holidays (special days) on inquiry demands, although day-of-the-week effects are not readily apparent. These findings are consistent with the results of the ARIMA modelling, which reveals statistically significant coefficients for special day effects, while the statistical significance of day-of-the-week effects was not observed. Furthermore, analysis exhibits significant variations in demand, particularly with heightened inquiry volumes from October to February. While formal seasonality detection was inconclusive due to limited data during the modelling process, plausible factors such as agricultural cycles may contribute to these patterns which require more historical 
data to confirm this. In response to the research question 1, the application of the ARIMA time series forecasting method successfully led to the development of a reasonably accurate forecasting model with a 10.236% MAPE. While our research primarily focused on the model development, the forecasted values can be utilised in guiding resource allocation and enhancing response times in the contact centre.

#### - Research Question 2 
In exploring the effect of digital advertising metrics on forecasting inquiry demands, we found that both advertising spending and the number of distinct campaigns variables have statistically significant positive correlations with inquiry demands, and the strengths of the correlations are moderate. These correlations, among all digital advertising metrics, exhibited the strongest influence on the dependent variable. Other digital advertising variables, such as campaign completers and non-completers, displayed weaker direct correlations with chat inquiries. Crosscorrelation analysis did not reveal any significant time-delayed relationships between digital advertising variables and inquiry volumes. Furthermore, Model 6, which incorporated advertising spending and the number of campaigns, outperformed other models in terms of accuracy, achieving a 10.236% MAPE. observe an improvement in the forecast error by approximately 4% compared to the benchmark model without any digital advertising effects ( 10.623 % MAPE).

### Data Processing and Modelling

In total, 6 ARIMA models were explored.

| Models  | Selected External Variables                                                             |    
|---------|-----------------------------------------------------------------------------------------|
| Model 0 | Benchmark model (workday, special day)                                                  |
| Model 1 | Advertising spending, workday, special day                                              |
| Model 2 | Number of completers, workday, special day                                              |
| Model 3 | Number of non-completers, workday, special day                                          |
| Model 4 | Number of distinct advertising campaigns, workday, special day                          |
| Model 5 | Interaction term (Advertising spending  and number of campaigns),  workday, special day | 
| Model 6 | Advertising spending, number of distinct advertising campaigns, workday, special day    |

![ARIMA_results](https://github.com/khinydnlin/portfolio/assets/145341635/09d231af-dd0f-461a-94dd-ebf2ff2d382c)


## Challenges and Further Model Improvement

However, the nature of this intervention tends to introduce uneven impacts across different subgroups: for example, certain cohorts may experience increased expenditure while other cohorts may see lowered expenditures. Therefore, as a next step, subgroup analysis would be appropriate to uncover the nuanced impacts as overall impact figure cannot capture these subtle differences across cohorts.



