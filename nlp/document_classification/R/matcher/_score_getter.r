# ----------------------------------------
#   FUN TO EXTRACT TAGS AND SCORES
#-----------------------------------------

#Require the hash result of similarity search
#Require the raw label to associate the result
#Require the LOOKUP TABLE: LOOKUP
#LOOKUP <- data.table::fread('../../data/lookup/LOOKUP.csv',na.strings = '',colClasses = 'characters',verbose = F)



#--------------------------
#majority vote the best tag 
#--------------------------
.votescore <- function (scores) 
{
  
  z <- exp(scores)
  #z <- z[z>50]
  
  sumz <- sum(z)
  
  if (sumz == 0) {
    return (scores[1])
  }
   sort( round( sapply(unique(names(z)),function(x) sum(z[which(names(z)==x)])/sumz*100) ) , decreasing = TRUE )
  
}




#query_labels = label of the test dataset
#dfmSparseMatrx = dfm sparse matrix
#LOOKUP = Lookup table to fetch metadata from
#Ncandidate = number(default to 5) of best candidate to display
.show_score <- function (query_labels,dfmSparseMatrix,Ncandidate=5,typo=F,ngrams=1,skip=0,verbose=TRUE)
{
  message(cat('\n-> Search for domains of informations in progress...\n- Please do not interrupt! ... ... ...'))
  
  res <- NULL
  counter <- 0 #init
  max_count <- length(query_labels)
  for (label in query_labels) {
    if (verbose ){
      count_perc <- round((100*(counter <- counter+1))/max_count,2)
      cat('\r',paste0(' |--->> ', count_perc, ' % '),append = TRUE)
    }
    QS <- .quanteda.scorer(label,dfmSparseMatrix,Ncandidate,stem = TRUE,typo,ngrams,skip)
    
    
    #reorder QS by consensus Vote for qs
    
    tag_score <- if(Ncandidate) { .votescore(QS [[ label ]]) }else { QS[[ label ]] }
    
    
    tag_name <- names(tag_score)
    
    tags_DT <- data.table::data.table(SCORE=tag_score,TAG_FOUND=tag_name)
    
    tags_DT[SCORE==0,TAG_FOUND:=NA]
    
    #sort score by descending order
    setorder(tags_DT,-SCORE) 
    #add to the growing list
    res <- c(res,list(tags_DT))
  }
  names(res) <- query_labels
  message(cat('\n\t\t\t\t==============    **Search is completed**    ==================='))
  
  return(res)
}







#====== V2 for LSA dfm ================


#query_labels = label of the test dataset
#dfmSparseMatrx = dfm sparse matrix
#LOOKUP = Lookup table to fetch metadata from
#Ncandidate = number(default to 5) of best candidate to display
.show_score2 <- function (query_labels,dfmDenseMatrix,Ncandidate=10)
{
  message(cat('\n-> Search for domains of informations in progress...\n- Please do not interrupt! ... ... ...'))
  
  
  #data.table::setkey(LOOKUP,ID_TEXT)
  res <- NULL
  for (label in query_labels) {
    message(cat(paste0(label,' >> ')),appendLF = F)
    sim_res <- .lsa.scorer(label,dfmDenseMatrix,Ncandidate)
    
    #tag_score <- sim_res[[ label ]]
    
    tag_score <- if(Ncandidate) { .votescore(sim_res[[ label ]]) }else { sim_res[[ label ]] }
    
    tag_name <- names(tag_score)
    
    tags_DT <- data.table::data.table(SCORE=tag_score,TAG_FOUND=tag_name)
    
    
    #change metadata name
    
    
    tags_DT[SCORE==0,TAG_FOUND:=NA]
    
    #sort score by descending order
    setorder(tags_DT,-SCORE) 
    #add to the growing list
    res <- c(res,list(tags_DT))
  }
  names(res) <- query_labels
  message(cat('\n\t\t\t\t==============    **Search is completed**    ==================='))
  return(res)
}
















#
#
#
.show_score_as_DT <- function (tag_score_list)
{
  message(cat('\n\t\t\t\t==============    **Compiling ...**    ==================='))
  tmpDT <- rbindlist(tag_score_list,idcol = T)
  return (tmpDT)
}



.show_score_as_DT2 <- function (tag_score_list)
{
  message(cat('\n\t\t\t\t==============    **Compiling ...**    ==================='))
  tmpDTlist <- sapply(tag_score_list, '[',1,USE.NAMES = T,simplify = F)
  tmpDT <- rbindlist(tmpDTlist,idcol = T)
  return (tmpDT)
}


#
# Unstack for all variables
#
.show_score_as_unstackDT <- function (tag_score_list)
{
  message(cat('\n\t\t\t\t==============    **Compiling ...**    ==================='))
  tmpDTlist <- sapply(tag_score_list,.unstack_dt,USE.NAMES = T,simplify = F)
  tmpDT <- rbindlist(tmpDTlist,idcol = 'label',fill = T)
  return (tmpDT)
}


