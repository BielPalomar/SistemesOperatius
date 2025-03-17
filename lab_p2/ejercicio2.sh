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

# Filtramos las lineas que contienen el mes indicado. Para ello cogemos con awk
# la primera columna i vemos si coincide con la expression \[0-9]+-"$mes"-[0-9]+\ donde
# "$mes" se sustituye por el contenido de mes (ej. si mes=01 entonces se filtra por \[0-9]+-01-[0-9]+)
#
# El propio comando de awk en "litres" ya suma todos los litros de los diferentes hogares
if [ ! -z "$3" ]; then
  mes=$3
  litres=$(cat $1 | awk -v r="[0-9]+-$mes-[0-9]+" -F '|' '{ if($1 ~ r) { a[$2]+=$3; n[$2]++; } } END {for(i in a){printf "%s|%.2f\n", i, a[i]/n[i];}}' | grep -E H )
  # years es una lista de todos los años distintos en las entradas. Cogemos de la primera columna los años distinitos
  years=$(cat $1 | awk -F '|' '{print $1}' | awk -F '-' '{a[$1]="";} END {for(i in a){print i;}}' | tail -n +2)
else
  litres=$(cat $1 | awk -F '|' '{a[$2]+=$3; n[$2]++; } END { for(i in a){printf "%s|%.2f\n", i, a[i]/n[i];}}' | grep -E H )
  years=""
fi


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

echo ""
if [ ! -z "$3" ]; then 
  echo -n "Periodo analizado: " 
  for year in $years; do
    echo -n "Mes $mes de $year "
  done
  echo ""
else
  periodos=$(cat $1 | awk -F '|' '{ a[$1]="" } END {for(i in a){print i}}' | grep -E '[0-9]+-[0-9]+-[0-9]+' | sort)
  primer_periodo=$(echo "$periodos" | head -n 1)
  ultimo_periodo=$(echo "$periodos" | tail -n 1)
  echo "Periodo analizado: $primer_periodo a $ultimo_periodo"
fi
exit 0
