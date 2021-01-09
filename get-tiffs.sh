set -x
cd /home/sank/MIT/summer-2020/dava/arctic-sea-ice/arctic-sea-ice/final-pipeline/sources
for dir in $(ls -d */);
do
  cd ${dir}

  for file in $(ls);
  do
    DAYS_DIFFERENCE=$(( ($(date --date="${END_DATE}" +%s) - $(date --date="${START_DATE}" +%s) )/(60*60*24) ))
    ITERATOR=1
    CURRENT_START_DATE=${START_DATE}
    while [ ${ITERATOR} -le ${DAYS_DIFFERENCE} ];
    do
      CURRENT_END_DATE=$(date +%Y%m%d -d "${START_DATE} + ${ITERATOR} day")

      sentinelsat -u ${uname} -p ${password} -s ${CURRENT_START_DATE} \
      -e ${CURRENT_END_DATE} -g ${file} --cloud ${CLOUD} --sentinel 2 \
      --instrument MSI --query "producttype=S2MSI1C" \
      --footprints

      CURRENT_START_DATE=${CURRENT_END_DATE}

      if [ -f search_footprints.geojson ];
      then
        mv search_footprints.geojson search_footprints.json

        node ${ROOT}/getSentinelTileIds.js \
        ${ROOT}/sources/${dir}/search_footprints.json > ${file%.*}-${ITERATOR}.txt

        less ${file%.*}-${ITERATOR}.txt | \
        parallel "node ${ROOT}/get-path.js {} ${file%.*}" | parallel "{}"

        gdalwarp -of 'Gtiff' -co COMPRESS=DEFLATE \
        -cutline ${file} -crop_to_cutline \
        -t_srs EPSG:3857 -srcnodata "0 0 0" *.jp2 \
        ${file%.*}-${ITERATOR}.tiff

	rm *.jp2
      fi

      ITERATOR=$(( ${ITERATOR} + 1 ))
    done
  done
  cd ../
done
