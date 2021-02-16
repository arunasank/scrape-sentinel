#! /bin/sh
export ROOT=$(pwd)
export BBOX_GEOJSON_FILE=${ROOT}/bbox.json
export IMG_SIZE=1024
export START_DATE=$1
export END_DATE=$2
export CLOUD=30                                     # Not used if SENTINEL=1
export SENTINEL=1
export QUERY="producttype=GRD,polarisationmode=VV"  # for sentinel 2: was producttype=S2MSI1C
export INSTRUMENT="MSI"                             # Not used if SENTINEL=1
