#!/bin/bash

if [ $# -ne 3 ]; then
  echo "Formato de uso: ./ejercicio6.sh <directorio> <parametro> <umbral>"
  exit 1
fi

directorio=$1
parametro=$2
umbral=$3

echo "Estaciones con $parametro superior a $umbral:"

res=$(grep -r $parametro $directorio | awk -F ':' '{print $1  "|" $3}' | awk -F ' ' '{print $1 $2}') # Hay un espacio después del nombre del archivo. Lo eliminamos con awk
for line in $res; do
  archivo=$(echo "$line" | awk -F '|' '{print $1}')
  numero=$(echo "$line" | awk -F '|' '{print $2}')
  if [ $(echo "" | awk "{ print $umbral < $numero }") -eq 1 ]; then
    echo "--------------------------------------------"
    echo "Archivo: $archivo"
    nombre=$(cat $archivo | grep 'Estación:' | cut -d ' ' -f2-)
    echo "Estación: $nombre"
    echo "Valor de $parametro: $numero"
  fi
done
echo "--------------------------------------------"

exit 0
