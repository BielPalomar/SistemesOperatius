#include <stdio.h>
#include <string.h>

int main(void)
{
    int i;
    char str[200];
    
    i = 0;
    while (scanf("%s", str) > 0) {
        i++;
    }

    printf("Numero total de palabras: %d\n", i);
    
    return 0;
}
