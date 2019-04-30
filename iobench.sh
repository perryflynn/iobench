#!/bin/bash

#
# Disk benchmark script by Christian Blechert
# 2017-05-17
# https://anysrc.net
# https://github.com/perryflynn
#
# Inspired by https://wiki.ubuntuusers.de/Festplatten-Geschwindigkeitstest/
#

EXEC=$0

usage() {
    echo "Usage: $EXEC --dir <directory> --megabytes 1024"
    echo
    echo "Optional settings:"
    echo "--sync      Test synced write and read without cache"
    echo "--skipread  Skip the read part"
    echo "--skipwrite Skip the write part"
    echo
}

tempfile() {
    echo -n "$DIR/$(mktemp -u iobench.XXXXXXXXXXX)"
}

# Parse arguments
DIR="."
C=1024
ISSYNC=0
ISREAD=1
ISWRITE=1

while [[ $# -ge 1 ]]
do
    key="$1"
    case $key in
        -d|--dir)
            DIR="$2"
            shift # past argument
            ;;
        -m|--megabytes)
            C="$2"
            shift # past argument
            ;;
        -s|--sync)
            ISSYNC=1
            ;;
        --skipwrite)
            ISWRITE=0
            ;;
        --skipread)
            ISREAD=0
            ;;
        -h|--help)
            HELP=1
            ;;
        *)
            # unknown option
            ;;
    esac
    shift # past argument or value
done

if [ "$HELP" == "1" ]; then
    usage
    exit 1
fi

if [ ! -d "$DIR" ]; then
    echo "Directory not found."
    usage
    exit 1
fi

if ! [[ $C =~ ^[0-9]+$ ]]; then
    echo "Not a valid positive integer"
    usage
    exit 1
fi

echo "Target directory: $DIR"
echo "Testfile size: $C x 1 Megabyte"
echo
echo "1. Write benchmark without cache"

TEMPF=$(tempfile)

if [ "$ISWRITE" == "1" ] && [ "$ISSYNC" == "1" ]; then
    dd if=/dev/urandom of="$TEMPF" bs=1M count=$C conv=fdatasync,notrunc 2>&1 | tail -n 1
    sleep 10
elif [ "$ISWRITE" == "0" ]; then
    echo "skipped."
else
    echo "skipped. use --sync option to enable."
fi

echo
echo "2. Write benchmark with cache"

if [ "$ISWRITE" == "1" ]; then
    dd if=/dev/urandom of="$TEMPF" bs=1M count=$C 2>&1 | tail -n 1
    sleep 10
else
    echo "skipped."
fi

echo
echo "3. Read benchmark with dropped cache"


if [ -f "$TEMPF" ] && [ "$ISREAD" == "1" ] && [ "$ISSYNC" == "1" ]; then
    echo 3 > /proc/sys/vm/drop_caches
    dd if="$TEMPF" of=/dev/null bs=1M count=$C 2>&1 | tail -n 1
    sleep 10
elif [ ! -f "$TEMPF" ]; then
    echo "No file for read tests found. skipped."
elif [ "$ISREAD" == "0" ]; then
    echo "skipped."
else
    echo "skipped. use --sync option to enable."
fi

echo
echo "4. Read benchmark without cache drop"

if [ -f "$TEMPF" ] && [ "$ISREAD" == "1" ]; then
    for i in {1..5}; do
        echo
        echo "Start $i of 5..."
        dd if="$TEMPF" of=/dev/null bs=1M count=$C 2>&1 | tail -n 1
    done
elif [ ! -f "$TEMPF" ]; then
    echo "No file for read tests found. skipped."
else
    echo "skipped."
fi


if [ -f "$TEMPF" ]; then
    rm "$TEMPF"
fi

echo
echo "Done."

exit 0;
