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

# echo -e "${RED}Enter the domain name for your new Jitsi Meet site:${NC}"
# echo -e "${RED}(ex. example.org or test.example.org) do not include www or http/s:${NC}"

# dpkg-reconfigure jitsi-videobridge2
# dpkg-reconfigure jicofo  > /dev/null 2>&1
# dpkg-reconfigure jitsi-meet-web         > /dev/null 2>&1
# dpkg-reconfigure jitsi-meet-web-config  > /dev/null 2>&1
# dpkg-reconfigure jitsi-meet             > /dev/null 2>&1
# dpkg-reconfigure jitsi-meet-prosody     > /dev/null 2>&1
# dpkg-reconfigure jitsi-meet-turnserver  > /dev/null 2>&1


# rm -Rf /etc/nginx/sites-enabled/meet.domain.com.conf



# echo -e "${RED}Kindly wait while the Jitsi Meet re-configure based on the domain!${NC}"

apt-get -y install jicofo jitsi-meet jitsi-meet-prosody jitsi-meet-turnserver jitsi-meet-web jitsi-meet-web-config jitsi-videobridge2

bash /usr/share/jitsi-meet/scripts/install-letsencrypt-cert.sh

# update prosody to use internal user management
for f in /etc/prosody/conf.avail/*.cfg.lua; do
    # ignore default prosody configuration files
        if [[ "$f" == */example.com.cfg.lua ]] || [[ "$f" == */jaas.cfg.lua ]] || [[ "$f" == */localhost.cfg.lua ]]; then
                continue
        fi
        printf "processing prosody conf file: ${f}\n"
        sed -i "s/authentication = \".*\"/authentication=\"internal_hashed\"/g" $f;
done

systemctl restart prosody
systemctl restart jicofo
systemctl restart jitsi-videobridge2
systemctl restart jitsi-meet-web

dom=$(grep -oP 'server_name \K[^;]+' /etc/nginx/sites-enabled/*.conf | head -1)

hostnamectl set-hostname  $dom > /dev/null 2>&1

sudo sed -i -e "/127\.0\.0\.1/s/^/# /" -e "/127\.0\.1\.1/s/^/# /" /etc/hosts > /dev/null 2>&1

echo "127.0.0.1 $dom" | sudo tee -a /etc/hosts > /dev/null 2>&1
echo "127.0.1.1 $dom" | sudo tee -a /etc/hosts > /dev/null 2>&1

# sudo sed -i '/server_names_hash_bucket_size/s/^/#/' /etc/nginx/sites-enabled/$dom.conf > /dev/null 2>&1

# certbot --nginx --non-interactive --redirect  -d $dom --agree-tos --register-unsafely-without-email > /dev/null 2>&1

# sudo sed -i '/server_names_hash_bucket_size/s/^#//' /etc/nginx/sites-enabled/$dom.conf > /dev/null 2>&1

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