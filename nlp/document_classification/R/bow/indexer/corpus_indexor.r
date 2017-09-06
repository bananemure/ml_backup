# -----------------------------------------------------------------------
#  FUNCTIONALITIES TO CREATE AND INDEX A CORPUS IN
#-----------------------------------------------------------------------



#
# Compute the weight by groups( ex class )
#It return TFIDF sparse matrix
# skip only applies when ngrams >1
.weight.DFM.group <- function(group,corpus,stem=FALSE,ngrams=1,skip=0,minDoc=1,...)
{
 .weight.DFM.corpus(corpus,group = group,stem=stem,ngrams=ngrams,skip=skip,minDoc=minDoc,...)
  
}

#
# Default weight computation
#Return a TFIDF sparse matrix
#skip only applies when ngrams>1
.weight.DFM.corpus <-  function(corpus,group = NULL,stem=FALSE,ngrams=1,skip=0,minDoc=1,...)
{
  
  k <- if(is.null(group)){
      z <- quanteda::dfm(corpus,verbose = FALSE,stem=stem,ngrams=ngrams,skip=skip,...)
      z <- quanteda::tf(z,scheme = 'log')
      z <- if(minDoc>1) {trim(z,minDoc = minDoc)}else {z}
  }else{ 
    z<-quanteda::dfm(corpus,group=group,verbose = FALSE,stem=stem,ngrams=ngrams,skip=skip,...)
    z <- if(minDoc>1) {quanteda::trim(z,minDoc = minDoc)}else {z}
  }
  
  #head(klogTfdtm <- quanteda::weight(k,type='logFreq'),10)
  head(klogTfdtm <- quanteda::tfidf(k,normalize=FALSE),20,25)
  return(klogTfdtm)
  

}



#-----------------------------------------------------------------------------------
#
#   recompute the weight by weighting based on class representation (not doc level)
#------------------------------------------------------------------------------------


# TODO




#-------------------------------------------------------------------------------
#
#   take all labels for a group and construct set of sentences separted by "\n"
#-------------------------------------------------------------------------------

.texts.group <- function(x, groups = NULL, ...) {
  if (is.null(groups)) return(x)
  if (!is.factor(groups)) stop("groups must be a factor")
  x <- split(x, groups)
  sapply(x, paste, collapse = "\n\r")
}



