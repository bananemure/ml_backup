
suppressPackageStartupMessages(library(argparser))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(stringi))

.load_csv <- function (dir_,csvname, sep=',',verbose=FALSE,...)
{
  if(missing(dir_)) stop('path is required: Add the name of directory path',call. = FALSE)
  if (missing(csvname)) stop('csvname is require: Add the name of csv file',call. = FALSE)
  csvfile <- file.path(dir_,csvname)
  if(verbose) message(cat(paste0('LOADING THE CSV: ',csvfile)))
  
  dt <- fread(input = csvfile,sep = sep,header = TRUE,colClasses = 'characters')
  return(dt)
}



.save_csv <- function (dataToSave,saveLocation,csvname,verbose=FALSE,...)
{
  if(missing(dataToSave)) stop('dataToSave is required: Add the name of data object to save',call. = FALSE)
  if (missing(csvname)) stop('csvname is require: Add the final name of csv file that will be saved',call. = FALSE)
  if(missing(saveLocation)) stop('csvLocation is required: Add the name of location directory for the saved file',call. = FALSE)
  
  where <- file.path(saveLocation , csvname)
  
  if(verbose) message(cat(paste0('\nSAVING THE CSV TO: ',where)))
  write.csv(dataToSave,file=where,na = '',row.names = FALSE)
  
}


.collapse_col <- function (dataset, what_regex = "Mlstr_area", to_what = "TAG_HUMAN") 
{
  if (!any(grepl(what_regex, names(dataset)))) 
    return(setDT(dataset))
  datacopy <- copy(dataset)
  setDF(datacopy)
  datacopy[is.na(dataset)] <- ""
  setDT(datacopy)
  VL <- datacopy[, do.call(stri_paste, c(.SD, sep = " ")), 
                 .SDcols = grep(what_regex, names(datacopy))]
  set(datacopy, j = to_what, value = VL)
  return(datacopy)
}


.tag_processor <- function (tag) 
{
  k <- stri_split_fixed(tag, pattern = " ")
  ksort <- vapply(k, function(x) stri_c(stri_sort(x), collapse = " "), 
                  FUN.VALUE = "a")
  tag = stri_trim_both(ksort)
  tag = stri_replace_all_regex(tag, "\\p{WHITE_SPACE}+", "||")
  return(tag)
}



.get_predict <- function(dat_, dtname='dt_ft') {
  
  ogfile <- dat_
  
  setDT(ogfile);setnames(ogfile,c('tag_human','label'));ogfile[,tag_human:=stri_trans_tolower(tag_human)];ogfile[,status:='bad']
  result <- read.table(paste0('fasttext/predict/',dtname,'.predict'))
  setDT(result); setnames(result,c('tag1','prob1','tag2','prob2','tag3','prob3','tag4','prob4','tag5','prob5'));setcolorder(result,c('prob1','tag1','prob2','tag2','prob3','tag3','prob4','tag4','prob5','tag5'))
  result[,tag1:=stri_replace_all_fixed(tag1,'tag_','')][,tag2:=stri_replace_all_fixed(tag2,'tag_','')][,tag3:=stri_replace_all_fixed(tag3,'tag_','')][,tag4:=stri_replace_all_fixed(tag4,'tag_','')][,tag5:=stri_replace_all_fixed(tag5,'tag_','')]
  result[,prob1:=round(prob1*100,1)][,prob2:=round(prob2*100,1)][,prob3:=round(prob3*100,1)][,prob4:=round(prob4*100,1)][,prob5:=round(prob5*100,1)]
  sapply(1:5,function(k) {probi <- paste0('prob',k); tagi = paste0('tag',k); set(result,i= which(result[[probi]] == 0),j=which(names(result)==tagi),value = '' ) } )
  
  #get status
  ogfile[ogfile[,tag_human]==result[,tag1],status:='good']
  
  cbind(ogfile,result)
}


.do_fasttext <- function(input_csv,dir_) {
  
  
  dt_ <- .load_csv(dir_, csvname =input_csv ,separator = ',',verbose = TRUE)
  input_prefix <- sub('.csv','',input_csv,fixed = TRUE)
  
  dt_ft <- copy(dt_)
  #collapse and process tag and save it for system bash
  dt_ft <- .collapse_col(dt_ft,to_what = 'tag')
  dt_ft[,tag:= .tag_processor(tag)]
  
  #remove any previous dt_ft.csv
  unlink(csv_file <- file.path('fasttext/data/sup_csv',input_csv) )
  #write new dt_ft.csv
  write.csv(dt_ft[,.(tag,`label:en`)],file = csv_file , row.names = FALSE,quote = TRUE)
  
  #system bash use the saved dt_ft csv and clean and predict based on the model
  cmd <- paste0('bash fasttext/src/clean_predictML.sh ',input_prefix,' >> fasttext/fasttext_log.txt' )
  system(cmd,ignore.stderr = TRUE)
  unlink(csv_file) ; unlink(paste0('fasttext/data/',input_prefix,'.query'))
  
  xx <- .get_predict( dt_ft[,.(tag,`label:en`)] ,dtname = input_prefix )
  
  cat(date(),'\n')
  list( finalpred = cbind(dt_ , xx)  ,  perc_= round(xx[status=='good',.N]*100/xx[,.N],2) )
}


