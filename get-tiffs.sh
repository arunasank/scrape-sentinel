set -x
cd ${ROOT}/sources/${START_DATE}_${END_DATE}
for dir in $(ls -d */);
do
  cd ${dir}

  for file in $(ls);
  do
    
    if [[ "$OSTYPE" == "darwin"* ]];
    then
        DAYS_DIFFERENCE=$(( ( $(date -j -f "%Y%m%d" "${END_DATE}" +%s) - $(date -j -f "%Y%m%d" "${START_DATE}" +%s) )/(60*60*24) ))
    elif [[ "$OSTYPE" == "linux-gnu"* ]];
    then
        DAYS_DIFFERENCE=$(( ($(date --date="${END_DATE}" +%s) - $(date --date="${START_DATE}" +%s) )/(60*60*24) ))
    fi
    
    ITERATOR=1
    CURRENT_START_DATE=${START_DATE}
    while [ ${ITERATOR} -le ${DAYS_DIFFERENCE} ];
    do
        if [[ "$OSTYPE" == "darwin"* ]];
        then
            CURRENT_END_DATE=$(date -j -f '%Y%m%d' -v+${ITERATOR}d "${START_DATE}" +%Y%m%d )
        elif [[ "$OSTYPE" == "linux-gnu"* ]];
        then
            CURRENT_END_DATE=$(date +%Y%m%d -d "${START_DATE} + ${ITERATOR} day")
        fi
      
      if [[ ${SENTINEL} -eq 2 ]];
      then
      
          sentinelsat -u ${uname} -p ${password} -s ${CURRENT_START_DATE} \
          -e ${CURRENT_END_DATE} -g ${file} --cloud ${CLOUD} --sentinel ${SENTINEL} \
          --instrument ${INSTRUMENT} --query ${QUERY} \
          --footprints
      elif [[ ${SENTINEL} -eq 1 ]];
      then
          sentinelsat -u ${uname} -p ${password} -s ${CURRENT_START_DATE} \
          -e ${CURRENT_END_DATE} -g ${file} --sentinel ${SENTINEL} \
          --query ${QUERY} --footprints
      fi
          
      CURRENT_START_DATE=${CURRENT_END_DATE}

      if [ -f search_footprints.geojson ];
      then
        mv search_footprints.geojson search_footprints.json

        node ${ROOT}/getSentinelTileIds.js \
        ${ROOT}/sources/${START_DATE}_${END_DATE}/${dir}search_footprints.json > ${file%.*}-${ITERATOR}.txt
        
        if [[ ! -s ${file%.*}-${ITERATOR}.txt ]];
        then
            rm -f ${file%.*}-${ITERATOR}.txt
            ITERATOR=$(( ${ITERATOR} + 1 ))
            continue
        fi
        
        less ${file%.*}-${ITERATOR}.txt | \
        parallel "node ${ROOT}/get-path.js {} ${file%.*}" | parallel "{}"
        
        if [[ ${SENTINEL} -eq 2 ]];
        then
            gdalwarp -of 'Gtiff' -co COMPRESS=DEFLATE \
            -cutline ${file} -crop_to_cutline \
            -t_srs EPSG:3857 -srcnodata "0 0 0" *.jp2 \
            ${file%.*}-${ITERATOR}.tiff
            
            rm *.jp2
        elif [[ ${SENTINEL} -eq 1 ]];
        then
            unzip -j *.zip "*.tiff"
            rm *.zip*
            rm *.metalink
            rm *.xml
            shopt -s nullglob
            for satImg in s1*; do
                polarization=($( echo ${satImg} | cut -d '-' -f 4 ))
                gdalwarp -of 'Gtiff' -tps -r bilinear -tr 10 10  \
                -cutline ${file} -crop_to_cutline -co COMPRESS=DEFLATE\
                -t_srs EPSG:3857 -srcnodata 0 -dstnodata 0 ${satImg} \
                ${file%.*}-${ITERATOR}-${polarization}.tiff

                if [ -f ${satImg} ];then
                    rm ${satImg}
                fi
            done
        

        
            
        fi
      fi

      ITERATOR=$(( ${ITERATOR} + 1 ))
    done
  done
  cd ../
done