#take a datatable or dframe and unstack each observation as a column 
#it will return a datatable with only one observation representing all the previous obsr together
#|  val1 val2|
#|1. x11  x12|  ==> val1_1 val2_1 val1_2 val2_2 val1_3 val2_3
#|2. x21  x22|        x11   x12     x21   x22    x31    x23
#|3. x31  x23| 

.unstack_dt <- function(dt) {
  do.call(cbind,lapply(1:nrow(dt),function(x) {y <- dt[x]; setnames(y,paste0(names(y),x))}))
}







#============================
#     TAG MATCH
#===========================

.search_tag <- function(dataset,mode = c('unigram','bigram','skipgram','uniskipgram','biskipgram','trigram','lsa','adjust','default'),
                        voting = 5, with_stop_word=FALSE,validation=TRUE,...)
{
  mode_info <- paste0(c(
    '[ unigram','bigram','skipgram','uniskipgram','biskipgram','trigram','lsa','adjust','default ]'
    
    ),collapse = ' - ')
 
  
  if(length(mode)>1) {
    
       mode<- readline(paste0('Please specify an analysis mode in the terminal. Choose one of the following ',mode_info,' :')  )
  }
 
  
  if(validation) { 
    if((!'TAG_HUMAN' %in% names(dataset)) && any(grepl('Mlstr_area',names(dataset)))){
      dataset[,TAG_HUMAN := do.call(stri_paste,c(.SD,sep=' ',ignore_null=T)),.SDcols = grep(    paste0('Mlstr_area') , names(dataset) ) ]
      dataset[,TAG_HUMAN :=.tag_processor(TAG_HUMAN)]
      
    }else if((!'TAG_HUMAN' %in% names(dataset)) && !any(grepl('Mlstr_area',names(dataset)))){ stop('nothing to validate\nSuggestion: use option validation=FALSE',call. = FALSE)}
  }
    
  if('label:en' %in% names(dataset) && !'label' %in% names(dataset)) dataset[,label := `label:en`]

  
  
  
  
  
  
  
  #if(length(type)>1) {type <-  readline('choose a type between: unseen or demo: ')}
  
  info <- switch (mode,
                  unigram = list(wdfm = 'WDFM_ENG', ngrams = 1 , skip = 0),
                  bigram = list(wdfm = 'WDFM_BI_ENG', ngrams = 2,skip = 0),
                  skipgram = list(wdfm = 'WDFM_SKIP_ENG',ngrams = 2,skip =0:1),
                  uniskipgram = list(wdfm ='WDFM_UNISKIP_ENG', ngrams= 1:2,skip=1),
                  biskipgram = list(wdfm = 'WDFM_BISKIP_ENG', ngrams=1:2, skip = 0:1),
                  trigram = list(wdfm= 'WDFM_TRI_ENG' , ngrams = 3 ,skip = 0),
                  lsa = list(wdfm = 'wlsa'),
                  adjust = list(wdfm='Wcomb',ngrams=1,skip=0),
                  #default = list(wdfm='WDFM_TAG_ENG',ngrams=1,skip=0)
                  default = list(wdfm='WDFM_GRP_STACK_ENG',ngrams=1,skip=0)
  )
  
  if(!with_stop_word) {
    wdfm_loader <- paste0('bow/model/dfm/',info$wdfm,'.rds')
  }else{
    wdfm_loader <- paste0('bow/model/dfm/with_stop_word/',info$wdfm,'.rds')
  }
  
  WDFM<-readRDS(wdfm_loader)
  
  
  #rename empty label
  dataset[!.isvalidtext(label),label:='EMPTY_LABEL']
  #get label
  q <- dataset[,label]
  #WDFM <- eval(as.name(info$wdfm))
  
  if( (is(WDFM,'LSAspace')) && !(mode =='lsa') ) stop("INCOMPATIBLE SETTINGS: ' matrix is LSAspace but mode is not lsa' ",call. = F)
  
  
  if(mode == 'lsa') {
    score_list <- .show_score2(q,WDFM,Ncandidate = voting)
  #} if(mode == 'default') {
   # score_list <- .show_score2(q,WDFM,stem = F,ngrams = info$ngrams,skip = info$skip)
  }else {
    score_list <- .show_score(q,WDFM,Ncandidate = voting,ngrams = info$ngrams,skip = info$skip)
  }

  score_tag <- .show_score_as_unstackDT(score_list)
  #add infos if any from original dataset
  
  if(validation) {
    
    mm_status <- .show_MM_DT(score_tag,dataset)[,STATUS]  #-<------dependency from evaluator 
    score_tag <- cbind(dataset,STATUS = mm_status, score_tag[,.SD,.SDcols = -1])
    
  }else{
    score_tag <- cbind(dataset, score_tag[,.SD,.SDcols = -1])
  }
 
  
  return (score_tag )
  
  
}

