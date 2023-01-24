#!/bin/bash

# to use the script,  run ./getops.sh -v | -s | -l 8
# This script generates a random password
# This user can set the password length with -l and add a special character with -s
# Verbose mode can be enabled with -v.


usage() {
  echo "Usage: ${0} [-vs] [-l LENGTH]" >&2
  echo 'Generate a random password.'
  echo ' -l LENGTH Specify the password length.'
  echo ' -s        Append a special character to the password.' 
  echo ' -v        Increase verbosity.'
  exit 1
}
  

# Set a default password length
LENGTH=48

while getopts vl:s OPTION
do
  case ${OPTION} in 
    v)
      VERBOSE='true'
      echo 'Verbose mode on.'
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
    
     
      
      
    
    
      
    
    
