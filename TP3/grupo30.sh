#!/bin/bash

# Comprovamos que hay 3 parámetros
if [ $# -ne 3 ]; then
  echo "Uso del script: ./tp3.sh <directorio_logs> <nombre_aplicacion> <código respuesta http>"
  exit 1
fi

# Comprovamos que <directorio_logs> es un directorio
if [ ! -d "$1" ]; then
  echo "$1 no es un directorio"
  exit 1
fi

# Comprovamos que <nombre_aplicacion> es válido
case "$2" in
  "api"|"static"|"video") 
    fitxers=$(find "$1/" -name "$2.log*")
  ;;
  *)
    echo "El nombre de aplicación no es válido"
    exit 1
  ;;
esac

# Filtramos de todos los archivos las lineas que coincide con 
# el código de respuesta con awk. Es decir, filtramos por la tercera columna
for f in "$fitxers"; do
  cat $f | awk -v var="$3" '{ if($3 == var) { print } }'
done

exit 0
