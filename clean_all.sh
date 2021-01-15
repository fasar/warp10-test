#!/bin/bash
#
#  Remove all runtime files for all folder
#
#

docker-compose -v down
docker-compose down
./fix_owner.sh
./fix_owner.sh
git clean -f
git clean -fX
git clean -fx
git clean -fd
./init_folders.sh
