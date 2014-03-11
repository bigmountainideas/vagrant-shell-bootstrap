#!/usr/bin/env bash


sudo iptables -F
sudo iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
sudo iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP
sudo iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP
sudo iptables -A INPUT -i lo -j ACCEPT

for port in "$@"
do
  sudo iptables -A INPUT -p tcp -m tcp --dport $port -j ACCEPT
done

sudo iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT
sudo iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
sudo iptables -P OUTPUT ACCEPT
sudo iptables -P INPUT DROP

if [ -a /etc/sysconfig/iptables ]; then
  sudo iptables-save | sudo tee /etc/sysconfig/iptables
  sudo service iptables restart
else
  sudo iptables-save
  sudo DEBIAN_FRONTEND=noninteractive aptitude install -y -q iptables-persistent
  sudo service iptables-persistent start
fi
