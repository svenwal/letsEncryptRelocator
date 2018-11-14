#!/bin/bash

echo "letEncryptReplocator 0.1.2"
getopt --test > /dev/null
if [[ $? -ne 4 ]]; then
    echo "I am sorry, `getopt --test` failed in this environment."
    exit 1
fi

OPTIONS=n:h:rdotu
LONGOPTIONS=name:,target-host:,remove,disable-renewal,overwrite,target-dir:,target-username:

# -temporarily store output to be able to check for errors
# -e.g. use --options parameter by name to activate quoting/enhanced mode
# -pass arguments only via   -- "$@"   to separate them correctly
PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTIONS --name "$0" -- "$@")
if [[ $? -ne 0 ]]; then
    # e.g. $? == 1
    #  then getopt has complained about wrong arguments to stdout
    exit 2
fi
# read getopt output this way to handle the quoting right:
eval set -- "$PARSED"

REMOVE="false"
DISABLE_RENEWEL="false"
OVERWRITE="false"
TARGET_DIR="/etc/letsencrypt/"

# now enjoy the options in order and nicely split until we see --
while true; do
    case "$1" in
        -n|--name)
            NAME=$2
            shift 2
            ;;
        -r|--remove)
            REMOVE="true"
            shift
            ;;
        -d|--disable-renewal)
            DISABLE_RENEWEL="true"
            shift
            ;;
        -o|--overwrite)
            OVERWRITE="true"
            shift 2
            ;;
        -t|--target-dir)
            TARGET_DIR=$2
            shift 2
            ;;
        -h|--target-host)
            TARGET_HOST=$2
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Programming error"
            exit 3
            ;;
    esac
done

echo "I will copy key $NAME to $TARGET_HOST with remove=$REMOVE disable-renewal=$DISABLE_RENEWEL overwrite=$OVERWRITE and target-dir=$TARGET_DIR"

rm /tmp/letsEncryptRelocator.tgz
cd /etc/letsencrypt
tar czf /tmp/letsEncryptRelocator.tgz archive/$NAME renewal/$NAME.conf live/$NAME

#TARGET_DIR=/tmp/doof

scp /tmp/letsEncryptRelocator.tgz "$TARGET_HOST:$TARGET_DIR"

ssh $TARGET_HOST "tar xvzf $TARGET_DIR/letsEncryptRelocator.tgz -C $TARGET_DIR"
ssh $TARGET_HOST "rm $TARGET_DIR/letsEncryptRelocator.tgz"

rm /tmp/letsEncryptRelocator.tgz
