# #load train data
# load("/home/ye/Desktop/codelab/zillow/correct_train.Rdata")
# train$X <- NULL
# train$abs_logerror <- NULL
# 
# # fill flag na with 0
# train[which(is.na(train$flag_tub)), "flag_tub"] = 0
# train[which(is.na(train$flag_spa)), "flag_spa"] = 0
# train[which(is.na(train$flag_pool_spa)), "flag_pool_spa"] = 0
# train[which(is.na(train$flag_pool_tub)), "flag_pool_tub"] = 0
# train[which(is.na(train$flag_fireplace)), "flag_fireplace"] = 0
# 
# # area_total_finished area_live_finished seems backup each other
# train$area_finished = train$area_total_finished + train$area_live_finished
# train$area_total_finished <- NULL
# train$area_live_finished <- NULL
# #binning build year
# build_year = as.integer(train$build_year)
# build_year_bin = cut(build_year,
#         c(min(build_year, na.rm = T),
#           1900, 1920, 1930, 1940,
#           1950, 1960, 1970, 1980, 1990, 2000,
#           max(build_year, na.rm=T)), include.lowest=TRUE)
# train$build_year = build_year_bin
# 
# # standardize data
# # https://stats.stackexchange.com/questions/29781/when-conducting-multiple-regression-when-should-you-center-your-predictor-varia
# 
# # remove all date related value
# train$trans_date <- NULL
# train$trans_DATE <- NULL
# train$trans_day <- NULL
# train$trans_month <- NULL
# train$trans_weekday <- NULL
# train$trans_year <- NULL
# 
# # fill num_pool NA with 0, drop flag_poop_tub
# train[which(is.na(train$num_pool)), "num_pool"] = 0
# train$flag_pool_tub <- NULL
# 
# 
# # combine heating and aircon, will NA with 0
# train[which(is.na(train$aircon)), "aircon"] = "0"
# train[which(is.na(train$heating)), "heating"] = "0"
# train$heating = as.character(as.integer(train$heating) + as.integer(train$aircon))
# train$aircon <- NULL
# train$num_bathroom_calc <- NULL
# train$num_bathroom <- NULL
# 
# # save train
# save(train, file = "/home/ye/Desktop/codelab/zillow/CleanTrain.Rdata")

#sapply(reg, function(x){length(unique(x))})

region.lm <- function(reg){
  #reg = train[which(train$region_neighbor == "274049"), ]
  # deal with outlier
  reg = reg[which(!reg$logerror %in% boxplot.stats(reg$logerror)$out), ]
  na.features = names(which(colSums(is.na(reg)) < 0.5*dim(reg)[1]))
  reg = reg[,na.features]
  
  # drop uni-value column
  multi_value = sapply(reg,
                       function(x){
                         return(!length(unique(x[!is.na(x)])) == 1)})
  if(length(multi_value)!=0)
    reg = reg[, names(which(multi_value))]
  
  # fill numerical na with mice
  # https://stats.stackexchange.com/questions/219013/how-do-the-number-of-imputations-the-maximum-iterations-affect-accuracy-in-mul
  
  library(mice)
  
  # impute numeric variable
  num.col = names(which(sapply(reg, is.numeric)))
  reg.num = reg[,num.col]
  if(sum(is.na(reg.num))!=0){
    reg.num.complete = complete(mice(reg.num, method = "cart", printFlag = F), 1)
    reg[,num.col] = reg.num.complete
  }
  reg = na.omit(reg)
  reg[,num.col]=scale(reg[,num.col])
  reg = reg[,colSums(is.na(reg))<nrow(reg)]
  
  # drop uni-value column again
  multi_value = sapply(reg,
                       function(x){
                         return(!length(unique(x[!is.na(x)])) == 1)})
  if(length(multi_value)!=0)
    reg = reg[, names(which(multi_value))]
  
  library(glmnet)
  dep = reg$logerror
  ind = model.matrix(~.-1, reg[, -c(1,2)])
  cvfit <- cv.glmnet(ind, dep)
  lmin = cvfit$lambda.min
  #pred = predict(cvfit,newx=ind,type="response",s="lambda.min")
  return(cvfit)
}

