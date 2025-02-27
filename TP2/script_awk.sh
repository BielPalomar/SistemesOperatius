#!/bin/bash

if [ $# -ne 1 ]
then 
    echo "Nombre incorrecte de parametres"
    exit 1
fi

dir=$1
files=($(ls -l dir | awk '{print $9}' | tail -n +2))
for fitxer in $files; do
  col1=($(awk '{print $1}' $dir/$fitxer)) 
  col2=($(awk '{print $2}' $dir/$fitxer))
  
  len=${#col1[*]}
  
  i=0
  sum1=0
  sum2=0
  sup=0
  
  while [ $i -lt $len ]
  do
    if [ ${col1[$i]} -gt ${col2[$i]} ]; then
      (( sup++ ))
    fi
    sum1=$(($sum1+${col1[$i]}))
    sum2=$(($sum2+${col2[$i]}))
    (( i++ ))
  done
  echo $sum1 $sum2 $sup
done

exit 0
