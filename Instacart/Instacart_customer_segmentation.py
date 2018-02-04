# -*- coding: utf-8 -*-
"""
Created on Wed Jan 31 10:56:23 2018

@author: Tianyi Fang
"""
'''
Find a possible customer segmentation enabling to classify customers according 
to their different purchases. Might be useful in prediction of reorder products 
and help marketing team better understand our customers and making better 
recommendations.
Using PCA to do generate new principle features, make clustering easier.



'''
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
train_df = pd.read_csv('E:\\projects\\Instacart\\order_products__train.csv')
prior_df = pd.read_csv('E:\\projects\\Instacart\\order_products__prior.csv')
aisles_df = pd.read_csv('E:\\projects\\Instacart\\aisles.csv')
departments_df = pd.read_csv('E:\\projects\\Instacart\\departments.csv')

np.shape(orders_df)
orders_df.head()
products_df.head()
prior_df.head()
aisles_df.shape

#open take 300000 in prior
prior_df = prior_df[0:300000]
order_prior = pd.merge(prior_df, orders_df, on = ['order_id','order_id'])
order_prior = order_prior.sort_values(by = ['user_id', 'order_id'])
order_prior.head()

total_df = pd.merge(prior_df, products_df, on = ['product_id','product_id'])
total_df = pd.merge(total_df, aisles_df, on = ['aisle_id','aisle_id'])
total_df = pd.merge(total_df, orders_df, on = ['order_id','order_id'])
total_df.head()

#check the most popular products, aisles
len(np.unique(total_df['product_name']))
total_df['product_name'].value_counts()[0:10]
len(np.unique(total_df['aisle']))
total_df['aisle'].value_counts()[0:10]


customer_product_df = pd.crosstab(total_df['user_id'], total_df['aisle'])
customer_product_df.head()

#apply PCA to reduce features into 6
from sklearn.decomposition import PCA
pca = PCA(n_components = 6)
pca.fit(customer_product_df)
pca_samples = pca.transform(customer_product_df)
pca_samples_df = pd.DataFrame(pca_samples)
pca_samples_df.head()

#plot the pairs of components, to find the suitable one
from mpl_toolkits.mplot3d import Axes3D
from mpl_toolkits.mplot3d import proj3d

fig = plt.figure(figsize = (8,8))
'''
since we want pca1 perpenticular to pca2, so plot some pairs
so see whether they are perpenticular to each other or not

'''
#choose some pairs to try pc4, pc1
pca_samples_df[[4,1]]
tocluster = pd.DataFrame(pca_samples_df[[4,1]])
tocluster.head()
plt.plot(tocluster[4], tocluster[1], "o", markersize = 2, color = 'blue', 
         alpha = 0.5, label = "class1")
pca_samples_df.head()
tocluster2 = pd.DataFrame(pca_samples_df[[3,1]])
#[3,1]
plt.plot(tocluster2[3], tocluster2[1], "o", markersize = 2, color = 'blue', 
         alpha = 0.5, label = "class2")
#[2,1]
plt.plot(pd.DataFrame(pca_samples_df[[2,1]])[2], 
         pd.DataFrame(pca_samples_df[[2,1]])[1], "o", markersize = 2, color = 'blue', 
         alpha = 0.5, label = "class3")
#[4,2]
plt.plot(pd.DataFrame(pca_samples_df[[4,2]])[4], 
         pd.DataFrame(pca_samples_df[[4,2]])[2], "o", markersize = 2, color = 'blue', 
         alpha = 0.5, label = "class4")
#write a loop to check
for i in range(0,5):
    for j in range(0,4):
        plt.figure(i+j)
        plt.plot(pd.DataFrame(pca_samples_df[[i,j]])[i], 
         pd.DataFrame(pca_samples_df[[i,j]])[j], "o", markersize = 2, color = 'blue', 
         alpha = 0.5, label = "class$i+j$")
        plt.hold(True)
        
for j in range(4):
    plt.figure(j)
    plt.plot(pd.DataFrame(pca_samples_df[[4,j]])[4], 
         pd.DataFrame(pca_samples_df[[4,j]])[j], "o", markersize = 2, color = 'blue', 
         alpha = 0.5, label = "class$i+j$")
