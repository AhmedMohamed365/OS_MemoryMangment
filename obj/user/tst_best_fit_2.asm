
obj/user/tst_best_fit_2:     file format elf32-i386


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
  800031:	e8 9f 08 00 00       	call   8008d5 <libmain>
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
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);
  800040:	83 ec 0c             	sub    $0xc,%esp
  800043:	6a 02                	push   $0x2
  800045:	e8 67 26 00 00       	call   8026b1 <sys_set_uheap_strategy>
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
  80005a:	a1 20 40 80 00       	mov    0x804020,%eax
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
	sys_set_uheap_strategy(UHP_PLACE_BESTFIT);

	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  80007a:	ff 45 f0             	incl   -0x10(%ebp)
  80007d:	a1 20 40 80 00       	mov    0x804020,%eax
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
  800095:	68 80 29 80 00       	push   $0x802980
  80009a:	6a 1b                	push   $0x1b
  80009c:	68 9c 29 80 00       	push   $0x80299c
  8000a1:	e8 74 09 00 00       	call   800a1a <_panic>
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
  8000cd:	e8 74 19 00 00       	call   801a46 <malloc>
  8000d2:	83 c4 10             	add    $0x10,%esp
  8000d5:	89 45 90             	mov    %eax,-0x70(%ebp)
		if (ptr_allocations[0] != NULL) panic("Malloc: Attempt to allocate more than heap size, should return NULL");
  8000d8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000db:	85 c0                	test   %eax,%eax
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 b4 29 80 00       	push   $0x8029b4
  8000e7:	6a 25                	push   $0x25
  8000e9:	68 9c 29 80 00       	push   $0x80299c
  8000ee:	e8 27 09 00 00       	call   800a1a <_panic>
	}
	//[2] Attempt to allocate space more than any available fragment
	//	a) Create Fragments
	{
		//2 MB
		int freeFrames = sys_calculate_free_frames() ;
  8000f3:	e8 25 21 00 00       	call   80221d <sys_calculate_free_frames>
  8000f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages();
  8000fb:	e8 a0 21 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800100:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  800103:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800106:	01 c0                	add    %eax,%eax
  800108:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 32 19 00 00       	call   801a46 <malloc>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START) ) panic("Wrong start address for the allocated space... ");
  80011a:	8b 45 90             	mov    -0x70(%ebp),%eax
  80011d:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 f8 29 80 00       	push   $0x8029f8
  80012c:	6a 2e                	push   $0x2e
  80012e:	68 9c 29 80 00       	push   $0x80299c
  800133:	e8 e2 08 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  800138:	e8 63 21 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  80013d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800140:	3d 00 02 00 00       	cmp    $0x200,%eax
  800145:	74 14                	je     80015b <_main+0x123>
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 28 2a 80 00       	push   $0x802a28
  80014f:	6a 30                	push   $0x30
  800151:	68 9c 29 80 00       	push   $0x80299c
  800156:	e8 bf 08 00 00       	call   800a1a <_panic>

		//2 MB
		freeFrames = sys_calculate_free_frames() ;
  80015b:	e8 bd 20 00 00       	call   80221d <sys_calculate_free_frames>
  800160:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800163:	e8 38 21 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800168:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  80016b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80016e:	01 c0                	add    %eax,%eax
  800170:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800173:	83 ec 0c             	sub    $0xc,%esp
  800176:	50                   	push   %eax
  800177:	e8 ca 18 00 00       	call   801a46 <malloc>
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
  800198:	68 f8 29 80 00       	push   $0x8029f8
  80019d:	6a 36                	push   $0x36
  80019f:	68 9c 29 80 00       	push   $0x80299c
  8001a4:	e8 71 08 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  8001a9:	e8 f2 20 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  8001ae:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8001b1:	3d 00 02 00 00       	cmp    $0x200,%eax
  8001b6:	74 14                	je     8001cc <_main+0x194>
  8001b8:	83 ec 04             	sub    $0x4,%esp
  8001bb:	68 28 2a 80 00       	push   $0x802a28
  8001c0:	6a 38                	push   $0x38
  8001c2:	68 9c 29 80 00       	push   $0x80299c
  8001c7:	e8 4e 08 00 00       	call   800a1a <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  8001cc:	e8 4c 20 00 00       	call   80221d <sys_calculate_free_frames>
  8001d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8001d4:	e8 c7 20 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  8001d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(2*kilo);
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	01 c0                	add    %eax,%eax
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	50                   	push   %eax
  8001e5:	e8 5c 18 00 00       	call   801a46 <malloc>
  8001ea:	83 c4 10             	add    $0x10,%esp
  8001ed:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] != (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8001f0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8001f3:	89 c2                	mov    %eax,%edx
  8001f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001f8:	c1 e0 02             	shl    $0x2,%eax
  8001fb:	05 00 00 00 80       	add    $0x80000000,%eax
  800200:	39 c2                	cmp    %eax,%edx
  800202:	74 14                	je     800218 <_main+0x1e0>
  800204:	83 ec 04             	sub    $0x4,%esp
  800207:	68 f8 29 80 00       	push   $0x8029f8
  80020c:	6a 3e                	push   $0x3e
  80020e:	68 9c 29 80 00       	push   $0x80299c
  800213:	e8 02 08 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  800218:	e8 83 20 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  80021d:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800220:	83 f8 01             	cmp    $0x1,%eax
  800223:	74 14                	je     800239 <_main+0x201>
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	68 28 2a 80 00       	push   $0x802a28
  80022d:	6a 40                	push   $0x40
  80022f:	68 9c 29 80 00       	push   $0x80299c
  800234:	e8 e1 07 00 00       	call   800a1a <_panic>

		//2 KB
		freeFrames = sys_calculate_free_frames() ;
  800239:	e8 df 1f 00 00       	call   80221d <sys_calculate_free_frames>
  80023e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800241:	e8 5a 20 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800246:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(2*kilo);
  800249:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80024c:	01 c0                	add    %eax,%eax
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	50                   	push   %eax
  800252:	e8 ef 17 00 00       	call   801a46 <malloc>
  800257:	83 c4 10             	add    $0x10,%esp
  80025a:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] != (USER_HEAP_START + 4*Mega + 4*kilo)) panic("Wrong start address for the allocated space... ");
  80025d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800265:	c1 e0 02             	shl    $0x2,%eax
  800268:	89 c1                	mov    %eax,%ecx
  80026a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80026d:	c1 e0 02             	shl    $0x2,%eax
  800270:	01 c8                	add    %ecx,%eax
  800272:	05 00 00 00 80       	add    $0x80000000,%eax
  800277:	39 c2                	cmp    %eax,%edx
  800279:	74 14                	je     80028f <_main+0x257>
  80027b:	83 ec 04             	sub    $0x4,%esp
  80027e:	68 f8 29 80 00       	push   $0x8029f8
  800283:	6a 46                	push   $0x46
  800285:	68 9c 29 80 00       	push   $0x80299c
  80028a:	e8 8b 07 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  1) panic("Wrong page file allocation: ");
  80028f:	e8 0c 20 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800294:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800297:	83 f8 01             	cmp    $0x1,%eax
  80029a:	74 14                	je     8002b0 <_main+0x278>
  80029c:	83 ec 04             	sub    $0x4,%esp
  80029f:	68 28 2a 80 00       	push   $0x802a28
  8002a4:	6a 48                	push   $0x48
  8002a6:	68 9c 29 80 00       	push   $0x80299c
  8002ab:	e8 6a 07 00 00       	call   800a1a <_panic>

		//4 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  8002b0:	e8 68 1f 00 00       	call   80221d <sys_calculate_free_frames>
  8002b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002b8:	e8 e3 1f 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  8002bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[2]);
  8002c0:	8b 45 98             	mov    -0x68(%ebp),%eax
  8002c3:	83 ec 0c             	sub    $0xc,%esp
  8002c6:	50                   	push   %eax
  8002c7:	e8 35 1c 00 00       	call   801f01 <free>
  8002cc:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1) panic("Wrong free: ");
		if( (usedDiskPages-sys_pf_calculate_allocated_pages()) !=  1) panic("Wrong page file free: ");
  8002cf:	e8 cc 1f 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  8002d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002d7:	29 c2                	sub    %eax,%edx
  8002d9:	89 d0                	mov    %edx,%eax
  8002db:	83 f8 01             	cmp    $0x1,%eax
  8002de:	74 14                	je     8002f4 <_main+0x2bc>
  8002e0:	83 ec 04             	sub    $0x4,%esp
  8002e3:	68 45 2a 80 00       	push   $0x802a45
  8002e8:	6a 4f                	push   $0x4f
  8002ea:	68 9c 29 80 00       	push   $0x80299c
  8002ef:	e8 26 07 00 00       	call   800a1a <_panic>

		//7 KB
		freeFrames = sys_calculate_free_frames() ;
  8002f4:	e8 24 1f 00 00       	call   80221d <sys_calculate_free_frames>
  8002f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8002fc:	e8 9f 1f 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800301:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800304:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800307:	89 d0                	mov    %edx,%eax
  800309:	01 c0                	add    %eax,%eax
  80030b:	01 d0                	add    %edx,%eax
  80030d:	01 c0                	add    %eax,%eax
  80030f:	01 d0                	add    %edx,%eax
  800311:	83 ec 0c             	sub    $0xc,%esp
  800314:	50                   	push   %eax
  800315:	e8 2c 17 00 00       	call   801a46 <malloc>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] != (USER_HEAP_START + 4*Mega + 8*kilo)) panic("Wrong start address for the allocated space... ");
  800320:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800323:	89 c2                	mov    %eax,%edx
  800325:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800328:	c1 e0 02             	shl    $0x2,%eax
  80032b:	89 c1                	mov    %eax,%ecx
  80032d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800330:	c1 e0 03             	shl    $0x3,%eax
  800333:	01 c8                	add    %ecx,%eax
  800335:	05 00 00 00 80       	add    $0x80000000,%eax
  80033a:	39 c2                	cmp    %eax,%edx
  80033c:	74 14                	je     800352 <_main+0x31a>
  80033e:	83 ec 04             	sub    $0x4,%esp
  800341:	68 f8 29 80 00       	push   $0x8029f8
  800346:	6a 55                	push   $0x55
  800348:	68 9c 29 80 00       	push   $0x80299c
  80034d:	e8 c8 06 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  800352:	e8 49 1f 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800357:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80035a:	83 f8 02             	cmp    $0x2,%eax
  80035d:	74 14                	je     800373 <_main+0x33b>
  80035f:	83 ec 04             	sub    $0x4,%esp
  800362:	68 28 2a 80 00       	push   $0x802a28
  800367:	6a 57                	push   $0x57
  800369:	68 9c 29 80 00       	push   $0x80299c
  80036e:	e8 a7 06 00 00       	call   800a1a <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800373:	e8 a5 1e 00 00       	call   80221d <sys_calculate_free_frames>
  800378:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80037b:	e8 20 1f 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800380:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[0]);
  800383:	8b 45 90             	mov    -0x70(%ebp),%eax
  800386:	83 ec 0c             	sub    $0xc,%esp
  800389:	50                   	push   %eax
  80038a:	e8 72 1b 00 00       	call   801f01 <free>
  80038f:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  800392:	e8 09 1f 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800397:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80039a:	29 c2                	sub    %eax,%edx
  80039c:	89 d0                	mov    %edx,%eax
  80039e:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003a3:	74 14                	je     8003b9 <_main+0x381>
  8003a5:	83 ec 04             	sub    $0x4,%esp
  8003a8:	68 45 2a 80 00       	push   $0x802a45
  8003ad:	6a 5e                	push   $0x5e
  8003af:	68 9c 29 80 00       	push   $0x80299c
  8003b4:	e8 61 06 00 00       	call   800a1a <_panic>

		//3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003b9:	e8 5f 1e 00 00       	call   80221d <sys_calculate_free_frames>
  8003be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8003c1:	e8 da 1e 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  8003c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  8003c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003cc:	89 c2                	mov    %eax,%edx
  8003ce:	01 d2                	add    %edx,%edx
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8003d5:	83 ec 0c             	sub    $0xc,%esp
  8003d8:	50                   	push   %eax
  8003d9:	e8 68 16 00 00       	call   801a46 <malloc>
  8003de:	83 c4 10             	add    $0x10,%esp
  8003e1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8003e4:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003e7:	89 c2                	mov    %eax,%edx
  8003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003ec:	c1 e0 02             	shl    $0x2,%eax
  8003ef:	89 c1                	mov    %eax,%ecx
  8003f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003f4:	c1 e0 04             	shl    $0x4,%eax
  8003f7:	01 c8                	add    %ecx,%eax
  8003f9:	05 00 00 00 80       	add    $0x80000000,%eax
  8003fe:	39 c2                	cmp    %eax,%edx
  800400:	74 14                	je     800416 <_main+0x3de>
  800402:	83 ec 04             	sub    $0x4,%esp
  800405:	68 f8 29 80 00       	push   $0x8029f8
  80040a:	6a 64                	push   $0x64
  80040c:	68 9c 29 80 00       	push   $0x80299c
  800411:	e8 04 06 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  800416:	e8 85 1e 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  80041b:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80041e:	89 c2                	mov    %eax,%edx
  800420:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800423:	89 c1                	mov    %eax,%ecx
  800425:	01 c9                	add    %ecx,%ecx
  800427:	01 c8                	add    %ecx,%eax
  800429:	85 c0                	test   %eax,%eax
  80042b:	79 05                	jns    800432 <_main+0x3fa>
  80042d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800432:	c1 f8 0c             	sar    $0xc,%eax
  800435:	39 c2                	cmp    %eax,%edx
  800437:	74 14                	je     80044d <_main+0x415>
  800439:	83 ec 04             	sub    $0x4,%esp
  80043c:	68 28 2a 80 00       	push   $0x802a28
  800441:	6a 66                	push   $0x66
  800443:	68 9c 29 80 00       	push   $0x80299c
  800448:	e8 cd 05 00 00       	call   800a1a <_panic>

		//2 MB + 6 KB
		freeFrames = sys_calculate_free_frames() ;
  80044d:	e8 cb 1d 00 00       	call   80221d <sys_calculate_free_frames>
  800452:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800455:	e8 46 1e 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  80045a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega + 6*kilo);
  80045d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800460:	89 c2                	mov    %eax,%edx
  800462:	01 d2                	add    %edx,%edx
  800464:	01 c2                	add    %eax,%edx
  800466:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800469:	01 d0                	add    %edx,%eax
  80046b:	01 c0                	add    %eax,%eax
  80046d:	83 ec 0c             	sub    $0xc,%esp
  800470:	50                   	push   %eax
  800471:	e8 d0 15 00 00       	call   801a46 <malloc>
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] != (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80047c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047f:	89 c1                	mov    %eax,%ecx
  800481:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800484:	89 d0                	mov    %edx,%eax
  800486:	01 c0                	add    %eax,%eax
  800488:	01 d0                	add    %edx,%eax
  80048a:	01 c0                	add    %eax,%eax
  80048c:	01 d0                	add    %edx,%eax
  80048e:	89 c2                	mov    %eax,%edx
  800490:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800493:	c1 e0 04             	shl    $0x4,%eax
  800496:	01 d0                	add    %edx,%eax
  800498:	05 00 00 00 80       	add    $0x80000000,%eax
  80049d:	39 c1                	cmp    %eax,%ecx
  80049f:	74 14                	je     8004b5 <_main+0x47d>
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	68 f8 29 80 00       	push   $0x8029f8
  8004a9:	6a 6c                	push   $0x6c
  8004ab:	68 9c 29 80 00       	push   $0x80299c
  8004b0:	e8 65 05 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 514+1 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  514) panic("Wrong page file allocation: ");
  8004b5:	e8 e6 1d 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  8004ba:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8004bd:	3d 02 02 00 00       	cmp    $0x202,%eax
  8004c2:	74 14                	je     8004d8 <_main+0x4a0>
  8004c4:	83 ec 04             	sub    $0x4,%esp
  8004c7:	68 28 2a 80 00       	push   $0x802a28
  8004cc:	6a 6e                	push   $0x6e
  8004ce:	68 9c 29 80 00       	push   $0x80299c
  8004d3:	e8 42 05 00 00       	call   800a1a <_panic>

		//5 MB
		freeFrames = sys_calculate_free_frames() ;
  8004d8:	e8 40 1d 00 00       	call   80221d <sys_calculate_free_frames>
  8004dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8004e0:	e8 bb 1d 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  8004e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[7] = malloc(5*Mega-kilo);
  8004e8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004eb:	89 d0                	mov    %edx,%eax
  8004ed:	c1 e0 02             	shl    $0x2,%eax
  8004f0:	01 d0                	add    %edx,%eax
  8004f2:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004f5:	83 ec 0c             	sub    $0xc,%esp
  8004f8:	50                   	push   %eax
  8004f9:	e8 48 15 00 00       	call   801a46 <malloc>
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	89 45 ac             	mov    %eax,-0x54(%ebp)
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 9*Mega + 24*kilo)) panic("Wrong start address for the allocated space... ");
  800504:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800507:	89 c1                	mov    %eax,%ecx
  800509:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80050c:	89 d0                	mov    %edx,%eax
  80050e:	c1 e0 03             	shl    $0x3,%eax
  800511:	01 d0                	add    %edx,%eax
  800513:	89 c3                	mov    %eax,%ebx
  800515:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800518:	89 d0                	mov    %edx,%eax
  80051a:	01 c0                	add    %eax,%eax
  80051c:	01 d0                	add    %edx,%eax
  80051e:	c1 e0 03             	shl    $0x3,%eax
  800521:	01 d8                	add    %ebx,%eax
  800523:	05 00 00 00 80       	add    $0x80000000,%eax
  800528:	39 c1                	cmp    %eax,%ecx
  80052a:	74 14                	je     800540 <_main+0x508>
  80052c:	83 ec 04             	sub    $0x4,%esp
  80052f:	68 f8 29 80 00       	push   $0x8029f8
  800534:	6a 74                	push   $0x74
  800536:	68 9c 29 80 00       	push   $0x80299c
  80053b:	e8 da 04 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 5*Mega/4096 + 1) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5*Mega/4096) panic("Wrong page file allocation: ");
  800540:	e8 5b 1d 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800545:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800548:	89 c1                	mov    %eax,%ecx
  80054a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80054d:	89 d0                	mov    %edx,%eax
  80054f:	c1 e0 02             	shl    $0x2,%eax
  800552:	01 d0                	add    %edx,%eax
  800554:	85 c0                	test   %eax,%eax
  800556:	79 05                	jns    80055d <_main+0x525>
  800558:	05 ff 0f 00 00       	add    $0xfff,%eax
  80055d:	c1 f8 0c             	sar    $0xc,%eax
  800560:	39 c1                	cmp    %eax,%ecx
  800562:	74 14                	je     800578 <_main+0x540>
  800564:	83 ec 04             	sub    $0x4,%esp
  800567:	68 28 2a 80 00       	push   $0x802a28
  80056c:	6a 76                	push   $0x76
  80056e:	68 9c 29 80 00       	push   $0x80299c
  800573:	e8 a2 04 00 00       	call   800a1a <_panic>

		//2 MB + 8 KB Hole
		freeFrames = sys_calculate_free_frames() ;
  800578:	e8 a0 1c 00 00       	call   80221d <sys_calculate_free_frames>
  80057d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800580:	e8 1b 1d 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800585:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[6]);
  800588:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80058b:	83 ec 0c             	sub    $0xc,%esp
  80058e:	50                   	push   %eax
  80058f:	e8 6d 19 00 00       	call   801f01 <free>
  800594:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 514) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  514) panic("Wrong page file free: ");
  800597:	e8 04 1d 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  80059c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80059f:	29 c2                	sub    %eax,%edx
  8005a1:	89 d0                	mov    %edx,%eax
  8005a3:	3d 02 02 00 00       	cmp    $0x202,%eax
  8005a8:	74 14                	je     8005be <_main+0x586>
  8005aa:	83 ec 04             	sub    $0x4,%esp
  8005ad:	68 45 2a 80 00       	push   $0x802a45
  8005b2:	6a 7d                	push   $0x7d
  8005b4:	68 9c 29 80 00       	push   $0x80299c
  8005b9:	e8 5c 04 00 00       	call   800a1a <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005be:	e8 5a 1c 00 00       	call   80221d <sys_calculate_free_frames>
  8005c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  8005c6:	e8 d5 1c 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  8005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[1]);
  8005ce:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8005d1:	83 ec 0c             	sub    $0xc,%esp
  8005d4:	50                   	push   %eax
  8005d5:	e8 27 19 00 00       	call   801f01 <free>
  8005da:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages() ) !=  512) panic("Wrong page file free: ");
  8005dd:	e8 be 1c 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  8005e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e5:	29 c2                	sub    %eax,%edx
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	3d 00 02 00 00       	cmp    $0x200,%eax
  8005ee:	74 17                	je     800607 <_main+0x5cf>
  8005f0:	83 ec 04             	sub    $0x4,%esp
  8005f3:	68 45 2a 80 00       	push   $0x802a45
  8005f8:	68 84 00 00 00       	push   $0x84
  8005fd:	68 9c 29 80 00       	push   $0x80299c
  800602:	e8 13 04 00 00       	call   800a1a <_panic>

		//2 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800607:	e8 11 1c 00 00       	call   80221d <sys_calculate_free_frames>
  80060c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80060f:	e8 8c 1c 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800614:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[8] = malloc(2*Mega-kilo);
  800617:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80061a:	01 c0                	add    %eax,%eax
  80061c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80061f:	83 ec 0c             	sub    $0xc,%esp
  800622:	50                   	push   %eax
  800623:	e8 1e 14 00 00       	call   801a46 <malloc>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	89 45 b0             	mov    %eax,-0x50(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 7*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80062e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800631:	89 c1                	mov    %eax,%ecx
  800633:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800636:	89 d0                	mov    %edx,%eax
  800638:	01 c0                	add    %eax,%eax
  80063a:	01 d0                	add    %edx,%eax
  80063c:	01 c0                	add    %eax,%eax
  80063e:	01 d0                	add    %edx,%eax
  800640:	89 c2                	mov    %eax,%edx
  800642:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800645:	c1 e0 04             	shl    $0x4,%eax
  800648:	01 d0                	add    %edx,%eax
  80064a:	05 00 00 00 80       	add    $0x80000000,%eax
  80064f:	39 c1                	cmp    %eax,%ecx
  800651:	74 17                	je     80066a <_main+0x632>
  800653:	83 ec 04             	sub    $0x4,%esp
  800656:	68 f8 29 80 00       	push   $0x8029f8
  80065b:	68 8a 00 00 00       	push   $0x8a
  800660:	68 9c 29 80 00       	push   $0x80299c
  800665:	e8 b0 03 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  512) panic("Wrong page file allocation: ");
  80066a:	e8 31 1c 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  80066f:	2b 45 e0             	sub    -0x20(%ebp),%eax
  800672:	3d 00 02 00 00       	cmp    $0x200,%eax
  800677:	74 17                	je     800690 <_main+0x658>
  800679:	83 ec 04             	sub    $0x4,%esp
  80067c:	68 28 2a 80 00       	push   $0x802a28
  800681:	68 8c 00 00 00       	push   $0x8c
  800686:	68 9c 29 80 00       	push   $0x80299c
  80068b:	e8 8a 03 00 00       	call   800a1a <_panic>

		//6 KB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800690:	e8 88 1b 00 00       	call   80221d <sys_calculate_free_frames>
  800695:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800698:	e8 03 1c 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  80069d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[9] = malloc(6*kilo);
  8006a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8006a3:	89 d0                	mov    %edx,%eax
  8006a5:	01 c0                	add    %eax,%eax
  8006a7:	01 d0                	add    %edx,%eax
  8006a9:	01 c0                	add    %eax,%eax
  8006ab:	83 ec 0c             	sub    $0xc,%esp
  8006ae:	50                   	push   %eax
  8006af:	e8 92 13 00 00       	call   801a46 <malloc>
  8006b4:	83 c4 10             	add    $0x10,%esp
  8006b7:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		if ((uint32) ptr_allocations[9] != (USER_HEAP_START + 9*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  8006ba:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8006bd:	89 c1                	mov    %eax,%ecx
  8006bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8006c2:	89 d0                	mov    %edx,%eax
  8006c4:	c1 e0 03             	shl    $0x3,%eax
  8006c7:	01 d0                	add    %edx,%eax
  8006c9:	89 c2                	mov    %eax,%edx
  8006cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8006ce:	c1 e0 04             	shl    $0x4,%eax
  8006d1:	01 d0                	add    %edx,%eax
  8006d3:	05 00 00 00 80       	add    $0x80000000,%eax
  8006d8:	39 c1                	cmp    %eax,%ecx
  8006da:	74 17                	je     8006f3 <_main+0x6bb>
  8006dc:	83 ec 04             	sub    $0x4,%esp
  8006df:	68 f8 29 80 00       	push   $0x8029f8
  8006e4:	68 92 00 00 00       	push   $0x92
  8006e9:	68 9c 29 80 00       	push   $0x80299c
  8006ee:	e8 27 03 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  2) panic("Wrong page file allocation: ");
  8006f3:	e8 a8 1b 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  8006f8:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8006fb:	83 f8 02             	cmp    $0x2,%eax
  8006fe:	74 17                	je     800717 <_main+0x6df>
  800700:	83 ec 04             	sub    $0x4,%esp
  800703:	68 28 2a 80 00       	push   $0x802a28
  800708:	68 94 00 00 00       	push   $0x94
  80070d:	68 9c 29 80 00       	push   $0x80299c
  800712:	e8 03 03 00 00       	call   800a1a <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  800717:	e8 01 1b 00 00       	call   80221d <sys_calculate_free_frames>
  80071c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  80071f:	e8 7c 1b 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800724:	89 45 e0             	mov    %eax,-0x20(%ebp)
		free(ptr_allocations[5]);
  800727:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80072a:	83 ec 0c             	sub    $0xc,%esp
  80072d:	50                   	push   %eax
  80072e:	e8 ce 17 00 00       	call   801f01 <free>
  800733:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if( (usedDiskPages - sys_pf_calculate_allocated_pages()) !=  768) panic("Wrong page file free: ");
  800736:	e8 65 1b 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  80073b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80073e:	29 c2                	sub    %eax,%edx
  800740:	89 d0                	mov    %edx,%eax
  800742:	3d 00 03 00 00       	cmp    $0x300,%eax
  800747:	74 17                	je     800760 <_main+0x728>
  800749:	83 ec 04             	sub    $0x4,%esp
  80074c:	68 45 2a 80 00       	push   $0x802a45
  800751:	68 9b 00 00 00       	push   $0x9b
  800756:	68 9c 29 80 00       	push   $0x80299c
  80075b:	e8 ba 02 00 00       	call   800a1a <_panic>

		//3 MB [BEST FIT Case]
		freeFrames = sys_calculate_free_frames() ;
  800760:	e8 b8 1a 00 00       	call   80221d <sys_calculate_free_frames>
  800765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800768:	e8 33 1b 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  80076d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[10] = malloc(3*Mega-kilo);
  800770:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800773:	89 c2                	mov    %eax,%edx
  800775:	01 d2                	add    %edx,%edx
  800777:	01 d0                	add    %edx,%eax
  800779:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80077c:	83 ec 0c             	sub    $0xc,%esp
  80077f:	50                   	push   %eax
  800780:	e8 c1 12 00 00       	call   801a46 <malloc>
  800785:	83 c4 10             	add    $0x10,%esp
  800788:	89 45 b8             	mov    %eax,-0x48(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 4*Mega + 16*kilo)) panic("Wrong start address for the allocated space... ");
  80078b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80078e:	89 c2                	mov    %eax,%edx
  800790:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800793:	c1 e0 02             	shl    $0x2,%eax
  800796:	89 c1                	mov    %eax,%ecx
  800798:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80079b:	c1 e0 04             	shl    $0x4,%eax
  80079e:	01 c8                	add    %ecx,%eax
  8007a0:	05 00 00 00 80       	add    $0x80000000,%eax
  8007a5:	39 c2                	cmp    %eax,%edx
  8007a7:	74 17                	je     8007c0 <_main+0x788>
  8007a9:	83 ec 04             	sub    $0x4,%esp
  8007ac:	68 f8 29 80 00       	push   $0x8029f8
  8007b1:	68 a1 00 00 00       	push   $0xa1
  8007b6:	68 9c 29 80 00       	push   $0x80299c
  8007bb:	e8 5a 02 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 3*Mega/4096 ) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  3*Mega/4096) panic("Wrong page file allocation: ");
  8007c0:	e8 db 1a 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  8007c5:	2b 45 e0             	sub    -0x20(%ebp),%eax
  8007c8:	89 c2                	mov    %eax,%edx
  8007ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cd:	89 c1                	mov    %eax,%ecx
  8007cf:	01 c9                	add    %ecx,%ecx
  8007d1:	01 c8                	add    %ecx,%eax
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	79 05                	jns    8007dc <_main+0x7a4>
  8007d7:	05 ff 0f 00 00       	add    $0xfff,%eax
  8007dc:	c1 f8 0c             	sar    $0xc,%eax
  8007df:	39 c2                	cmp    %eax,%edx
  8007e1:	74 17                	je     8007fa <_main+0x7c2>
  8007e3:	83 ec 04             	sub    $0x4,%esp
  8007e6:	68 28 2a 80 00       	push   $0x802a28
  8007eb:	68 a3 00 00 00       	push   $0xa3
  8007f0:	68 9c 29 80 00       	push   $0x80299c
  8007f5:	e8 20 02 00 00       	call   800a1a <_panic>

		//4 MB
		freeFrames = sys_calculate_free_frames() ;
  8007fa:	e8 1e 1a 00 00       	call   80221d <sys_calculate_free_frames>
  8007ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages();
  800802:	e8 99 1a 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800807:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[11] = malloc(4*Mega-kilo);
  80080a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80080d:	c1 e0 02             	shl    $0x2,%eax
  800810:	2b 45 e8             	sub    -0x18(%ebp),%eax
  800813:	83 ec 0c             	sub    $0xc,%esp
  800816:	50                   	push   %eax
  800817:	e8 2a 12 00 00       	call   801a46 <malloc>
  80081c:	83 c4 10             	add    $0x10,%esp
  80081f:	89 45 bc             	mov    %eax,-0x44(%ebp)
		if ((uint32) ptr_allocations[11] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800822:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800825:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80082a:	74 17                	je     800843 <_main+0x80b>
  80082c:	83 ec 04             	sub    $0x4,%esp
  80082f:	68 f8 29 80 00       	push   $0x8029f8
  800834:	68 a9 00 00 00       	push   $0xa9
  800839:	68 9c 29 80 00       	push   $0x80299c
  80083e:	e8 d7 01 00 00       	call   800a1a <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 4*Mega/4096) panic("Wrong allocation: ");
		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  4*Mega/4096) panic("Wrong page file allocation: ");
  800843:	e8 58 1a 00 00       	call   8022a0 <sys_pf_calculate_allocated_pages>
  800848:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80084b:	89 c2                	mov    %eax,%edx
  80084d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800850:	c1 e0 02             	shl    $0x2,%eax
  800853:	85 c0                	test   %eax,%eax
  800855:	79 05                	jns    80085c <_main+0x824>
  800857:	05 ff 0f 00 00       	add    $0xfff,%eax
  80085c:	c1 f8 0c             	sar    $0xc,%eax
  80085f:	39 c2                	cmp    %eax,%edx
  800861:	74 17                	je     80087a <_main+0x842>
  800863:	83 ec 04             	sub    $0x4,%esp
  800866:	68 28 2a 80 00       	push   $0x802a28
  80086b:	68 ab 00 00 00       	push   $0xab
  800870:	68 9c 29 80 00       	push   $0x80299c
  800875:	e8 a0 01 00 00       	call   800a1a <_panic>
	//	b) Attempt to allocate large segment with no suitable fragment to fit on
	{
		//Large Allocation
		//int freeFrames = sys_calculate_free_frames() ;
		//usedDiskPages = sys_pf_calculate_allocated_pages();
		ptr_allocations[12] = malloc((USER_HEAP_MAX - USER_HEAP_START - 14*Mega));
  80087a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80087d:	89 d0                	mov    %edx,%eax
  80087f:	01 c0                	add    %eax,%eax
  800881:	01 d0                	add    %edx,%eax
  800883:	01 c0                	add    %eax,%eax
  800885:	01 d0                	add    %edx,%eax
  800887:	01 c0                	add    %eax,%eax
  800889:	f7 d8                	neg    %eax
  80088b:	05 00 00 00 20       	add    $0x20000000,%eax
  800890:	83 ec 0c             	sub    $0xc,%esp
  800893:	50                   	push   %eax
  800894:	e8 ad 11 00 00       	call   801a46 <malloc>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	89 45 c0             	mov    %eax,-0x40(%ebp)
		if (ptr_allocations[12] != NULL) panic("Malloc: Attempt to allocate large segment with no suitable fragment to fit on, should return NULL");
  80089f:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8008a2:	85 c0                	test   %eax,%eax
  8008a4:	74 17                	je     8008bd <_main+0x885>
  8008a6:	83 ec 04             	sub    $0x4,%esp
  8008a9:	68 5c 2a 80 00       	push   $0x802a5c
  8008ae:	68 b4 00 00 00       	push   $0xb4
  8008b3:	68 9c 29 80 00       	push   $0x80299c
  8008b8:	e8 5d 01 00 00       	call   800a1a <_panic>

		cprintf("Congratulations!! test BEST FIT allocation (2) completed successfully.\n");
  8008bd:	83 ec 0c             	sub    $0xc,%esp
  8008c0:	68 c0 2a 80 00       	push   $0x802ac0
  8008c5:	e8 f2 03 00 00       	call   800cbc <cprintf>
  8008ca:	83 c4 10             	add    $0x10,%esp

		return;
  8008cd:	90                   	nop
	}
}
  8008ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8008d1:	5b                   	pop    %ebx
  8008d2:	5f                   	pop    %edi
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8008db:	e8 72 18 00 00       	call   802152 <sys_getenvindex>
  8008e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8008e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008e6:	89 d0                	mov    %edx,%eax
  8008e8:	c1 e0 03             	shl    $0x3,%eax
  8008eb:	01 d0                	add    %edx,%eax
  8008ed:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
  8008f4:	01 c8                	add    %ecx,%eax
  8008f6:	01 c0                	add    %eax,%eax
  8008f8:	01 d0                	add    %edx,%eax
  8008fa:	01 c0                	add    %eax,%eax
  8008fc:	01 d0                	add    %edx,%eax
  8008fe:	89 c2                	mov    %eax,%edx
  800900:	c1 e2 05             	shl    $0x5,%edx
  800903:	29 c2                	sub    %eax,%edx
  800905:	8d 04 d5 00 00 00 00 	lea    0x0(,%edx,8),%eax
  80090c:	89 c2                	mov    %eax,%edx
  80090e:	8d 82 00 00 c0 ee    	lea    -0x11400000(%edx),%eax
  800914:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800919:	a1 20 40 80 00       	mov    0x804020,%eax
  80091e:	8a 80 40 3c 01 00    	mov    0x13c40(%eax),%al
  800924:	84 c0                	test   %al,%al
  800926:	74 0f                	je     800937 <libmain+0x62>
		binaryname = myEnv->prog_name;
  800928:	a1 20 40 80 00       	mov    0x804020,%eax
  80092d:	05 40 3c 01 00       	add    $0x13c40,%eax
  800932:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800937:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80093b:	7e 0a                	jle    800947 <libmain+0x72>
		binaryname = argv[0];
  80093d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800940:	8b 00                	mov    (%eax),%eax
  800942:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800947:	83 ec 08             	sub    $0x8,%esp
  80094a:	ff 75 0c             	pushl  0xc(%ebp)
  80094d:	ff 75 08             	pushl  0x8(%ebp)
  800950:	e8 e3 f6 ff ff       	call   800038 <_main>
  800955:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800958:	e8 90 19 00 00       	call   8022ed <sys_disable_interrupt>
	cprintf("**************************************\n");
  80095d:	83 ec 0c             	sub    $0xc,%esp
  800960:	68 20 2b 80 00       	push   $0x802b20
  800965:	e8 52 03 00 00       	call   800cbc <cprintf>
  80096a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80096d:	a1 20 40 80 00       	mov    0x804020,%eax
  800972:	8b 90 30 3c 01 00    	mov    0x13c30(%eax),%edx
  800978:	a1 20 40 80 00       	mov    0x804020,%eax
  80097d:	8b 80 20 3c 01 00    	mov    0x13c20(%eax),%eax
  800983:	83 ec 04             	sub    $0x4,%esp
  800986:	52                   	push   %edx
  800987:	50                   	push   %eax
  800988:	68 48 2b 80 00       	push   $0x802b48
  80098d:	e8 2a 03 00 00       	call   800cbc <cprintf>
  800992:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE IN (from disk) = %d, Num of PAGE OUT (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut);
  800995:	a1 20 40 80 00       	mov    0x804020,%eax
  80099a:	8b 90 3c 3c 01 00    	mov    0x13c3c(%eax),%edx
  8009a0:	a1 20 40 80 00       	mov    0x804020,%eax
  8009a5:	8b 80 38 3c 01 00    	mov    0x13c38(%eax),%eax
  8009ab:	83 ec 04             	sub    $0x4,%esp
  8009ae:	52                   	push   %edx
  8009af:	50                   	push   %eax
  8009b0:	68 70 2b 80 00       	push   $0x802b70
  8009b5:	e8 02 03 00 00       	call   800cbc <cprintf>
  8009ba:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8009bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8009c2:	8b 80 88 3c 01 00    	mov    0x13c88(%eax),%eax
  8009c8:	83 ec 08             	sub    $0x8,%esp
  8009cb:	50                   	push   %eax
  8009cc:	68 b1 2b 80 00       	push   $0x802bb1
  8009d1:	e8 e6 02 00 00       	call   800cbc <cprintf>
  8009d6:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8009d9:	83 ec 0c             	sub    $0xc,%esp
  8009dc:	68 20 2b 80 00       	push   $0x802b20
  8009e1:	e8 d6 02 00 00       	call   800cbc <cprintf>
  8009e6:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8009e9:	e8 19 19 00 00       	call   802307 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8009ee:	e8 19 00 00 00       	call   800a0c <exit>
}
  8009f3:	90                   	nop
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    

