#!/usr/bin/env bash
clear

# Options
[[ -r $HOME/.debug ]] && set -o xtrace || set +o xtrace

# Config
BASE=`dirname $(realpath $0)`
source "${BASE}/sl.conf"

# Check
if [[ $CLIENT_DIR == "" || $CLIENT_BIN == "" ]]; then
    echo -e "\nYou must define 'CLIENT_DIR' and 'CLIENT_BIN' in 'sl.conf' to run the script.\n"
    exit 1
fi
if [[ $VPN_BIN == "" ]]; then
    echo -e "\nYou must define 'VPN_BIN' in 'sl.conf' to run the script.\n"
    exit 2
fi

echo -e "\nInit VPN connection...\n"
$VPN_BIN connect --sc

echo -e "\nVPN connection initiated, run [watch -n2 '$VPN_BIN status'] to see the status..."
sleep 5

echo -e "\nMoving to SL directory...\n"
cd $CLIENT_DIR ; pwd

echo -e "\nRunning SL client...\n"
$CLIENT_BIN

echo -e "\nDisconnecting from VPN...\n"
$VPN_BIN disconnect
echo
