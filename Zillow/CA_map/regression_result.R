rm(list=ls())
load("/home/ye/Desktop/DS501-3/bittigerds501-1703/CodeLab/Week3/CA_map/CleanTrain.Rdata")
source("/home/ye/Desktop/DS501-3/bittigerds501-1703/CodeLab/Week3/CA_map/regionlm.R")

neighbor = unique(train$region_neighbor[!is.na(train$region_neighbor)])
s = 0
cv.mse = list()
for(i in neighbor){
  #print(i)
  print(s)
  reg = train[which(train$region_neighbor == i), ]
  if(nrow(reg) > 40)
  {
    m = region.lm(reg)
    #print(i)
    #print(m$glmnet.fit$dev.ratio[which(m$glmnet.fit$lambda == m$lambda.min)])
  }
  else{m = NA}
  cv.mse[i] <- list(m)
}

save(cv.mse, file = "/home/ye/Desktop/DS501-3/bittigerds501-1703/CodeLab/Week3/CA_map/cv_mse.Rdata")
