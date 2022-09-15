
#include <stdio.h>
int NUM=100;

int n;

static int m= 36;
int sum(int _a,int _b)
{
    int c=0;
    c=_a+_b;
    printf("c的地址是 %p\n",&c);
    return c;
}
 
 
int main()
{
    
    int a=10;
    int b=20; 

    int cc ;

    printf("cc的地址是 %p\n",&cc);
    printf("NUM的地址是 %p\n",&NUM);
    int ret=sum(a,b);
    return 0;
}
