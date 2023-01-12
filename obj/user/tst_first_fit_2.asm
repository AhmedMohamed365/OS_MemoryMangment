
obj/user/tst_first_fit_2:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 bd 06 00 00       	call   8006f3 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	83 ec 70             	sub    $0x70,%esp
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 01                	push   $0x1
  800045:	e8 85 24 00 00       	call   8024cf <sys_set_uheap_strategy>
  80004a:	83 c4 10             	add    $0x10,%esp

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80004d:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800051:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800058:	eb 23                	jmp    80007d <_main+0x45>
		{
			if (myEnv->__uptr_pws[i].empty)
  80005a:	a1 20 30 80 00       	mov    0x803020,%eax
  80005f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800065:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800068:	c1 e2 04             	shl    $0x4,%edx
  80006b:	01 d0                	add    %edx,%eax
  80006d:	8a 40 04             	mov    0x4(%eax),%al
  800070:	84 c0                	test   %al,%al
  800072:	74 06                	je     80007a <_main+0x42>
			{
				fullWS = 0;
  800074:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800078:	eb 12                	jmp    80008c <_main+0x54>
	sys_set_uheap_strategy(UHP_PLACE_FIRSTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007a:	ff 45 f0             	incl   -0x10(%ebp)
  80007d:	a1 20 30 80 00       	mov    0x803020,%eax
  800082:	8b 50 74             	mov    0x74(%eax),%edx
  800085:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800088:	39 c2                	cmp    %eax,%edx
  80008a:	77 ce                	ja     80005a <_main+0x22>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  80008c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800090:	74 14                	je     8000a6 <_main+0x6e>
  800092:	83 ec 04             	sub    $0x4,%esp
  800095:	68 a0 27 80 00       	push   $0x8027a0
  80009a:	6a 1b                	push   $0x1b
  80009c:	68 bc 27 80 00       	push   $0x8027bc
  8000a1:	e8 92 07 00 00       	call   800838 <_panic>
	}


	int Mega = 1024*1024;
  8000a6:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000ad:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	void* ptr_allocations[20] = {0};
  8000b4:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000b7:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c1:	89 d7                	mov    %edx,%edi
  8000c3:	f3 ab                	rep stos %eax,%es:(%edi)

	//[1] Attempt to allocate more than heap size
	{
		ptr_allocations[0] = malloc(USER_HEAP_MAX - USER_HEAP_START + 1);
  8000c5:	83 ec 0c             	sub    $0xc,%esp
  8000c8:	68 01 00 00 20       	push   $0x20000001
  8000cd:	e8 92 17 00 00       	call   801864 <malloc>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000d8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 d4 27 80 00       	push   $0x8027d4
  8000e7:	6a 26                	push   $0x26
  8000e9:	68 bc 27 80 00       	push   $0x8027bc
  8000ee:	e8 45 07 00 00       	call   800838 <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  8000f3:	e8 43 1f 00 00       	call   80203b <sys_calculate_free_frames>
  8000f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  8000fb:	e8 be 1f 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  800100:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 50 17 00 00       	call   801864 <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80011a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80011d:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 18 28 80 00       	push   $0x802818
  80012c:	6a 2f                	push   $0x2f
  80012e:	68 bc 27 80 00       	push   $0x8027bc
  800133:	e8 00 07 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800138:	e8 81 1f 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  80013d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800140:	3d 00 02 00 00       	cmp    $0x200,%eax
  800145:	74 14                	je     80015b <_main+0x123>
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 48 28 80 00       	push   $0x802848
  80014f:	6a 31                	push   $0x31
  800151:	68 bc 27 80 00       	push   $0x8027bc
  800156:	e8 dd 06 00 00       	call   800838 <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80015b:	e8 db 1e 00 00       	call   80203b <sys_calculate_free_frames>
  800160:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800163:	e8 56 1f 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  800168:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80016b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016e:	01 c0                	add    %eax,%eax
  800170:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	50                   	push   %eax
  800177:	e8 e8 16 00 00       	call   801864 <malloc>
  80017c:	83 c4 10             	add    $0x10,%esp
  80017f:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  800182:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800185:	89 c2                	mov    %eax,%edx
  800187:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80018a:	01 c0                	add    %eax,%eax
  80018c:	05 00 00 00 80       	add    $0x80000000,%eax
  800191:	39 c2                	cmp    %eax,%edx
  800193:	74 14                	je     8001a9 <_main+0x171>
  800195:	83 ec 04             	sub    $0x4,%esp
  800198:	68 18 28 80 00       	push   $0x802818
  80019d:	6a 37                	push   $0x37
  80019f:	68 bc 27 80 00       	push   $0x8027bc
  8001a4:	e8 8f 06 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001a9:	e8 10 1f 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  8001ae:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001b6:	74 14                	je     8001cc <_main+0x194>
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	68 48 28 80 00       	push   $0x802848
  8001c0:	6a 39                	push   $0x39
  8001c2:	68 bc 27 80 00       	push   $0x8027bc
  8001c7:	e8 6c 06 00 00       	call   800838 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  8001cc:	e8 6a 1e 00 00       	call   80203b <sys_calculate_free_frames>
  8001d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001d4:	e8 e5 1e 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  8001d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	89 c2                	mov    %eax,%edx
  8001e1:	01 d2                	add    %edx,%edx
  8001e3:	01 d0                	add    %edx,%eax
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	50                   	push   %eax
  8001e9:	e8 76 16 00 00       	call   801864 <malloc>
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8001f4:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001f7:	89 c2                	mov    %eax,%edx
  8001f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001fc:	c1 e0 02             	shl    $0x2,%eax
  8001ff:	05 00 00 00 80       	add    $0x80000000,%eax
  800204:	39 c2                	cmp    %eax,%edx
  800206:	74 14                	je     80021c <_main+0x1e4>
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	68 18 28 80 00       	push   $0x802818
  800210:	6a 3f                	push   $0x3f
  800212:	68 bc 27 80 00       	push   $0x8027bc
  800217:	e8 1c 06 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80021c:	e8 9d 1e 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  800221:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800224:	83 f8 01             	cmp    $0x1,%eax
  800227:	74 14                	je     80023d <_main+0x205>
  800229:	83 ec 04             	sub    $0x4,%esp
  80022c:	68 48 28 80 00       	push   $0x802848
  800231:	6a 41                	push   $0x41
  800233:	68 bc 27 80 00       	push   $0x8027bc
  800238:	e8 fb 05 00 00       	call   800838 <_panic>

		//3 KB
		freeFrames = sys_calculate_free_frames() ;
  80023d:	e8 f9 1d 00 00       	call   80203b <sys_calculate_free_frames>
  800242:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800245:	e8 74 1e 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  80024a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  80024d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800250:	89 c2                	mov    %eax,%edx
  800252:	01 d2                	add    %edx,%edx
  800254:	01 d0                	add    %edx,%eax
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	e8 05 16 00 00       	call   801864 <malloc>
  80025f:	83 c4 10             	add    $0x10,%esp
  800262:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  800265:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800268:	89 c2                	mov    %eax,%edx
  80026a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80026d:	c1 e0 02             	shl    $0x2,%eax
  800270:	89 c1                	mov    %eax,%ecx
  800272:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800275:	c1 e0 02             	shl    $0x2,%eax
  800278:	01 c8                	add    %ecx,%eax
  80027a:	05 00 00 00 80       	add    $0x80000000,%eax
  80027f:	39 c2                	cmp    %eax,%edx
  800281:	74 14                	je     800297 <_main+0x25f>
  800283:	83 ec 04             	sub    $0x4,%esp
  800286:	68 18 28 80 00       	push   $0x802818
  80028b:	6a 47                	push   $0x47
  80028d:	68 bc 27 80 00       	push   $0x8027bc
  800292:	e8 a1 05 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  800297:	e8 22 1e 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  80029c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80029f:	83 f8 01             	cmp    $0x1,%eax
  8002a2:	74 14                	je     8002b8 <_main+0x280>
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	68 48 28 80 00       	push   $0x802848
  8002ac:	6a 49                	push   $0x49
  8002ae:	68 bc 27 80 00       	push   $0x8027bc
  8002b3:	e8 80 05 00 00       	call   800838 <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002b8:	e8 7e 1d 00 00       	call   80203b <sys_calculate_free_frames>
  8002bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002c0:	e8 f9 1d 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  8002c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002c8:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	50                   	push   %eax
  8002cf:	e8 4b 1a 00 00       	call   801d1f <free>
  8002d4:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002d7:	e8 e2 1d 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  8002dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002df:	29 c2                	sub    %eax,%edx
  8002e1:	89 d0                	mov    %edx,%eax
  8002e3:	83 f8 01             	cmp    $0x1,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 65 28 80 00       	push   $0x802865
  8002f0:	6a 50                	push   $0x50
  8002f2:	68 bc 27 80 00       	push   $0x8027bc
  8002f7:	e8 3c 05 00 00       	call   800838 <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002fc:	e8 3a 1d 00 00       	call   80203b <sys_calculate_free_frames>
  800301:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800304:	e8 b5 1d 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  800309:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  80030c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80030f:	89 d0                	mov    %edx,%eax
  800311:	01 c0                	add    %eax,%eax
  800313:	01 d0                	add    %edx,%eax
  800315:	01 c0                	add    %eax,%eax
  800317:	01 d0                	add    %edx,%eax
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	50                   	push   %eax
  80031d:	e8 42 15 00 00       	call   801864 <malloc>
  800322:	83 c4 10             	add    $0x10,%esp
  800325:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800328:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80032b:	89 c2                	mov    %eax,%edx
  80032d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800330:	c1 e0 02             	shl    $0x2,%eax
  800333:	89 c1                	mov    %eax,%ecx
  800335:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800338:	c1 e0 03             	shl    $0x3,%eax
  80033b:	01 c8                	add    %ecx,%eax
  80033d:	05 00 00 00 80       	add    $0x80000000,%eax
  800342:	39 c2                	cmp    %eax,%edx
  800344:	74 14                	je     80035a <_main+0x322>
  800346:	83 ec 04             	sub    $0x4,%esp
  800349:	68 18 28 80 00       	push   $0x802818
  80034e:	6a 56                	push   $0x56
  800350:	68 bc 27 80 00       	push   $0x8027bc
  800355:	e8 de 04 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  80035a:	e8 5f 1d 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  80035f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800362:	83 f8 02             	cmp    $0x2,%eax
  800365:	74 14                	je     80037b <_main+0x343>
  800367:	83 ec 04             	sub    $0x4,%esp
  80036a:	68 48 28 80 00       	push   $0x802848
  80036f:	6a 58                	push   $0x58
  800371:	68 bc 27 80 00       	push   $0x8027bc
  800376:	e8 bd 04 00 00       	call   800838 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80037b:	e8 bb 1c 00 00       	call   80203b <sys_calculate_free_frames>
  800380:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800383:	e8 36 1d 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  800388:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  80038b:	8b 45 90             	mov    -0x70(%ebp),%eax
  80038e:	83 ec 0c             	sub    $0xc,%esp
  800391:	50                   	push   %eax
  800392:	e8 88 19 00 00       	call   801d1f <free>
  800397:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  80039a:	e8 1f 1d 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  80039f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003a2:	29 c2                	sub    %eax,%edx
  8003a4:	89 d0                	mov    %edx,%eax
  8003a6:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003ab:	74 14                	je     8003c1 <_main+0x389>
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	68 65 28 80 00       	push   $0x802865
  8003b5:	6a 5f                	push   $0x5f
  8003b7:	68 bc 27 80 00       	push   $0x8027bc
  8003bc:	e8 77 04 00 00       	call   800838 <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003c1:	e8 75 1c 00 00       	call   80203b <sys_calculate_free_frames>
  8003c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003c9:	e8 f0 1c 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  8003ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	01 d2                	add    %edx,%edx
  8003d8:	01 d0                	add    %edx,%eax
  8003da:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003dd:	83 ec 0c             	sub    $0xc,%esp
  8003e0:	50                   	push   %eax
  8003e1:	e8 7e 14 00 00       	call   801864 <malloc>
  8003e6:	83 c4 10             	add    $0x10,%esp
  8003e9:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003ec:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003ef:	89 c2                	mov    %eax,%edx
  8003f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003f4:	c1 e0 02             	shl    $0x2,%eax
  8003f7:	89 c1                	mov    %eax,%ecx
  8003f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003fc:	c1 e0 04             	shl    $0x4,%eax
  8003ff:	01 c8                	add    %ecx,%eax
  800401:	05 00 00 00 80       	add    $0x80000000,%eax
  800406:	39 c2                	cmp    %eax,%edx
  800408:	74 14                	je     80041e <_main+0x3e6>
  80040a:	83 ec 04             	sub    $0x4,%esp
  80040d:	68 18 28 80 00       	push   $0x802818
  800412:	6a 65                	push   $0x65
  800414:	68 bc 27 80 00       	push   $0x8027bc
  800419:	e8 1a 04 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  80041e:	e8 9b 1c 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  800423:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800426:	89 c2                	mov    %eax,%edx
  800428:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80042b:	89 c1                	mov    %eax,%ecx
  80042d:	01 c9                	add    %ecx,%ecx
  80042f:	01 c8                	add    %ecx,%eax
  800431:	85 c0                	test   %eax,%eax
  800433:	79 05                	jns    80043a <_main+0x402>
  800435:	05 ff 0f 00 00       	add    $0xfff,%eax
  80043a:	c1 f8 0c             	sar    $0xc,%eax
  80043d:	39 c2                	cmp    %eax,%edx
  80043f:	74 14                	je     800455 <_main+0x41d>
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 48 28 80 00       	push   $0x802848
  800449:	6a 67                	push   $0x67
  80044b:	68 bc 27 80 00       	push   $0x8027bc
  800450:	e8 e3 03 00 00       	call   800838 <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  800455:	e8 e1 1b 00 00       	call   80203b <sys_calculate_free_frames>
  80045a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80045d:	e8 5c 1c 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  800462:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  800465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800468:	89 c2                	mov    %eax,%edx
  80046a:	01 d2                	add    %edx,%edx
  80046c:	01 c2                	add    %eax,%edx
  80046e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800471:	01 d0                	add    %edx,%eax
  800473:	01 c0                	add    %eax,%eax
  800475:	83 ec 0c             	sub    $0xc,%esp
  800478:	50                   	push   %eax
  800479:	e8 e6 13 00 00       	call   801864 <malloc>
  80047e:	83 c4 10             	add    $0x10,%esp
  800481:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  800484:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800487:	89 c1                	mov    %eax,%ecx
  800489:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80048c:	89 d0                	mov    %edx,%eax
  80048e:	01 c0                	add    %eax,%eax
  800490:	01 d0                	add    %edx,%eax
  800492:	01 c0                	add    %eax,%eax
  800494:	01 d0                	add    %edx,%eax
  800496:	89 c2                	mov    %eax,%edx
  800498:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80049b:	c1 e0 04             	shl    $0x4,%eax
  80049e:	01 d0                	add    %edx,%eax
  8004a0:	05 00 00 00 80       	add    $0x80000000,%eax
  8004a5:	39 c1                	cmp    %eax,%ecx
  8004a7:	74 14                	je     8004bd <_main+0x485>
  8004a9:	83 ec 04             	sub    $0x4,%esp
  8004ac:	68 18 28 80 00       	push   $0x802818
  8004b1:	6a 6d                	push   $0x6d
  8004b3:	68 bc 27 80 00       	push   $0x8027bc
  8004b8:	e8 7b 03 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004bd:	e8 fc 1b 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  8004c2:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004c5:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004ca:	74 14                	je     8004e0 <_main+0x4a8>
  8004cc:	83 ec 04             	sub    $0x4,%esp
  8004cf:	68 48 28 80 00       	push   $0x802848
  8004d4:	6a 6f                	push   $0x6f
  8004d6:	68 bc 27 80 00       	push   $0x8027bc
  8004db:	e8 58 03 00 00       	call   800838 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8004e0:	e8 56 1b 00 00       	call   80203b <sys_calculate_free_frames>
  8004e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e8:	e8 d1 1b 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  8004ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  8004f0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004f3:	83 ec 0c             	sub    $0xc,%esp
  8004f6:	50                   	push   %eax
  8004f7:	e8 23 18 00 00       	call   801d1f <free>
  8004fc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  8004ff:	e8 ba 1b 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  800504:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800507:	29 c2                	sub    %eax,%edx
  800509:	89 d0                	mov    %edx,%eax
  80050b:	3d 00 03 00 00       	cmp    $0x300,%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 65 28 80 00       	push   $0x802865
  80051a:	6a 76                	push   $0x76
  80051c:	68 bc 27 80 00       	push   $0x8027bc
  800521:	e8 12 03 00 00       	call   800838 <_panic>

		//2 MB Hole [Resulting Hole = 2 MB + 2 MB + 4 KB = 4 MB + 4 KB]
		freeFrames = sys_calculate_free_frames() ;
  800526:	e8 10 1b 00 00       	call   80203b <sys_calculate_free_frames>
  80052b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80052e:	e8 8b 1b 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  800533:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  800536:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	50                   	push   %eax
  80053d:	e8 dd 17 00 00       	call   801d1f <free>
  800542:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  800545:	e8 74 1b 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  80054a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80054d:	29 c2                	sub    %eax,%edx
  80054f:	89 d0                	mov    %edx,%eax
  800551:	3d 00 02 00 00       	cmp    $0x200,%eax
  800556:	74 14                	je     80056c <_main+0x534>
  800558:	83 ec 04             	sub    $0x4,%esp
  80055b:	68 65 28 80 00       	push   $0x802865
  800560:	6a 7d                	push   $0x7d
  800562:	68 bc 27 80 00       	push   $0x8027bc
  800567:	e8 cc 02 00 00       	call   800838 <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  80056c:	e8 ca 1a 00 00       	call   80203b <sys_calculate_free_frames>
  800571:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800574:	e8 45 1b 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  800579:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  80057c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80057f:	89 d0                	mov    %edx,%eax
  800581:	c1 e0 02             	shl    $0x2,%eax
  800584:	01 d0                	add    %edx,%eax
  800586:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800589:	83 ec 0c             	sub    $0xc,%esp
  80058c:	50                   	push   %eax
  80058d:	e8 d2 12 00 00       	call   801864 <malloc>
  800592:	83 c4 10             	add    $0x10,%esp
  800595:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800598:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80059b:	89 c1                	mov    %eax,%ecx
  80059d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005a0:	89 d0                	mov    %edx,%eax
  8005a2:	c1 e0 03             	shl    $0x3,%eax
  8005a5:	01 d0                	add    %edx,%eax
  8005a7:	89 c3                	mov    %eax,%ebx
  8005a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005ac:	89 d0                	mov    %edx,%eax
  8005ae:	01 c0                	add    %eax,%eax
  8005b0:	01 d0                	add    %edx,%eax
  8005b2:	c1 e0 03             	shl    $0x3,%eax
  8005b5:	01 d8                	add    %ebx,%eax
  8005b7:	05 00 00 00 80       	add    $0x80000000,%eax
  8005bc:	39 c1                	cmp    %eax,%ecx
  8005be:	74 17                	je     8005d7 <_main+0x59f>
  8005c0:	83 ec 04             	sub    $0x4,%esp
  8005c3:	68 18 28 80 00       	push   $0x802818
  8005c8:	68 83 00 00 00       	push   $0x83
  8005cd:	68 bc 27 80 00       	push   $0x8027bc
  8005d2:	e8 61 02 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  8005d7:	e8 e2 1a 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  8005dc:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8005df:	89 c1                	mov    %eax,%ecx
  8005e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005e4:	89 d0                	mov    %edx,%eax
  8005e6:	c1 e0 02             	shl    $0x2,%eax
  8005e9:	01 d0                	add    %edx,%eax
  8005eb:	85 c0                	test   %eax,%eax
  8005ed:	79 05                	jns    8005f4 <_main+0x5bc>
  8005ef:	05 ff 0f 00 00       	add    $0xfff,%eax
  8005f4:	c1 f8 0c             	sar    $0xc,%eax
  8005f7:	39 c1                	cmp    %eax,%ecx
  8005f9:	74 17                	je     800612 <_main+0x5da>
  8005fb:	83 ec 04             	sub    $0x4,%esp
  8005fe:	68 48 28 80 00       	push   $0x802848
  800603:	68 85 00 00 00       	push   $0x85
  800608:	68 bc 27 80 00       	push   $0x8027bc
  80060d:	e8 26 02 00 00       	call   800838 <_panic>
//		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
//		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");

		//[FIRST FIT Case]
		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  800612:	e8 24 1a 00 00       	call   80203b <sys_calculate_free_frames>
  800617:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80061a:	e8 9f 1a 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  80061f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(3*Mega-kilo);
  800622:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800625:	89 c2                	mov    %eax,%edx
  800627:	01 d2                	add    %edx,%edx
  800629:	01 d0                	add    %edx,%eax
  80062b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80062e:	83 ec 0c             	sub    $0xc,%esp
  800631:	50                   	push   %eax
  800632:	e8 2d 12 00 00       	call   801864 <malloc>
  800637:	83 c4 10             	add    $0x10,%esp
  80063a:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80063d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800640:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800645:	74 17                	je     80065e <_main+0x626>
  800647:	83 ec 04             	sub    $0x4,%esp
  80064a:	68 18 28 80 00       	push   $0x802818
  80064f:	68 93 00 00 00       	push   $0x93
  800654:	68 bc 27 80 00       	push   $0x8027bc
  800659:	e8 da 01 00 00       	call   800838 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  80065e:	e8 5b 1a 00 00       	call   8020be <sys_pf_calculate_allocated_pages>
  800663:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800666:	89 c2                	mov    %eax,%edx
  800668:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80066b:	89 c1                	mov    %eax,%ecx
  80066d:	01 c9                	add    %ecx,%ecx
  80066f:	01 c8                	add    %ecx,%eax
  800671:	85 c0                	test   %eax,%eax
  800673:	79 05                	jns    80067a <_main+0x642>
  800675:	05 ff 0f 00 00       	add    $0xfff,%eax
  80067a:	c1 f8 0c             	sar    $0xc,%eax
  80067d:	39 c2                	cmp    %eax,%edx
  80067f:	74 17                	je     800698 <_main+0x660>
  800681:	83 ec 04             	sub    $0x4,%esp
  800684:	68 48 28 80 00       	push   $0x802848
  800689:	68 95 00 00 00       	push   $0x95
  80068e:	68 bc 27 80 00       	push   $0x8027bc
  800693:	e8 a0 01 00 00       	call   800838 <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[9] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  800698:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80069b:	89 d0                	mov    %edx,%eax
  80069d:	01 c0                	add    %eax,%eax
  80069f:	01 d0                	add    %edx,%eax
  8006a1:	01 c0                	add    %eax,%eax
  8006a3:	01 d0                	add    %edx,%eax
  8006a5:	01 c0                	add    %eax,%eax
  8006a7:	f7 d8                	neg    %eax
  8006a9:	05 00 00 00 20       	add    $0x20000000,%eax
  8006ae:	83 ec 0c             	sub    $0xc,%esp
  8006b1:	50                   	push   %eax
  8006b2:	e8 ad 11 00 00       	call   801864 <malloc>
  8006b7:	83 c4 10             	add    $0x10,%esp
  8006ba:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if (ptr_allocations[9] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  8006bd:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006c0:	85 c0                	test   %eax,%eax
  8006c2:	74 17                	je     8006db <_main+0x6a3>
  8006c4:	83 ec 04             	sub    $0x4,%esp
  8006c7:	68 7c 28 80 00       	push   $0x80287c
  8006cc:	68 9e 00 00 00       	push   $0x9e
  8006d1:	68 bc 27 80 00       	push   $0x8027bc
  8006d6:	e8 5d 01 00 00       	call   800838 <_panic>

		cprintf("Congratulations!! test FIRST FIT allocation (2) completed successfully.\n");
  8006db:	83 ec 0c             	sub    $0xc,%esp
  8006de:	68 e0 28 80 00       	push   $0x8028e0
  8006e3:	e8 f2 03 00 00       	call   800ada <cprintf>
  8006e8:	83 c4 10             	add    $0x10,%esp

		return;
  8006eb:	90                   	nop
	}
}
  8006ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006ef:	5b                   	pop    %ebx
  8006f0:	5f                   	pop    %edi
  8006f1:	5d                   	pop    %ebp
  8006f2:	c3                   	ret    

008006f3 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8006f3:	55                   	push   %ebp
  8006f4:	89 e5                	mov    %esp,%ebp
  8006f6:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8006f9:	e8 72 18 00 00       	call   801f70 <sys_getenvindex>
  8006fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800701:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800704:	89 d0                	mov    %edx,%eax
  800706:	c1 e0 03             	shl    $0x3,%eax
  800709:	01 d0                	add    %edx,%eax
  80070b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  800712:	01 c8                	add    %ecx,%eax
  800714:	01 c0                	add    %eax,%eax
  800716:	01 d0                	add    %edx,%eax
  800718:	01 c0                	add    %eax,%eax
  80071a:	01 d0                	add    %edx,%eax
  80071c:	89 c2                	mov    %eax,%edx
  80071e:	c1 e2 05             	shl    $0x5,%edx
  800721:	29 c2                	sub    %eax,%edx
  800723:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80072a:	89 c2                	mov    %eax,%edx
  80072c:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800732:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800737:	a1 20 30 80 00       	mov    0x803020,%eax
  80073c:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800742:	84 c0                	test   %al,%al
  800744:	74 0f                	je     800755 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800746:	a1 20 30 80 00       	mov    0x803020,%eax
  80074b:	05 40 3c 01 00       	add    $0x13c40,%eax
  800750:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800755:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800759:	7e 0a                	jle    800765 <libmain+0x72>
		binaryname = argv[0];
  80075b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075e:	8b 00                	mov    (%eax),%eax
  800760:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800765:	83 ec 08             	sub    $0x8,%esp
  800768:	ff 75 0c             	pushl  0xc(%ebp)
  80076b:	ff 75 08             	pushl  0x8(%ebp)
  80076e:	e8 c5 f8 ff ff       	call   800038 <_main>
  800773:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800776:	e8 90 19 00 00       	call   80210b <sys_disable_interrupt>
	cprintf("**************************************\n");
  80077b:	83 ec 0c             	sub    $0xc,%esp
  80077e:	68 44 29 80 00       	push   $0x802944
  800783:	e8 52 03 00 00       	call   800ada <cprintf>
  800788:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80078b:	a1 20 30 80 00       	mov    0x803020,%eax
  800790:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800796:	a1 20 30 80 00       	mov    0x803020,%eax
  80079b:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  8007a1:	83 ec 04             	sub    $0x4,%esp
  8007a4:	52                   	push   %edx
  8007a5:	50                   	push   %eax
  8007a6:	68 6c 29 80 00       	push   $0x80296c
  8007ab:	e8 2a 03 00 00       	call   800ada <cprintf>
  8007b0:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  8007b3:	a1 20 30 80 00       	mov    0x803020,%eax
  8007b8:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8007be:	a1 20 30 80 00       	mov    0x803020,%eax
  8007c3:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8007c9:	83 ec 04             	sub    $0x4,%esp
  8007cc:	52                   	push   %edx
  8007cd:	50                   	push   %eax
  8007ce:	68 94 29 80 00       	push   $0x802994
  8007d3:	e8 02 03 00 00       	call   800ada <cprintf>
  8007d8:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8007db:	a1 20 30 80 00       	mov    0x803020,%eax
  8007e0:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8007e6:	83 ec 08             	sub    $0x8,%esp
  8007e9:	50                   	push   %eax
  8007ea:	68 d5 29 80 00       	push   $0x8029d5
  8007ef:	e8 e6 02 00 00       	call   800ada <cprintf>
  8007f4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8007f7:	83 ec 0c             	sub    $0xc,%esp
  8007fa:	68 44 29 80 00       	push   $0x802944
  8007ff:	e8 d6 02 00 00       	call   800ada <cprintf>
  800804:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800807:	e8 19 19 00 00       	call   802125 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80080c:	e8 19 00 00 00       	call   80082a <exit>
}
  800811:	90                   	nop
  800812:	c9                   	leave  
  800813:	c3                   	ret    

00800814 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800814:	55                   	push   %ebp
  800815:	89 e5                	mov    %esp,%ebp
  800817:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  80081a:	83 ec 0c             	sub    $0xc,%esp
  80081d:	6a 00                	push   $0x0
  80081f:	e8 18 17 00 00       	call   801f3c <sys_env_destroy>
  800824:	83 c4 10             	add    $0x10,%esp
}
  800827:	90                   	nop
  800828:	c9                   	leave  
  800829:	c3                   	ret    

