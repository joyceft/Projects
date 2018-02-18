# Ensemble combination of diverse Classifiers based on AdaBoost Using Genetic Algorithm
This is a personal crosswork project of Computational Statistics and Nature-Inspired Algorithm, which applied Genetic Algorithm in model selection
of mixed weak learners in Adaboost model.

This idea is inspired by Knapsack Problem. Each weak learner in the final model is like one item in the bag, with its own value and weight, the goal is to applying Genetic Algorithm to find the best combination of items to maximize the total value of the bag within the limitation of bag capacity. Here for my project is: apply Genetic Algorithm to find the best combination of weak learners to maximize the final model's preformance with the restriction of the number of weak learners. In that case, the preformance of final model is not hurt by reducing the model complexity in binary classification problems.

## Languages and Packages
R; 

Caret, GA, and other data analysis and visualization packages(plyr, MICE, reshape, tidyverse, ggplot, etc) 
## Datasets
This self-written maching learning prediction model is tested on 3 datasets:
- Wisconsin Breast Cancer
- Pima Indians Diabetes
- Sonar
Which can be all found in [UCI Machine Learning Repository](http://archive.ics.uci.edu/ml/index.php)

## Steps
1.Weak Learner Selection
Although the most general used weak learner of Adaboost is Decision Stump, which is a really weak prediction learner with slightly better 
preformance than random guess(50%), here I tried a mixed types of weak learner with relatively weak prediction ability. The types of 
candidates are: **Decision tree(cart, c4.5)**, **SVMLinear**, **PLS**, **KNN**, and along with their different parameter 
grids(10 for one type), generated 40 different weak learners(with different types and different parameters) for the first iteration. 

2.Implmentation of Adaboost
Following learning steps of Adaboost, in each learning iteration, each weak learner will learn the data separately and get their own weights and preformance, that means, 40 new weak learner with their own preformance(accuracy) and weights(
based on opposite of accuracy) will be generated, and weights of each data points is also changed according to the learning performance of this steps. Then after n iteration of learning, n\*40 different weak learners will be generated and constitute the solution space for GA.

3.Applying GA to find the best combination of weak learners
After done Adaboost learning, a solution space is generated for GA to do global search. I set the limitation of number of weak learner as no more than 25% of entire population(in my case, no exceed 10 weak learners in the final model).

4.Measurement and Evaluation
Using Classification Performance: Accuracy, Sensitivity, Specificity and Precision, Recall, F-1, etc on GAMixBoost, 
basic weak learner 

4.Comparing final results with existed ensemble models
Compared prediction results with Random Forest, Adaboost,  


