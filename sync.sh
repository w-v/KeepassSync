#!/bin/bash

# this script synchronises a password database with an NFS share or by ssh if the share is not accessible

SRVS=( "10.0.2.3" "h.w-v.fr" )
PORT=22
USR='robin'
CLD_PATH="/media/cloud/m.kdbx" 
SSH_PATH="/srv/cld/m.kdbx"
TMP_CPY="tmp/m.kdbx.tmp"
MAIN="m.kdbx"
LOG="tmp/log"


if [ -f $CLD_PATH ]; then

  echo "cloud is accessible" >> ${LOG}
  if [[ ! -L "$TMP_CPY" || ! -f "$TMP_CPY" ]];then
    echo "making a symlink to cloud db" >> ${LOG}
    mv "$TMP_CPY" "${TMP_CPY}.hard" 2>/dev/null
    ln -sf "$CLD_PATH" "$TMP_CPY"
  fi

else

  echo "cloud is not accessible" >> ${LOG}
  echo "going with ssh" >> ${LOG}
  echo "testing adresses" >> ${LOG}

  for addr in $SRVS; do
    echo "testing $addr" >> ${LOG}
    if [ -z $(ping -c 1 $addr | grep "Network Unreachable") ];then
      echo "elected $addr" >> ${LOG}
      break;
    fi
  done

  if [ ! -f $TMP_CPY ];then
    if [ -f "${TMP_CPY}.hard" ];then
      mv "${TMP_CPY}.hard" "${TMP_CPY}"
    else
      cp $MAIN $TMP_CPY
    fi
  fi

  arg="${USR}@${addr}:${SSH_PATH}"

  if [[ -z $1 || "$1" = "push" ]] ;then
    echo pushing >> ${LOG}
    arg="$TMP_CPY $arg"
  else
    echo pulling >> ${LOG}
    arg="$arg $TMP_CPY"
  fi

  rsync --rsh="ssh -p $PORT" --copy-links -av --progress --partial $arg >> ${LOG}
  if [ $? -eq 0 ];then
    echo DONE >> ${LOG}
  else
    echo SHIT WENT SOUTH >> ${LOG}
  fi

fi
