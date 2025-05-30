#include <stdio.h>
#include <stdlib.h>
#include "red-black-tree.h"
#include "estadisticas.h"
#include "ficheros-csv.h"

/**
 *
 * Main function.
 *
 */

int main(int argc, char **argv) {
    FILE *fp;

    if (argc != 4) {
        printf("Use: %s <filename.csv> <llista_aeroports.csv> <aeroport>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    /* Abrimos el fichero con la lista de aeropuertos */
    fp = fopen(argv[2], "r");
    if (!fp) {
        printf("Could not open file '%s'\n", argv[2]);
        exit(EXIT_FAILURE);
    }

	/* Inicializar árbol y leer los datos del fichero de aeropuertos */ 

    fclose(fp);

    /* Abrimos el fichero con los datos de los vuelos */
    fp = fopen(argv[1], "r");
    if (!fp) {
        printf("Could not open file '%s'\n", argv[1]);
        exit(EXIT_FAILURE);
    }

	/* Leer los datos e introducirlos en el árbol */
    fclose(fp);

    rb_tree* arbol = create_tree(argv[2], argv[1]);

    /* Mostramos la media de retardos y el máximo de destinos */
    printf("Media de retardos para %s\n", argv[3]);
    estadisticas_media_retardos(arbol, argv[3]);

    printf("\nAeropuerto con mas destinos\n");
    estadisticas_max_destinos(arbol);

    /* Borramos el arbol y lo aliberamos llamando antes a delete_tree y luego free */
    delete_tree(arbol);
    free(arbol);

    return EXIT_SUCCESS;
}
