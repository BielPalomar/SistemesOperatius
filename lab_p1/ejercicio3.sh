#!/bin/bash
if [ $# -ne 8 ]; then
	echo "Nombre de parametres incorrecte: <hora> <dia1> <dia2> <dia3> <dia4> <dia5> <dia6> <dia7>"
	exit 1
fi

if [ $1 -lt 0 ] || [ $1 -gt 23 ]; then
	echo "La hora ha de estar en format 24h (0-23)"
	exit 1
fi

echo "Análisi de consumo energético - $1:00h"

for i in {1..7};
do
	temp=$((i+1))
	numCaracters=$((${!temp} / 25))
	echo $numCaracters
	echo -n "Dia $i: ${!temp} Kwh "
	for ((j = 1; j <= $numCaracters; j++))
	do
		echo -e -n  "\u2588"
	done
	echo ""
done

if [ $2 -lt $8 ]; then
	echo -e "Tendecnia: CRECIENTE \u2191"
elif [ $2 -gt $8 ]; then
	echo -e "Tendencia: DECRECIENTE \u2193"
else
	echo -e "Tendencia: ESTABLE -"
fi

exit 0
