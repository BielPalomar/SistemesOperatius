#!/bin/bash
if [ $# -eq 0 ]; then
  echo "Uso: ./ejercicio2.sh <archivo_consumo> [umbral] [mes]"
  echo "- archivo_consumo: archivo con datos de consumo de agua"
  echo "- umbral: consumo máximo en litros (opcional, default: 200)"
  echo "- mes: filtrar por mes en formato 'MM' (opcional)"
  exit 1
fi
umbral=200
mes=-1

if [ ! -z "$2" ]; then
  umbral=$2
fi

if [ ! -z "$3" ]; then
  mes=$3
fi

litres=$(cat $1 | awk -F '|' '{a[$2]+=$3;}END{for(i in a){print i "|" a[i];}}' | grep -E H )

echo "Consumo promedio de agua por hogar:"
echo "--------------------------------"
for line in $litres; do
  nom=$(echo "$line" | awk -F '|' '{print $1}')
  num=$(echo "$line" | awk -F '|' '{print $2}')
  echo "$nom: $num litros"
done
echo ""
echo "Hogares que superan el umbral de $umbral litros:"
echo "--------------------------------"

for line in $litres; do
  nom=$(echo "$line" | awk -F '|' '{print $1}')
  num=$(echo "$line" | awk -F '|' '{print $2}')
  comp=$(echo "$num > $umbral" | bc -l) 
  if [ $comp -eq 1 ]; then
    echo "$nom: $num litros"
  fi
done

periodo=$(cat $1 | awk -F '|' '{ a[$1]="" } END {for(i in a){print i}}' | sort )
echo "$periodo"
