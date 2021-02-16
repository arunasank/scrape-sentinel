#! /bin/bash
export ROOT=$(pwd)
while IFS=" " read -r START END remainder;
do
    echo $START
    echo $END
    bash pipeline.sh $START $END
    rsync -azP ${ROOT}/sources/${START}_$END jlchew@deluge.mit.edu:/home/jlchew/CRISES/satImages
    
    mv ROOT/sources/${START_DATE}_${END_DATE}/ /Users/jlchew/Dropbox\ \(MIT\)/juliana/SatImages/Sentinel1_GRD/${START_DATE}_${END_DATE}/

done < "dates.txt"


