#!/bin/bash

#Sys Update
sudo printf "Root password:\n"

printf "\nUpdating and upgrading \n\n"
sleep 5
sudo apt-get update
sleep 5
printf "\napt-get update complete\n"
sleep 5
printf "\nStarting apt-get upgrade\n"
sleep 5
sudo apt-get upgrade 
sleep 5
printf "\napt-get upgrade complete\n"


printf "\nCreating directory to link to nginx volume\n\n"
sudo mkdir /usr/share/nginx/html/
wget -P /usr/share/nginx/html/ https://raw.githubusercontent.com/trojan-xs/static-hello/main/index.html
sudo mkdir /var/lib/docker/volumes/ngx-proxy/letsencrypt
sudo mkdir /var/lib/docker/volumes/ngx-proxy/data
sleep 5
printf "\nDirectories mapped\n"
sleep 3


### Saves install.sh script to .bashrc on login ###

# Get the current working directory
current_dir=$(pwd)

# Get the username
current_user=$(whoami)

# Define the path to the script file
script_file="$current_dir/install.sh"

# Check if the script file exists
if [ -f "$script_file" ]; then
    # Backup the existing .bashrc as .bashrc.original
    if [ "$current_user" = "root" ]; then
        bashrc_backup="/root/.bashrc.original"
        echo "Backing up existing .bashrc to $bashrc_backup"
        cp "/root/.bashrc" "$bashrc_backup"
    else
        bashrc_backup="/home/$current_user/.bashrc.original"
        echo "Backing up existing .bashrc to $bashrc_backup"
        cp "/home/$current_user/.bashrc" "$bashrc_backup"
    fi

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


#Restart

printf "\nServer rebooting. Continuing install on terminal login after reboot\n"
sleep 5
printf "\nServer Rebooting. Press Ctrl C to abort\n"
sleep 5
echo Rebooting
sleep 3
sudo reboot
