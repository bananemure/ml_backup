#!/usr/bin/env bash
cd /media/stef/teradata/analysis/machine-learning/nlp/document-classification/FT
DATADIR=data

filename=$1



mkdir -p "${DATADIR}"


if [ -f  "${DATADIR}/$filename.query" ]
then 
  rm "${DATADIR}/$filename.query"
fi



if [ ! -f  "${DATADIR}/$filename.query" ]

then
  
   cmdR="Rscript src/R_normalize_test.r -i ${DATADIR}/sup/$filename.csv -o ${DATADIR}/$filename.query"
   echo $cmdR;eval $cmdR

fi


#  ------------------------------------------ PREDICTION ------------------------------------------------------------------------
MODELDIR=model/sup
PREDICTDIR=predict


MODEL=modelsup.bin




mkdir -p "${MODELDIR}"
mkdir -p "${PREDICTDIR}"

printf    "********************************************\n \t MODEL: $MODEL  \n********************************************\n"
 date

predict() { 
	printf  "\nPREDICTION $1 fasttext predict-prob "${MODELDIR}/$MODEL" "${DATADIR}/$1.query" > "${PREDICTDIR}/$1.predict" 5\n"
	time fasttext predict-prob "${MODELDIR}/$MODEL" "${DATADIR}/$1.query" > "${PREDICTDIR}/$1.predict" 5
	#fasttext test "${MODELDIR}/$MODEL" "${DATADIR}/$1.test" 1
}


predict $filename
