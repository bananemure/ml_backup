#!/usr/bin/env bash

cd /media/stef/teradata/analysis/machine-learning/nlp/document-classification/FT
MODELDIR=model/unsup/
DATADIR=data




mkdir -p "${MODELDIR}"
mkdir -p "${DATADIR}"




TRAINING=cbow
echo TRAINING: $TRAINING unsupervised
cmd="fasttext $TRAINING -input "${DATADIR}/mlstr.wv.unsup" -output "${MODELDIR}/model_$TRAINING.wv" -lr 0.05 -dim 75 -ws 20 -minCount 1 -epoch 2000 -minn 4 -neg 6 -lrUpdateRate 1000"
echo $cmd;
time eval $cmd
#time fasttext $TRAINING -input "${DATADIR}/mlstr.wv.unsup" -output "${MODELDIR}/model_$TRAINING.wv" -lr 0.05 -dim 75 -ws 20 -minCount 1 -epoch 2000 -minn 4 -maxn 10 -neg 6 -lrUpdateRate 1000


# --------------------------------------------------------------------------------------------------------------------

TRAINING=skipgram
echo TRAINING: $TRAINING unsupervised
cmd="fasttext $TRAINING -input "${DATADIR}/mlstr.wv.unsup" -output "${MODELDIR}/model_$TRAINING.wv" -lr 0.05 -dim 75 -ws 20 -minCount 1 -epoch 1000 -minn 4  -neg 6 -lrUpdateRate 1000"
echo $cmd
time eval $cmd
#time fasttext $TRAINING -input "${DATADIR}/mlstr.wv.unsup" -output "${MODELDIR}/model_$TRAINING.wv" -lr 0.05 -dim 75 -ws 20 -minCount 1 -epoch 1000 -minn 2 -maxn 10 -neg 10 -lrUpdateRate 1000



