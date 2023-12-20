#!/bin/bash

#Sys Update
sudo printf "Root password:\n"

printf "Updating and upgrading \n\n"
sudo apt-get update
sudo apt-get upgrade 

printf "Creating directory to link to nginx volume\n\n"
sudo mkdir /usr/share/nginx/html/
wget -P /usr/share/nginx/html/ https://raw.githubusercontent.com/trojan-xs/static-hello/main/index.html
sudo mkdir /var/lib/docker/volumes/ngx-proxy/letsencrypt
sudo mkdir /var/lib/docker/volumes/ngx-proxy/data


### Add cron script to call install script after reboot ###

# Get the full working path
working_path=$(pwd)
script_path="$working_path/2install.sh"

# Add the script to crontab
(crontab -l ; echo "@reboot $script_path") | crontab -

#Reboot the server
printf "\nServer install finished\n"
printf "Rebooting"
sleep 3

sudo reboot




