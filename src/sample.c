#include <stdio.h>
#include <stdlib.h>

#define MAX 100

int main() 
{
    int x = 10;
    x = 20;
    if (x >= 10) 
        x++;
    else 
        x--;

    while (x < MAX) 
        x++;

    int *ptr = malloc(100);

    free(ptr);

    return 0;
}
