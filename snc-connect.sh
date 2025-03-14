#!/bin/bash

# Function to check the OS type
check_os() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$ID
    else
        echo "Cannot determine OS."
        exit 1
    fi
}


# Function to install and configure Cockpit on Ubuntu/Debian
install_ubuntu_debian() {
    sudo apt update
    sudo apt install -y cockpit cockpit-pcp
    sudo systemctl start cockpit
    sudo systemctl enable cockpit
    ######custum Port########
    sudo mkdir -p /etc/systemd/system/cockpit.socket.d
    echo -e "[Socket]\nListenStream=5146" | sudo tee /etc/systemd/system/cockpit.socket.d/listen.conf
    sudo systemctl restart cockpit
    
    sudo ufw allow 9090
    sudo firewall-cmd --zone=public --add-port=80/udp --permanent
    sudo firewall-cmd --zone=public --add-port=9090/udp --permanent
    sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
    sudo firewall-cmd --zone=public --add-port=9090/tcp --permanent
    sudo firewall-cmd --reload
    echo "######## Accessing  #######"
    echo "http://localhost:9090 in your web browser"
}

# Function to install and configure Cockpit on CentOS/RHEL
install_centos_rhel() {
    sudo yum update -y
    sudo yum install -y cockpit
    sudo systemctl start cockpit.socket
    sudo systemctl enable cockpit.socket
    ######custum Port########
    sudo mkdir -p /etc/systemd/system/cockpit.socket.d
    echo -e "[Socket]\nListenStream=5146" | sudo tee /etc/systemd/system/cockpit.socket.d/listen.conf
    sudo systemctl restart cockpit
    
    sudo firewall-cmd --zone=public --add-port=80/udp --permanent
    sudo firewall-cmd --zone=public --add-port=9090/udp --permanent
    sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
    sudo firewall-cmd --zone=public --add-port=9090/tcp --permanent
    sudo firewall-cmd --permanent --add-service=cockpit
    sudo firewall-cmd --reload
    echo "######## Accessing  #######"
    echo "http://localhost:9090 in your web browser"
}

# Function to install and configure Cockpit on Fedora
install_fedora() {
    sudo dnf update -y
    sudo dnf install -y cockpit
    sudo systemctl start cockpit.socket
    sudo systemctl enable cockpit.socket
    ######custum Port########
    sudo mkdir -p /etc/systemd/system/cockpit.socket.d
    echo -e "[Socket]\nListenStream=5146" | sudo tee /etc/systemd/system/cockpit.socket.d/listen.conf
    sudo systemctl restart cockpit
    
    sudo firewall-cmd --permanent --add-service=cockpit
    sudo firewall-cmd --zone=public --add-port=80/udp --permanent
    sudo firewall-cmd --zone=public --add-port=9090/udp --permanent
    sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
    sudo firewall-cmd --zone=public --add-port=9090/tcp --permanent
    sudo firewall-cmd --reload
    echo "######## Accessing  #######"
    echo "http://localhost:9090 in your web browser"
}

# Main script
check_os

if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    install_ubuntu_debian
elif [[ "$OS" == "centos" || "$OS" == "rhel" ]]; then
    install_centos_rhel
elif [[ "$OS" == "fedora" ]]; then
    install_fedora
else
    echo "Unsupported OS."
    exit 1
fi
