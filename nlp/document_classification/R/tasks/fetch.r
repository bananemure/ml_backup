dir_ <- '~/teradata/analysis/machine-learning/text-classification-nlp/data/unsup/opal_format'
d_ <- rbindlist( zlist <- lapply ( z <- file.path(dir_,list.files(dir_)),function(f) {df <- readxl::read_excel(f); setDT(df)} ) ) 




