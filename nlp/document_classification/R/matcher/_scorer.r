
#-------------------------------------------------------------------------------------------------
#                         USE QUANTEDA FOR FIRST RANKING: IT'S FAST AND MATURE 
#-------------------------------------------------------------------------------------------------


.map_feature <- function (dfma, dfmb) 
{
  feat_a <- features(dfma)
  feat_b <- features(dfmb)
  
  featIdx <- which(feat_a %in% feat_b)
  
  # remove features in x that are not in features (from supplied dfmb)
  dfma2 <- dfma[, featIdx]; feat_a2 <- features(dfma2)
  
  # now add zero-valued features of dfmab that are not in dfma2 but are in features
  featIdx_b_not_a2 <- which(!(feat_b %in% feat_a2))
  #xOriginalFeatureLength <- nfeature(x2)
  
  x <- new("dfmSparse", Matrix::cbind2(dfma2,
                                       Matrix::sparseMatrix(i = NULL, j = NULL, dims = c(ndoc(dfma2), length(featIdx_b_not_a2)), 
                                                            dimnames = list(docnames(dfma2), feat_b[featIdx_b_not_a2]))))
  #featIndex <- match(features_dfm, features(x))
  # x <- x2 #[, features_dfm]
  x[,feat_b]
}




#Require processor
source('bow/indexer/normalizer.R')


#general
#this function is needed because skip-gram sometimes return character(0)
.isvalidtext <- function(x)
{
  stri_trim_both(x) != '' & !is.na(x) 
}


#
##find index of query token within the features
#take a tokenized query and return his weight ready for use within a dfmSparseMatrix to build a querySparceMatrix
#return a weight vector for a query ex: 1 0 1 0 0 0 0 1 0 0 1 .....

.quanteda.querySparseMatrix <- function(query_label,dfmSparseMatrix,stem=T,typo=F,ngrams=1:2,skip=0) 
{
  plabel <- .normalise(query_label,nn = FALSE)
  if(.isvalidtext(plabel)) {
    
    #get query vector
    qdfm <- dfm(plabel,removeNumbers=F,removePunct=F,removeSeparators=T,verbose=F,stem=F,ngrams=ngrams,skip=skip)
    rownames(qdfm) <- 'query'
    
    if ( sum(features(dfmSparseMatrix) %in% features(qdfm)) ) {
      qsparseMatrix <- rbind(qdfm,dfmSparseMatrix)
    }else{
      qsparseMatrix <- NA
    }
   
    return(qsparseMatrix)
    
  }else{
    
    return (NA)
  }
  #TODO: typo
}



#
#take a querysparseMatrix and compute cosine similarity then return result.
# For now only the ten best results are returned 
# those scores need to be processed in further steps
# the querySparseMatrix is then deleted in mem

.quanteda.matcher <- function(querySparseMatrix,Ncandidate=5)
{
  result <- if(is(querySparseMatrix,'dfm')){
    quanteda::similarity(querySparseMatrix,'query',n=Ncandidate, method = 'cosine')[[1]]*100
  }else{
    c(notag=0)
  }
  return(round(result))
}



#----------------------------------------------
# LOOP OVER ALL VARIABLE LABELS IN A TEST SET
#-----------------------------------------------

.quanteda.scorer <- function(query_labels,dfmSparseMatrix, Ncandidate=5,stem=T,typo=F,ngrams=1:2,skip=0) 
{
  if(!is.character(query_labels)) stop('query should be a character type ',call. = F)
  if(!is(dfmSparseMatrix,'dfmSparse')) stop ('index matrix should be a sparse matrix of dfmSparse type',call. = F)
 label <- query_labels
  QSPARSE <- .quanteda.querySparseMatrix(label,dfmSparseMatrix,stem,typo,ngrams,skip) 
  score <- .quanteda.matcher(QSPARSE,Ncandidate)
  score
}


