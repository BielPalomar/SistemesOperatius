#include <stdio.h>
#include <stdlib.h>

int main(void) {
  int i, j;
  char **matriu;

  // Creem una matriu 10x10 i omplim de valors
  matriu = (char **) malloc(sizeof(char *) * 10);
  for (i = 0; i < 10; i++) {
    matriu[i] = (char *) malloc(sizeof(char) * 10);

    for (j = 0; j < 10; j++) {
      matriu[i][j] = i + j;
    }
  }

  // Escribim matriu per pantalla
  printf("Matriu:\n");
  for (i = 0; i < 10; i++) {
      for (j = 0; j < 10; j++) {
          printf("%d\t", matriu[i][j]);
      }
      printf("\n");
  }

  free(matriu);

  return 0;
}
