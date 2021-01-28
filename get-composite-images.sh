set -x
filename=${1}

while read number; do

  PL_API_KEY=6ab2f0bf459b425192050bbb09020c83
  cd ~/sentinel/scripts/splits/${number}

  for dateTime in $(ls); do
    
    #get files from S3
    cd ~/sentinel/scripts/splits/$number/$dateTime
    gsutil -qm cp gs://arunas-arctic-sea-ice/${number}/${dateTime}/*.tiff .
    
    #generate a composite with all the tiffs and the AOI
    gdalwarp -of GTiff -co COMPRESS=DEFLATE -cutline ~/sources/${START_DATE}_${END_DATE}/feature-${number}.geojson -crop_to_cutline -t_srs EPSG:3857 -srcnodata "0 0 0" *.tiff ${number}-${dateTime}-composite-init.tiff

    #If the command fails because of invalid tiffs, record the error and skip iteration
    if [ $? -ne 0 ]; then
      echo "${number}/${dateTime}" >> ~/sentinel/scripts/composites/${filename}-fails
      rm *.tiff
      continue
    fi

    #Trim transparent pixels from the borders of the tiff
    convert ${number}-${dateTime}-composite-init.tiff -trim ${number}-${dateTime}-composite-init-trim.tiff
    
    #convert the tiff to a PNG. Store size of original tiff, just in case
    size=`gdalinfo ${number}-${dateTime}-composite-init-trim.tiff | grep -o -P '(?<=Size is ).*(?=)' | tr -s ", " '-'` 
    gdal_translate -of "GTiff" -outsize 1024 1024 ${number}-${dateTime}-composite-init-trim.tiff ${number}-${dateTime}-${size}-composite.png

    #check if the convert has any transparent pixels
    success=`convert ${number}-${dateTime}-${size}-composite.png -channel a -separate -format "%[fx:100*mean]" info:`
    if [ $( echo "${success} < 99" | bc -l) -eq 1 ]; then
      mv ${number}-${dateTime}-${size}-composite.png ${number}-${dateTime}-${size}-failed.png
    fi

    #copy all files back to S3
    gsutil -qm mv *composite*tiff gs://arunas-arctic-sea-ice/${number}/${dateTime}/ && rm *.tiff &
    gsutil -qm mv *${dateTime}*png gs://arunas-arctic-sea-ice/${number}/${dateTime}/ &

  done

done < ${filename}