008009f6 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	83 ec 08             	sub    $0x8,%esp
	sys_env_destroy(0);
  8009fc:	83 ec 0c             	sub    $0xc,%esp
  8009ff:	6a 00                	push   $0x0
  800a01:	e8 18 17 00 00       	call   80211e <sys_env_destroy>
  800a06:	83 c4 10             	add    $0x10,%esp
}
  800a09:	90                   	nop
  800a0a:	c9                   	leave  
  800a0b:	c3                   	ret    

00800a0c <exit>:

void
exit(void)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	83 ec 08             	sub    $0x8,%esp
	sys_env_exit();
  800a12:	e8 6d 17 00 00       	call   802184 <sys_env_exit>
}
  800a17:	90                   	nop
  800a18:	c9                   	leave  
  800a19:	c3                   	ret    

00800a1a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a20:	8d 45 10             	lea    0x10(%ebp),%eax
  800a23:	83 c0 04             	add    $0x4,%eax
  800a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800a29:	a1 18 41 80 00       	mov    0x804118,%eax
  800a2e:	85 c0                	test   %eax,%eax
  800a30:	74 16                	je     800a48 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800a32:	a1 18 41 80 00       	mov    0x804118,%eax
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	50                   	push   %eax
  800a3b:	68 c8 2b 80 00       	push   $0x802bc8
  800a40:	e8 77 02 00 00       	call   800cbc <cprintf>
  800a45:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800a48:	a1 00 40 80 00       	mov    0x804000,%eax
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	ff 75 08             	pushl  0x8(%ebp)
  800a53:	50                   	push   %eax
  800a54:	68 cd 2b 80 00       	push   $0x802bcd
  800a59:	e8 5e 02 00 00       	call   800cbc <cprintf>
  800a5e:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800a61:	8b 45 10             	mov    0x10(%ebp),%eax
  800a64:	83 ec 08             	sub    $0x8,%esp
  800a67:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6a:	50                   	push   %eax
  800a6b:	e8 e1 01 00 00       	call   800c51 <vcprintf>
  800a70:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800a73:	83 ec 08             	sub    $0x8,%esp
  800a76:	6a 00                	push   $0x0
  800a78:	68 e9 2b 80 00       	push   $0x802be9
  800a7d:	e8 cf 01 00 00       	call   800c51 <vcprintf>
  800a82:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a85:	e8 82 ff ff ff       	call   800a0c <exit>

	// should not return here
	while (1) ;
  800a8a:	eb fe                	jmp    800a8a <_panic+0x70>

