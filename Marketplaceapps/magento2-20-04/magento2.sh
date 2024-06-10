#!/bin/bash

mkdir -p {/usr/local/src/magento2-20-04/etc/apache2/sites-available/,/usr/local/src/magento2-20-04/etc/letsencrypt/,/usr/local/src/magento2-20-04/var/www/html/,/usr/local/src/magento2-20-04/var/www/.config/composer/,/usr/local/src/magento2-20-04/opt/cloudstack/,/usr/local/src/magento2-20-04/,/usr/local/src/magento2-20-04/opt/ssl_config/}

cd /usr/local/src/magento2-20-04/etc/apache2/sites-available/ && wget https://raw.githubusercontent.com/stackbill/marketplace/main/_common-files/etc/apache2/sites-available/magento2.conf

cd /usr/local/src/magento2-20-04/etc/apache2/sites-available/ && wget https://raw.githubusercontent.com/stackbill/marketplace/main/_common-files/etc/apache2/sites-available/magento2-ssl.conf

cd /usr/local/src/magento2-20-04/etc/letsencrypt/ && wget https://raw.githubusercontent.com/stackbill/marketplace/main/_common-files/etc/letsencrypt/options-ssl-apache.conf

cd /usr/local/src/magento2-20-04/var/www/html/ && wget https://raw.githubusercontent.com/stackbill/marketplace/main/_common-files/var/www/html/index.html

cd /usr/local/src/magento2-20-04/var/www/.config/composer/ && wget https://raw.githubusercontent.com/stackbill/marketplace/main/_common-files/var/www/.config/composer/auth.json

cd /usr/local/src/magento2-20-04/opt/cloudstack/ && wget https://raw.githubusercontent.com/stackbill/marketplace/main/_common-files/opt/cloudstack/auth.json-def

cd /usr/local/src/magento2-20-04/opt/cloudstack/ && wget https://raw.githubusercontent.com/stackbill/marketplace/main/_common-files/opt/cloudstack/magento2-cleanup.sh

cd /usr/local/src/magento2-20-04/opt/cloudstack/ && wget https://raw.githubusercontent.com/stackbill/marketplace/main/_common-files/opt/cloudstack/update_config.php

cd /usr/local/src/magento2-20-04/opt/ssl_config/ && wget https://raw.githubusercontent.com/stackbill/marketplace/main/_common-files/opt/ssl_config/ssl.sh

cd /usr/local/src/magento2-20-04/ && wget https://raw.githubusercontent.com/vigneshvrm/Workout/main/Marketplaceapps/magento2-20-04/composer.sh

cd /usr/local/src/magento2-20-04/ && wget https://raw.githubusercontent.com/vigneshvrm/Workout/main/Marketplaceapps/magento2-20-04/magento2.yaml