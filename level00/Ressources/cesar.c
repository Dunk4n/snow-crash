#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdint.h>

int main(int ac, char **av)
    {
    unsigned int cnt;
    int key;

    cnt = 0;
    key = 0;

    if (ac != 3)
        return (1);

    key = atoi(av[2]);
    if (key < 0)
        return (1);

    key = key % 26;

    cnt = 0;
    while(av[1][cnt] != '\0')
        {
        if (av[1][cnt] >= 'a' && av[1][cnt] <= 'z')
            {
            av[1][cnt] = ((char) (((av[1][cnt] - 'a') + ((unsigned int) key)) % 26)) + 'a';
            }
        else if (av[1][cnt] >= 'A' && av[1][cnt] <= 'Z')
            {
            av[1][cnt] = ((char) (((av[1][cnt] - 'A') + ((unsigned int) key)) % 26)) + 'A';
            }

        if (cnt < UINT32_MAX)
            cnt++;
        else
            return (1);
        }

    printf("%s\n", av[1]);
    return (0);
    }
