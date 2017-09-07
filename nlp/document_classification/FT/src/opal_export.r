#! /usr/bin/Rscript

#  --------- get all datasources/projects in opal
#dsrces <- opal.datasources(o)


#----------- loop in datasources

extract_multids_attr <-  function (opal,datasource = NULL,filter_out =' ')  {
                  if(is.null(datasource)) ds <- opal.datasources(o)
                  else ds <- lapply(datasource,function(x) {opal.datasource(o,x)})
                  
                  filter_out <- paste0(filter_out,collapse = '|') 
                  ds <- Filter(function(f) (!is.null(f$table)) && (!grepl(filter_out,f$name,TRUE)),ds)
                  
                  
                  #get all variables attributes for all tables in all datasource
                  return ( lapply(ds, function(x) {cat(paste0(x$name,'\n'));extract_ds_attr(o,x)}) )
}



# get all the var attributes for all tables of one ds
extract_ds_attr <- function(opal,datasource){
  ds_i <- datasource
  if(is.null(ds_i$table)) return(NULL)
  
  ds_attr <- sapply(ds_i$table,function(tbl_x) { 
    
                vars <- opal.variables(opal,ds_i$name,tbl_x)
                extr <- extract_table_attr(vars)
                extr$table <- tbl_x
                return(data.table::setDT(extr))
          },simplify = FALSE
      )
  ds_ <- data.table::rbindlist(ds_attr)
  ds_[,datasource := ds_i$name]
  data.table::setcolorder(ds_,c('datasource','table','original_table','name','label','description','source','target','tag'))
}


#get all the variables attributes for one table of one ds
#vars <- opal.variables(o,ds1$name,tbl_i)

extract_table_attr <- function(vars) {
  vars_attr <- sapply(vars,function(var_i) {
                            extr <- extract_var_attr(var_i$attributes); 
                            extr$name <- var_i$name; 
                            return(extr) 
                            },
                      simplify = FALSE
                      )
  return(do.call(rbind,vars_attr))
  
} 


#zz <- extract_table_attr(vars)


#-----get all attributes for one variable
#attrbs <- extract_var_attr(vars_i$attributes)



extract_var_attr <- function (attrbs){
  had_tag <- FALSE
  prev_tag <- tag <- label <- target <- source <- description<- original_table <- ''
  extr <- sapply(attrbs, function (atr) { 
          if(atr$name =='label') label <<- atr$value  
          else if(grepl('target',atr$name,TRUE)) target <<- atr$value  
          else if(grepl('source',atr$name,TRUE)) source <<- atr$value  
          else if (atr$name == 'description') description <<- atr$value
          else if (atr$name == 'original_table') original_table <<- atr$value 
          else if(!is.null(atr$namespace)) {
            if(atr$namespace == 'Mlstr_area') { 
                tag <<- if (had_tag) { c(tag, atr$value)}else{atr$value}
                had_tag <<- TRUE 
              }
          }
    }
  )
  tag <- paste0(sort(tag),collapse = '||')
  data.frame(original_table,source,target,label,description,tag)
}






# ------------compile desc and label -------
label_desc_merge <- function(dt) {
  tmp_lbl <- copy(dt)
  tmp_desc <- copy(dt)
  tmp_lbl[,label_desc := label]
  tmp_desc[,label_desc := description]
  dtmerge <- rbind(tmp_lbl,tmp_desc)[!label_desc=='',]
  #dtmerge <- dtmerge[!(stri_duplicated(label_desc)),.SD,by=tag]
  return(dtmerge)
}



#---------------clean artifact in label ---------------
clean_artifact <- function(dt){
  #remove netherlands label (from table lifelines_food)
  dt[!table == 'LifeLines_Food',]
}



#------------------------MAIN ---------------------
#o <- opal.login('xxxxxx','xxxxxxx',url = 'https://opal.maelstrom-research.org')

setwd('~/teradata/analysis/machine-learning/nlp/document_classification/FT/')
FF <- extract_multids_attr(o,filter_out = c('test','melissa','study-dataset','ramon','patate','ttt','frele','nuage','chpttest','stephane'))



#compile all DT
FF <- data.table::rbindlist(FF)
write.csv(FF,'data/full/RAW_OPAL.csv',row.names = FALSE)


#clean artifact
DF <- clean_artifact(FF)

#merge label and desc into label_desc
DF <- label_desc_merge(DF)

DF[,tag_label:= stri_c(tag,label,sep=' ')]

DF <- DF[!duplicated(tag_label),]

#--- save file 
fwrite(DF,file='data/full/FETCHED.csv',na = '',row.names = FALSE)