0080082a <exit>:

void
exit(void)
{
  80082a:	55                   	push   %ebp
  80082b:	89 e5                	mov    %esp,%ebp
  80082d:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800830:	e8 6d 17 00 00       	call   801fa2 <sys_env_exit>
}
  800835:	90                   	nop
  800836:	c9                   	leave  
  800837:	c3                   	ret    

00800838 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800838:	55                   	push   %ebp
  800839:	89 e5                	mov    %esp,%ebp
  80083b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80083e:	8d 45 10             	lea    0x10(%ebp),%eax
  800841:	83 c0 04             	add    $0x4,%eax
  800844:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800847:	a1 18 31 80 00       	mov    0x803118,%eax
  80084c:	85 c0                	test   %eax,%eax
  80084e:	74 16                	je     800866 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800850:	a1 18 31 80 00       	mov    0x803118,%eax
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	50                   	push   %eax
  800859:	68 ec 29 80 00       	push   $0x8029ec
  80085e:	e8 77 02 00 00       	call   800ada <cprintf>
  800863:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800866:	a1 00 30 80 00       	mov    0x803000,%eax
  80086b:	ff 75 0c             	pushl  0xc(%ebp)
  80086e:	ff 75 08             	pushl  0x8(%ebp)
  800871:	50                   	push   %eax
  800872:	68 f1 29 80 00       	push   $0x8029f1
  800877:	e8 5e 02 00 00       	call   800ada <cprintf>
  80087c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80087f:	8b 45 10             	mov    0x10(%ebp),%eax
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	ff 75 f4             	pushl  -0xc(%ebp)
  800888:	50                   	push   %eax
  800889:	e8 e1 01 00 00       	call   800a6f <vcprintf>
  80088e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800891:	83 ec 08             	sub    $0x8,%esp
  800894:	6a 00                	push   $0x0
  800896:	68 0d 2a 80 00       	push   $0x802a0d
  80089b:	e8 cf 01 00 00       	call   800a6f <vcprintf>
  8008a0:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8008a3:	e8 82 ff ff ff       	call   80082a <exit>

	// should not return here
	while (1) ;
  8008a8:	eb fe                	jmp    8008a8 <_panic+0x70>

