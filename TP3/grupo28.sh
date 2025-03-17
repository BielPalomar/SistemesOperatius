#!/bin/bash

# Comprobamos que se introduzcan los 3 parámetros adecuados
if [ $# -ne 3 ]; then
    echo "Nombre de parámetros incorrecto: $0 <directorio_logs> <nombre_aplicación> <código respuesta http>"
    exit 1
fi

# Comprobamos que el primer parámetro sea un directorio
if [ ! -d "$1" ]; then
    echo "El primer parámetro debe ser un directorio: $0 <directorio_logs> <nombre_aplicación> <código respuesta http>"
    exit 1
fi

# Comprobamos que el 2º parámetro sea un componente
#-q lo ponemos para que el comando grep actúe en modo silecioso y solo devuelva un 0 o un 1
if ! echo api static video | grep -q "$2"; then  
    echo "El parámetro no es uno de los componentes de la aplicación"
    exit 1
fi

# Buscamos los ficheros con el nombre del componente pasado por parámetro
ficheros=$( find "$1" -type f -name "${2}.*")

# Por cada fichero buscamos los datos correspondientes
for fichero in $ficheros
do

# Esto imprimirá las líneas del fichero que contengan el patrón que pasamos por parámetro
# en la posición 3 evitando con \b que si pones un número como el 2 te imprima porque lo encuentra en 200.
    grep -E "^[^ ]+ [^ ]+ ${3}\b" "$fichero"
	
done

exit 0 

