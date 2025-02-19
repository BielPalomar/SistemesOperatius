#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Se requiere el siguiente formato: ./ejercicio1.sh <archivo_ciudad1>"
  exit 1
fi
total=0
for fitxer in "$@"
do
  if [ -f "$fitxer" ]; then
    # tamano=`wc -c < $fitxer`
    tamano=`ls -l $fitxer | awk '{print $5}'`
    echo "Tamaño del archivo $fitxer: $tamano bytes"
    let total=total+tamano
  else
    echo "No se ha podido leer el archivo $fitxer"
  fi
done
echo "Tamaño del archivo combinado: $total bytes"
exit 0

