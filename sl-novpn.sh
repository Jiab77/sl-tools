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

# Launching SL client
echo -e "\nMoving to SL directory...\n"
cd $CLIENT_DIR ; pwd

echo -e "\nRunning SL client...\n"
$CLIENT_BIN
