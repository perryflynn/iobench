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
    echo "$EXEC --dir <directory> --megabytes 1024"
}

tempfile() {
    echo -n "$DIR/$(mktemp -u iobench.XXXXXXXXXXX)"
}

# Parse arguments
DIR="."
C=1024

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
        -h|--help)
            HELP=1
            ;;
        *)
            # unknown option
            ;;
    esac
    shift # past argument or value
done

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
dd if=/dev/zero of="$TEMPF" bs=1M count=$C conv=fdatasync,notrunc 2>&1 | tail -n 1

echo
echo "2. Write benchmark with cache"

dd if=/dev/zero of="$TEMPF" bs=1M count=$C 2>&1 | tail -n 1

echo
echo "3. Read benchmark with droped cache"

echo 3 > /proc/sys/vm/drop_caches
dd if="$TEMPF" of=/dev/null bs=1M count=$C 2>&1 | tail -n 1

echo
echo "4. Read benchmark without cache drop"

for i in {1..5}; do
    echo
    echo "Start $i of 5..."
    dd if="$TEMPF" of=/dev/null bs=1M count=$C 2>&1 | tail -n 1
done

rm "$TEMPF"

echo
echo "Done."

exit 0;
