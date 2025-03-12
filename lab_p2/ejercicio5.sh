#!/bin/bash

if [ $# -ne 1 ]; then
	echo "Uso: ejercicio3.sh <directorio_datos>"
	exit 1
fi

if [ ! -d "$1" ]; then
	echo "El directorio $1 no és un directorio o no existe"
	exit 1
fi

nom=$(echo $1 | awk -F '/' '{print $NF}')
echo "Iniciando organización de archivos de $nom"
echo "Iniciando organización de archivos de $nom" >> $1/informe_organizacion.txt
contadorMovidos=0
contador=0
categorias=0
paraulaAnterior=""
for file in $1/*; do
	if [ -f $file ]; then
		paraula=$(echo "$file" | awk -F '/' '{print $NF}')
		paraula=$(echo "$paraula" | awk -F '_' '{print $1 }')
		if [ ! -d $1/$paraula ]; then
			categorias=$(( $categorias + 1 ))
			if [ $paraula != "informe" ]; then
				mkdir $1/$paraula
				echo "Directorio creado: $1/$paraula"
				echo "Directorio creado: $1/$paraula" >> $1/informe_organizacion.txt
			fi
		fi
	fi
done
for file in $1/*; do
	if [ -f $file ]; then
		contador=$(( $contador + 1 ))
		paraula=$(echo "$file" | awk -F '/' '{print $NF}')
		paraula=$(echo "$paraula" | awk -F '_' '{print $1 }')
		if [ $paraula != "informe" ]; then
			mv $file $1/$paraula
			echo "Movido: $file -> $paraula/"
			echo "Movido: $file -> $paraula/" >> $1/informe_organizacion.txt
			contadorMovidos=$(( $contadorMovidos + 1 ))
		fi
	fi
done

echo
echo "Organización completada."
echo "-------------------------"
echo "Total de archivos procesados: $contador"
echo "Archivos movidos: $contadorMovidos"
echo "Categorías detectadas: $categorias"
echo "Se ha generado un informe en: $1/informe_organizacion.txt"

echo >> $1/informe_organizacion.txt
echo "Organización completada." >> $1/informe_organizacion.txt
echo "-------------------------" >> $1/informe_organizacion.txt
echo "Total de archivos procesados: $contador" >> $1/informe_organizacion.txt
echo "Archivos movidos: $contadorMovidos" >> $1/informe_organizacion.txt
echo "Categorías detectadas: $categorias" >> $1/informe_organizacion.txt
echo "Se ha generado un informe en: $1/informe_organizacion.txt" >> $1/informe_organizacion.txt

exit 0
