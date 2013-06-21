#!/usr/bin/env bash

# external parameters:
# need to be substituted when instantiating this template!
##################################

export PROJECT_DIR=@PROJECT_DIR@
export RUN_ID=@RUN_ID@
export START_INDEX=@START_INDEX@
export BATCH_SIZE=@BATCH_SIZE@
export QUERY_FILE=@QUERY_FILE@

##################################

export SCRIPT_DIR=${PROJECT_DIR}/script
export RUN_DIR=${PROJECT_DIR}/runs/${RUN_ID}
export DATA_DIR=${PROJECT_DIR}/data
export LOGFILE=${PROJECT_DIR}/log/blastn.log
export PATH=${SCRIPT_DIR}:$PATH

export NOTIF_EMAIL=balint.domokos@astridbio.com

source ${SCRIPT_DIR}/workflow_utils.sh

#export COUNTERFILE=".scriptcount.txt"

##################################


mkdir -p $RUN_DIR

#if [ ! -e "${PROJECT_DIR}/${COUNTERFILE}" ]; then
#    echo 1 > $COUNTERFILE
#fi

for f in {"M2_L008_good_1.fastq","M2_L008_good_2.fastq","M2norm_L008_good_1.fastq","M2norm_L008_good_2.fastq"}
do
    CMD="python script/fastq2fasta.py ${DATA_DIR}/${f} |blastn -db 16SMicrobial -num_threads 14 -evalue 1e-5 -outfmt '7' > ${RESULT_DIR}/${f}_blast16s.txt"
    run_and_log_notif $CMD
done
