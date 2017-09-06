# -----------------------------------------------------------------------
#       CREATE AND INDEX CORPUS INTO A DOCUMENT FREQUENCY MATRIX (DFM)
#-----------------------------------------------------------------------
message(cat('-> Collapsing the tags column(s) into one column\n'))

#library('quanteda')
#Load the required functions and metadata
source('bow/indexer/indexer.r')



lkup <- fread('../../data/full/FULL_CLEANED.csv',stringsAsFactors = FALSE,colClasses = 'characters',verbose = TRUE)
#last cleaning
#lkup[,label_desc:=.normalise(label_desc)]


#now work with LOOKUP 
lkup <- lkup[!(tag==''),]

cat('\n-> Creating the corpus\n')


#--BUILD THE CORPUS
crpus <- quanteda::corpus(as.data.frame(lkup),textField='label_desc')

saveRDS(crpus,file = 'corpus/crpus.rds')


#==========================================#
#             BUILD DF_IDF  
#==========================================#

cat('\n-> Indexing the Docs-Features matrix\n')

#------------------------------------------------
cat('\n-> Build the text data to index\n')
lbl_txt <- quanteda::texts(lkup[,label_desc])
names(lbl_txt) <- lkup[,tag]
saveRDS(lbl_txt,file = 'corpus/lbl_txt.rds')

cat('\n-> Start indexing the Docs-Features matrix\n')
#-BUILD THE DFM SPARSE MATRIX
d_1g <- quanteda::dfm(lbl_txt,verbose=FALSE,removeNumbers =FALSE, removePunct=FALSE)
saveRDS(d_1g,file = 'bow/model/dfm/d_1g.rds')


d_2g <- quanteda::dfm(lbl_txt,verbose=FALSE,removeNumbers =FALSE, removePunct=FALSE,ngrams=1:2,skip=0)
saveRDS(d_2g,file = 'bow/model/dfm/d_2g.rds')


d_3g <- quanteda::dfm(lbl_txt,verbose=FALSE,removeNumbers =FALSE, removePunct=FALSE,ngrams=1:3,skip=0)
saveRDS(d_3g,file = 'bow/model/dfm/d_3g.rds')


cat('\n-> Weighting the term in Docs-Features matrix\n')
#-compute WEIGHTED DFM for all documents unigram
w_1g <- .weight.DFM.corpus(lbl_txt,removeNumbers =FALSE, removePunct=FALSE)
saveRDS(w_1g,file = 'bow/model/dfm/w_1g.rds')

################### N-GRAMS SKIPGRAMS########################

#-compute WEIGHTED DFM for all documents bi_gram 
w_2g <- .weight.DFM.corpus(lbl_txt,ngrams = 1:2,skip = 0,removeNumbers =FALSE, removePunct=FALSE)
saveRDS(w_2g,file = 'bow/model/dfm/w_2g.rds')


w_3g <- .weight.DFM.corpus(lbl_txt,ngrams = 1:3,skip = 0,removeNumbers =FALSE, removePunct=FALSE)
saveRDS(w_3g,file = 'bow/model/dfm/w_3g.rds')


# -------DOCUMENTS GROUPED BY TAG

lbl_by_tag <- quanteda::texts(lkup[,label_desc],group=lkup[,as.factor(tag)])
saveRDS(lbl_by_tag,file = 'corpus/lbl_by_tag.rds')


#---- adjust weight 



compute_w_cmb <- function(d_){
  
  categories <- unique(quanteda::docnames(d_))
  
  Mlist <- lapply(categories,function(x) 
  {
    pos <- which(quanteda::docnames(d_) %chin% x)
    Mpos <- d_[pos]
    boost <- Matrix::colSums(Mpos)
    
    t<-Matrix::t
    
    tMpos <- t(Mpos)
    tMpos@x <- tMpos@x * boost[tMpos@i+1]
    return(t(tMpos))
  }
  )
  
  d_cmb <- do.call(rbind,Mlist)
  
  return ( quanteda::tfidf(quanteda::tf(d_cmb,scheme = 'log')) )
}


cat('\n Adjusting [COMBINATION] Weight in index \n')
wc_1g <- compute_w_cmb(d_1g)
saveRDS(wc_1g,'bow/model/dfm/wc_1g.rds')

wc_2g <- compute_w_cmb(d_2g)
saveRDS(wc_2g,'bow/model/dfm/wc_2g.rds')

wc_3g <- compute_w_cmb(d_3g)
saveRDS(wc_3g,'bow/model/dfm/wc_3g.rds')

rm(crpus,lbl_by_tag,lbl_txt,d_1g,d_2g,d_3g,w_1g,w_2g,w_3g)




