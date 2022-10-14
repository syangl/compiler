
prework1-O0:     file format elf64-x86-64


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

0000000000401030 <_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@plt>:
  401030:	ff 25 e2 2f 00 00    	jmpq   *0x2fe2(%rip)        # 404018 <_ZSt4endlIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_@GLIBCXX_3.4>
  401036:	68 00 00 00 00       	pushq  $0x0
  40103b:	e9 e0 ff ff ff       	jmpq   401020 <.plt>

0000000000401040 <_ZNSirsERi@plt>:
  401040:	ff 25 da 2f 00 00    	jmpq   *0x2fda(%rip)        # 404020 <_ZNSirsERi@GLIBCXX_3.4>
  401046:	68 01 00 00 00       	pushq  $0x1
  40104b:	e9 d0 ff ff ff       	jmpq   401020 <.plt>

0000000000401050 <__cxa_atexit@plt>:
  401050:	ff 25 d2 2f 00 00    	jmpq   *0x2fd2(%rip)        # 404028 <__cxa_atexit@GLIBC_2.2.5>
  401056:	68 02 00 00 00       	pushq  $0x2
  40105b:	e9 c0 ff ff ff       	jmpq   401020 <.plt>

0000000000401060 <_ZNSolsEPFRSoS_E@plt>:
  401060:	ff 25 ca 2f 00 00    	jmpq   *0x2fca(%rip)        # 404030 <_ZNSolsEPFRSoS_E@GLIBCXX_3.4>
  401066:	68 03 00 00 00       	pushq  $0x3
  40106b:	e9 b0 ff ff ff       	jmpq   401020 <.plt>

0000000000401070 <_ZNSt8ios_base4InitC1Ev@plt>:
  401070:	ff 25 c2 2f 00 00    	jmpq   *0x2fc2(%rip)        # 404038 <_ZNSt8ios_base4InitC1Ev@GLIBCXX_3.4>
  401076:	68 04 00 00 00       	pushq  $0x4
  40107b:	e9 a0 ff ff ff       	jmpq   401020 <.plt>

0000000000401080 <_ZNSolsEi@plt>:
  401080:	ff 25 ba 2f 00 00    	jmpq   *0x2fba(%rip)        # 404040 <_ZNSolsEi@GLIBCXX_3.4>
  401086:	68 05 00 00 00       	pushq  $0x5
  40108b:	e9 90 ff ff ff       	jmpq   401020 <.plt>

0000000000401090 <_ZNSt8ios_base4InitD1Ev@plt>:
  401090:	ff 25 b2 2f 00 00    	jmpq   *0x2fb2(%rip)        # 404048 <_ZNSt8ios_base4InitD1Ev@GLIBCXX_3.4>
  401096:	68 06 00 00 00       	pushq  $0x6
  40109b:	e9 80 ff ff ff       	jmpq   401020 <.plt>

Disassembly of section .text:

