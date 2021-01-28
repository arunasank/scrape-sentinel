#!/bin/bash

set -xe

. config.sh
. login.sh

mkdir -p sources

if [ -d sources/${START_DATE}_${END_DATE}/ ];
then
    rm -Rf sources/${START_DATE}_${END_DATE}/
fi

mkdir sources/${START_DATE}_${END_DATE}
echo "${BBOX_GEOJSON_FILE} ${IMG_SIZE}"
node get-grid-geojsons.js
sh get-tiffs.sh 
