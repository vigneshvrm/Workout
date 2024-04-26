#!/bin/bash

mkdir -p /usr/local/src/nextcloud

cd /usr/local/src/nextcloud && wget https://raw.githubusercontent.com/vigneshvrm/Workout/main/Marketplaceapps/nextcloud/nextcloud.yaml
cd /usr/local/src/nextcloud && wget https://raw.githubusercontent.com/vigneshvrm/Workout/main/Marketplaceapps/nextcloud/nextcloud.conf
cd /usr/local/src/nextcloud && wget https://raw.githubusercontent.com/vigneshvrm/Workout/main/Marketplaceapps/nextcloud/nextcloud-cleanup.sh