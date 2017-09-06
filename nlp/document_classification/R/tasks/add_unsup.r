source('R/bow/indexer/normalizer.r')

d_fetched <- fread('data/full/FETCHED.csv')


# --------------- extract other non tagged data from owncloud and merge
dir_ <- 'data/unsup/opal_format'
d_ <- rbindlist(lapply ( file.path(dir_,list.files(dir_)),function(f) {df <- openxlsx::read.xlsx(f); setDT(df)} ),fill = T ) 
setnames(d_,c('description:en','label:en'),c('description','label'))


d_ <- d_[,.(table,original_table,name,label,description)]; d_[,`:=`(label_desc='',tag='')]

# process label_desc
d_ <- .label_desc_merge(d_)




#---------- finalise  -----------------

#merge old with new
d_ <- rbindlist(list(d_,d_fetched),fill = TRUE)
setDF(d_); d_[is.na(d_)]<-'';setDT(d_)

#add datasource
d_[is.na(tag)|tag == '',datasource:='UNSUP']   #<---


#--- save file 
fwrite(d_,file='data/full/FULL_UPDATE.csv',na = '',row.names = FALSE)

#     do unsupervised data
d_unsup <- d_[!(duplicated(label_desc)),.SD,by=tag]
#d_unsup[,label_desc:=.normalise(label_desc,nn=TRUE)]
fwrite(d_unsup,file='data/full/FULL_UNSUP.csv',na = '',row.names = FALSE)




#Do only supervised data
d_sup <- d_[!datasource=='UNSUP',]
d_sup <- d_sup[!(duplicated(label_desc)),.SD,by=tag]
fwrite(d_sup,file='data/full/FULL_SUP.csv',na = '',row.names = FALSE)


rm(d_,d_fetched)
