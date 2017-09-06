normalise <- function(x) {
  
  #lowercase
  x <- stri_trans_tolower(x)
  
  #clean
  x <- stri_replace_all_regex(x, "\\bshant\\b",'shall not')
  x <- stri_replace_all_regex(x, "\\bwon't\\b|\\bwont\\b",'will not')
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
  
  
  
  # --------- do a personal stemming-------------------------------------
  x <- stri_replace_all_regex(x,'(ishes)\\b','ish')
  #consonant_and_S <- paste0(letters[-c(1,5,9,15,19,21)],collapse = '|')
  x <- stri_replace_all_regex(x,'(sses)\\b','ss')
  x <- stri_replace_all_regex(x,'(oes)\\b','o')
  x <- stri_replace_all_regex(x,'(ies)\\b','y')
  x <- stri_replace_all_regex(x,'(?<!(a|s|i|o|u))s\\b','')
  #--------------------------------------------------------------------
  
  
  
  #-------------digit -------------------------------------
 
  #digit to 1
  x <- stri_replace_all_regex(x,'\\p{N}+',1)
  
  # remove word starting with digit ex: 4vgh
  x <- stri_replace_all_regex(x,'\\b\\p{N}\\w+','')
  #--------------------------------------------------------
  
  
  
  #---------------then punctuation, non printable and unichar: those to space
  x <- stri_replace_all_regex(x, "xv|(xx)+|iii|ii|\\biv\\b|\\betc\\b|\\p{P}|\\b\\w{1}\\b|\\s+|\\p{C}+|\\p{S}",' ')
  
  
  
  #-------trim space
  stri_trim_both(x)
  

}

D <- fread('../../data/full/FULL_UPDATE.csv')

D[,`label:en`:=normalise(`label:en`)]