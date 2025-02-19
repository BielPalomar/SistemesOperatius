#!/bin/bash

if [ $# -lt 2 ]; then
  echo "Formato de uso: ./ejercicio2.sh <carpeta_datos> <umbral>" 
  exit 1
fi
if [ ! -d "$1" ]; then
  echo "$1 no es un directorio"
  exit 1
fi

mkdir -p alerta normal # Hacemos que no de error si las carpetas existen
echo "Procesando archivos de calidad del aire..."

procesados=0
detectados=0
normales=0

for fitxero in $1/*; do
  if [ -f "$fitxero" ]; then
    n=$(echo -e $(head -1 $fitxero)) # Leemos la primera linea
    echo "$n <"
    if [[ $(echo "$n < $2" | bc -l) -eq 0 ]]; then # Preguntar si puedo usar esto
      normales=$(($normales+1))
      mv $fitxero normal/
    else
      let detectados=$detectados+1
      mv $fitxero alerta/
    fi
    let procesados=$procesados+1
  fi
done

# Generamos el archivo y lo mostramos
echo "Archivos procesados: $procesados" > resumen_calidad_aire.txt
echo "Alertas detectadas: $detectados" >> resumen_calidad_aire.txt
echo "Archivos normales: $normales" >> resumen_calidad_aire.txt
cat resumen_calidad_aire.txt
echo "Se ha generado el informe en resumen_calidad_aire.txt"


