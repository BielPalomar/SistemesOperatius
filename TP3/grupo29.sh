
# En primer lugar, comprobamos que el número de parámetros sea el correcto.
if [ $# -ne 3 ]
then 
    echo "Nombre incorrecte de parametres."
    exit 1
fi

# Guardamos los tres parámetros en variables.
directory=$1
nom_app=$2
code=$3

# Comprobamos que el directorio dado sea válido.
if [ ! -d $directory ]; then	
	echo "El directorio $directory no existe o es incorrecto."
	exit 1
fi

# Comprobamos que el segundo parámetro es alguno de los componentes de la aplicación
# (api, static o videos).
if [[ "$nom_app" != "api" && "$nom_app" != "static" && "$nom_app" != "videos" ]]; then
	echo "El segundo parámetro ha de ser 'api', 'static' o 'videos'."
	exit 1
fi

echo

# Recorremos todos los archivos del directorio.
for archivo in "$directory"/*; do
	
	# Con el comando grep filtramos las líneas que contengan el componente de la
	# aplicación que guardamos en la variable 'nom_app'.
	
	# Además, utilizamos el comando 'awk' para filtrar las líneas que tengan en 
	# la tercera columna el código introducido. Para ello, hemos de usar una
	# variable auxiliar para lo cual introducimos '-v' y la igualamos a 'code',
	# para poder comparar su contenido con la tercera columna de la línea (que
	# filtramos usando '$3', que el comando awk interpreta como el tercer field,
	# esto es, la tercera palabra separada por el IFS por defecto, el espacio).
	
	lineas_filtradas=$(grep "$nom_app" $archivo | awk -v var="$code" '$3 == var')
	
	# En caso de haber encontrado alguna(s) línea(s) con el código y el componente
	# indicados, la(s) imprimimos.
	if [ -n "$lineas_filtradas" ]; then
		echo "$lineas_filtradas"
	fi
done

echo

exit 0
