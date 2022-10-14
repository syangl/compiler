	.text
	.file	"my-llvm-characters.ll"
	.globl	function                # -- Begin function function
	.p2align	4, 0x90
	.type	function,@function
function:                               # @function
# %bb.0:
	movss	%xmm0, -16(%rsp)
	movl	%edi, -20(%rsp)
	movl	%esi, -4(%rsp)
	movl	%edi, -8(%rsp)
	addl	%edi, %esi
	addl	%edx, %esi
	movl	%esi, -12(%rsp)
	cvttss2si	%xmm0, %eax
	movl	%eax, -24(%rsp)
	retq
.Lfunc_end0:
	.size	function, .Lfunc_end0-function
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2               # -- Begin function main
.LCPI1_0:
	.long	1078529622              # float 3.1415
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
# %bb.0:
	pushq	%rax
	movss	.LCPI1_0(%rip), %xmm0   # xmm0 = mem[0],zero,zero,zero
	movl	$1, %edi
	movl	$2, %esi
	movl	$3, %edx
	callq	function
	movl	$.L.str, %edi
	movl	%eax, %esi
	xorl	%eax, %eax
	callq	printf
	xorl	%eax, %eax
	popq	%rcx
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
                                        # -- End function
	.type	global_var,@object      # @global_var
	.data
	.globl	global_var
	.p2align	2
global_var:
	.long	100                     # 0x64
	.size	global_var, 4

	.type	.L.str,@object          # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d\n"
	.size	.L.str, 4

	.section	".note.GNU-stack","",@progbits
