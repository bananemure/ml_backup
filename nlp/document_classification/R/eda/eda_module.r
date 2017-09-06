#====================================
# SPLIT MULTIPLE TAG IN OBSERVATIONS
#=====================================

#split tags from multiple tagged.
#add each split as a new observation
#
.split_tag <- function(dt,colname,pattern='\\|+') 
{
  j_col <- as.name(colname)
  
  vv <- stri_split_regex(R[,eval(j_col)],'\\|+')
  vv <- unique(stri_trim_both( unlist(vv) ) )
  
  RLIST <- sapply(vv, function(x) {Y <- dt[grepl(paste0('\\b',x,'\\b'),eval(j_col))]; set(Y,j = colname,value = x)},simplify = FALSE)
  
  rbindlist(RLIST)
  
}

#====================================
# ADD AREA INFO TO ASSOCIATED TAG IN OBSERVATIONS
#=====================================


#add area info associated to each tag
#
.add_area_info <- function(dt,colname)
{
  source('settings/MLSTRM_STRUCT.R',local = T)
  
  lapply(MLSTRM_AREA,function(x) { 
      tx <- TAG_BY_AREA[[x]];
      idx<-which(dt[,eval(as.name(colname))]%in%tx)
      dt[idx,AREA:=x]
    }
  )
  
  
}




.confusion_table <- function(DT=NULL)
{
  if((!is(DT,'data.table'))) stop('DT should be a data.table',call. = F)
    
  tbl <- DT[,table(TAG_HUMAN,TAG_FOUND1)]
  CFX_DT <- as.data.table(tbl)
  CFX_DT <- CFX_DT[N>0,]
  CFX_DT[!TAG_HUMAN==TAG_FOUND1,STATUS:='missed']
  CFX_DT[TAG_HUMAN==TAG_FOUND1,STATUS:='matched']
  setorder(CFX_DT,-N)
  return(CFX_DT)
}






#====================================
# PLOT DISTRIBUTION OF TAG IN OBSERVATIONS
#=====================================

#plotting
#status: ['missed'| 'matched']
#dt a datatable
.plot_tag_by_who <- function(area=NULL ,dt,status='missed')
{ 
  domain_list <-c(
    'Administrative_information', 
    'Cognitive_psychological_measures', 
    'Diseases', 
    'End_of_life', 
    'Health_community_care_utilization', 
    'Health_status_functional_limitations', 
    'Infancy_childhood', 
    'Laboratory_measures', 
    'Lifestyle_behaviours', 
    'Medication_supplements', 
    'Non_pharmacological_interventions', 
    'Physical_environment', 
    'Physical_measures', 
    'Reproduction', 
    'Social_environment', 
    'Sociodemographic_economic_characteristics', 
    'Symptoms_signs'
  )
  domain_message <- paste0(  c('---------------------------------------',domain_list,  '---------------------------------------'),collapse = '\n')
  
  if(is.null(area)) area <- 1
  if((!is(area,'character')) | !tolower(area) %in% tolower(domain_list)) {stop(paste0('"area" is mandatory...Please choose one of the Maelstrom area information domains below: \n',domain_message),call. = F)}
  if(!is(dt,'data.table')) stop('dt should be a data.table...This function use only data.table for fast processing advantages',call. = F)
  
  #capitalize the area string before using the plot features
  area <- stri_trans_totitle(area)
  g <- ggplot(dt[(WHO=='HUMAN'|WHO=='COMP1') & AREA==area & STATUS == status,],mapping = aes(TAG,N,fill=WHO))
  g <-g+geom_bar(stat='identity',position = 'dodge',show.legend = T,width = .4) + coord_flip(expand = F) +ggtitle(paste0(area,' Area ',status,' distribution'))+scale_fill_brewer(type = 'qual',palette = 'Paired')
  print(invisible(g+coord_flip() ))
}





#====================================
# PLOT DISTRIBUTION OF TAG IN OBSERVATIONS
#=====================================

#plotting
#dt a datatable
.plot_tag_fn <- function(area=NULL ,dt,who,study=NULL,count=F)
{ 
  
  dt <- data.table::copy(dt)
  domain_list <-c(
    'Administrative_information', 
    'Cognitive_psychological_measures', 
    'Diseases', 
    'End_of_life', 
    'Health_community_care_utilization', 
    'Health_status_functional_limitations', 
    'Infancy_childhood', 
    'Laboratory_measures', 
    'Lifestyle_behaviours', 
    'Medication_supplements', 
    'Non_pharmacological_interventions', 
    'Physical_environment', 
    'Physical_measures', 
    'Reproduction', 
    'Social_environment', 
    'Sociodemographic_economic_characteristics', 
    'Symptoms_signs'
  )
  domain_message <- paste0(  c('---------------------------------------',domain_list,  '---------------------------------------'),collapse = '\n')
  
  if(is.null(area)) area <- 1
  if((!is(area,'character')) | !tolower(area) %in% tolower(domain_list)) {stop(paste0('"area" is mandatory...Please choose one of the Maelstrom area information domains below: \n',domain_message),call. = F)}
  if(!is(dt,'data.table')) stop('dt should be a data.table...This function use only data.table for fast processing advantages',call. = F)
  
  dt[STATUS=='missed',COL:='pink']
  dt[STATUS=='matched',COL:='ligthblue']
  
  
  
  #define a title for the plot
  if(is.null(study)) {
    title <- paste0(area,' RECALL')
  }else{
    title <- paste0(area,' RECALL for ', study)
  }
  
  #capitalize the area string before using the plot features
  area <- stri_trans_totitle(area)
  
  if(!count){
    g <- ggplot(dt[(WHO==who) & AREA==area,],mapping = aes(TAG,PERCENT,fill=STATUS))+ ylab('Percent (%) over human tag')
  }else{
    g <- ggplot(dt[(WHO==who) & AREA==area,],mapping = aes(TAG,N,fill=STATUS)) + ylab('Count (N)')
  }
  
  g <-g+geom_bar(stat='identity',position = 'dodge',show.legend = T,width = .4) + ggtitle(title)+scale_fill_brewer(type = 'qual',palette = 'Set1',direction = -1)
  fig <- g + coord_flip() #theme(axis.text.x = element_text(angle = 30, hjust = 1,vjust = 1))
  print(fig)
}









