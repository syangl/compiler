	.arch armv8-a
	.arch_extension crc
	.arm
	.global main
	.type main , %function
main:
	push {r4, fp, lr}
	mov fp, sp
	sub sp, sp, #4
.L3:
	ldr r4, =10
	str r4, [fp, #-4]
	ldr r4, [fp, #-4]
	cmp r4, #0
	movgt r4, #1
	movle r4, #0
	bgt .L5
	b .L7
.L5:
	mov r0, #1
	add sp, sp, #4
	pop {r4, fp, lr}
	bx lr
	b .L6
.L6:
	mov r0, #0
	add sp, sp, #4
	pop {r4, fp, lr}
	bx lr
.L7:
	b .L6

