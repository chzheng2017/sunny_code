#!/bin/bash

# Count the number of failed logins by IP address
# If there are any IPs with over LIMIT failures, display the count, IP and location
LIMIT=10

# A log file is provided as an argument. If a file is not provided
# or it cannot be read, then the script will display an error message
# and exit with a status 1

LOG_FILE=$1

if [ ! -e "${LOG_FILE}" ]
then
  echo "Cannot open log file: ${LOG_FILE}" >&2
  exit 1
fi


# Two ways can scrape out the IP address:
# grep Failed syslog-sample | awk -F 'from ' '{print$2}' | awk '{print$1}' | sort -n | uniq -c
# grep Failed syslog-sample | awk '{print $(NF-3)}' | sort | uniq -c | sort -rn

#Display the header
echo 'Count,IP,Location'
# Loop through the list of failed attempts and corresponding IP address
grep Failed syslog-sample | awk '{print $(NF-3)}' | sort | uniq -c | sort -rn | while read COUNT IP
do
  if [ ${COUNT} > ${LIMIT} ]
# can also do if [[ "${COUNT}" -gt "${LIMIT}" ]]
  then
    LOCATION=$(geoiplookup ${IP} | awk -F ', ' '{print $2}')
    echo "${COUNT},${IP},${LOCATION}"
  fi
done
exit 0