00800a8c <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a92:	a1 20 40 80 00       	mov    0x804020,%eax
  800a97:	8b 50 74             	mov    0x74(%eax),%edx
  800a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9d:	39 c2                	cmp    %eax,%edx
  800a9f:	74 14                	je     800ab5 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800aa1:	83 ec 04             	sub    $0x4,%esp
  800aa4:	68 ec 2b 80 00       	push   $0x802bec
  800aa9:	6a 26                	push   $0x26
  800aab:	68 38 2c 80 00       	push   $0x802c38
  800ab0:	e8 65 ff ff ff       	call   800a1a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800ab5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800abc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ac3:	e9 b6 00 00 00       	jmp    800b7e <CheckWSWithoutLastIndex+0xf2>
		if (expectedPages[e] == 0) {
  800ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800acb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	01 d0                	add    %edx,%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	85 c0                	test   %eax,%eax
  800adb:	75 08                	jne    800ae5 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800add:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800ae0:	e9 96 00 00 00       	jmp    800b7b <CheckWSWithoutLastIndex+0xef>
		}
		int found = 0;
  800ae5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800aec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800af3:	eb 5d                	jmp    800b52 <CheckWSWithoutLastIndex+0xc6>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800af5:	a1 20 40 80 00       	mov    0x804020,%eax
  800afa:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b00:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b03:	c1 e2 04             	shl    $0x4,%edx
  800b06:	01 d0                	add    %edx,%eax
  800b08:	8a 40 04             	mov    0x4(%eax),%al
  800b0b:	84 c0                	test   %al,%al
  800b0d:	75 40                	jne    800b4f <CheckWSWithoutLastIndex+0xc3>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b0f:	a1 20 40 80 00       	mov    0x804020,%eax
  800b14:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800b1a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b1d:	c1 e2 04             	shl    $0x4,%edx
  800b20:	01 d0                	add    %edx,%eax
  800b22:	8b 00                	mov    (%eax),%eax
  800b24:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800b27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800b2a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800b2f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b34:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	01 c8                	add    %ecx,%eax
  800b40:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b42:	39 c2                	cmp    %eax,%edx
  800b44:	75 09                	jne    800b4f <CheckWSWithoutLastIndex+0xc3>
						== expectedPages[e]) {
					found = 1;
  800b46:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800b4d:	eb 12                	jmp    800b61 <CheckWSWithoutLastIndex+0xd5>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b4f:	ff 45 e8             	incl   -0x18(%ebp)
  800b52:	a1 20 40 80 00       	mov    0x804020,%eax
  800b57:	8b 50 74             	mov    0x74(%eax),%edx
  800b5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b5d:	39 c2                	cmp    %eax,%edx
  800b5f:	77 94                	ja     800af5 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800b61:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800b65:	75 14                	jne    800b7b <CheckWSWithoutLastIndex+0xef>
			panic(
  800b67:	83 ec 04             	sub    $0x4,%esp
  800b6a:	68 44 2c 80 00       	push   $0x802c44
  800b6f:	6a 3a                	push   $0x3a
  800b71:	68 38 2c 80 00       	push   $0x802c38
  800b76:	e8 9f fe ff ff       	call   800a1a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b7b:	ff 45 f0             	incl   -0x10(%ebp)
  800b7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b81:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b84:	0f 8c 3e ff ff ff    	jl     800ac8 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b8a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b91:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b98:	eb 20                	jmp    800bba <CheckWSWithoutLastIndex+0x12e>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b9a:	a1 20 40 80 00       	mov    0x804020,%eax
  800b9f:	8b 80 80 3c 01 00    	mov    0x13c80(%eax),%eax
  800ba5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ba8:	c1 e2 04             	shl    $0x4,%edx
  800bab:	01 d0                	add    %edx,%eax
  800bad:	8a 40 04             	mov    0x4(%eax),%al
  800bb0:	3c 01                	cmp    $0x1,%al
  800bb2:	75 03                	jne    800bb7 <CheckWSWithoutLastIndex+0x12b>
			actualNumOfEmptyLocs++;
  800bb4:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bb7:	ff 45 e0             	incl   -0x20(%ebp)
  800bba:	a1 20 40 80 00       	mov    0x804020,%eax
  800bbf:	8b 50 74             	mov    0x74(%eax),%edx
  800bc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bc5:	39 c2                	cmp    %eax,%edx
  800bc7:	77 d1                	ja     800b9a <CheckWSWithoutLastIndex+0x10e>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bcc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800bcf:	74 14                	je     800be5 <CheckWSWithoutLastIndex+0x159>
		panic(
  800bd1:	83 ec 04             	sub    $0x4,%esp
  800bd4:	68 98 2c 80 00       	push   $0x802c98
  800bd9:	6a 44                	push   $0x44
  800bdb:	68 38 2c 80 00       	push   $0x802c38
  800be0:	e8 35 fe ff ff       	call   800a1a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800be5:	90                   	nop
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	8b 00                	mov    (%eax),%eax
  800bf3:	8d 48 01             	lea    0x1(%eax),%ecx
  800bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf9:	89 0a                	mov    %ecx,(%edx)
  800bfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800bfe:	88 d1                	mov    %dl,%cl
  800c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c03:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0a:	8b 00                	mov    (%eax),%eax
  800c0c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800c11:	75 2c                	jne    800c3f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800c13:	a0 24 40 80 00       	mov    0x804024,%al
  800c18:	0f b6 c0             	movzbl %al,%eax
  800c1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1e:	8b 12                	mov    (%edx),%edx
  800c20:	89 d1                	mov    %edx,%ecx
  800c22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c25:	83 c2 08             	add    $0x8,%edx
  800c28:	83 ec 04             	sub    $0x4,%esp
  800c2b:	50                   	push   %eax
  800c2c:	51                   	push   %ecx
  800c2d:	52                   	push   %edx
  800c2e:	e8 a9 14 00 00       	call   8020dc <sys_cputs>
  800c33:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800c3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c42:	8b 40 04             	mov    0x4(%eax),%eax
  800c45:	8d 50 01             	lea    0x1(%eax),%edx
  800c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4b:	89 50 04             	mov    %edx,0x4(%eax)
}
  800c4e:	90                   	nop
  800c4f:	c9                   	leave  
  800c50:	c3                   	ret    

00800c51 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800c5a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800c61:	00 00 00 
	b.cnt = 0;
  800c64:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c6b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c6e:	ff 75 0c             	pushl  0xc(%ebp)
  800c71:	ff 75 08             	pushl  0x8(%ebp)
  800c74:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c7a:	50                   	push   %eax
  800c7b:	68 e8 0b 80 00       	push   $0x800be8
  800c80:	e8 11 02 00 00       	call   800e96 <vprintfmt>
  800c85:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c88:	a0 24 40 80 00       	mov    0x804024,%al
  800c8d:	0f b6 c0             	movzbl %al,%eax
  800c90:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c96:	83 ec 04             	sub    $0x4,%esp
  800c99:	50                   	push   %eax
  800c9a:	52                   	push   %edx
  800c9b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800ca1:	83 c0 08             	add    $0x8,%eax
  800ca4:	50                   	push   %eax
  800ca5:	e8 32 14 00 00       	call   8020dc <sys_cputs>
  800caa:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800cad:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800cb4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800cba:	c9                   	leave  
  800cbb:	c3                   	ret    

00800cbc <cprintf>:

int cprintf(const char *fmt, ...) {
  800cbc:	55                   	push   %ebp
  800cbd:	89 e5                	mov    %esp,%ebp
  800cbf:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800cc2:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800cc9:	8d 45 0c             	lea    0xc(%ebp),%eax
  800ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	83 ec 08             	sub    $0x8,%esp
  800cd5:	ff 75 f4             	pushl  -0xc(%ebp)
  800cd8:	50                   	push   %eax
  800cd9:	e8 73 ff ff ff       	call   800c51 <vcprintf>
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800ce4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800cef:	e8 f9 15 00 00       	call   8022ed <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800cf4:	8d 45 0c             	lea    0xc(%ebp),%eax
  800cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfd:	83 ec 08             	sub    $0x8,%esp
  800d00:	ff 75 f4             	pushl  -0xc(%ebp)
  800d03:	50                   	push   %eax
  800d04:	e8 48 ff ff ff       	call   800c51 <vcprintf>
  800d09:	83 c4 10             	add    $0x10,%esp
  800d0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d0f:	e8 f3 15 00 00       	call   802307 <sys_enable_interrupt>
	return cnt;
  800d14:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d17:	c9                   	leave  
  800d18:	c3                   	ret    

00800d19 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	53                   	push   %ebx
  800d1d:	83 ec 14             	sub    $0x14,%esp
  800d20:	8b 45 10             	mov    0x10(%ebp),%eax
  800d23:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d26:	8b 45 14             	mov    0x14(%ebp),%eax
  800d29:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800d2c:	8b 45 18             	mov    0x18(%ebp),%eax
  800d2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d34:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d37:	77 55                	ja     800d8e <printnum+0x75>
  800d39:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800d3c:	72 05                	jb     800d43 <printnum+0x2a>
  800d3e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800d41:	77 4b                	ja     800d8e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800d43:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800d46:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800d49:	8b 45 18             	mov    0x18(%ebp),%eax
  800d4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800d51:	52                   	push   %edx
  800d52:	50                   	push   %eax
  800d53:	ff 75 f4             	pushl  -0xc(%ebp)
  800d56:	ff 75 f0             	pushl  -0x10(%ebp)
  800d59:	e8 b2 19 00 00       	call   802710 <__udivdi3>
  800d5e:	83 c4 10             	add    $0x10,%esp
  800d61:	83 ec 04             	sub    $0x4,%esp
  800d64:	ff 75 20             	pushl  0x20(%ebp)
  800d67:	53                   	push   %ebx
  800d68:	ff 75 18             	pushl  0x18(%ebp)
  800d6b:	52                   	push   %edx
  800d6c:	50                   	push   %eax
  800d6d:	ff 75 0c             	pushl  0xc(%ebp)
  800d70:	ff 75 08             	pushl  0x8(%ebp)
  800d73:	e8 a1 ff ff ff       	call   800d19 <printnum>
  800d78:	83 c4 20             	add    $0x20,%esp
  800d7b:	eb 1a                	jmp    800d97 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d7d:	83 ec 08             	sub    $0x8,%esp
  800d80:	ff 75 0c             	pushl  0xc(%ebp)
  800d83:	ff 75 20             	pushl  0x20(%ebp)
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	ff d0                	call   *%eax
  800d8b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d8e:	ff 4d 1c             	decl   0x1c(%ebp)
  800d91:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d95:	7f e6                	jg     800d7d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d97:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800da2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800da5:	53                   	push   %ebx
  800da6:	51                   	push   %ecx
  800da7:	52                   	push   %edx
  800da8:	50                   	push   %eax
  800da9:	e8 72 1a 00 00       	call   802820 <__umoddi3>
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	05 14 2f 80 00       	add    $0x802f14,%eax
  800db6:	8a 00                	mov    (%eax),%al
  800db8:	0f be c0             	movsbl %al,%eax
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	50                   	push   %eax
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	ff d0                	call   *%eax
  800dc7:	83 c4 10             	add    $0x10,%esp
}
  800dca:	90                   	nop
  800dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800dce:	c9                   	leave  
  800dcf:	c3                   	ret    

00800dd0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dd7:	7e 1c                	jle    800df5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddc:	8b 00                	mov    (%eax),%eax
  800dde:	8d 50 08             	lea    0x8(%eax),%edx
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	89 10                	mov    %edx,(%eax)
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8b 00                	mov    (%eax),%eax
  800deb:	83 e8 08             	sub    $0x8,%eax
  800dee:	8b 50 04             	mov    0x4(%eax),%edx
  800df1:	8b 00                	mov    (%eax),%eax
  800df3:	eb 40                	jmp    800e35 <getuint+0x65>
	else if (lflag)
  800df5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800df9:	74 1e                	je     800e19 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	8b 00                	mov    (%eax),%eax
  800e00:	8d 50 04             	lea    0x4(%eax),%edx
  800e03:	8b 45 08             	mov    0x8(%ebp),%eax
  800e06:	89 10                	mov    %edx,(%eax)
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0b:	8b 00                	mov    (%eax),%eax
  800e0d:	83 e8 04             	sub    $0x4,%eax
  800e10:	8b 00                	mov    (%eax),%eax
  800e12:	ba 00 00 00 00       	mov    $0x0,%edx
  800e17:	eb 1c                	jmp    800e35 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	8b 00                	mov    (%eax),%eax
  800e1e:	8d 50 04             	lea    0x4(%eax),%edx
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	89 10                	mov    %edx,(%eax)
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	8b 00                	mov    (%eax),%eax
  800e2b:	83 e8 04             	sub    $0x4,%eax
  800e2e:	8b 00                	mov    (%eax),%eax
  800e30:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800e35:	5d                   	pop    %ebp
  800e36:	c3                   	ret    

00800e37 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e3a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e3e:	7e 1c                	jle    800e5c <getint+0x25>
		return va_arg(*ap, long long);
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8b 00                	mov    (%eax),%eax
  800e45:	8d 50 08             	lea    0x8(%eax),%edx
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	89 10                	mov    %edx,(%eax)
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8b 00                	mov    (%eax),%eax
  800e52:	83 e8 08             	sub    $0x8,%eax
  800e55:	8b 50 04             	mov    0x4(%eax),%edx
  800e58:	8b 00                	mov    (%eax),%eax
  800e5a:	eb 38                	jmp    800e94 <getint+0x5d>
	else if (lflag)
  800e5c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e60:	74 1a                	je     800e7c <getint+0x45>
		return va_arg(*ap, long);
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	8b 00                	mov    (%eax),%eax
  800e67:	8d 50 04             	lea    0x4(%eax),%edx
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	89 10                	mov    %edx,(%eax)
  800e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e72:	8b 00                	mov    (%eax),%eax
  800e74:	83 e8 04             	sub    $0x4,%eax
  800e77:	8b 00                	mov    (%eax),%eax
  800e79:	99                   	cltd   
  800e7a:	eb 18                	jmp    800e94 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7f:	8b 00                	mov    (%eax),%eax
  800e81:	8d 50 04             	lea    0x4(%eax),%edx
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	89 10                	mov    %edx,(%eax)
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	8b 00                	mov    (%eax),%eax
  800e8e:	83 e8 04             	sub    $0x4,%eax
  800e91:	8b 00                	mov    (%eax),%eax
  800e93:	99                   	cltd   
}
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    

00800e96 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e96:	55                   	push   %ebp
  800e97:	89 e5                	mov    %esp,%ebp
  800e99:	56                   	push   %esi
  800e9a:	53                   	push   %ebx
  800e9b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e9e:	eb 17                	jmp    800eb7 <vprintfmt+0x21>
			if (ch == '\0')
  800ea0:	85 db                	test   %ebx,%ebx
  800ea2:	0f 84 af 03 00 00    	je     801257 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ea8:	83 ec 08             	sub    $0x8,%esp
  800eab:	ff 75 0c             	pushl  0xc(%ebp)
  800eae:	53                   	push   %ebx
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb2:	ff d0                	call   *%eax
  800eb4:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	8d 50 01             	lea    0x1(%eax),%edx
  800ebd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec0:	8a 00                	mov    (%eax),%al
  800ec2:	0f b6 d8             	movzbl %al,%ebx
  800ec5:	83 fb 25             	cmp    $0x25,%ebx
  800ec8:	75 d6                	jne    800ea0 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800eca:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ece:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800ed5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800edc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800ee3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800eea:	8b 45 10             	mov    0x10(%ebp),%eax
  800eed:	8d 50 01             	lea    0x1(%eax),%edx
  800ef0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	0f b6 d8             	movzbl %al,%ebx
  800ef8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800efb:	83 f8 55             	cmp    $0x55,%eax
  800efe:	0f 87 2b 03 00 00    	ja     80122f <vprintfmt+0x399>
  800f04:	8b 04 85 38 2f 80 00 	mov    0x802f38(,%eax,4),%eax
  800f0b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f0d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800f11:	eb d7                	jmp    800eea <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800f13:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800f17:	eb d1                	jmp    800eea <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f19:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800f20:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f23:	89 d0                	mov    %edx,%eax
  800f25:	c1 e0 02             	shl    $0x2,%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	01 c0                	add    %eax,%eax
  800f2c:	01 d8                	add    %ebx,%eax
  800f2e:	83 e8 30             	sub    $0x30,%eax
  800f31:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800f34:	8b 45 10             	mov    0x10(%ebp),%eax
  800f37:	8a 00                	mov    (%eax),%al
  800f39:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800f3c:	83 fb 2f             	cmp    $0x2f,%ebx
  800f3f:	7e 3e                	jle    800f7f <vprintfmt+0xe9>
  800f41:	83 fb 39             	cmp    $0x39,%ebx
  800f44:	7f 39                	jg     800f7f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800f46:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800f49:	eb d5                	jmp    800f20 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800f4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4e:	83 c0 04             	add    $0x4,%eax
  800f51:	89 45 14             	mov    %eax,0x14(%ebp)
  800f54:	8b 45 14             	mov    0x14(%ebp),%eax
  800f57:	83 e8 04             	sub    $0x4,%eax
  800f5a:	8b 00                	mov    (%eax),%eax
  800f5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800f5f:	eb 1f                	jmp    800f80 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800f61:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f65:	79 83                	jns    800eea <vprintfmt+0x54>
				width = 0;
  800f67:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f6e:	e9 77 ff ff ff       	jmp    800eea <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f73:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f7a:	e9 6b ff ff ff       	jmp    800eea <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f7f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f84:	0f 89 60 ff ff ff    	jns    800eea <vprintfmt+0x54>
				width = precision, precision = -1;
  800f8a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f90:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f97:	e9 4e ff ff ff       	jmp    800eea <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f9c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f9f:	e9 46 ff ff ff       	jmp    800eea <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800fa4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fa7:	83 c0 04             	add    $0x4,%eax
  800faa:	89 45 14             	mov    %eax,0x14(%ebp)
  800fad:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb0:	83 e8 04             	sub    $0x4,%eax
  800fb3:	8b 00                	mov    (%eax),%eax
  800fb5:	83 ec 08             	sub    $0x8,%esp
  800fb8:	ff 75 0c             	pushl  0xc(%ebp)
  800fbb:	50                   	push   %eax
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	ff d0                	call   *%eax
  800fc1:	83 c4 10             	add    $0x10,%esp
			break;
  800fc4:	e9 89 02 00 00       	jmp    801252 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800fc9:	8b 45 14             	mov    0x14(%ebp),%eax
  800fcc:	83 c0 04             	add    $0x4,%eax
  800fcf:	89 45 14             	mov    %eax,0x14(%ebp)
  800fd2:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd5:	83 e8 04             	sub    $0x4,%eax
  800fd8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800fda:	85 db                	test   %ebx,%ebx
  800fdc:	79 02                	jns    800fe0 <vprintfmt+0x14a>
				err = -err;
  800fde:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800fe0:	83 fb 64             	cmp    $0x64,%ebx
  800fe3:	7f 0b                	jg     800ff0 <vprintfmt+0x15a>
  800fe5:	8b 34 9d 80 2d 80 00 	mov    0x802d80(,%ebx,4),%esi
  800fec:	85 f6                	test   %esi,%esi
  800fee:	75 19                	jne    801009 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ff0:	53                   	push   %ebx
  800ff1:	68 25 2f 80 00       	push   $0x802f25
  800ff6:	ff 75 0c             	pushl  0xc(%ebp)
  800ff9:	ff 75 08             	pushl  0x8(%ebp)
  800ffc:	e8 5e 02 00 00       	call   80125f <printfmt>
  801001:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801004:	e9 49 02 00 00       	jmp    801252 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801009:	56                   	push   %esi
  80100a:	68 2e 2f 80 00       	push   $0x802f2e
  80100f:	ff 75 0c             	pushl  0xc(%ebp)
  801012:	ff 75 08             	pushl  0x8(%ebp)
  801015:	e8 45 02 00 00       	call   80125f <printfmt>
  80101a:	83 c4 10             	add    $0x10,%esp
			break;
  80101d:	e9 30 02 00 00       	jmp    801252 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801022:	8b 45 14             	mov    0x14(%ebp),%eax
  801025:	83 c0 04             	add    $0x4,%eax
  801028:	89 45 14             	mov    %eax,0x14(%ebp)
  80102b:	8b 45 14             	mov    0x14(%ebp),%eax
  80102e:	83 e8 04             	sub    $0x4,%eax
  801031:	8b 30                	mov    (%eax),%esi
  801033:	85 f6                	test   %esi,%esi
  801035:	75 05                	jne    80103c <vprintfmt+0x1a6>
				p = "(null)";
  801037:	be 31 2f 80 00       	mov    $0x802f31,%esi
			if (width > 0 && padc != '-')
  80103c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801040:	7e 6d                	jle    8010af <vprintfmt+0x219>
  801042:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801046:	74 67                	je     8010af <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801048:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80104b:	83 ec 08             	sub    $0x8,%esp
  80104e:	50                   	push   %eax
  80104f:	56                   	push   %esi
  801050:	e8 0c 03 00 00       	call   801361 <strnlen>
  801055:	83 c4 10             	add    $0x10,%esp
  801058:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80105b:	eb 16                	jmp    801073 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80105d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801061:	83 ec 08             	sub    $0x8,%esp
  801064:	ff 75 0c             	pushl  0xc(%ebp)
  801067:	50                   	push   %eax
  801068:	8b 45 08             	mov    0x8(%ebp),%eax
  80106b:	ff d0                	call   *%eax
  80106d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801070:	ff 4d e4             	decl   -0x1c(%ebp)
  801073:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801077:	7f e4                	jg     80105d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801079:	eb 34                	jmp    8010af <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80107b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80107f:	74 1c                	je     80109d <vprintfmt+0x207>
  801081:	83 fb 1f             	cmp    $0x1f,%ebx
  801084:	7e 05                	jle    80108b <vprintfmt+0x1f5>
  801086:	83 fb 7e             	cmp    $0x7e,%ebx
  801089:	7e 12                	jle    80109d <vprintfmt+0x207>
					putch('?', putdat);
  80108b:	83 ec 08             	sub    $0x8,%esp
  80108e:	ff 75 0c             	pushl  0xc(%ebp)
  801091:	6a 3f                	push   $0x3f
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	ff d0                	call   *%eax
  801098:	83 c4 10             	add    $0x10,%esp
  80109b:	eb 0f                	jmp    8010ac <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80109d:	83 ec 08             	sub    $0x8,%esp
  8010a0:	ff 75 0c             	pushl  0xc(%ebp)
  8010a3:	53                   	push   %ebx
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	ff d0                	call   *%eax
  8010a9:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8010ac:	ff 4d e4             	decl   -0x1c(%ebp)
  8010af:	89 f0                	mov    %esi,%eax
  8010b1:	8d 70 01             	lea    0x1(%eax),%esi
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	0f be d8             	movsbl %al,%ebx
  8010b9:	85 db                	test   %ebx,%ebx
  8010bb:	74 24                	je     8010e1 <vprintfmt+0x24b>
  8010bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010c1:	78 b8                	js     80107b <vprintfmt+0x1e5>
  8010c3:	ff 4d e0             	decl   -0x20(%ebp)
  8010c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8010ca:	79 af                	jns    80107b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010cc:	eb 13                	jmp    8010e1 <vprintfmt+0x24b>
				putch(' ', putdat);
  8010ce:	83 ec 08             	sub    $0x8,%esp
  8010d1:	ff 75 0c             	pushl  0xc(%ebp)
  8010d4:	6a 20                	push   $0x20
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	ff d0                	call   *%eax
  8010db:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8010de:	ff 4d e4             	decl   -0x1c(%ebp)
  8010e1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010e5:	7f e7                	jg     8010ce <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8010e7:	e9 66 01 00 00       	jmp    801252 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8010ec:	83 ec 08             	sub    $0x8,%esp
  8010ef:	ff 75 e8             	pushl  -0x18(%ebp)
  8010f2:	8d 45 14             	lea    0x14(%ebp),%eax
  8010f5:	50                   	push   %eax
  8010f6:	e8 3c fd ff ff       	call   800e37 <getint>
  8010fb:	83 c4 10             	add    $0x10,%esp
  8010fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801101:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801107:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110a:	85 d2                	test   %edx,%edx
  80110c:	79 23                	jns    801131 <vprintfmt+0x29b>
				putch('-', putdat);
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	ff 75 0c             	pushl  0xc(%ebp)
  801114:	6a 2d                	push   $0x2d
  801116:	8b 45 08             	mov    0x8(%ebp),%eax
  801119:	ff d0                	call   *%eax
  80111b:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80111e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801121:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801124:	f7 d8                	neg    %eax
  801126:	83 d2 00             	adc    $0x0,%edx
  801129:	f7 da                	neg    %edx
  80112b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80112e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801131:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801138:	e9 bc 00 00 00       	jmp    8011f9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  80113d:	83 ec 08             	sub    $0x8,%esp
  801140:	ff 75 e8             	pushl  -0x18(%ebp)
  801143:	8d 45 14             	lea    0x14(%ebp),%eax
  801146:	50                   	push   %eax
  801147:	e8 84 fc ff ff       	call   800dd0 <getuint>
  80114c:	83 c4 10             	add    $0x10,%esp
  80114f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801152:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801155:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80115c:	e9 98 00 00 00       	jmp    8011f9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801161:	83 ec 08             	sub    $0x8,%esp
  801164:	ff 75 0c             	pushl  0xc(%ebp)
  801167:	6a 58                	push   $0x58
  801169:	8b 45 08             	mov    0x8(%ebp),%eax
  80116c:	ff d0                	call   *%eax
  80116e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801171:	83 ec 08             	sub    $0x8,%esp
  801174:	ff 75 0c             	pushl  0xc(%ebp)
  801177:	6a 58                	push   $0x58
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
  80117c:	ff d0                	call   *%eax
  80117e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801181:	83 ec 08             	sub    $0x8,%esp
  801184:	ff 75 0c             	pushl  0xc(%ebp)
  801187:	6a 58                	push   $0x58
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	ff d0                	call   *%eax
  80118e:	83 c4 10             	add    $0x10,%esp
			break;
  801191:	e9 bc 00 00 00       	jmp    801252 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801196:	83 ec 08             	sub    $0x8,%esp
  801199:	ff 75 0c             	pushl  0xc(%ebp)
  80119c:	6a 30                	push   $0x30
  80119e:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a1:	ff d0                	call   *%eax
  8011a3:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	ff 75 0c             	pushl  0xc(%ebp)
  8011ac:	6a 78                	push   $0x78
  8011ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b1:	ff d0                	call   *%eax
  8011b3:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  8011b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b9:	83 c0 04             	add    $0x4,%eax
  8011bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8011bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c2:	83 e8 04             	sub    $0x4,%eax
  8011c5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  8011c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  8011d1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  8011d8:	eb 1f                	jmp    8011f9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8011da:	83 ec 08             	sub    $0x8,%esp
  8011dd:	ff 75 e8             	pushl  -0x18(%ebp)
  8011e0:	8d 45 14             	lea    0x14(%ebp),%eax
  8011e3:	50                   	push   %eax
  8011e4:	e8 e7 fb ff ff       	call   800dd0 <getuint>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8011f2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8011f9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8011fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801200:	83 ec 04             	sub    $0x4,%esp
  801203:	52                   	push   %edx
  801204:	ff 75 e4             	pushl  -0x1c(%ebp)
  801207:	50                   	push   %eax
  801208:	ff 75 f4             	pushl  -0xc(%ebp)
  80120b:	ff 75 f0             	pushl  -0x10(%ebp)
  80120e:	ff 75 0c             	pushl  0xc(%ebp)
  801211:	ff 75 08             	pushl  0x8(%ebp)
  801214:	e8 00 fb ff ff       	call   800d19 <printnum>
  801219:	83 c4 20             	add    $0x20,%esp
			break;
  80121c:	eb 34                	jmp    801252 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80121e:	83 ec 08             	sub    $0x8,%esp
  801221:	ff 75 0c             	pushl  0xc(%ebp)
  801224:	53                   	push   %ebx
  801225:	8b 45 08             	mov    0x8(%ebp),%eax
  801228:	ff d0                	call   *%eax
  80122a:	83 c4 10             	add    $0x10,%esp
			break;
  80122d:	eb 23                	jmp    801252 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80122f:	83 ec 08             	sub    $0x8,%esp
  801232:	ff 75 0c             	pushl  0xc(%ebp)
  801235:	6a 25                	push   $0x25
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	ff d0                	call   *%eax
  80123c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  80123f:	ff 4d 10             	decl   0x10(%ebp)
  801242:	eb 03                	jmp    801247 <vprintfmt+0x3b1>
  801244:	ff 4d 10             	decl   0x10(%ebp)
  801247:	8b 45 10             	mov    0x10(%ebp),%eax
  80124a:	48                   	dec    %eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	3c 25                	cmp    $0x25,%al
  80124f:	75 f3                	jne    801244 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801251:	90                   	nop
		}
	}
  801252:	e9 47 fc ff ff       	jmp    800e9e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801257:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801258:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80125b:	5b                   	pop    %ebx
  80125c:	5e                   	pop    %esi
  80125d:	5d                   	pop    %ebp
  80125e:	c3                   	ret    

