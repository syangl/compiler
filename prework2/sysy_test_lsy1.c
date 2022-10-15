#include<stdio.h>
// 尽可能体现要实现的语言特性，4、5、6、7条
void main(){
    int i = 0, k = 4;
    int a[10];
    int b[10];

    while(i < 10){
        a[i] = i + 1; // 1~10
        i++;
    }

    i = 0;
    while(i < 10){
        if (i < 6){
            b[9 - i] = a[i];
        }else{
            b[9 - i] = k * i;
        }
        
        printf("array b[%d] is: %d\n", i, b[9 - i]);
        i++;
    }


}