        .arch armv7-a

.str0:
        .ascii  "array b[%d] is: %d\012\000"
        
        .text
	.align	2
        .global	main
        .type   main, %function
main:
        @init
        push    {r7, lr}
        sub     sp, sp, #88
        add     r7, sp, #0
        @int i = 0, k = 4;
        movs    r3, #0
        str     r3, [r7, #84]
        movs    r3, #4
        str     r3, [r7, #80]
        b       .LOOP1

.LOOP1BODY:
        @a[i] = i + 1; 
        @ r3 == i
        ldr     r3, [r7, #84]
        @ r2 == i + 1
        adds    r2, r3, #1

        ldr     r3, [r7, #84]
        @ r3 == i * 4
        lsls    r3, r3, #2
        @ r1 == r7 + 88
        add     r1, r7, #88
        @ r3 == r7 + 88 + i * 4
        add     r3, r3, r1
        @ r2 => [r7 + 40 + i * 4]
        str     r2, [r3, #-48]
        @i++;
        @ r3 == i
        ldr     r3, [r7, #84]
        adds    r3, r3, #1
        str     r3, [r7, #84]

.LOOP1:
        @while(i < 10)
        ldr     r3, [r7, #84]
        cmp     r3, #9
        ble     .LOOP1BODY
        @ i = 0;
        movs    r3, #0
        str     r3, [r7, #84]
        b       .LOOP2

.LOOP2BODY:
        @if (i < 6)
        ldr     r3, [r7, #84]
        cmp     r3, #5
        bgt     .LOOP2ELSE
        @ b[9 - i] = a[i];
        ldr     r3, [r7, #84]
        @ 可使用arm的逆向减法指令 r1 == 9 - i
        rsb     r1, r3, #9
        ldr     r3, [r7, #84]
        @ r3 == i * 4
        lsls    r3, r3, #2
        @ r2 == r7 + 88
        add     r2, r7, #88
        @ r3 == r7 + 88 + i * 4
        add     r3, r3, r2
        @r2 == [r7 + 40 + i * 4]
        ldr     r2, [r3, #-48]
        @ r3 == (9 - i) * 4
        lsls    r3, r1, #2
        @ r1 == r7 + 88
        add     r1, r7, #88
        @ r3 == r7 + 88 + (9 - i) * 4
        add     r3, r3, r1
        @ r2 => [r7 + (9 - i) * 4]
        str     r2, [r3, #-88]
        b       .LOOP2PRINT
.LOOP2ELSE:
        @b[9 - i] = k * i;
        ldr     r3, [r7, #84]
        rsb     r3, r3, #9
        ldr     r2, [r7, #80]
        ldr     r1, [r7, #84]
        mul     r2, r1, r2
        lsls    r3, r3, #2
        add     r1, r7, #88
        add     r3, r3, r1
        str     r2, [r3, #-88]
.LOOP2PRINT:
        @ printf("array b[%d] is: %d\n", i, b[9 - i]);
        ldr     r3, [r7, #84]
        rsb     r3, r3, #9
        lsls    r3, r3, #2
        add     r2, r7, #88
        add     r3, r3, r2
        ldr     r3, [r3, #-88]
        mov     r2, r3
        ldr     r1, [r7, #84]
        ldr     r0, _bridge
        bl      printf
        @  i++;
        ldr     r3, [r7, #84]
        adds    r3, r3, #1
        str     r3, [r7, #84]

.LOOP2:
        ldr     r3, [r7, #84]
        cmp     r3, #9
        ble     .LOOP2BODY


        @ main end
        adds    r7, r7, #88
        mov     sp, r7
        pop     {r7, pc}

_bridge:
        .word .str0