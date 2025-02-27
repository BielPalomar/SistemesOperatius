#!/bin/bash


# Comprovem que el nombre d'arguments que rebem és 1
if [ $# -ne 1 ]
then
   echo "Nombre de parametres incorrecte: $0 <fitxer>"
   exit 1 # Retornem un error
fi

# Comprovem si l'argument rebut existeix 
if [ ! -e "$1" ]; then
	echo "El argumento proporcionado no existe."
	exit 1 # Retornem un error
fi

# Comprovem si l'argument rebut és un directori
if [ -d "$1" ]; then
	echo "El argumento proporcionado es un directorio."
	exit 1 # Retornem un error
fi

# Comprovem si l'argument rebut no és un fitxer
if [ ! -f "$1" ]; then
	echo "El argumento proporcionado no es un fichero."
	exit 1 # Retornem un error
fi

# Guardem el contingut de l'arxiu a la variable 'directoris'
directoris=$(cat $1)

# Llegim línia a línia el contingut de l'arxiu 
for i in $directoris; do
	
	# Dividim la línia e dues parts, abans del ';' i després del ';'
	# Guardem la primera part de la línia a la variable 'archivo', aquesta part indica el nom de l'arxiu
	# Guardem la segona part de la línia a la variable 'numLin', aquesta part indica el nombre de línies de l'arxiu que hem de llegir
	IFS=';' read -r archivo numLin <<< "$i"

	# Verifiquem si l'arxiu existeix abans d'intentar llegir-ho
	if [ ! -e "$archivo" ]; then
		echo "El archivo $archivo proporcionado no existe."
		continue # Si no existeix passem al següent arxiu
		
	fi

	# Verifiquem que l'arxiu és un fitxer
	if [ -f "$archivo" ]; then
	
		echo "Primeres $numLin linies del fitxer $archivo"
	
		# Fem un bucle que imprimeix el nombre de línies del fitxer indicades a la variable 'numLin' 
		for ((i = 1; i <= numLin; i++)); do
		
			lineas=$(awk "NR==$i" $archivo) # Obtenim la línia número 'i'
		
			echo "$lineas" # Imprimim la línia
			
		done
	
	else
		# En cas que l'arxiu no sigui un fitxer retornem el següent missatge: 
		echo "El argumento $archivo proporcionado no es un archivo."
		continue # Passem al següent arxiu
		
	fi
	
	
	
done
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
