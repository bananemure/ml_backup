#!/usr/bin/env bash

cd /media/stef/teradata/analysis/machine-learning/nlp/document-classification/FT
MODELDIR=model/sup
PREDICTDIR=predict
DATADIR=data

MODEL=${MODELDIR}/$2




mkdir -p "${MODELDIR}"
mkdir -p "${PREDICTDIR}"

printf    "********************************************\n \t MODEL: $MODEL  \n********************************************\n"

date

#predict() { 
#	printf  "\nPREDICTION $1 fasttext predict-prob "${MODELDIR}/$MODEL" "${DATADIR}/$1" > "${PREDICTDIR}/$1.predict" 5\n"
#	time fasttext predict-prob "${MODELDIR}/$MODEL" "${DATADIR}/$1" > "${PREDICTDIR}/$1.predict" 5
#	fasttext test "${MODELDIR}/$MODEL" "${DATADIR}/$1" 1
#}


predict() { 
	printf  "PREDICTION:  fasttext predict-prob $MODEL ${DATADIR}/$1 > ${PREDICTDIR}/$1.predict $3\n"
	cmd="time fasttext predict-prob $MODEL ${DATADIR}/$1 > ${PREDICTDIR}/$1.predict $3"
	echo $cmd; eval $cmd
	#fasttext test "$MODEL.bin" "${DATADIR}/$1" 1
}



predict $1 $2 $3


