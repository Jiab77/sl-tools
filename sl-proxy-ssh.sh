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
if [[ $SSH_USER == "" || $SSH_HOST == "" || $TUNNEL_PORT == "" || $PROXYCHAINS_BIN == "" ]]; then
    echo -e "\nTo run the script, you must define the following variables in 'sl.conf'.\n"
    echo -e "- 'SSH_USER'"
    echo -e "- 'SSH_HOST'"
    echo -e "- 'TUNNEL_PORT'"
    echo -e "- 'PROXYCHAINS_BIN'"
    echo
    exit 2
fi

# Check if we need to create a tunnel
echo -e "\nVerify existing SSH tunnel...\n"
if [[ $(ss -tunel | grep $TUNNEL_PORT | wc -l) -ge 1 ]]; then
    # Don't recreate / kill existing tunnel if already used
    KILL_EXISTING_TUNNEL=false
else
    # No existing tunnels found, creating one
    echo -e "\nStarting SSH tunnel...\n"
    ssh -nNTfD $TUNNEL_PORT "${SSH_USER}@${SSH_HOST}"
fi

# Stop if the tunnel creation has failed
if [[ ! $(ss -tunel | grep $TUNNEL_PORT | wc -l) -ge 1 ]]; then
    echo -e "\nError: Unable to create required tunnel. Leaving.\n"
    exit 1
else
    echo -e "\nTunnel initiated, run [ps -efH | grep 'ssh -nNTfD'] to see the status...\n"
    sleep 5
fi

# Stop if proxychains has not been setup for using the SSH tunnel
if [[ $(cat /etc/proxychains.conf | grep -v "#" | grep $TUNNEL_PORT | wc -l) -eq 0 ]]; then
    echo -e "\nError: Proxychains not configured for using SSH tunnel. Leaving.\n"
    exit 2
fi

# If we are here then the tunnel has been created, launching SL client
echo -e "\nMoving to SL directory...\n"
cd $CLIENT_DIR ; pwd
echo -e "\nRunning SL client throught the SSH tunnel with Proxychains...\n"
$PROXYCHAINS_BIN $CLIENT_BIN

# Check if we need to kill existing tunnel or not
if [[ $KILL_EXISTING_TUNNEL == true ]]; then
    if [[ $(ss -tunel | grep $TUNNEL_PORT | wc -l) -ge 1 ]]; then
        echo -e "\nClosing SSH tunnel...\n"
        kill -9 $(pgrep -fi "ssh -nNTfD $TUNNEL_PORT ${SSH_USER}@${SSH_HOST}")
        echo -e "\n"
    fi
fi
