#!/usr/bin/env bash

echo "[`date`] Running AnalysisTracker2 checker task"
result=`curl http://localhost:3200/cron/check.json?cmd=checkqueue`
ERR=$?
if (( $ERR )); then
    echo "result: failed to connect"
else
    echo "result: $result"
fi