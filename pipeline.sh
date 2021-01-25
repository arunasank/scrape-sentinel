#!/bin/bash

set -xe

. config.sh
. login.sh

if [ -d sources ];
then
    rm -Rf sources
fi

mkdir -p sources/
echo "${BBOX_GEOJSON_FILE} ${IMG_SIZE}"
node get-grid-geojsons.js
sh get-tiffs.sh 
