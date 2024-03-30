#!/usr/bin/env python
# coding: utf-8

# # 2023 London Fire False Alarm Predictions

# 1. Data Cleaning and EDA
#     - Time Series Analysis
#     - Location Analysis
#     - General Analyis
#     
# 2. Data Preprocessing and Feature Engineering
# 
# 3. Model Exploration and Development
# 
# 4. Model Improvement & Model Selection

# In[2]:


import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.linear_model import LogisticRegression
from sklearn.neighbors import KNeighborsClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import GridSearchCV, RandomizedSearchCV
from sklearn.metrics import accuracy_score,precision_score, recall_score, f1_score 

#To surpress warnings
import warnings
warnings.filterwarnings('ignore')


# In[3]:


fire_df = pd.read_csv("C:\\london_fire_incidents.csv", encoding = 'ISO-8859-1')


# In[4]:


sns.set_palette('Set2')


# In[5]:


fire_df.head()


# In[6]:


#To visualize the dataframe before conducting EDA

from itables import init_notebook_mode

init_notebook_mode(all_interactive = True)


# In[7]:


from itables import show

show(
    fire_df,
     layout = {"top1": "searchBuilder"},
     searchBuilder = {
         "preDefined": {
             "criteria" : [
                 {"data" : "IncidentGroup" , "condition" : "=", "value" : ["Fire"]}
             ]
         }
     },
)


# ## 1. Data Cleaning and EDA

# In[8]:


#Checking data types

fire_df.info()


# In[9]:


fire_df_clean = fire_df.iloc[:, :-12].drop(["CalYear","HourOfCall","SpecialServiceType"],axis = 1)


fire_df_clean.head()


# In[10]:


fire_df_clean.info()


# In[11]:


fire_df_clean.nunique() 


# In[16]:


sns.barplot(data = fire_df_clean['IncidentGroup'].value_counts(normalize = True), color ='darkred')


# ### Time Series Analysis

# In[17]:


fire_df_clean['DateTime'] = fire_df_clean['DateOfCall'] + ' ' + fire_df_clean['TimeOfCall']

fire_df_clean['DateTime'] = pd.to_datetime(fire_df_clean['DateTime'], format = '%d-%b-%y %H:%M:%S')
fire_df_clean.head()


# In[18]:


fire_df_clean = (fire_df_clean.assign(
    incident_year = fire_df_clean["DateTime"].dt.year,
    incident_month = fire_df_clean["DateTime"].dt.month,
    incident_dayofweek = fire_df_clean["DateTime"].dt.dayofweek,
    incident_day = fire_df_clean["DateTime"].dt.day,
    incident_hour = fire_df_clean["DateTime"].dt.hour,
    incident_minute = fire_df_clean["DateTime"].dt.minute)
).drop(['IncidentNumber','DateOfCall','TimeOfCall','DateTime'], axis = 1)

fire_df_clean.tail()


# In[19]:


incidents_time_df = fire_df_clean[fire_df_clean["IncidentGroup"] == "False Alarm"].iloc[:, -6:]
incidents_time_df.head()


# In[20]:


incidents_time_df = pd.concat([fire_df_clean[['IncidentGroup']],fire_df_clean.iloc[:, -6:]],axis =1)
incidents_time_df.head()


# In[16]:


data = incidents_time_df.drop(['incident_year','incident_minute'], axis =1)

for feat in data.select_dtypes('int').columns:
    aggregate_data = data.groupby([feat, 'IncidentGroup']).size().reset_index(name ='no of incidents')
    sns.lineplot(data = aggregate_data, x = feat,y = 'no of incidents', hue = 'IncidentGroup')
    plt.show()


# Although the incident rates seem to vary based on temporal patterns, both false alarms and actual acidents share similar trends. Therefore, time factors may not have high predictive value.

# ### Location Analysis

# Location data has several missing values. We need to analyse if these missing values are systematically missing or random.
# 
# Amongst the location data, the following features have no missing values:
# 
# - Postcode_district
# - UPRN
# - USRN
# - IncGeo_BoroughCode
# - IncGeo_BoroughName
# - ProperCase
# - Easting_rounded
# - Northing_rounded

# In[21]:


fire_df_clean.isnull().sum()


# In[22]:


import folium

location_df = fire_df_clean.dropna(subset = ['Latitude','Longitude'])

# create the map.
incidents_map = folium.Map(location=[51.5074,-0.1278],  tiles = "Cartodb Positron")

