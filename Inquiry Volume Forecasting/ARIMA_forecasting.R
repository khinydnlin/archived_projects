#Importing dataset
---

getwd()
setwd("---")

library(ggplot2)
library(forecast)
library(dplyr)
library(car)
library(corx)
library(tseries)
library(zoo)
library(Hmisc)
library(lubridate)
library(urca)
library(uroot)
library(lmtest)

#Section 1 ---------------------------------------------------------------
#Data Preparation and Cleaning

#Checking data types
str(inquiry_data)
class(inquiry_data)

View(inquiry_data)

#Data type conversion
inquiry_data$date<- as.Date(inquiry_data$date,format="%Y-%m-%d")
inquiry_data$work_day <- as.factor(inquiry_data$work_day)
inquiry_data$special_day <- as.factor(inquiry_data$special_day)
str(inquiry_data)

#Checking data distribution
hist(inquiry_data$inquiry_volumes)
hist(inquiry_data$ads_spending_usd)
hist(inquiry_data$completers)
hist(inquiry_data$non_completers)
hist(inquiry_data$no_of_campaigns)

#Checking missing values
sum(is.na(inquiry_data))


#Section 2 A ----------------------------------------------------------------
#Correlation Analysis

#Correlation Analysis
corr_matrix <- inquiry_data %>% select_if(is.numeric) %>% select(-conversion_rate)
rcorr(as.matrix(corr_matrix))

#Ads_spending and no of campaigns have highest correlation among all variables.

#Section 2 B ----------------------------------------------------------------
#Cross-Correlation Analysis


# Create time series objects

inquiry_ts <- ts(inquiry_data$inquiry_volumes,
                 start=c(year(inquiry_data$date)[1],as.numeric(format(inquiry_data$date[1], "%j"))),
                 frequency = 365)

ads_ts <- ts(inquiry_data$ads_spending_usd,
             start=c(year(inquiry_data$date)[1],as.numeric(format(inquiry_data$date[1], "%j"))),
             frequency = 365)

completers_ts <- ts(inquiry_data$completers, 
                    start=c(year(inquiry_data$date)[1],as.numeric(format(inquiry_data$date[1],"%j"))),
                    frequency=365)

non_completers_ts <- ts(inquiry_data$non_completers, 
                        start=c(year(inquiry_data$date)[1],as.numeric(format(inquiry_data$date[1],"%j"))),
                        frequency=365)

no_campaign_ts <- ts(inquiry_data$no_of_campaigns,
                     start=c(year(inquiry_data$date)[1],as.numeric(format(inquiry_data$date[1], "%j"))),
                     frequency = 365)


#To check time-delayed effects using pre-whitening and cross-correlogram method
#Firstly,checking the ACF and PACF plots before cross-correlation analysis
autoplot(inquiry_ts)
acf_result <- acf(coredata(inquiry_ts),main="ACF Plot for Inquiry Volumes")
pacf_result <- pacf(coredata(inquiry_ts), main="Partial ACF Plot for Inquiry Volumes")

#Checking stationarity 
adf_test_inquiry <- adf.test(inquiry_ts)
adf_test_ads <- adf.test(ads_ts)
adf_test_no_campaign <- adf.test(no_campaign_ts)
adf_test_completers <- adf.test(completers_ts)
adf_test_completers <- adf.test(non_completers_ts)

#Prewhitening the series
model_output <- auto.arima(inquiry_ts, D=0, stepwise=FALSE, approximation=FALSE)

fit_inquiry <- Arima(inquiry_ts, model=model_output)
prewhitened_inquiry <- residuals(fit_inquiry)

fit_ads <- Arima(ads_ts, model=model_output)
prewhitened_ads <- residuals(fit_ads)

fit_no_campaign <- Arima(no_campaign_ts, model=model_output)
prewhitened_no_campaign <- residuals(fit_no_campaign)

fit_completers <- Arima(completers_ts, model=model_output)
prewhitened_completers <- residuals(fit_completers)

fit_non_completers <- Arima(non_completers_ts, model=model_output)
prewhitened_non_completers <- residuals(fit_non_completers)


