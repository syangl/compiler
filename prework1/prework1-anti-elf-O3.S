
prework1-O3:     file format elf64-x86-64


Disassembly of section .init:

0000000000401000 <_init>:
  401000:	f3 0f 1e fa          	endbr64 
  401004:	48 83 ec 08          	sub    $0x8,%rsp
  401008:	48 8b 05 e9 2f 00 00 	mov    0x2fe9(%rip),%rax        # 403ff8 <__gmon_start__>
  40100f:	48 85 c0             	test   %rax,%rax
  401012:	74 02                	je     401016 <_init+0x16>
  401014:	ff d0                	callq  *%rax
  401016:	48 83 c4 08          	add    $0x8,%rsp
  40101a:	c3                   	retq   

Disassembly of section .plt:

0000000000401020 <.plt>:
  401020:	ff 35 e2 2f 00 00    	pushq  0x2fe2(%rip)        # 404008 <_GLOBAL_OFFSET_TABLE_+0x8>
  401026:	ff 25 e4 2f 00 00    	jmpq   *0x2fe4(%rip)        # 404010 <_GLOBAL_OFFSET_TABLE_+0x10>
  40102c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000401030 <_ZNSo3putEc@plt>:
  401030:	ff 25 e2 2f 00 00    	jmpq   *0x2fe2(%rip)        # 404018 <_ZNSo3putEc@GLIBCXX_3.4>
  401036:	68 00 00 00 00       	pushq  $0x0
  40103b:	e9 e0 ff ff ff       	jmpq   401020 <.plt>

0000000000401040 <_ZNSirsERi@plt>:
  401040:	ff 25 da 2f 00 00    	jmpq   *0x2fda(%rip)        # 404020 <_ZNSirsERi@GLIBCXX_3.4>
  401046:	68 01 00 00 00       	pushq  $0x1
  40104b:	e9 d0 ff ff ff       	jmpq   401020 <.plt>

0000000000401050 <_ZNSo5flushEv@plt>:
  401050:	ff 25 d2 2f 00 00    	jmpq   *0x2fd2(%rip)        # 404028 <_ZNSo5flushEv@GLIBCXX_3.4>
  401056:	68 02 00 00 00       	pushq  $0x2
  40105b:	e9 c0 ff ff ff       	jmpq   401020 <.plt>

0000000000401060 <__cxa_atexit@plt>:
  401060:	ff 25 ca 2f 00 00    	jmpq   *0x2fca(%rip)        # 404030 <__cxa_atexit@GLIBC_2.2.5>
  401066:	68 03 00 00 00       	pushq  $0x3
  40106b:	e9 b0 ff ff ff       	jmpq   401020 <.plt>

0000000000401070 <_ZNKSt5ctypeIcE13_M_widen_initEv@plt>:
  401070:	ff 25 c2 2f 00 00    	jmpq   *0x2fc2(%rip)        # 404038 <_ZNKSt5ctypeIcE13_M_widen_initEv@GLIBCXX_3.4.11>
  401076:	68 04 00 00 00       	pushq  $0x4
  40107b:	e9 a0 ff ff ff       	jmpq   401020 <.plt>

0000000000401080 <_ZSt16__throw_bad_castv@plt>:
  401080:	ff 25 ba 2f 00 00    	jmpq   *0x2fba(%rip)        # 404040 <_ZSt16__throw_bad_castv@GLIBCXX_3.4>
  401086:	68 05 00 00 00       	pushq  $0x5
  40108b:	e9 90 ff ff ff       	jmpq   401020 <.plt>

0000000000401090 <_ZNSt8ios_base4InitC1Ev@plt>:
  401090:	ff 25 b2 2f 00 00    	jmpq   *0x2fb2(%rip)        # 404048 <_ZNSt8ios_base4InitC1Ev@GLIBCXX_3.4>
  401096:	68 06 00 00 00       	pushq  $0x6
  40109b:	e9 80 ff ff ff       	jmpq   401020 <.plt>