# adding the latitude and longitude points to the map.
location_df.apply(lambda row:folium.Circle(
    location=[row["Latitude"], row["Longitude"]],
    radius = 5,
    color = 'darkred',
    fill = False,
    fill_opacity = 0.4
).add_to(incidents_map), axis=1)

# display the map: just ask for the object representation in juypter notebook.
incidents_map


# In[23]:


from matplotlib.colors import to_hex

location_fa_df = location_df[location_df['IncidentGroup'] == 'False Alarm']

borough_list = location_fa_df['IncGeo_BoroughName'].unique()
colormap = plt.cm.get_cmap('Set3', len(borough_list))

borough_colors = {borough: to_hex(colormap(i)) for i, borough in enumerate(borough_list)}

# create the map.
incidents_map = folium.Map(location=[51.5074,-0.1278], tiles = "Cartodb Positron")

# adding the latitude and longitude points to the map.
location_fa_df.apply(lambda row:folium.Circle(
    location=[row["Latitude"], row["Longitude"]],
    radius = 5,
    color = borough_colors[row['IncGeo_BoroughName']],
    fill = False,
    fill_opacity = 0.4
).add_to(incidents_map), axis=1)

# display the map
incidents_map


# In[24]:


location_fa_df.head()


# In[25]:


# Checking if null values of Location data are systematically missing or not
null_counts_by_group = fire_df_clean.groupby('AddressQualifier')['Longitude'].apply(lambda x: x.isnull().sum()).reset_index(name='Null_Counts')

null_counts_by_group


# ### General Analysis

# As we have some initial insights on the incident types, we will create a target variable to dig deeper.

# In[26]:


fire_df_clean['target'] = np.where(fire_df_clean['IncidentGroup'] == 'False Alarm', 1, 0)


# In[27]:


fire_df_clean.head()


# In[24]:


sns.barplot( data = fire_df_clean['target'].value_counts(normalize = True))


# Since the target variable doesn't have class imbalance issues, we don't need to handle resampling techniques. 

# In[28]:


cat_data = fire_df_clean[['target','PropertyCategory','IncGeo_BoroughName']]

def cat_plotter(data,target, fig_width = 10, fig_height =  8):
    for col in data.select_dtypes(["object"]).columns:
        plt.figure(figsize = (fig_width,fig_height))
        sns.barplot(
            data=(
                data
                .groupby(col, as_index=False)
                .agg({"target": "mean"})
                .sort_values(by="target", ascending=False)
                 ), 
            x=col, 
            y=target,
            palette = 'Set3')
        plt.xticks(rotation=80, ha = 'right')
        plt.show()
        
cat_plotter(cat_data, "target", fig_width = 12, fig_height = 6)


# In[29]:


fire_df_clean['StopCodeDescription'].value_counts()


# In[30]:


sums_by_group = fire_df_clean.groupby('StopCodeDescription')['target'].sum()
total_sum = sums_by_group.sum()
percentage = round((sums_by_group/total_sum) * 100, 2)
print(percentage)


# Although StopCodeDescription does not directly refer to source of call, we can guage the origin of call for False Alarms from this variable, assuming that we can distinguish the call at the time of prediction. Surprisingly, 80% of False Alarms come from AFA. This feature might have a high predictive power on false alarms.

# ## 2. Data Preprocessing and Feature Engineering

# In[31]:


fire_df_clean.head()


# In[32]:


def check_source_of_call(row):
    if 'afa' in row['StopCodeDescription'].lower():
        return 'AFA'
    else:
        # Since we don't have access to source of call from the dataset, we will treat other types as non-AFA
        return 'Non-AFA'
    
fire_df_clean['SourceOfCall'] = fire_df_clean.apply(check_source_of_call, axis = 1)
fire_df_clean.head()


# In[33]:


drop_features = ['IncidentGroup',
                 'StopCodeDescription',
                 'PropertyType',
                 'AddressQualifier',
                 'Postcode_full',
                 'Postcode_district',
                 'UPRN',
                 'USRN',
                 'IncGeo_BoroughCode',
                 'ProperCase',
                 'IncGeo_WardCode',
                 'IncGeo_WardName',
                 'IncGeo_WardNameNew',
                 'Easting_m',
                 'Northing_m',
                 'Latitude',
                 'Longitude',
                 'incident_minute',
                 #'SourceOfCall', #we will test with and without this feature to gauge its influence on performance
                  ]