00000000004010a0 <__cxx_global_var_init>:
  4010a0:	55                   	push   %rbp
  4010a1:	48 89 e5             	mov    %rsp,%rbp
  4010a4:	48 bf b9 42 40 00 00 	movabs $0x4042b9,%rdi
  4010ab:	00 00 00 
  4010ae:	e8 bd ff ff ff       	callq  401070 <_ZNSt8ios_base4InitC1Ev@plt>
  4010b3:	48 b8 90 10 40 00 00 	movabs $0x401090,%rax
  4010ba:	00 00 00 
  4010bd:	48 89 c7             	mov    %rax,%rdi
  4010c0:	48 be b9 42 40 00 00 	movabs $0x4042b9,%rsi
  4010c7:	00 00 00 
  4010ca:	48 ba 58 40 40 00 00 	movabs $0x404058,%rdx
  4010d1:	00 00 00 
  4010d4:	e8 77 ff ff ff       	callq  401050 <__cxa_atexit@plt>
  4010d9:	5d                   	pop    %rbp
  4010da:	c3                   	retq   
  4010db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000004010e0 <_GLOBAL__sub_I_prework1.cpp>:
  4010e0:	55                   	push   %rbp
  4010e1:	48 89 e5             	mov    %rsp,%rbp
  4010e4:	e8 b7 ff ff ff       	callq  4010a0 <__cxx_global_var_init>
  4010e9:	5d                   	pop    %rbp
  4010ea:	c3                   	retq   
  4010eb:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000004010f0 <_start>:
  4010f0:	f3 0f 1e fa          	endbr64 
  4010f4:	31 ed                	xor    %ebp,%ebp
  4010f6:	49 89 d1             	mov    %rdx,%r9
  4010f9:	5e                   	pop    %rsi
  4010fa:	48 89 e2             	mov    %rsp,%rdx
  4010fd:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  401101:	50                   	push   %rax
  401102:	54                   	push   %rsp
  401103:	49 c7 c0 40 13 40 00 	mov    $0x401340,%r8
  40110a:	48 c7 c1 d0 12 40 00 	mov    $0x4012d0,%rcx
  401111:	48 c7 c7 e0 11 40 00 	mov    $0x4011e0,%rdi
  401118:	ff 15 d2 2e 00 00    	callq  *0x2ed2(%rip)        # 403ff0 <__libc_start_main@GLIBC_2.2.5>
  40111e:	f4                   	hlt    
  40111f:	90                   	nop

0000000000401120 <_dl_relocate_static_pie>:
  401120:	f3 0f 1e fa          	endbr64 
  401124:	c3                   	retq   
  401125:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  40112c:	00 00 00 
  40112f:	90                   	nop

0000000000401130 <deregister_tm_clones>:
  401130:	b8 60 40 40 00       	mov    $0x404060,%eax
  401135:	48 3d 60 40 40 00    	cmp    $0x404060,%rax
  40113b:	74 13                	je     401150 <deregister_tm_clones+0x20>
  40113d:	b8 00 00 00 00       	mov    $0x0,%eax
  401142:	48 85 c0             	test   %rax,%rax
  401145:	74 09                	je     401150 <deregister_tm_clones+0x20>
  401147:	bf 60 40 40 00       	mov    $0x404060,%edi
  40114c:	ff e0                	jmpq   *%rax
  40114e:	66 90                	xchg   %ax,%ax
  401150:	c3                   	retq   
  401151:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  401158:	00 00 00 00 
  40115c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000401160 <register_tm_clones>:
  401160:	be 60 40 40 00       	mov    $0x404060,%esi
  401165:	48 81 ee 60 40 40 00 	sub    $0x404060,%rsi
  40116c:	48 89 f0             	mov    %rsi,%rax
  40116f:	48 c1 ee 3f          	shr    $0x3f,%rsi
  401173:	48 c1 f8 03          	sar    $0x3,%rax
  401177:	48 01 c6             	add    %rax,%rsi
  40117a:	48 d1 fe             	sar    %rsi
  40117d:	74 11                	je     401190 <register_tm_clones+0x30>
  40117f:	b8 00 00 00 00       	mov    $0x0,%eax
  401184:	48 85 c0             	test   %rax,%rax
  401187:	74 07                	je     401190 <register_tm_clones+0x30>
  401189:	bf 60 40 40 00       	mov    $0x404060,%edi
  40118e:	ff e0                	jmpq   *%rax
  401190:	c3                   	retq   
  401191:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  401198:	00 00 00 00 
  40119c:	0f 1f 40 00          	nopl   0x0(%rax)

