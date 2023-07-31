#!/bin/bash

mkdir -p /usr/local/src/kibana

cd /usr/local/src/kibana && wget https://github.com/vigneshvrm/Workout/raw/main/Marketplaceapps/kibana/kibana-cleanup.sh

cd /usr/local/src/kibana && wget https://github.com/vigneshvrm/Workout/raw/main/Marketplaceapps/kibana/kibana.yml

cd /usr/local/src/kibana && wget https://github.com/vigneshvrm/Workout/raw/main/Marketplaceapps/kibana/30-elasticsearch-output.conf