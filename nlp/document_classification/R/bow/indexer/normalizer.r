###################################################
#                                                 #
#       CLEANING (ENGLISH-FRENCH LABELS+TAGS)     #
#                                                 #
###################################################

#library('stringi')



# |   ------------------------------- |
#  FUNCTION TO remove repetitions in docs and sort the terms in a docs
#  useful for fingerprint clustering

.fingerprint.index <- function (x)
{
  k <- stri_split_charclass(x,pattern = '[[:space:]]')
  kwordsortedlist <- sapply(k,function(x)stri_c(stri_unique(stri_sort(x)),collapse = ' '))
  is_dup <- stri_duplicated(kwordsortedlist)
  return(which(is_dup))
}

#--------------------------------
.has.single.term <- function (x)
{
  stri_count_words(x)==1
}


#
# stem phrases
#

.phraseStem <- function(phrase,language='porter')
{

  token_phraselist <- stri_split_charclass(phrase,'[[:space:]]',omit_empty = T)
  stemmed_tp <- vapply(token_phraselist,function(x) {stri_c(quanteda::wordstem(x,language),collapse = ' ')},FUN.VALUE = 'a')
  stemmed_tp

}

.remove_words <- function (x,words)
{
  pattern <- stri_c(  stri_c('\\b', words,'\\b' ),collapse = '|' )
  step1 <- stri_replace_all_regex(x,pattern,replacement = '')
  stri_replace_all_regex(step1,pattern = '\\p{Z}+',replacement = ' ')
}



.mystemmer <- function(x)
{
  x <- stri_replace_all_regex(x,'(ishes)\\b','ish')
  #consonant_and_S <- paste0(letters[-c(1,5,9,15,19,21)],collapse = '|')
  x <- stri_replace_all_regex(x,'(sses)\\b','ss')
  x <- stri_replace_all_regex(x,'(oes)\\b','o')
  x <- stri_replace_all_regex(x,'(ies)\\b','y')
  x <- stri_replace_all_regex(x,'(?<!(a|s|i|o|u|dd))s\\b','')
  x
}




#-------------------------------------------------------------------#


