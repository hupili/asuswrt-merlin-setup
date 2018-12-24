#!/bin/sh

RC='/opt/etc/init.d/rc.unslung'

i=30
until [ -x "$RC" ] ; do
  i=$(($i-1))
  if [ "$i" -lt 1 ] ; then
    logger "Could not start Entware"
    exit
  fi
  sleep 1
done
$RC start
