#!/bin/bash

# This won't be executed if keys already exist (i.e. from a volume)
ssh-keygen -A

# Copy authorized keys from ENV variable
echo -e $AUTHORIZED_KEYS >>$AUTHORIZED_KEYS_FILE

# Chown data folder (if mounted as a volume for the first time)
chown data:data /home/data

if [ ! -z $SCP_USER ];
then
  chown $SCP_USER /authorized_keys
  chown $SCP_USER ~$SCP_USER
  usermod --shell=/usr/bin/rssh $SCP_USER 
fi

# Run sshd on container start
exec /usr/sbin/sshd -D -e
