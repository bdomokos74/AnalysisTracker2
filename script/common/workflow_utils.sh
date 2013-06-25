#!/usr/bin/env bash

export LOGFORMAT="[%E] Done => %C"
export COUNTERFILE=".scriptcount.txt"

function get_and_increase {
    local PREFIX=""
    if [ -e "${COUNTERFILE}" ]; then
        COUNTER=$(cat $COUNTERFILE)
        echo $(($COUNTER + 1)) > ${COUNTERFILE}
        PREFIX=$(python -c 'import sys; print "#%05d"%(int(sys.argv[1]))' $COUNTER)
    fi
    echo ${PREFIX}
}

function get_prefix {
    local PREFIX=""
    if [ -e "${COUNTERFILE}" ]; then
        COUNTER=$(cat $COUNTERFILE)
        PREFIX=$(python -c 'import sys; print "#%05d"%(int(sys.argv[1]))' $COUNTER)
    fi
    echo ${PREFIX}
}

function dump_config {
    local PREFIX=$(get_prefix)
    echo "${PREFIX} [`date`] CFG dump $1:" >> $LOGFILE
    grep -v "^#" $1 | sed "s/^/${PREFIX} CFG /" >> $LOGFILE
}

function run_and_log {
    local PREFIX=$(get_and_increase)
    echo "${PREFIX}[`date`] Executing => $@" >> $LOGFILE
    /usr/bin/time -o ${LOGFILE} -a -f "${PREFIX}${LOGFORMAT}" eval_str.sh $@
    ERR=$?
    if (( $ERR )); then
        echo "${PREFIX}[`date`] Failed ($ERR) => $@" >> ${LOGFILE}
    fi
}

function run_and_log_notif {
    local PREFIX=$(get_and_increase)
    local CMD_STORED=$@
    local CMD_STATUS="success"
    local CMD_START=`date +"%Y-%m-%d %H:%M:%S"`
    local CMD_END
    local CMD_TIME

    echo "${PREFIX}[`date`] Executing => $@" >> $LOGFILE

    /usr/bin/time -o ${LOGFILE} -a -f "${PREFIX}${LOGFORMAT}" eval_str.sh $@
    local ERR=$?
    if (( $ERR )); then
        echo "${PREFIX}[`date`] Failed ($ERR) => $@" >> ${LOGFILE}
        CMD_STATUS="failed"
    fi
    CMD_END=`date +"%Y-%m-%d %H:%M:%S"`
    CMD_TIME=`python ${SCRIPT_DIR}/timediff.py "$CMD_START" "$CMD_END"`

    SERVERIP=`ifconfig | grep 'inet addr:' | grep -v '127.0.0.1'|cut -d: -f2 |awk '{ print $1 }'`
    MSG="$(cat << EOS
The following command completed with $CMD_STATUS, in ${CMD_TIME} on ${SERVERIP}:

$CMD_STORED
EOS
)"
    python ${SCRIPT_DIR}/notify_by_mail.py "$NOTIF_EMAIL" "$MSG"

    local ERR_MAIL=$?
    if (( $ERR_MAIL )); then
        echo "Error during mail notification"
    fi

    echo "Err variable: $ERR"
}

function run_and_log_server {
    local PREFIX=$RUN_ID
    START_DATE=`date +"%Y-%m-%d %H:%M:%S"`
    echo "#${PREFIX}[$START_DATE] Executing => $@" >> $LOGFILE
    /usr/bin/time -o ${LOGFILE} -a -f "${PREFIX}${LOGFORMAT}" eval_str.sh $@
    ERR=$?
    END_DATE=`date +"%Y-%m-%d %H:%M:%S"`
    if (( $ERR )); then
        echo "#${PREFIX}[$END_DATE] Failed ($ERR) => $@" >> ${LOGFILE}
    else
        echo "#${PREFIX}[$END_DATE] Success => $@" >> ${LOGFILE}
    fi
    duration=`python ${SCRIPT_DIR}/timediff.py "$START_DATE" "$END_DATE"`
    #echo "$SERVER_URL runid=$RUN_ID err=$ERR dur=$duration" >> $LOGFILE
    python ${SCRIPT_DIR}/bookkeeping.py $SERVER_URL $RUN_ID $ERR $duration
}

function fail_and_log_server {
    local RUN_ID=$1
    local ERR=$2
    python ${SCRIPT_DIR}/bookkeeping.py $SERVER_URL $RUN_ID $ERR 0
}