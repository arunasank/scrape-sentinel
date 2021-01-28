#! /bin/sh

while IFS=" " read -r START END remainder;
do
    echo $START
    echo $END
    . pipeline.sh $START $END

done < "dates.txt"


