#include <stdio.h>
#include <unistd.h>
#include <string.h>

int main(int argc, char **argv)
    {
    int i = 0;

    if(argc < 2)
        return (1);

    i = 0;
    while(argv[1][i] != '\0')
        {
        printf("%c", (char) (argv[1][i] - i));
        i++;
        }
    printf("\n");

    return (0);
    }
