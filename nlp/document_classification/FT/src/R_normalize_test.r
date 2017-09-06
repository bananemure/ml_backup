#!/usr/bin/Rscript

suppressPackageStartupMessages(library(argparser))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(stringi))


p <- arg_parser('Normalise csv file to fasttext')
p <- add_argument(p,c("--input", "--output"),help = c("input file", "output file"),short = c('-i','-o') )

argv <- parse_args(p)

if (anyNA(c(argv$input,argv$output))) {
  print(p)
  #cat('\n')
  stop('Missing argument[s]',call. = FALSE)
}



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
  label_desc <- stri_replace_all_regex(label_desc,'_num_',' ')
  
  #space
  label_desc <- stri_trim_both(label_desc)
  label_desc <- stri_replace_all_regex(label_desc,'\\p{Z}+',' ')
  
  return(label_desc)
  
}

#read data
csvfile <- argv$input


if(file.exists(csvfile)){
  
  #raw set 
  d_ <- fread(csvfile,colClasses = 'characters')
  
  setnames(d_,if(NCOL(d_)==2){c('tag','label_desc')}else{'label_desc'})
  #lower tag
  if(NCOL(d_) == 2 ) d_[,tag:=stri_trans_tolower(tag)][,tag:=stri_c('tag_',tag)]
  d_[,label_desc:=clean_data(label_desc)]
  fwrite(d_,file = argv$output,row.names = FALSE,col.names = FALSE,sep = '\t')
  
}else{
  cat(paste0('\nfile ',csvfile,' not found\n'))
  print(p)
}

