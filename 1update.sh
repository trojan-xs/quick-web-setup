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


### Add cron script to call install bashrc after reboot ###

# Get the current working directory
current_dir=$(pwd)

# Get the username
current_user=$(whoami)

# Define the path to the script file
script_file="$current_dir/2install.sh"

# Check if the script file exists
if [ -f "$script_file" ]; then
    # Append the script execution line to the user's .bashrc
    if [ "$current_user" = "root" ]; then
        echo "/bin/bash $script_file" >> "/root/.bashrc"
        echo "Script execution line appended to .bashrc for root user"
    else
        echo "/bin/bash $script_file" >> "/home/$current_user/.bashrc"
        echo "Script execution line appended to .bashrc for user: $current_user"
    fi
else
    echo "Script file not found: $script_file"
fi













# Get the full working path
working_path=$(pwd)
script_path="$working_path/1install.sh"

# Add the script to crontab
(crontab -l ; echo "/bin/bash $script_path") | crontab -

#Reboot the server
printf "\nServer install finished\n"
printf "Rebooting"
sleep 3

sudo reboot