0080125f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801265:	8d 45 10             	lea    0x10(%ebp),%eax
  801268:	83 c0 04             	add    $0x4,%eax
  80126b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80126e:	8b 45 10             	mov    0x10(%ebp),%eax
  801271:	ff 75 f4             	pushl  -0xc(%ebp)
  801274:	50                   	push   %eax
  801275:	ff 75 0c             	pushl  0xc(%ebp)
  801278:	ff 75 08             	pushl  0x8(%ebp)
  80127b:	e8 16 fc ff ff       	call   800e96 <vprintfmt>
  801280:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801283:	90                   	nop
  801284:	c9                   	leave  
  801285:	c3                   	ret    

00801286 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801289:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128c:	8b 40 08             	mov    0x8(%eax),%eax
  80128f:	8d 50 01             	lea    0x1(%eax),%edx
  801292:	8b 45 0c             	mov    0xc(%ebp),%eax
  801295:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801298:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129b:	8b 10                	mov    (%eax),%edx
  80129d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a0:	8b 40 04             	mov    0x4(%eax),%eax
  8012a3:	39 c2                	cmp    %eax,%edx
  8012a5:	73 12                	jae    8012b9 <sprintputch+0x33>
		*b->buf++ = ch;
  8012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012aa:	8b 00                	mov    (%eax),%eax
  8012ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8012af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012b2:	89 0a                	mov    %ecx,(%edx)
  8012b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b7:	88 10                	mov    %dl,(%eax)
}
  8012b9:	90                   	nop
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    

008012bc <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8012bc:	55                   	push   %ebp
  8012bd:	89 e5                	mov    %esp,%ebp
  8012bf:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  8012c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8012c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012cb:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d1:	01 d0                	add    %edx,%eax
  8012d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8012d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8012dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e1:	74 06                	je     8012e9 <vsnprintf+0x2d>
  8012e3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012e7:	7f 07                	jg     8012f0 <vsnprintf+0x34>
		return -E_INVAL;
  8012e9:	b8 03 00 00 00       	mov    $0x3,%eax
  8012ee:	eb 20                	jmp    801310 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8012f0:	ff 75 14             	pushl  0x14(%ebp)
  8012f3:	ff 75 10             	pushl  0x10(%ebp)
  8012f6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012f9:	50                   	push   %eax
  8012fa:	68 86 12 80 00       	push   $0x801286
  8012ff:	e8 92 fb ff ff       	call   800e96 <vprintfmt>
  801304:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801307:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80130a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80130d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801310:	c9                   	leave  
  801311:	c3                   	ret    

00801312 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801318:	8d 45 10             	lea    0x10(%ebp),%eax
  80131b:	83 c0 04             	add    $0x4,%eax
  80131e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801321:	8b 45 10             	mov    0x10(%ebp),%eax
  801324:	ff 75 f4             	pushl  -0xc(%ebp)
  801327:	50                   	push   %eax
  801328:	ff 75 0c             	pushl  0xc(%ebp)
  80132b:	ff 75 08             	pushl  0x8(%ebp)
  80132e:	e8 89 ff ff ff       	call   8012bc <vsnprintf>
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801339:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80133c:	c9                   	leave  
  80133d:	c3                   	ret    

0080133e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801344:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80134b:	eb 06                	jmp    801353 <strlen+0x15>
		n++;
  80134d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801350:	ff 45 08             	incl   0x8(%ebp)
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	75 f1                	jne    80134d <strlen+0xf>
		n++;
	return n;
  80135c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801367:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80136e:	eb 09                	jmp    801379 <strnlen+0x18>
		n++;
  801370:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801373:	ff 45 08             	incl   0x8(%ebp)
  801376:	ff 4d 0c             	decl   0xc(%ebp)
  801379:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80137d:	74 09                	je     801388 <strnlen+0x27>
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	8a 00                	mov    (%eax),%al
  801384:	84 c0                	test   %al,%al
  801386:	75 e8                	jne    801370 <strnlen+0xf>
		n++;
	return n;
  801388:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80138b:	c9                   	leave  
  80138c:	c3                   	ret    

0080138d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801393:	8b 45 08             	mov    0x8(%ebp),%eax
  801396:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801399:	90                   	nop
  80139a:	8b 45 08             	mov    0x8(%ebp),%eax
  80139d:	8d 50 01             	lea    0x1(%eax),%edx
  8013a0:	89 55 08             	mov    %edx,0x8(%ebp)
  8013a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a6:	8d 4a 01             	lea    0x1(%edx),%ecx
  8013a9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8013ac:	8a 12                	mov    (%edx),%dl
  8013ae:	88 10                	mov    %dl,(%eax)
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	84 c0                	test   %al,%al
  8013b4:	75 e4                	jne    80139a <strcpy+0xd>
		/* do nothing */;
	return ret;
  8013b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013b9:	c9                   	leave  
  8013ba:	c3                   	ret    

008013bb <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8013c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8013c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ce:	eb 1f                	jmp    8013ef <strncpy+0x34>
		*dst++ = *src;
  8013d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d3:	8d 50 01             	lea    0x1(%eax),%edx
  8013d6:	89 55 08             	mov    %edx,0x8(%ebp)
  8013d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013dc:	8a 12                	mov    (%edx),%dl
  8013de:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8013e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e3:	8a 00                	mov    (%eax),%al
  8013e5:	84 c0                	test   %al,%al
  8013e7:	74 03                	je     8013ec <strncpy+0x31>
			src++;
  8013e9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ec:	ff 45 fc             	incl   -0x4(%ebp)
  8013ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013f2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8013f5:	72 d9                	jb     8013d0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8013f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801408:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140c:	74 30                	je     80143e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80140e:	eb 16                	jmp    801426 <strlcpy+0x2a>
			*dst++ = *src++;
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	8d 50 01             	lea    0x1(%eax),%edx
  801416:	89 55 08             	mov    %edx,0x8(%ebp)
  801419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80141c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80141f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801422:	8a 12                	mov    (%edx),%dl
  801424:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801426:	ff 4d 10             	decl   0x10(%ebp)
  801429:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80142d:	74 09                	je     801438 <strlcpy+0x3c>
  80142f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801432:	8a 00                	mov    (%eax),%al
  801434:	84 c0                	test   %al,%al
  801436:	75 d8                	jne    801410 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801438:	8b 45 08             	mov    0x8(%ebp),%eax
  80143b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80143e:	8b 55 08             	mov    0x8(%ebp),%edx
  801441:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801444:	29 c2                	sub    %eax,%edx
  801446:	89 d0                	mov    %edx,%eax
}
  801448:	c9                   	leave  
  801449:	c3                   	ret    

0080144a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  80144d:	eb 06                	jmp    801455 <strcmp+0xb>
		p++, q++;
  80144f:	ff 45 08             	incl   0x8(%ebp)
  801452:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
  801458:	8a 00                	mov    (%eax),%al
  80145a:	84 c0                	test   %al,%al
  80145c:	74 0e                	je     80146c <strcmp+0x22>
  80145e:	8b 45 08             	mov    0x8(%ebp),%eax
  801461:	8a 10                	mov    (%eax),%dl
  801463:	8b 45 0c             	mov    0xc(%ebp),%eax
  801466:	8a 00                	mov    (%eax),%al
  801468:	38 c2                	cmp    %al,%dl
  80146a:	74 e3                	je     80144f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80146c:	8b 45 08             	mov    0x8(%ebp),%eax
  80146f:	8a 00                	mov    (%eax),%al
  801471:	0f b6 d0             	movzbl %al,%edx
  801474:	8b 45 0c             	mov    0xc(%ebp),%eax
  801477:	8a 00                	mov    (%eax),%al
  801479:	0f b6 c0             	movzbl %al,%eax
  80147c:	29 c2                	sub    %eax,%edx
  80147e:	89 d0                	mov    %edx,%eax
}
  801480:	5d                   	pop    %ebp
  801481:	c3                   	ret    

00801482 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801485:	eb 09                	jmp    801490 <strncmp+0xe>
		n--, p++, q++;
  801487:	ff 4d 10             	decl   0x10(%ebp)
  80148a:	ff 45 08             	incl   0x8(%ebp)
  80148d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801490:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801494:	74 17                	je     8014ad <strncmp+0x2b>
  801496:	8b 45 08             	mov    0x8(%ebp),%eax
  801499:	8a 00                	mov    (%eax),%al
  80149b:	84 c0                	test   %al,%al
  80149d:	74 0e                	je     8014ad <strncmp+0x2b>
  80149f:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a2:	8a 10                	mov    (%eax),%dl
  8014a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	38 c2                	cmp    %al,%dl
  8014ab:	74 da                	je     801487 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8014ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014b1:	75 07                	jne    8014ba <strncmp+0x38>
		return 0;
  8014b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b8:	eb 14                	jmp    8014ce <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8014ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bd:	8a 00                	mov    (%eax),%al
  8014bf:	0f b6 d0             	movzbl %al,%edx
  8014c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	0f b6 c0             	movzbl %al,%eax
  8014ca:	29 c2                	sub    %eax,%edx
  8014cc:	89 d0                	mov    %edx,%eax
}
  8014ce:	5d                   	pop    %ebp
  8014cf:	c3                   	ret    

008014d0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 04             	sub    $0x4,%esp
  8014d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014d9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8014dc:	eb 12                	jmp    8014f0 <strchr+0x20>
		if (*s == c)
  8014de:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e1:	8a 00                	mov    (%eax),%al
  8014e3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8014e6:	75 05                	jne    8014ed <strchr+0x1d>
			return (char *) s;
  8014e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014eb:	eb 11                	jmp    8014fe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014ed:	ff 45 08             	incl   0x8(%ebp)
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	84 c0                	test   %al,%al
  8014f7:	75 e5                	jne    8014de <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8014f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014fe:	c9                   	leave  
  8014ff:	c3                   	ret    

