#----------------------------------------
# download the cookbooks text 
#

if (!file.exists("cookbooks.zip")) {
  download.file("http://archive.lib.msu.edu/dinfo/feedingamerica/cookbook_text.zip","cookbooks.zip")
}
unzip("cookbooks.zip",exdir="cookbooks")



#-------------------------------------------------------#
# use the package function to prepare the text dataset  #

#this is a bit slow
prep_word2vec("cookbooks","cookbooks.txt",lowercase=T)
#alternatively we can use perl to parse the text
#system("perl -pe 's/[^A-Za-z_0-9 \n]/ /g;' cookbooks/* > cookbooks.txt")

#train a word2vec (skip-gram) model on cookbooks and save the trained model into binary file
model = train_word2vec("cookbooks.txt",output="cookbook_vectors.bin",threads = 3,vectors = 100,window=12)


# read the trained model
model <- read.vectors("deep_learning/cookbook_vectors.bin")


#see some interesting result
1-nearest_to(model,model[[c("fried",'potato')]],20)
