#include <stdio.h>
#include <stdlib.h>

int x;
int y;

/*
 * Very unoptimized add function
 */
int add2(int a, int b)
{
  int partial = 0;
  partial += a;
  partial += b;
  return partial;
}

int main(int argc, char* argv[]) {
  switch (argc)
  {
  case 1:
    x = 1;
    y = 1;
    break;
  case 2:
    x = atoi(argv[1]);
    y = 1;
    break;
  case 3:
    x = atoi(argv[1]);
    y = atoi(argv[2]);
    break;
  }

  printf("On ARM %d + %d is still %d\n", x, y, add2(x, y));
}
