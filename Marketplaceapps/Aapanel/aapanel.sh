#!/bin/bash

mkdir -p /usr/local/src/Aapanel

apt install wget -y

cd /usr/local/src/Aapanel && wget https://github.com/vigneshvrm/Workout/raw/main/Marketplaceapps/Aapanel/Aapanel-cleanup.sh

cd /usr/local/src/Aapanel && wget https://github.com/vigneshvrm/Workout/raw/main/Marketplaceapps/Aapanel/aapanel.yaml

