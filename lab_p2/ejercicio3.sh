#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Uso: ejercicio3.sh <directorio_datos>"
	exit 1
fi

if [ ! -d "$1" ]; then
	echo "El directorio $1 no és un directorio o no existe"
	exit 1
fi

echo "Analizando datos de precipitaciones..."
echo "======================================"
echo "ESTACIONES CON RIESGO DE SEQUIA (precipitación total < 30mm):"
echo "--------------------------------------"


contadorSequia=0
contadorInundacion=0
totalEstaciones=0
touch temp.txt
for file in $1/*; do
	total=0	
	totalEstaciones=$(( $totalEstaciones + 1 ))
	linies=$(cat $file  | awk -F ',' '{print $2}' |  grep -E '[0-9]+(\.[0-9]+)')
	for line in $linies; do
		total=$( echo "$total $line" | awk '{print $1 + $2}')
	done
	if [ "$(echo "$total 30" | awk '{print ($1 < $2)}')" -eq 1 ]; then
		contadorSequia=$(( $contadorSequia + 1 ))
		nom=$(echo $file | awk -F '/' '{print $NF}')
		nom=$(echo $nom | awk -F '.' '{print $1}')
		echo "$nom : $total mm"
	fi
done
echo 
echo "ESTACIONES CON RIESGO DE INUNDACIÓN (precipitación diaria > 50 mm):"
echo "--------------------------------------"
for file in $1/*; do 
	primer=1
	linies=$(cat $file | awk -F ',' '{print $0}' | grep -E  '[0-9]+(\.[0-9]+)')
	for line in $linies; do
		numero=$(echo "$line" | awk -F ',' '{print $2}')
		if [ "$(echo "$numero 50" | awk '{print ($1 > $2)}')" -eq 1 ]; then
			if [[ $primer -eq 1 ]]; then
				nom=$(echo $file | awk -F '/' '{print $NF}')
				nom=$(echo $nom | awk -F '.' '{print $1}')
				echo "$nom :"
				primer=0
			fi
			data=$(echo "$line" | awk -F ',' '{print $1}')
			echo "$data : $numero mm"
			contadorInundacion=$(( $contadorInundacion + 1 ))
		fi
	done
done
echo
echo "ESTADÍSTICAS GENERALES:"
echo "---------------------------------------"
echo "Total de estaciones analizadas: $totalEstaciones"
echo "Estaciones con riesgo de sequía: $contadorSequia"
echo "Estaciones con riesgo de inundación: $contadorInundacion"


exit 0
