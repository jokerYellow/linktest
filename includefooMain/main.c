#include "stdio.h"

extern char* fooname();

int main(int argc, char const *argv[])
{
    printf("%s",fooname());
    return 0;
}
