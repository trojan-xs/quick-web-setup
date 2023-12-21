#!/bin/bash

# Receive the GitHub repo as an argument
github_repo="$1"


#Sys Update
printf "Root password:\n"
sudo echo

printf "\nUpdating and upgrading \n\n"
sleep 2
sudo apt-get update -y
sleep 2
printf "\napt-get update complete\n"

sleep 2
printf "\nStarting apt-get upgrade\n"
sleep 2
sudo apt-get upgrade -y
sleep 2
printf "\napt-get upgrade complete\n"


printf "\nCreating directory to link to nginx volume\n\n"
sudo mkdir -p /usr/share/nginx/html/
sudo git clone $github_repo /usr/share/nginx/html/
sudo mkdir -p /var/lib/docker/volumes/ngx-proxy/letsencrypt
sudo mkdir -p /var/lib/docker/volumes/ngx-proxy/data
sleep 2
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

printf "\nServer rebooting. Login with same user after reboot to continue install\n"
sleep 2
printf "\nServer Rebooting. Press Ctrl C to abort\n"
sleep 5
echo Rebooting
sleep 5
sudo reboot