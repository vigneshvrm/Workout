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

echo "jitsi-videobridge jitsi-videobridge/jvb-hostname $dom" | debconf-set-selections
echo "jitsi-meet-web-config jitsi-meet/cert-choice select 'Generate a new self-signed certificate (You will later get a chance to obtain a Let's encrypt certificate)'" | debconf-set-selections

apt install jitsi-meet

certbot --nginx --non-interactive --redirect  -d $dom


private=$(hostname -I)
public=$(curl https://api.ipify.org)

echo "org.ice4j.ice.harvest.NAT_HARVESTER_LOCAL_ADDRESS=$private" >> /etc/jitsi/videobridge/sip-communicator.properties
echo "org.ice4j.ice.harvest.NAT_HARVESTER_PUBLIC_ADDRESS=$public" >> /etc/jitsi/videobridge/sip-communicator.properties


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