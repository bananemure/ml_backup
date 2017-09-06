library(wordVectors)
m_cbow <- read.vectors('~/teradata/analysis/machine-learning/text-classification-nlp/fasttext/model/unsup/med_cbow.wv.vec',binary = F)
m_skip <- read.vectors('~/teradata/analysis/machine-learning/text-classification-nlp/fasttext/model/unsup/med_skipgram.wv.vec',binary = F)

most_similar <- function(model,word,n=25){
  (1 - nearest_to(model,model[[word]],n))*100
}


#ecb = function(x,y,z,txt,cex=1){rgl::plot3d(x,type='n',main="viz word embed"); rgl::text3d(x,texts = txt,cex = cex) }

set.seed(1L)
idx <- sample(nrow(model <- m_skip), 10000,FALSE)

m <-tsne::tsne(  { sm <- model[idx,];txtname <- rownames(sm); sm }   ,k = 3,perplexity = 200,max_iter = 500,epoch = 10) ; rm(sm,model)


save(list=c('m','txtname'),file = 'result/rimage/model_tsne.rda')


#exemple of evaluation

library(plotly)
p <- plot_ly(data = as.data.frame(m[1:2000,]),x=~V1,y=~V2,z=~V3,type = 'scatter3d',mode='text',text=txtname[1:2000])
print(p)
