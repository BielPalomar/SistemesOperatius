#!/bin/bash
if [ $# -ne 1 ]; then
  echo "El número de parámetros no es correcto"
  exit 1
fi
file=$1
if [ ! -f $file ]; then
  echo "El parámetro no es un archivo"
  exit 1
fi
lines=$(cat $file)
for line in $lines; do
  echo "$line" | awk 
done
