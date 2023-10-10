#!/bin/bash

finalcsv="/PATH/TO/file.csv"

name1=$(basename "$finalcsv")
name1_no_extension="${name1%.csv}"
dir1=$(dirname "$finalcsv")

awk -F "," '{ print $1 }' "$finalcsv" | sort -u -k1 -n > "${dir1}/${name1_no_extension}_count.csv"
head -n 1 "$finalcsv" | tr ',' '\n' > "${dir1}/${name1_no_extension}_colnames.csv"
