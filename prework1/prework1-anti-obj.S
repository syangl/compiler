
prework1.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 20          	sub    $0x20,%rsp
   8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
   f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  16:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  1d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
  24:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
  2b:	00 00 00 
  2e:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  32:	e8 00 00 00 00       	callq  37 <main+0x37>
  37:	8b 75 f4             	mov    -0xc(%rbp),%esi
  3a:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
  41:	00 00 00 
  44:	e8 00 00 00 00       	callq  49 <main+0x49>
  49:	48 89 c7             	mov    %rax,%rdi
  4c:	48 be 00 00 00 00 00 	movabs $0x0,%rsi
  53:	00 00 00 
  56:	e8 00 00 00 00       	callq  5b <main+0x5b>
  5b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  5e:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
  65:	00 00 00 
  68:	e8 00 00 00 00       	callq  6d <main+0x6d>
  6d:	48 89 c7             	mov    %rax,%rdi
  70:	48 be 00 00 00 00 00 	movabs $0x0,%rsi
  77:	00 00 00 
  7a:	e8 00 00 00 00       	callq  7f <main+0x7f>
  7f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  82:	3b 45 f0             	cmp    -0x10(%rbp),%eax
  85:	7d 44                	jge    cb <main+0xcb>
  87:	8b 45 fc             	mov    -0x4(%rbp),%eax
  8a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  8d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  90:	03 45 fc             	add    -0x4(%rbp),%eax
  93:	89 45 fc             	mov    %eax,-0x4(%rbp)
  96:	8b 75 fc             	mov    -0x4(%rbp),%esi
  99:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
  a0:	00 00 00 
  a3:	e8 00 00 00 00       	callq  a8 <main+0xa8>
  a8:	48 89 c7             	mov    %rax,%rdi
  ab:	48 be 00 00 00 00 00 	movabs $0x0,%rsi
  b2:	00 00 00 
  b5:	e8 00 00 00 00       	callq  ba <main+0xba>
  ba:	8b 45 ec             	mov    -0x14(%rbp),%eax
  bd:	89 45 f4             	mov    %eax,-0xc(%rbp)
  c0:	8b 45 f8             	mov    -0x8(%rbp),%eax
  c3:	83 c0 01             	add    $0x1,%eax
  c6:	89 45 f8             	mov    %eax,-0x8(%rbp)
  c9:	eb b4                	jmp    7f <main+0x7f>
  cb:	8b 45 e8             	mov    -0x18(%rbp),%eax
  ce:	48 83 c4 20          	add    $0x20,%rsp
  d2:	5d                   	pop    %rbp
  d3:	c3                   	retq   

Disassembly of section .text.startup:

0000000000000000 <__cxx_global_var_init>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	bf 00 00 00 00       	mov    $0x0,%edi
   9:	e8 00 00 00 00       	callq  e <__cxx_global_var_init+0xe>
   e:	bf 00 00 00 00       	mov    $0x0,%edi
  13:	be 00 00 00 00       	mov    $0x0,%esi
  18:	ba 00 00 00 00       	mov    $0x0,%edx
  1d:	e8 00 00 00 00       	callq  22 <__cxx_global_var_init+0x22>
  22:	5d                   	pop    %rbp
  23:	c3                   	retq   
  24:	90                   	nop
  25:	90                   	nop
  26:	90                   	nop
  27:	90                   	nop
  28:	90                   	nop
  29:	90                   	nop
  2a:	90                   	nop
  2b:	90                   	nop
  2c:	90                   	nop
  2d:	90                   	nop
  2e:	90                   	nop
  2f:	90                   	nop

0000000000000030 <_GLOBAL__sub_I_prework1.cpp>:
  30:	55                   	push   %rbp
  31:	48 89 e5             	mov    %rsp,%rbp
  34:	e8 c7 ff ff ff       	callq  0 <__cxx_global_var_init>
  39:	5d                   	pop    %rbp
  3a:	c3                   	retq   
