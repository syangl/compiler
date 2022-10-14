
prework1:     file format elf64-x86-64


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
  4010a4:	bf b9 42 40 00       	mov    $0x4042b9,%edi
  4010a9:	e8 c2 ff ff ff       	callq  401070 <_ZNSt8ios_base4InitC1Ev@plt>
  4010ae:	bf 90 10 40 00       	mov    $0x401090,%edi
  4010b3:	be b9 42 40 00       	mov    $0x4042b9,%esi
  4010b8:	ba 58 40 40 00       	mov    $0x404058,%edx
  4010bd:	e8 8e ff ff ff       	callq  401050 <__cxa_atexit@plt>
  4010c2:	5d                   	pop    %rbp
  4010c3:	c3                   	retq   
  4010c4:	90                   	nop
  4010c5:	90                   	nop
  4010c6:	90                   	nop
  4010c7:	90                   	nop
  4010c8:	90                   	nop
  4010c9:	90                   	nop
  4010ca:	90                   	nop
  4010cb:	90                   	nop
  4010cc:	90                   	nop
  4010cd:	90                   	nop
  4010ce:	90                   	nop
  4010cf:	90                   	nop

00000000004010d0 <_GLOBAL__sub_I_prework1.cpp>:
  4010d0:	55                   	push   %rbp
  4010d1:	48 89 e5             	mov    %rsp,%rbp
  4010d4:	e8 c7 ff ff ff       	callq  4010a0 <__cxx_global_var_init>
  4010d9:	5d                   	pop    %rbp
  4010da:	c3                   	retq   
  4010db:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)

00000000004010e0 <_start>:
  4010e0:	f3 0f 1e fa          	endbr64 
  4010e4:	31 ed                	xor    %ebp,%ebp
  4010e6:	49 89 d1             	mov    %rdx,%r9
  4010e9:	5e                   	pop    %rsi
  4010ea:	48 89 e2             	mov    %rsp,%rdx
  4010ed:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  4010f1:	50                   	push   %rax
  4010f2:	54                   	push   %rsp
  4010f3:	49 c7 c0 20 13 40 00 	mov    $0x401320,%r8
  4010fa:	48 c7 c1 b0 12 40 00 	mov    $0x4012b0,%rcx
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
  401120:	b8 60 40 40 00       	mov    $0x404060,%eax
  401125:	48 3d 60 40 40 00    	cmp    $0x404060,%rax
  40112b:	74 13                	je     401140 <deregister_tm_clones+0x20>
  40112d:	b8 00 00 00 00       	mov    $0x0,%eax
  401132:	48 85 c0             	test   %rax,%rax
  401135:	74 09                	je     401140 <deregister_tm_clones+0x20>
  401137:	bf 60 40 40 00       	mov    $0x404060,%edi
  40113c:	ff e0                	jmpq   *%rax
  40113e:	66 90                	xchg   %ax,%ax
  401140:	c3                   	retq   
  401141:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  401148:	00 00 00 00 
  40114c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000401150 <register_tm_clones>:
  401150:	be 60 40 40 00       	mov    $0x404060,%esi
  401155:	48 81 ee 60 40 40 00 	sub    $0x404060,%rsi
  40115c:	48 89 f0             	mov    %rsi,%rax
  40115f:	48 c1 ee 3f          	shr    $0x3f,%rsi
  401163:	48 c1 f8 03          	sar    $0x3,%rax
  401167:	48 01 c6             	add    %rax,%rsi
  40116a:	48 d1 fe             	sar    %rsi
  40116d:	74 11                	je     401180 <register_tm_clones+0x30>
  40116f:	b8 00 00 00 00       	mov    $0x0,%eax
  401174:	48 85 c0             	test   %rax,%rax
  401177:	74 07                	je     401180 <register_tm_clones+0x30>
  401179:	bf 60 40 40 00       	mov    $0x404060,%edi
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
  4011d1:	48 89 e5             	mov    %rsp,%rbp
  4011d4:	48 83 ec 20          	sub    $0x20,%rsp
  4011d8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
  4011df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%rbp)
  4011e6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  4011ed:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%rbp)
  4011f4:	48 bf a0 41 40 00 00 	movabs $0x4041a0,%rdi
  4011fb:	00 00 00 
  4011fe:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  401202:	e8 39 fe ff ff       	callq  401040 <_ZNSirsERi@plt>
  401207:	8b 75 f4             	mov    -0xc(%rbp),%esi
  40120a:	48 bf 80 40 40 00 00 	movabs $0x404080,%rdi
  401211:	00 00 00 
  401214:	e8 67 fe ff ff       	callq  401080 <_ZNSolsEi@plt>
  401219:	48 89 c7             	mov    %rax,%rdi
  40121c:	48 be 30 10 40 00 00 	movabs $0x401030,%rsi
  401223:	00 00 00 
  401226:	e8 35 fe ff ff       	callq  401060 <_ZNSolsEPFRSoS_E@plt>
  40122b:	8b 75 fc             	mov    -0x4(%rbp),%esi
  40122e:	48 bf 80 40 40 00 00 	movabs $0x404080,%rdi
  401235:	00 00 00 
  401238:	e8 43 fe ff ff       	callq  401080 <_ZNSolsEi@plt>
  40123d:	48 89 c7             	mov    %rax,%rdi
  401240:	48 be 30 10 40 00 00 	movabs $0x401030,%rsi
  401247:	00 00 00 
  40124a:	e8 11 fe ff ff       	callq  401060 <_ZNSolsEPFRSoS_E@plt>
  40124f:	8b 45 f8             	mov    -0x8(%rbp),%eax
  401252:	3b 45 f0             	cmp    -0x10(%rbp),%eax
  401255:	7d 44                	jge    40129b <main+0xcb>
  401257:	8b 45 fc             	mov    -0x4(%rbp),%eax
  40125a:	89 45 ec             	mov    %eax,-0x14(%rbp)
  40125d:	8b 45 f4             	mov    -0xc(%rbp),%eax
  401260:	03 45 fc             	add    -0x4(%rbp),%eax
  401263:	89 45 fc             	mov    %eax,-0x4(%rbp)
  401266:	8b 75 fc             	mov    -0x4(%rbp),%esi
  401269:	48 bf 80 40 40 00 00 	movabs $0x404080,%rdi
  401270:	00 00 00 
  401273:	e8 08 fe ff ff       	callq  401080 <_ZNSolsEi@plt>
  401278:	48 89 c7             	mov    %rax,%rdi
  40127b:	48 be 30 10 40 00 00 	movabs $0x401030,%rsi
  401282:	00 00 00 
  401285:	e8 d6 fd ff ff       	callq  401060 <_ZNSolsEPFRSoS_E@plt>
  40128a:	8b 45 ec             	mov    -0x14(%rbp),%eax
  40128d:	89 45 f4             	mov    %eax,-0xc(%rbp)
  401290:	8b 45 f8             	mov    -0x8(%rbp),%eax
  401293:	83 c0 01             	add    $0x1,%eax
  401296:	89 45 f8             	mov    %eax,-0x8(%rbp)
  401299:	eb b4                	jmp    40124f <main+0x7f>
  40129b:	8b 45 e8             	mov    -0x18(%rbp),%eax
  40129e:	48 83 c4 20          	add    $0x20,%rsp
  4012a2:	5d                   	pop    %rbp
  4012a3:	c3                   	retq   
  4012a4:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  4012ab:	00 00 00 
  4012ae:	66 90                	xchg   %ax,%ax

