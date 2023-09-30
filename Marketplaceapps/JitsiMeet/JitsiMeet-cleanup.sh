#!/bin/bash

RED='\033[1;31m'
NC='\033[0m'

echo -e "${RED}
################################################################################################################
#                              Your MarketPlace App will be deployed Shortly!                            #
################################################################################################################
${NC}"

echo
echo -e "${RED}This message will be removed in the next login!${NC}"
echo
echo
sleep 10

#To Install The Jistmeet


apt-get -y install jicofo jitsi-meet jitsi-meet-prosody jitsi-meet-turnserver jitsi-meet-web jitsi-meet-web-config > /dev/null 2>&1
apt-get -y jitsi-videobridge2

bash /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh

systemctl restart prosody
systemctl restart jicofo
systemctl restart jitsi-videobridge2
systemctl restart jitsi-meet-web

dom=$(grep -oP 'server_name \K[^;]+' /etc/nginx/sites-enabled/*.conf | head -1)

hostnamectl set-hostname  $dom > /dev/null 2>&1

sudo sed -i -e "/127\.0\.0\.1/s/^/# /" -e "/127\.0\.1\.1/s/^/# /" /etc/hosts > /dev/null 2>&1

echo "127.0.0.1 $dom" | sudo tee -a /etc/hosts > /dev/null 2>&1
echo "127.0.1.1 $dom" | sudo tee -a /etc/hosts > /dev/null 2>&1

public_ip=$(curl -s ifconfig.me)
private_ip=$(hostname -I | awk '{print $1}')

echo "org.ice4j.ice.harvest.NAT_HARVESTER_LOCAL_ADDRESS={{ private_ip.stdout }}" >> /etc/jitsi/videobridge/sip-communicator.properties
echo "org.ice4j.ice.harvest.NAT_HARVESTER_PUBLIC_ADDRESS={{ public_ip.stdout }}" >> /etc/jitsi/videobridge/sip-communicator.properties

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