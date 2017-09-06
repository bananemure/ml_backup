
library(LiblineaR)

yTrain = factor(docnames(W))
# Find the best model with the best cost parameter via 10-fold cross-validations
tryTypes=c(0:7)
tryCosts=c(1000,1,0.001)
bestCost=NA
bestAcc=0
bestType=NA

for(ty in tryTypes){
  for(co in tryCosts){
    acc=LiblineaR(data=w2,target=yTrain,type=ty,cost=co,bias=TRUE,cross=5,verbose=FALSE)
    cat("Results for C=",co," : ",acc," accuracy.\n",sep="")
    if(acc>bestAcc){
      bestCost=co
      bestAcc=acc
      bestType=ty
    }
  }
}


cat("Best model type is:",bestType,"\n")
cat("Best cost is:",bestCost,"\n")
cat("Best accuracy is:",bestAcc,"\n")








#train with the best hyperparam: logistic L2 regularization with cost of 1
m=LiblineaR(data=w2,target=yTrain,type=bestType,cost=bestCost,bias=TRUE,verbose=TRUE)

#compute the prediction
p=predict(m,w2,proba=TRUE,decisionValues=TRUE)

#compute confusion matrix for training
res <- table(p$predictions,yTrain)
#compute Balanced Classification Rate for the 1206 classes
do.call ( mean, lapply(1:1206,function(x) res[x,x]/sum(res[,x])) ) 


