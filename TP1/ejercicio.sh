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
  numLinies=${line#*;}
  nomFitxer=${line%;*}
  if [ -f $nomFitxer ]; then
    echo "Primeres ${numLinies} del ${nomFitxer}"
    head -n $numLinies $nomFitxer
    echo ""
  else
    echo "${nomFitxer} no existeix o es un directori"
  fi
done
exit 0