'''
find that pca4 is always perpenticular to others, so choose pca1, pca4
then to do k-means clustering
'''
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
clusterer = KMeans(n_clusters = 4, random_state = 42).fit(tocluster)
centers = clusterer.cluster_centers_
c_preds = clusterer.predict(tocluster)
print(centers)
print(c_preds[0:100]) #check each customer in which cluster
#visualize our cluster result
colors = ['orange','blue','purple','green']#give each cluster a color
colored = [colors[k] for k in c_preds]
colored[0:10]
plt.scatter(tocluster[4], tocluster[1], color = colored)
#show the cluster center 
for ci, c in enumerate(centers):
    plt.plot(c[0], c[1], 'o', markersize = 8, color = 'red', alpha = 0.9, 
             label = '' + str(ci))
plt.legend()    
'''
now maybe we find the possible clustering for our customers
lets take a look at whether there are some interesting pattern we can find
'''
#combine customer_product with cluster
cluster_product = customer_product_df.copy()
cluster_product['cluster'] = c_preds
cluster_product.head()

'''
now check how many people are in each cluster and in the total
'''
f, arr = plt.subplots(2,2, sharex = True, figsize = (15, 15))
c1_count = len(cluster_product[cluster_product['cluster']==0])
c0 = cluster_product[cluster_product['cluster']==0].drop('cluster', axis = 1). mean()
arr[0,0].bar(range(len(cluster_product.drop('cluster', axis = 1).columns)), c0)
c1 = cluster_product[cluster_product['cluster']==1].drop('cluster', axis = 1). mean()
arr[0,1].bar(range(len(cluster_product.drop('cluster', axis = 1).columns)), c1)
c2 = cluster_product[cluster_product['cluster']==2].drop('cluster', axis = 1). mean()
arr[1, 0].bar(range(len(cluster_product.drop('cluster', axis = 1).columns)), c2)
c3 = cluster_product[cluster_product['cluster']==3].drop('cluster', axis = 1). mean()
arr[1,1].bar(range(len(cluster_product.drop('cluster', axis = 1).columns)), c3)
plt.show()

'''now check what are top 10 popular products bought by customers in each cluster
based on the absolute number and the precentage among each cluster
'''
c0.head()
print("cluster0:", c0.sort_values(ascending = False)[0:10])
print("cluster1:",c1.sort_values(ascending = False)[0:10])
print("cluster2:",c2.sort_values(ascending = False)[0:10])
print("cluster3:",c3.sort_values(ascending = False)[0:10])
#can code to find those unique ones, common ones among clusters
'''from top 10 product of each cluster, we can see there are many common products
bought by customers of each cluster, 
like: fresh fruits, fresh veges, yugurt, packaged cheese, milk, chip pretzels
so let's take a look at the special ones:
    c0:fresh herbs, frozen product, canned jarred veges(no chip, sparking water)
    c1:refrigerated
    c2:energy granola bars, bread
    c3:baby food formula(no soy lactosefree)
'''
'''
since most popular products are common in every cluster, maybe top10~15 could tell
us more about the specialality of each cluster
'''
print("cluster0:", c0.sort_values(ascending = False)[10:15])
print("cluster1:",c1.sort_values(ascending = False)[10:15])
print("cluster2:",c2.sort_values(ascending = False)[10:15])
print("cluster3:",c3.sort_values(ascending = False)[10:15])

'''
like: fresh fruits, fresh veges, yugurt, packaged cheese, milk, chip pretzels,
bread, 
so let's take a look at the special ones:
    c0:fresh herbs, frozen product, canned jarred veges, soup broth, beans(no chip)
    c1:refrigerated, soft drinks
    c2:energy granola bars, crackers
    c3:baby food formula, cereal(no soy lactosefree)
Now, we can tell more about features of each cluster. 
c0 is much healthier than others. they buy herbs, broth, indicate they might 
enjoy cooking more by themselves, and this cluster of customer has no interest in
chips! How healthy!
c1 is the opposite. High precentage in chips, refrigerated, soft drinks. Showing
the lifestyle of majority US people, love chips and soft drinks!
c2 is more like "gym guy", noticably high purchase rate in energy bar, bread, milk, 
maybe next time, we can recommend them about protein powder or products would help
them recovered from workout and keep fit!
c3 is the most unique one with "baby food formula" and "cereal". Which indicates
that they are large likely to be young mom or pregment women.
