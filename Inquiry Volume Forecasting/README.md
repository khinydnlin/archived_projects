# Predicting Customer Inquiry Volumes on Facebook Messenger in a Contact Centre Channel by Incorporating Digital Advertising Data: An ARIMA Time Series Forecasting

#### -- Project: Dissertation 
Note: Due to data confidentiality, the raw data and company information are not included to protect anonymity of the case organisation.

## Abstract
In the rapidly evolving business environment, contact centres are becoming essential hubs for customer interactions. Accurate demand forecasting of contact centres is key to enhancing both operational efficiency and customer experience. This research distinguishes itself from existing studies by focusing on two innovative aspects: the utilisation of chat inquiry demands within the Facebook Messenger channel and the incorporation of digital advertising metrics as external predictive factors in demand forecasting. A comprehensive case study was conducted on a well known organisation in X country, utilising one year's worth of daily inquiry data to construct a forecasting model based on the Autoregressive Moving Average (ARIMA) method. This case study addresses two central research questions: the application of time series forecasting to forecast inquiry demands with an aim to optimise resource allocation and to improve response times, and the influence of digital advertising metrics on the inquiry demands as well as the forecasting performance. By integrating factors such as digital advertising expenditure and the number of unique digital campaigns, the forecasting model achieves a 10.236 % MAPE, marking a 4 % improvement in accuracy compared to the model without these factors (10.623 % MAPE). While the findings substantiate these digital advertising factors as valid predictors of inquiry volumes, the operational impact of this enhancement on the case organisation is relatively modest. However, this impact can be contextually significant based on operational scale and strategic directions. Additionally, this study also explores how variations in contact centre channels can influence demand forecasting process in dynamic multi-channel contact centres.

### Skills Used
* Time Series Analysis
* ARIMA Time Series Forecasting (dynamic regression model with ARIMA errors)
* Demand Forecasting

### Technologies
* R (Forecast package)

## Getting Started

1. Clone this repo (for help see this [tutorial](https://help.github.com/articles/cloning-a-repository/)).
2. Raw Data is available within this repo. Get dataset 1 [here](https://github.com/khinydnlin/portfolio/blob/main/Impact%20Analysis_ACIC%20challenge/acic_data.csv) and year_data [here](https://github.com/khinydnlin/portfolio/blob/main/Impact%20Analysis_ACIC%20challenge/acic_year.csv). Two files need to be merged by id.practice in order to run analysis.
3. Data processing and modelling scripts are available [here](https://github.com/khinydnlin/portfolio/blob/main/Impact%20Analysis_ACIC%20challenge/DiD_analysis_scripts.R)
4. The project findings and other details can be found below:

## Project Details

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

| Models  | Selected External Variables                                                             | MAPE   |
|---------|-----------------------------------------------------------------------------------------|--------|
| Model 0 | Benchmark model (workday, special day)                                                  | 10.623 |
| Model 1 | Advertising spending, workday, special day                                              | 10.250 |
| Model 2 | Number of completers, workday, special day                                              | 10.408 |
| Model 3 | Number of non-completers, workday, special day                                          | 12.510 |
| Model 4 | Number of distinct advertising campaigns, workday, special day                          | 10.291 |
| Model 5 | Interaction term (Advertising spending  and number of campaigns),  workday, special day | 12.258 |
| Model 6 | Advertising spending, number of distinct advertising campaigns, workday, special day    | 10.236 |

- Among all the models, model 2, 3 and 5 were removed from consideration as these models do not meet the model assumptions based on Ljung-Box residual tests.
- Model 6 (lowest MAPE) outperformed the benchmark model 0, proving that adding advertising expenditure and the volume of ads campaigns into the ARIMA model produced slightly more accurate forecasts for inquiry demand forecasting.
  

![ARIMA_results](https://github.com/khinydnlin/portfolio/assets/145341635/09d231af-dd0f-461a-94dd-ebf2ff2d382c)



### Theorectical Contributions and Mangerial Implications

#### Theoretical Contributions 
This study offers two key theoretical contributions. Firstly, the study contributes to the contact centre research by illuminating the demand variations specific to chat-based communication channels in an emerging contact centres context. By offering this insight, the research facilitates a deeper understanding of channel-specific dynamics. This contribution not only fills the research gap identified by Koole and Li (2023) but also signals a direction for further studies to harness these insights in a multi-channel context. Secondly, this study addresses the theoretical gap identified by Manno et al. (2022) by integrating external predictors (digital advertising metrics) into contact centre forecasting models and empirically linking them to customer inquiries. It quantifies the impact of digital advertising on forecast accuracy, revealing an approximately 4% improvement in forecast error, thereby establishing a new benchmark for future research. The findings also enrich theoretical discussions by demonstrating the practical inclusion of digital advertising factors in forecasting models. 

#### Managerial Implications and Recommendations 
This study provides two key managerial implications for the case organisation. The first implication pertains to resource allocation, where the accuracy of demand forecasting is essential for balancing staff levels to meet inquiry demands, directly affecting response times and cost efficiency. The second implication concerns the measurable impact of digital advertising expenditure and the number of unique campaigns on contact centre operations.  In light of the overarching aim to improve response times and enhance operational efficiency, our recommendations for the organisation include employing a simple forecast model (without digital 
advertising factors) for routine staffing decisions, exploring additional factors such as sales promotional events and weather information to improve forecasting, improving staffing strategies to be aligned with a demand forecasting model, and considering the adoption of technologies like chatbot FAQs and advanced forecasting tools for more effective inquiry management. These steps could lead to more efficient operations and increased customer satisfaction.


