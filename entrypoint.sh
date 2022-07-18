#!/bin/bash

# exit on error
set -e

# set username
echo "Setting username..."
groupmod -n $SERVER_USER $(id -ng 1000)
usermod -l $SERVER_USER $(id -nu 1000)
sed -i "s/coder/$SERVER_USER/g" /etc/supervisor/supervisord.conf

# change home directory
echo "Changing home directory for $SERVER_USER..."
mkdir -p /home/$SERVER_USER
chown $SERVER_USER:$SERVER_USER /home/$SERVER_USER
usermod -d /home/$SERVER_USER $SERVER_USER

# boostrap home directory
if [ -d /home/$SERVER_USER/.config ] || [ ! -f /home/$SERVER_USER/.config/.bootstrap ]; then
    echo "Bootstrapping home directory..."
    rsync -aA /home/.bootstrap/ /home/$SERVER_USER/
    mkdir -p /home/$SERVER_USER/.config
    chown $SERVER_USER:$SERVER_USER /home/$SERVER_USER/.config
    touch /home/$SERVER_USER/.config/.bootstrap
fi

# run supervisord
exec supervisord -c /etc/supervisor/supervisord.conf
