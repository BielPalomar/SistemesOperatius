#!/bin/bash
if [ $# -ne 8 ]; then
	echo "Nombre de parametres incorrecte: ./ejercicio3.sh <hora> <dia1> <dia2> <dia3> <dia4> <dia5> <dia6> <dia7>"
	exit 1
fi

if [ $1 -lt 0 ] || [ $1 -gt 23 ]; then
	echo "La hora ha de estar en format 24h (0-23)"
	exit 1
fi

hora=$1
shift
echo "Análisi de consumo energético - $hora:00h"

for i in {1..7};
do
	temp=${!i}
	numCaracters=$(($temp / 25))
	echo ""
	echo -n "Dia $i: $temp Kwh "
	for ((j=1;j<=numCaracters;j++))
	do
		echo -e -n  "\u2588"
	done
	echo ""
done

if [ $1 -lt $7 ]; then
	echo -e "Tendencia: CRECIENTE \u2191"
elif [ $1 -gt $7 ]; then
	echo -e "Tendencia: DECRECIENTE \u2193"
else
	echo -e "Tendencia: ESTABLE -"
fi

exit 0