#Cross-correlation
ccf(prewhitened_ads, prewhitened_inquiry, lag.max=20, main="CCF between Advertising Spending & Inquiry Volumes")

ccf(prewhitened_no_campaign, prewhitened_inquiry, lag.max=20, main="CCF between No. of Advertising Campaigns & Inquiry Volumes")

ccf(prewhitened_completers, prewhitened_inquiry, lag.max=20, main="CCF between No. of Completers & Inquiry Volumes")

ccf(prewhitened_non_completers, prewhitened_inquiry, lag.max=20, main="CCF between No. of Non-Completers & Inquiry Volumes")




#Section 3 ----------------------------------------------------------------
#ARIMA Modelling



# Create log time series object for inquiry volumes because of high variance

log_inquiry_ts <- ts(inquiry_data$log_inquiry,
                 start=c(year(inquiry_data$date)[1],as.numeric(format(inquiry_data$date[1], "%j"))),
                 frequency = 365)


#Double checking to make sure the ts objects were created properly
str(log_inquiry_ts)
length(log_inquiry_ts)
print(log_inquiry_ts)
summary(inquiry_ts)
head(inquiry_ts)
class(inquiry_ts)

#Checking stationarity

#ADF tests to check stationarity
adf_test <- adf.test(log_inquiry_ts) #Results show that the data is stationary


# Creating matrices with external predictors to construct six ARIMA models

xreg0 <- cbind(inquiry_data$work_day, inquiry_data$special_day)
colnames(xreg0) <- c("work_day", "special_day")

xreg1 <- cbind(inquiry_data$ads_spending_usd, inquiry_data$work_day, inquiry_data$special_day)
colnames(xreg1) <- c("ads_spending", "work_day", "special_day")

xreg2 <- cbind(inquiry_data$completers, inquiry_data$work_day, inquiry_data$special_day)
colnames(xreg2) <- c("completers", "work_day", "special_day")

xreg3 <- cbind(inquiry_data$non_completers, inquiry_data$work_day, inquiry_data$special_day)
colnames(xreg3) <- c("non_completers", "work_day", "special_day")

xreg4 <- cbind(inquiry_data$no_of_campaigns, inquiry_data$work_day, inquiry_data$special_day)
colnames(xreg4) <- c("no_of_campaigns", "work_day", "special_day")

xreg5 <- cbind(inquiry_data$ads_campaigns, inquiry_data$work_day, inquiry_data$special_day)
colnames(xreg5) <- c("ads_campaigns", "work_day", "special_day")

xreg6 <- cbind(inquiry_data$ads_spending_usd, inquiry_data$no_of_campaigns, inquiry_data$work_day, inquiry_data$special_day)
colnames(xreg6) <- c("ads_spending", "no_of_campaigns", "work_day", "special_day")


#Time-series walk-forward cross-validation method 

#The goal of cross-validation is to understand how each variable of interest performs well on unseen data.
#This helps us choose the models with lowest errors.   



#Benchmark Model 0
fc0 <- function(x, h, xreg, newxreg) {
 forecast(auto.arima(x, xreg=xreg), h=1, xreg=newxreg)
}

#Model1
#
fc1 <- function(x, h, xreg, newxreg) {
  forecast(auto.arima(x, xreg = xreg), h=1, xreg=newxreg)
}

#Model2
fc2 <- function(x, h, xreg, newxreg) {
  forecast(auto.arima(x, xreg = xreg), h=1, xreg=newxreg)
}

#Model3
fc3 <- function(x, h, xreg, newxreg) {
  forecast(auto.arima(x, xreg = xreg), h=1, xreg=newxreg)
}

#Model4
fc4 <- function(x, h, xreg, newxreg) {
  forecast(auto.arima(x, xreg = xreg), h=1, xreg=newxreg)
}

#Model5
fc5 <- function(x, h, xreg, newxreg) {
  forecast(auto.arima(x, xreg = xreg), h=1, xreg=newxreg)
}

#Model6
fc6 <- function(x, h, xreg, newxreg) {
  forecast(auto.arima(x, xreg = xreg), h=1, xreg=newxreg)
}