.normalise <- function(x,rm_stopword=!nn, nn=FALSE) {
  
  #lowercase
  x <- stri_trans_tolower(x)
  
  
  
  #-------------digit -------------------------------------
  
 
  
  
  
  
  #clean
  if(rm_stopword) {
    
    #digit to 1
    #x <- stri_replace_all_regex(x,'\\p{N}+',1)
    
    # remove word HAVING DIGIT
    x <- stri_replace_all_regex(x,'(\\w+)?\\p{N}(\\w+)?','')
    #--------------------------------------------------------
    
    
    x <- .remove_words(x,c("if","are","the","he","she"
                          ,"shant","won't","don't","dont","do","not","don t", "doesn't","doesnt"
                          ,"don'","did","does","don`t","didnt","didn't"
                           ,"can't","cannot","can not","can"
                           ,"im","i'm","i am","you","youve","weve","you're","they're","that","he's","your","her","his","him"
                           ,"would","wouldnt","wouldn't","couldnt","mustnt","mustn't","wouldn","shouldn","couldn","cant"
                           ,"havent","haven't","i'd","you'd","he'd","she'd","we'd","they'd","'ll","n't"
                           ,"ifs","and","or","ands","buts","but"
                           ,"it's","there's","that's","here","here's"
                           ,"yes","no","other"
                           ,"which","when","what","how","in","this","with","per","why"
                           ,"to","any","at","for","of","on"
                           ,"have","had","has","is","was","were"
                           )
                      )
    
    
    # --------- do a personal stemming-------------------------------------
    x <- .mystemmer(x)
    #--------------------------------------------------------------------
    
    
    
    
    #---------------then punctuation, non printable and unichar: those to space
    x <- stri_replace_all_regex(x, "xv|(xx)+|iii|ii|\\biv\\b|\\betc\\b|\\s+|\\p{C}+|\\p{S}",' ')#|\\p{P}
    
    x <- stri_replace_all_regex(x,'"','')
    x <- stri_replace_all_regex(x,"'|\\.|:|\\(|\\)|\\[|\\]|,|/|-|!|\\?",' ')
    
    
    x <- stri_replace_all_regex(x,"\\b\\w{1}\\b|\\*|%",' ')
    
  }else {
    
    x <- stri_replace_all_regex(x, "\\bshant\\b",'shall not')
    x <- stri_replace_all_regex(x, "\\bwon't\\b|\\bwont\\b",'will not')
    x <- stri_replace_all_regex(x, "\\bdon't\\b|dont|don t",'do not')
    x <- stri_replace_all_regex(x, "\\bdoesn't\\b|doesnt|doesn t",'does not')
    x <- stri_replace_all_regex(x, "\\bcan't\\b|\\bcannot\\b",'can not')
    x <- stri_replace_all_regex(x, "\\bim\\b|\\bi'm\\b",'i am')
    x <- stri_replace_all_regex(x, "\\b(you)ve\\b|\\b(we)ve\\b|\\b(they)ve\\b|\\b(i)ve\\b|\\b(i)'ve\\b|\\b(you)'ve\\b|\\b(they)'ve\\b",'$1 have')
    x <- stri_replace_all_regex(x, "\\b(you)re\\b|\\b(you)'re\\b|\\b(we)'re\\b|\\b(they)'re\\b",'$1 are')
    x <- stri_replace_all_regex(x, "\\b(he)s\\b|\\b(she)s\\b(there)s\\b|\\b(when)s\\b|\\b(where)s\\b|\\b(why)s\\b|\\b(how)s\\b|\\b(who)s\\b|\\b(here)s\\b|
                              \\b(that)s|\\b(he)'s\\b|\\b(she)'s\\b|\\b(it)'s|\\b(that)'s\\b|\\b(who)'s\\b|
                              \\b(what)'s\\b|\\b(here)'s\\b|\\b(there)'s\\b|\\b(when)'s\\b|\\b(where)'s\\b|\\b(why)'s\\b|\\b(how)'s\\b|\\bhers\\b",'$1 is')
    x <- stri_replace_all_regex(x, "\\b(would)nt\\b|\\b(should)nt\\b|\\b(could)nt\\b|\\b(must)nt\\b|
                              \\b(would)n\\b|\\b(should)n\\b|\\b(could)n\\b|\\b(ca)nt\\b|\\b(have)nt\\b|\\b(do)nt\\b|\\b(did)nt\\b",'$1 not')
    
    x <- stri_replace_all_regex(x, "\\b(i)'d\\b|\\b(you)'d\\b|\\b(he)'d\\b|\\b(she)'d\\b|\\b(we)'d\\b|\\b(they)'d\\b",'$1 would')
    
    x <- stri_replace_all_regex(x, "'ll\\b",' will')
    x <- stri_replace_all_regex(x, "n't\\b",' not')
    
    x <- stri_replace_all_regex(x, "\\b(if)s\\b|\\b(and)s\\b|\\b(but)s\\b",'$1')
    
    
  }
  

  
  #-------trim space
  stri_trim_both(x)
  
  
}



.tokenize <- function(x,rm_stopword=FALSE)
{

  x_clean <- .normalise(x,rm_stopword)
  tok_label <- stri_split_charclass(x_clean,pattern='\\p{Z}',omit_empty = TRUE)

  names(tok_label) <- if(!is.null(names(x))){ names(x) }else{  paste0('text',1:length(tok_label)) }

  return(tok_label)
}




#--------------------------------------------------------
# function use to processs tag
.tag_processor <- function(tag)
{

  #sort multiple tags
  k <- stri_split_charclass(tag,pattern = '[[:space:]]')
  ksort <- vapply(k,function(x)stri_c(stri_unique(stri_sort(x)),collapse = ' '),FUN.VALUE = 'a')

  #then collapse with ||
  tag = stri_trim_both(ksort)
  tag = stri_replace_all_regex(tag,'\\p{WHITE_SPACE}+','||')

  return(tag)
}



.collapse_col <- function(dataset,what_regex = 'Mlstr_area',to_what='tag')
{
  if(!any(grepl(what_regex,names(dataset)))) return(data.table::setDT(dataset))
  datacopy <- data.table::copy(dataset)
  setDF(datacopy)
  datacopy[is.na(dataset)]<-''
  setDT(datacopy)
  VL <- datacopy[,do.call(stri_paste,c(.SD,sep=' ')),.SDcols = grep( what_regex , names(datacopy) ) ]
  set(datacopy,j=to_what,value =  VL)
  
  return(datacopy[,.SD,.SDcols = seq(ncol(datacopy))[!grepl( what_regex , names(datacopy) )] ])
}



#------------------------------------#
# SPLIT MULTIPLE TAG IN OBSERVATIONS #


#split tags from multiple tagged.
#add each split as a new observation
#
.split_tag <- function(dt,colname,pattern='\\|+')
{
  j_col <- as.name(colname)

  vv <- stri_split_regex(dt[,eval(j_col)],'\\|+')
  vv <- unique(stri_trim_both( unlist(vv) ) )

  RLIST <- sapply(vv, function(x) {Y <- dt[grepl(paste0('\\b',x,'\\b'),eval(j_col))]; set(Y,j = colname,value = x)},simplify = FALSE)

  rbindlist(RLIST)

}


.label_desc_merge <- function(dt) {
  tmp_lbl <- copy(dt)
  tmp_desc <- copy(dt)
  tmp_lbl[,label_desc := label]
  tmp_desc[,label_desc := description]
  dtmerge <- rbind(tmp_lbl,tmp_desc)[!label_desc=='',]
  dtmerge <- dtmerge[!(stri_duplicated(label_desc)),.SD,by = tag]
  return(dtmerge)
}

