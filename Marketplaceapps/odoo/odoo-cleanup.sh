#!/bin/bash

RED='\033[1;31m'
NC='\033[0m'

echo -e "${RED}
################################################################################################################
#                              Your MarketPlace App has been deployed successfully!                            #
#                                 Passwords are stored under /root/                                            #
#                                 Please spend 2 minutes for configuration                                     #
#                              Kindly update the below configuration to complete the setup                     #
################################################################################################################
${NC}"

echo
echo -e "${RED}This message will be removed in the next login!${NC}"
echo
echo

# Get the Domain Name from the client
a=0
while [ $a -eq 0 ]
do
 echo -e "${RED}To cancel setup, press Ctrl+C.  This script will run again on your next login:${NC}"
 echo -e "${RED}Enter the domain name for your new odoo site:${NC}"
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

# Replace the domain name "odoo.domian.com" in the odoo.conf file 
sed -i "s/odoo.domain.com/$dom/g" /etc/odoo/odoo.conf

# Reload the Nginx service
nginx -s reload

# Install SSL for the domian name
certbot --nginx --non-interactive --redirect  -d $dom --agree-tos --email admin@$dom