008008aa <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8008b0:	a1 20 30 80 00       	mov    0x803020,%eax
  8008b5:	8b 50 74             	mov    0x74(%eax),%edx
  8008b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bb:	39 c2                	cmp    %eax,%edx
  8008bd:	74 14                	je     8008d3 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8008bf:	83 ec 04             	sub    $0x4,%esp
  8008c2:	68 10 2a 80 00       	push   $0x802a10
  8008c7:	6a 26                	push   $0x26
  8008c9:	68 5c 2a 80 00       	push   $0x802a5c
  8008ce:	e8 65 ff ff ff       	call   800838 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8008d3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8008da:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8008e1:	e9 b6 00 00 00       	jmp    80099c <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  8008e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	01 d0                	add    %edx,%eax
  8008f5:	8b 00                	mov    (%eax),%eax
  8008f7:	85 c0                	test   %eax,%eax
  8008f9:	75 08                	jne    800903 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8008fb:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8008fe:	e9 96 00 00 00       	jmp    800999 <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800903:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80090a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800911:	eb 5d                	jmp    800970 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800913:	a1 20 30 80 00       	mov    0x803020,%eax
  800918:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  80091e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800921:	c1 e2 04             	shl    $0x4,%edx
  800924:	01 d0                	add    %edx,%eax
  800926:	8a 40 04             	mov    0x4(%eax),%al
  800929:	84 c0                	test   %al,%al
  80092b:	75 40                	jne    80096d <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80092d:	a1 20 30 80 00       	mov    0x803020,%eax
  800932:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800938:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80093b:	c1 e2 04             	shl    $0x4,%edx
  80093e:	01 d0                	add    %edx,%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800945:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800948:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80094d:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80094f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800952:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	01 c8                	add    %ecx,%eax
  80095e:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800960:	39 c2                	cmp    %eax,%edx
  800962:	75 09                	jne    80096d <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800964:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80096b:	eb 12                	jmp    80097f <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096d:	ff 45 e8             	incl   -0x18(%ebp)
  800970:	a1 20 30 80 00       	mov    0x803020,%eax
  800975:	8b 50 74             	mov    0x74(%eax),%edx
  800978:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80097b:	39 c2                	cmp    %eax,%edx
  80097d:	77 94                	ja     800913 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80097f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800983:	75 14                	jne    800999 <CheckWSWithoutLastIndex+0xef>
			panic(
  800985:	83 ec 04             	sub    $0x4,%esp
  800988:	68 68 2a 80 00       	push   $0x802a68
  80098d:	6a 3a                	push   $0x3a
  80098f:	68 5c 2a 80 00       	push   $0x802a5c
  800994:	e8 9f fe ff ff       	call   800838 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800999:	ff 45 f0             	incl   -0x10(%ebp)
  80099c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8009a2:	0f 8c 3e ff ff ff    	jl     8008e6 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8009a8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009b6:	eb 20                	jmp    8009d8 <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8009b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8009bd:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  8009c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009c6:	c1 e2 04             	shl    $0x4,%edx
  8009c9:	01 d0                	add    %edx,%eax
  8009cb:	8a 40 04             	mov    0x4(%eax),%al
  8009ce:	3c 01                	cmp    $0x1,%al
  8009d0:	75 03                	jne    8009d5 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  8009d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009d5:	ff 45 e0             	incl   -0x20(%ebp)
  8009d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8009dd:	8b 50 74             	mov    0x74(%eax),%edx
  8009e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e3:	39 c2                	cmp    %eax,%edx
  8009e5:	77 d1                	ja     8009b8 <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8009e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8009ed:	74 14                	je     800a03 <CheckWSWithoutLastIndex+0x159>
		panic(
  8009ef:	83 ec 04             	sub    $0x4,%esp
  8009f2:	68 bc 2a 80 00       	push   $0x802abc
  8009f7:	6a 44                	push   $0x44
  8009f9:	68 5c 2a 80 00       	push   $0x802a5c
  8009fe:	e8 35 fe ff ff       	call   800838 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a03:	90                   	nop
  800a04:	c9                   	leave  
  800a05:	c3                   	ret    

00800a06 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0f:	8b 00                	mov    (%eax),%eax
  800a11:	8d 48 01             	lea    0x1(%eax),%ecx
  800a14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a17:	89 0a                	mov    %ecx,(%edx)
  800a19:	8b 55 08             	mov    0x8(%ebp),%edx
  800a1c:	88 d1                	mov    %dl,%cl
  800a1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a21:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a28:	8b 00                	mov    (%eax),%eax
  800a2a:	3d ff 00 00 00       	cmp    $0xff,%eax
  800a2f:	75 2c                	jne    800a5d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800a31:	a0 24 30 80 00       	mov    0x803024,%al
  800a36:	0f b6 c0             	movzbl %al,%eax
  800a39:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a3c:	8b 12                	mov    (%edx),%edx
  800a3e:	89 d1                	mov    %edx,%ecx
  800a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a43:	83 c2 08             	add    $0x8,%edx
  800a46:	83 ec 04             	sub    $0x4,%esp
  800a49:	50                   	push   %eax
  800a4a:	51                   	push   %ecx
  800a4b:	52                   	push   %edx
  800a4c:	e8 a9 14 00 00       	call   801efa <sys_cputs>
  800a51:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800a5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a60:	8b 40 04             	mov    0x4(%eax),%eax
  800a63:	8d 50 01             	lea    0x1(%eax),%edx
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	89 50 04             	mov    %edx,0x4(%eax)
}
  800a6c:	90                   	nop
  800a6d:	c9                   	leave  
  800a6e:	c3                   	ret    

00800a6f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800a78:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800a7f:	00 00 00 
	b.cnt = 0;
  800a82:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800a89:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a8c:	ff 75 0c             	pushl  0xc(%ebp)
  800a8f:	ff 75 08             	pushl  0x8(%ebp)
  800a92:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	68 06 0a 80 00       	push   $0x800a06
  800a9e:	e8 11 02 00 00       	call   800cb4 <vprintfmt>
  800aa3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800aa6:	a0 24 30 80 00       	mov    0x803024,%al
  800aab:	0f b6 c0             	movzbl %al,%eax
  800aae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	50                   	push   %eax
  800ab8:	52                   	push   %edx
  800ab9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800abf:	83 c0 08             	add    $0x8,%eax
  800ac2:	50                   	push   %eax
  800ac3:	e8 32 14 00 00       	call   801efa <sys_cputs>
  800ac8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800acb:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800ad2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800ad8:	c9                   	leave  
  800ad9:	c3                   	ret    

00800ada <cprintf>:

int cprintf(const char *fmt, ...) {
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800ae0:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800ae7:	8d 45 0c             	lea    0xc(%ebp),%eax
  800aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800aed:	8b 45 08             	mov    0x8(%ebp),%eax
  800af0:	83 ec 08             	sub    $0x8,%esp
  800af3:	ff 75 f4             	pushl  -0xc(%ebp)
  800af6:	50                   	push   %eax
  800af7:	e8 73 ff ff ff       	call   800a6f <vcprintf>
  800afc:	83 c4 10             	add    $0x10,%esp
  800aff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b05:	c9                   	leave  
  800b06:	c3                   	ret    

00800b07 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b07:	55                   	push   %ebp
  800b08:	89 e5                	mov    %esp,%ebp
  800b0a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b0d:	e8 f9 15 00 00       	call   80210b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b12:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	83 ec 08             	sub    $0x8,%esp
  800b1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b21:	50                   	push   %eax
  800b22:	e8 48 ff ff ff       	call   800a6f <vcprintf>
  800b27:	83 c4 10             	add    $0x10,%esp
  800b2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800b2d:	e8 f3 15 00 00       	call   802125 <sys_enable_interrupt>
	return cnt;
  800b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b35:	c9                   	leave  
  800b36:	c3                   	ret    

00800b37 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	53                   	push   %ebx
  800b3b:	83 ec 14             	sub    $0x14,%esp
  800b3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b44:	8b 45 14             	mov    0x14(%ebp),%eax
  800b47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800b4a:	8b 45 18             	mov    0x18(%ebp),%eax
  800b4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b52:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b55:	77 55                	ja     800bac <printnum+0x75>
  800b57:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800b5a:	72 05                	jb     800b61 <printnum+0x2a>
  800b5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b5f:	77 4b                	ja     800bac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800b61:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b64:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800b67:	8b 45 18             	mov    0x18(%ebp),%eax
  800b6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800b6f:	52                   	push   %edx
  800b70:	50                   	push   %eax
  800b71:	ff 75 f4             	pushl  -0xc(%ebp)
  800b74:	ff 75 f0             	pushl  -0x10(%ebp)
  800b77:	e8 b0 19 00 00       	call   80252c <__udivdi3>
  800b7c:	83 c4 10             	add    $0x10,%esp
  800b7f:	83 ec 04             	sub    $0x4,%esp
  800b82:	ff 75 20             	pushl  0x20(%ebp)
  800b85:	53                   	push   %ebx
  800b86:	ff 75 18             	pushl  0x18(%ebp)
  800b89:	52                   	push   %edx
  800b8a:	50                   	push   %eax
  800b8b:	ff 75 0c             	pushl  0xc(%ebp)
  800b8e:	ff 75 08             	pushl  0x8(%ebp)
  800b91:	e8 a1 ff ff ff       	call   800b37 <printnum>
  800b96:	83 c4 20             	add    $0x20,%esp
  800b99:	eb 1a                	jmp    800bb5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	ff 75 0c             	pushl  0xc(%ebp)
  800ba1:	ff 75 20             	pushl  0x20(%ebp)
  800ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba7:	ff d0                	call   *%eax
  800ba9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800bac:	ff 4d 1c             	decl   0x1c(%ebp)
  800baf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800bb3:	7f e6                	jg     800b9b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800bb5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800bb8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bc0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bc3:	53                   	push   %ebx
  800bc4:	51                   	push   %ecx
  800bc5:	52                   	push   %edx
  800bc6:	50                   	push   %eax
  800bc7:	e8 70 1a 00 00       	call   80263c <__umoddi3>
  800bcc:	83 c4 10             	add    $0x10,%esp
  800bcf:	05 34 2d 80 00       	add    $0x802d34,%eax
  800bd4:	8a 00                	mov    (%eax),%al
  800bd6:	0f be c0             	movsbl %al,%eax
  800bd9:	83 ec 08             	sub    $0x8,%esp
  800bdc:	ff 75 0c             	pushl  0xc(%ebp)
  800bdf:	50                   	push   %eax
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	ff d0                	call   *%eax
  800be5:	83 c4 10             	add    $0x10,%esp
}
  800be8:	90                   	nop
  800be9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bf1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bf5:	7e 1c                	jle    800c13 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfa:	8b 00                	mov    (%eax),%eax
  800bfc:	8d 50 08             	lea    0x8(%eax),%edx
  800bff:	8b 45 08             	mov    0x8(%ebp),%eax
  800c02:	89 10                	mov    %edx,(%eax)
  800c04:	8b 45 08             	mov    0x8(%ebp),%eax
  800c07:	8b 00                	mov    (%eax),%eax
  800c09:	83 e8 08             	sub    $0x8,%eax
  800c0c:	8b 50 04             	mov    0x4(%eax),%edx
  800c0f:	8b 00                	mov    (%eax),%eax
  800c11:	eb 40                	jmp    800c53 <getuint+0x65>
	else if (lflag)
  800c13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c17:	74 1e                	je     800c37 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8b 00                	mov    (%eax),%eax
  800c1e:	8d 50 04             	lea    0x4(%eax),%edx
  800c21:	8b 45 08             	mov    0x8(%ebp),%eax
  800c24:	89 10                	mov    %edx,(%eax)
  800c26:	8b 45 08             	mov    0x8(%ebp),%eax
  800c29:	8b 00                	mov    (%eax),%eax
  800c2b:	83 e8 04             	sub    $0x4,%eax
  800c2e:	8b 00                	mov    (%eax),%eax
  800c30:	ba 00 00 00 00       	mov    $0x0,%edx
  800c35:	eb 1c                	jmp    800c53 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800c37:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3a:	8b 00                	mov    (%eax),%eax
  800c3c:	8d 50 04             	lea    0x4(%eax),%edx
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	89 10                	mov    %edx,(%eax)
  800c44:	8b 45 08             	mov    0x8(%ebp),%eax
  800c47:	8b 00                	mov    (%eax),%eax
  800c49:	83 e8 04             	sub    $0x4,%eax
  800c4c:	8b 00                	mov    (%eax),%eax
  800c4e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c58:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c5c:	7e 1c                	jle    800c7a <getint+0x25>
		return va_arg(*ap, long long);
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	8b 00                	mov    (%eax),%eax
  800c63:	8d 50 08             	lea    0x8(%eax),%edx
  800c66:	8b 45 08             	mov    0x8(%ebp),%eax
  800c69:	89 10                	mov    %edx,(%eax)
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8b 00                	mov    (%eax),%eax
  800c70:	83 e8 08             	sub    $0x8,%eax
  800c73:	8b 50 04             	mov    0x4(%eax),%edx
  800c76:	8b 00                	mov    (%eax),%eax
  800c78:	eb 38                	jmp    800cb2 <getint+0x5d>
	else if (lflag)
  800c7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7e:	74 1a                	je     800c9a <getint+0x45>
		return va_arg(*ap, long);
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8b 00                	mov    (%eax),%eax
  800c85:	8d 50 04             	lea    0x4(%eax),%edx
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8b:	89 10                	mov    %edx,(%eax)
  800c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c90:	8b 00                	mov    (%eax),%eax
  800c92:	83 e8 04             	sub    $0x4,%eax
  800c95:	8b 00                	mov    (%eax),%eax
  800c97:	99                   	cltd   
  800c98:	eb 18                	jmp    800cb2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	8b 00                	mov    (%eax),%eax
  800c9f:	8d 50 04             	lea    0x4(%eax),%edx
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 10                	mov    %edx,(%eax)
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8b 00                	mov    (%eax),%eax
  800cac:	83 e8 04             	sub    $0x4,%eax
  800caf:	8b 00                	mov    (%eax),%eax
  800cb1:	99                   	cltd   
}
  800cb2:	5d                   	pop    %ebp
  800cb3:	c3                   	ret    

00800cb4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	56                   	push   %esi
  800cb8:	53                   	push   %ebx
  800cb9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cbc:	eb 17                	jmp    800cd5 <vprintfmt+0x21>
			if (ch == '\0')
  800cbe:	85 db                	test   %ebx,%ebx
  800cc0:	0f 84 af 03 00 00    	je     801075 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800cc6:	83 ec 08             	sub    $0x8,%esp
  800cc9:	ff 75 0c             	pushl  0xc(%ebp)
  800ccc:	53                   	push   %ebx
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	ff d0                	call   *%eax
  800cd2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800cd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd8:	8d 50 01             	lea    0x1(%eax),%edx
  800cdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	0f b6 d8             	movzbl %al,%ebx
  800ce3:	83 fb 25             	cmp    $0x25,%ebx
  800ce6:	75 d6                	jne    800cbe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ce8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800cec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800cf3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800cfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d08:	8b 45 10             	mov    0x10(%ebp),%eax
  800d0b:	8d 50 01             	lea    0x1(%eax),%edx
  800d0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800d11:	8a 00                	mov    (%eax),%al
  800d13:	0f b6 d8             	movzbl %al,%ebx
  800d16:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d19:	83 f8 55             	cmp    $0x55,%eax
  800d1c:	0f 87 2b 03 00 00    	ja     80104d <vprintfmt+0x399>
  800d22:	8b 04 85 58 2d 80 00 	mov    0x802d58(,%eax,4),%eax
  800d29:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800d2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800d2f:	eb d7                	jmp    800d08 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800d31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800d35:	eb d1                	jmp    800d08 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800d3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800d41:	89 d0                	mov    %edx,%eax
  800d43:	c1 e0 02             	shl    $0x2,%eax
  800d46:	01 d0                	add    %edx,%eax
  800d48:	01 c0                	add    %eax,%eax
  800d4a:	01 d8                	add    %ebx,%eax
  800d4c:	83 e8 30             	sub    $0x30,%eax
  800d4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800d52:	8b 45 10             	mov    0x10(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800d5a:	83 fb 2f             	cmp    $0x2f,%ebx
  800d5d:	7e 3e                	jle    800d9d <vprintfmt+0xe9>
  800d5f:	83 fb 39             	cmp    $0x39,%ebx
  800d62:	7f 39                	jg     800d9d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800d64:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800d67:	eb d5                	jmp    800d3e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800d69:	8b 45 14             	mov    0x14(%ebp),%eax
  800d6c:	83 c0 04             	add    $0x4,%eax
  800d6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800d72:	8b 45 14             	mov    0x14(%ebp),%eax
  800d75:	83 e8 04             	sub    $0x4,%eax
  800d78:	8b 00                	mov    (%eax),%eax
  800d7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800d7d:	eb 1f                	jmp    800d9e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800d7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d83:	79 83                	jns    800d08 <vprintfmt+0x54>
				width = 0;
  800d85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d8c:	e9 77 ff ff ff       	jmp    800d08 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d91:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d98:	e9 6b ff ff ff       	jmp    800d08 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d9d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800da2:	0f 89 60 ff ff ff    	jns    800d08 <vprintfmt+0x54>
				width = precision, precision = -1;
  800da8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800dae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800db5:	e9 4e ff ff ff       	jmp    800d08 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800dba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800dbd:	e9 46 ff ff ff       	jmp    800d08 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800dc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc5:	83 c0 04             	add    $0x4,%eax
  800dc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800dcb:	8b 45 14             	mov    0x14(%ebp),%eax
  800dce:	83 e8 04             	sub    $0x4,%eax
  800dd1:	8b 00                	mov    (%eax),%eax
  800dd3:	83 ec 08             	sub    $0x8,%esp
  800dd6:	ff 75 0c             	pushl  0xc(%ebp)
  800dd9:	50                   	push   %eax
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	ff d0                	call   *%eax
  800ddf:	83 c4 10             	add    $0x10,%esp
			break;
  800de2:	e9 89 02 00 00       	jmp    801070 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800de7:	8b 45 14             	mov    0x14(%ebp),%eax
  800dea:	83 c0 04             	add    $0x4,%eax
  800ded:	89 45 14             	mov    %eax,0x14(%ebp)
  800df0:	8b 45 14             	mov    0x14(%ebp),%eax
  800df3:	83 e8 04             	sub    $0x4,%eax
  800df6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800df8:	85 db                	test   %ebx,%ebx
  800dfa:	79 02                	jns    800dfe <vprintfmt+0x14a>
				err = -err;
  800dfc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800dfe:	83 fb 64             	cmp    $0x64,%ebx
  800e01:	7f 0b                	jg     800e0e <vprintfmt+0x15a>
  800e03:	8b 34 9d a0 2b 80 00 	mov    0x802ba0(,%ebx,4),%esi
  800e0a:	85 f6                	test   %esi,%esi
  800e0c:	75 19                	jne    800e27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e0e:	53                   	push   %ebx
  800e0f:	68 45 2d 80 00       	push   $0x802d45
  800e14:	ff 75 0c             	pushl  0xc(%ebp)
  800e17:	ff 75 08             	pushl  0x8(%ebp)
  800e1a:	e8 5e 02 00 00       	call   80107d <printfmt>
  800e1f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e22:	e9 49 02 00 00       	jmp    801070 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e27:	56                   	push   %esi
  800e28:	68 4e 2d 80 00       	push   $0x802d4e
  800e2d:	ff 75 0c             	pushl  0xc(%ebp)
  800e30:	ff 75 08             	pushl  0x8(%ebp)
  800e33:	e8 45 02 00 00       	call   80107d <printfmt>
  800e38:	83 c4 10             	add    $0x10,%esp
			break;
  800e3b:	e9 30 02 00 00       	jmp    801070 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800e40:	8b 45 14             	mov    0x14(%ebp),%eax
  800e43:	83 c0 04             	add    $0x4,%eax
  800e46:	89 45 14             	mov    %eax,0x14(%ebp)
  800e49:	8b 45 14             	mov    0x14(%ebp),%eax
  800e4c:	83 e8 04             	sub    $0x4,%eax
  800e4f:	8b 30                	mov    (%eax),%esi
  800e51:	85 f6                	test   %esi,%esi
  800e53:	75 05                	jne    800e5a <vprintfmt+0x1a6>
				p = "(null)";
  800e55:	be 51 2d 80 00       	mov    $0x802d51,%esi
			if (width > 0 && padc != '-')
  800e5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e5e:	7e 6d                	jle    800ecd <vprintfmt+0x219>
  800e60:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800e64:	74 67                	je     800ecd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e69:	83 ec 08             	sub    $0x8,%esp
  800e6c:	50                   	push   %eax
  800e6d:	56                   	push   %esi
  800e6e:	e8 0c 03 00 00       	call   80117f <strnlen>
  800e73:	83 c4 10             	add    $0x10,%esp
  800e76:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800e79:	eb 16                	jmp    800e91 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800e7b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	50                   	push   %eax
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	ff d0                	call   *%eax
  800e8b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800e91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e95:	7f e4                	jg     800e7b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e97:	eb 34                	jmp    800ecd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e99:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e9d:	74 1c                	je     800ebb <vprintfmt+0x207>
  800e9f:	83 fb 1f             	cmp    $0x1f,%ebx
  800ea2:	7e 05                	jle    800ea9 <vprintfmt+0x1f5>
  800ea4:	83 fb 7e             	cmp    $0x7e,%ebx
  800ea7:	7e 12                	jle    800ebb <vprintfmt+0x207>
					putch('?', putdat);
  800ea9:	83 ec 08             	sub    $0x8,%esp
  800eac:	ff 75 0c             	pushl  0xc(%ebp)
  800eaf:	6a 3f                	push   $0x3f
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	ff d0                	call   *%eax
  800eb6:	83 c4 10             	add    $0x10,%esp
  800eb9:	eb 0f                	jmp    800eca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800ebb:	83 ec 08             	sub    $0x8,%esp
  800ebe:	ff 75 0c             	pushl  0xc(%ebp)
  800ec1:	53                   	push   %ebx
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	ff d0                	call   *%eax
  800ec7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800eca:	ff 4d e4             	decl   -0x1c(%ebp)
  800ecd:	89 f0                	mov    %esi,%eax
  800ecf:	8d 70 01             	lea    0x1(%eax),%esi
  800ed2:	8a 00                	mov    (%eax),%al
  800ed4:	0f be d8             	movsbl %al,%ebx
  800ed7:	85 db                	test   %ebx,%ebx
  800ed9:	74 24                	je     800eff <vprintfmt+0x24b>
  800edb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800edf:	78 b8                	js     800e99 <vprintfmt+0x1e5>
  800ee1:	ff 4d e0             	decl   -0x20(%ebp)
  800ee4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ee8:	79 af                	jns    800e99 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800eea:	eb 13                	jmp    800eff <vprintfmt+0x24b>
				putch(' ', putdat);
  800eec:	83 ec 08             	sub    $0x8,%esp
  800eef:	ff 75 0c             	pushl  0xc(%ebp)
  800ef2:	6a 20                	push   $0x20
  800ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef7:	ff d0                	call   *%eax
  800ef9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800efc:	ff 4d e4             	decl   -0x1c(%ebp)
  800eff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f03:	7f e7                	jg     800eec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f05:	e9 66 01 00 00       	jmp    801070 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f0a:	83 ec 08             	sub    $0x8,%esp
  800f0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800f10:	8d 45 14             	lea    0x14(%ebp),%eax
  800f13:	50                   	push   %eax
  800f14:	e8 3c fd ff ff       	call   800c55 <getint>
  800f19:	83 c4 10             	add    $0x10,%esp
  800f1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f28:	85 d2                	test   %edx,%edx
  800f2a:	79 23                	jns    800f4f <vprintfmt+0x29b>
				putch('-', putdat);
  800f2c:	83 ec 08             	sub    $0x8,%esp
  800f2f:	ff 75 0c             	pushl  0xc(%ebp)
  800f32:	6a 2d                	push   $0x2d
  800f34:	8b 45 08             	mov    0x8(%ebp),%eax
  800f37:	ff d0                	call   *%eax
  800f39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800f3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f42:	f7 d8                	neg    %eax
  800f44:	83 d2 00             	adc    $0x0,%edx
  800f47:	f7 da                	neg    %edx
  800f49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800f4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f56:	e9 bc 00 00 00       	jmp    801017 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800f5b:	83 ec 08             	sub    $0x8,%esp
  800f5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800f61:	8d 45 14             	lea    0x14(%ebp),%eax
  800f64:	50                   	push   %eax
  800f65:	e8 84 fc ff ff       	call   800bee <getuint>
  800f6a:	83 c4 10             	add    $0x10,%esp
  800f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800f73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800f7a:	e9 98 00 00 00       	jmp    801017 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800f7f:	83 ec 08             	sub    $0x8,%esp
  800f82:	ff 75 0c             	pushl  0xc(%ebp)
  800f85:	6a 58                	push   $0x58
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	ff d0                	call   *%eax
  800f8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f8f:	83 ec 08             	sub    $0x8,%esp
  800f92:	ff 75 0c             	pushl  0xc(%ebp)
  800f95:	6a 58                	push   $0x58
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	ff d0                	call   *%eax
  800f9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f9f:	83 ec 08             	sub    $0x8,%esp
  800fa2:	ff 75 0c             	pushl  0xc(%ebp)
  800fa5:	6a 58                	push   $0x58
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	ff d0                	call   *%eax
  800fac:	83 c4 10             	add    $0x10,%esp
			break;
  800faf:	e9 bc 00 00 00       	jmp    801070 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800fb4:	83 ec 08             	sub    $0x8,%esp
  800fb7:	ff 75 0c             	pushl  0xc(%ebp)
  800fba:	6a 30                	push   $0x30
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	ff d0                	call   *%eax
  800fc1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800fc4:	83 ec 08             	sub    $0x8,%esp
  800fc7:	ff 75 0c             	pushl  0xc(%ebp)
  800fca:	6a 78                	push   $0x78
  800fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcf:	ff d0                	call   *%eax
  800fd1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800fd4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd7:	83 c0 04             	add    $0x4,%eax
  800fda:	89 45 14             	mov    %eax,0x14(%ebp)
  800fdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe0:	83 e8 04             	sub    $0x4,%eax
  800fe3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800fef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ff6:	eb 1f                	jmp    801017 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ff8:	83 ec 08             	sub    $0x8,%esp
  800ffb:	ff 75 e8             	pushl  -0x18(%ebp)
  800ffe:	8d 45 14             	lea    0x14(%ebp),%eax
  801001:	50                   	push   %eax
  801002:	e8 e7 fb ff ff       	call   800bee <getuint>
  801007:	83 c4 10             	add    $0x10,%esp
  80100a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80100d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801010:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801017:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80101b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80101e:	83 ec 04             	sub    $0x4,%esp
  801021:	52                   	push   %edx
  801022:	ff 75 e4             	pushl  -0x1c(%ebp)
  801025:	50                   	push   %eax
  801026:	ff 75 f4             	pushl  -0xc(%ebp)
  801029:	ff 75 f0             	pushl  -0x10(%ebp)
  80102c:	ff 75 0c             	pushl  0xc(%ebp)
  80102f:	ff 75 08             	pushl  0x8(%ebp)
  801032:	e8 00 fb ff ff       	call   800b37 <printnum>
  801037:	83 c4 20             	add    $0x20,%esp
			break;
  80103a:	eb 34                	jmp    801070 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80103c:	83 ec 08             	sub    $0x8,%esp
  80103f:	ff 75 0c             	pushl  0xc(%ebp)
  801042:	53                   	push   %ebx
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	ff d0                	call   *%eax
  801048:	83 c4 10             	add    $0x10,%esp
			break;
  80104b:	eb 23                	jmp    801070 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80104d:	83 ec 08             	sub    $0x8,%esp
  801050:	ff 75 0c             	pushl  0xc(%ebp)
  801053:	6a 25                	push   $0x25
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	ff d0                	call   *%eax
  80105a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80105d:	ff 4d 10             	decl   0x10(%ebp)
  801060:	eb 03                	jmp    801065 <vprintfmt+0x3b1>
  801062:	ff 4d 10             	decl   0x10(%ebp)
  801065:	8b 45 10             	mov    0x10(%ebp),%eax
  801068:	48                   	dec    %eax
  801069:	8a 00                	mov    (%eax),%al
  80106b:	3c 25                	cmp    $0x25,%al
  80106d:	75 f3                	jne    801062 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  80106f:	90                   	nop
		}
	}
  801070:	e9 47 fc ff ff       	jmp    800cbc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801075:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801076:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801079:	5b                   	pop    %ebx
  80107a:	5e                   	pop    %esi
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801083:	8d 45 10             	lea    0x10(%ebp),%eax
  801086:	83 c0 04             	add    $0x4,%eax
  801089:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80108c:	8b 45 10             	mov    0x10(%ebp),%eax
  80108f:	ff 75 f4             	pushl  -0xc(%ebp)
  801092:	50                   	push   %eax
  801093:	ff 75 0c             	pushl  0xc(%ebp)
  801096:	ff 75 08             	pushl  0x8(%ebp)
  801099:	e8 16 fc ff ff       	call   800cb4 <vprintfmt>
  80109e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  8010a1:	90                   	nop
  8010a2:	c9                   	leave  
  8010a3:	c3                   	ret    

