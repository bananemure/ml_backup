W <- readRDS('bow/model/dfm/WDFM_TAG_ENG.rds')
wcnosw <- readRDS('bow/model/dfm/Wcomb.rds')
class_name <- paste0(docnames(W),'_related')


#find 50 topfeatures from doc_matrix and group_matrix
feat1 <- sapply(docnames(W),function(x) names(topfeatures(W[which(docnames(W) == x)],30)),simplify = FALSE) 
feat2 <- sapply(docnames(W),function(x) names(topfeatures(wcnosw[which(docnames(wcnosw) == x)],30)),simplify = FALSE) 

feat_all <- sapply(docnames(W),function(x) unique( c ( feat1[[x]],feat2[[x]] ))   ,simplify = FALSE)

source('keywords/synonym.R')
K <- do.call(.cbind.na,feat_all)
write.csv(K,file = 'keywords/keyword_candidate.csv',na = '',row.names = FALSE)