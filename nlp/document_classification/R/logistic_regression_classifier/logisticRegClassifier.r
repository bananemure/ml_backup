require(SparseM); require(quanteda);require(LiblineaR)
#load the tfidf doc term matrix
w_ <- readRDS('bow/model/dfm/w_bi.rds')
X_FULL <- as(w_,'matrix.csr')
Y_FULL <- factor(docnames(w_))



# FULL LEARNING 
system.time( m_full <- LiblineaR(data=X_FULL, target=Y_FULL ,type=7, cost=1, bias=TRUE, verbose=TRUE) )





#len <- nrow(w_bi)
#set.seed(7)
#ridx <- sample(len,len,FALSE)
#xd_ <- as(w_bi[ridx[1:round(len*.8)] ], 'matrix.csr')
#yd_ <- factor ( docnames(w_bi) )[ridx[1:round(len*.8)]]

#t_ <- as(w_bi[ridx[(round(len*.8)+1) : round(len*.9)] ] , 'matrix.csr')
#yt_ <- factor ( docnames(w_bi) )[ ridx[(round(len*.8)+1) : round(len*.9)] ] 

#v_ <- as(w_bi[ridx[(round(len*.9)+1) : len], ] , 'matrix.csr')
#yv_ <- factor ( docnames(w_bi) )[ ridx[(round(len*.9)+1) : len] ] 


#m=LiblineaR(data=xd_,target=yd_,type=0,cost=1,bias=TRUE,verbose=TRUE)


#  -------------show prediction for model0---------------
#p_t=predict(m,t_,proba=TRUE,decisionValues=TRUE)
#p_v=predict(m,v_,proba=TRUE,decisionValues=TRUE)
# Display confusion matrix
#res_t=table(p_t$predictions,yt_)
#sum(diag(res_t)) / sum(res_t)

#res_v=table(p_v$predictions,yv_)
#sum(diag(res_v)) / sum(res_v)



#  -------------show prediction for model 7---------------
p_ <- predict(m_full,X_FULL,proba=TRUE,decisionValues=TRUE)
#p_v7=predict(m7,v_,proba=TRUE,decisionValues=TRUE)
# Display confusion matrix
res_=table(p_$predictions,Y_FULL)
sum(diag(res_)) / sum(res_)

#res_v7=table(p_v7$predictions,yv_)
#sum(diag(res_v7)) / sum(res_v7)