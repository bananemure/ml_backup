
#-------------------------------------------------------#
# use the package function to prepare the text dataset  #

#this is a bit slow
#with no stop word
prep_word2vec('maelstrom.txt',destination = 'deep_learning/maelstrom_train.txt',lowercase = TRUE)

#with stop word
prep_word2vec('deep_learning/maelstrom_train_clean_sw.txt',destination = 'deep_learning/maelstrom_train_clean_sw.txt',lowercase = TRUE)

#alternatively we can use perl to parse the text
#system("perl -pe 's/[^A-Za-z_0-9 \n]/ /g;' cookbooks/* > cookbooks.txt")

#train a word2vec (skip-gram) model on cookbooks and save the trained model into binary file

train_word2vec("deep_learning/maelstrom_train_clean_sw.txt",output="deep_learning/bin/maelstrom_w2_300.bin",threads = 4,vectors = 300,window=2,min_count = 2,force = TRUE,iter = 100)
train_word2vec("deep_learning/maelstrom_train_clean_sw.txt",output="deep_learning/bin/maelstrom_w4_300.bin",threads = 4,vectors = 300,window=4,min_count = 2,force = TRUE,iter = 100)
train_word2vec("deep_learning/maelstrom_train_clean_sw.txt",output="deep_learning/bin/maelstrom_w6_300.bin",threads = 4,vectors = 300,window=6,min_count = 2,force = TRUE,iter = 100)
train_word2vec("deep_learning/maelstrom_train_clean_sw.txt",output="deep_learning/bin/maelstrom_w10_300.bin",threads = 4,vectors = 300,window=10,min_count = 2,force = TRUE,iter = 100)





train_word2vec("deep_learning/maelstrom_train_clean_sw.txt",output="deep_learning/bin/maelstrom_w2_75.bin",threads = 4,vectors = 75,window=2,min_count = 2,force = TRUE,iter = 1000)
train_word2vec("deep_learning/maelstrom_train_clean_sw.txt",output="deep_learning/bin/maelstrom_w4_75.bin",threads = 4,vectors = 75,window=4,min_count = 2,force = TRUE,iter = 1000)
train_word2vec("deep_learning/maelstrom_train_clean_sw.txt",output="deep_learning/bin/maelstrom_w6_75.bin",threads = 4,vectors = 75,window=6,min_count = 2,force = TRUE,iter = 1000)
train_word2vec("deep_learning/maelstrom_train_clean_sw.txt",output="deep_learning/bin/maelstrom_w10_75.bin",threads = 4,vectors = 75,window=10,min_count = 2,force = TRUE,iter = 1000)

train_word2vec("deep_learning/maelstrom_train_clean_sw.txt",output="deep_learning/bin/maelstrom_w15_75.bin",threads = 4,vectors = 75,window=15,min_count = 2,force = TRUE,iter = 1000)
train_word2vec("deep_learning/maelstrom_train_clean_sw.txt",output="deep_learning/bin/maelstrom_w20_75.bin",threads = 4,vectors = 75,window=20,min_count = 2,force = TRUE,iter = 1000)

# read the trained model
model <- read.vectors("deep_learning/bin/maelstrom_w2_150.bin")


#see some interesting result
1-nearest_to(model,model[[c("diabetes")]],20)

