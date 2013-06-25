#!/usr/bin/env bash

# external parameters:
# need to be substituted when instantiating this template!
##################################

export ROOT_DIR=@ROOT_DIR@
export RUN_ID=@RUN_ID@
export START_INDEX=@START_INDEX@
export BATCH_SIZE=@BATCH_SIZE@
export QUERY_FILE=@QUERY_FILE@

##################################

export RUN_DIR=${ROOT_DIR}/runs/${RUN_ID}
export SCRIPT_DIR=${RUN_DIR}/script
export RESULT_DIR=${RUN_DIR}/result
export DATA_DIR=${ROOT_DIR}/data
export LOGFILE=${RUN_DIR}/log/blastn.log
export PATH=${SCRIPT_DIR}:$PATH

export NOTIF_EMAIL=balint.domokos@astridbio.com

source ${SCRIPT_DIR}/workflow_utils.sh

#export COUNTERFILE=".scriptcount.txt"

##################################

CMD="zcat $DATA_DIR/$QUERY_FILE | python ${SCRIPT_DIR}/fastq2fasta.py stdin $START_INDEX $BATCH_SIZE |blastn -db nt -num_threads 14 -evalue 1e-5 -outfmt '7' > ${RESULT_DIR}/${QUERY_FILE}_${START_INDEX}.blastn"
run_and_log $CMD
