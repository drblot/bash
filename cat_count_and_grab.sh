#!/bin/bash

input="/PATH/TO/INPUTDIR"
outputname="NEWNAME"
finalcsv="${input}/${outputname}.csv"

cat "${input}"/*.csv > "${finalcsv}"
awk -F "," '{ print $1 }' "$finalcsv" | sort -u -k1 -n > "${finalcsv}_count.csv"
head -n 1 "$finalcsv" | tr ',' '\n' > "${finalcsv}_colnames.csv"