# Perform cross-validation for each model with 14 days forecasts
CV0 <- tsCV(log_inquiry_ts, fc0, xreg = xreg0, h = 14)
CV1 <- tsCV(log_inquiry_ts, fc1, xreg = xreg1, h = 14)
CV2 <- tsCV(log_inquiry_ts, fc2, xreg = xreg2, h = 14)
CV3 <- tsCV(log_inquiry_ts, fc3, xreg = xreg3, h = 14)
CV4 <- tsCV(log_inquiry_ts, fc4, xreg = xreg4, h = 14)
CV5 <- tsCV(log_inquiry_ts, fc5, xreg = xreg5, h = 14)
CV6 <- tsCV(log_inquiry_ts, fc6, xreg = xreg6, h = 14)

#Finding differences between actual values and forecasted values to generate measures of fitness
n <- 365

accuracy_results <- list(
  Model0 = accuracy(ts(log_inquiry_ts[1:(n-13)]) - CV0[1:(n-13)], ts(log_inquiry_ts[1:(n-13)])),
  Model1 = accuracy(ts(log_inquiry_ts[1:(n-13)]) - CV1[1:(n-13)], ts(log_inquiry_ts[1:(n-13)])),
  Model2 = accuracy(ts(log_inquiry_ts[1:(n-13)]) - CV2[1:(n-13)], ts(log_inquiry_ts[1:(n-13)])),
  Model3 = accuracy(ts(log_inquiry_ts[1:(n-13)]) - CV3[1:(n-13)], ts(log_inquiry_ts[1:(n-13)])),
  Model4 = accuracy(ts(log_inquiry_ts[1:(n-13)]) - CV4[1:(n-13)], ts(log_inquiry_ts[1:(n-13)])),
  Model5 = accuracy(ts(log_inquiry_ts[1:(n-13)]) - CV5[1:(n-13)], ts(log_inquiry_ts[1:(n-13)])),
  Model6 = accuracy(ts(log_inquiry_ts[1:(n-13)]) - CV6[1:(n-13)], ts(log_inquiry_ts[1:(n-13)]))
)


# Convert the named list into a data frame
accuracy_df <- do.call(rbind, lapply(accuracy_results, as.data.frame))
rownames(accuracy_df) <- NULL  # Remove row names

# Add a column for model names
accuracy_df$Model <- names(accuracy_results)

# Reorder columns for better readability
accuracy_df <- accuracy_df[, c("Model", "MAE", "RMSE", "MAPE")]

# Print the table using knitr::kable
knitr::kable(accuracy_df)

#Checking the fitted models to detect overfitting/underfitting issues
fit_model <- ets(log_inquiry_ts)
fit_model0 <- auto.arima(log_inquiry_ts, xreg=xreg0, trace=TRUE)
fit_model1 <- auto.arima(log_inquiry_ts, xreg=xreg1, trace=TRUE)
fit_model2 <- auto.arima(log_inquiry_ts, xreg=xreg2, trace=TRUE)
fit_model3 <- auto.arima(log_inquiry_ts, xreg=xreg3, trace=TRUE)
fit_model4 <- auto.arima(log_inquiry_ts, xreg=xreg4, trace=TRUE)
fit_model5 <- auto.arima(log_inquiry_ts, xreg=xreg5, trace=TRUE)
fit_model6 <- auto.arima(log_inquiry_ts, xreg=xreg6, trace=TRUE)

accuracy(fit_model)
accuracy(fit_model0)
accuracy(fit_model1)
accuracy(fit_model2)
accuracy(fit_model3)
accuracy(fit_model4)
accuracy(fit_model5)
accuracy(fit_model6)

#To generate summary statistics of the fitted models
summary(fit_model0)
summary(fit_model1)
summary(fit_model2)
summary(fit_model3)
summary(fit_model4)
summary(fit_model5)
summary(fit_model6)


checkresiduals(fit_model0)
checkresiduals(fit_model1)
checkresiduals(fit_model2)
checkresiduals(fit_model3)
checkresiduals(fit_model4)
checkresiduals(fit_model5)
checkresiduals(fit_model6)
#Based on Ljung-box test results, model 2, model 3, model 5 violate residual normality.
#Therefore, these models are removed from further analysis
#The remaining models perform very similarly according to residual plots analysis.

