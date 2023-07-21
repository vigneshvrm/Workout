#!/bin/bash

mkdir -p /usr/local/src/Aapanel

cd /usr/local/src/Aapanel && cat << 'EOF' > install_aapanel.exp
#!/usr/bin/expect
set timeout -1
spawn sudo bash /usr/local/src/install-ubuntu_6.0_en.sh
expect "Do you want to install aaPanel to the /www directory now?(y/n):"
send "y\r"
expect "Do you need to enable the panel SSl ? (yes/n):"
send "yes\r"
expect eof
EOF

cd /usr/local/src/Aapanel && wget https://github.com/vigneshvrm/Workout/raw/main/Marketplaceapps/Aapanel/Aapanel-cleanup.sh

cd /usr/local/src/Aapanel && wget https://github.com/vigneshvrm/Workout/raw/main/Marketplaceapps/Aapanel/aapanel.yml