
/* Codigo escrito por Lluis Garrido */

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "ficheros-csv.h"

/**
 *
 * Esta funcion crea el arbol a partir de los datos de los aeropuertos y de los ficheros de retardo
 *
 */
#define MAX_AEROPORT_LENGTH 4
#define MAX_DATA_LENGTH 256

rb_tree *create_tree(char *str_airports, char *str_dades)
{
    /* Creamos el arbol*/
    rb_tree *tree = malloc(sizeof(rb_tree));

    init_tree(tree);

    /* Abrimos el fichero con los nombres de los aeropuertos y los insertamos en el arbol */
    FILE *fp = fopen(str_airports, "r");
    read_airports(tree, fp);

    fclose(fp);

    /* Abrimos el fichero con los datos de los aeropuertos y guardamos los datos en el arbol */
    fp = fopen(str_dades, "r");
    read_airports_data(tree, fp);

    fclose(fp);

    return tree;
}

/**
 *
 * Esta funcion lee la lista de los aeropuertos y crea el arbol 
 *
 */

void read_airports(rb_tree *tree, FILE *fp) 
{
    int i, num_airports;
    char line[MAXCHAR];

    /*
     * eow es el caracter de fin de palabra
     */
    char eow = '\0';


    fgets(line, 100, fp);
    num_airports = atoi(line);

    i = 0;
    while (i < num_airports)
    {
        fgets(line, 100, fp);
        line[3] = eow; 

        /* Creamos un nodo, inicializamos su lista y lo insertamos en el árbol */
        node_data* nodo = malloc(sizeof(node_data));
        nodo->key = malloc(sizeof(char) * 4);
        nodo->linkedList = malloc(sizeof(list));
        strcpy(nodo->key, line);
        init_list(nodo->linkedList);
        
        insert_node(tree, nodo);

        i++;
    }
}

/**
 * Función que permite leer todos los campos de la línea de vuelo: origen,
 * destino, retardo.
 * 		
 */

static int extract_fields_airport(char *line, flight_information *fi) {

    /*Recorre la linea por caracteres*/
    char caracter;
    /* i sirve para recorrer la linea
     * iterator es para copiar el substring de la linea a char
     * coma_count es el contador de comas
     */
    int i, iterator, coma_count;
    /* start indica donde empieza el substring a copiar
     * end indica donde termina el substring a copiar
     * len indica la longitud del substring
     */
    int start, end, len;
    /* invalid nos permite saber si todos los campos son correctos
     * 1 hay error, 0 no hay error pero no hemos terminado
     */
    int invalid = 0;
    /*
     * eow es el caracter de fin de palabra
     */
    char eow = '\0';
    /*
     * contenedor del substring a copiar
     */
    char *word;
    /*
     * Inicializamos los valores de las variables
     */
    start = 0;
    end = -1;
    i = 0;
    coma_count = 0;
    /*
     * Empezamos a contar comas
     */
    do {
        caracter = line[i++];
        if (caracter == ',') {
            coma_count ++;
            /*
             * Cogemos el valor de end
             */
            end = i;
            /*
             * Si es uno de los campos que queremos procedemos a copiar el substring
             */
            if(coma_count == ATRASO_LLEGADA_AEROPUERTO || 
                    coma_count == AEROPUERTO_ORIGEN || 
                    coma_count == AEROPUERTO_DESTINO){
                /*
                 * Calculamos la longitud, si es mayor que 1 es que tenemos 
                 * algo que copiar
                 */
                len = end - start;
                if (len > 1) {
                    /*
                     * Alojamos memoria y copiamos el substring
                     */
                     word =(char*)malloc(sizeof(char)*(len));
                     for(iterator = start; iterator < end-1; iterator ++){
                         word[iterator-start] = line[iterator];
                        }
                        /*
                        * Introducimos el caracter de fin de palabra
                        */
                        word[iterator-start] = eow;
                        /*
                        * Comprobamos que el campo no sea NA (Not Available) 
                        */
                    if (strcmp("NA", word) == 0){
                        invalid = 1;
                    }
                    else {
                        switch (coma_count) {
                            case ATRASO_LLEGADA_AEROPUERTO:
                                fi->delay = atoi(word);
                                break;
                            case AEROPUERTO_ORIGEN:
                                strcpy(fi->origin, word);
                                break;
                            case AEROPUERTO_DESTINO:
                                strcpy(fi->destination, word);
                                break;
                            default:
                                printf("ERROR in coma_count\n");
                                exit(1);
                        }
                    }

                    free(word);

                } else {
                    /*
                     * Si el campo esta vacio invalidamos la linea entera 
                     */


                    invalid = 1;
                }
            }
            start = end;
        }
    } while (caracter && invalid==0);

    return invalid;
}

/**
 *
 * Esta funcion lee los datos de los vuelos y los inserta en el 
 * arbol (previamente creado)
 *
 */

void read_airports_data(rb_tree *tree, FILE *fp) {
    char line[MAXCHAR];
    int invalid;

    flight_information fi;


    /* Leemos la cabecera del fichero */
    fgets(line, MAXCHAR, fp);
    
    while (fgets(line, MAXCHAR, fp) != NULL)
    {
        invalid = extract_fields_airport(line, &fi);

        if (!invalid) {
            
			/* Inserción de datos en el arbol 
			 */

            node_data *nodo = find_node(tree, fi.origin);

            if(nodo == NULL){
                printf("Nodo es NULL\n");
                exit(EXIT_FAILURE);
            }
            
            /* Cogemos la lista del nodo */
            list* llista = nodo->linkedList;

            /* Buscamos en la lista el elemento con key fi.destination */
            list_data* data = find_list(llista, fi.destination);

            /* Si no existe lo creamos y lo insertamos en la lista 
                con el retardo total de 0 y numero de vuelos 0 */
            if(data == NULL){
                data = malloc(sizeof(list_data));
                data->key = malloc(sizeof(char) * 4);
                strcpy(data->key, fi.destination);

                data->info.retard = 0;
                data->info.n_vols = 0;

                insert_list(llista, data);
            }

            /* Una vez encontrado (o creado) el elemento en la lista, le añadimos los datos
            del vuelo que estamos considerando */
            data->info.retard += fi.delay;
            data->info.n_vols += 1;

        }
    }
}



