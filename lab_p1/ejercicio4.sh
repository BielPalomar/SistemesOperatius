#!/bin/bash
if [ $# -ne 2 ]; then
	echo "El nombre de parametres és incorrecte: ./ejercicio4.sh <medio> <distancia>"
	exit 1
fi

if [ "$1" != "coche" ] &&  [ "$1" != "bus" ] && [ "$1" != "tren" ] && [ "$1" != "bici" ]; then 
	echo "El medio proporcionado no es correcto, opciones: coche bus tren bici"
	exit 1
fi

echo "Medio de transporte: $1"

echo "Distancia: $2 km "

emision=0
if [ "$1" = "coche" ]; then
	emision=$((120 * $2))
elif [ "$1" = "bus" ]; then
	emision=$((70 * $2))
elif [ "$1" = "tren" ]; then
	emision=$((30 * $2))
else
	emision=0
fi

emision=$(echo "$emision" | awk '{print $1 / 1000}')
echo "Emision: $emision kg CO2"

emisionCoche=$((120 * $2))
emisionCoche=$(echo "$emisionCoche" | awk '{print $1 / 1000}')

ahorro=$(echo "$emisionCoche $emision" | awk '{print $1 - $2}')
echo "Ahorro respecto al coche: $ahorro kg CO2"


if [ "$1" != "tren" ]; then
	echo "¿Podria sugerirte ir en tren ya que es la opción más eficiente?"
else
	echo "¡Excelente elección! El tren és $ahorro veces más eficiente que el coche para esta distancia"
fi
exit 0
