#!/usr/bin/env bash

# external parameters:
# need to be substituted when instantiating this template!
##################################

export ROOT_DIR=@ROOT_DIR@
export RUN_ID=@RUN_ID@
export FILE_A=@FILE_A@
export FILE_B=@FILE_B@
export SKIP_FILE=@SKIP_FILE@
export SERVER_URL=@SERVER_URL@
export START_INDEX=@START_INDEX@
export BATCH_SIZE=@BATCH_SIZE@

##################################

export RUN_DIR=${ROOT_DIR}/runs/${RUN_ID}
export SCRIPT_DIR=${RUN_DIR}/script
export RESULT_DIR=${RUN_DIR}/result
export DATA_DIR=${ROOT_DIR}/data
export LOGFILE=${RUN_DIR}/log/lcs.log
export PATH=${SCRIPT_DIR}:$PATH

export NOTIF_EMAIL=balint.domokos@astridbio.com

source ${SCRIPT_DIR}/workflow_utils.sh

##################################

# Run the command
CMD="python ${SCRIPT_DIR}/lcs_proc.py ${DATA_DIR} ${FILE_A} ${FILE_B} ${SKIP_FILE} ${START_INDEX} ${BATCH_SIZE} > ${RESULT_DIR}/matches_${START_INDEX}.json"
run_and_log_server $CMD
