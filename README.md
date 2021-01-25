# Scrape sentinel

This gets satellite imagery from sentinelsat

## Installation Instructions
### Configuring your environment 
* Make sure python3.6 is installed
* Install virtualenv : `python3.6 -m pip install virtualenv`
* Create the virtual environment: 
    * For OSX: `python3.6 -m virtualenv --python=/usr/local/bin/python3.6 venv_dir/`
    * For Windows: `virtualenv --python=/c/Users/STARLab/AppData/Local/Programs/Python/Python35/python.exe venv_dir` 
    * For Ubuntu: `virtualenv -p /usr/bin/python3.6 venv_dir ` 
* Activate the environment: `source venv_dir/bin/activate` 
### Installing GNU Parallel
* Install GNU parallel with homebrew: `brew install parallel` 
### Installing sentinelsat 
* `pip install sentinelsat` 
### Installing gdal 
* Installing gdal is a bit tricky. First, try the instructions from : https://pypi.org/project/GDAL/
* If at all else, try this link: https://gdal.org/download.html 
* `brew install gdal --HEAD` sometimes works as well. 
### Installing gsutils
* `pip install gsutil` 
* Authenticate stand-alone gsutil:
    * (Windows only): Go to the directory you installed gsutil (likely `C:\gsutil`)
    * `gsutil config` (For Windows, `python gsutil config`)
    * Navigate to the authorization link given 
    * Allow access to Google Cloud Platform. If you don't have a project, sign up and create a project. More can be found at https://console.cloud.google.com/ 
    * Copy the authorization code on the webpage and paste into the terminal 
    * Enter the project ID into the terminal 
### Makiing an account 
* Create an account on the copernicus open hub: https://scihub.copernicus.eu/
### Adding Login Information
* Create a file called `login.sh`. Format it as follows: 
* `export uname=<username>`
* `export password=<password>`

## Changing the config.sh file
* Don't change the contents of the `ROOT` variable.
* The `BBOX_GEOJSON_FILE` is the `json` file that contains a polygon/bounding box in which we want to look for data. Create a file, say `bbox.json`. This file needs to have the area we are searching for images in, in the JSON format. The easiest way to fill up this file is by going to geojson.io and drawing a polygon, and pasting the generated geojson in this file. The variable has the _path to this file_. For example, the _path to this file_ can be ${ROOT}/_filename_.json
* The `IMG_SIZE` is the size of the resulting image in pixels. So, for eg if you want a final image of 1024 by 1024 px, this variable will be `IMG_SIZE=1024`
* The start and end dates are in the format YYYYMMDD. For example, 20191030
* The `CLOUD` variable is the cloud cover. You can assign this to 0, and read more about it on the Copernicus Sentinelsat documentation on the values for cloud cover.

## Commands
* Run `npm install` to install all the packages
* Run `bash config.sh`
* Run `bash pipeline.sh.sh`
