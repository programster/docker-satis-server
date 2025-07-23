#!/bin/bash

EXPECTED_NUM_ARGS=1;

if [ "$#" -ne $EXPECTED_NUM_ARGS ]; then
    echo "Missing required sleep period argument."
    exit 1
fi

echo "Satis updater sleeping for $1 seconds..."
sleep $1

source /config/svn-credentials.txt

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

echo "Refreshing packag index..."
cd $SCRIPTPATH
/usr/bin/expect update-satis.tcl $USERNAME $PASSWORD

echo "Done."
