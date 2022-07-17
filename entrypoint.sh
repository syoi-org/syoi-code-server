#!/bin/bash

# exit on error
set -e

# set username
groupmod -n $SERVER_USER $(id -ng 1000)
usermod -l $SERVER_USER $(id -nu 1000)
sed -i "s/coder/$SERVER_USER/g" /etc/supervisor/supervisord.conf

# change home directory
usermod -d /home/$SERVER_USER -m $SERVER_USER

# run supervisord
exec supervisord -c /etc/supervisor/supervisord.conf
