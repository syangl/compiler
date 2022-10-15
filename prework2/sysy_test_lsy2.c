#include<stdio.h>

int my_func(int c){
    int a = 10;
    int b = 100;
    c = a + b;
    while(c / 10 == 11){
        printf("c = %d\n", c);
        if (c < 110){
            c += 10;
        }else{
            c += 10;
        }
    }
    return c;
}

int main(){
    int d = my_func(0);
    printf("d = %d\n", d);
    return 0;
}