008010a4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8010a4:	55                   	push   %ebp
  8010a5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  8010a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010aa:	8b 40 08             	mov    0x8(%eax),%eax
  8010ad:	8d 50 01             	lea    0x1(%eax),%edx
  8010b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  8010b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b9:	8b 10                	mov    (%eax),%edx
  8010bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010be:	8b 40 04             	mov    0x4(%eax),%eax
  8010c1:	39 c2                	cmp    %eax,%edx
  8010c3:	73 12                	jae    8010d7 <sprintputch+0x33>
		*b->buf++ = ch;
  8010c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c8:	8b 00                	mov    (%eax),%eax
  8010ca:	8d 48 01             	lea    0x1(%eax),%ecx
  8010cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d0:	89 0a                	mov    %ecx,(%edx)
  8010d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d5:	88 10                	mov    %dl,(%eax)
}
  8010d7:	90                   	nop
  8010d8:	5d                   	pop    %ebp
  8010d9:	c3                   	ret    

008010da <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8010da:	55                   	push   %ebp
  8010db:	89 e5                	mov    %esp,%ebp
  8010dd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ef:	01 d0                	add    %edx,%eax
  8010f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8010fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010ff:	74 06                	je     801107 <vsnprintf+0x2d>
  801101:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801105:	7f 07                	jg     80110e <vsnprintf+0x34>
		return -E_INVAL;
  801107:	b8 03 00 00 00       	mov    $0x3,%eax
  80110c:	eb 20                	jmp    80112e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80110e:	ff 75 14             	pushl  0x14(%ebp)
  801111:	ff 75 10             	pushl  0x10(%ebp)
  801114:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801117:	50                   	push   %eax
  801118:	68 a4 10 80 00       	push   $0x8010a4
  80111d:	e8 92 fb ff ff       	call   800cb4 <vprintfmt>
  801122:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801125:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801128:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80112b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80112e:	c9                   	leave  
  80112f:	c3                   	ret    

00801130 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801136:	8d 45 10             	lea    0x10(%ebp),%eax
  801139:	83 c0 04             	add    $0x4,%eax
  80113c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80113f:	8b 45 10             	mov    0x10(%ebp),%eax
  801142:	ff 75 f4             	pushl  -0xc(%ebp)
  801145:	50                   	push   %eax
  801146:	ff 75 0c             	pushl  0xc(%ebp)
  801149:	ff 75 08             	pushl  0x8(%ebp)
  80114c:	e8 89 ff ff ff       	call   8010da <vsnprintf>
  801151:	83 c4 10             	add    $0x10,%esp
  801154:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801157:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80115a:	c9                   	leave  
  80115b:	c3                   	ret    

0080115c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801162:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801169:	eb 06                	jmp    801171 <strlen+0x15>
		n++;
  80116b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80116e:	ff 45 08             	incl   0x8(%ebp)
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8a 00                	mov    (%eax),%al
  801176:	84 c0                	test   %al,%al
  801178:	75 f1                	jne    80116b <strlen+0xf>
		n++;
	return n;
  80117a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80117d:	c9                   	leave  
  80117e:	c3                   	ret    

0080117f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801185:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80118c:	eb 09                	jmp    801197 <strnlen+0x18>
		n++;
  80118e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801191:	ff 45 08             	incl   0x8(%ebp)
  801194:	ff 4d 0c             	decl   0xc(%ebp)
  801197:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80119b:	74 09                	je     8011a6 <strnlen+0x27>
  80119d:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a0:	8a 00                	mov    (%eax),%al
  8011a2:	84 c0                	test   %al,%al
  8011a4:	75 e8                	jne    80118e <strnlen+0xf>
		n++;
	return n;
  8011a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    

008011ab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8011ab:	55                   	push   %ebp
  8011ac:	89 e5                	mov    %esp,%ebp
  8011ae:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8011b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8011b7:	90                   	nop
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	8d 50 01             	lea    0x1(%eax),%edx
  8011be:	89 55 08             	mov    %edx,0x8(%ebp)
  8011c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011c7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011ca:	8a 12                	mov    (%edx),%dl
  8011cc:	88 10                	mov    %dl,(%eax)
  8011ce:	8a 00                	mov    (%eax),%al
  8011d0:	84 c0                	test   %al,%al
  8011d2:	75 e4                	jne    8011b8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8011d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8011e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ec:	eb 1f                	jmp    80120d <strncpy+0x34>
		*dst++ = *src;
  8011ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f1:	8d 50 01             	lea    0x1(%eax),%edx
  8011f4:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011fa:	8a 12                	mov    (%edx),%dl
  8011fc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	8a 00                	mov    (%eax),%al
  801203:	84 c0                	test   %al,%al
  801205:	74 03                	je     80120a <strncpy+0x31>
			src++;
  801207:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80120a:	ff 45 fc             	incl   -0x4(%ebp)
  80120d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801210:	3b 45 10             	cmp    0x10(%ebp),%eax
  801213:	72 d9                	jb     8011ee <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801215:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801218:	c9                   	leave  
  801219:	c3                   	ret    

0080121a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801220:	8b 45 08             	mov    0x8(%ebp),%eax
  801223:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801226:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80122a:	74 30                	je     80125c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80122c:	eb 16                	jmp    801244 <strlcpy+0x2a>
			*dst++ = *src++;
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	8d 50 01             	lea    0x1(%eax),%edx
  801234:	89 55 08             	mov    %edx,0x8(%ebp)
  801237:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80123d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801240:	8a 12                	mov    (%edx),%dl
  801242:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801244:	ff 4d 10             	decl   0x10(%ebp)
  801247:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80124b:	74 09                	je     801256 <strlcpy+0x3c>
  80124d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	84 c0                	test   %al,%al
  801254:	75 d8                	jne    80122e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80125c:	8b 55 08             	mov    0x8(%ebp),%edx
  80125f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801262:	29 c2                	sub    %eax,%edx
  801264:	89 d0                	mov    %edx,%eax
}
  801266:	c9                   	leave  
  801267:	c3                   	ret    

00801268 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80126b:	eb 06                	jmp    801273 <strcmp+0xb>
		p++, q++;
  80126d:	ff 45 08             	incl   0x8(%ebp)
  801270:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	84 c0                	test   %al,%al
  80127a:	74 0e                	je     80128a <strcmp+0x22>
  80127c:	8b 45 08             	mov    0x8(%ebp),%eax
  80127f:	8a 10                	mov    (%eax),%dl
  801281:	8b 45 0c             	mov    0xc(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	38 c2                	cmp    %al,%dl
  801288:	74 e3                	je     80126d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	0f b6 d0             	movzbl %al,%edx
  801292:	8b 45 0c             	mov    0xc(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f b6 c0             	movzbl %al,%eax
  80129a:	29 c2                	sub    %eax,%edx
  80129c:	89 d0                	mov    %edx,%eax
}
  80129e:	5d                   	pop    %ebp
  80129f:	c3                   	ret    

008012a0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8012a3:	eb 09                	jmp    8012ae <strncmp+0xe>
		n--, p++, q++;
  8012a5:	ff 4d 10             	decl   0x10(%ebp)
  8012a8:	ff 45 08             	incl   0x8(%ebp)
  8012ab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8012ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012b2:	74 17                	je     8012cb <strncmp+0x2b>
  8012b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	84 c0                	test   %al,%al
  8012bb:	74 0e                	je     8012cb <strncmp+0x2b>
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	8a 10                	mov    (%eax),%dl
  8012c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c5:	8a 00                	mov    (%eax),%al
  8012c7:	38 c2                	cmp    %al,%dl
  8012c9:	74 da                	je     8012a5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8012cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8012cf:	75 07                	jne    8012d8 <strncmp+0x38>
		return 0;
  8012d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8012d6:	eb 14                	jmp    8012ec <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	0f b6 d0             	movzbl %al,%edx
  8012e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e3:	8a 00                	mov    (%eax),%al
  8012e5:	0f b6 c0             	movzbl %al,%eax
  8012e8:	29 c2                	sub    %eax,%edx
  8012ea:	89 d0                	mov    %edx,%eax
}
  8012ec:	5d                   	pop    %ebp
  8012ed:	c3                   	ret    

008012ee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 04             	sub    $0x4,%esp
  8012f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8012fa:	eb 12                	jmp    80130e <strchr+0x20>
		if (*s == c)
  8012fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801304:	75 05                	jne    80130b <strchr+0x1d>
			return (char *) s;
  801306:	8b 45 08             	mov    0x8(%ebp),%eax
  801309:	eb 11                	jmp    80131c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80130b:	ff 45 08             	incl   0x8(%ebp)
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	75 e5                	jne    8012fc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801317:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131c:	c9                   	leave  
  80131d:	c3                   	ret    

0080131e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 04             	sub    $0x4,%esp
  801324:	8b 45 0c             	mov    0xc(%ebp),%eax
  801327:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80132a:	eb 0d                	jmp    801339 <strfind+0x1b>
		if (*s == c)
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8a 00                	mov    (%eax),%al
  801331:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801334:	74 0e                	je     801344 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801336:	ff 45 08             	incl   0x8(%ebp)
  801339:	8b 45 08             	mov    0x8(%ebp),%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	84 c0                	test   %al,%al
  801340:	75 ea                	jne    80132c <strfind+0xe>
  801342:	eb 01                	jmp    801345 <strfind+0x27>
		if (*s == c)
			break;
  801344:	90                   	nop
	return (char *) s;
  801345:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801356:	8b 45 10             	mov    0x10(%ebp),%eax
  801359:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80135c:	eb 0e                	jmp    80136c <memset+0x22>
		*p++ = c;
  80135e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801361:	8d 50 01             	lea    0x1(%eax),%edx
  801364:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80136a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80136c:	ff 4d f8             	decl   -0x8(%ebp)
  80136f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801373:	79 e9                	jns    80135e <memset+0x14>
		*p++ = c;

	return v;
  801375:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801378:	c9                   	leave  
  801379:	c3                   	ret    

0080137a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
  80137d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801380:	8b 45 0c             	mov    0xc(%ebp),%eax
  801383:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801386:	8b 45 08             	mov    0x8(%ebp),%eax
  801389:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80138c:	eb 16                	jmp    8013a4 <memcpy+0x2a>
		*d++ = *s++;
  80138e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801391:	8d 50 01             	lea    0x1(%eax),%edx
  801394:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801397:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80139a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80139d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8013a0:	8a 12                	mov    (%edx),%dl
  8013a2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8013a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a7:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013aa:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	75 dd                	jne    80138e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8013b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8013bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8013c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013ce:	73 50                	jae    801420 <memmove+0x6a>
  8013d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d6:	01 d0                	add    %edx,%eax
  8013d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8013db:	76 43                	jbe    801420 <memmove+0x6a>
		s += n;
  8013dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8013e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8013e9:	eb 10                	jmp    8013fb <memmove+0x45>
			*--d = *--s;
  8013eb:	ff 4d f8             	decl   -0x8(%ebp)
  8013ee:	ff 4d fc             	decl   -0x4(%ebp)
  8013f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f4:	8a 10                	mov    (%eax),%dl
  8013f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013f9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8013fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8013fe:	8d 50 ff             	lea    -0x1(%eax),%edx
  801401:	89 55 10             	mov    %edx,0x10(%ebp)
  801404:	85 c0                	test   %eax,%eax
  801406:	75 e3                	jne    8013eb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801408:	eb 23                	jmp    80142d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80140a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140d:	8d 50 01             	lea    0x1(%eax),%edx
  801410:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801413:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801416:	8d 4a 01             	lea    0x1(%edx),%ecx
  801419:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80141c:	8a 12                	mov    (%edx),%dl
  80141e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801420:	8b 45 10             	mov    0x10(%ebp),%eax
  801423:	8d 50 ff             	lea    -0x1(%eax),%edx
  801426:	89 55 10             	mov    %edx,0x10(%ebp)
  801429:	85 c0                	test   %eax,%eax
  80142b:	75 dd                	jne    80140a <memmove+0x54>
			*d++ = *s++;

	return dst;
  80142d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801430:	c9                   	leave  
  801431:	c3                   	ret    

00801432 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80143e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801441:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801444:	eb 2a                	jmp    801470 <memcmp+0x3e>
		if (*s1 != *s2)
  801446:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801449:	8a 10                	mov    (%eax),%dl
  80144b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	38 c2                	cmp    %al,%dl
  801452:	74 16                	je     80146a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801454:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	0f b6 d0             	movzbl %al,%edx
  80145c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	0f b6 c0             	movzbl %al,%eax
  801464:	29 c2                	sub    %eax,%edx
  801466:	89 d0                	mov    %edx,%eax
  801468:	eb 18                	jmp    801482 <memcmp+0x50>
		s1++, s2++;
  80146a:	ff 45 fc             	incl   -0x4(%ebp)
  80146d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	8d 50 ff             	lea    -0x1(%eax),%edx
  801476:	89 55 10             	mov    %edx,0x10(%ebp)
  801479:	85 c0                	test   %eax,%eax
  80147b:	75 c9                	jne    801446 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80147d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801482:	c9                   	leave  
  801483:	c3                   	ret    

