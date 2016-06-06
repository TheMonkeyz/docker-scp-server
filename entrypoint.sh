#!/bin/bash

# This won't be executed if keys already exist (i.e. from a volume)
ssh-keygen -A

# Copy authorized keys from ENV variable
echo $AUTHORIZED_KEYS | base64 -d >>$AUTHORIZED_KEYS_FILE

# Chown data folder (if mounted as a volume for the first time)
chown data:data /home/data

if [ -z $SCP_USER ];
then
  chown $SCP_USER /authorized_keys
  usermod --shell /usr/bin/rssh 
fi

# Run sshd on container start
exec /usr/sbin/sshd -D -e