#Visual Examination of the in-sample forecast performances

# In-sample forecasting for Model 0
in_sample_forecasts0 <- fitted(fit_model0)

# Plot actual vs. in-sample forecasted values
plot(log_inquiry_ts, type = "l", col = "blue", xlab = "Time", ylab = "inquiry volumes", main = "Actual vs. In-Sample Forecasted Values - Model 0")
lines(in_sample_forecasts0, col = "red")
legend("topright", legend = c("Actual", "In-Sample Forecast"), col = c("blue", "red"), lty = 1)


# In-sample forecasting for Model 6
in_sample_forecasts6 <- fitted(fit_model6)

# Plot actual vs. in-sample forecasted values
plot(log_inquiry_ts, type = "l", col = "blue", xlab = "Time", ylab = "inquiry volumes", main = "Actual vs. In-Sample Forecasted Values - Model 6")
lines(in_sample_forecasts6, col = "red")
legend("topright", legend = c("Actual", "In-Sample Forecast"), col = c("blue", "red"), lty = 1)

#Model 6 was chosen as the best model, followed by benchmark model 0.


#Checking the coefficents of the models
coeftest(fit_model0)
coeftest(fit_model6)



#Section 4 ----------------------------------------------------------------
#Forecasting using Model 6


#Forecast values for regressor
specialdays_future <- c(0,0,0,0,0,0,0,0,0,0,0,0,0,0)
work_day_future <- c(1,1,0,0,1,0,1,1,1,0,0,1,1,1)
specialdays_future <- as.factor(specialdays_future)
work_day_future <- as.factor(work_day_future)

ads_spending_mean <- mean(xreg6[,1], na.rm = TRUE)
ads_spending_future <- rep(ads_spending_mean, 14)

campaigns_mean <- mean(xreg6[,2], na.rm = TRUE)
campaigns_future <- rep(campaigns_mean, 14)

xreg_future6 <- cbind(ads_spending_future, campaigns_future,work_day_future,specialdays_future)

#Fit the  selected model with full data
forecast_fit_model6 <- forecast(fit_model6,xreg=xreg_future6,h=14)
autoplot(inquiry_ts) + autolayer(forecast_fit_model6)

#Back-transform forecast values from log-transformed forecasts
forecast_fit_model6$mean <- exp(forecast_fit_model6$mean)
if(length(forecast_fit_model6$lower) > 0 && length(forecast_fit_model6$upper) > 0){
  forecast_fit_model6$lower <- exp(forecast_fit_model6$lower)
  forecast_fit_model6$upper <- exp(forecast_fit_model6$upper)
}

# Create the forecast plot
forecast_plot <- autoplot(inquiry_ts) + autolayer(forecast_fit_model6)
forecast_plot +
  ggtitle("Two-week Forecast for Inquiry Volumes on Messenger using Model 6") +
  xlab("Time") +
  ylab("Inquiry Volumes")




#----------------------------
#----------------------------

#Appendix -  experimentation

#Checking linear relationships
plot(inquiry_data$ads_spending_usd,inquiry_data$inquiry_volumes)
lm_model1 <- lm(inquiry_volumes ~ ads_spending_usd, data = inquiry_data)
abline(lm_model1,col="red")

plot(inquiry_data$conversion_rate,inquiry_data$inquiry_volumes)
lm_model2 <- lm(inquiry_volumes ~ conversion_rate, data = inquiry_data)
abline(lm_model2)

plot(inquiry_data$no_of_campaigns,inquiry_data$inquiry_volumes)
lm_model3 <- lm(inquiry_volumes ~ no_of_campaigns, data = inquiry_data)
abline(lm_model3)

lm_model <- lm(inquiry_volumes ~ ads_spending_usd + no_of_campaigns + long_holiday + seasonality, data = inquiry_data)
summary(lm_model)
vif(lm_model)


# In-sample forecasting for Model 1
in_sample_forecasts1 <- fitted(fit_model1)

