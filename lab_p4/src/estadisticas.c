/* Codigo escrito por Lluis Garrido, 2018 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "estadisticas.h"

/**
 * Calcula la media de retardo para los destinos de un
 * determinado aeropuerto y las imprime por pantalla.
 *
 */

void estadisticas_media_retardos(rb_tree *tree, char *origen)
{
	node_data* data = find_node(tree, origen);
	list_item* item = data->linkedList->first;
	printf("Mitjanes:\n");
	while(item != NULL){
		// printf("%s: ", item->data->key);
		printf("%f\n", (float) item->data->info.retard / item->data->info.n_vols);
		item = item->next;
	}
}

/**
 *  
 *  Funcion recursiva para encontrar el aeropuerto con mas destinos.
 */

void estadisticas_max_destinos_recursive(node *x, char **origen, int *num_destinos)
{
	int destinacions = x->data->linkedList->num_items;
	if(destinacions > *num_destinos) {
		*num_destinos = destinacions;
		*origen = x->data->key;
	}

	if(x->left != NULL){
		estadisticas_max_destinos_recursive(x->left, origen, num_destinos);
	}

	if(x->right != NULL){
		estadisticas_max_destinos_recursive(x->right, origen, num_destinos);
	}
}

/**
 *
 * Funcion que permite encontrar el aeropuerto con mas destinos. Imprime
 * el resultado por pantalla.
 *
 */

void estadisticas_max_destinos(rb_tree *tree)
{
	int max_destinos = -1;
	char* origen;
	estadisticas_max_destinos_recursive(tree->root, &origen, &max_destinos);
	printf("El aeropuerto con más destinos es %s con %d destinos.\n", origen, max_destinos);
}


