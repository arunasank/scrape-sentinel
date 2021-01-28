#! /bin/sh
while IFS=" " read -r START END remainder;
do
    echo $START
    echo $END
    sh pipeline.sh $START $END

done < "dates.txt"