00801484 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801484:	55                   	push   %ebp
  801485:	89 e5                	mov    %esp,%ebp
  801487:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80148a:	8b 55 08             	mov    0x8(%ebp),%edx
  80148d:	8b 45 10             	mov    0x10(%ebp),%eax
  801490:	01 d0                	add    %edx,%eax
  801492:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801495:	eb 15                	jmp    8014ac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801497:	8b 45 08             	mov    0x8(%ebp),%eax
  80149a:	8a 00                	mov    (%eax),%al
  80149c:	0f b6 d0             	movzbl %al,%edx
  80149f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a2:	0f b6 c0             	movzbl %al,%eax
  8014a5:	39 c2                	cmp    %eax,%edx
  8014a7:	74 0d                	je     8014b6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8014a9:	ff 45 08             	incl   0x8(%ebp)
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8014b2:	72 e3                	jb     801497 <memfind+0x13>
  8014b4:	eb 01                	jmp    8014b7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8014b6:	90                   	nop
	return (void *) s;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8014c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8014c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d0:	eb 03                	jmp    8014d5 <strtol+0x19>
		s++;
  8014d2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8a 00                	mov    (%eax),%al
  8014da:	3c 20                	cmp    $0x20,%al
  8014dc:	74 f4                	je     8014d2 <strtol+0x16>
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	3c 09                	cmp    $0x9,%al
  8014e5:	74 eb                	je     8014d2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8a 00                	mov    (%eax),%al
  8014ec:	3c 2b                	cmp    $0x2b,%al
  8014ee:	75 05                	jne    8014f5 <strtol+0x39>
		s++;
  8014f0:	ff 45 08             	incl   0x8(%ebp)
  8014f3:	eb 13                	jmp    801508 <strtol+0x4c>
	else if (*s == '-')
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f8:	8a 00                	mov    (%eax),%al
  8014fa:	3c 2d                	cmp    $0x2d,%al
  8014fc:	75 0a                	jne    801508 <strtol+0x4c>
		s++, neg = 1;
  8014fe:	ff 45 08             	incl   0x8(%ebp)
  801501:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801508:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150c:	74 06                	je     801514 <strtol+0x58>
  80150e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801512:	75 20                	jne    801534 <strtol+0x78>
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	8a 00                	mov    (%eax),%al
  801519:	3c 30                	cmp    $0x30,%al
  80151b:	75 17                	jne    801534 <strtol+0x78>
  80151d:	8b 45 08             	mov    0x8(%ebp),%eax
  801520:	40                   	inc    %eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	3c 78                	cmp    $0x78,%al
  801525:	75 0d                	jne    801534 <strtol+0x78>
		s += 2, base = 16;
  801527:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80152b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801532:	eb 28                	jmp    80155c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801534:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801538:	75 15                	jne    80154f <strtol+0x93>
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 00                	mov    (%eax),%al
  80153f:	3c 30                	cmp    $0x30,%al
  801541:	75 0c                	jne    80154f <strtol+0x93>
		s++, base = 8;
  801543:	ff 45 08             	incl   0x8(%ebp)
  801546:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80154d:	eb 0d                	jmp    80155c <strtol+0xa0>
	else if (base == 0)
  80154f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801553:	75 07                	jne    80155c <strtol+0xa0>
		base = 10;
  801555:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80155c:	8b 45 08             	mov    0x8(%ebp),%eax
  80155f:	8a 00                	mov    (%eax),%al
  801561:	3c 2f                	cmp    $0x2f,%al
  801563:	7e 19                	jle    80157e <strtol+0xc2>
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	8a 00                	mov    (%eax),%al
  80156a:	3c 39                	cmp    $0x39,%al
  80156c:	7f 10                	jg     80157e <strtol+0xc2>
			dig = *s - '0';
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	0f be c0             	movsbl %al,%eax
  801576:	83 e8 30             	sub    $0x30,%eax
  801579:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80157c:	eb 42                	jmp    8015c0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	8a 00                	mov    (%eax),%al
  801583:	3c 60                	cmp    $0x60,%al
  801585:	7e 19                	jle    8015a0 <strtol+0xe4>
  801587:	8b 45 08             	mov    0x8(%ebp),%eax
  80158a:	8a 00                	mov    (%eax),%al
  80158c:	3c 7a                	cmp    $0x7a,%al
  80158e:	7f 10                	jg     8015a0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801590:	8b 45 08             	mov    0x8(%ebp),%eax
  801593:	8a 00                	mov    (%eax),%al
  801595:	0f be c0             	movsbl %al,%eax
  801598:	83 e8 57             	sub    $0x57,%eax
  80159b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80159e:	eb 20                	jmp    8015c0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	8a 00                	mov    (%eax),%al
  8015a5:	3c 40                	cmp    $0x40,%al
  8015a7:	7e 39                	jle    8015e2 <strtol+0x126>
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	3c 5a                	cmp    $0x5a,%al
  8015b0:	7f 30                	jg     8015e2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	8a 00                	mov    (%eax),%al
  8015b7:	0f be c0             	movsbl %al,%eax
  8015ba:	83 e8 37             	sub    $0x37,%eax
  8015bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8015c6:	7d 19                	jge    8015e1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8015c8:	ff 45 08             	incl   0x8(%ebp)
  8015cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8015d2:	89 c2                	mov    %eax,%edx
  8015d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d7:	01 d0                	add    %edx,%eax
  8015d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8015dc:	e9 7b ff ff ff       	jmp    80155c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8015e1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8015e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015e6:	74 08                	je     8015f0 <strtol+0x134>
		*endptr = (char *) s;
  8015e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8015ee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8015f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8015f4:	74 07                	je     8015fd <strtol+0x141>
  8015f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015f9:	f7 d8                	neg    %eax
  8015fb:	eb 03                	jmp    801600 <strtol+0x144>
  8015fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <ltostr>:

void
ltostr(long value, char *str)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801608:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80160f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801616:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80161a:	79 13                	jns    80162f <ltostr+0x2d>
	{
		neg = 1;
  80161c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801623:	8b 45 0c             	mov    0xc(%ebp),%eax
  801626:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801629:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80162c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801637:	99                   	cltd   
  801638:	f7 f9                	idiv   %ecx
  80163a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80163d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801640:	8d 50 01             	lea    0x1(%eax),%edx
  801643:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801646:	89 c2                	mov    %eax,%edx
  801648:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164b:	01 d0                	add    %edx,%eax
  80164d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801650:	83 c2 30             	add    $0x30,%edx
  801653:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801655:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801658:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80165d:	f7 e9                	imul   %ecx
  80165f:	c1 fa 02             	sar    $0x2,%edx
  801662:	89 c8                	mov    %ecx,%eax
  801664:	c1 f8 1f             	sar    $0x1f,%eax
  801667:	29 c2                	sub    %eax,%edx
  801669:	89 d0                	mov    %edx,%eax
  80166b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80166e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801671:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801676:	f7 e9                	imul   %ecx
  801678:	c1 fa 02             	sar    $0x2,%edx
  80167b:	89 c8                	mov    %ecx,%eax
  80167d:	c1 f8 1f             	sar    $0x1f,%eax
  801680:	29 c2                	sub    %eax,%edx
  801682:	89 d0                	mov    %edx,%eax
  801684:	c1 e0 02             	shl    $0x2,%eax
  801687:	01 d0                	add    %edx,%eax
  801689:	01 c0                	add    %eax,%eax
  80168b:	29 c1                	sub    %eax,%ecx
  80168d:	89 ca                	mov    %ecx,%edx
  80168f:	85 d2                	test   %edx,%edx
  801691:	75 9c                	jne    80162f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801693:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80169a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80169d:	48                   	dec    %eax
  80169e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8016a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016a5:	74 3d                	je     8016e4 <ltostr+0xe2>
		start = 1 ;
  8016a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8016ae:	eb 34                	jmp    8016e4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8016b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	01 d0                	add    %edx,%eax
  8016b8:	8a 00                	mov    (%eax),%al
  8016ba:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8016bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c3:	01 c2                	add    %eax,%edx
  8016c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8016c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cb:	01 c8                	add    %ecx,%eax
  8016cd:	8a 00                	mov    (%eax),%al
  8016cf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8016d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d7:	01 c2                	add    %eax,%edx
  8016d9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8016dc:	88 02                	mov    %al,(%edx)
		start++ ;
  8016de:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8016e1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8016e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016ea:	7c c4                	jl     8016b0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8016ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8016ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f2:	01 d0                	add    %edx,%eax
  8016f4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8016f7:	90                   	nop
  8016f8:	c9                   	leave  
  8016f9:	c3                   	ret    

008016fa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8016fa:	55                   	push   %ebp
  8016fb:	89 e5                	mov    %esp,%ebp
  8016fd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801700:	ff 75 08             	pushl  0x8(%ebp)
  801703:	e8 54 fa ff ff       	call   80115c <strlen>
  801708:	83 c4 04             	add    $0x4,%esp
  80170b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80170e:	ff 75 0c             	pushl  0xc(%ebp)
  801711:	e8 46 fa ff ff       	call   80115c <strlen>
  801716:	83 c4 04             	add    $0x4,%esp
  801719:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80171c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801723:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80172a:	eb 17                	jmp    801743 <strcconcat+0x49>
		final[s] = str1[s] ;
  80172c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80172f:	8b 45 10             	mov    0x10(%ebp),%eax
  801732:	01 c2                	add    %eax,%edx
  801734:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801737:	8b 45 08             	mov    0x8(%ebp),%eax
  80173a:	01 c8                	add    %ecx,%eax
  80173c:	8a 00                	mov    (%eax),%al
  80173e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801740:	ff 45 fc             	incl   -0x4(%ebp)
  801743:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801746:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801749:	7c e1                	jl     80172c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80174b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801752:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801759:	eb 1f                	jmp    80177a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80175b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80175e:	8d 50 01             	lea    0x1(%eax),%edx
  801761:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801764:	89 c2                	mov    %eax,%edx
  801766:	8b 45 10             	mov    0x10(%ebp),%eax
  801769:	01 c2                	add    %eax,%edx
  80176b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80176e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801771:	01 c8                	add    %ecx,%eax
  801773:	8a 00                	mov    (%eax),%al
  801775:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801777:	ff 45 f8             	incl   -0x8(%ebp)
  80177a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801780:	7c d9                	jl     80175b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801782:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 d0                	add    %edx,%eax
  80178a:	c6 00 00             	movb   $0x0,(%eax)
}
  80178d:	90                   	nop
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801793:	8b 45 14             	mov    0x14(%ebp),%eax
  801796:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80179c:	8b 45 14             	mov    0x14(%ebp),%eax
  80179f:	8b 00                	mov    (%eax),%eax
  8017a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ab:	01 d0                	add    %edx,%eax
  8017ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017b3:	eb 0c                	jmp    8017c1 <strsplit+0x31>
			*string++ = 0;
  8017b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b8:	8d 50 01             	lea    0x1(%eax),%edx
  8017bb:	89 55 08             	mov    %edx,0x8(%ebp)
  8017be:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8a 00                	mov    (%eax),%al
  8017c6:	84 c0                	test   %al,%al
  8017c8:	74 18                	je     8017e2 <strsplit+0x52>
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	8a 00                	mov    (%eax),%al
  8017cf:	0f be c0             	movsbl %al,%eax
  8017d2:	50                   	push   %eax
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	e8 13 fb ff ff       	call   8012ee <strchr>
  8017db:	83 c4 08             	add    $0x8,%esp
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	75 d3                	jne    8017b5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	84 c0                	test   %al,%al
  8017e9:	74 5a                	je     801845 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8017eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ee:	8b 00                	mov    (%eax),%eax
  8017f0:	83 f8 0f             	cmp    $0xf,%eax
  8017f3:	75 07                	jne    8017fc <strsplit+0x6c>
		{
			return 0;
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fa:	eb 66                	jmp    801862 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8017fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ff:	8b 00                	mov    (%eax),%eax
  801801:	8d 48 01             	lea    0x1(%eax),%ecx
  801804:	8b 55 14             	mov    0x14(%ebp),%edx
  801807:	89 0a                	mov    %ecx,(%edx)
  801809:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801810:	8b 45 10             	mov    0x10(%ebp),%eax
  801813:	01 c2                	add    %eax,%edx
  801815:	8b 45 08             	mov    0x8(%ebp),%eax
  801818:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80181a:	eb 03                	jmp    80181f <strsplit+0x8f>
			string++;
  80181c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	8a 00                	mov    (%eax),%al
  801824:	84 c0                	test   %al,%al
  801826:	74 8b                	je     8017b3 <strsplit+0x23>
  801828:	8b 45 08             	mov    0x8(%ebp),%eax
  80182b:	8a 00                	mov    (%eax),%al
  80182d:	0f be c0             	movsbl %al,%eax
  801830:	50                   	push   %eax
  801831:	ff 75 0c             	pushl  0xc(%ebp)
  801834:	e8 b5 fa ff ff       	call   8012ee <strchr>
  801839:	83 c4 08             	add    $0x8,%esp
  80183c:	85 c0                	test   %eax,%eax
  80183e:	74 dc                	je     80181c <strsplit+0x8c>
			string++;
	}
  801840:	e9 6e ff ff ff       	jmp    8017b3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801845:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801846:	8b 45 14             	mov    0x14(%ebp),%eax
  801849:	8b 00                	mov    (%eax),%eax
  80184b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	01 d0                	add    %edx,%eax
  801857:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80185d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801862:	c9                   	leave  
  801863:	c3                   	ret    