00000000004011a0 <__do_global_dtors_aux>:
  4011a0:	f3 0f 1e fa          	endbr64 
  4011a4:	80 3d 0d 31 00 00 00 	cmpb   $0x0,0x310d(%rip)        # 4042b8 <completed.8061>
  4011ab:	75 13                	jne    4011c0 <__do_global_dtors_aux+0x20>
  4011ad:	55                   	push   %rbp
  4011ae:	48 89 e5             	mov    %rsp,%rbp
  4011b1:	e8 7a ff ff ff       	callq  401130 <deregister_tm_clones>
  4011b6:	c6 05 fb 30 00 00 01 	movb   $0x1,0x30fb(%rip)        # 4042b8 <completed.8061>
  4011bd:	5d                   	pop    %rbp
  4011be:	c3                   	retq   
  4011bf:	90                   	nop
  4011c0:	c3                   	retq   
  4011c1:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  4011c8:	00 00 00 00 
  4011cc:	0f 1f 40 00          	nopl   0x0(%rax)

00000000004011d0 <frame_dummy>:
  4011d0:	f3 0f 1e fa          	endbr64 
  4011d4:	eb 8a                	jmp    401160 <register_tm_clones>
  4011d6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  4011dd:	00 00 00 

00000000004011e0 <main>:
  4011e0:	55                   	push   %rbp
  4011e1:	48 89 e5             	mov    %rsp,%rbp
  4011e4:	48 83 ec 30          	sub    $0x30,%rsp
  4011e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%rbp)
  4011ef:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  4011f6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
  4011fd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%rbp)
  401204:	48 bf a0 41 40 00 00 	movabs $0x4041a0,%rdi
  40120b:	00 00 00 
  40120e:	48 8d 75 e8          	lea    -0x18(%rbp),%rsi
  401212:	e8 29 fe ff ff       	callq  401040 <_ZNSirsERi@plt>
  401217:	8b 75 f8             	mov    -0x8(%rbp),%esi
  40121a:	48 bf 80 40 40 00 00 	movabs $0x404080,%rdi
  401221:	00 00 00 
  401224:	48 89 45 d8          	mov    %rax,-0x28(%rbp)
  401228:	e8 53 fe ff ff       	callq  401080 <_ZNSolsEi@plt>
  40122d:	48 89 c7             	mov    %rax,%rdi
  401230:	48 be 30 10 40 00 00 	movabs $0x401030,%rsi
  401237:	00 00 00 
  40123a:	e8 21 fe ff ff       	callq  401060 <_ZNSolsEPFRSoS_E@plt>
  40123f:	8b 75 f4             	mov    -0xc(%rbp),%esi
  401242:	48 bf 80 40 40 00 00 	movabs $0x404080,%rdi
  401249:	00 00 00 
  40124c:	48 89 45 d0          	mov    %rax,-0x30(%rbp)
  401250:	e8 2b fe ff ff       	callq  401080 <_ZNSolsEi@plt>
  401255:	48 89 c7             	mov    %rax,%rdi
  401258:	48 be 30 10 40 00 00 	movabs $0x401030,%rsi
  40125f:	00 00 00 
  401262:	e8 f9 fd ff ff       	callq  401060 <_ZNSolsEPFRSoS_E@plt>
  401267:	8b 45 f0             	mov    -0x10(%rbp),%eax
  40126a:	3b 45 e8             	cmp    -0x18(%rbp),%eax
  40126d:	0f 8d 47 00 00 00    	jge    4012ba <main+0xda>
  401273:	8b 45 f4             	mov    -0xc(%rbp),%eax
  401276:	89 45 ec             	mov    %eax,-0x14(%rbp)
  401279:	8b 45 f8             	mov    -0x8(%rbp),%eax
  40127c:	03 45 f4             	add    -0xc(%rbp),%eax
  40127f:	89 45 f4             	mov    %eax,-0xc(%rbp)
  401282:	8b 75 f4             	mov    -0xc(%rbp),%esi
  401285:	48 bf 80 40 40 00 00 	movabs $0x404080,%rdi
  40128c:	00 00 00 
  40128f:	e8 ec fd ff ff       	callq  401080 <_ZNSolsEi@plt>
  401294:	48 89 c7             	mov    %rax,%rdi
  401297:	48 be 30 10 40 00 00 	movabs $0x401030,%rsi
  40129e:	00 00 00 
  4012a1:	e8 ba fd ff ff       	callq  401060 <_ZNSolsEPFRSoS_E@plt>
  4012a6:	8b 4d ec             	mov    -0x14(%rbp),%ecx
  4012a9:	89 4d f8             	mov    %ecx,-0x8(%rbp)
  4012ac:	8b 4d f0             	mov    -0x10(%rbp),%ecx
  4012af:	83 c1 01             	add    $0x1,%ecx
  4012b2:	89 4d f0             	mov    %ecx,-0x10(%rbp)
  4012b5:	e9 ad ff ff ff       	jmpq   401267 <main+0x87>
  4012ba:	8b 45 fc             	mov    -0x4(%rbp),%eax
  4012bd:	48 83 c4 30          	add    $0x30,%rsp
  4012c1:	5d                   	pop    %rbp
  4012c2:	c3                   	retq   
  4012c3:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  4012ca:	00 00 00 
  4012cd:	0f 1f 00             	nopl   (%rax)

