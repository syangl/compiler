
.str0:
        .ascii  "c = %d\012\000"
.str1:
        .ascii  "d = %d\012\000"

        .text
	    .align	2
	    .global my_func
        .type   my_func, %function
my_func:
        push    {r7, lr}
        sub     sp, sp, #16
        add     r7, sp, #0
        str     r0, [r7, #4]
        @    int a = 10;
        movs    r3, #10
        str     r3, [r7, #12]
        @    int b = 100;
        movs    r3, #100
        str     r3, [r7, #8]
        @    c = a + b;
        ldr     r2, [r7, #12]
        ldr     r3, [r7, #8]
        add     r3, r3, r2
        str     r3, [r7, #4]
        b       .LOOP
.LOOP_IF:
        @ printf("c = %d\n", c);
        ldr     r1, [r7, #4]
        ldr     r0, _bridge
        bl      printf
        @  if (c < 110)
        ldr     r3, [r7, #4]
        cmp     r3, #109
        bgt     .LOOP_ELSE
        @  c += 10;
        ldr     r3, [r7, #4]
        adds    r3, r3, #10
        str     r3, [r7, #4]
        b       .LOOP
.LOOP_ELSE:
        @ c += 10;
        ldr     r3, [r7, #4]
        adds    r3, r3, #10
        str     r3, [r7, #4]
.LOOP:
        @ while(c / 10 == 11)
        ldr     r3, [r7, #4]
        subs    r3, r3, #110
        cmp     r3, #9
        bls     .LOOP_IF
        @ return c;
        ldr     r3, [r7, #4]
        mov     r0, r3
        adds    r7, r7, #16
        mov     sp, r7
        pop     {r7, pc}

        .global	main
        .type   main, %function
main:
        push    {r7, lr}
        sub     sp, sp, #8
        add     r7, sp, #0
        @  int d = my_func(0);
        movs    r0, #0
        bl      my_func
        str     r0, [r7, #4]
        @ printf("d = %d\n", d);
        ldr     r1, [r7, #4]
        ldr     r0, _bridge+4
        bl      printf
        movs    r3, #0
        mov     r0, r3
        adds    r7, r7, #8
        mov     sp, r7
        pop     {r7, pc}

_bridge:
    .word .str0
    .word .str1
