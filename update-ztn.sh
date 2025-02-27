#!/bin/bash

#configuration file
FIREWALLD_FILE="/etc/firewalld/zones/trusted.xml"

# Create the trusted.xml file with firewall configuration
cat <<EOF | tee "$FIREWALLD_FILE"
<?xml version="1.0" encoding="utf-8"?>
<zone target="ACCEPT">
  <short>Trusted</short>
  <description>All network connections are accepted.</description>
  <source address="172.31.252.1"/>
  <source address="172.31.252.2"/>
</zone>
EOF

# Define the configuration file path
ZTN_CONFIG_FILE="/etc/ztn/config.yaml"

# Append the required configuration to /etc/ztn/config.yaml
echo -e "    - port: 80\n      proto: tcp\n      groups:\n        - ssh" | tee -a "$ZTN_CONFIG_FILE"

echo -e "    - port: 443\n      proto: tcp\n      groups:\n        - ssh" | tee -a "$ZTN_CONFIG_FILE"

echo -e "    - port: 9090\n      proto: tcp\n      groups:\n        - ssh" | tee -a "$ZTN_CONFIG_FILE"

# Restart firewalld to apply changes
systemctl restart firewalld ztn

