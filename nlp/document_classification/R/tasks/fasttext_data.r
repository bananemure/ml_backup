#!/usr/bin/Rscript
setwd('~/teradata/analysis/machine-learning/text-classification-nlp/')
library('data.table');library('stringi')
clean_data <- function(label_desc) {
  
  #remove all carriage return
  label_desc <- stri_replace_all_regex(label_desc,'\n|\r',' ')
  
  #rs_number
  label_desc <- stri_replace_all_regex(label_desc,'\\brs[[:digit:]]+','rs_number')
  #... """" \ [ ] <br />
  label_desc <- stri_replace_all_regex(label_desc,'\\.{2,}|\\<br /\\>|"|\\[|\\]|\\\\|;|:',' ')
  #’'
  label_desc <- stri_replace_all_regex(label_desc,"(’|'|\\,|\\(|\\)|\\?|!|#|/|\\-)"," $1 ")
  #lower case
  label_desc <- stri_trans_tolower(label_desc)
  #space
  label_desc <- stri_trim_both(label_desc)
  label_desc <- stri_replace_all_regex(label_desc,'\\p{Z}+',' ')
  
  return(label_desc)
  
}


#----supervised data ----------------

d_sup <- fread('~/teradata/analysis/machine-learning/text-classification-nlp/data/full/FULL_SUP.csv')
#d_sup[,label_desc:= .normalise(label_desc,nn = TRUE)]
#shuffle before saving
set.seed(1L); d_sup <- d_sup[sample(nrow(d_sup), nrow(d_sup),replace = FALSE),]
#add __tag__ sticker
d_sup[,tag:=stri_c('__tag__',tag)]

d_sup[,label_desc:=clean_data(label_desc)]

#- save file 
write.table(d_sup[,.(tag,label_desc)],file='~/teradata/analysis/machine-learning/text-classification-nlp/fasttext/data/sup_csv/mlstr.sup.csv',na = '',row.names = FALSE,fileEncoding = 'UTF-8',quote = FALSE,col.names = FALSE)
write.table(d_sup[,.(tag,label_desc)],file='~/teradata/analysis/machine-learning/text-classification-nlp/fasttext/data/mlstr.sup',na = '',row.names = FALSE,fileEncoding = 'UTF-8',quote = FALSE,col.names = FALSE)





#------- unsupervised data -----------

d_unsup <- fread('~/teradata/analysis/machine-learning/text-classification-nlp/data/full/FULL_UNSUP.csv')
d_unsup <- d_unsup[sample(nrow(d_unsup), nrow(d_unsup),replace = FALSE),]
d_unsup[,label_desc:=clean_data(label_desc)]

#- save file 
write.table(d_unsup[,.(label_desc)],file='~/teradata/analysis/machine-learning/text-classification-nlp/fasttext/data/sup_csv/mlstr.unsup.wv.csv',na = '',row.names = FALSE,fileEncoding = 'UTF-8',quote = FALSE,col.names = FALSE)
write.table(d_unsup[,.(label_desc)],file='~/teradata/analysis/machine-learning/text-classification-nlp/fasttext/data/mlstr.wv.unsup',na = '',row.names = FALSE,fileEncoding = 'UTF-8',quote = FALSE,col.names = FALSE)
