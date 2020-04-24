#!/bin/bash

# get env variables from .env file
source .env

if [[ -z "${SETUP_PRD}" ]]; then
    echo "SETUP_PRD is not set, setting up for local development"
    echo "" > orientdb/create-db.osql
    array=( test dev )
    for i in "${array[@]}"
    do
        echo "CREATE DATABASE remote:localhost/$i root ORIENTDB_ROOT_PASS PLOCAL" >> orientdb/create-db.osql
    done
    # replace the root pass before copying, unfortunately osql does not support env vars yet
    sed 's/ORIENTDB_ROOT_PASS/root/g' orientdb/create-db.osql > orientdb/create-db-pass.osql
  else
    echo "APP_RELEASE is set doing a release from current branch.."
    echo "" > orientdb/create-db.osql
    array=( news-raw )
    for i in "${array[@]}"
    do
        echo "CREATE DATABASE remote:localhost/$i root ORIENTDB_ROOT_PASS PLOCAL" >> orientdb/create-db.osql
    done
    # replace the root pass before copying, unfortunately osql does not support env vars yet
    sed 's/ORIENTDB_ROOT_PASS/'"${ORIENTDB_ROOT_PASS}"'/g' orientdb/create-db.osql > orientdb/create-db-pass.osql 
  fi

# copy over the necessary scripts to the container
# just one node is enough even in distributed mode
docker cp orientdb/create-db-pass.osql tr-odb1:/tmp/create-db-pass.osql 

# remove sensitive file from local
rm -f orientdb/create-db-pass.osql

docker exec -it tr-odb1 /orientdb/bin/console.sh /tmp/create-db-pass.osql