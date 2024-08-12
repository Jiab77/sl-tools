#!/usr/bin/env bash
clear

# Options
[[ -r $HOME/.debug ]] && set -o xtrace || set +o xtrace

# Config
BASE=`dirname $(realpath $0)`
source "${BASE}/sl.conf"
BACKUP_FOLDER="${CLIENT_DIR}-backups"

# Check
if [[ $CLIENT_DIR == "" || $CLIENT_BIN == "" ]]; then
    echo -e "\nYou must define 'CLIENT_DIR' and 'CLIENT_BIN' in 'sl.conf' to run the script.\n"
    exit 1
fi

# Display current version
echo -ne "\nDetecting client version..."
if [ -f "${CLIENT_DIR}/build_data.json" ]; then
    CLIENT_VERSION=`cat ${CLIENT_DIR}/build_data.json | jq -r .Version`
fi
if [[ ! -z $CLIENT_VERSION ]]; then
    echo " ${CLIENT_VERSION}"
else
    echo -e " not detected! Stopping here.\n"
    exit 2
fi

# Create backup folder
echo -ne "\nCreating backup folder..."
mkdir -pv $BACKUP_FOLDER
if [ -d $BACKUP_FOLDER ]; then
    echo " created."
else
    echo -e " not created. Stopping here."
    exit 3
fi

# Detect user data folder
echo -ne "\nDetecting user data folder..."
USER_DATA_DIR="${HOME}/.`basename $CLIENT_DIR`_x`cat ${CLIENT_DIR}/build_data.json | jq -r '."Address Size"'`"
if [ -d "$USER_DATA_DIR" ]; then
    USER_DATA_DIR_FOUND=true
    echo -e " detected!"
    echo -e "Found: ${USER_DATA_DIR}"
else
    USER_DATA_DIR_FOUND=false
    echo -e " not detected. Stopping here.\n"
    exit 4
fi

# Running backup process
if [[ $USER_DATA_DIR_FOUND == true ]]; then
    echo -e "\nCompressing client folder [${CLIENT_DIR}] to [${BACKUP_FOLDER}/`basename ${CLIENT_DIR}`_${CLIENT_VERSION}.tar.xz]...\n"
    CLIENT_ARCHIVE_NAME="`basename ${CLIENT_DIR}`_${CLIENT_VERSION}.tar.xz"
    time tar cf - "${CLIENT_DIR}" | xz -z -9 -e -T 0 -vv -c - > "${BACKUP_FOLDER}/${CLIENT_ARCHIVE_NAME}"
    RET_CODE_CLIENT=$?
    echo -e "\nExit code: ${RET_CODE_CLIENT}\n"
    echo -ne "\nCleaning user data cache folder before compression..."
    rm -rf "${USER_DATA_DIR}"/cache/* &>/dev/null
    RET_CODE_CLEAN=$?
    if [ $RET_CODE_CLEAN -eq 0 ]; then
        echo " done."
    else
        echo " failed. Stopping here."
        exit 5
    fi
    echo -e "\nCompressing user data folder [${USER_DATA_DIR}] to [${BACKUP_FOLDER}/`basename ${USER_DATA_DIR}`-data_${CLIENT_VERSION}.tar.xz]...\n"
    USER_DATA_ARCHIVE_NAME="`basename ${USER_DATA_DIR}`-data_${CLIENT_VERSION}.tar.xz"
    time tar cf - "${USER_DATA_DIR}" | xz -z -9 -e -T 0 -vv -c - > "${BACKUP_FOLDER}/${USER_DATA_ARCHIVE_NAME}"
    RET_CODE_USER=$?
    echo -e "\nExit code: ${RET_CODE_USER}\n"
fi
