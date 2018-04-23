# for the distributions
# d stands for density, p stands for cdf, q(cdf) finds the value x with cdf,
# r stands for generating random variable following dist
rnorm(n = 10)
plot(density(rnorm(n=100000)))
dnorm(x = 0)
pnorm(q = 0) # returns cdf
qnorm(p = 0.975) # returns z score for type 1 error 0.05; qnorm(p = 0.5)  

# similar functions
# http://www.cyclismo.org/tutorial/R/probability.html
dt()
pt()
qt()
rt()

train <- read.csv('train_property.csv', stringsAsFactors = F)
# check how many NAs in each feature
num.NA <- sort(colSums(sapply(train, is.na)))
# sort(sapply(train, function(x) {sum(is.na(x))}), decreasing=TRUE)
remain.col <- names(num.NA)[which(num.NA <= 0.2 * dim(train)[1])] # trainT = train
train <- train[, remain.col]

# Data exploration
# First check each feature and features with relationship with each other
# Take bathroomcnt, bedroomcnt and roomcnt for example
summary(train$bathroomcnt)
summary(train$bedroomcnt)
summary(train$roomcnt)
with(train, plot(bathroomcnt + bedroomcnt, roomcnt))
# Why there are so many house with roomcnt smaller than bath + bed?
# Assumption: error in data
boxplot(subset(train, roomcnt < bathroomcnt + bedroomcnt)$logerror,
        subset(train, roomcnt >= bathroomcnt + bedroomcnt)$logerror)
quantile(abs(train$logerror), 0.9)
boxplot(subset(train, roomcnt < bathroomcnt + bedroomcnt & abs(logerror) < 0.145)$logerror,
        subset(train, roomcnt >= bathroomcnt + bedroomcnt & abs(logerror) < 0.145)$logerror)
boxplot(abs(subset(train, roomcnt < bathroomcnt + bedroomcnt & abs(logerror) < 0.145)$logerror),
        abs(subset(train, roomcnt >= bathroomcnt + bedroomcnt & abs(logerror) < 0.145)$logerror))
with(train, t.test(logerror ~ (roomcnt < bathroomcnt + bedroomcnt)))
with(train, t.test(abs(logerror) ~ (roomcnt < bathroomcnt + bedroomcnt)))

# understand t.test
# t.test(x, y = NULL, alternative = c("two.sided", "less", "greater"), 
# mu = 0, paired = FALSE, var.equal = FALSE, conf.level = 0.95, ...)
# Welch t-test (var.equal = FALSE) and student t-test(var.equal = TRUE)
correct.rmcnt <- subset(train, roomcnt >= bathroomcnt + bedroomcnt)
wrong.rmcnt <- subset(train, roomcnt < bathroomcnt + bedroomcnt)
train$logerror.abs <- abs(train$logerror)
stderr <- sqrt(var(correct.rmcnt$logerror.abs) / dim(correct.rmcnt)[1] +
                 var(wrong.rmcnt$logerror.abs) / dim(wrong.rmcnt)[1])
t.score <- (mean(correct.rmcnt$logerror.abs) - mean(wrong.rmcnt$logerror.abs)) / stderr
p.val <- 2 * (1 - pt(t.score, df = 32425))
2 * (1 - pnorm(t.score)) # compares with normal distribtion

# For category variables
# (1) if level is not too many, we can use bar chart to check the difference first
#     and then use t test to compare. Take fip for example. 

table(train$fips)
str(train$fips)
library(lattice)
train$fips <- as.character(train$fips)
error.fip = by(train, train$fip, function(x) {
  return(mean(x$logerror))})

with(train, t.test(logerror ~ (fips == '6111')))
# 6037 Los Angeles
# 6059 Orange County
# 6111 Ventura County

hs.not.6111 <- subset(train, fips != '6111')
hs.6111 <- subset(train, fips == '6111')
stderr <- sqrt(var(hs.6111$logerror) / dim(hs.6111)[1] +
       var(hs.not.6111$logerror) / dim(hs.not.6111)[1])
t.score <- (mean(hs.not.6111$logerror) - mean(hs.6111$logerror)) / stderr

