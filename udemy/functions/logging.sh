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

backup_file() {
# This function creates a backup of a file. Returns non-zerio status on error.
  local FILE='${1}"
# Make sure the file exists.
  if [[ -f "${FILE}" ]]
  then
    local BACKUP_FILE="/var/tmp/$(basename ${FILE}).$(date +%F-%N)"
    log "Backing up ${FILE} to ${BACKUP_FILE}."
  
  # The exit status of the function will be the exit status of the cp command.
  # -p option on cp command stands for preserve, it preserves the timestamp, mode, ownership
  # if don't use -p, the copy of the original file will have current timestamp
    cp -p ${FILE} ${BACKUP_FILE}
  else
  # The file does not exist, so return a non-zero exit status. Inside the function, use return instead of exit, exit will exit the entire shell script
    return 1
  fi
}

readonly VERBOSE='true'     #readonly make variable not changable
log 'true' 'Hello!'
log 'true' 'This is fun!'
backup_file '/etc/passwd'

# Make a decision based on the exit status of the function.
if [[ "${?}" -eq '0' ]]
then
  log 'File backup succeeded!'
else
  log 'File backup failed!'
  exit 1
fi