00801500 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	83 ec 04             	sub    $0x4,%esp
  801506:	8b 45 0c             	mov    0xc(%ebp),%eax
  801509:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80150c:	eb 0d                	jmp    80151b <strfind+0x1b>
		if (*s == c)
  80150e:	8b 45 08             	mov    0x8(%ebp),%eax
  801511:	8a 00                	mov    (%eax),%al
  801513:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801516:	74 0e                	je     801526 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801518:	ff 45 08             	incl   0x8(%ebp)
  80151b:	8b 45 08             	mov    0x8(%ebp),%eax
  80151e:	8a 00                	mov    (%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	75 ea                	jne    80150e <strfind+0xe>
  801524:	eb 01                	jmp    801527 <strfind+0x27>
		if (*s == c)
			break;
  801526:	90                   	nop
	return (char *) s;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801538:	8b 45 10             	mov    0x10(%ebp),%eax
  80153b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80153e:	eb 0e                	jmp    80154e <memset+0x22>
		*p++ = c;
  801540:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801543:	8d 50 01             	lea    0x1(%eax),%edx
  801546:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801549:	8b 55 0c             	mov    0xc(%ebp),%edx
  80154c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80154e:	ff 4d f8             	decl   -0x8(%ebp)
  801551:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801555:	79 e9                	jns    801540 <memset+0x14>
		*p++ = c;

	return v;
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801562:	8b 45 0c             	mov    0xc(%ebp),%eax
  801565:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801568:	8b 45 08             	mov    0x8(%ebp),%eax
  80156b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80156e:	eb 16                	jmp    801586 <memcpy+0x2a>
		*d++ = *s++;
  801570:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801579:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80157c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80157f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801582:	8a 12                	mov    (%edx),%dl
  801584:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801586:	8b 45 10             	mov    0x10(%ebp),%eax
  801589:	8d 50 ff             	lea    -0x1(%eax),%edx
  80158c:	89 55 10             	mov    %edx,0x10(%ebp)
  80158f:	85 c0                	test   %eax,%eax
  801591:	75 dd                	jne    801570 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801596:	c9                   	leave  
  801597:	c3                   	ret    

00801598 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801598:	55                   	push   %ebp
  801599:	89 e5                	mov    %esp,%ebp
  80159b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80159e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8015aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015b0:	73 50                	jae    801602 <memmove+0x6a>
  8015b2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b8:	01 d0                	add    %edx,%eax
  8015ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8015bd:	76 43                	jbe    801602 <memmove+0x6a>
		s += n;
  8015bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8015c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8015cb:	eb 10                	jmp    8015dd <memmove+0x45>
			*--d = *--s;
  8015cd:	ff 4d f8             	decl   -0x8(%ebp)
  8015d0:	ff 4d fc             	decl   -0x4(%ebp)
  8015d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d6:	8a 10                	mov    (%eax),%dl
  8015d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015db:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8015dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8015e3:	89 55 10             	mov    %edx,0x10(%ebp)
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	75 e3                	jne    8015cd <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8015ea:	eb 23                	jmp    80160f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8015ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015ef:	8d 50 01             	lea    0x1(%eax),%edx
  8015f2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015f8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015fb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8015fe:	8a 12                	mov    (%edx),%dl
  801600:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801602:	8b 45 10             	mov    0x10(%ebp),%eax
  801605:	8d 50 ff             	lea    -0x1(%eax),%edx
  801608:	89 55 10             	mov    %edx,0x10(%ebp)
  80160b:	85 c0                	test   %eax,%eax
  80160d:	75 dd                	jne    8015ec <memmove+0x54>
			*d++ = *s++;

	return dst;
  80160f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801612:	c9                   	leave  
  801613:	c3                   	ret    

00801614 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801614:	55                   	push   %ebp
  801615:	89 e5                	mov    %esp,%ebp
  801617:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801620:	8b 45 0c             	mov    0xc(%ebp),%eax
  801623:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801626:	eb 2a                	jmp    801652 <memcmp+0x3e>
		if (*s1 != *s2)
  801628:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80162b:	8a 10                	mov    (%eax),%dl
  80162d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801630:	8a 00                	mov    (%eax),%al
  801632:	38 c2                	cmp    %al,%dl
  801634:	74 16                	je     80164c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801636:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801639:	8a 00                	mov    (%eax),%al
  80163b:	0f b6 d0             	movzbl %al,%edx
  80163e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801641:	8a 00                	mov    (%eax),%al
  801643:	0f b6 c0             	movzbl %al,%eax
  801646:	29 c2                	sub    %eax,%edx
  801648:	89 d0                	mov    %edx,%eax
  80164a:	eb 18                	jmp    801664 <memcmp+0x50>
		s1++, s2++;
  80164c:	ff 45 fc             	incl   -0x4(%ebp)
  80164f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801652:	8b 45 10             	mov    0x10(%ebp),%eax
  801655:	8d 50 ff             	lea    -0x1(%eax),%edx
  801658:	89 55 10             	mov    %edx,0x10(%ebp)
  80165b:	85 c0                	test   %eax,%eax
  80165d:	75 c9                	jne    801628 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80165f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801664:	c9                   	leave  
  801665:	c3                   	ret    

00801666 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801666:	55                   	push   %ebp
  801667:	89 e5                	mov    %esp,%ebp
  801669:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80166c:	8b 55 08             	mov    0x8(%ebp),%edx
  80166f:	8b 45 10             	mov    0x10(%ebp),%eax
  801672:	01 d0                	add    %edx,%eax
  801674:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801677:	eb 15                	jmp    80168e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801679:	8b 45 08             	mov    0x8(%ebp),%eax
  80167c:	8a 00                	mov    (%eax),%al
  80167e:	0f b6 d0             	movzbl %al,%edx
  801681:	8b 45 0c             	mov    0xc(%ebp),%eax
  801684:	0f b6 c0             	movzbl %al,%eax
  801687:	39 c2                	cmp    %eax,%edx
  801689:	74 0d                	je     801698 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80168b:	ff 45 08             	incl   0x8(%ebp)
  80168e:	8b 45 08             	mov    0x8(%ebp),%eax
  801691:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801694:	72 e3                	jb     801679 <memfind+0x13>
  801696:	eb 01                	jmp    801699 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801698:	90                   	nop
	return (void *) s;
  801699:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80169c:	c9                   	leave  
  80169d:	c3                   	ret    

0080169e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80169e:	55                   	push   %ebp
  80169f:	89 e5                	mov    %esp,%ebp
  8016a1:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8016a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8016ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016b2:	eb 03                	jmp    8016b7 <strtol+0x19>
		s++;
  8016b4:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8016b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ba:	8a 00                	mov    (%eax),%al
  8016bc:	3c 20                	cmp    $0x20,%al
  8016be:	74 f4                	je     8016b4 <strtol+0x16>
  8016c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c3:	8a 00                	mov    (%eax),%al
  8016c5:	3c 09                	cmp    $0x9,%al
  8016c7:	74 eb                	je     8016b4 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8016c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cc:	8a 00                	mov    (%eax),%al
  8016ce:	3c 2b                	cmp    $0x2b,%al
  8016d0:	75 05                	jne    8016d7 <strtol+0x39>
		s++;
  8016d2:	ff 45 08             	incl   0x8(%ebp)
  8016d5:	eb 13                	jmp    8016ea <strtol+0x4c>
	else if (*s == '-')
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	8a 00                	mov    (%eax),%al
  8016dc:	3c 2d                	cmp    $0x2d,%al
  8016de:	75 0a                	jne    8016ea <strtol+0x4c>
		s++, neg = 1;
  8016e0:	ff 45 08             	incl   0x8(%ebp)
  8016e3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8016ee:	74 06                	je     8016f6 <strtol+0x58>
  8016f0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8016f4:	75 20                	jne    801716 <strtol+0x78>
  8016f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f9:	8a 00                	mov    (%eax),%al
  8016fb:	3c 30                	cmp    $0x30,%al
  8016fd:	75 17                	jne    801716 <strtol+0x78>
  8016ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801702:	40                   	inc    %eax
  801703:	8a 00                	mov    (%eax),%al
  801705:	3c 78                	cmp    $0x78,%al
  801707:	75 0d                	jne    801716 <strtol+0x78>
		s += 2, base = 16;
  801709:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80170d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801714:	eb 28                	jmp    80173e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801716:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80171a:	75 15                	jne    801731 <strtol+0x93>
  80171c:	8b 45 08             	mov    0x8(%ebp),%eax
  80171f:	8a 00                	mov    (%eax),%al
  801721:	3c 30                	cmp    $0x30,%al
  801723:	75 0c                	jne    801731 <strtol+0x93>
		s++, base = 8;
  801725:	ff 45 08             	incl   0x8(%ebp)
  801728:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80172f:	eb 0d                	jmp    80173e <strtol+0xa0>
	else if (base == 0)
  801731:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801735:	75 07                	jne    80173e <strtol+0xa0>
		base = 10;
  801737:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80173e:	8b 45 08             	mov    0x8(%ebp),%eax
  801741:	8a 00                	mov    (%eax),%al
  801743:	3c 2f                	cmp    $0x2f,%al
  801745:	7e 19                	jle    801760 <strtol+0xc2>
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	8a 00                	mov    (%eax),%al
  80174c:	3c 39                	cmp    $0x39,%al
  80174e:	7f 10                	jg     801760 <strtol+0xc2>
			dig = *s - '0';
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	8a 00                	mov    (%eax),%al
  801755:	0f be c0             	movsbl %al,%eax
  801758:	83 e8 30             	sub    $0x30,%eax
  80175b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80175e:	eb 42                	jmp    8017a2 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	8a 00                	mov    (%eax),%al
  801765:	3c 60                	cmp    $0x60,%al
  801767:	7e 19                	jle    801782 <strtol+0xe4>
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
  80176c:	8a 00                	mov    (%eax),%al
  80176e:	3c 7a                	cmp    $0x7a,%al
  801770:	7f 10                	jg     801782 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8a 00                	mov    (%eax),%al
  801777:	0f be c0             	movsbl %al,%eax
  80177a:	83 e8 57             	sub    $0x57,%eax
  80177d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801780:	eb 20                	jmp    8017a2 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801782:	8b 45 08             	mov    0x8(%ebp),%eax
  801785:	8a 00                	mov    (%eax),%al
  801787:	3c 40                	cmp    $0x40,%al
  801789:	7e 39                	jle    8017c4 <strtol+0x126>
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	8a 00                	mov    (%eax),%al
  801790:	3c 5a                	cmp    $0x5a,%al
  801792:	7f 30                	jg     8017c4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	0f be c0             	movsbl %al,%eax
  80179c:	83 e8 37             	sub    $0x37,%eax
  80179f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8017a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a5:	3b 45 10             	cmp    0x10(%ebp),%eax
  8017a8:	7d 19                	jge    8017c3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8017aa:	ff 45 08             	incl   0x8(%ebp)
  8017ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017b0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8017b4:	89 c2                	mov    %eax,%edx
  8017b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b9:	01 d0                	add    %edx,%eax
  8017bb:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8017be:	e9 7b ff ff ff       	jmp    80173e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8017c3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8017c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8017c8:	74 08                	je     8017d2 <strtol+0x134>
		*endptr = (char *) s;
  8017ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8017d2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017d6:	74 07                	je     8017df <strtol+0x141>
  8017d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017db:	f7 d8                	neg    %eax
  8017dd:	eb 03                	jmp    8017e2 <strtol+0x144>
  8017df:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <ltostr>:

void
ltostr(long value, char *str)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8017ea:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8017f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8017f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8017fc:	79 13                	jns    801811 <ltostr+0x2d>
	{
		neg = 1;
  8017fe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801805:	8b 45 0c             	mov    0xc(%ebp),%eax
  801808:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80180b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80180e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801811:	8b 45 08             	mov    0x8(%ebp),%eax
  801814:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801819:	99                   	cltd   
  80181a:	f7 f9                	idiv   %ecx
  80181c:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80181f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801822:	8d 50 01             	lea    0x1(%eax),%edx
  801825:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801828:	89 c2                	mov    %eax,%edx
  80182a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182d:	01 d0                	add    %edx,%eax
  80182f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801832:	83 c2 30             	add    $0x30,%edx
  801835:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801837:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80183a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80183f:	f7 e9                	imul   %ecx
  801841:	c1 fa 02             	sar    $0x2,%edx
  801844:	89 c8                	mov    %ecx,%eax
  801846:	c1 f8 1f             	sar    $0x1f,%eax
  801849:	29 c2                	sub    %eax,%edx
  80184b:	89 d0                	mov    %edx,%eax
  80184d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801850:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801853:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801858:	f7 e9                	imul   %ecx
  80185a:	c1 fa 02             	sar    $0x2,%edx
  80185d:	89 c8                	mov    %ecx,%eax
  80185f:	c1 f8 1f             	sar    $0x1f,%eax
  801862:	29 c2                	sub    %eax,%edx
  801864:	89 d0                	mov    %edx,%eax
  801866:	c1 e0 02             	shl    $0x2,%eax
  801869:	01 d0                	add    %edx,%eax
  80186b:	01 c0                	add    %eax,%eax
  80186d:	29 c1                	sub    %eax,%ecx
  80186f:	89 ca                	mov    %ecx,%edx
  801871:	85 d2                	test   %edx,%edx
  801873:	75 9c                	jne    801811 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801875:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80187c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80187f:	48                   	dec    %eax
  801880:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801883:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801887:	74 3d                	je     8018c6 <ltostr+0xe2>
		start = 1 ;
  801889:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801890:	eb 34                	jmp    8018c6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801892:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801895:	8b 45 0c             	mov    0xc(%ebp),%eax
  801898:	01 d0                	add    %edx,%eax
  80189a:	8a 00                	mov    (%eax),%al
  80189c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80189f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a5:	01 c2                	add    %eax,%edx
  8018a7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8018aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ad:	01 c8                	add    %ecx,%eax
  8018af:	8a 00                	mov    (%eax),%al
  8018b1:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8018b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018b9:	01 c2                	add    %eax,%edx
  8018bb:	8a 45 eb             	mov    -0x15(%ebp),%al
  8018be:	88 02                	mov    %al,(%edx)
		start++ ;
  8018c0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8018c3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8018c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8018cc:	7c c4                	jl     801892 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8018ce:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8018d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d4:	01 d0                	add    %edx,%eax
  8018d6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8018d9:	90                   	nop
  8018da:	c9                   	leave  
  8018db:	c3                   	ret    

008018dc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8018e2:	ff 75 08             	pushl  0x8(%ebp)
  8018e5:	e8 54 fa ff ff       	call   80133e <strlen>
  8018ea:	83 c4 04             	add    $0x4,%esp
  8018ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8018f0:	ff 75 0c             	pushl  0xc(%ebp)
  8018f3:	e8 46 fa ff ff       	call   80133e <strlen>
  8018f8:	83 c4 04             	add    $0x4,%esp
  8018fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8018fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801905:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80190c:	eb 17                	jmp    801925 <strcconcat+0x49>
		final[s] = str1[s] ;
  80190e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801911:	8b 45 10             	mov    0x10(%ebp),%eax
  801914:	01 c2                	add    %eax,%edx
  801916:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	01 c8                	add    %ecx,%eax
  80191e:	8a 00                	mov    (%eax),%al
  801920:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801922:	ff 45 fc             	incl   -0x4(%ebp)
  801925:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801928:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80192b:	7c e1                	jl     80190e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80192d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801934:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80193b:	eb 1f                	jmp    80195c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80193d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801940:	8d 50 01             	lea    0x1(%eax),%edx
  801943:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801946:	89 c2                	mov    %eax,%edx
  801948:	8b 45 10             	mov    0x10(%ebp),%eax
  80194b:	01 c2                	add    %eax,%edx
  80194d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801950:	8b 45 0c             	mov    0xc(%ebp),%eax
  801953:	01 c8                	add    %ecx,%eax
  801955:	8a 00                	mov    (%eax),%al
  801957:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801959:	ff 45 f8             	incl   -0x8(%ebp)
  80195c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80195f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801962:	7c d9                	jl     80193d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801964:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801967:	8b 45 10             	mov    0x10(%ebp),%eax
  80196a:	01 d0                	add    %edx,%eax
  80196c:	c6 00 00             	movb   $0x0,(%eax)
}
  80196f:	90                   	nop
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80197e:	8b 45 14             	mov    0x14(%ebp),%eax
  801981:	8b 00                	mov    (%eax),%eax
  801983:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80198a:	8b 45 10             	mov    0x10(%ebp),%eax
  80198d:	01 d0                	add    %edx,%eax
  80198f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801995:	eb 0c                	jmp    8019a3 <strsplit+0x31>
			*string++ = 0;
  801997:	8b 45 08             	mov    0x8(%ebp),%eax
  80199a:	8d 50 01             	lea    0x1(%eax),%edx
  80199d:	89 55 08             	mov    %edx,0x8(%ebp)
  8019a0:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	8a 00                	mov    (%eax),%al
  8019a8:	84 c0                	test   %al,%al
  8019aa:	74 18                	je     8019c4 <strsplit+0x52>
  8019ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8019af:	8a 00                	mov    (%eax),%al
  8019b1:	0f be c0             	movsbl %al,%eax
  8019b4:	50                   	push   %eax
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	e8 13 fb ff ff       	call   8014d0 <strchr>
  8019bd:	83 c4 08             	add    $0x8,%esp
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	75 d3                	jne    801997 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8019c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c7:	8a 00                	mov    (%eax),%al
  8019c9:	84 c0                	test   %al,%al
  8019cb:	74 5a                	je     801a27 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8019cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d0:	8b 00                	mov    (%eax),%eax
  8019d2:	83 f8 0f             	cmp    $0xf,%eax
  8019d5:	75 07                	jne    8019de <strsplit+0x6c>
		{
			return 0;
  8019d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8019dc:	eb 66                	jmp    801a44 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8019de:	8b 45 14             	mov    0x14(%ebp),%eax
  8019e1:	8b 00                	mov    (%eax),%eax
  8019e3:	8d 48 01             	lea    0x1(%eax),%ecx
  8019e6:	8b 55 14             	mov    0x14(%ebp),%edx
  8019e9:	89 0a                	mov    %ecx,(%edx)
  8019eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8019f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f5:	01 c2                	add    %eax,%edx
  8019f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fa:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8019fc:	eb 03                	jmp    801a01 <strsplit+0x8f>
			string++;
  8019fe:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a01:	8b 45 08             	mov    0x8(%ebp),%eax
  801a04:	8a 00                	mov    (%eax),%al
  801a06:	84 c0                	test   %al,%al
  801a08:	74 8b                	je     801995 <strsplit+0x23>
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	8a 00                	mov    (%eax),%al
  801a0f:	0f be c0             	movsbl %al,%eax
  801a12:	50                   	push   %eax
  801a13:	ff 75 0c             	pushl  0xc(%ebp)
  801a16:	e8 b5 fa ff ff       	call   8014d0 <strchr>
  801a1b:	83 c4 08             	add    $0x8,%esp
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	74 dc                	je     8019fe <strsplit+0x8c>
			string++;
	}
  801a22:	e9 6e ff ff ff       	jmp    801995 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801a27:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801a28:	8b 45 14             	mov    0x14(%ebp),%eax
  801a2b:	8b 00                	mov    (%eax),%eax
  801a2d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a34:	8b 45 10             	mov    0x10(%ebp),%eax
  801a37:	01 d0                	add    %edx,%eax
  801a39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801a3f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <malloc>:
			uint32 end;
			int space;
		};
struct best_fit arr[10000];
void* malloc(uint32 size)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 68             	sub    $0x68,%esp
	///cprintf("size is : %d",size);