#====================================
# PLOT DISTRIBUTION OF TAG IN OBSERVATIONS
#=====================================

#plotting
#dt a datatable
.plot_tag_fp <- function(area=NULL ,dt,who,study=NULL,count=F)
{ 
  
  dt <- data.table::copy(dt[STATUS=='missed',])
  domain_list <-c(
    'Administrative_information', 
    'Cognitive_psychological_measures', 
    'Diseases', 
    'End_of_life', 
    'Health_community_care_utilization', 
    'Health_status_functional_limitations', 
    'Infancy_childhood', 
    'Laboratory_measures', 
    'Lifestyle_behaviours', 
    'Medication_supplements', 
    'Non_pharmacological_interventions', 
    'Physical_environment', 
    'Physical_measures', 
    'Reproduction', 
    'Social_environment', 
    'Sociodemographic_economic_characteristics', 
    'Symptoms_signs'
  )
  domain_message <- paste0(  c('---------------------------------------',domain_list,  '---------------------------------------'),collapse = '\n')
  
  if(is.null(area)) area <- 1
  if((!is(area,'character')) | !tolower(area) %in% tolower(domain_list)) {stop(paste0('"area" is mandatory...Please choose one of the Maelstrom area information domains below: \n',domain_message),call. = F)}
  if(!is(dt,'data.table')) stop('dt should be a data.table...This function use only data.table for fast processing advantages',call. = F)
  
  dt[STATUS=='missed',COL:='pink']
  dt[STATUS=='matched',COL:='ligthblue']
  
  
  
  #define a title for the plot
  if(is.null(study)) {
    title <- paste0(area,' FALSE POSITIVE')
  }else{
    title <- paste0(area,' FALSE POSITIVE for ', study)
  }
  
  #capitalize the area string before using the plot features
  area <- stri_trans_totitle(area)
  
  if(!count){
    g <- ggplot(dt[(WHO==who) & AREA==area,],mapping = aes(TAG,PERCENT,fill=TAG))+ ylab('Percent (%) over computer tag')
  }else{
    g <- ggplot(dt[(WHO==who) & AREA==area,],mapping = aes(TAG,N,fill = TAG)) + ylab('Count (N)')
  }
  
  g <-g+geom_bar(stat='identity',position = 'dodge',show.legend = F,width = .3) + ggtitle(title)#+scale_fill_brewer(type = 'qual',palette = 'Set1',direction = -1)
  fig <- g + coord_flip() #theme(axis.text.x = element_text(angle = 30, hjust = 1,vjust = 1))
  print(fig)
}








#====================================
# PLOT COUNT OF TAG or AREA IN OBSERVATIONS
#=====================================

.plot_tag_or_area <- function(area= NULL,dt_lookup,what_col,count=F,title)
{
  title <- if(is.null(area)) {paste0(what_col,' in training set')}else{ paste0(what_col,' in ',area,' training set')}
  
  
  if(!is(dt_lookup,'data.table')) stop('dt_lookup is expected to be a data.table type',call. = F)
  if(!is(what_col,'character')) stop('Specify the col [what_col] to compunon-wigglyte')
  
  dt_count <- dt_lookup[,.N,by= eval(unique(c(what_col,'AREA')))]
  setorder(dt_count,N)
  what_sum <- dt_count[,sum(N)]
  what_value <- as.name(what_col)
  if(!count)
  {
    dt_count[,Percent:=100*N/what_sum]
    y <- as.name('Percent')
    ylabel <- 'Percent (%) over all labels in training set'
  }else{
    y <- as.name('N')
    ylabel <- 'Count (N)'
  }
  
  #setkey(dt_count,AREA)
  dt_count_area <- if (is.null(area)) { dt_count}else{ dt_count[AREA == area,]}
  
  g <- ggplot(data = dt_count_area,mapping = aes(x = eval(what_value),y = eval(y),fill=eval(what_value)))+ylab(ylabel)
  g <- g+geom_bar(stat = 'identity',width = .3,show.legend = F) + labs(list(title = title,x=what_col))  + coord_flip()
  
  print(g)
} 





