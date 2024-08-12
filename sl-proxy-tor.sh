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
if [[ $TUNNEL_PORT == "" || $PROXYCHAINS_BIN == "" ]]; then
    echo -e "\nTo run the script, you must define the following variables in 'sl.conf'.\n"
    echo -e "- 'TUNNEL_PORT'"
    echo -e "- 'PROXYCHAINS_BIN'"
    echo
    exit 2
fi

# The TOR tunnel should be define in the proxychains config...
# Launching SL client
echo -e "\nMoving to SL directory...\n"
cd $CLIENT_DIR ; pwd

echo -e "\nRunning SL client throught the SSH tunnel with Proxychains...\n"
$PROXYCHAINS_BIN $CLIENT_BIN
