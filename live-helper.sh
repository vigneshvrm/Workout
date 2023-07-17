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
echo -e "${RED}Use the Below Password for logging into MySQL${NC}"
echo
cat /root/.mysql_root_pass
echo
echo -e "${RED}Use the Below Password for logging into lhc${NC}"
echo
cat /root/.lhc_db_pass
echo
echo "--------------------------------------------------"
echo "This setup requires a domain name.  If you do not have one yet, you may"
echo "cancel this setup, press Ctrl+C.  This script will run again on your next login"
echo "--------------------------------------------------"
echo "Enter the domain name for your new Live Helper Chat site."
echo "(ex. example.org or test.example.org) do not include www or http/s"
echo "--------------------------------------------------"
a=0
while [ $a -eq 0 ]
do
 read -p "Domain/Subdomain name: " dom
 if [ -z "$dom" ]
 then
  a=0
  echo "Please provide a valid domain or subdomain name to continue to press Ctrl+C to cancel"
 else
  a=1
fi
done
sed -i "s/demo.livehelperchat.com/$dom/g"  /etc/nginx/conf.d/livehelperchat.conf

echo -en "Now we will create your new admin user account for Live Helper Chat."

function lhc_admin_account(){

  while [ -z $email ]
  do
    echo -en "\n"
    read -p "Your Email Address: " email
  done

  while [ -z $username ]
  do
    echo -en "\n"
    read -p  "Username: " username
  done

  while [ -z $pass ]
  do
    echo -en "\n"
    read -s -p "Password: " pass
    echo -en "\n"
  done

  while [ -z "$department" ]
  do
    echo -en "\n"
    read -p "Default department title: " department
  done
}

lhc_admin_account

while true
do
    echo -en "\n"
    read -p "Is the information correct? [Y/n] " confirmation
    confirmation=${confirmation,,}
    if [[ "${confirmation}" =~ ^(yes|y)$ ]] || [ -z $confirmation ]
    then
      break
    else
      unset email username pass department confirmation
      lhc_admin_account
    fi
done

echo -en "\n\n\n"
echo "Next, you have the option of configuring LetsEncrypt to secure your new site. Before doing this, be sure that you have pointed your domain or subdomain to this server's IP address. You can also run LetsEncrypt certbot later with the command 'certbot --nginx'"
echo -en "\n\n\n"

while true; do
 read -p "Would you like to use LetsEncrypt (certbot) to configure SSL(https) for your new site? (y/n): " yn
    case $yn in
        [Yy]* ) certbot --nginx; echo "Live Helper Chat has been enabled at https://$dom/site_admin Please open this URL in a browser to complete the setup of your site.";break;;
        [Nn]* ) echo "Skipping LetsEncrypt certificate generation";break;;
        * ) echo "Please answer y or n.";;
    esac
done

echo "Finalizing installation..."

echo -en "Completing the configuration of Live Helper Chat."

# populate the Live Helper Chat config file with user variables

sed -e "s/default_username/$username/g" \
    -e "s/default_password/$pass/g" \
    -e "s/default_email/$email/g" \
    -e "s/default_departament/$department/g" \
    -e "s/domain_name_here/$dom/g" \
    -i /var/www/html/settings.ini

# Finish installation
cd /var/www/html/ && php install-cli.php /var/www/html/settings.ini


# Start NodeJS Helper server
systemctl restart nodejshelper
systemctl enable nodejshelper

# Start Co-Browsing server
systemctl restart nodejscobrowser

#Cleanup script
rm -rf /usr/local/src/
mkdir -p /usr/local/src/
rm -rf /var/lib/cloud/instances/*
rm -rf /var/lib/cloud/data/*
find /var/log -mtime -1 -type f -exec truncate -s 0 {} \;
rm -rf /var/log/*.gz /var/log/*.[0-9] /var/log/*-????????
cat /dev/null > /var/log/lastlog; cat /dev/null > /var/log/wtmp
apt-get -y autoremove >/dev/null 2>&1
apt-get -y autoclean >/dev/null 2>&1
cat /dev/null > /root/.bash_history
unset HISTFILE
rm -rf /root/.bashrc
cp /etc/skel/.bashrc /root
rm -rf /opt/cloudstack
history -c

echo "Installation complete. Access your new Live Helper Chat site in a browser to continue. Admin URL $dom/site_admin/ or just http://<server_ip>/site_admin/"
