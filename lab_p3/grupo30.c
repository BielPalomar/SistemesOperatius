#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>
#include <time.h>

#define PAIS1_ID 1
#define PAIS2_ID 2
#define CAPACIDAD_CARGA 1000
#define UMBRAL_MEDIO 750
#define UMBRAL_BAJO 450

sigset_t mask, oldmask;

int pipe1[2];  // Primer pipe
int pipe2[2];  // Segon pipe
int N;
int sigusrvar1 = 0;

float recursosPais1;
float recursosPais2;

float recursos = CAPACIDAD_CARGA;

void sigusr1(){
    sigusrvar1 = 1;
}


void fill(){
  // Código del primer hijo
  srand(getpid());
  signal(SIGUSR1, sigusr1);
  //REBRE VALORS DE MAX MIG MIN I N DEL PARE
  for(int i = 0; i < N; i++){
    while(!sigusrvar1){}
    sigusrvar1 = 0;
  
    float limitAnual;
    read(pipe1[0], &limitAnual, sizeof(float)); // Lee mensaje del padre

    printf("Limit anual es %f\n", limitAnual);

    float recursosExtreure = rand() % ((int) limitAnual);
    write(pipe2[1], &recursosExtreure, sizeof(float));
  }
  close(pipe1[1]); // No escribe en pipe1
  close(pipe2[0]); // No lee de pipe2
  close(pipe1[0]);
  close(pipe2[1]);

  exit(0);
}

void recuperacioAnual(float recursosActuals){
    float pb = 0.05;
    if(recursosActuals <= 750 && recursosActuals > 450){
        pb = 0.20;
    }
    float pv = 0;
    srand(time(NULL));
    int cas = rand() % 100; // num de 0 a 99

    if (cas < 75) {
        printf("[Evento] Este año se han producido condiciones normales de recuperación \n");
        pv = 0;
    } else if (cas < 90) {
        printf("[Evento] Este año se han producido condiciones adversas de recueración \n");
        pv = -0.15;
    } else {
        printf("[Evento] Este año se han producido condiciones favorables de recuperación \n");
        pv = 0.1;
    }

    float prob = pb + pv;
    if(prob < 0){
        prob = 0;
    }

    printf("[Evento] El porcentage de recuperación es del %f\n", prob);
    float increment = recursosActuals * prob;
    if(increment + recursosActuals > 1000){
      recursos = 1000;
    }else{
      recursos = recursosActuals + increment;
    }
    printf("[Coordinador] Los recursos se recuperaron en %f unidades\n", increment);

}
int main(int argc, char *argv[])
{
      // Leer parámetros
  if (argc != 5)
  {
    printf("%s <lim_alto> <lim_medio> <lim_bajo> <N>\n", argv[0]);
    exit(1);
  }

  float lim_alto = atof(argv[1]);
  float lim_medio = atof(argv[2]);
  float lim_bajo = atof(argv[3]);

  pipe(pipe1);
  pipe(pipe2);

  N = atoi(argv[4]);

  if (N < 1)
  {
    printf("N no pot ser zero o negatiu!\n");
    exit(1);
  }

  recursosPais1 = 0;
  recursosPais2 = 0;
  // signal(SIGUSR1, sigusr1);

  int child_pid1 = fork(); //Fill 1
  if (child_pid1 == 0) {
    fill();
    return 1;
  }

  int child_pid2 = fork(); //Fill 2
  if (child_pid2 == 0) {
    fill();
    return 1;
  }

  // Padre escribe mensajes para los hijos
  /* const char *msg1 = "Mensaje para hijo 1";
  const char *msg2 = "Mensaje para hijo 2";

  write(pipe1[1], msg1, strlen(msg1) + 1);
  write(pipe2[1], msg2, strlen(msg2) + 1);
  */

  recursos = CAPACIDAD_CARGA;
  for(int i = 1; i <= N; i++){
    printf("* AÑO %d \n", i);
    printf("[Coordinador] Los recursos disponibles para el año son %f\n", recursos );
    //Calculo limites
    float limiteAnual = 0;
    if(recursos <= 1000 && recursos > 750){
        limiteAnual = lim_alto;
    }
    else if(recursos < 750 && recursos > 450){
      limiteAnual = lim_medio;
    }
    else if(recursos <= 450 && recursos > 0){
      limiteAnual = lim_bajo;
    }

    float llegitsPais1, llegitsPais2;
    printf("[Coordinador] El límite de extracción para el año en curso es %f\n", limiteAnual);
    
    write(pipe1[1], &limiteAnual, sizeof(float));
    kill(child_pid1, SIGUSR1);
    read(pipe2[0], &llegitsPais1, sizeof(float));
    printf("[Coordinador] El pais 1 solicita extraer %f\n", llegitsPais1);
    
    printf("[Coordinador] La solicitud del pais 1 se ha aprobado\n");
    recursos = recursos - llegitsPais1;
    if(recursos < 0) recursos = 0;
    recursosPais1 = recursosPais1 + llegitsPais1;
  
    
    write(pipe1[1], &limiteAnual, sizeof(float));
    kill(child_pid2, SIGUSR1);
    read(pipe2[0], &llegitsPais2, sizeof(float));
    printf("[Coordinador] El pais 2 solicita extraer %f\n", llegitsPais2);

    printf("[Coordinador] La solicitud del pais 2 se ha aprobado\n");
    recursos = recursos - llegitsPais2;
    if(recursos < 0) recursos = 0;
    recursosPais2 = recursosPais2 + llegitsPais2;

    //Copiar per pais 2?

    recuperacioAnual(recursos);
    printf("\n");

  }

  


  close(pipe1[0]); 
  close(pipe2[1]);
  close(pipe1[1]);
  close(pipe2[0]);

  int status;

  // Esperar a los dos hijos
  waitpid(child_pid1, &status, 0);
  waitpid(child_pid2, &status, 0);

  printf("La simulación ha finalizado\n");
  printf("Recursos extraídos por país 1: %f\n", recursosPais1);
  printf("Recursos extraídos por país 2: %f\n", recursosPais2);
  printf("Total recursos extraídos: %f\n", recursosPais1 + recursosPais2);
  printf("Recursos disponibles: %f\n", recursos);

  return 0;

}
