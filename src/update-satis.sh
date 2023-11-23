#!/bin/bash

source /config/credentials.txt

SCRIPT=$(readlink -f "$0")
SCRIPTPATH=$(dirname "$SCRIPT")

cd $SCRIPTPATH
/usr/bin/expect update-satis.tcl $USERNAME $PASSWORD
