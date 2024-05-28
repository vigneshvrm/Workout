#!/bin/bash

mkdir -p /usr/local/src/grafana

cd /usr/local/src/grafana && wget https://raw.githubusercontent.com/stackbill/marketplace/main/grafana/grafana-cleanup.sh

cd /usr/local/src/grafana && wget https://raw.githubusercontent.com/stackbill/marketplace/main/grafana/grafana.yaml