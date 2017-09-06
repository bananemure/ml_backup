#!/usr/bin/Rscript
setwd('~/teradata/analysis/machine-learning/nlp/document_classification/')
library('data.table');library('stringi')



#---function ----

# --------cleaning function-----------------
clean_data <- function(label_desc) {
  
  #lower case
  label_desc <- stri_trans_tolower(label_desc)
  label_desc <- stri_replace_all_regex(label_desc,'\\bw\\/o','without ')
  label_desc <- stri_replace_all_regex(label_desc,'\\bw\\/','with ')
  label_desc <- stri_replace_all_regex(label_desc, "β",'beta')
  label_desc <- stri_replace_all_regex(label_desc, "α",'alpha')
  label_desc <- stri_replace_all_regex(label_desc, "μ", "mu")
  label_desc <- stri_replace_all_regex(label_desc, "\\bn/a\\b","not available")
  
  #weird character
  label_desc <- stri_replace_all_regex(label_desc,'…',' ')
  
  
  #remove all . decimal
  label_desc <- stri_replace_all_regex(label_desc,'(?<=[0-9]{1,3})\\.(?=[0-9]+)','')
  label_desc <- stri_replace_all_regex(label_desc,'(?<=[a-z]{1,3})\\.(?=[a-z]+)',' ')
  label_desc <- stri_replace_all_regex(label_desc,'\\,',' ')
  label_desc <- stri_replace_all_regex(label_desc,'\\(|\\)',' ')
  
  #remove all . betwen two letter
  label_desc <- stri_replace_all_regex(label_desc,'(?<=[0-9]{1,3})\\.(?=[0-9]+)','')
  
  #
  
  #remove nonsense code
  label_desc <- stri_replace_all_regex(label_desc,'^[a-z]+\\d+:','')
  label_desc <- stri_replace_all_regex(label_desc,'^[adeg-z][0-9]+([-a-z0-9_)]+)?|^[a-z]\\d+[a-z:]+(\\d+:)?','')
  label_desc <- stri_replace_all_regex(label_desc,'^\\d+[a-z]+-\\d+|^\\d+(?!(th|st|nd))[a-z]+','')
  label_desc <- stri_replace_all_regex(label_desc,'^\\d+-[a-z]+|\\d+[.][a-z]+|^\\d+[-:]\\d+([a-z]+)?','')
  #remove all carriage return
  label_desc <- stri_replace_all_regex(label_desc,'\n|\r',' ')
  
  #rs_number
  label_desc <- stri_replace_all_regex(label_desc,'\\brs\\p{N}+','rsids')
  
  #... """" \ [ ] <br />
  label_desc <- stri_replace_all_regex(label_desc,'(?<=[a-z]{1,3})/|/(?=[a-z]+)| / ',' ')
  
  label_desc <- stri_replace_all_regex(label_desc,'“|”|\\.{2,}|_|\\<br /\\>|"|\\\\|\\={3,}',' ')
  label_desc <- stri_replace_all_regex(label_desc,"\\.|\\.$|’|'|!|#|\\-|;|:|\\[|\\]", " ")
  #’'
  label_desc <- stri_replace_all_regex(label_desc,"(\\?|\\>|\\<|\\=|\\+|\\*|%|\\^)"," $1 ")
  
  
  #remove trailing number
  label_desc <- stri_trim_both(label_desc)
  label_desc <- stri_replace_all_regex(label_desc,'^\\d+\\b','')
  label_desc <- stri_replace_all_regex(label_desc,'(\\b\\d+\\b)','_num_')
  
  #space
  label_desc <- stri_trim_both(label_desc)
  label_desc <- stri_replace_all_regex(label_desc,'\\p{Z}+',' ')
  
  #final _num_ regrouping
  label_desc <- stri_replace_all_regex(label_desc,'_num_ (?=_num_)','')
  
  return(label_desc)
  
}




#----supervised data ----------------

d_sup <- fread('~/teradata/analysis/machine-learning/nlp/data/full/FULL_SUP.csv')
#shuffle before saving
set.seed(1L); d_sup <- d_sup[sample(nrow(d_sup), nrow(d_sup),replace = FALSE),]

#lower tag
d_sup[,tag:=stri_trans_tolower(tag)]
d_sup[,tag:=stri_c('tag_',tag)]
d_sup[,label_desc:=clean_data(label_desc)]

# add space before text and after tag
#d_sup[,label_desc:= stri_c(' ',label_desc)]


#------ split train - test -validation --------
# n <- d_sup[,.N]
fwrite(d_sup[ 1 : round(d_sup[,.N]*.1 -1)   ,.(tag,label_desc) ],file='FT/data/mlstr.test',na = '',row.names = FALSE,col.names = FALSE,sep = '\t')
fwrite(d_sup[ round(d_sup[,.N]*.1) : round(d_sup[,.N]*.2 -1)   ,.(tag,label_desc) ],file='FT/data/mlstr.validation',na = '',row.names = FALSE,col.names = FALSE,sep = '\t')
fwrite(d_sup[ round(d_sup[,.N]*.2) : round(d_sup[,.N])   ,.(tag,label_desc) ],file='FT/data/mlstr.train',na = '',row.names = FALSE,col.names = FALSE,sep = '\t')

fwrite(d_sup[ ,.(tag,label_desc) ],file='FT/data/mlstr.all',na = '',row.names = FALSE,col.names = FALSE,sep = '\t')

#- save file 
fwrite(d_sup[ ,.(tag,label_desc) ],file='FT/data/sup_csv/mlstr.sup.csv',na = '',row.names = FALSE,col.names = FALSE)