00000000004010a0 <_ZNSolsEi@plt>:
  4010a0:	ff 25 aa 2f 00 00    	jmpq   *0x2faa(%rip)        # 404050 <_ZNSolsEi@GLIBCXX_3.4>
  4010a6:	68 07 00 00 00       	pushq  $0x7
  4010ab:	e9 70 ff ff ff       	jmpq   401020 <.plt>

00000000004010b0 <_ZNSt8ios_base4InitD1Ev@plt>:
  4010b0:	ff 25 a2 2f 00 00    	jmpq   *0x2fa2(%rip)        # 404058 <_ZNSt8ios_base4InitD1Ev@GLIBCXX_3.4>
  4010b6:	68 08 00 00 00       	pushq  $0x8
  4010bb:	e9 60 ff ff ff       	jmpq   401020 <.plt>

Disassembly of section .text:

00000000004010c0 <_GLOBAL__sub_I_prework1.cpp>:
  4010c0:	50                   	push   %rax
  4010c1:	bf b9 42 40 00       	mov    $0x4042b9,%edi
  4010c6:	e8 c5 ff ff ff       	callq  401090 <_ZNSt8ios_base4InitC1Ev@plt>
  4010cb:	bf b0 10 40 00       	mov    $0x4010b0,%edi
  4010d0:	be b9 42 40 00       	mov    $0x4042b9,%esi
  4010d5:	ba 68 40 40 00       	mov    $0x404068,%edx
  4010da:	58                   	pop    %rax
  4010db:	e9 80 ff ff ff       	jmpq   401060 <__cxa_atexit@plt>

00000000004010e0 <_start>:
  4010e0:	f3 0f 1e fa          	endbr64 
  4010e4:	31 ed                	xor    %ebp,%ebp
  4010e6:	49 89 d1             	mov    %rdx,%r9
  4010e9:	5e                   	pop    %rsi
  4010ea:	48 89 e2             	mov    %rsp,%rdx
  4010ed:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  4010f1:	50                   	push   %rax
  4010f2:	54                   	push   %rsp
  4010f3:	49 c7 c0 c0 13 40 00 	mov    $0x4013c0,%r8
  4010fa:	48 c7 c1 50 13 40 00 	mov    $0x401350,%rcx
  401101:	48 c7 c7 d0 11 40 00 	mov    $0x4011d0,%rdi
  401108:	ff 15 e2 2e 00 00    	callq  *0x2ee2(%rip)        # 403ff0 <__libc_start_main@GLIBC_2.2.5>
  40110e:	f4                   	hlt    
  40110f:	90                   	nop

0000000000401110 <_dl_relocate_static_pie>:
  401110:	f3 0f 1e fa          	endbr64 
  401114:	c3                   	retq   
  401115:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  40111c:	00 00 00 
  40111f:	90                   	nop

0000000000401120 <deregister_tm_clones>:
  401120:	b8 70 40 40 00       	mov    $0x404070,%eax
  401125:	48 3d 70 40 40 00    	cmp    $0x404070,%rax
  40112b:	74 13                	je     401140 <deregister_tm_clones+0x20>
  40112d:	b8 00 00 00 00       	mov    $0x0,%eax
  401132:	48 85 c0             	test   %rax,%rax
  401135:	74 09                	je     401140 <deregister_tm_clones+0x20>
  401137:	bf 70 40 40 00       	mov    $0x404070,%edi
  40113c:	ff e0                	jmpq   *%rax
  40113e:	66 90                	xchg   %ax,%ax
  401140:	c3                   	retq   
  401141:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  401148:	00 00 00 00 
  40114c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000401150 <register_tm_clones>:
  401150:	be 70 40 40 00       	mov    $0x404070,%esi
  401155:	48 81 ee 70 40 40 00 	sub    $0x404070,%rsi
  40115c:	48 89 f0             	mov    %rsi,%rax
  40115f:	48 c1 ee 3f          	shr    $0x3f,%rsi
  401163:	48 c1 f8 03          	sar    $0x3,%rax
  401167:	48 01 c6             	add    %rax,%rsi
  40116a:	48 d1 fe             	sar    %rsi
  40116d:	74 11                	je     401180 <register_tm_clones+0x30>
  40116f:	b8 00 00 00 00       	mov    $0x0,%eax
  401174:	48 85 c0             	test   %rax,%rax
  401177:	74 07                	je     401180 <register_tm_clones+0x30>
  401179:	bf 70 40 40 00       	mov    $0x404070,%edi
  40117e:	ff e0                	jmpq   *%rax
  401180:	c3                   	retq   
  401181:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  401188:	00 00 00 00 
  40118c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000401190 <__do_global_dtors_aux>:
  401190:	f3 0f 1e fa          	endbr64 
  401194:	80 3d 1d 31 00 00 00 	cmpb   $0x0,0x311d(%rip)        # 4042b8 <completed.8061>
  40119b:	75 13                	jne    4011b0 <__do_global_dtors_aux+0x20>
  40119d:	55                   	push   %rbp
  40119e:	48 89 e5             	mov    %rsp,%rbp
  4011a1:	e8 7a ff ff ff       	callq  401120 <deregister_tm_clones>
  4011a6:	c6 05 0b 31 00 00 01 	movb   $0x1,0x310b(%rip)        # 4042b8 <completed.8061>
  4011ad:	5d                   	pop    %rbp
  4011ae:	c3                   	retq   
  4011af:	90                   	nop
  4011b0:	c3                   	retq   
  4011b1:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  4011b8:	00 00 00 00 
  4011bc:	0f 1f 40 00          	nopl   0x0(%rax)