# Plot actual vs. in-sample forecasted values
plot(log_inquiry_ts, type = "l", col = "blue", xlab = "Time", ylab = "inquiry volumes", main = "Actual vs. In-Sample Forecasted Values - Model 1")
lines(in_sample_forecasts1, col = "red")
legend("topright", legend = c("Actual", "In-Sample Forecast"), col = c("blue", "red"), lty = 1)



# In-sample forecasting for Model 2
in_sample_forecasts2 <- fitted(fit_model2)

# Plot actual vs. in-sample forecasted values
plot(log_inquiry_ts, type = "l", col = "blue", xlab = "Time", ylab = "inquiry volumes", main = "Actual vs. In-Sample Forecasted Values - Model 2")
lines(in_sample_forecasts2, col = "red")
legend("topright", legend = c("Actual", "In-Sample Forecast"), col = c("blue", "red"), lty = 1)


# In-sample forecasting for Model 3
in_sample_forecasts3 <- fitted(fit_model3)

# Plot actual vs. in-sample forecasted values
plot(log_inquiry_ts, type = "l", col = "blue", xlab = "Time", ylab = "inquiry volumes", main = "Actual vs. In-Sample Forecasted Values - Model 3")
lines(in_sample_forecasts3, col = "red")
legend("topright", legend = c("Actual", "In-Sample Forecast"), col = c("blue", "red"), lty = 1)


# In-sample forecasting for Model 4
in_sample_forecasts4 <- fitted(fit_model4)

# Plot actual vs. in-sample forecasted values
plot(log_inquiry_ts, type = "l", col = "blue", xlab = "Time", ylab = "inquiry volumes", main = "Actual vs. In-Sample Forecasted Values - Model 4")
lines(in_sample_forecasts4, col = "red")
legend("topright", legend = c("Actual", "In-Sample Forecast"), col = c("blue", "red"), lty = 1)


# In-sample forecasting for Model 5
in_sample_forecasts5 <- fitted(fit_model5)

# Plot actual vs. in-sample forecasted values
plot(log_inquiry_ts, type = "l", col = "blue", xlab = "Time", ylab = "inquiry volumes", main = "Actual vs. In-Sample Forecasted Values - Model 5")
lines(in_sample_forecasts5, col = "red")
legend("topright", legend = c("Actual", "In-Sample Forecast"), col = c("blue", "red"), lty = 1)


#Forecasting model 1

#Forecast values for regressor
holidays_future <- c(0,0,0,0,0,0,0,0,0,0,0,0,0,0)
work_day_future <- c(1,1,0,0,1,0,1,1,1,0,0,1,1,1)
holidays_future <- as.factor(holidays_future)
work_day_future <- as.factor(work_day_future)

ads_median <- median(xreg1[,1], na.rm = TRUE)
ads_future <- rep(ads_median, 14)

xreg_future1 <- cbind(ads_future,work_day_future,holidays_future)

#Fit the  selected model with full data
fit_model1 <- auto.arima(inquiry_ts,xreg=xreg1,d=1, trace=TRUE)
accuracy(fit_model1)
checkresiduals(fit_model1)
forecast_fit_model1 <- forecast(fit_model1,xreg=xreg_future1,h=14)
autoplot(inquiry_ts) + autolayer(forecast_fit_model1)


#Forecasting model 4

#Forecast values for regressor
holidays_future <- c(0,0,0,0,0,0,0,0,0,0,0,0,0,0)
work_day_future <- c(1,1,0,0,1,0,1,1,1,0,0,1,1,1)
holidays_future <- as.factor(holidays_future)
work_day_future <- as.factor(work_day_future)

campaigns_median <- median(xreg4[,1], na.rm = TRUE)
campaigns_future <- rep(campaigns_median, 14)

xreg_future4 <- cbind(campaigns_future,work_day_future,holidays_future)

#Fit the  selected model with full data
fit_model1 <- auto.arima(inquiry_ts,xreg=xreg4,d=1, trace=TRUE)
accuracy(fit_model4)
checkresiduals(fit_model4)
forecast_fit_model4 <- forecast(fit_model4,xreg=xreg_future4,h=14)
autoplot(inquiry_ts) + autolayer(forecast_fit_model4)