# if we use pooled variance
with(train, t.test(logerror ~ (fips == '6111')), var.equal = TRUE)
n1 <- dim(hs.6111)[1]
n2 <- dim(hs.not.6111)[1]
pooled.stderr <- sqrt((var(hs.6111$logerror) * (n1 - 1) +
                 var(hs.not.6111$logerror) * (n2 - 1))
                 / (n1 + n2 - 2)) * sqrt(1/n1 + 1/n2)
# a bit larger than stderr. 
# pooled.stderr^2 - stderr^2 = (s2^2 - s1^2) (n2 - n1) / (n1 + n2 - 2)
# with(train, anova(lm(logerror ~ fips)))

# Now think about why 6111 have larger logerror, maybe we have too few data points
num.fip <- by(train, train$fips, function(x){
  return(length(unique(x$parcelid)))})
train$num.fip <- num.fip[train$fips]
# conclusion, we should include boolean feature indicating whether fips = 6111.
# Also if other feature having level with sparse data, we should expect large log.error.

# (2) if category variables has too many levels, Take regionidcity for example.
# Disadvantage of using such variable as it is.
# Find similar levels and collapse them, how to find similar level though?
table(train$regionidzip)
train$regionidzip <- as.character(train$regionidzip)
error.zip <- by(train, train$regionidzip, function(x) {
  return(mean(x$logerror))
})
plot(density(error.zip))
train$error.zip <- error.zip[train$regionidzip]
summary(train$error.zip) # seeing NA due to regionidzip is NA. 
# How to impute
# Set up new level, find per region city what's most likely zip code and
# more advanced imputation, like libarry(mice)

summary(lm(logerror ~ regionidzip, train))
summary(lm(logerror ~ error.zip, train))

train$regionidzip.new <- ifelse(train$error.zip < quantile(error.zip, 0.05), '1',
                                ifelse(train$error.zip < quantile(error.zip, 0.95), '2', '3'))
                                     #  ifelse(train$error.zip < quantile(error.zip, 0.75), '3', '4')))
summary(lm(logerror ~ regionidzip.new, train))

# check these extreme cases and find out they also have relative sparse data.
error.zip[which(error.zip < -0.1)] # 96226
error.zip[which(error.zip > 0.1)]
dim(subset(train, regionidzip == 96226))

# Assumption: few number of houses for certain region id zip caused logerror large.
# How to verify
num.zip <- by(train, train$regionidzip, function(x) {
  return(dim(x)[1])})
train$num.zip = num.zip[train$regionidzip]
with(train, cor(logerror, num.zip, use = 'pairwise.complete.obs'))
with(train, cor(abs(logerror), num.zip, use = 'pairwise.complete.obs'))

# Continuous variables, take tax amount for example
# taxvaluedollarcnt: value to be taxed
# structuretaxvaluedollarcnt: value to be taxed from structure
# landtaxvaluedollarcnt: value to be taxed from land
# taxamount: actual paid tax
with(train, plot(structuretaxvaluedollarcnt + landtaxvaluedollarcnt, taxvaluedollarcnt))

summary(with(train, taxamount/taxvaluedollarcnt))

with(train, plot(taxamount/taxvaluedollarcnt, logerror))
with(subset(train,taxamount/taxvaluedollarcnt <= 0.1),
     plot(taxamount/taxvaluedollarcnt, logerror))
with(subset(train,taxamount/taxvaluedollarcnt <= 0.1), 
     cor(logerror, taxamount/taxvaluedollarcnt, use = 'pairwise.complete.obs')) #-0.04
with(subset(train,taxamount/taxvaluedollarcnt <= 0.1), 
     cor(logerror, taxamount, use = 'pairwise.complete.obs')) # -0.004
with(subset(train,taxamount/taxvaluedollarcnt <= 0.1), 
     cor(logerror, taxvaluedollarcnt, use = 'pairwise.complete.obs')) # 0.004

train$living.per <- with(train, calculatedfinishedsquarefeet/lotsizesquarefeet)
with(train, cor(logerror, calculatedfinishedsquarefeet, use = 'pairwise.complete.obs'))
with(train, cor(logerror, lotsizesquarefeet, use = 'pairwise.complete.obs'))
with(train, cor(logerror, calculatedfinishedsquarefeet/lotsizesquarefeet,
                use = 'pairwise.complete.obs'))

