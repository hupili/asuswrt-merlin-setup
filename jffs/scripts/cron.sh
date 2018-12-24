#!/bin/sh

LOG="/jffs/logs/cron.log"

echo >> $LOG
echo [begin start service] `date` >> $LOG
/jffs/scripts/entware-start.sh 2>&1 >> $LOG
echo [end start service] `date` >> $LOG
echo >> $LOG
