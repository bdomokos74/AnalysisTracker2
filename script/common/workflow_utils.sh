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

