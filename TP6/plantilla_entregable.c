#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

#define MAX_INPUT 100

void sigusr1(int signo)
{
  printf("[signal] El fill ha rebut el SIGUSR1\n");
}

void sigusr2(int signo)
{
  printf("[signal] El pare ha rebut el SIGUSR2\n");
}

int main(void)
{
    int parent_pid, child_pid;
    int fd[2];

    char missatge[MAX_INPUT];
    char uppercase[MAX_INPUT];
    char reversed[MAX_INPUT];

    pipe(fd);

    child_pid = fork();
    if (child_pid == 0) { // fill

        /* Afagar el pid del pare */
        parent_pid = getppid();

        /* Inserir codi aqui per gestionar senyals */

        /* Esperar a rebre senyal del pare */

        /* Llegir el missatge que ens envía el pare */

        // Transformar a uppercase
        int i = 0;
        while (missatge[i]) {
            uppercase[i] = toupper(missatge[i]);
            i++;
        }

        /* Escriure el missatge per enviar al pare */

        /* Avisar al pare */

        /* Esperar a tornar a rebre la senyal del pare */

        /* Llegir el missatge que ens envía el pare */

        // Invertir missatge
        int len = strlen(missatge);
        for (int i = 0; i < len; i++) {
            reversed[i] = missatge[len - i - 1];
        }

        /* Escriure el missatge per enviar al pare */

        /* Avisar al pare */

        exit(EXIT_SUCCESS);
    } else {
        /* Inserir codi aqui per gestionar senyals */

        /* Llegir cadena stdin */
        printf("Introdueix una cadena: ");
        fgets(missatge, sizeof(missatge), stdin);

        /* Escriure el missatge per enviar al fill */

        /* Avisar al fill */

        /* Esperar a que el fill acabi */

        /* Llegir el missatge que ens envía el fill */
        printf("[pare] Cadena uppercase rebuda: %s", missatge);

        /* Tornar a escriure el missatge al fill */

        /* Tornar a avisar al fill */

        /* Tornar a esperar que el fill acabi */

        /* Llegir el missatge que ens envía el fill */
        printf("[pare] Cadena invertida rebuda: %s \n", missatge);

        wait(NULL);
        exit(EXIT_SUCCESS);
    }

    return 0;
}
