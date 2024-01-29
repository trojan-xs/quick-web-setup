#!/bin/bash

#wget -O - https://install.squing.us | bash
# Default GitHub repository placeholder
github_repo="https://github.com/trojan-xs/static-hello"

# Check if a GitHub repo argument is provided
if [ "$#" -eq 1 ]; then
    github_repo="$1"
fi
#Default values
skip_update="no"
reboot_flag="yes"
get_tools="yes"
cf_flag="no"
continue="no"
tunnel_id=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -su|--update)
            skip_update="yes"
            shift
            ;;
        -nr|--no-reboot)
            reboot_flag="no"
            shift
            ;;
        -nt|--no-tools)
            get_tools="no"
            shift
            ;;
        -cf|--cf-tunnel)
            cf_flag="" ###Work in progress
            shift 2
            ;;
        -c|--continue)
            continue="yes"
            shift
            ;;
        -id|--cf-id)
            continue="yes"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

check.sudo(){
    printf "Root password:\n"
    sudo echo
}



#Sys Update
sys.update() {
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
}


#Create Volumes
make.dir() {
printf "\nCreating directory to link to nginx volume\n\n"
sudo mkdir -p /usr/share/nginx/html/
sudo git clone $github_repo /usr/share/nginx/html/

if [ "$cf_flag" = "no" ]; then
sudo mkdir -p /var/lib/docker/volumes/ngx-proxy/letsencrypt
sudo mkdir -p /var/lib/docker/volumes/ngx-proxy/data
printf "\nNginx Proxy volumes created\n"
else
    printf "\nNginx proxy volumes skipped\n"
fi
sleep 1
printf "\nDirectories mapped\n"
sleep 3
}


backup.bashrc(){
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
        echo "/bin/bash $script_file -c" >> "/root/.bashrc"
        echo "Script execution line appended to .bashrc for root user"
    else
        echo "/bin/bash $script_file -c" >> "/home/$current_user/.bashrc"
        echo "Script execution line appended to .bashrc for user: $current_user"
    fi
else
    echo "Script file not found: $script_file"
fi
}



#Restart
sys.restart() {
printf "\nServer rebooting. Login with same user after reboot to continue install\n"
sleep 2
printf "\nServer Rebooting. Press Ctrl C to abort\n"
sleep 5
echo Rebooting
sleep 5
sudo reboot
}



#Installing tools
install.tools(){
sleep 2
printf "\nInstaling tools \n\n"
sleep 3
sudo apt install -y curl git net-tools screen nmap
}

#Installing docker
install.docker(){
printf "\nInstalling docker \n\n"
sleep 3
sudo apt install -y docker.io
}

#Pulling images
pull.images(){
printf "\nPulling images\n\n"
sleep 3
#sudo docker pull portainer/portainer-ce:latest
printf "\nPulled Portainer\n"

#sudo docker pull nginx:latest
printf "\nPulled Nginx\n"


if [ "$cf_flag" = "yes" ]; then
    #sudo docker pull cloudflare/cloudflared:latest
    printf "\nPulled Cloudflared\n"
else
    #sudo docker pull jc21/nginx-proxy-manager:latest
    printf "\nPulled Nginx proxy\n"

fi
}


#Start machines
spin.up(){
printf "\nSpinning up machines\n"
sleep 3
#sudo docker run -d -p 8080:80 --name nginx --restart=always -v /usr/share/nginx/html/:/usr/share/nginx/html nginx:latest
printf "\nStarted Nginx\n"

#sudo docker run -d -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
printf "\nStarted Portainer"

if [ "$cf_flag" = "yes" ]; then
    #sudo docker run -d --name CF-ZTNAA cloudflare/cloudflared:latest tunnel --no-autoupdate run --token $tunnel_id
    printf "\nStarted Cloudflared"
else
    #sudo docker run -d -p 80:80 -p 443:443 -p 81:81 --name ngx-proxy --restart=always -v /var/lib/docker/volumes/ngx-proxy/data:/data -v /var/lib/docker/volumes/ngx-proxy/letsencrypt:/etc/letsencrypt jc21/nginx-proxy-manager:latest 
    printf "\nStarted Nginx Proxy"
fi
}


### Clearing bashrc ###
bashrc.clear(){
printf "\nClearing bashrc\n"
sleep 3
# Get the username
current_user=$(whoami)

# Determine the home directory based on the user
if [ "$current_user" = "root" ]; then
    home_directory="/root"
else
    home_directory="/home/$current_user"
fi

# Define the paths
bashrc_file="$home_directory/.bashrc"
bashrc_backup="$home_directory/.bashrc.original"

# Check if .bashrc.original backup exists
if [ -f "$bashrc_backup" ]; then
    # Backup exists, delete current .bashrc and rename .bashrc.original
    rm "$bashrc_file"
    mv "$bashrc_backup" "$bashrc_file"
    printf "\nRestored .bashrc from backup.\n"
else
    # Backup does not exist
    printf "\nNo .bashrc.original backup found. No changes made.\n"
fi
}



#Instructions
print.instructions(){
localhost_ip=$(hostname -I)
echo "Your IP is $localhost_ip"
printf """\n
## Docker port mappings ##

Nginx: :8080
Proxy admin: $localhost_ip:81
Portainer: $localhost_ip:9443


Nginx First time login:
Email:    admin@example.com
Password: changeme\n\n
Good bye!
"""
}



start(){
if [ "$continue" = "no" ]; then
    run
else
    resume
fi
}


run(){
if [ "$skip_update" = "no" ]; then
    sys.update
    if [ "$get_tools" = "yes" ]; then
    install.tools
else
    printf "\ncurl git net-tools screen nmap not installed\n"

fi
    make.dir
    backup.bashrc
    sys.restart
else
    printf "\nNo-update option chosen, skipping update\n"
    make.dir
    install.docker
    pull.images
    spin.up
    print.instructions
fi
}

resume(){
if [ "$continue" = "yes" ]; then
     install.docker
    pull.images
    spin.up
    print.instructions
else
    echo Hi!
fi
}









run



#####To do: ####
<<COMMENT
Fix cloudflared string parsing
Fix check.sudo logic
Fix run and resume function logic


Make it pretty
Write proper comments

COMMENT