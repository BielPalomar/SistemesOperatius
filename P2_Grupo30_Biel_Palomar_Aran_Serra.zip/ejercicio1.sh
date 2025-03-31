#!/bin/bash
if [ $# -ne 1 ]; then
	echo "Se requiere el siguiente formato: ./ejericio1.sh <archivo_calidad_agua>"
	exit 1
fi

if [ ! -f "$1" ]; then
	echo "El archivo \'$1\' no existe."
	exit 1
fi

if [[ $(head -n 1 "$1" | awk -F ',' '{print $3}') != "pH" ]]; then
	echo "El archivo tiene no tiene el formato correcto. Debe tener almenos una columna de pH."
	exit 1
fi

linies=$( cat $1 | awk -F ',' '{print $3}' | grep -E '[0-9]+(\.[0-9]+)?' )
total=0
mes=0
menys=0
for line in $linies; do
	total=$((total+1))
	limit=6.5
	limit2=8.5
	comparacio=$(echo "$line < $limit" | bc -l)
	comp2=$(echo "$line > $limit2" | bc -l) 
	if [ $comparacio -eq 1 ]; then
		menys=$((menys+1))
	elif [ $comp2 -eq 1 ]; then
		mes=$((mes+1))
	fi
done

echo "Total de muestras analizadas: $total"
echo "Muestras con ph por debajo de $limit: $menys"
echo "Muestras con ph por encima de $limit2: $mes"