00801864 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  80186a:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801871:	8b 55 08             	mov    0x8(%ebp),%edx
  801874:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801877:	01 d0                	add    %edx,%eax
  801879:	48                   	dec    %eax
  80187a:	89 45 a8             	mov    %eax,-0x58(%ebp)
  80187d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801880:	ba 00 00 00 00       	mov    $0x0,%edx
  801885:	f7 75 ac             	divl   -0x54(%ebp)
  801888:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80188b:	29 d0                	sub    %edx,%eax
  80188d:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801890:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801897:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  80189e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  8018a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8018ac:	eb 3f                	jmp    8018ed <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  8018ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018b1:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	50                   	push   %eax
  8018bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8018bf:	68 b0 2e 80 00       	push   $0x802eb0
  8018c4:	e8 11 f2 ff ff       	call   800ada <cprintf>
  8018c9:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  8018cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018cf:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  8018d6:	83 ec 04             	sub    $0x4,%esp
  8018d9:	50                   	push   %eax
  8018da:	ff 75 e8             	pushl  -0x18(%ebp)
  8018dd:	68 c5 2e 80 00       	push   $0x802ec5
  8018e2:	e8 f3 f1 ff ff       	call   800ada <cprintf>
  8018e7:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  8018ea:	ff 45 e8             	incl   -0x18(%ebp)
  8018ed:	a1 28 30 80 00       	mov    0x803028,%eax
  8018f2:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  8018f5:	7c b7                	jl     8018ae <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  8018f7:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  8018fe:	e9 42 01 00 00       	jmp    801a45 <malloc+0x1e1>
		int flag0=1;
  801903:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  80190a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80190d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801910:	eb 6b                	jmp    80197d <malloc+0x119>
			for(int k=0;k<count;k++){
  801912:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801919:	eb 42                	jmp    80195d <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  80191b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80191e:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801925:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801928:	39 c2                	cmp    %eax,%edx
  80192a:	77 2e                	ja     80195a <malloc+0xf6>
  80192c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80192f:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801936:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801939:	39 c2                	cmp    %eax,%edx
  80193b:	76 1d                	jbe    80195a <malloc+0xf6>
					ni=arr_add[k].end-i;
  80193d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801940:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801947:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80194a:	29 c2                	sub    %eax,%edx
  80194c:	89 d0                	mov    %edx,%eax
  80194e:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801951:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801958:	eb 0d                	jmp    801967 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  80195a:	ff 45 d8             	incl   -0x28(%ebp)
  80195d:	a1 28 30 80 00       	mov    0x803028,%eax
  801962:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801965:	7c b4                	jl     80191b <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801967:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80196b:	74 09                	je     801976 <malloc+0x112>
				flag0=0;
  80196d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801974:	eb 16                	jmp    80198c <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801976:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  80197d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801980:	8b 45 08             	mov    0x8(%ebp),%eax
  801983:	01 c2                	add    %eax,%edx
  801985:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801988:	39 c2                	cmp    %eax,%edx
  80198a:	77 86                	ja     801912 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  80198c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801990:	0f 84 a2 00 00 00    	je     801a38 <malloc+0x1d4>

			int f=1;
  801996:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  80199d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019a0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8019a3:	89 c8                	mov    %ecx,%eax
  8019a5:	01 c0                	add    %eax,%eax
  8019a7:	01 c8                	add    %ecx,%eax
  8019a9:	c1 e0 02             	shl    $0x2,%eax
  8019ac:	05 20 31 80 00       	add    $0x803120,%eax
  8019b1:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  8019b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8019bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019bf:	89 d0                	mov    %edx,%eax
  8019c1:	01 c0                	add    %eax,%eax
  8019c3:	01 d0                	add    %edx,%eax
  8019c5:	c1 e0 02             	shl    $0x2,%eax
  8019c8:	05 24 31 80 00       	add    $0x803124,%eax
  8019cd:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  8019cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019d2:	89 d0                	mov    %edx,%eax
  8019d4:	01 c0                	add    %eax,%eax
  8019d6:	01 d0                	add    %edx,%eax
  8019d8:	c1 e0 02             	shl    $0x2,%eax
  8019db:	05 28 31 80 00       	add    $0x803128,%eax
  8019e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  8019e6:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  8019e9:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8019f0:	eb 36                	jmp    801a28 <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  8019f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f8:	01 c2                	add    %eax,%edx
  8019fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8019fd:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801a04:	39 c2                	cmp    %eax,%edx
  801a06:	73 1d                	jae    801a25 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801a08:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801a0b:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a15:	29 c2                	sub    %eax,%edx
  801a17:	89 d0                	mov    %edx,%eax
  801a19:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801a1c:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801a23:	eb 0d                	jmp    801a32 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801a25:	ff 45 d0             	incl   -0x30(%ebp)
  801a28:	a1 28 30 80 00       	mov    0x803028,%eax
  801a2d:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801a30:	7c c0                	jl     8019f2 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801a32:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801a36:	75 1d                	jne    801a55 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801a38:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801a3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a42:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801a45:	a1 04 30 80 00       	mov    0x803004,%eax
  801a4a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a4d:	0f 8c b0 fe ff ff    	jl     801903 <malloc+0x9f>
  801a53:	eb 01                	jmp    801a56 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801a55:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801a5a:	75 7a                	jne    801ad6 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801a5c:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801a62:	8b 45 08             	mov    0x8(%ebp),%eax
  801a65:	01 d0                	add    %edx,%eax
  801a67:	48                   	dec    %eax
  801a68:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801a6d:	7c 0a                	jl     801a79 <malloc+0x215>
			return NULL;
  801a6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a74:	e9 a4 02 00 00       	jmp    801d1d <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801a79:	a1 04 30 80 00       	mov    0x803004,%eax
  801a7e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801a81:	a1 28 30 80 00       	mov    0x803028,%eax
  801a86:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801a89:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
		    sys_allocateMem(s,size);
  801a90:	83 ec 08             	sub    $0x8,%esp
  801a93:	ff 75 08             	pushl  0x8(%ebp)
  801a96:	ff 75 a4             	pushl  -0x5c(%ebp)
  801a99:	e8 04 06 00 00       	call   8020a2 <sys_allocateMem>
  801a9e:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801aa1:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaa:	01 d0                	add    %edx,%eax
  801aac:	a3 04 30 80 00       	mov    %eax,0x803004
			arr_add[count].end=base_add;
  801ab1:	a1 28 30 80 00       	mov    0x803028,%eax
  801ab6:	8b 15 04 30 80 00    	mov    0x803004,%edx
  801abc:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)
			count++;
  801ac3:	a1 28 30 80 00       	mov    0x803028,%eax
  801ac8:	40                   	inc    %eax
  801ac9:	a3 28 30 80 00       	mov    %eax,0x803028

			return (void*)s;
  801ace:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801ad1:	e9 47 02 00 00       	jmp    801d1d <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801ad6:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801add:	e9 ac 00 00 00       	jmp    801b8e <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801ae2:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801ae5:	89 d0                	mov    %edx,%eax
  801ae7:	01 c0                	add    %eax,%eax
  801ae9:	01 d0                	add    %edx,%eax
  801aeb:	c1 e0 02             	shl    $0x2,%eax
  801aee:	05 24 31 80 00       	add    $0x803124,%eax
  801af3:	8b 00                	mov    (%eax),%eax
  801af5:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801af8:	eb 7e                	jmp    801b78 <malloc+0x314>
			int flag=0;
  801afa:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801b01:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801b08:	eb 57                	jmp    801b61 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801b0a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b0d:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801b14:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b17:	39 c2                	cmp    %eax,%edx
  801b19:	77 1a                	ja     801b35 <malloc+0x2d1>
  801b1b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801b1e:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801b25:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801b28:	39 c2                	cmp    %eax,%edx
  801b2a:	76 09                	jbe    801b35 <malloc+0x2d1>
								flag=1;
  801b2c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801b33:	eb 36                	jmp    801b6b <malloc+0x307>
			arr[i].space++;
  801b35:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801b38:	89 d0                	mov    %edx,%eax
  801b3a:	01 c0                	add    %eax,%eax
  801b3c:	01 d0                	add    %edx,%eax
  801b3e:	c1 e0 02             	shl    $0x2,%eax
  801b41:	05 28 31 80 00       	add    $0x803128,%eax
  801b46:	8b 00                	mov    (%eax),%eax
  801b48:	8d 48 01             	lea    0x1(%eax),%ecx
  801b4b:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801b4e:	89 d0                	mov    %edx,%eax
  801b50:	01 c0                	add    %eax,%eax
  801b52:	01 d0                	add    %edx,%eax
  801b54:	c1 e0 02             	shl    $0x2,%eax
  801b57:	05 28 31 80 00       	add    $0x803128,%eax
  801b5c:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801b5e:	ff 45 c0             	incl   -0x40(%ebp)
  801b61:	a1 28 30 80 00       	mov    0x803028,%eax
  801b66:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801b69:	7c 9f                	jl     801b0a <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801b6b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801b6f:	75 19                	jne    801b8a <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801b71:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801b78:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801b7b:	a1 04 30 80 00       	mov    0x803004,%eax
  801b80:	39 c2                	cmp    %eax,%edx
  801b82:	0f 82 72 ff ff ff    	jb     801afa <malloc+0x296>
  801b88:	eb 01                	jmp    801b8b <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801b8a:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801b8b:	ff 45 cc             	incl   -0x34(%ebp)
  801b8e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801b91:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801b94:	0f 8c 48 ff ff ff    	jl     801ae2 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801b9a:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801ba1:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801ba8:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801baf:	eb 37                	jmp    801be8 <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801bb1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801bb4:	89 d0                	mov    %edx,%eax
  801bb6:	01 c0                	add    %eax,%eax
  801bb8:	01 d0                	add    %edx,%eax
  801bba:	c1 e0 02             	shl    $0x2,%eax
  801bbd:	05 28 31 80 00       	add    $0x803128,%eax
  801bc2:	8b 00                	mov    (%eax),%eax
  801bc4:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801bc7:	7d 1c                	jge    801be5 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801bc9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801bcc:	89 d0                	mov    %edx,%eax
  801bce:	01 c0                	add    %eax,%eax
  801bd0:	01 d0                	add    %edx,%eax
  801bd2:	c1 e0 02             	shl    $0x2,%eax
  801bd5:	05 28 31 80 00       	add    $0x803128,%eax
  801bda:	8b 00                	mov    (%eax),%eax
  801bdc:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801bdf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801be2:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801be5:	ff 45 b4             	incl   -0x4c(%ebp)
  801be8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801beb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801bee:	7c c1                	jl     801bb1 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801bf0:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801bf6:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801bf9:	89 c8                	mov    %ecx,%eax
  801bfb:	01 c0                	add    %eax,%eax
  801bfd:	01 c8                	add    %ecx,%eax
  801bff:	c1 e0 02             	shl    $0x2,%eax
  801c02:	05 20 31 80 00       	add    $0x803120,%eax
  801c07:	8b 00                	mov    (%eax),%eax
  801c09:	89 04 d5 e0 05 82 00 	mov    %eax,0x8205e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801c10:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801c16:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801c19:	89 c8                	mov    %ecx,%eax
  801c1b:	01 c0                	add    %eax,%eax
  801c1d:	01 c8                	add    %ecx,%eax
  801c1f:	c1 e0 02             	shl    $0x2,%eax
  801c22:	05 24 31 80 00       	add    $0x803124,%eax
  801c27:	8b 00                	mov    (%eax),%eax
  801c29:	89 04 d5 e4 05 82 00 	mov    %eax,0x8205e4(,%edx,8)
	count++;
  801c30:	a1 28 30 80 00       	mov    0x803028,%eax
  801c35:	40                   	inc    %eax
  801c36:	a3 28 30 80 00       	mov    %eax,0x803028


		sys_allocateMem(arr[index].start,size);
  801c3b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801c3e:	89 d0                	mov    %edx,%eax
  801c40:	01 c0                	add    %eax,%eax
  801c42:	01 d0                	add    %edx,%eax
  801c44:	c1 e0 02             	shl    $0x2,%eax
  801c47:	05 20 31 80 00       	add    $0x803120,%eax
  801c4c:	8b 00                	mov    (%eax),%eax
  801c4e:	83 ec 08             	sub    $0x8,%esp
  801c51:	ff 75 08             	pushl  0x8(%ebp)
  801c54:	50                   	push   %eax
  801c55:	e8 48 04 00 00       	call   8020a2 <sys_allocateMem>
  801c5a:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801c5d:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801c64:	eb 78                	jmp    801cde <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801c66:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801c69:	89 d0                	mov    %edx,%eax
  801c6b:	01 c0                	add    %eax,%eax
  801c6d:	01 d0                	add    %edx,%eax
  801c6f:	c1 e0 02             	shl    $0x2,%eax
  801c72:	05 20 31 80 00       	add    $0x803120,%eax
  801c77:	8b 00                	mov    (%eax),%eax
  801c79:	83 ec 04             	sub    $0x4,%esp
  801c7c:	50                   	push   %eax
  801c7d:	ff 75 b0             	pushl  -0x50(%ebp)
  801c80:	68 b0 2e 80 00       	push   $0x802eb0
  801c85:	e8 50 ee ff ff       	call   800ada <cprintf>
  801c8a:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801c8d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801c90:	89 d0                	mov    %edx,%eax
  801c92:	01 c0                	add    %eax,%eax
  801c94:	01 d0                	add    %edx,%eax
  801c96:	c1 e0 02             	shl    $0x2,%eax
  801c99:	05 24 31 80 00       	add    $0x803124,%eax
  801c9e:	8b 00                	mov    (%eax),%eax
  801ca0:	83 ec 04             	sub    $0x4,%esp
  801ca3:	50                   	push   %eax
  801ca4:	ff 75 b0             	pushl  -0x50(%ebp)
  801ca7:	68 c5 2e 80 00       	push   $0x802ec5
  801cac:	e8 29 ee ff ff       	call   800ada <cprintf>
  801cb1:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801cb4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801cb7:	89 d0                	mov    %edx,%eax
  801cb9:	01 c0                	add    %eax,%eax
  801cbb:	01 d0                	add    %edx,%eax
  801cbd:	c1 e0 02             	shl    $0x2,%eax
  801cc0:	05 28 31 80 00       	add    $0x803128,%eax
  801cc5:	8b 00                	mov    (%eax),%eax
  801cc7:	83 ec 04             	sub    $0x4,%esp
  801cca:	50                   	push   %eax
  801ccb:	ff 75 b0             	pushl  -0x50(%ebp)
  801cce:	68 d8 2e 80 00       	push   $0x802ed8
  801cd3:	e8 02 ee ff ff       	call   800ada <cprintf>
  801cd8:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801cdb:	ff 45 b0             	incl   -0x50(%ebp)
  801cde:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801ce1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ce4:	7c 80                	jl     801c66 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801ce6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801ce9:	89 d0                	mov    %edx,%eax
  801ceb:	01 c0                	add    %eax,%eax
  801ced:	01 d0                	add    %edx,%eax
  801cef:	c1 e0 02             	shl    $0x2,%eax
  801cf2:	05 20 31 80 00       	add    $0x803120,%eax
  801cf7:	8b 00                	mov    (%eax),%eax
  801cf9:	83 ec 08             	sub    $0x8,%esp
  801cfc:	50                   	push   %eax
  801cfd:	68 ec 2e 80 00       	push   $0x802eec
  801d02:	e8 d3 ed ff ff       	call   800ada <cprintf>
  801d07:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801d0a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801d0d:	89 d0                	mov    %edx,%eax
  801d0f:	01 c0                	add    %eax,%eax
  801d11:	01 d0                	add    %edx,%eax
  801d13:	c1 e0 02             	shl    $0x2,%eax
  801d16:	05 20 31 80 00       	add    $0x803120,%eax
  801d1b:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
  801d22:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801d25:	8b 45 08             	mov    0x8(%ebp),%eax
  801d28:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801d2b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801d32:	eb 4b                	jmp    801d7f <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801d34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d37:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801d3e:	89 c2                	mov    %eax,%edx
  801d40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d43:	39 c2                	cmp    %eax,%edx
  801d45:	7f 35                	jg     801d7c <free+0x5d>
  801d47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d4a:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801d51:	89 c2                	mov    %eax,%edx
  801d53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d56:	39 c2                	cmp    %eax,%edx
  801d58:	7e 22                	jle    801d7c <free+0x5d>
				start=arr_add[i].start;
  801d5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d5d:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801d64:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d6a:	8b 04 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%eax
  801d71:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801d74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d77:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801d7a:	eb 0d                	jmp    801d89 <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801d7c:	ff 45 ec             	incl   -0x14(%ebp)
  801d7f:	a1 28 30 80 00       	mov    0x803028,%eax
  801d84:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801d87:	7c ab                	jl     801d34 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d8c:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801d93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d96:	8b 04 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%eax
  801d9d:	29 c2                	sub    %eax,%edx
  801d9f:	89 d0                	mov    %edx,%eax
  801da1:	83 ec 08             	sub    $0x8,%esp
  801da4:	50                   	push   %eax
  801da5:	ff 75 f4             	pushl  -0xc(%ebp)
  801da8:	e8 d9 02 00 00       	call   802086 <sys_freeMem>
  801dad:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801db6:	eb 2d                	jmp    801de5 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801db8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dbb:	40                   	inc    %eax
  801dbc:	8b 14 c5 e0 05 82 00 	mov    0x8205e0(,%eax,8),%edx
  801dc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dc6:	89 14 c5 e0 05 82 00 	mov    %edx,0x8205e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801dcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801dd0:	40                   	inc    %eax
  801dd1:	8b 14 c5 e4 05 82 00 	mov    0x8205e4(,%eax,8),%edx
  801dd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ddb:	89 14 c5 e4 05 82 00 	mov    %edx,0x8205e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801de2:	ff 45 e8             	incl   -0x18(%ebp)
  801de5:	a1 28 30 80 00       	mov    0x803028,%eax
  801dea:	48                   	dec    %eax
  801deb:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801dee:	7f c8                	jg     801db8 <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801df0:	a1 28 30 80 00       	mov    0x803028,%eax
  801df5:	48                   	dec    %eax
  801df6:	a3 28 30 80 00       	mov    %eax,0x803028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801dfb:	90                   	nop
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 18             	sub    $0x18,%esp
  801e04:	8b 45 10             	mov    0x10(%ebp),%eax
  801e07:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801e0a:	83 ec 04             	sub    $0x4,%esp
  801e0d:	68 08 2f 80 00       	push   $0x802f08
  801e12:	68 18 01 00 00       	push   $0x118
  801e17:	68 2b 2f 80 00       	push   $0x802f2b
  801e1c:	e8 17 ea ff ff       	call   800838 <_panic>

00801e21 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e27:	83 ec 04             	sub    $0x4,%esp
  801e2a:	68 08 2f 80 00       	push   $0x802f08
  801e2f:	68 1e 01 00 00       	push   $0x11e
  801e34:	68 2b 2f 80 00       	push   $0x802f2b
  801e39:	e8 fa e9 ff ff       	call   800838 <_panic>

00801e3e <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e44:	83 ec 04             	sub    $0x4,%esp
  801e47:	68 08 2f 80 00       	push   $0x802f08
  801e4c:	68 24 01 00 00       	push   $0x124
  801e51:	68 2b 2f 80 00       	push   $0x802f2b
  801e56:	e8 dd e9 ff ff       	call   800838 <_panic>

00801e5b <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
  801e5e:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e61:	83 ec 04             	sub    $0x4,%esp
  801e64:	68 08 2f 80 00       	push   $0x802f08
  801e69:	68 29 01 00 00       	push   $0x129
  801e6e:	68 2b 2f 80 00       	push   $0x802f2b
  801e73:	e8 c0 e9 ff ff       	call   800838 <_panic>

00801e78 <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e7e:	83 ec 04             	sub    $0x4,%esp
  801e81:	68 08 2f 80 00       	push   $0x802f08
  801e86:	68 2f 01 00 00       	push   $0x12f
  801e8b:	68 2b 2f 80 00       	push   $0x802f2b
  801e90:	e8 a3 e9 ff ff       	call   800838 <_panic>

00801e95 <shrink>:
}
void shrink(uint32 newSize)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801e9b:	83 ec 04             	sub    $0x4,%esp
  801e9e:	68 08 2f 80 00       	push   $0x802f08
  801ea3:	68 33 01 00 00       	push   $0x133
  801ea8:	68 2b 2f 80 00       	push   $0x802f2b
  801ead:	e8 86 e9 ff ff       	call   800838 <_panic>

00801eb2 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  801eb8:	83 ec 04             	sub    $0x4,%esp
  801ebb:	68 08 2f 80 00       	push   $0x802f08
  801ec0:	68 38 01 00 00       	push   $0x138
  801ec5:	68 2b 2f 80 00       	push   $0x802f2b
  801eca:	e8 69 e9 ff ff       	call   800838 <_panic>

00801ecf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ecf:	55                   	push   %ebp
  801ed0:	89 e5                	mov    %esp,%ebp
  801ed2:	57                   	push   %edi
  801ed3:	56                   	push   %esi
  801ed4:	53                   	push   %ebx
  801ed5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  801edb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ede:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee4:	8b 7d 18             	mov    0x18(%ebp),%edi
  801ee7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801eea:	cd 30                	int    $0x30
  801eec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801ef2:	83 c4 10             	add    $0x10,%esp
  801ef5:	5b                   	pop    %ebx
  801ef6:	5e                   	pop    %esi
  801ef7:	5f                   	pop    %edi
  801ef8:	5d                   	pop    %ebp
  801ef9:	c3                   	ret    

00801efa <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801efa:	55                   	push   %ebp
  801efb:	89 e5                	mov    %esp,%ebp
  801efd:	83 ec 04             	sub    $0x4,%esp
  801f00:	8b 45 10             	mov    0x10(%ebp),%eax
  801f03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f06:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	52                   	push   %edx
  801f12:	ff 75 0c             	pushl  0xc(%ebp)
  801f15:	50                   	push   %eax
  801f16:	6a 00                	push   $0x0
  801f18:	e8 b2 ff ff ff       	call   801ecf <syscall>
  801f1d:	83 c4 18             	add    $0x18,%esp
}
  801f20:	90                   	nop
  801f21:	c9                   	leave  
  801f22:	c3                   	ret    

00801f23 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f23:	55                   	push   %ebp
  801f24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f26:	6a 00                	push   $0x0
  801f28:	6a 00                	push   $0x0
  801f2a:	6a 00                	push   $0x0
  801f2c:	6a 00                	push   $0x0
  801f2e:	6a 00                	push   $0x0
  801f30:	6a 01                	push   $0x1
  801f32:	e8 98 ff ff ff       	call   801ecf <syscall>
  801f37:	83 c4 18             	add    $0x18,%esp
}
  801f3a:	c9                   	leave  
  801f3b:	c3                   	ret    

00801f3c <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  801f3c:	55                   	push   %ebp
  801f3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  801f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	50                   	push   %eax
  801f4b:	6a 05                	push   $0x5
  801f4d:	e8 7d ff ff ff       	call   801ecf <syscall>
  801f52:	83 c4 18             	add    $0x18,%esp
}
  801f55:	c9                   	leave  
  801f56:	c3                   	ret    

00801f57 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801f57:	55                   	push   %ebp
  801f58:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	6a 00                	push   $0x0
  801f60:	6a 00                	push   $0x0
  801f62:	6a 00                	push   $0x0
  801f64:	6a 02                	push   $0x2
  801f66:	e8 64 ff ff ff       	call   801ecf <syscall>
  801f6b:	83 c4 18             	add    $0x18,%esp
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	6a 00                	push   $0x0
  801f7d:	6a 03                	push   $0x3
  801f7f:	e8 4b ff ff ff       	call   801ecf <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 00                	push   $0x0
  801f94:	6a 00                	push   $0x0
  801f96:	6a 04                	push   $0x4
  801f98:	e8 32 ff ff ff       	call   801ecf <syscall>
  801f9d:	83 c4 18             	add    $0x18,%esp
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <sys_env_exit>:


