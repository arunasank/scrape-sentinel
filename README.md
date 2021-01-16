# Scrape sentinel

This gets satellite imagery from sentinelsat

## Instructions
* Create an account on the copernicus open hub: https://scihub.copernicus.eu/

## Changing the config.sh file
* Don't change the contents of the `ROOT` variable.
* Enter the username, password, and other metadata in the config.sh file.
* The `BBOX_GEOJSON_FILE` is a file that contains a polygon/bounding box in which we want to look for data. Create a file, say `bbox.geojson`. This file needs to have the area we are searching for images in, in the geoJSON format. The easiest way to fill up this file is by going to geojson.io and drawing a polygon, and pasting the generated geojson in this file. The variable has the _path to this file_. 
* The `IMG_SIZE` is the size of the resulting image in pixels. So, for eg if you want a final image of 1024 by 1024 px, this variable will be `IMG_SIZE=1024`
* The `CLOUD` variable is the cloud cover. You can assign this to 0, and read more about it on the Copernicus Sentinelsat documentation on the values for cloud cover.

## Commands
* Run `npm install` to install all the packages
* Run `bash config.sh`
* Run `bash pieline.sh.sh`
