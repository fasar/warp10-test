#!/bin/bash
#
# Create empty leveldb folders for each nodes
#
 

for i in  w10-data-db*; do
    echo "Cleaning lebeldb folder"
    mkdir $i/warp10/leveldb
    rm $i/warp10/leveldb/.nofile
done