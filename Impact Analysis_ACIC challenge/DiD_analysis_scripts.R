#loading necessary packages
library(dplyr)
library(ggplot2)
library(plm)
library(lmtest)
library(sandwich)

#loading data
data1 <- read.csv("C://Hospital Expenditures Data/acic_year_copy.csv") #replace with file paths
data2 <- read.csv("C://Hospital Expenditures Data/acic_data_copy.csv") #replace with file paths

#merging two datases according instructions from data competition
merged_data <- merge(data1,data2,by = "id.practice")

#checking a merged dataset
head(merged_data)

#checking data types
str(merged_data)

#converting categorical data into factor data types
merged_data <-  merged_data %>%
  mutate_if(is.character,as.factor)

#converting binary columns into factor data types
merged_data <- merged_data %>%
  mutate_at(c('X1','X3','X5','Z','post'),as.factor)

str(merged_data)

#creating a data frame for average outcomes by intervention year and treated groups
average_data <- merged_data %>%
  group_by(Z, year, X3) %>%
  summarise(mean_expenditure = mean(Y, na.rm= TRUE)) %>%
  ungroup()

print(average_data)

#creating a line plot to visualize parallel trend between treatment and control groups pre and post intervention
ggplot(average_data %>% filter(X3 == 0),aes(x=year, y= mean_expenditure, colour = Z)) +
  geom_line()+
  geom_point()+
  labs(title = 'Average Medicare Expenditure Pre and Post Intervention',
    x = 'Year',
    y = 'Average Expenditure',
    color = 'Z')+
  geom_vline(xintercept = 2.5, linetype = "dashed", color = "darkorange") +
  scale_color_manual(values = c("navyblue", "red"),
                      labels = c("Control", "Treatment")) +
  theme_minimal()+
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(colour = "black", fill=NA))

#checking distribution of outcome data
ggplot(merged_data,aes(x=Y)) + geom_histogram(color='black',fill='lightblue') +
  labs(title='Histogram of Average Expenditure of Practices',
       x = 'Expenditure',
       y = 'No of practices')+
  theme_minimal()+
  theme(panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_rect(colour = "black", fill=NA))
#outcome data is slightly right-skewed

#transforming dataset into panel data
panel_data <- pdata.frame(merged_data, index=c('id.practice','year'))

View(panel_data)

panel_data$log_Y <- log(panel_data$Y)


did_model_weighted <- plm(log_Y ~ Z + post + Z*post + V1_avg + V2_avg + V3_avg + V4_avg + V5_A_avg + V5_B_avg + V5_C_avg + X1 + X2 + X3 + X4 + X5 + X6 + X7 + X8 + X9, 
                 data = panel_data, model = 'within', weights = n.patients)
did_model_unweighted <- plm(log_Y ~ Z + post + Z*post + V1_avg + V2_avg + V3_avg + V4_avg + V5_A_avg + V5_B_avg + V5_C_avg + X1 + X2 + X3 + X4 + X5 + X6 + X7 + X8 + X9, 
                 data = panel_data, model = 'within')

summary(did_model_weighted)
summary(did_model_unweighted)

#obtain clustered standard errors
coeftest(did_model_unweighted, vcov = function(x)
  vcovHC(x, cluster = 'group', type = 'HC1'))