fire_df_prep = fire_df_clean.drop(drop_features, axis =1)
fire_df_prep = pd.get_dummies(fire_df_prep, drop_first = True, dtype = int)
fire_df_prep.head()


# ## 3. Model Exploration and Development

# In[40]:


from sklearn.model_selection import train_test_split
#Splitting data

X = fire_df_prep.drop('target', axis =1)
y = fire_df_prep['target']

X_train,X_test,y_train,y_test = train_test_split(X,y, test_size = 0.2, random_state = 42)


# In[47]:


lr = LogisticRegression(penalty = 'l2', random_state = 42, solver = 'lbfgs', max_iter =100)

lr.fit(X_train,y_train)

print(classification_report(y_train,lr.predict(X_train)))
print(classification_report(y_test,lr.predict(X_test)))


# In[45]:


import sklearn
print(sklearn.__version__)


# In[37]:


print(accuracy_score(y_train,lr.predict(X_train)))
print(accuracy_score(y_test,lr.predict(X_test)))


# In[35]:


from sklearn.metrics import confusion_matrix

sns.heatmap(
    data = confusion_matrix(y_test, lr.predict(X_test)),
    cmap = 'Reds',
    annot = True,
    fmt = 'g',
    xticklabels = ['Real Incidents','False Alarms'],
    yticklabels = ['Real Incidents','False Alarms'],
).set(
    xlabel = 'Predictions',
    ylabel = 'Actual',
    title = 'Logistic Confusion Matrix')


# In[37]:


from sklearn.preprocessing import StandardScaler

std = StandardScaler()

X_train_std = std.fit_transform(X_train)
X_test_std = std.transform(X_test)


# In[38]:


knn = KNeighborsClassifier()

knn.fit(X_train_std,y_train)

print(classification_report(y_train,lr.predict(X_train_std)))
print(classification_report(y_test,lr.predict(X_test_std)))


# In[39]:


print(accuracy_score(y_train,knn.predict(X_train_std)))
print(accuracy_score(y_test, knn.predict(X_test_std)))


# In[40]:


sns.heatmap(
    data = confusion_matrix(y_test, knn.predict(X_test_std)),
    cmap = 'Reds',
    annot = True,
    fmt = 'g',
    xticklabels = ['Real Incidents','False Alarms'],
    yticklabels = ['Real Incidents','False Alarms'],
).set(
    xlabel = 'Predictions',
    ylabel = 'Actual',
    title = 'KNN Confusion Matrix')


# In[41]:


from sklearn.naive_bayes import GaussianNB

gnb = GaussianNB()

gnb.fit(X_train,y_train)

print(classification_report(y_train,gnb.predict(X_train)))
print(classification_report(y_test, gnb.predict(X_test)))


# In[42]:


print(accuracy_score(y_train,gnb.predict(X_train)))
print(accuracy_score(y_test, gnb.predict(X_test)))


# In[43]:


sns.heatmap(
    data = confusion_matrix(y_test, gnb.predict(X_test)),
    cmap = 'Reds',
    annot = True,
    fmt = 'g',
    xticklabels = ['Real Incidents','False Alarms'],
    yticklabels = ['Real Incidents','False Alarms'],
).set(
    xlabel = 'Predictions',
    ylabel = 'Actual',
    title = 'Gaussian Confusion Matrix')


# In[44]:


rf = RandomForestClassifier(random_state = 42)

rf.fit(X_train,y_train)

print(classification_report(y_train,rf.predict(X_train)))
print(classification_report(y_test, rf.predict(X_test)))


# In[45]:


print(accuracy_score(y_train,rf.predict(X_train)))
print(accuracy_score(y_test,rf.predict(X_test)))


# In[46]:


from sklearn.metrics import confusion_matrix

sns.heatmap(
    data = confusion_matrix(y_test, rf.predict(X_test)),
    cmap = 'Reds',
    annot = True,
    fmt = 'g',
    xticklabels = ['Real Incidents','False Alarms'],
    yticklabels = ['Real Incidents','False Alarms'],
).set(
    xlabel = 'Predictions',
    ylabel = 'Actual',
    title = 'Random Forest Confusion Matrix')


# In[47]:


feature_importance = (
    pd.DataFrame({
        'features' : X_train.columns,
        'importance' : rf.feature_importances_
    })
    .sort_values('importance', ascending = False)
)

