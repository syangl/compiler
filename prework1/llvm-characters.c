#include<stdio.h>

int global_var = 100;
int function(int a, int b, int c, float f){
    // 写一个变量交换值
    int temp = a;
    a = b;
    b = temp;
    //写一个体现临时寄存器升序的语句
    c = a + b + c;
    //隐式类型转换
    int turn = f;
    return turn;
}

int main(){
    printf("%d\n",function(1,2,3,3.1415));
    return 0;
}