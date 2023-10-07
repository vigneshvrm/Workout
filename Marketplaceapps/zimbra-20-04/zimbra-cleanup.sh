/bin/bash

RED='\033[1;31m'
NC='\033[0m'

echo -e "${RED}
################################################################################################################
#                              Your MarketPlace App has been deployed successfully!                            #
#                                 Passwords are stored under /root/                                            #
################################################################################################################
${NC}"
pass=$(pwgen -ys 12 1)
echo $pass > /root/.Zimbraadmin
echo
echo -e "${RED}This message will be removed in the next login!${NC}"
echo
echo
echo -e "${RED}The Zimbra Password is $(cat /root/.Zimbraadmin)"
echo
echo


#To replace the Domain Name in the Zimbra configuration 
a=0
while [ $a -eq 0 ]
do
 echo -e "${RED}To cancel setup, press Ctrl+C.  This script will run again on your next login:${NC}"
 echo -e "${RED}Enter the domain name for your new Kibana site:${NC}"
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
# Prompt the user for the server timezone
read -p "Enter the server timezone (e.g., 'America/New_York'): " user_timezone
echo
echo
echo -e "${RED}Kindly wait till the Zimbra installation is completed${NC}"
echo
echo
/usr/local/src/zimbra/zinstaller -p $pass -n mail -t $user_timezone $dom 
echo
echo
echo -e "${RED}The zimbra installation is completed${NC}"
echo
echo

# #Cleanup script
# rm -rf /usr/local/src/
# mkdir -p /usr/local/src/
# rm -rf /var/lib/cloud/instances/*
# rm -rf /var/lib/cloud/data/*
# find /var/log -mtime -1 -type f -exec truncate -s 0 {} \; >/dev/null 2>&1
# rm -rf /var/log/*.gz /var/log/*.[0-9] /var/log/*-????????
# cat /dev/null > /var/log/lastlog; cat /dev/null > /var/log/wtmp
# apt-get -y autoremove >/dev/null 2>&1
# apt-get -y autoclean >/dev/null 2>&1
# cat /dev/null > /root/.bash_history
# unset HISTFILE
# rm -rf /root/.bashrc
# cp /etc/skel/.bashrc /root
# rm -rf /opt/zimbra
# history -c
