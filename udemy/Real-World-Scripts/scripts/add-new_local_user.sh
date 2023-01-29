#!/bin/bash
#
# This script creates a new user on the local system.
# You must supply a username as an argument
# You can also provide a comment for the account as an argument, it's optional
# The password will be automatically generated
# The username, password, and host for the account will be displayed.
# ./add-new-local-user.sh emmal Emma Lee

# Make sure the script is being executed with superuser privileges.
if [[ "${UID}" -ne 0 ]]
then
   echo 'Please run with sudo or as root.'
   exit 1
fi

# if the usrname is not supplied, tell user how to use the script

if [[ "${#}" -lt 1 ]]
then
  echo "Usage: ${0} USER_NAME [comment]..."
  echo " Create an account on the local system with the name of USER_name and optional comment"
  exit 1
fi

# The first parameter is the user name
USER_NAME="${1}"

# The rest of the parameters are for the account comments
shift
COMMENT="${@}"

# Auto generate the password.
SPECIAL_CHARACTER=$(echo '!@#$%^&*()_+=' | fold -w1 | shuf | head -c1)
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
echo "${PASSWORD}$SPECIAL_CHARACTER"

# Create the account. Put ${COMMENT} in "" so they will be treated as one thing
useradd -c "${COMMENT}" -m ${USER_NAME}

# Check to see if the useradd command succeeded.
# We don't want to tell the user that an account was created when it hasn't been.
if [[ "${?}" -ne 0 ]]
then
  echo 'The account could not be created.'
  exit 1
fi

# Set the password (centos/rhel)
#echo ${PASSWORD} | passwd --stdin ${USER_NAME}

# Set the password (Ubuntu)
echo "${USER_NAME}: ${PASSWORD}" | sudo chpasswd


# Check to see if the passwd command succeeded.
if [[ "${?}" -ne 0 ]]
then
  echo 'The password for the account could not be set.'
  exit 1
fi

# Force password change on first login.
passwd -e ${USER_NAME}

# Display the username, password, and the host where the user was created.
echo
echo 'username:'
echo "${USER_NAME}"
echo
echo 'password:'
echo "${PASSWORD}"
echo
echo 'host:'
echo "${HOSTNAME}"
exit 0
