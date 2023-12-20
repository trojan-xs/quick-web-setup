#!/bin/bash

#clearing bashrc







#Installing tools
printf "Instaling tools \n\n"
sudo apt install curl git net-tools screen nmap

printf "Installing docker \n\n"
sudo apt install docker.io


#Pulling images
printf "Pulling images\n\n"
sudo docker pull jc21/nginx-proxy-manager:latest
sudo docker pull portainer/portainer-ce:latest
sudo docker pull nginx:latest

#Start machines
printf "Spinning up machines"
sudo docker run -d -p 8080:80 --name nginx --restart=always -v /usr/share/nginx/html/:/usr/share/nginx/html nginx:latest
sudo docker run -d -p 80:80 -p 443:443 -p 81:81 --name ngx-proxy --restart=always -v /var/lib/docker/volumes/ngx-proxy/data:/data -v /var/lib/docker/volumes/ngx-proxy/letsencrypt:/etc/letsencrypt jc21/nginx-proxy-manager:latest 
sudo docker run -d -p 9443:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest

#Instructions
printf """\n
Nginx: localhost:8080

Proxy admin: localhost:81

Portainer: localhost:9443

"""

printf """
Nginx First time login:
Email:    admin@example.com
Password: changeme\n\n
Good luck
"""