//	while(size%PAGE_SIZE!=0){
	//			size++;
		//	}

	size=ROUNDUP(size,PAGE_SIZE);
  801a4c:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  801a53:	8b 55 08             	mov    0x8(%ebp),%edx
  801a56:	8b 45 ac             	mov    -0x54(%ebp),%eax
  801a59:	01 d0                	add    %edx,%eax
  801a5b:	48                   	dec    %eax
  801a5c:	89 45 a8             	mov    %eax,-0x58(%ebp)
  801a5f:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801a62:	ba 00 00 00 00       	mov    $0x0,%edx
  801a67:	f7 75 ac             	divl   -0x54(%ebp)
  801a6a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  801a6d:	29 d0                	sub    %edx,%eax
  801a6f:	89 45 08             	mov    %eax,0x8(%ebp)

	//cprintf("sizeeeeeeeeeeee %d \n",size);

	int count2=0;
  801a72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	int flag1=0;
  801a79:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

	int ni= PAGE_SIZE;
  801a80:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)

	for(int i=0;i<count;i++){
  801a87:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801a8e:	eb 3f                	jmp    801acf <malloc+0x89>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
  801a90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801a93:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801a9a:	83 ec 04             	sub    $0x4,%esp
  801a9d:	50                   	push   %eax
  801a9e:	ff 75 e8             	pushl  -0x18(%ebp)
  801aa1:	68 90 30 80 00       	push   $0x803090
  801aa6:	e8 11 f2 ff ff       	call   800cbc <cprintf>
  801aab:	83 c4 10             	add    $0x10,%esp
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
  801aae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ab1:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801ab8:	83 ec 04             	sub    $0x4,%esp
  801abb:	50                   	push   %eax
  801abc:	ff 75 e8             	pushl  -0x18(%ebp)
  801abf:	68 a5 30 80 00       	push   $0x8030a5
  801ac4:	e8 f3 f1 ff ff       	call   800cbc <cprintf>
  801ac9:	83 c4 10             	add    $0x10,%esp

	int flag1=0;

	int ni= PAGE_SIZE;

	for(int i=0;i<count;i++){
  801acc:	ff 45 e8             	incl   -0x18(%ebp)
  801acf:	a1 28 40 80 00       	mov    0x804028,%eax
  801ad4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  801ad7:	7c b7                	jl     801a90 <malloc+0x4a>

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801ad9:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
  801ae0:	e9 42 01 00 00       	jmp    801c27 <malloc+0x1e1>
		int flag0=1;
  801ae5:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801aec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aef:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801af2:	eb 6b                	jmp    801b5f <malloc+0x119>
			for(int k=0;k<count;k++){
  801af4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801afb:	eb 42                	jmp    801b3f <malloc+0xf9>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801afd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b00:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801b07:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b0a:	39 c2                	cmp    %eax,%edx
  801b0c:	77 2e                	ja     801b3c <malloc+0xf6>
  801b0e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b11:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801b18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b1b:	39 c2                	cmp    %eax,%edx
  801b1d:	76 1d                	jbe    801b3c <malloc+0xf6>
					ni=arr_add[k].end-i;
  801b1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b22:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801b29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b2c:	29 c2                	sub    %eax,%edx
  801b2e:	89 d0                	mov    %edx,%eax
  801b30:	89 45 ec             	mov    %eax,-0x14(%ebp)
					flag1=1;
  801b33:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
					break;
  801b3a:	eb 0d                	jmp    801b49 <malloc+0x103>
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
			for(int k=0;k<count;k++){
  801b3c:	ff 45 d8             	incl   -0x28(%ebp)
  801b3f:	a1 28 40 80 00       	mov    0x804028,%eax
  801b44:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  801b47:	7c b4                	jl     801afd <malloc+0xb7>
					ni=arr_add[k].end-i;
					flag1=1;
					break;
				}
			}
			if(flag1){
  801b49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801b4d:	74 09                	je     801b58 <malloc+0x112>
				flag0=0;
  801b4f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				break;
  801b56:	eb 16                	jmp    801b6e <malloc+0x128>
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
		int flag0=1;
		for(int j=i;j<i+size;j+=PAGE_SIZE){
  801b58:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
  801b5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	01 c2                	add    %eax,%edx
  801b67:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801b6a:	39 c2                	cmp    %eax,%edx
  801b6c:	77 86                	ja     801af4 <malloc+0xae>
			if(flag1){
				flag0=0;
				break;
			}
		}
		if(flag0){
  801b6e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801b72:	0f 84 a2 00 00 00    	je     801c1a <malloc+0x1d4>

			int f=1;
  801b78:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)

			arr[count2].start=i;
  801b7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b82:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801b85:	89 c8                	mov    %ecx,%eax
  801b87:	01 c0                	add    %eax,%eax
  801b89:	01 c8                	add    %ecx,%eax
  801b8b:	c1 e0 02             	shl    $0x2,%eax
  801b8e:	05 20 41 80 00       	add    $0x804120,%eax
  801b93:	89 10                	mov    %edx,(%eax)
			arr[count2].end = i+size;
  801b95:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  801b9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba1:	89 d0                	mov    %edx,%eax
  801ba3:	01 c0                	add    %eax,%eax
  801ba5:	01 d0                	add    %edx,%eax
  801ba7:	c1 e0 02             	shl    $0x2,%eax
  801baa:	05 24 41 80 00       	add    $0x804124,%eax
  801baf:	89 08                	mov    %ecx,(%eax)
			arr[count2].space=0;
  801bb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bb4:	89 d0                	mov    %edx,%eax
  801bb6:	01 c0                	add    %eax,%eax
  801bb8:	01 d0                	add    %edx,%eax
  801bba:	c1 e0 02             	shl    $0x2,%eax
  801bbd:	05 28 41 80 00       	add    $0x804128,%eax
  801bc2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			count2++;
  801bc8:	ff 45 f4             	incl   -0xc(%ebp)

			for(int l=0;l<count;l++){
  801bcb:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801bd2:	eb 36                	jmp    801c0a <malloc+0x1c4>
				if(i+size<arr_add[l].start){
  801bd4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	01 c2                	add    %eax,%edx
  801bdc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801bdf:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801be6:	39 c2                	cmp    %eax,%edx
  801be8:	73 1d                	jae    801c07 <malloc+0x1c1>
					ni=arr_add[l].end-i;
  801bea:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801bed:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801bf4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bf7:	29 c2                	sub    %eax,%edx
  801bf9:	89 d0                	mov    %edx,%eax
  801bfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
					f=0;
  801bfe:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
					break;
  801c05:	eb 0d                	jmp    801c14 <malloc+0x1ce>
			arr[count2].start=i;
			arr[count2].end = i+size;
			arr[count2].space=0;
			count2++;

			for(int l=0;l<count;l++){
  801c07:	ff 45 d0             	incl   -0x30(%ebp)
  801c0a:	a1 28 40 80 00       	mov    0x804028,%eax
  801c0f:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  801c12:	7c c0                	jl     801bd4 <malloc+0x18e>
					break;

				}
			}

			if(f){
  801c14:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801c18:	75 1d                	jne    801c37 <malloc+0x1f1>
				break;
			}

		}

		flag1=0;
  801c1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

		cprintf("arr %d start is: %x\n",i,arr_add[i].start);
		cprintf("arr %d end is: %x\n",i,arr_add[i].end);
	}

	for(int i=USER_HEAP_START;i<(int)base_add;i+=ni){
  801c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c24:	01 45 e4             	add    %eax,-0x1c(%ebp)
  801c27:	a1 04 40 80 00       	mov    0x804004,%eax
  801c2c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801c2f:	0f 8c b0 fe ff ff    	jl     801ae5 <malloc+0x9f>
  801c35:	eb 01                	jmp    801c38 <malloc+0x1f2>

				}
			}

			if(f){
				break;
  801c37:	90                   	nop
		flag1=0;


	}

	if(count2==0){
  801c38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c3c:	75 7a                	jne    801cb8 <malloc+0x272>
		//cprintf("hellllllllOOlooo");
		if((int)(base_add+size-1)>=(int)USER_HEAP_MAX)
  801c3e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	01 d0                	add    %edx,%eax
  801c49:	48                   	dec    %eax
  801c4a:	3d 00 00 00 a0       	cmp    $0xa0000000,%eax
  801c4f:	7c 0a                	jl     801c5b <malloc+0x215>
			return NULL;
  801c51:	b8 00 00 00 00       	mov    $0x0,%eax
  801c56:	e9 a4 02 00 00       	jmp    801eff <malloc+0x4b9>
		else{
			uint32 s=base_add;
  801c5b:	a1 04 40 80 00       	mov    0x804004,%eax
  801c60:	89 45 a4             	mov    %eax,-0x5c(%ebp)
			//cprintf("s: %x",s);
			arr_add[count].start=s;
  801c63:	a1 28 40 80 00       	mov    0x804028,%eax
  801c68:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  801c6b:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
		    sys_allocateMem(s,size);
  801c72:	83 ec 08             	sub    $0x8,%esp
  801c75:	ff 75 08             	pushl  0x8(%ebp)
  801c78:	ff 75 a4             	pushl  -0x5c(%ebp)
  801c7b:	e8 04 06 00 00       	call   802284 <sys_allocateMem>
  801c80:	83 c4 10             	add    $0x10,%esp
			base_add+=size;
  801c83:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	01 d0                	add    %edx,%eax
  801c8e:	a3 04 40 80 00       	mov    %eax,0x804004
			arr_add[count].end=base_add;
  801c93:	a1 28 40 80 00       	mov    0x804028,%eax
  801c98:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c9e:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)
			count++;
  801ca5:	a1 28 40 80 00       	mov    0x804028,%eax
  801caa:	40                   	inc    %eax
  801cab:	a3 28 40 80 00       	mov    %eax,0x804028

			return (void*)s;
  801cb0:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  801cb3:	e9 47 02 00 00       	jmp    801eff <malloc+0x4b9>
	}
	else{



	for(int i=0;i<count2;i++){
  801cb8:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  801cbf:	e9 ac 00 00 00       	jmp    801d70 <malloc+0x32a>
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801cc4:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801cc7:	89 d0                	mov    %edx,%eax
  801cc9:	01 c0                	add    %eax,%eax
  801ccb:	01 d0                	add    %edx,%eax
  801ccd:	c1 e0 02             	shl    $0x2,%eax
  801cd0:	05 24 41 80 00       	add    $0x804124,%eax
  801cd5:	8b 00                	mov    (%eax),%eax
  801cd7:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801cda:	eb 7e                	jmp    801d5a <malloc+0x314>
			int flag=0;
  801cdc:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
			for(int k=0;k<count;k++){
  801ce3:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  801cea:	eb 57                	jmp    801d43 <malloc+0x2fd>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
  801cec:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801cef:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801cf6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801cf9:	39 c2                	cmp    %eax,%edx
  801cfb:	77 1a                	ja     801d17 <malloc+0x2d1>
  801cfd:	8b 45 c0             	mov    -0x40(%ebp),%eax
  801d00:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801d07:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801d0a:	39 c2                	cmp    %eax,%edx
  801d0c:	76 09                	jbe    801d17 <malloc+0x2d1>
								flag=1;
  801d0e:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
								break;}
  801d15:	eb 36                	jmp    801d4d <malloc+0x307>
			arr[i].space++;
  801d17:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801d1a:	89 d0                	mov    %edx,%eax
  801d1c:	01 c0                	add    %eax,%eax
  801d1e:	01 d0                	add    %edx,%eax
  801d20:	c1 e0 02             	shl    $0x2,%eax
  801d23:	05 28 41 80 00       	add    $0x804128,%eax
  801d28:	8b 00                	mov    (%eax),%eax
  801d2a:	8d 48 01             	lea    0x1(%eax),%ecx
  801d2d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801d30:	89 d0                	mov    %edx,%eax
  801d32:	01 c0                	add    %eax,%eax
  801d34:	01 d0                	add    %edx,%eax
  801d36:	c1 e0 02             	shl    $0x2,%eax
  801d39:	05 28 41 80 00       	add    $0x804128,%eax
  801d3e:	89 08                	mov    %ecx,(%eax)


	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
			int flag=0;
			for(int k=0;k<count;k++){
  801d40:	ff 45 c0             	incl   -0x40(%ebp)
  801d43:	a1 28 40 80 00       	mov    0x804028,%eax
  801d48:	39 45 c0             	cmp    %eax,-0x40(%ebp)
  801d4b:	7c 9f                	jl     801cec <malloc+0x2a6>
				if(j>=arr_add[k].start&&j<arr_add[k].end){
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
  801d4d:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801d51:	75 19                	jne    801d6c <malloc+0x326>
	else{



	for(int i=0;i<count2;i++){
		for(int j=arr[i].end;j<base_add;j+=PAGE_SIZE){
  801d53:	81 45 c8 00 10 00 00 	addl   $0x1000,-0x38(%ebp)
  801d5a:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801d5d:	a1 04 40 80 00       	mov    0x804004,%eax
  801d62:	39 c2                	cmp    %eax,%edx
  801d64:	0f 82 72 ff ff ff    	jb     801cdc <malloc+0x296>
  801d6a:	eb 01                	jmp    801d6d <malloc+0x327>
								flag=1;
								break;}
			arr[i].space++;
			}
			if(flag)
				break;
  801d6c:	90                   	nop
	}
	else{



	for(int i=0;i<count2;i++){
  801d6d:	ff 45 cc             	incl   -0x34(%ebp)
  801d70:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801d73:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801d76:	0f 8c 48 ff ff ff    	jl     801cc4 <malloc+0x27e>
			if(flag)
				break;
		}
	}

	int index=0;
  801d7c:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int min=9999999;
  801d83:	c7 45 b8 7f 96 98 00 	movl   $0x98967f,-0x48(%ebp)
	for(int i=0;i<count2;i++){
  801d8a:	c7 45 b4 00 00 00 00 	movl   $0x0,-0x4c(%ebp)
  801d91:	eb 37                	jmp    801dca <malloc+0x384>
		//cprintf("arr %d size is: %x\n",i,arr[i].space);
		if(arr[i].space<min){
  801d93:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801d96:	89 d0                	mov    %edx,%eax
  801d98:	01 c0                	add    %eax,%eax
  801d9a:	01 d0                	add    %edx,%eax
  801d9c:	c1 e0 02             	shl    $0x2,%eax
  801d9f:	05 28 41 80 00       	add    $0x804128,%eax
  801da4:	8b 00                	mov    (%eax),%eax
  801da6:	3b 45 b8             	cmp    -0x48(%ebp),%eax
  801da9:	7d 1c                	jge    801dc7 <malloc+0x381>
			//cprintf("arr %d size is: %x\n",i,min);
			min=arr[i].space;
  801dab:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  801dae:	89 d0                	mov    %edx,%eax
  801db0:	01 c0                	add    %eax,%eax
  801db2:	01 d0                	add    %edx,%eax
  801db4:	c1 e0 02             	shl    $0x2,%eax
  801db7:	05 28 41 80 00       	add    $0x804128,%eax
  801dbc:	8b 00                	mov    (%eax),%eax
  801dbe:	89 45 b8             	mov    %eax,-0x48(%ebp)
			index=i;
  801dc1:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801dc4:	89 45 bc             	mov    %eax,-0x44(%ebp)
		}
	}

	int index=0;
	int min=9999999;
	for(int i=0;i<count2;i++){
  801dc7:	ff 45 b4             	incl   -0x4c(%ebp)
  801dca:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  801dcd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801dd0:	7c c1                	jl     801d93 <malloc+0x34d>
			//cprintf("arr %d size is: %x\n",i,min);
			//printf("arr %d start is: %x\n",i,arr[i].start);
		}
	}

	arr_add[count].start=arr[index].start;
  801dd2:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801dd8:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801ddb:	89 c8                	mov    %ecx,%eax
  801ddd:	01 c0                	add    %eax,%eax
  801ddf:	01 c8                	add    %ecx,%eax
  801de1:	c1 e0 02             	shl    $0x2,%eax
  801de4:	05 20 41 80 00       	add    $0x804120,%eax
  801de9:	8b 00                	mov    (%eax),%eax
  801deb:	89 04 d5 e0 15 82 00 	mov    %eax,0x8215e0(,%edx,8)
	arr_add[count].end=arr[index].end;
  801df2:	8b 15 28 40 80 00    	mov    0x804028,%edx
  801df8:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801dfb:	89 c8                	mov    %ecx,%eax
  801dfd:	01 c0                	add    %eax,%eax
  801dff:	01 c8                	add    %ecx,%eax
  801e01:	c1 e0 02             	shl    $0x2,%eax
  801e04:	05 24 41 80 00       	add    $0x804124,%eax
  801e09:	8b 00                	mov    (%eax),%eax
  801e0b:	89 04 d5 e4 15 82 00 	mov    %eax,0x8215e4(,%edx,8)
	count++;
  801e12:	a1 28 40 80 00       	mov    0x804028,%eax
  801e17:	40                   	inc    %eax
  801e18:	a3 28 40 80 00       	mov    %eax,0x804028


		sys_allocateMem(arr[index].start,size);
  801e1d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801e20:	89 d0                	mov    %edx,%eax
  801e22:	01 c0                	add    %eax,%eax
  801e24:	01 d0                	add    %edx,%eax
  801e26:	c1 e0 02             	shl    $0x2,%eax
  801e29:	05 20 41 80 00       	add    $0x804120,%eax
  801e2e:	8b 00                	mov    (%eax),%eax
  801e30:	83 ec 08             	sub    $0x8,%esp
  801e33:	ff 75 08             	pushl  0x8(%ebp)
  801e36:	50                   	push   %eax
  801e37:	e8 48 04 00 00       	call   802284 <sys_allocateMem>
  801e3c:	83 c4 10             	add    $0x10,%esp

		for(int i=0;i<count2;i++){
  801e3f:	c7 45 b0 00 00 00 00 	movl   $0x0,-0x50(%ebp)
  801e46:	eb 78                	jmp    801ec0 <malloc+0x47a>

			cprintf("arr %d start is: %x\n",i,arr[i].start);
  801e48:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e4b:	89 d0                	mov    %edx,%eax
  801e4d:	01 c0                	add    %eax,%eax
  801e4f:	01 d0                	add    %edx,%eax
  801e51:	c1 e0 02             	shl    $0x2,%eax
  801e54:	05 20 41 80 00       	add    $0x804120,%eax
  801e59:	8b 00                	mov    (%eax),%eax
  801e5b:	83 ec 04             	sub    $0x4,%esp
  801e5e:	50                   	push   %eax
  801e5f:	ff 75 b0             	pushl  -0x50(%ebp)
  801e62:	68 90 30 80 00       	push   $0x803090
  801e67:	e8 50 ee ff ff       	call   800cbc <cprintf>
  801e6c:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d end is: %x\n",i,arr[i].end);
  801e6f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e72:	89 d0                	mov    %edx,%eax
  801e74:	01 c0                	add    %eax,%eax
  801e76:	01 d0                	add    %edx,%eax
  801e78:	c1 e0 02             	shl    $0x2,%eax
  801e7b:	05 24 41 80 00       	add    $0x804124,%eax
  801e80:	8b 00                	mov    (%eax),%eax
  801e82:	83 ec 04             	sub    $0x4,%esp
  801e85:	50                   	push   %eax
  801e86:	ff 75 b0             	pushl  -0x50(%ebp)
  801e89:	68 a5 30 80 00       	push   $0x8030a5
  801e8e:	e8 29 ee ff ff       	call   800cbc <cprintf>
  801e93:	83 c4 10             	add    $0x10,%esp
			cprintf("arr %d size is: %d\n",i,arr[i].space);
  801e96:	8b 55 b0             	mov    -0x50(%ebp),%edx
  801e99:	89 d0                	mov    %edx,%eax
  801e9b:	01 c0                	add    %eax,%eax
  801e9d:	01 d0                	add    %edx,%eax
  801e9f:	c1 e0 02             	shl    $0x2,%eax
  801ea2:	05 28 41 80 00       	add    $0x804128,%eax
  801ea7:	8b 00                	mov    (%eax),%eax
  801ea9:	83 ec 04             	sub    $0x4,%esp
  801eac:	50                   	push   %eax
  801ead:	ff 75 b0             	pushl  -0x50(%ebp)
  801eb0:	68 b8 30 80 00       	push   $0x8030b8
  801eb5:	e8 02 ee ff ff       	call   800cbc <cprintf>
  801eba:	83 c4 10             	add    $0x10,%esp
	count++;


		sys_allocateMem(arr[index].start,size);

		for(int i=0;i<count2;i++){
  801ebd:	ff 45 b0             	incl   -0x50(%ebp)
  801ec0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  801ec3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801ec6:	7c 80                	jl     801e48 <malloc+0x402>
			cprintf("arr %d start is: %x\n",i,arr[i].start);
			cprintf("arr %d end is: %x\n",i,arr[i].end);
			cprintf("arr %d size is: %d\n",i,arr[i].space);
			}

		cprintf("addddddddddddddddddresss %x",arr[index].start);
  801ec8:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801ecb:	89 d0                	mov    %edx,%eax
  801ecd:	01 c0                	add    %eax,%eax
  801ecf:	01 d0                	add    %edx,%eax
  801ed1:	c1 e0 02             	shl    $0x2,%eax
  801ed4:	05 20 41 80 00       	add    $0x804120,%eax
  801ed9:	8b 00                	mov    (%eax),%eax
  801edb:	83 ec 08             	sub    $0x8,%esp
  801ede:	50                   	push   %eax
  801edf:	68 cc 30 80 00       	push   $0x8030cc
  801ee4:	e8 d3 ed ff ff       	call   800cbc <cprintf>
  801ee9:	83 c4 10             	add    $0x10,%esp



		return (void*)arr[index].start;
  801eec:	8b 55 bc             	mov    -0x44(%ebp),%edx
  801eef:	89 d0                	mov    %edx,%eax
  801ef1:	01 c0                	add    %eax,%eax
  801ef3:	01 d0                	add    %edx,%eax
  801ef5:	c1 e0 02             	shl    $0x2,%eax
  801ef8:	05 20 41 80 00       	add    $0x804120,%eax
  801efd:	8b 00                	mov    (%eax),%eax

				return (void*)s;
}*/

	return NULL;
}
  801eff:	c9                   	leave  
  801f00:	c3                   	ret    

00801f01 <free>:
//		switches to the kernel mode, calls freeMem(struct Env* e, uint32 virtual_address, uint32 size) in
//		"memory_manager.c", then switch back to the user mode here
//	the freeMem function is empty, make sure to implement it.

void free(void* virtual_address)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	83 ec 28             	sub    $0x28,%esp
	//cprintf("vvvvvvvvvvvvvvvvvvv %x \n",virtual_address);

	    uint32 start;
		uint32 end;

		uint32 v = (uint32)virtual_address;
  801f07:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)

		int index;

		for(int i=0;i<count;i++){
  801f0d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  801f14:	eb 4b                	jmp    801f61 <free+0x60>
			if((int)v>=(int)arr_add[i].start&&(int)v<(int)arr_add[i].end){
  801f16:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f19:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801f20:	89 c2                	mov    %eax,%edx
  801f22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f25:	39 c2                	cmp    %eax,%edx
  801f27:	7f 35                	jg     801f5e <free+0x5d>
  801f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f2c:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801f33:	89 c2                	mov    %eax,%edx
  801f35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f38:	39 c2                	cmp    %eax,%edx
  801f3a:	7e 22                	jle    801f5e <free+0x5d>
				start=arr_add[i].start;
  801f3c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f3f:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801f46:	89 45 f4             	mov    %eax,-0xc(%ebp)
				end=arr_add[i].end;
  801f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f4c:	8b 04 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%eax
  801f53:	89 45 e0             	mov    %eax,-0x20(%ebp)
				index=i;
  801f56:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f59:	89 45 f0             	mov    %eax,-0x10(%ebp)
				break;
  801f5c:	eb 0d                	jmp    801f6b <free+0x6a>

		uint32 v = (uint32)virtual_address;

		int index;

		for(int i=0;i<count;i++){
  801f5e:	ff 45 ec             	incl   -0x14(%ebp)
  801f61:	a1 28 40 80 00       	mov    0x804028,%eax
  801f66:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  801f69:	7c ab                	jl     801f16 <free+0x15>
				break;
			}
		}


			sys_freeMem(start,arr_add[index].end-arr_add[index].start);
  801f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6e:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801f75:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f78:	8b 04 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%eax
  801f7f:	29 c2                	sub    %eax,%edx
  801f81:	89 d0                	mov    %edx,%eax
  801f83:	83 ec 08             	sub    $0x8,%esp
  801f86:	50                   	push   %eax
  801f87:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8a:	e8 d9 02 00 00       	call   802268 <sys_freeMem>
  801f8f:	83 c4 10             	add    $0x10,%esp



		for(int i=index;i<count-1;i++){
  801f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f95:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f98:	eb 2d                	jmp    801fc7 <free+0xc6>
			arr_add[i].start=arr_add[i+1].start;
  801f9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f9d:	40                   	inc    %eax
  801f9e:	8b 14 c5 e0 15 82 00 	mov    0x8215e0(,%eax,8),%edx
  801fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fa8:	89 14 c5 e0 15 82 00 	mov    %edx,0x8215e0(,%eax,8)
			arr_add[i].end=arr_add[i+1].end;
  801faf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fb2:	40                   	inc    %eax
  801fb3:	8b 14 c5 e4 15 82 00 	mov    0x8215e4(,%eax,8),%edx
  801fba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801fbd:	89 14 c5 e4 15 82 00 	mov    %edx,0x8215e4(,%eax,8)

			sys_freeMem(start,arr_add[index].end-arr_add[index].start);



		for(int i=index;i<count-1;i++){
  801fc4:	ff 45 e8             	incl   -0x18(%ebp)
  801fc7:	a1 28 40 80 00       	mov    0x804028,%eax
  801fcc:	48                   	dec    %eax
  801fcd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  801fd0:	7f c8                	jg     801f9a <free+0x99>
			arr_add[i].start=arr_add[i+1].start;
			arr_add[i].end=arr_add[i+1].end;
		}

		count--;
  801fd2:	a1 28 40 80 00       	mov    0x804028,%eax
  801fd7:	48                   	dec    %eax
  801fd8:	a3 28 40 80 00       	mov    %eax,0x804028
	///panic("free() is not implemented yet...!!");

	//you should get the size of the given allocation using its address

	//refer to the project presentation and documentation for details
}
  801fdd:	90                   	nop
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <smalloc>:
//==================================================================================//
//================================ OTHER FUNCTIONS =================================//
//==================================================================================//

void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
  801fe3:	83 ec 18             	sub    $0x18,%esp
  801fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe9:	88 45 f4             	mov    %al,-0xc(%ebp)
	panic("this function is not required...!!");
  801fec:	83 ec 04             	sub    $0x4,%esp
  801fef:	68 e8 30 80 00       	push   $0x8030e8
  801ff4:	68 18 01 00 00       	push   $0x118
  801ff9:	68 0b 31 80 00       	push   $0x80310b
  801ffe:	e8 17 ea ff ff       	call   800a1a <_panic>

00802003 <sget>:
	return 0;
}

void* sget(int32 ownerEnvID, char *sharedVarName)
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802009:	83 ec 04             	sub    $0x4,%esp
  80200c:	68 e8 30 80 00       	push   $0x8030e8
  802011:	68 1e 01 00 00       	push   $0x11e
  802016:	68 0b 31 80 00       	push   $0x80310b
  80201b:	e8 fa e9 ff ff       	call   800a1a <_panic>

00802020 <sfree>:
	return 0;
}

void sfree(void* virtual_address)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802026:	83 ec 04             	sub    $0x4,%esp
  802029:	68 e8 30 80 00       	push   $0x8030e8
  80202e:	68 24 01 00 00       	push   $0x124
  802033:	68 0b 31 80 00       	push   $0x80310b
  802038:	e8 dd e9 ff ff       	call   800a1a <_panic>

0080203d <realloc>:
}

void *realloc(void *virtual_address, uint32 new_size)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802043:	83 ec 04             	sub    $0x4,%esp
  802046:	68 e8 30 80 00       	push   $0x8030e8
  80204b:	68 29 01 00 00       	push   $0x129
  802050:	68 0b 31 80 00       	push   $0x80310b
  802055:	e8 c0 e9 ff ff       	call   800a1a <_panic>

0080205a <expand>:
	return 0;
}

void expand(uint32 newSize)
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  802060:	83 ec 04             	sub    $0x4,%esp
  802063:	68 e8 30 80 00       	push   $0x8030e8
  802068:	68 2f 01 00 00       	push   $0x12f
  80206d:	68 0b 31 80 00       	push   $0x80310b
  802072:	e8 a3 e9 ff ff       	call   800a1a <_panic>

00802077 <shrink>:
}
void shrink(uint32 newSize)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80207d:	83 ec 04             	sub    $0x4,%esp
  802080:	68 e8 30 80 00       	push   $0x8030e8
  802085:	68 33 01 00 00       	push   $0x133
  80208a:	68 0b 31 80 00       	push   $0x80310b
  80208f:	e8 86 e9 ff ff       	call   800a1a <_panic>

00802094 <freeHeap>:
}

void freeHeap(void* virtual_address)
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 08             	sub    $0x8,%esp
	panic("this function is not required...!!");
  80209a:	83 ec 04             	sub    $0x4,%esp
  80209d:	68 e8 30 80 00       	push   $0x8030e8
  8020a2:	68 38 01 00 00       	push   $0x138
  8020a7:	68 0b 31 80 00       	push   $0x80310b
  8020ac:	e8 69 e9 ff ff       	call   800a1a <_panic>