00000000004012d0 <__libc_csu_init>:
  4012d0:	f3 0f 1e fa          	endbr64 
  4012d4:	41 57                	push   %r15
  4012d6:	4c 8d 3d fb 2a 00 00 	lea    0x2afb(%rip),%r15        # 403dd8 <__frame_dummy_init_array_entry>
  4012dd:	41 56                	push   %r14
  4012df:	49 89 d6             	mov    %rdx,%r14
  4012e2:	41 55                	push   %r13
  4012e4:	49 89 f5             	mov    %rsi,%r13
  4012e7:	41 54                	push   %r12
  4012e9:	41 89 fc             	mov    %edi,%r12d
  4012ec:	55                   	push   %rbp
  4012ed:	48 8d 2d f4 2a 00 00 	lea    0x2af4(%rip),%rbp        # 403de8 <__do_global_dtors_aux_fini_array_entry>
  4012f4:	53                   	push   %rbx
  4012f5:	4c 29 fd             	sub    %r15,%rbp
  4012f8:	48 83 ec 08          	sub    $0x8,%rsp
  4012fc:	e8 ff fc ff ff       	callq  401000 <_init>
  401301:	48 c1 fd 03          	sar    $0x3,%rbp
  401305:	74 1f                	je     401326 <__libc_csu_init+0x56>
  401307:	31 db                	xor    %ebx,%ebx
  401309:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  401310:	4c 89 f2             	mov    %r14,%rdx
  401313:	4c 89 ee             	mov    %r13,%rsi
  401316:	44 89 e7             	mov    %r12d,%edi
  401319:	41 ff 14 df          	callq  *(%r15,%rbx,8)
  40131d:	48 83 c3 01          	add    $0x1,%rbx
  401321:	48 39 dd             	cmp    %rbx,%rbp
  401324:	75 ea                	jne    401310 <__libc_csu_init+0x40>
  401326:	48 83 c4 08          	add    $0x8,%rsp
  40132a:	5b                   	pop    %rbx
  40132b:	5d                   	pop    %rbp
  40132c:	41 5c                	pop    %r12
  40132e:	41 5d                	pop    %r13
  401330:	41 5e                	pop    %r14
  401332:	41 5f                	pop    %r15
  401334:	c3                   	retq   
  401335:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  40133c:	00 00 00 00 

0000000000401340 <__libc_csu_fini>:
  401340:	f3 0f 1e fa          	endbr64 
  401344:	c3                   	retq   

Disassembly of section .fini:

0000000000401348 <_fini>:
  401348:	f3 0f 1e fa          	endbr64 
  40134c:	48 83 ec 08          	sub    $0x8,%rsp
  401350:	48 83 c4 08          	add    $0x8,%rsp
  401354:	c3                   	retq   
