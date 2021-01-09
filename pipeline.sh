#!/bin/bash

set -xe

. config.sh

mkdir -p sources/
echo "${BBOX_GEOJSON_FILE} ${IMG_SIZE}"
node get-grid-geojsons.js
sh get-tiffs.sh 