008020b1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	57                   	push   %edi
  8020b5:	56                   	push   %esi
  8020b6:	53                   	push   %ebx
  8020b7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020c6:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020c9:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020cc:	cd 30                	int    $0x30
  8020ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020d4:	83 c4 10             	add    $0x10,%esp
  8020d7:	5b                   	pop    %ebx
  8020d8:	5e                   	pop    %esi
  8020d9:	5f                   	pop    %edi
  8020da:	5d                   	pop    %ebp
  8020db:	c3                   	ret    

008020dc <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020dc:	55                   	push   %ebp
  8020dd:	89 e5                	mov    %esp,%ebp
  8020df:	83 ec 04             	sub    $0x4,%esp
  8020e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020e8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 00                	push   $0x0
  8020f3:	52                   	push   %edx
  8020f4:	ff 75 0c             	pushl  0xc(%ebp)
  8020f7:	50                   	push   %eax
  8020f8:	6a 00                	push   $0x0
  8020fa:	e8 b2 ff ff ff       	call   8020b1 <syscall>
  8020ff:	83 c4 18             	add    $0x18,%esp
}
  802102:	90                   	nop
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <sys_cgetc>:

int
sys_cgetc(void)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802108:	6a 00                	push   $0x0
  80210a:	6a 00                	push   $0x0
  80210c:	6a 00                	push   $0x0
  80210e:	6a 00                	push   $0x0
  802110:	6a 00                	push   $0x0
  802112:	6a 01                	push   $0x1
  802114:	e8 98 ff ff ff       	call   8020b1 <syscall>
  802119:	83 c4 18             	add    $0x18,%esp
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <sys_env_destroy>:

int sys_env_destroy(int32  envid)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_env_destroy, envid, 0, 0, 0, 0);
  802121:	8b 45 08             	mov    0x8(%ebp),%eax
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	50                   	push   %eax
  80212d:	6a 05                	push   $0x5
  80212f:	e8 7d ff ff ff       	call   8020b1 <syscall>
  802134:	83 c4 18             	add    $0x18,%esp
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    

00802139 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80213c:	6a 00                	push   $0x0
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	6a 02                	push   $0x2
  802148:	e8 64 ff ff ff       	call   8020b1 <syscall>
  80214d:	83 c4 18             	add    $0x18,%esp
}
  802150:	c9                   	leave  
  802151:	c3                   	ret    

00802152 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802155:	6a 00                	push   $0x0
  802157:	6a 00                	push   $0x0
  802159:	6a 00                	push   $0x0
  80215b:	6a 00                	push   $0x0
  80215d:	6a 00                	push   $0x0
  80215f:	6a 03                	push   $0x3
  802161:	e8 4b ff ff ff       	call   8020b1 <syscall>
  802166:	83 c4 18             	add    $0x18,%esp
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80216e:	6a 00                	push   $0x0
  802170:	6a 00                	push   $0x0
  802172:	6a 00                	push   $0x0
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	6a 04                	push   $0x4
  80217a:	e8 32 ff ff ff       	call   8020b1 <syscall>
  80217f:	83 c4 18             	add    $0x18,%esp
}
  802182:	c9                   	leave  
  802183:	c3                   	ret    

00802184 <sys_env_exit>:


void sys_env_exit(void)
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
	syscall(SYS_env_exit, 0, 0, 0, 0, 0);
  802187:	6a 00                	push   $0x0
  802189:	6a 00                	push   $0x0
  80218b:	6a 00                	push   $0x0
  80218d:	6a 00                	push   $0x0
  80218f:	6a 00                	push   $0x0
  802191:	6a 06                	push   $0x6
  802193:	e8 19 ff ff ff       	call   8020b1 <syscall>
  802198:	83 c4 18             	add    $0x18,%esp
}
  80219b:	90                   	nop
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <__sys_allocate_page>:


int __sys_allocate_page(void *va, int perm)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8021a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 00                	push   $0x0
  8021ad:	52                   	push   %edx
  8021ae:	50                   	push   %eax
  8021af:	6a 07                	push   $0x7
  8021b1:	e8 fb fe ff ff       	call   8020b1 <syscall>
  8021b6:	83 c4 18             	add    $0x18,%esp
}
  8021b9:	c9                   	leave  
  8021ba:	c3                   	ret    

008021bb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	56                   	push   %esi
  8021bf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8021c0:	8b 75 18             	mov    0x18(%ebp),%esi
  8021c3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021c6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	56                   	push   %esi
  8021d0:	53                   	push   %ebx
  8021d1:	51                   	push   %ecx
  8021d2:	52                   	push   %edx
  8021d3:	50                   	push   %eax
  8021d4:	6a 08                	push   $0x8
  8021d6:	e8 d6 fe ff ff       	call   8020b1 <syscall>
  8021db:	83 c4 18             	add    $0x18,%esp
}
  8021de:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021e1:	5b                   	pop    %ebx
  8021e2:	5e                   	pop    %esi
  8021e3:	5d                   	pop    %ebp
  8021e4:	c3                   	ret    

008021e5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8021e5:	55                   	push   %ebp
  8021e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8021e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	6a 00                	push   $0x0
  8021f0:	6a 00                	push   $0x0
  8021f2:	6a 00                	push   $0x0
  8021f4:	52                   	push   %edx
  8021f5:	50                   	push   %eax
  8021f6:	6a 09                	push   $0x9
  8021f8:	e8 b4 fe ff ff       	call   8020b1 <syscall>
  8021fd:	83 c4 18             	add    $0x18,%esp
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802205:	6a 00                	push   $0x0
  802207:	6a 00                	push   $0x0
  802209:	6a 00                	push   $0x0
  80220b:	ff 75 0c             	pushl  0xc(%ebp)
  80220e:	ff 75 08             	pushl  0x8(%ebp)
  802211:	6a 0a                	push   $0xa
  802213:	e8 99 fe ff ff       	call   8020b1 <syscall>
  802218:	83 c4 18             	add    $0x18,%esp
}
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802220:	6a 00                	push   $0x0
  802222:	6a 00                	push   $0x0
  802224:	6a 00                	push   $0x0
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 0b                	push   $0xb
  80222c:	e8 80 fe ff ff       	call   8020b1 <syscall>
  802231:	83 c4 18             	add    $0x18,%esp
}
  802234:	c9                   	leave  
  802235:	c3                   	ret    

00802236 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 00                	push   $0x0
  802243:	6a 0c                	push   $0xc
  802245:	e8 67 fe ff ff       	call   8020b1 <syscall>
  80224a:	83 c4 18             	add    $0x18,%esp
}
  80224d:	c9                   	leave  
  80224e:	c3                   	ret    

0080224f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	6a 00                	push   $0x0
  80225a:	6a 00                	push   $0x0
  80225c:	6a 0d                	push   $0xd
  80225e:	e8 4e fe ff ff       	call   8020b1 <syscall>
  802263:	83 c4 18             	add    $0x18,%esp
}
  802266:	c9                   	leave  
  802267:	c3                   	ret    

00802268 <sys_freeMem>:

void sys_freeMem(uint32 virtual_address, uint32 size)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
	syscall(SYS_freeMem, virtual_address, size, 0, 0, 0);
  80226b:	6a 00                	push   $0x0
  80226d:	6a 00                	push   $0x0
  80226f:	6a 00                	push   $0x0
  802271:	ff 75 0c             	pushl  0xc(%ebp)
  802274:	ff 75 08             	pushl  0x8(%ebp)
  802277:	6a 11                	push   $0x11
  802279:	e8 33 fe ff ff       	call   8020b1 <syscall>
  80227e:	83 c4 18             	add    $0x18,%esp
	return;
  802281:	90                   	nop
}
  802282:	c9                   	leave  
  802283:	c3                   	ret    

00802284 <sys_allocateMem>:

void sys_allocateMem(uint32 virtual_address, uint32 size)
{
  802284:	55                   	push   %ebp
  802285:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocateMem, virtual_address, size, 0, 0, 0);
  802287:	6a 00                	push   $0x0
  802289:	6a 00                	push   $0x0
  80228b:	6a 00                	push   $0x0
  80228d:	ff 75 0c             	pushl  0xc(%ebp)
  802290:	ff 75 08             	pushl  0x8(%ebp)
  802293:	6a 12                	push   $0x12
  802295:	e8 17 fe ff ff       	call   8020b1 <syscall>
  80229a:	83 c4 18             	add    $0x18,%esp
	return ;
  80229d:	90                   	nop
}
  80229e:	c9                   	leave  
  80229f:	c3                   	ret    

008022a0 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8022a3:	6a 00                	push   $0x0
  8022a5:	6a 00                	push   $0x0
  8022a7:	6a 00                	push   $0x0
  8022a9:	6a 00                	push   $0x0
  8022ab:	6a 00                	push   $0x0
  8022ad:	6a 0e                	push   $0xe
  8022af:	e8 fd fd ff ff       	call   8020b1 <syscall>
  8022b4:	83 c4 18             	add    $0x18,%esp
}
  8022b7:	c9                   	leave  
  8022b8:	c3                   	ret    

008022b9 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8022b9:	55                   	push   %ebp
  8022ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	ff 75 08             	pushl  0x8(%ebp)
  8022c7:	6a 0f                	push   $0xf
  8022c9:	e8 e3 fd ff ff       	call   8020b1 <syscall>
  8022ce:	83 c4 18             	add    $0x18,%esp
}
  8022d1:	c9                   	leave  
  8022d2:	c3                   	ret    

008022d3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 00                	push   $0x0
  8022da:	6a 00                	push   $0x0
  8022dc:	6a 00                	push   $0x0
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 10                	push   $0x10
  8022e2:	e8 ca fd ff ff       	call   8020b1 <syscall>
  8022e7:	83 c4 18             	add    $0x18,%esp
}
  8022ea:	90                   	nop
  8022eb:	c9                   	leave  
  8022ec:	c3                   	ret    

008022ed <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8022ed:	55                   	push   %ebp
  8022ee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8022f0:	6a 00                	push   $0x0
  8022f2:	6a 00                	push   $0x0
  8022f4:	6a 00                	push   $0x0
  8022f6:	6a 00                	push   $0x0
  8022f8:	6a 00                	push   $0x0
  8022fa:	6a 14                	push   $0x14
  8022fc:	e8 b0 fd ff ff       	call   8020b1 <syscall>
  802301:	83 c4 18             	add    $0x18,%esp
}
  802304:	90                   	nop
  802305:	c9                   	leave  
  802306:	c3                   	ret    

00802307 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802307:	55                   	push   %ebp
  802308:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80230a:	6a 00                	push   $0x0
  80230c:	6a 00                	push   $0x0
  80230e:	6a 00                	push   $0x0
  802310:	6a 00                	push   $0x0
  802312:	6a 00                	push   $0x0
  802314:	6a 15                	push   $0x15
  802316:	e8 96 fd ff ff       	call   8020b1 <syscall>
  80231b:	83 c4 18             	add    $0x18,%esp
}
  80231e:	90                   	nop
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <sys_cputc>:


void
sys_cputc(const char c)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 04             	sub    $0x4,%esp
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80232d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802331:	6a 00                	push   $0x0
  802333:	6a 00                	push   $0x0
  802335:	6a 00                	push   $0x0
  802337:	6a 00                	push   $0x0
  802339:	50                   	push   %eax
  80233a:	6a 16                	push   $0x16
  80233c:	e8 70 fd ff ff       	call   8020b1 <syscall>
  802341:	83 c4 18             	add    $0x18,%esp
}
  802344:	90                   	nop
  802345:	c9                   	leave  
  802346:	c3                   	ret    

00802347 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802347:	55                   	push   %ebp
  802348:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80234a:	6a 00                	push   $0x0
  80234c:	6a 00                	push   $0x0
  80234e:	6a 00                	push   $0x0
  802350:	6a 00                	push   $0x0
  802352:	6a 00                	push   $0x0
  802354:	6a 17                	push   $0x17
  802356:	e8 56 fd ff ff       	call   8020b1 <syscall>
  80235b:	83 c4 18             	add    $0x18,%esp
}
  80235e:	90                   	nop
  80235f:	c9                   	leave  
  802360:	c3                   	ret    

00802361 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802361:	55                   	push   %ebp
  802362:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	6a 00                	push   $0x0
  802369:	6a 00                	push   $0x0
  80236b:	6a 00                	push   $0x0
  80236d:	ff 75 0c             	pushl  0xc(%ebp)
  802370:	50                   	push   %eax
  802371:	6a 18                	push   $0x18
  802373:	e8 39 fd ff ff       	call   8020b1 <syscall>
  802378:	83 c4 18             	add    $0x18,%esp
}
  80237b:	c9                   	leave  
  80237c:	c3                   	ret    

0080237d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80237d:	55                   	push   %ebp
  80237e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802380:	8b 55 0c             	mov    0xc(%ebp),%edx
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	6a 00                	push   $0x0
  802388:	6a 00                	push   $0x0
  80238a:	6a 00                	push   $0x0
  80238c:	52                   	push   %edx
  80238d:	50                   	push   %eax
  80238e:	6a 1b                	push   $0x1b
  802390:	e8 1c fd ff ff       	call   8020b1 <syscall>
  802395:	83 c4 18             	add    $0x18,%esp
}
  802398:	c9                   	leave  
  802399:	c3                   	ret    

0080239a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80239a:	55                   	push   %ebp
  80239b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80239d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	52                   	push   %edx
  8023aa:	50                   	push   %eax
  8023ab:	6a 19                	push   $0x19
  8023ad:	e8 ff fc ff ff       	call   8020b1 <syscall>
  8023b2:	83 c4 18             	add    $0x18,%esp
}
  8023b5:	90                   	nop
  8023b6:	c9                   	leave  
  8023b7:	c3                   	ret    

008023b8 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8023b8:	55                   	push   %ebp
  8023b9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8023bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023be:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c1:	6a 00                	push   $0x0
  8023c3:	6a 00                	push   $0x0
  8023c5:	6a 00                	push   $0x0
  8023c7:	52                   	push   %edx
  8023c8:	50                   	push   %eax
  8023c9:	6a 1a                	push   $0x1a
  8023cb:	e8 e1 fc ff ff       	call   8020b1 <syscall>
  8023d0:	83 c4 18             	add    $0x18,%esp
}
  8023d3:	90                   	nop
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 04             	sub    $0x4,%esp
  8023dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8023df:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8023e2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8023e5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8023e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ec:	6a 00                	push   $0x0
  8023ee:	51                   	push   %ecx
  8023ef:	52                   	push   %edx
  8023f0:	ff 75 0c             	pushl  0xc(%ebp)
  8023f3:	50                   	push   %eax
  8023f4:	6a 1c                	push   $0x1c
  8023f6:	e8 b6 fc ff ff       	call   8020b1 <syscall>
  8023fb:	83 c4 18             	add    $0x18,%esp
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802403:	8b 55 0c             	mov    0xc(%ebp),%edx
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	6a 00                	push   $0x0
  80240b:	6a 00                	push   $0x0
  80240d:	6a 00                	push   $0x0
  80240f:	52                   	push   %edx
  802410:	50                   	push   %eax
  802411:	6a 1d                	push   $0x1d
  802413:	e8 99 fc ff ff       	call   8020b1 <syscall>
  802418:	83 c4 18             	add    $0x18,%esp
}
  80241b:	c9                   	leave  
  80241c:	c3                   	ret    

0080241d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80241d:	55                   	push   %ebp
  80241e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802420:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802423:	8b 55 0c             	mov    0xc(%ebp),%edx
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	6a 00                	push   $0x0
  80242b:	6a 00                	push   $0x0
  80242d:	51                   	push   %ecx
  80242e:	52                   	push   %edx
  80242f:	50                   	push   %eax
  802430:	6a 1e                	push   $0x1e
  802432:	e8 7a fc ff ff       	call   8020b1 <syscall>
  802437:	83 c4 18             	add    $0x18,%esp
}
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80243f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	6a 00                	push   $0x0
  802447:	6a 00                	push   $0x0
  802449:	6a 00                	push   $0x0
  80244b:	52                   	push   %edx
  80244c:	50                   	push   %eax
  80244d:	6a 1f                	push   $0x1f
  80244f:	e8 5d fc ff ff       	call   8020b1 <syscall>
  802454:	83 c4 18             	add    $0x18,%esp
}
  802457:	c9                   	leave  
  802458:	c3                   	ret    

00802459 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802459:	55                   	push   %ebp
  80245a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 20                	push   $0x20
  802468:	e8 44 fc ff ff       	call   8020b1 <syscall>
  80246d:	83 c4 18             	add    $0x18,%esp
}
  802470:	c9                   	leave  
  802471:	c3                   	ret    

00802472 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802472:	55                   	push   %ebp
  802473:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802475:	8b 45 08             	mov    0x8(%ebp),%eax
  802478:	6a 00                	push   $0x0
  80247a:	ff 75 14             	pushl  0x14(%ebp)
  80247d:	ff 75 10             	pushl  0x10(%ebp)
  802480:	ff 75 0c             	pushl  0xc(%ebp)
  802483:	50                   	push   %eax
  802484:	6a 21                	push   $0x21
  802486:	e8 26 fc ff ff       	call   8020b1 <syscall>
  80248b:	83 c4 18             	add    $0x18,%esp
}
  80248e:	c9                   	leave  
  80248f:	c3                   	ret    

00802490 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802490:	55                   	push   %ebp
  802491:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802493:	8b 45 08             	mov    0x8(%ebp),%eax
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 00                	push   $0x0
  80249c:	6a 00                	push   $0x0
  80249e:	50                   	push   %eax
  80249f:	6a 22                	push   $0x22
  8024a1:	e8 0b fc ff ff       	call   8020b1 <syscall>
  8024a6:	83 c4 18             	add    $0x18,%esp
}
  8024a9:	90                   	nop
  8024aa:	c9                   	leave  
  8024ab:	c3                   	ret    

008024ac <sys_free_env>:

void
sys_free_env(int32 envId)
{
  8024ac:	55                   	push   %ebp
  8024ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_env, (int32)envId, 0, 0, 0, 0);
  8024af:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b2:	6a 00                	push   $0x0
  8024b4:	6a 00                	push   $0x0
  8024b6:	6a 00                	push   $0x0
  8024b8:	6a 00                	push   $0x0
  8024ba:	50                   	push   %eax
  8024bb:	6a 23                	push   $0x23
  8024bd:	e8 ef fb ff ff       	call   8020b1 <syscall>
  8024c2:	83 c4 18             	add    $0x18,%esp
}
  8024c5:	90                   	nop
  8024c6:	c9                   	leave  
  8024c7:	c3                   	ret    

008024c8 <sys_get_virtual_time>:

struct uint64
sys_get_virtual_time()
{
  8024c8:	55                   	push   %ebp
  8024c9:	89 e5                	mov    %esp,%ebp
  8024cb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024ce:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024d1:	8d 50 04             	lea    0x4(%eax),%edx
  8024d4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024d7:	6a 00                	push   $0x0
  8024d9:	6a 00                	push   $0x0
  8024db:	6a 00                	push   $0x0
  8024dd:	52                   	push   %edx
  8024de:	50                   	push   %eax
  8024df:	6a 24                	push   $0x24
  8024e1:	e8 cb fb ff ff       	call   8020b1 <syscall>
  8024e6:	83 c4 18             	add    $0x18,%esp
	return result;
  8024e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024f2:	89 01                	mov    %eax,(%ecx)
  8024f4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fa:	c9                   	leave  
  8024fb:	c2 04 00             	ret    $0x4

008024fe <sys_moveMem>:

// 2014
void sys_moveMem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_moveMem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802501:	6a 00                	push   $0x0
  802503:	6a 00                	push   $0x0
  802505:	ff 75 10             	pushl  0x10(%ebp)
  802508:	ff 75 0c             	pushl  0xc(%ebp)
  80250b:	ff 75 08             	pushl  0x8(%ebp)
  80250e:	6a 13                	push   $0x13
  802510:	e8 9c fb ff ff       	call   8020b1 <syscall>
  802515:	83 c4 18             	add    $0x18,%esp
	return ;
  802518:	90                   	nop
}
  802519:	c9                   	leave  
  80251a:	c3                   	ret    

0080251b <sys_rcr2>:
uint32 sys_rcr2()
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80251e:	6a 00                	push   $0x0
  802520:	6a 00                	push   $0x0
  802522:	6a 00                	push   $0x0
  802524:	6a 00                	push   $0x0
  802526:	6a 00                	push   $0x0
  802528:	6a 25                	push   $0x25
  80252a:	e8 82 fb ff ff       	call   8020b1 <syscall>
  80252f:	83 c4 18             	add    $0x18,%esp
}
  802532:	c9                   	leave  
  802533:	c3                   	ret    

00802534 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802534:	55                   	push   %ebp
  802535:	89 e5                	mov    %esp,%ebp
  802537:	83 ec 04             	sub    $0x4,%esp
  80253a:	8b 45 08             	mov    0x8(%ebp),%eax
  80253d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802540:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802544:	6a 00                	push   $0x0
  802546:	6a 00                	push   $0x0
  802548:	6a 00                	push   $0x0
  80254a:	6a 00                	push   $0x0
  80254c:	50                   	push   %eax
  80254d:	6a 26                	push   $0x26
  80254f:	e8 5d fb ff ff       	call   8020b1 <syscall>
  802554:	83 c4 18             	add    $0x18,%esp
	return ;
  802557:	90                   	nop
}
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <rsttst>:
void rsttst()
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80255d:	6a 00                	push   $0x0
  80255f:	6a 00                	push   $0x0
  802561:	6a 00                	push   $0x0
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 28                	push   $0x28
  802569:	e8 43 fb ff ff       	call   8020b1 <syscall>
  80256e:	83 c4 18             	add    $0x18,%esp
	return ;
  802571:	90                   	nop
}
  802572:	c9                   	leave  
  802573:	c3                   	ret    

