#!/bin/bash

RED='\033[1;31m'
NC='\033[0m'

echo -e "${RED}
################################################################################################################
#                              Your MarketPlace App has been deployed successfully!                            #
#                                 Passwords are stored under /root/                                            #
################################################################################################################
${NC}"

echo
echo -e "${RED}This message will be removed in the next login!${NC}"
echo
echo
#To Install The Jistmeet
a=0
while [ $a -eq 0 ]
do
 echo -e "${RED}Enter the domain name for your new Jitsi Meet site:${NC}"
 echo -e "${RED}(ex. example.org or test.example.org) do not include www or http/s:${NC}"
 read -p "Domain/Subdomain name: " dom
 if [ -z "$dom" ]
 then
  a=0
  echo -e "${RED}Please provide a valid domain or subdomain name to continue to press Ctrl+C to cancel${NC}"
 else
  a=1
fi
done

hostnamectl set-hostname  $dom

sudo sed -i -e "/127\.0\.0\.1/s/^/# /" -e "/127\.0\.1\.1/s/^/# /" /etc/hosts

echo "127.0.0.1 $dom" | sudo tee -a /etc/hosts
echo "127.0.1.1 $dom" | sudo tee -a /etc/hosts


dpkg-reconfigure jitsi-videobridge2
dpkg-reconfigure jitsi-meet-web         
dpkg-reconfigure jitsi-meet-web-config  
dpkg-reconfigure jitsi-meet             
dpkg-reconfigure jitsi-meet-prosody     
dpkg-reconfigure jitsi-meet-turnserver  
sudo sed -i '/server_names_hash_bucket_size/s/^/#/' /etc/nginx/sites-enabled/$dom

 certbot --nginx --non-interactive --redirect  -d $dom --agree-tos --register-unsafely-without-email

sudo sed -i '/server_names_hash_bucket_size/s/^#//' /etc/nginx/sites-enabled/$dom

#Cleanup script
rm -rf /usr/local/src/
mkdir -p /usr/local/src/
rm -rf /var/lib/cloud/instances/*
rm -rf /var/lib/cloud/data/*
find /var/log -mtime -1 -type f -exec truncate -s 0 {} \; >/dev/null 2>&1
rm -rf /var/log/*.gz /var/log/*.[0-9] /var/log/*-????????
cat /dev/null > /var/log/lastlog; cat /dev/null > /var/log/wtmp
apt-get -y autoremove >/dev/null 2>&1
apt-get -y autoclean >/dev/null 2>&1
history -c
cat /dev/null > /root/.bash_history
unset HISTFILE

rm -rf /root/.bashrc
cp /etc/skel/.bashrc /root
rm -rf /opt/cloudstack