top_10_features = feature_importance.head(20)
sns.barplot(data = top_10_features, x = 'importance', y= 'features', palette ='Set3')


# ## 4. Model Improvement

# In[57]:


# Tuning KNN 
knn_params = {"n_neighbors": range(1, 50)}

knn_grid = GridSearchCV(KNeighborsClassifier(), knn_params)

knn_grid.fit(X_train_std, y_train)

knn_grid.best_params_


# In[60]:


knn_tuned = KNeighborsClassifier(**knn_grid.best_params_)

knn_tuned.fit(X_train_std,y_train)

print(f"Training Accuracy: {knn_tuned.score(X_train_std, y_train)}")
print(f"Test Accuracy: {knn_tuned.score(X_test_std, y_test)}")


# In[66]:


print(classification_report(y_test, knn_tuned.predict(X_test_std)))


# In[49]:


#Tuning Random Forest with Randomized Search to narrow down the best parameters

rf = RandomForestClassifier(random_state = 42, n_jobs = -1)

params = {
    'n_estimators' : np.arange(start = 100, stop = 500, step = 100),
    'max_features' : [None, 'sqrt'],
    'max_samples' : [None, .3, .5, .9],
    'max_depth' : np.arange(start = 1, stop = 11, step = 1),
    'min_samples_leaf': [2,5,10,20,100],
}

rs = RandomizedSearchCV(
    rf,
    params,
    n_iter = 100,
    scoring = 'accuracy'
)

rs.fit(X_train,y_train)

rs.best_params_


# In[55]:


rf = RandomForestClassifier(random_state = 42, n_jobs = -1)

params = {
    'n_estimators' : [50,100,150],
     'min_samples_leaf': [4,5,6,7],
     'max_samples': [0.8, 0.9],
     'max_features': [None],
     'max_depth': [10],
}

grid = GridSearchCV(
    rf,
    params,
    scoring = 'accuracy'
)

grid.fit(X_train,y_train)

grid.best_params_


# In[56]:


rf_tuned = RandomForestClassifier(random_state=42, **grid.best_params_)

rf_tuned.fit(X_train, y_train)

print(f"Training Accuracy: {rf_tuned.score(X_train, y_train)}")
print(f"Test Accuracy: {rf_tuned.score(X_test, y_test)}")


# In[65]:


print(classification_report(y_test, rf_tuned.predict(X_test)))


# In[64]:


sns.heatmap(
    data = confusion_matrix(y_test, rf_tuned.predict(X_test)),
    cmap = 'Reds',
    annot = True,
    fmt = 'g',
    xticklabels = ['Real Incidents','False Alarms'],
    yticklabels = ['Real Incidents','False Alarms'],
).set(
    xlabel = 'Predictions',
    ylabel = 'Actual',
    title = 'Tuned Random Forest Confusion Matrix')


# In[63]:


from sklearn.metrics import roc_curve, auc

#Generate ROC AUC for tuned random forest
y_probs = rf_tuned.predict_proba(X_test)[:, 1]
fpr1, tpr1, thresholds = roc_curve(y_test, y_probs)
auc_score1 = auc(fpr1, tpr1)

#Generate ROC AUC for tuned KNN model
y_probs = rf_tuned.predict_proba(X_test_std)[:, 1]
fpr2, tpr2, thresholds = roc_curve(y_test, y_probs)
auc_score2 = auc(fpr2, tpr2)

#Plot the ROC curve

plt.plot(fpr1, tpr1, label = f'Tuned RF (AUC = {auc_score1: .2f})')
plt.plot(fpr2, tpr2, label = f'Tuned KNN  (AUC = {auc_score2: .2f})')
         
         # Draw Random Guess
plt.plot([0, 1], [0, 1], 'k--', label='Random Guess (AUC = 0.50)')

# Modify Formatting
plt.xlabel('False Positive Rate')
plt.ylabel('True Positive Rate')
plt.title('ROC Curves for Different Models')
plt.legend()
plt.show()


# It is evident that Tuned Random Forest outperformed the Tuned KNN model in terms of AUC score.  Increasing the threshold of true positives (false alarms) (up to a certain point indicated by the graph) would not significantly increase the chances of false positives (actual incidents being incorrectly identified as false alarms). The model seems to be performing well in this regard, as indicated by the sharp angle of the curve and the low FPR across a wide range of TPR values.In other words, the model is quite confident in identifying what it considers false alarms without mistakenly classifying actual incidents.