00802574 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802574:	55                   	push   %ebp
  802575:	89 e5                	mov    %esp,%ebp
  802577:	83 ec 04             	sub    $0x4,%esp
  80257a:	8b 45 14             	mov    0x14(%ebp),%eax
  80257d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802580:	8b 55 18             	mov    0x18(%ebp),%edx
  802583:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802587:	52                   	push   %edx
  802588:	50                   	push   %eax
  802589:	ff 75 10             	pushl  0x10(%ebp)
  80258c:	ff 75 0c             	pushl  0xc(%ebp)
  80258f:	ff 75 08             	pushl  0x8(%ebp)
  802592:	6a 27                	push   $0x27
  802594:	e8 18 fb ff ff       	call   8020b1 <syscall>
  802599:	83 c4 18             	add    $0x18,%esp
	return ;
  80259c:	90                   	nop
}
  80259d:	c9                   	leave  
  80259e:	c3                   	ret    

0080259f <chktst>:
void chktst(uint32 n)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8025a2:	6a 00                	push   $0x0
  8025a4:	6a 00                	push   $0x0
  8025a6:	6a 00                	push   $0x0
  8025a8:	6a 00                	push   $0x0
  8025aa:	ff 75 08             	pushl  0x8(%ebp)
  8025ad:	6a 29                	push   $0x29
  8025af:	e8 fd fa ff ff       	call   8020b1 <syscall>
  8025b4:	83 c4 18             	add    $0x18,%esp
	return ;
  8025b7:	90                   	nop
}
  8025b8:	c9                   	leave  
  8025b9:	c3                   	ret    

008025ba <inctst>:

void inctst()
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 00                	push   $0x0
  8025c1:	6a 00                	push   $0x0
  8025c3:	6a 00                	push   $0x0
  8025c5:	6a 00                	push   $0x0
  8025c7:	6a 2a                	push   $0x2a
  8025c9:	e8 e3 fa ff ff       	call   8020b1 <syscall>
  8025ce:	83 c4 18             	add    $0x18,%esp
	return ;
  8025d1:	90                   	nop
}
  8025d2:	c9                   	leave  
  8025d3:	c3                   	ret    

008025d4 <gettst>:
uint32 gettst()
{
  8025d4:	55                   	push   %ebp
  8025d5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 00                	push   $0x0
  8025db:	6a 00                	push   $0x0
  8025dd:	6a 00                	push   $0x0
  8025df:	6a 00                	push   $0x0
  8025e1:	6a 2b                	push   $0x2b
  8025e3:	e8 c9 fa ff ff       	call   8020b1 <syscall>
  8025e8:	83 c4 18             	add    $0x18,%esp
}
  8025eb:	c9                   	leave  
  8025ec:	c3                   	ret    

008025ed <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025ed:	55                   	push   %ebp
  8025ee:	89 e5                	mov    %esp,%ebp
  8025f0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 00                	push   $0x0
  8025f7:	6a 00                	push   $0x0
  8025f9:	6a 00                	push   $0x0
  8025fb:	6a 00                	push   $0x0
  8025fd:	6a 2c                	push   $0x2c
  8025ff:	e8 ad fa ff ff       	call   8020b1 <syscall>
  802604:	83 c4 18             	add    $0x18,%esp
  802607:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80260a:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80260e:	75 07                	jne    802617 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802610:	b8 01 00 00 00       	mov    $0x1,%eax
  802615:	eb 05                	jmp    80261c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802617:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261c:	c9                   	leave  
  80261d:	c3                   	ret    

0080261e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80261e:	55                   	push   %ebp
  80261f:	89 e5                	mov    %esp,%ebp
  802621:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802624:	6a 00                	push   $0x0
  802626:	6a 00                	push   $0x0
  802628:	6a 00                	push   $0x0
  80262a:	6a 00                	push   $0x0
  80262c:	6a 00                	push   $0x0
  80262e:	6a 2c                	push   $0x2c
  802630:	e8 7c fa ff ff       	call   8020b1 <syscall>
  802635:	83 c4 18             	add    $0x18,%esp
  802638:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80263b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80263f:	75 07                	jne    802648 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802641:	b8 01 00 00 00       	mov    $0x1,%eax
  802646:	eb 05                	jmp    80264d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802648:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264d:	c9                   	leave  
  80264e:	c3                   	ret    

0080264f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80264f:	55                   	push   %ebp
  802650:	89 e5                	mov    %esp,%ebp
  802652:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802655:	6a 00                	push   $0x0
  802657:	6a 00                	push   $0x0
  802659:	6a 00                	push   $0x0
  80265b:	6a 00                	push   $0x0
  80265d:	6a 00                	push   $0x0
  80265f:	6a 2c                	push   $0x2c
  802661:	e8 4b fa ff ff       	call   8020b1 <syscall>
  802666:	83 c4 18             	add    $0x18,%esp
  802669:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80266c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802670:	75 07                	jne    802679 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802672:	b8 01 00 00 00       	mov    $0x1,%eax
  802677:	eb 05                	jmp    80267e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802679:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80267e:	c9                   	leave  
  80267f:	c3                   	ret    

00802680 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
  802683:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802686:	6a 00                	push   $0x0
  802688:	6a 00                	push   $0x0
  80268a:	6a 00                	push   $0x0
  80268c:	6a 00                	push   $0x0
  80268e:	6a 00                	push   $0x0
  802690:	6a 2c                	push   $0x2c
  802692:	e8 1a fa ff ff       	call   8020b1 <syscall>
  802697:	83 c4 18             	add    $0x18,%esp
  80269a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80269d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8026a1:	75 07                	jne    8026aa <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8026a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a8:	eb 05                	jmp    8026af <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026af:	c9                   	leave  
  8026b0:	c3                   	ret    

008026b1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026b4:	6a 00                	push   $0x0
  8026b6:	6a 00                	push   $0x0
  8026b8:	6a 00                	push   $0x0
  8026ba:	6a 00                	push   $0x0
  8026bc:	ff 75 08             	pushl  0x8(%ebp)
  8026bf:	6a 2d                	push   $0x2d
  8026c1:	e8 eb f9 ff ff       	call   8020b1 <syscall>
  8026c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c9:	90                   	nop
}
  8026ca:	c9                   	leave  
  8026cb:	c3                   	ret    

008026cc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026cc:	55                   	push   %ebp
  8026cd:	89 e5                	mov    %esp,%ebp
  8026cf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026d0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dc:	6a 00                	push   $0x0
  8026de:	53                   	push   %ebx
  8026df:	51                   	push   %ecx
  8026e0:	52                   	push   %edx
  8026e1:	50                   	push   %eax
  8026e2:	6a 2e                	push   $0x2e
  8026e4:	e8 c8 f9 ff ff       	call   8020b1 <syscall>
  8026e9:	83 c4 18             	add    $0x18,%esp
}
  8026ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	6a 00                	push   $0x0
  8026fc:	6a 00                	push   $0x0
  8026fe:	6a 00                	push   $0x0
  802700:	52                   	push   %edx
  802701:	50                   	push   %eax
  802702:	6a 2f                	push   $0x2f
  802704:	e8 a8 f9 ff ff       	call   8020b1 <syscall>
  802709:	83 c4 18             	add    $0x18,%esp
}
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    
  80270e:	66 90                	xchg   %ax,%ax

00802710 <__udivdi3>:
  802710:	55                   	push   %ebp
  802711:	57                   	push   %edi
  802712:	56                   	push   %esi
  802713:	53                   	push   %ebx
  802714:	83 ec 1c             	sub    $0x1c,%esp
  802717:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80271b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80271f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802723:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802727:	89 ca                	mov    %ecx,%edx
  802729:	89 f8                	mov    %edi,%eax
  80272b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80272f:	85 f6                	test   %esi,%esi
  802731:	75 2d                	jne    802760 <__udivdi3+0x50>
  802733:	39 cf                	cmp    %ecx,%edi
  802735:	77 65                	ja     80279c <__udivdi3+0x8c>
  802737:	89 fd                	mov    %edi,%ebp
  802739:	85 ff                	test   %edi,%edi
  80273b:	75 0b                	jne    802748 <__udivdi3+0x38>
  80273d:	b8 01 00 00 00       	mov    $0x1,%eax
  802742:	31 d2                	xor    %edx,%edx
  802744:	f7 f7                	div    %edi
  802746:	89 c5                	mov    %eax,%ebp
  802748:	31 d2                	xor    %edx,%edx
  80274a:	89 c8                	mov    %ecx,%eax
  80274c:	f7 f5                	div    %ebp
  80274e:	89 c1                	mov    %eax,%ecx
  802750:	89 d8                	mov    %ebx,%eax
  802752:	f7 f5                	div    %ebp
  802754:	89 cf                	mov    %ecx,%edi
  802756:	89 fa                	mov    %edi,%edx
  802758:	83 c4 1c             	add    $0x1c,%esp
  80275b:	5b                   	pop    %ebx
  80275c:	5e                   	pop    %esi
  80275d:	5f                   	pop    %edi
  80275e:	5d                   	pop    %ebp
  80275f:	c3                   	ret    
  802760:	39 ce                	cmp    %ecx,%esi
  802762:	77 28                	ja     80278c <__udivdi3+0x7c>
  802764:	0f bd fe             	bsr    %esi,%edi
  802767:	83 f7 1f             	xor    $0x1f,%edi
  80276a:	75 40                	jne    8027ac <__udivdi3+0x9c>
  80276c:	39 ce                	cmp    %ecx,%esi
  80276e:	72 0a                	jb     80277a <__udivdi3+0x6a>
  802770:	3b 44 24 08          	cmp    0x8(%esp),%eax
  802774:	0f 87 9e 00 00 00    	ja     802818 <__udivdi3+0x108>
  80277a:	b8 01 00 00 00       	mov    $0x1,%eax
  80277f:	89 fa                	mov    %edi,%edx
  802781:	83 c4 1c             	add    $0x1c,%esp
  802784:	5b                   	pop    %ebx
  802785:	5e                   	pop    %esi
  802786:	5f                   	pop    %edi
  802787:	5d                   	pop    %ebp
  802788:	c3                   	ret    
  802789:	8d 76 00             	lea    0x0(%esi),%esi
  80278c:	31 ff                	xor    %edi,%edi
  80278e:	31 c0                	xor    %eax,%eax
  802790:	89 fa                	mov    %edi,%edx
  802792:	83 c4 1c             	add    $0x1c,%esp
  802795:	5b                   	pop    %ebx
  802796:	5e                   	pop    %esi
  802797:	5f                   	pop    %edi
  802798:	5d                   	pop    %ebp
  802799:	c3                   	ret    
  80279a:	66 90                	xchg   %ax,%ax
  80279c:	89 d8                	mov    %ebx,%eax
  80279e:	f7 f7                	div    %edi
  8027a0:	31 ff                	xor    %edi,%edi
  8027a2:	89 fa                	mov    %edi,%edx
  8027a4:	83 c4 1c             	add    $0x1c,%esp
  8027a7:	5b                   	pop    %ebx
  8027a8:	5e                   	pop    %esi
  8027a9:	5f                   	pop    %edi
  8027aa:	5d                   	pop    %ebp
  8027ab:	c3                   	ret    
  8027ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8027b1:	89 eb                	mov    %ebp,%ebx
  8027b3:	29 fb                	sub    %edi,%ebx
  8027b5:	89 f9                	mov    %edi,%ecx
  8027b7:	d3 e6                	shl    %cl,%esi
  8027b9:	89 c5                	mov    %eax,%ebp
  8027bb:	88 d9                	mov    %bl,%cl
  8027bd:	d3 ed                	shr    %cl,%ebp
  8027bf:	89 e9                	mov    %ebp,%ecx
  8027c1:	09 f1                	or     %esi,%ecx
  8027c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8027c7:	89 f9                	mov    %edi,%ecx
  8027c9:	d3 e0                	shl    %cl,%eax
  8027cb:	89 c5                	mov    %eax,%ebp
  8027cd:	89 d6                	mov    %edx,%esi
  8027cf:	88 d9                	mov    %bl,%cl
  8027d1:	d3 ee                	shr    %cl,%esi
  8027d3:	89 f9                	mov    %edi,%ecx
  8027d5:	d3 e2                	shl    %cl,%edx
  8027d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8027db:	88 d9                	mov    %bl,%cl
  8027dd:	d3 e8                	shr    %cl,%eax
  8027df:	09 c2                	or     %eax,%edx
  8027e1:	89 d0                	mov    %edx,%eax
  8027e3:	89 f2                	mov    %esi,%edx
  8027e5:	f7 74 24 0c          	divl   0xc(%esp)
  8027e9:	89 d6                	mov    %edx,%esi
  8027eb:	89 c3                	mov    %eax,%ebx
  8027ed:	f7 e5                	mul    %ebp
  8027ef:	39 d6                	cmp    %edx,%esi
  8027f1:	72 19                	jb     80280c <__udivdi3+0xfc>
  8027f3:	74 0b                	je     802800 <__udivdi3+0xf0>
  8027f5:	89 d8                	mov    %ebx,%eax
  8027f7:	31 ff                	xor    %edi,%edi
  8027f9:	e9 58 ff ff ff       	jmp    802756 <__udivdi3+0x46>
  8027fe:	66 90                	xchg   %ax,%ax
  802800:	8b 54 24 08          	mov    0x8(%esp),%edx
  802804:	89 f9                	mov    %edi,%ecx
  802806:	d3 e2                	shl    %cl,%edx
  802808:	39 c2                	cmp    %eax,%edx
  80280a:	73 e9                	jae    8027f5 <__udivdi3+0xe5>
  80280c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80280f:	31 ff                	xor    %edi,%edi
  802811:	e9 40 ff ff ff       	jmp    802756 <__udivdi3+0x46>
  802816:	66 90                	xchg   %ax,%ax
  802818:	31 c0                	xor    %eax,%eax
  80281a:	e9 37 ff ff ff       	jmp    802756 <__udivdi3+0x46>
  80281f:	90                   	nop

00802820 <__umoddi3>:
  802820:	55                   	push   %ebp
  802821:	57                   	push   %edi
  802822:	56                   	push   %esi
  802823:	53                   	push   %ebx
  802824:	83 ec 1c             	sub    $0x1c,%esp
  802827:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80282b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80282f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802833:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802837:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80283b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80283f:	89 f3                	mov    %esi,%ebx
  802841:	89 fa                	mov    %edi,%edx
  802843:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802847:	89 34 24             	mov    %esi,(%esp)
  80284a:	85 c0                	test   %eax,%eax
  80284c:	75 1a                	jne    802868 <__umoddi3+0x48>
  80284e:	39 f7                	cmp    %esi,%edi
  802850:	0f 86 a2 00 00 00    	jbe    8028f8 <__umoddi3+0xd8>
  802856:	89 c8                	mov    %ecx,%eax
  802858:	89 f2                	mov    %esi,%edx
  80285a:	f7 f7                	div    %edi
  80285c:	89 d0                	mov    %edx,%eax
  80285e:	31 d2                	xor    %edx,%edx
  802860:	83 c4 1c             	add    $0x1c,%esp
  802863:	5b                   	pop    %ebx
  802864:	5e                   	pop    %esi
  802865:	5f                   	pop    %edi
  802866:	5d                   	pop    %ebp
  802867:	c3                   	ret    
  802868:	39 f0                	cmp    %esi,%eax
  80286a:	0f 87 ac 00 00 00    	ja     80291c <__umoddi3+0xfc>
  802870:	0f bd e8             	bsr    %eax,%ebp
  802873:	83 f5 1f             	xor    $0x1f,%ebp
  802876:	0f 84 ac 00 00 00    	je     802928 <__umoddi3+0x108>
  80287c:	bf 20 00 00 00       	mov    $0x20,%edi
  802881:	29 ef                	sub    %ebp,%edi
  802883:	89 fe                	mov    %edi,%esi
  802885:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802889:	89 e9                	mov    %ebp,%ecx
  80288b:	d3 e0                	shl    %cl,%eax
  80288d:	89 d7                	mov    %edx,%edi
  80288f:	89 f1                	mov    %esi,%ecx
  802891:	d3 ef                	shr    %cl,%edi
  802893:	09 c7                	or     %eax,%edi
  802895:	89 e9                	mov    %ebp,%ecx
  802897:	d3 e2                	shl    %cl,%edx
  802899:	89 14 24             	mov    %edx,(%esp)
  80289c:	89 d8                	mov    %ebx,%eax
  80289e:	d3 e0                	shl    %cl,%eax
  8028a0:	89 c2                	mov    %eax,%edx
  8028a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028a6:	d3 e0                	shl    %cl,%eax
  8028a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8028b0:	89 f1                	mov    %esi,%ecx
  8028b2:	d3 e8                	shr    %cl,%eax
  8028b4:	09 d0                	or     %edx,%eax
  8028b6:	d3 eb                	shr    %cl,%ebx
  8028b8:	89 da                	mov    %ebx,%edx
  8028ba:	f7 f7                	div    %edi
  8028bc:	89 d3                	mov    %edx,%ebx
  8028be:	f7 24 24             	mull   (%esp)
  8028c1:	89 c6                	mov    %eax,%esi
  8028c3:	89 d1                	mov    %edx,%ecx
  8028c5:	39 d3                	cmp    %edx,%ebx
  8028c7:	0f 82 87 00 00 00    	jb     802954 <__umoddi3+0x134>
  8028cd:	0f 84 91 00 00 00    	je     802964 <__umoddi3+0x144>
  8028d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8028d7:	29 f2                	sub    %esi,%edx
  8028d9:	19 cb                	sbb    %ecx,%ebx
  8028db:	89 d8                	mov    %ebx,%eax
  8028dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8028e1:	d3 e0                	shl    %cl,%eax
  8028e3:	89 e9                	mov    %ebp,%ecx
  8028e5:	d3 ea                	shr    %cl,%edx
  8028e7:	09 d0                	or     %edx,%eax
  8028e9:	89 e9                	mov    %ebp,%ecx
  8028eb:	d3 eb                	shr    %cl,%ebx
  8028ed:	89 da                	mov    %ebx,%edx
  8028ef:	83 c4 1c             	add    $0x1c,%esp
  8028f2:	5b                   	pop    %ebx
  8028f3:	5e                   	pop    %esi
  8028f4:	5f                   	pop    %edi
  8028f5:	5d                   	pop    %ebp
  8028f6:	c3                   	ret    
  8028f7:	90                   	nop
  8028f8:	89 fd                	mov    %edi,%ebp
  8028fa:	85 ff                	test   %edi,%edi
  8028fc:	75 0b                	jne    802909 <__umoddi3+0xe9>
  8028fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802903:	31 d2                	xor    %edx,%edx
  802905:	f7 f7                	div    %edi
  802907:	89 c5                	mov    %eax,%ebp
  802909:	89 f0                	mov    %esi,%eax
  80290b:	31 d2                	xor    %edx,%edx
  80290d:	f7 f5                	div    %ebp
  80290f:	89 c8                	mov    %ecx,%eax
  802911:	f7 f5                	div    %ebp
  802913:	89 d0                	mov    %edx,%eax
  802915:	e9 44 ff ff ff       	jmp    80285e <__umoddi3+0x3e>
  80291a:	66 90                	xchg   %ax,%ax
  80291c:	89 c8                	mov    %ecx,%eax
  80291e:	89 f2                	mov    %esi,%edx
  802920:	83 c4 1c             	add    $0x1c,%esp
  802923:	5b                   	pop    %ebx
  802924:	5e                   	pop    %esi
  802925:	5f                   	pop    %edi
  802926:	5d                   	pop    %ebp
  802927:	c3                   	ret    
  802928:	3b 04 24             	cmp    (%esp),%eax
  80292b:	72 06                	jb     802933 <__umoddi3+0x113>
  80292d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802931:	77 0f                	ja     802942 <__umoddi3+0x122>
  802933:	89 f2                	mov    %esi,%edx
  802935:	29 f9                	sub    %edi,%ecx
  802937:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80293b:	89 14 24             	mov    %edx,(%esp)
  80293e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802942:	8b 44 24 04          	mov    0x4(%esp),%eax
  802946:	8b 14 24             	mov    (%esp),%edx
  802949:	83 c4 1c             	add    $0x1c,%esp
  80294c:	5b                   	pop    %ebx
  80294d:	5e                   	pop    %esi
  80294e:	5f                   	pop    %edi
  80294f:	5d                   	pop    %ebp
  802950:	c3                   	ret    
  802951:	8d 76 00             	lea    0x0(%esi),%esi
  802954:	2b 04 24             	sub    (%esp),%eax
  802957:	19 fa                	sbb    %edi,%edx
  802959:	89 d1                	mov    %edx,%ecx
  80295b:	89 c6                	mov    %eax,%esi
  80295d:	e9 71 ff ff ff       	jmp    8028d3 <__umoddi3+0xb3>
  802962:	66 90                	xchg   %ax,%ax
  802964:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802968:	72 ea                	jb     802954 <__umoddi3+0x134>
  80296a:	89 d9                	mov    %ebx,%ecx
  80296c:	e9 62 ff ff ff       	jmp    8028d3 <__umoddi3+0xb3>
