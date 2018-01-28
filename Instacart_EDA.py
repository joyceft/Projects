# -*- coding: utf-8 -*-
"""
Created on Thu Jan 25 19:03:01 2018

@author: Tianyi Fang
"""

#Instacart EDA
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
color = sns.color_palette()

%matplotlib inline

from subprocess import check_output
#check the dataset in the workplace
print(check_output(['ls', 'E:\\projects\\Instacart']).decode('utf8'))

#read datasets in as df and take a look
orders_df = pd.read_csv('E:\\projects\\Instacart\\orders.csv')
products_df = pd.read_csv('E:\\projects\\Instacart\\products.csv')
order_products_train_df = pd.read_csv('E:\\projects\\Instacart\\order_products__train.csv')
order_products_prior_df = pd.read_csv('E:\\projects\\Instacart\\order_products__prior.csv')
aisles_df = pd.read_csv('E:\\projects\\Instacart\\aisles.csv')
departments_df = pd.read_csv('E:\\projects\\Instacart\\departments.csv')
#take a look at orders
orders_df.head()

cnt_srs = orders_df.eval_set.value_counts()
print(cnt_srs)
plt.figure(figsize= (12,8))
sns.barplot(cnt_srs.index, cnt_srs.values, alpha = 0.8, color = color[1])
plt.ylabel('Number of Occurance', fontsize = 12)
plt.xlabel('Eval set type', fontsize = 12)
plt.title('Count of rows in each dataset')
#See how raw data are separated into 3 parts

def get_unique_count(x):
    return len(np.unique(x))

cnt_srs = orders_df.groupby("eval_set")["user_id"].aggregate(get_unique_count)
cnt_srs
#unique customers

cnt_srs = orders_df.groupby("user_id")["order_number"].aggregate(np.max).reset_index()
cnt_srs = cnt_srs.order_number.value_counts()
plt.figure(figsize=(12,8))
sns.barplot(cnt_srs.index, cnt_srs.values, alpha=0.8, color=color[2])
plt.ylabel('Number of Occurrences', fontsize=12)
plt.xlabel('Maximum order number', fontsize=12)
plt.xticks(rotation='vertical')
#the min order is 4, largest is 100

#frequency of order by week day
sns.countplot(x='order_dow', data = orders_df, color = color[0])
plt.title("Frequency of order by week day", fontsize=15)
#during 0(Sat),1(Sun) are most sells day, Wed is lowest

#frequency of order by time of day
sns.countplot(x="order_hour_of_day", data=orders_df, color=color[1])
plt.title("Frequency of order by hour of day", fontsize=15)

#combine shopping hours and days
grouped_df = orders_df.groupby(["order_dow", "order_hour_of_day"])["order_number"].aggregate("count").reset_index()
grouped_df.head()

grouped_df = grouped_df.pivot("order_dow", "order_hour_of_day", "order_number")
grouped_df.head()

sns.heatmap(grouped_df)
plt.title("Frequency of Day of week Vs Hour of day")
#seems the Saturdats' afternoon and Sunday's morning are peak shopping time
 
#Check the shopping interval between orders
sns.countplot(x="days_since_prior_order", data = orders_df,  color = color[2])
plt.title("Frequency distribution by days since prior order", fontsize=15)
#Looks like customer shopping weekly or monthly. Maybe due to different product categories,
#also there are peaks during 7, 14, 21, 28(weekends)


#check the reorder data
order_products_prior_df["reordered"].sum()/order_products_prior_df.shape[0]
order_products_train_df["reordered"].sum()/order_products_train_df.shape[0]
#Almost the same, nearly 0.592
