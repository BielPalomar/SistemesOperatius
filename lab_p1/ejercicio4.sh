#!/bin/bash
if [ $# -ne 2 ]; then
	echo "El número de parámetros es incorrecto: ./ejercicio4.sh <medio> <distancia>"
	exit 1
fi

emision=0

case $1 in
	"coche")
		emision=$((120 * $2))
	;;

	"tren")
		emision=$((30 * $2))
	;;

	"bus")
		emision=$((70 * $2))
	;;

	"bici")
		emision=0
	;;
	*)
		echo "El medio proporcionado no es correcto, opciones: coche bus tren bici"
		exit 1
	;;
esac
echo "Medio de transporte: $1"

echo "Distancia: $2 km "

emision=$(echo "$emision" | awk '{print $1 / 1000}')
echo "Emision: $emision kg CO2"

emisionCoche=$((120 * $2))
emisionCoche=$(echo "$emisionCoche" | awk '{print $1 / 1000}')

ahorro=$(echo "$emisionCoche $emision" | awk '{print $1 - $2}')
echo "Ahorro respecto al coche: $ahorro kg CO2"


if [ "$1" == "coche" ]; then
	echo "Has elegido la opción de transporte que más contamina!"
else
	echo "¡Excelente elección! El $1 és $ahorro veces más eficiente que el coche para esta distancia"
fi
exit 0