void sys_env_exit(void)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  801fa5:	6a 00                	push   $0x0
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	6a 00                	push   $0x0
  801faf:	6a 06                	push   $0x6
  801fb1:	e8 19 ff ff ff       	call   801ecf <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
}
  801fb9:	90                   	nop
  801fba:	c9                   	leave  
  801fbb:	c3                   	ret    

00801fbc <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  801fbc:	55                   	push   %ebp
  801fbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fbf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	6a 00                	push   $0x0
  801fc7:	6a 00                	push   $0x0
  801fc9:	6a 00                	push   $0x0
  801fcb:	52                   	push   %edx
  801fcc:	50                   	push   %eax
  801fcd:	6a 07                	push   $0x7
  801fcf:	e8 fb fe ff ff       	call   801ecf <syscall>
  801fd4:	83 c4 18             	add    $0x18,%esp
}
  801fd7:	c9                   	leave  
  801fd8:	c3                   	ret    

00801fd9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fd9:	55                   	push   %ebp
  801fda:	89 e5                	mov    %esp,%ebp
  801fdc:	56                   	push   %esi
  801fdd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fde:	8b 75 18             	mov    0x18(%ebp),%esi
  801fe1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fe4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fe7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	56                   	push   %esi
  801fee:	53                   	push   %ebx
  801fef:	51                   	push   %ecx
  801ff0:	52                   	push   %edx
  801ff1:	50                   	push   %eax
  801ff2:	6a 08                	push   $0x8
  801ff4:	e8 d6 fe ff ff       	call   801ecf <syscall>
  801ff9:	83 c4 18             	add    $0x18,%esp
}
  801ffc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fff:	5b                   	pop    %ebx
  802000:	5e                   	pop    %esi
  802001:	5d                   	pop    %ebp
  802002:	c3                   	ret    

00802003 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802006:	8b 55 0c             	mov    0xc(%ebp),%edx
  802009:	8b 45 08             	mov    0x8(%ebp),%eax
  80200c:	6a 00                	push   $0x0
  80200e:	6a 00                	push   $0x0
  802010:	6a 00                	push   $0x0
  802012:	52                   	push   %edx
  802013:	50                   	push   %eax
  802014:	6a 09                	push   $0x9
  802016:	e8 b4 fe ff ff       	call   801ecf <syscall>
  80201b:	83 c4 18             	add    $0x18,%esp
}
  80201e:	c9                   	leave  
  80201f:	c3                   	ret    

00802020 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802023:	6a 00                	push   $0x0
  802025:	6a 00                	push   $0x0
  802027:	6a 00                	push   $0x0
  802029:	ff 75 0c             	pushl  0xc(%ebp)
  80202c:	ff 75 08             	pushl  0x8(%ebp)
  80202f:	6a 0a                	push   $0xa
  802031:	e8 99 fe ff ff       	call   801ecf <syscall>
  802036:	83 c4 18             	add    $0x18,%esp
}
  802039:	c9                   	leave  
  80203a:	c3                   	ret    

0080203b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80203b:	55                   	push   %ebp
  80203c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80203e:	6a 00                	push   $0x0
  802040:	6a 00                	push   $0x0
  802042:	6a 00                	push   $0x0
  802044:	6a 00                	push   $0x0
  802046:	6a 00                	push   $0x0
  802048:	6a 0b                	push   $0xb
  80204a:	e8 80 fe ff ff       	call   801ecf <syscall>
  80204f:	83 c4 18             	add    $0x18,%esp
}
  802052:	c9                   	leave  
  802053:	c3                   	ret    

00802054 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802057:	6a 00                	push   $0x0
  802059:	6a 00                	push   $0x0
  80205b:	6a 00                	push   $0x0
  80205d:	6a 00                	push   $0x0
  80205f:	6a 00                	push   $0x0
  802061:	6a 0c                	push   $0xc
  802063:	e8 67 fe ff ff       	call   801ecf <syscall>
  802068:	83 c4 18             	add    $0x18,%esp
}
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802070:	6a 00                	push   $0x0
  802072:	6a 00                	push   $0x0
  802074:	6a 00                	push   $0x0
  802076:	6a 00                	push   $0x0
  802078:	6a 00                	push   $0x0
  80207a:	6a 0d                	push   $0xd
  80207c:	e8 4e fe ff ff       	call   801ecf <syscall>
  802081:	83 c4 18             	add    $0x18,%esp
}
  802084:	c9                   	leave  
  802085:	c3                   	ret    

00802086 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802086:	55                   	push   %ebp
  802087:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	6a 00                	push   $0x0
  80208f:	ff 75 0c             	pushl  0xc(%ebp)
  802092:	ff 75 08             	pushl  0x8(%ebp)
  802095:	6a 11                	push   $0x11
  802097:	e8 33 fe ff ff       	call   801ecf <syscall>
  80209c:	83 c4 18             	add    $0x18,%esp
	return;
  80209f:	90                   	nop
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    

008020a2 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  8020a2:	55                   	push   %ebp
  8020a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	ff 75 0c             	pushl  0xc(%ebp)
  8020ae:	ff 75 08             	pushl  0x8(%ebp)
  8020b1:	6a 12                	push   $0x12
  8020b3:	e8 17 fe ff ff       	call   801ecf <syscall>
  8020b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8020bb:	90                   	nop
}
  8020bc:	c9                   	leave  
  8020bd:	c3                   	ret    

008020be <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	6a 00                	push   $0x0
  8020cb:	6a 0e                	push   $0xe
  8020cd:	e8 fd fd ff ff       	call   801ecf <syscall>
  8020d2:	83 c4 18             	add    $0x18,%esp
}
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	ff 75 08             	pushl  0x8(%ebp)
  8020e5:	6a 0f                	push   $0xf
  8020e7:	e8 e3 fd ff ff       	call   801ecf <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
}
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 00                	push   $0x0
  8020fe:	6a 10                	push   $0x10
  802100:	e8 ca fd ff ff       	call   801ecf <syscall>
  802105:	83 c4 18             	add    $0x18,%esp
}
  802108:	90                   	nop
  802109:	c9                   	leave  
  80210a:	c3                   	ret    

0080210b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80210b:	55                   	push   %ebp
  80210c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 00                	push   $0x0
  802114:	6a 00                	push   $0x0
  802116:	6a 00                	push   $0x0
  802118:	6a 14                	push   $0x14
  80211a:	e8 b0 fd ff ff       	call   801ecf <syscall>
  80211f:	83 c4 18             	add    $0x18,%esp
}
  802122:	90                   	nop
  802123:	c9                   	leave  
  802124:	c3                   	ret    

00802125 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 00                	push   $0x0
  802130:	6a 00                	push   $0x0
  802132:	6a 15                	push   $0x15
  802134:	e8 96 fd ff ff       	call   801ecf <syscall>
  802139:	83 c4 18             	add    $0x18,%esp
}
  80213c:	90                   	nop
  80213d:	c9                   	leave  
  80213e:	c3                   	ret    

0080213f <sys_cputc>:


void
sys_cputc(const char c)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 04             	sub    $0x4,%esp
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80214b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80214f:	6a 00                	push   $0x0
  802151:	6a 00                	push   $0x0
  802153:	6a 00                	push   $0x0
  802155:	6a 00                	push   $0x0
  802157:	50                   	push   %eax
  802158:	6a 16                	push   $0x16
  80215a:	e8 70 fd ff ff       	call   801ecf <syscall>
  80215f:	83 c4 18             	add    $0x18,%esp
}
  802162:	90                   	nop
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802168:	6a 00                	push   $0x0
  80216a:	6a 00                	push   $0x0
  80216c:	6a 00                	push   $0x0
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 17                	push   $0x17
  802174:	e8 56 fd ff ff       	call   801ecf <syscall>
  802179:	83 c4 18             	add    $0x18,%esp
}
  80217c:	90                   	nop
  80217d:	c9                   	leave  
  80217e:	c3                   	ret    

0080217f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80217f:	55                   	push   %ebp
  802180:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	6a 00                	push   $0x0
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	ff 75 0c             	pushl  0xc(%ebp)
  80218e:	50                   	push   %eax
  80218f:	6a 18                	push   $0x18
  802191:	e8 39 fd ff ff       	call   801ecf <syscall>
  802196:	83 c4 18             	add    $0x18,%esp
}
  802199:	c9                   	leave  
  80219a:	c3                   	ret    

0080219b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80219b:	55                   	push   %ebp
  80219c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80219e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	6a 00                	push   $0x0
  8021a6:	6a 00                	push   $0x0
  8021a8:	6a 00                	push   $0x0
  8021aa:	52                   	push   %edx
  8021ab:	50                   	push   %eax
  8021ac:	6a 1b                	push   $0x1b
  8021ae:	e8 1c fd ff ff       	call   801ecf <syscall>
  8021b3:	83 c4 18             	add    $0x18,%esp
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	6a 00                	push   $0x0
  8021c3:	6a 00                	push   $0x0
  8021c5:	6a 00                	push   $0x0
  8021c7:	52                   	push   %edx
  8021c8:	50                   	push   %eax
  8021c9:	6a 19                	push   $0x19
  8021cb:	e8 ff fc ff ff       	call   801ecf <syscall>
  8021d0:	83 c4 18             	add    $0x18,%esp
}
  8021d3:	90                   	nop
  8021d4:	c9                   	leave  
  8021d5:	c3                   	ret    

008021d6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021df:	6a 00                	push   $0x0
  8021e1:	6a 00                	push   $0x0
  8021e3:	6a 00                	push   $0x0
  8021e5:	52                   	push   %edx
  8021e6:	50                   	push   %eax
  8021e7:	6a 1a                	push   $0x1a
  8021e9:	e8 e1 fc ff ff       	call   801ecf <syscall>
  8021ee:	83 c4 18             	add    $0x18,%esp
}
  8021f1:	90                   	nop
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	83 ec 04             	sub    $0x4,%esp
  8021fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8021fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802200:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802203:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	6a 00                	push   $0x0
  80220c:	51                   	push   %ecx
  80220d:	52                   	push   %edx
  80220e:	ff 75 0c             	pushl  0xc(%ebp)
  802211:	50                   	push   %eax
  802212:	6a 1c                	push   $0x1c
  802214:	e8 b6 fc ff ff       	call   801ecf <syscall>
  802219:	83 c4 18             	add    $0x18,%esp
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802221:	8b 55 0c             	mov    0xc(%ebp),%edx
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	6a 00                	push   $0x0
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	52                   	push   %edx
  80222e:	50                   	push   %eax
  80222f:	6a 1d                	push   $0x1d
  802231:	e8 99 fc ff ff       	call   801ecf <syscall>
  802236:	83 c4 18             	add    $0x18,%esp
}
  802239:	c9                   	leave  
  80223a:	c3                   	ret    

0080223b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80223b:	55                   	push   %ebp
  80223c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80223e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802241:	8b 55 0c             	mov    0xc(%ebp),%edx
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	6a 00                	push   $0x0
  802249:	6a 00                	push   $0x0
  80224b:	51                   	push   %ecx
  80224c:	52                   	push   %edx
  80224d:	50                   	push   %eax
  80224e:	6a 1e                	push   $0x1e
  802250:	e8 7a fc ff ff       	call   801ecf <syscall>
  802255:	83 c4 18             	add    $0x18,%esp
}
  802258:	c9                   	leave  
  802259:	c3                   	ret    

0080225a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80225a:	55                   	push   %ebp
  80225b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80225d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	6a 00                	push   $0x0
  802265:	6a 00                	push   $0x0
  802267:	6a 00                	push   $0x0
  802269:	52                   	push   %edx
  80226a:	50                   	push   %eax
  80226b:	6a 1f                	push   $0x1f
  80226d:	e8 5d fc ff ff       	call   801ecf <syscall>
  802272:	83 c4 18             	add    $0x18,%esp
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80227a:	6a 00                	push   $0x0
  80227c:	6a 00                	push   $0x0
  80227e:	6a 00                	push   $0x0
  802280:	6a 00                	push   $0x0
  802282:	6a 00                	push   $0x0
  802284:	6a 20                	push   $0x20
  802286:	e8 44 fc ff ff       	call   801ecf <syscall>
  80228b:	83 c4 18             	add    $0x18,%esp
}
  80228e:	c9                   	leave  
  80228f:	c3                   	ret    

00802290 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802290:	55                   	push   %ebp
  802291:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	6a 00                	push   $0x0
  802298:	ff 75 14             	pushl  0x14(%ebp)
  80229b:	ff 75 10             	pushl  0x10(%ebp)
  80229e:	ff 75 0c             	pushl  0xc(%ebp)
  8022a1:	50                   	push   %eax
  8022a2:	6a 21                	push   $0x21
  8022a4:	e8 26 fc ff ff       	call   801ecf <syscall>
  8022a9:	83 c4 18             	add    $0x18,%esp
}
  8022ac:	c9                   	leave  
  8022ad:	c3                   	ret    

008022ae <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	6a 00                	push   $0x0
  8022b6:	6a 00                	push   $0x0
  8022b8:	6a 00                	push   $0x0
  8022ba:	6a 00                	push   $0x0
  8022bc:	50                   	push   %eax
  8022bd:	6a 22                	push   $0x22
  8022bf:	e8 0b fc ff ff       	call   801ecf <syscall>
  8022c4:	83 c4 18             	add    $0x18,%esp
}
  8022c7:	90                   	nop
  8022c8:	c9                   	leave  
  8022c9:	c3                   	ret    

008022ca <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8022ca:	55                   	push   %ebp
  8022cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8022cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	50                   	push   %eax
  8022d9:	6a 23                	push   $0x23
  8022db:	e8 ef fb ff ff       	call   801ecf <syscall>
  8022e0:	83 c4 18             	add    $0x18,%esp
}
  8022e3:	90                   	nop
  8022e4:	c9                   	leave  
  8022e5:	c3                   	ret    

008022e6 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8022ec:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022ef:	8d 50 04             	lea    0x4(%eax),%edx
  8022f2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8022f5:	6a 00                	push   $0x0
  8022f7:	6a 00                	push   $0x0
  8022f9:	6a 00                	push   $0x0
  8022fb:	52                   	push   %edx
  8022fc:	50                   	push   %eax
  8022fd:	6a 24                	push   $0x24
  8022ff:	e8 cb fb ff ff       	call   801ecf <syscall>
  802304:	83 c4 18             	add    $0x18,%esp
	return result;
  802307:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80230a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80230d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802310:	89 01                	mov    %eax,(%ecx)
  802312:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	c9                   	leave  
  802319:	c2 04 00             	ret    $0x4

0080231c <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	ff 75 10             	pushl  0x10(%ebp)
  802326:	ff 75 0c             	pushl  0xc(%ebp)
  802329:	ff 75 08             	pushl  0x8(%ebp)
  80232c:	6a 13                	push   $0x13
  80232e:	e8 9c fb ff ff       	call   801ecf <syscall>
  802333:	83 c4 18             	add    $0x18,%esp
	return ;
  802336:	90                   	nop
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <sys_rcr2>:
uint32 sys_rcr2()
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 25                	push   $0x25
  802348:	e8 82 fb ff ff       	call   801ecf <syscall>
  80234d:	83 c4 18             	add    $0x18,%esp
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 04             	sub    $0x4,%esp
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80235e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802362:	6a 00                	push   $0x0
  802364:	6a 00                	push   $0x0
  802366:	6a 00                	push   $0x0
  802368:	6a 00                	push   $0x0
  80236a:	50                   	push   %eax
  80236b:	6a 26                	push   $0x26
  80236d:	e8 5d fb ff ff       	call   801ecf <syscall>
  802372:	83 c4 18             	add    $0x18,%esp
	return ;
  802375:	90                   	nop
}
  802376:	c9                   	leave  
  802377:	c3                   	ret    

00802378 <rsttst>:
void rsttst()
{
  802378:	55                   	push   %ebp
  802379:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80237b:	6a 00                	push   $0x0
  80237d:	6a 00                	push   $0x0
  80237f:	6a 00                	push   $0x0
  802381:	6a 00                	push   $0x0
  802383:	6a 00                	push   $0x0
  802385:	6a 28                	push   $0x28
  802387:	e8 43 fb ff ff       	call   801ecf <syscall>
  80238c:	83 c4 18             	add    $0x18,%esp
	return ;
  80238f:	90                   	nop
}
  802390:	c9                   	leave  
  802391:	c3                   	ret    

00802392 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802392:	55                   	push   %ebp
  802393:	89 e5                	mov    %esp,%ebp
  802395:	83 ec 04             	sub    $0x4,%esp
  802398:	8b 45 14             	mov    0x14(%ebp),%eax
  80239b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80239e:	8b 55 18             	mov    0x18(%ebp),%edx
  8023a1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023a5:	52                   	push   %edx
  8023a6:	50                   	push   %eax
  8023a7:	ff 75 10             	pushl  0x10(%ebp)
  8023aa:	ff 75 0c             	pushl  0xc(%ebp)
  8023ad:	ff 75 08             	pushl  0x8(%ebp)
  8023b0:	6a 27                	push   $0x27
  8023b2:	e8 18 fb ff ff       	call   801ecf <syscall>
  8023b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ba:	90                   	nop
}
  8023bb:	c9                   	leave  
  8023bc:	c3                   	ret    

008023bd <chktst>:
void chktst(uint32 n)
{
  8023bd:	55                   	push   %ebp
  8023be:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8023c0:	6a 00                	push   $0x0
  8023c2:	6a 00                	push   $0x0
  8023c4:	6a 00                	push   $0x0
  8023c6:	6a 00                	push   $0x0
  8023c8:	ff 75 08             	pushl  0x8(%ebp)
  8023cb:	6a 29                	push   $0x29
  8023cd:	e8 fd fa ff ff       	call   801ecf <syscall>
  8023d2:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d5:	90                   	nop
}
  8023d6:	c9                   	leave  
  8023d7:	c3                   	ret    

008023d8 <inctst>:

