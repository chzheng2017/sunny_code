#!/bin/bash
log() {
  # This function sends a message to syslog and to standard output if VERBOSE is true.
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then 
      echo "${MESSAGE}"
  fi
  logger -t logging.sh "${MESSAGE}"
}

readonly VERBOSE='true'     #readonly make variable not changable

log 'true' 'Hello!'
log 'true' 'This is fun!'
