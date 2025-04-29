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

void sigusr1(){
    sigusrvar1 = 1;
}


void fill1(){
  // Código del primer hijo
  srand(getpid());
  signal(SIGUSR1, sigusr1);
  //REBRE VALORS DE MAX MIG MIN I N DEL PARE
  for(int i = 0; i < N; i++){
    char buffer[100];
    read(pipe1[0], buffer, sizeof(buffer)); // Lee mensaje del padre

    float recursosExtreure = rand() % 1000;
    write(pipe2[1], &recursosExtreure, sizeof(float));
  }
  close(pipe1[1]); // No escribe en pipe1
  close(pipe2[0]); // No lee de pipe2
  close(pipe1[0]);
  close(pipe2[1]);
  
  while(!sigusrvar1){}
  sigusrvar1 = 0;

  exit(0);
}

void fill2(){
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
        CAPACIDAD_CARGA = 1000;
    }else{
        CAPACIDAD_CARGA = recursosActuals + increment;
    }
    prinf("[Coordinador] Los recursos se recuperaron en %f unidades", increment);

}
int main(int argc, char *argv[])
{
      // Leer parámetros
  if (argc != 5)
  {
    printf("%s <lim_alto> <lim_medio> <lim_bajo> <N>\n", argv[0]);
    exit(1);
  }

  int lim_alto = atof(argv[1]);
  int lim_medio = atof(argv[2]);
  int lim_bajo = atof(argv[3]);
  N = atoi(argv[4]);

  if (N < 1)
  {
    printf("N no pot ser zero o negatiu!\n");
    exit(1);
  }
  recursosPais1 = 0;
  recursosPais2 = 0;
  signal(SIGUSR1, sigusr1);

  int child_pid1 = fork(); //Fill 1
  if (child_pid1 == 0) {
    fill1();
  }

  int child_pid2 = fork(); //Fill 2
  if (child_pid2 == 0) {
    fill2();
  }

  // Padre escribe mensajes para los hijos
  const char *msg1 = "Mensaje para hijo 1";
  const char *msg2 = "Mensaje para hijo 2";

  write(pipe1[1], msg1, strlen(msg1) + 1);
  write(pipe2[1], msg2, strlen(msg2) + 1);

  for(int i = 0; i < N; i++){
    printf("* AÑO %d \n", i);
    printf("[Coordinador] Los recursos disponibles para el año son %d\n ", CAPACIDAD_CARGA );
    //Calculo limites
    int limiteAnual = 0;
    if(CAPACIDAD_CARGA <= 1000 && CAPACIDAD_CARGA > 750){
        limiteAnual = lim_alto;
    }
    else if(CAPACIDAD_CARGA < 750 && CAPACIDAD_CARGA > 450){
      limiteAnual = lim_medio;
    }
    else if(CAPACIDAD_CARGA <= 450 && CAPACIDAD_CARGA > 0){
      limiteAnual = lim_bajo;
    }
    printf("[Coordinador] El límite de extracción para el año en curso es %d\n", limiteAnual);


    char response[100];
    read(pipe1[0], response, sizeof(response));

    printf("[Coordinador] El pais 1 solicita extraer %d\n", response);

    if(response < limiteAnual){
        printf("[Coordinador] La solicitud del pais 1 se ha aprobado");
        CAPACIDAD_CARGA = CAPACIDAD_CARGA - response;
        recursosPais1 = recursosPais1 + response;
    }else{
        printf("[Coordinador] La solicitud del pais 1 se ha rechazado");
    }

    //Copiar per pais 2?

    recuperacioAnual(CAPACIDAD_CARGA);

  }

  


  close(pipe1[0]); 
  close(pipe2[1]);
  close(pipe1[1]);
  close(pipe2[0]);

  // Esperar a los dos hijos
  wait(NULL);
  wait(NULL);


  return 0;

}