void inctst()
{
  8023d8:	55                   	push   %ebp
  8023d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	6a 00                	push   $0x0
  8023e1:	6a 00                	push   $0x0
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 2a                	push   $0x2a
  8023e7:	e8 e3 fa ff ff       	call   801ecf <syscall>
  8023ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8023ef:	90                   	nop
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <gettst>:
uint32 gettst()
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8023f5:	6a 00                	push   $0x0
  8023f7:	6a 00                	push   $0x0
  8023f9:	6a 00                	push   $0x0
  8023fb:	6a 00                	push   $0x0
  8023fd:	6a 00                	push   $0x0
  8023ff:	6a 2b                	push   $0x2b
  802401:	e8 c9 fa ff ff       	call   801ecf <syscall>
  802406:	83 c4 18             	add    $0x18,%esp
}
  802409:	c9                   	leave  
  80240a:	c3                   	ret    

0080240b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80240b:	55                   	push   %ebp
  80240c:	89 e5                	mov    %esp,%ebp
  80240e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802411:	6a 00                	push   $0x0
  802413:	6a 00                	push   $0x0
  802415:	6a 00                	push   $0x0
  802417:	6a 00                	push   $0x0
  802419:	6a 00                	push   $0x0
  80241b:	6a 2c                	push   $0x2c
  80241d:	e8 ad fa ff ff       	call   801ecf <syscall>
  802422:	83 c4 18             	add    $0x18,%esp
  802425:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802428:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80242c:	75 07                	jne    802435 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80242e:	b8 01 00 00 00       	mov    $0x1,%eax
  802433:	eb 05                	jmp    80243a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802435:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 2c                	push   $0x2c
  80244e:	e8 7c fa ff ff       	call   801ecf <syscall>
  802453:	83 c4 18             	add    $0x18,%esp
  802456:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802459:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80245d:	75 07                	jne    802466 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80245f:	b8 01 00 00 00       	mov    $0x1,%eax
  802464:	eb 05                	jmp    80246b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802466:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80246b:	c9                   	leave  
  80246c:	c3                   	ret    

0080246d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80246d:	55                   	push   %ebp
  80246e:	89 e5                	mov    %esp,%ebp
  802470:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802473:	6a 00                	push   $0x0
  802475:	6a 00                	push   $0x0
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 2c                	push   $0x2c
  80247f:	e8 4b fa ff ff       	call   801ecf <syscall>
  802484:	83 c4 18             	add    $0x18,%esp
  802487:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80248a:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80248e:	75 07                	jne    802497 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802490:	b8 01 00 00 00       	mov    $0x1,%eax
  802495:	eb 05                	jmp    80249c <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802497:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249c:	c9                   	leave  
  80249d:	c3                   	ret    

0080249e <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
  8024a1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	6a 00                	push   $0x0
  8024aa:	6a 00                	push   $0x0
  8024ac:	6a 00                	push   $0x0
  8024ae:	6a 2c                	push   $0x2c
  8024b0:	e8 1a fa ff ff       	call   801ecf <syscall>
  8024b5:	83 c4 18             	add    $0x18,%esp
  8024b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8024bb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8024bf:	75 07                	jne    8024c8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8024c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c6:	eb 05                	jmp    8024cd <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8024c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8024d2:	6a 00                	push   $0x0
  8024d4:	6a 00                	push   $0x0
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	ff 75 08             	pushl  0x8(%ebp)
  8024dd:	6a 2d                	push   $0x2d
  8024df:	e8 eb f9 ff ff       	call   801ecf <syscall>
  8024e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8024e7:	90                   	nop
}
  8024e8:	c9                   	leave  
  8024e9:	c3                   	ret    

008024ea <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8024ea:	55                   	push   %ebp
  8024eb:	89 e5                	mov    %esp,%ebp
  8024ed:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8024ee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8024f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fa:	6a 00                	push   $0x0
  8024fc:	53                   	push   %ebx
  8024fd:	51                   	push   %ecx
  8024fe:	52                   	push   %edx
  8024ff:	50                   	push   %eax
  802500:	6a 2e                	push   $0x2e
  802502:	e8 c8 f9 ff ff       	call   801ecf <syscall>
  802507:	83 c4 18             	add    $0x18,%esp
}
  80250a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80250d:	c9                   	leave  
  80250e:	c3                   	ret    

0080250f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80250f:	55                   	push   %ebp
  802510:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802512:	8b 55 0c             	mov    0xc(%ebp),%edx
  802515:	8b 45 08             	mov    0x8(%ebp),%eax
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	52                   	push   %edx
  80251f:	50                   	push   %eax
  802520:	6a 2f                	push   $0x2f
  802522:	e8 a8 f9 ff ff       	call   801ecf <syscall>
  802527:	83 c4 18             	add    $0x18,%esp
}
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    

0080252c <__udivdi3>:
  80252c:	55                   	push   %ebp
  80252d:	57                   	push   %edi
  80252e:	56                   	push   %esi
  80252f:	53                   	push   %ebx
  802530:	83 ec 1c             	sub    $0x1c,%esp
  802533:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802537:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80253b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80253f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802543:	89 ca                	mov    %ecx,%edx
  802545:	89 f8                	mov    %edi,%eax
  802547:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80254b:	85 f6                	test   %esi,%esi
  80254d:	75 2d                	jne    80257c <__udivdi3+0x50>
  80254f:	39 cf                	cmp    %ecx,%edi
  802551:	77 65                	ja     8025b8 <__udivdi3+0x8c>
  802553:	89 fd                	mov    %edi,%ebp
  802555:	85 ff                	test   %edi,%edi
  802557:	75 0b                	jne    802564 <__udivdi3+0x38>
  802559:	b8 01 00 00 00       	mov    $0x1,%eax
  80255e:	31 d2                	xor    %edx,%edx
  802560:	f7 f7                	div    %edi
  802562:	89 c5                	mov    %eax,%ebp
  802564:	31 d2                	xor    %edx,%edx
  802566:	89 c8                	mov    %ecx,%eax
  802568:	f7 f5                	div    %ebp
  80256a:	89 c1                	mov    %eax,%ecx
  80256c:	89 d8                	mov    %ebx,%eax
  80256e:	f7 f5                	div    %ebp
  802570:	89 cf                	mov    %ecx,%edi
  802572:	89 fa                	mov    %edi,%edx
  802574:	83 c4 1c             	add    $0x1c,%esp
  802577:	5b                   	pop    %ebx
  802578:	5e                   	pop    %esi
  802579:	5f                   	pop    %edi
  80257a:	5d                   	pop    %ebp
  80257b:	c3                   	ret    
  80257c:	39 ce                	cmp    %ecx,%esi
  80257e:	77 28                	ja     8025a8 <__udivdi3+0x7c>
  802580:	0f bd fe             	bsr    %esi,%edi
  802583:	83 f7 1f             	xor    $0x1f,%edi
  802586:	75 40                	jne    8025c8 <__udivdi3+0x9c>
  802588:	39 ce                	cmp    %ecx,%esi
  80258a:	72 0a                	jb     802596 <__udivdi3+0x6a>
  80258c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802590:	0f 87 9e 00 00 00    	ja     802634 <__udivdi3+0x108>
  802596:	b8 01 00 00 00       	mov    $0x1,%eax
  80259b:	89 fa                	mov    %edi,%edx
  80259d:	83 c4 1c             	add    $0x1c,%esp
  8025a0:	5b                   	pop    %ebx
  8025a1:	5e                   	pop    %esi
  8025a2:	5f                   	pop    %edi
  8025a3:	5d                   	pop    %ebp
  8025a4:	c3                   	ret    
  8025a5:	8d 76 00             	lea    0x0(%esi),%esi
  8025a8:	31 ff                	xor    %edi,%edi
  8025aa:	31 c0                	xor    %eax,%eax
  8025ac:	89 fa                	mov    %edi,%edx
  8025ae:	83 c4 1c             	add    $0x1c,%esp
  8025b1:	5b                   	pop    %ebx
  8025b2:	5e                   	pop    %esi
  8025b3:	5f                   	pop    %edi
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    
  8025b6:	66 90                	xchg   %ax,%ax
  8025b8:	89 d8                	mov    %ebx,%eax
  8025ba:	f7 f7                	div    %edi
  8025bc:	31 ff                	xor    %edi,%edi
  8025be:	89 fa                	mov    %edi,%edx
  8025c0:	83 c4 1c             	add    $0x1c,%esp
  8025c3:	5b                   	pop    %ebx
  8025c4:	5e                   	pop    %esi
  8025c5:	5f                   	pop    %edi
  8025c6:	5d                   	pop    %ebp
  8025c7:	c3                   	ret    
  8025c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8025cd:	89 eb                	mov    %ebp,%ebx
  8025cf:	29 fb                	sub    %edi,%ebx
  8025d1:	89 f9                	mov    %edi,%ecx
  8025d3:	d3 e6                	shl    %cl,%esi
  8025d5:	89 c5                	mov    %eax,%ebp
  8025d7:	88 d9                	mov    %bl,%cl
  8025d9:	d3 ed                	shr    %cl,%ebp
  8025db:	89 e9                	mov    %ebp,%ecx
  8025dd:	09 f1                	or     %esi,%ecx
  8025df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8025e3:	89 f9                	mov    %edi,%ecx
  8025e5:	d3 e0                	shl    %cl,%eax
  8025e7:	89 c5                	mov    %eax,%ebp
  8025e9:	89 d6                	mov    %edx,%esi
  8025eb:	88 d9                	mov    %bl,%cl
  8025ed:	d3 ee                	shr    %cl,%esi
  8025ef:	89 f9                	mov    %edi,%ecx
  8025f1:	d3 e2                	shl    %cl,%edx
  8025f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8025f7:	88 d9                	mov    %bl,%cl
  8025f9:	d3 e8                	shr    %cl,%eax
  8025fb:	09 c2                	or     %eax,%edx
  8025fd:	89 d0                	mov    %edx,%eax
  8025ff:	89 f2                	mov    %esi,%edx
  802601:	f7 74 24 0c          	divl   0xc(%esp)
  802605:	89 d6                	mov    %edx,%esi
  802607:	89 c3                	mov    %eax,%ebx
  802609:	f7 e5                	mul    %ebp
  80260b:	39 d6                	cmp    %edx,%esi
  80260d:	72 19                	jb     802628 <__udivdi3+0xfc>
  80260f:	74 0b                	je     80261c <__udivdi3+0xf0>
  802611:	89 d8                	mov    %ebx,%eax
  802613:	31 ff                	xor    %edi,%edi
  802615:	e9 58 ff ff ff       	jmp    802572 <__udivdi3+0x46>
  80261a:	66 90                	xchg   %ax,%ax
  80261c:	8b 54 24 08          	mov    0x8(%esp),%edx
  802620:	89 f9                	mov    %edi,%ecx
  802622:	d3 e2                	shl    %cl,%edx
  802624:	39 c2                	cmp    %eax,%edx
  802626:	73 e9                	jae    802611 <__udivdi3+0xe5>
  802628:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80262b:	31 ff                	xor    %edi,%edi
  80262d:	e9 40 ff ff ff       	jmp    802572 <__udivdi3+0x46>
  802632:	66 90                	xchg   %ax,%ax
  802634:	31 c0                	xor    %eax,%eax
  802636:	e9 37 ff ff ff       	jmp    802572 <__udivdi3+0x46>
  80263b:	90                   	nop

0080263c <__umoddi3>:
  80263c:	55                   	push   %ebp
  80263d:	57                   	push   %edi
  80263e:	56                   	push   %esi
  80263f:	53                   	push   %ebx
  802640:	83 ec 1c             	sub    $0x1c,%esp
  802643:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802647:	8b 74 24 34          	mov    0x34(%esp),%esi
  80264b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80264f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802653:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802657:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80265b:	89 f3                	mov    %esi,%ebx
  80265d:	89 fa                	mov    %edi,%edx
  80265f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802663:	89 34 24             	mov    %esi,(%esp)
  802666:	85 c0                	test   %eax,%eax
  802668:	75 1a                	jne    802684 <__umoddi3+0x48>
  80266a:	39 f7                	cmp    %esi,%edi
  80266c:	0f 86 a2 00 00 00    	jbe    802714 <__umoddi3+0xd8>
  802672:	89 c8                	mov    %ecx,%eax
  802674:	89 f2                	mov    %esi,%edx
  802676:	f7 f7                	div    %edi
  802678:	89 d0                	mov    %edx,%eax
  80267a:	31 d2                	xor    %edx,%edx
  80267c:	83 c4 1c             	add    $0x1c,%esp
  80267f:	5b                   	pop    %ebx
  802680:	5e                   	pop    %esi
  802681:	5f                   	pop    %edi
  802682:	5d                   	pop    %ebp
  802683:	c3                   	ret    
  802684:	39 f0                	cmp    %esi,%eax
  802686:	0f 87 ac 00 00 00    	ja     802738 <__umoddi3+0xfc>
  80268c:	0f bd e8             	bsr    %eax,%ebp
  80268f:	83 f5 1f             	xor    $0x1f,%ebp
  802692:	0f 84 ac 00 00 00    	je     802744 <__umoddi3+0x108>
  802698:	bf 20 00 00 00       	mov    $0x20,%edi
  80269d:	29 ef                	sub    %ebp,%edi
  80269f:	89 fe                	mov    %edi,%esi
  8026a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8026a5:	89 e9                	mov    %ebp,%ecx
  8026a7:	d3 e0                	shl    %cl,%eax
  8026a9:	89 d7                	mov    %edx,%edi
  8026ab:	89 f1                	mov    %esi,%ecx
  8026ad:	d3 ef                	shr    %cl,%edi
  8026af:	09 c7                	or     %eax,%edi
  8026b1:	89 e9                	mov    %ebp,%ecx
  8026b3:	d3 e2                	shl    %cl,%edx
  8026b5:	89 14 24             	mov    %edx,(%esp)
  8026b8:	89 d8                	mov    %ebx,%eax
  8026ba:	d3 e0                	shl    %cl,%eax
  8026bc:	89 c2                	mov    %eax,%edx
  8026be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026c2:	d3 e0                	shl    %cl,%eax
  8026c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8026cc:	89 f1                	mov    %esi,%ecx
  8026ce:	d3 e8                	shr    %cl,%eax
  8026d0:	09 d0                	or     %edx,%eax
  8026d2:	d3 eb                	shr    %cl,%ebx
  8026d4:	89 da                	mov    %ebx,%edx
  8026d6:	f7 f7                	div    %edi
  8026d8:	89 d3                	mov    %edx,%ebx
  8026da:	f7 24 24             	mull   (%esp)
  8026dd:	89 c6                	mov    %eax,%esi
  8026df:	89 d1                	mov    %edx,%ecx
  8026e1:	39 d3                	cmp    %edx,%ebx
  8026e3:	0f 82 87 00 00 00    	jb     802770 <__umoddi3+0x134>
  8026e9:	0f 84 91 00 00 00    	je     802780 <__umoddi3+0x144>
  8026ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8026f3:	29 f2                	sub    %esi,%edx
  8026f5:	19 cb                	sbb    %ecx,%ebx
  8026f7:	89 d8                	mov    %ebx,%eax
  8026f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8026fd:	d3 e0                	shl    %cl,%eax
  8026ff:	89 e9                	mov    %ebp,%ecx
  802701:	d3 ea                	shr    %cl,%edx
  802703:	09 d0                	or     %edx,%eax
  802705:	89 e9                	mov    %ebp,%ecx
  802707:	d3 eb                	shr    %cl,%ebx
  802709:	89 da                	mov    %ebx,%edx
  80270b:	83 c4 1c             	add    $0x1c,%esp
  80270e:	5b                   	pop    %ebx
  80270f:	5e                   	pop    %esi
  802710:	5f                   	pop    %edi
  802711:	5d                   	pop    %ebp
  802712:	c3                   	ret    
  802713:	90                   	nop
  802714:	89 fd                	mov    %edi,%ebp
  802716:	85 ff                	test   %edi,%edi
  802718:	75 0b                	jne    802725 <__umoddi3+0xe9>
  80271a:	b8 01 00 00 00       	mov    $0x1,%eax
  80271f:	31 d2                	xor    %edx,%edx
  802721:	f7 f7                	div    %edi
  802723:	89 c5                	mov    %eax,%ebp
  802725:	89 f0                	mov    %esi,%eax
  802727:	31 d2                	xor    %edx,%edx
  802729:	f7 f5                	div    %ebp
  80272b:	89 c8                	mov    %ecx,%eax
  80272d:	f7 f5                	div    %ebp
  80272f:	89 d0                	mov    %edx,%eax
  802731:	e9 44 ff ff ff       	jmp    80267a <__umoddi3+0x3e>
  802736:	66 90                	xchg   %ax,%ax
  802738:	89 c8                	mov    %ecx,%eax
  80273a:	89 f2                	mov    %esi,%edx
  80273c:	83 c4 1c             	add    $0x1c,%esp
  80273f:	5b                   	pop    %ebx
  802740:	5e                   	pop    %esi
  802741:	5f                   	pop    %edi
  802742:	5d                   	pop    %ebp
  802743:	c3                   	ret    
  802744:	3b 04 24             	cmp    (%esp),%eax
  802747:	72 06                	jb     80274f <__umoddi3+0x113>
  802749:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80274d:	77 0f                	ja     80275e <__umoddi3+0x122>
  80274f:	89 f2                	mov    %esi,%edx
  802751:	29 f9                	sub    %edi,%ecx
  802753:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802757:	89 14 24             	mov    %edx,(%esp)
  80275a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80275e:	8b 44 24 04          	mov    0x4(%esp),%eax
  802762:	8b 14 24             	mov    (%esp),%edx
  802765:	83 c4 1c             	add    $0x1c,%esp
  802768:	5b                   	pop    %ebx
  802769:	5e                   	pop    %esi
  80276a:	5f                   	pop    %edi
  80276b:	5d                   	pop    %ebp
  80276c:	c3                   	ret    
  80276d:	8d 76 00             	lea    0x0(%esi),%esi
  802770:	2b 04 24             	sub    (%esp),%eax
  802773:	19 fa                	sbb    %edi,%edx
  802775:	89 d1                	mov    %edx,%ecx
  802777:	89 c6                	mov    %eax,%esi
  802779:	e9 71 ff ff ff       	jmp    8026ef <__umoddi3+0xb3>
  80277e:	66 90                	xchg   %ax,%ax
  802780:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802784:	72 ea                	jb     802770 <__umoddi3+0x134>
  802786:	89 d9                	mov    %ebx,%ecx
  802788:	e9 62 ff ff ff       	jmp    8026ef <__umoddi3+0xb3>
