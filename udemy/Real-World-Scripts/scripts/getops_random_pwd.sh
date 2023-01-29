#!/bin/bash

# to use the script,  run ./getops.sh -v | -s | -l 8
# This script generates a random password
# This user can set the password length with -l and add a special character with -s
# Verbose mode can be enabled with -v.
# getopts to process command line options


usage() {
  echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
  echo 'Generate a random password.'
  echo ' -l LENGTH Specify the password length.'
  echo ' -s        Append a special character to the password.' 
  echo ' -v        Increase verbosity.'
  exit 1
}

log() {
  local MESSAGE="${@}"
  if [[ "${VERBOSE}" = 'true' ]]
  then
    echo "${MESSAGE}"
  fi
}   

# Set a default password length
LENGTH=48

while getopts vl:s OPTION
do
  case ${OPTION} in 
    v)
      VERBOSE='true'
      log 'Verbose mode on.'
      ;;
    l)
      LENGTH="${OPTARG}"
      ;;
    s)
      USE_SPECIAL_CHARACTER='true'
      ;;
    ?)
      usage
      ;;
  esac
done

echo "Number of args: ${#}"
echo "All args: ${@}"
echo "Frist arg: ${1}"
echo "Second arg: ${2}"
echo "Third arg: ${3}"

if [[ ""${#}" -gt 0 ]]
then
  usage
fi


# Inspect OPTIND
echo "OPTIND: ${OPTIND}"

# Remove the options while leaving the remaining arguments
shift "$(( OPTIND -1 ))"

log 'Generating a password.'

PASSWORD=$(date +%s%N${RANDOM}${RANDOM} |sha256sum | head -c${LENGTH})

#Append a special character if requested to do so.
if [[ "${USE_SPECIAL_CHARACTER}" ='true' ]]
then 
  log 'Selecting a random special character.'
  SPECIAL_CHARACTER=$(echo '!@#$%6^&*()-+=' | fold -w1 | shuf | head -c1)
  PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

log 'Done.'
log 'Here is the password:'

# Display the password no matter verbose mode is on or not
echo "${PASSWORD}"
exit 0