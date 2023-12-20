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


### Saves install.sh script to .bashrc on login ###

# Get the current working directory
current_dir=$(pwd)

# Get the username
current_user=$(whoami)

# Define the path to the script file
script_file="$current_dir/2install.sh"

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

sudo reboot