00000000004012b0 <__libc_csu_init>:
  4012b0:	f3 0f 1e fa          	endbr64 
  4012b4:	41 57                	push   %r15
  4012b6:	4c 8d 3d 1b 2b 00 00 	lea    0x2b1b(%rip),%r15        # 403dd8 <__frame_dummy_init_array_entry>
  4012bd:	41 56                	push   %r14
  4012bf:	49 89 d6             	mov    %rdx,%r14
  4012c2:	41 55                	push   %r13
  4012c4:	49 89 f5             	mov    %rsi,%r13
  4012c7:	41 54                	push   %r12
  4012c9:	41 89 fc             	mov    %edi,%r12d
  4012cc:	55                   	push   %rbp
  4012cd:	48 8d 2d 14 2b 00 00 	lea    0x2b14(%rip),%rbp        # 403de8 <__do_global_dtors_aux_fini_array_entry>
  4012d4:	53                   	push   %rbx
  4012d5:	4c 29 fd             	sub    %r15,%rbp
  4012d8:	48 83 ec 08          	sub    $0x8,%rsp
  4012dc:	e8 1f fd ff ff       	callq  401000 <_init>
  4012e1:	48 c1 fd 03          	sar    $0x3,%rbp
  4012e5:	74 1f                	je     401306 <__libc_csu_init+0x56>
  4012e7:	31 db                	xor    %ebx,%ebx
  4012e9:	0f 1f 80 00 00 00 00 	nopl   0x0(%rax)
  4012f0:	4c 89 f2             	mov    %r14,%rdx
  4012f3:	4c 89 ee             	mov    %r13,%rsi
  4012f6:	44 89 e7             	mov    %r12d,%edi
  4012f9:	41 ff 14 df          	callq  *(%r15,%rbx,8)
  4012fd:	48 83 c3 01          	add    $0x1,%rbx
  401301:	48 39 dd             	cmp    %rbx,%rbp
  401304:	75 ea                	jne    4012f0 <__libc_csu_init+0x40>
  401306:	48 83 c4 08          	add    $0x8,%rsp
  40130a:	5b                   	pop    %rbx
  40130b:	5d                   	pop    %rbp
  40130c:	41 5c                	pop    %r12
  40130e:	41 5d                	pop    %r13
  401310:	41 5e                	pop    %r14
  401312:	41 5f                	pop    %r15
  401314:	c3                   	retq   
  401315:	66 66 2e 0f 1f 84 00 	data16 nopw %cs:0x0(%rax,%rax,1)
  40131c:	00 00 00 00 

0000000000401320 <__libc_csu_fini>:
  401320:	f3 0f 1e fa          	endbr64 
  401324:	c3                   	retq   

Disassembly of section .fini:

0000000000401328 <_fini>:
  401328:	f3 0f 1e fa          	endbr64 
  40132c:	48 83 ec 08          	sub    $0x8,%rsp
  401330:	48 83 c4 08          	add    $0x8,%rsp
  401334:	c3                   	retq   