00000000004011c0 <frame_dummy>:
  4011c0:	f3 0f 1e fa          	endbr64 
  4011c4:	eb 8a                	jmp    401150 <register_tm_clones>
  4011c6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  4011cd:	00 00 00 

00000000004011d0 <main>:
  4011d0:	55                   	push   %rbp
  4011d1:	41 57                	push   %r15
  4011d3:	41 56                	push   %r14
  4011d5:	41 54                	push   %r12
  4011d7:	53                   	push   %rbx
  4011d8:	48 83 ec 10          	sub    $0x10,%rsp
  4011dc:	48 8d 74 24 0c       	lea    0xc(%rsp),%rsi
  4011e1:	bf a0 41 40 00       	mov    $0x4041a0,%edi
  4011e6:	e8 55 fe ff ff       	callq  401040 <_ZNSirsERi@plt>
  4011eb:	bf 80 40 40 00       	mov    $0x404080,%edi
  4011f0:	31 f6                	xor    %esi,%esi
  4011f2:	e8 a9 fe ff ff       	callq  4010a0 <_ZNSolsEi@plt>
  4011f7:	49 89 c6             	mov    %rax,%r14
  4011fa:	48 8b 00             	mov    (%rax),%rax
  4011fd:	48 8b 40 e8          	mov    -0x18(%rax),%rax
  401201:	49 8b 9c 06 f0 00 00 	mov    0xf0(%r14,%rax,1),%rbx
  401208:	00 
  401209:	48 85 db             	test   %rbx,%rbx
  40120c:	0f 84 2b 01 00 00    	je     40133d <main+0x16d>
  401212:	80 7b 38 00          	cmpb   $0x0,0x38(%rbx)
  401216:	74 05                	je     40121d <main+0x4d>
  401218:	8a 43 43             	mov    0x43(%rbx),%al
  40121b:	eb 16                	jmp    401233 <main+0x63>
  40121d:	48 89 df             	mov    %rbx,%rdi
  401220:	e8 4b fe ff ff       	callq  401070 <_ZNKSt5ctypeIcE13_M_widen_initEv@plt>
  401225:	48 8b 03             	mov    (%rbx),%rax
  401228:	48 89 df             	mov    %rbx,%rdi
  40122b:	be 0a 00 00 00       	mov    $0xa,%esi
  401230:	ff 50 30             	callq  *0x30(%rax)
  401233:	0f be f0             	movsbl %al,%esi
  401236:	4c 89 f7             	mov    %r14,%rdi
  401239:	e8 f2 fd ff ff       	callq  401030 <_ZNSo3putEc@plt>
  40123e:	48 89 c7             	mov    %rax,%rdi
  401241:	e8 0a fe ff ff       	callq  401050 <_ZNSo5flushEv@plt>
  401246:	bf 80 40 40 00       	mov    $0x404080,%edi
  40124b:	be 01 00 00 00       	mov    $0x1,%esi
  401250:	e8 4b fe ff ff       	callq  4010a0 <_ZNSolsEi@plt>
  401255:	49 89 c6             	mov    %rax,%r14
  401258:	48 8b 00             	mov    (%rax),%rax
  40125b:	48 8b 40 e8          	mov    -0x18(%rax),%rax
  40125f:	49 8b 9c 06 f0 00 00 	mov    0xf0(%r14,%rax,1),%rbx
  401266:	00 
  401267:	48 85 db             	test   %rbx,%rbx
  40126a:	0f 84 cd 00 00 00    	je     40133d <main+0x16d>
  401270:	80 7b 38 00          	cmpb   $0x0,0x38(%rbx)
  401274:	74 05                	je     40127b <main+0xab>
  401276:	8a 43 43             	mov    0x43(%rbx),%al
  401279:	eb 16                	jmp    401291 <main+0xc1>
  40127b:	48 89 df             	mov    %rbx,%rdi
  40127e:	e8 ed fd ff ff       	callq  401070 <_ZNKSt5ctypeIcE13_M_widen_initEv@plt>
  401283:	48 8b 03             	mov    (%rbx),%rax
  401286:	48 89 df             	mov    %rbx,%rdi
  401289:	be 0a 00 00 00       	mov    $0xa,%esi
  40128e:	ff 50 30             	callq  *0x30(%rax)
  401291:	0f be f0             	movsbl %al,%esi
  401294:	4c 89 f7             	mov    %r14,%rdi
  401297:	e8 94 fd ff ff       	callq  401030 <_ZNSo3putEc@plt>
  40129c:	48 89 c7             	mov    %rax,%rdi
  40129f:	e8 ac fd ff ff       	callq  401050 <_ZNSo5flushEv@plt>
  4012a4:	83 7c 24 0c 02       	cmpl   $0x2,0xc(%rsp)
  4012a9:	0f 8c 7f 00 00 00    	jl     40132e <main+0x15e>
  4012af:	41 bf 01 00 00 00    	mov    $0x1,%r15d
  4012b5:	31 c0                	xor    %eax,%eax
  4012b7:	41 bc 01 00 00 00    	mov    $0x1,%r12d
  4012bd:	eb 3b                	jmp    4012fa <main+0x12a>
  4012bf:	90                   	nop
  4012c0:	48 89 df             	mov    %rbx,%rdi
  4012c3:	e8 a8 fd ff ff       	callq  401070 <_ZNKSt5ctypeIcE13_M_widen_initEv@plt>
  4012c8:	48 8b 03             	mov    (%rbx),%rax
  4012cb:	48 89 df             	mov    %rbx,%rdi
  4012ce:	be 0a 00 00 00       	mov    $0xa,%esi
  4012d3:	ff 50 30             	callq  *0x30(%rax)
  4012d6:	0f be f0             	movsbl %al,%esi
  4012d9:	4c 89 f7             	mov    %r14,%rdi
  4012dc:	e8 4f fd ff ff       	callq  401030 <_ZNSo3putEc@plt>
  4012e1:	48 89 c7             	mov    %rax,%rdi
  4012e4:	e8 67 fd ff ff       	callq  401050 <_ZNSo5flushEv@plt>
  4012e9:	41 83 c4 01          	add    $0x1,%r12d
  4012ed:	44 89 f8             	mov    %r15d,%eax
  4012f0:	41 89 ef             	mov    %ebp,%r15d
  4012f3:	44 3b 64 24 0c       	cmp    0xc(%rsp),%r12d
  4012f8:	7d 34                	jge    40132e <main+0x15e>
  4012fa:	89 c5                	mov    %eax,%ebp
  4012fc:	44 01 fd             	add    %r15d,%ebp
  4012ff:	bf 80 40 40 00       	mov    $0x404080,%edi
  401304:	89 ee                	mov    %ebp,%esi
  401306:	e8 95 fd ff ff       	callq  4010a0 <_ZNSolsEi@plt>
  40130b:	49 89 c6             	mov    %rax,%r14
  40130e:	48 8b 00             	mov    (%rax),%rax
  401311:	48 8b 40 e8          	mov    -0x18(%rax),%rax
  401315:	49 8b 9c 06 f0 00 00 	mov    0xf0(%r14,%rax,1),%rbx
  40131c:	00 
  40131d:	48 85 db             	test   %rbx,%rbx
  401320:	74 1b                	je     40133d <main+0x16d>
  401322:	80 7b 38 00          	cmpb   $0x0,0x38(%rbx)
  401326:	74 98                	je     4012c0 <main+0xf0>
  401328:	0f b6 43 43          	movzbl 0x43(%rbx),%eax
  40132c:	eb a8                	jmp    4012d6 <main+0x106>
  40132e:	31 c0                	xor    %eax,%eax
  401330:	48 83 c4 10          	add    $0x10,%rsp
  401334:	5b                   	pop    %rbx
  401335:	41 5c                	pop    %r12
  401337:	41 5e                	pop    %r14
  401339:	41 5f                	pop    %r15
  40133b:	5d                   	pop    %rbp
  40133c:	c3                   	retq   
  40133d:	e8 3e fd ff ff       	callq  401080 <_ZSt16__throw_bad_castv@plt>
  401342:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  401349:	00 00 00 
  40134c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000401350 <__libc_csu_init>:
  401350:	f3 0f 1e fa          	endbr64 
  401354:	41 57                	push   %r15
  401356:	4c 8d 3d 7b 2a 00 00 	lea    0x2a7b(%rip),%r15        # 403dd8 <__frame_dummy_init_array_entry>
  40135d:	41 56                	push   %r14
  40135f:	49 89 d6             	mov    %rdx,%r14
  401362:	41 55                	push   %r13
  401364:	49 89 f5             	mov    %rsi,%r13
  401367:	41 54                	push   %r12
  401369:	41 89 fc             	mov    %edi,%r12d
  40136c:	55                   	push   %rbp
  40136d:	48 8d 2d 74 2a 00 00 	lea    0x2a74(%rip),%rbp        # 403de8 <__do_global_dtors_aux_fini_array_entry>
  401374:	53                   	push   %rbx
  401375:	4c 29 fd             	sub    %r15,%rbp
  401378:	48 83 ec 08          	sub    $0x8,%rsp
  40137c:	e8 7f fc ff ff       	callq  401000 <_init>
  401381:	48 c1 fd 03          	sar    $0x3,%rbp
  401385:	74 1f                	je     4013a6 <__libc_csu_init+0x56>
  401387:	31 db                	xor    %ebx,%ebx
  401389:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  401390:	4c 89 f2             	mov    %r14,%rdx
  401393:	4c 89 ee             	mov    %r13,%rsi
  401396:	44 89 e7             	mov    %r12d,%edi
  401399:	41 ff 14 df          	callq  *(%r15,%rbx,8)
  40139d:	48 83 c3 01          	add    $0x1,%rbx
  4013a1:	48 39 dd             	cmp    %rbx,%rbp
  4013a4:	75 ea                	jne    401390 <__libc_csu_init+0x40>
  4013a6:	48 83 c4 08          	add    $0x8,%rsp
  4013aa:	5b                   	pop    %rbx
  4013ab:	5d                   	pop    %rbp
  4013ac:	41 5c                	pop    %r12
  4013ae:	41 5d                	pop    %r13
  4013b0:	41 5e                	pop    %r14
  4013b2:	41 5f                	pop    %r15
  4013b4:	c3                   	retq   
  4013b5:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  4013bc:	00 00 00 00 

00000000004013c0 <__libc_csu_fini>:
  4013c0:	f3 0f 1e fa          	endbr64 
  4013c4:	c3                   	retq   

Disassembly of section .fini:

00000000004013c8 <_fini>:
  4013c8:	f3 0f 1e fa          	endbr64 
  4013cc:	48 83 ec 08          	sub    $0x8,%rsp
  4013d0:	48 83 c4 08          	add    $0x8,%rsp
  4013d4:	c3                   	retq   
